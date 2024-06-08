import 'package:archive/archive_io.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/importModels/importStructureModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPartPage/views/dlgProjectPart.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as i;
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class ProjectPartsViewModel extends ViewModel {
  List<ProjectPartModel> parts = [];
  int prjID;
  double importedValue=0.0;
  String prjUUID = "";
  bool needLoading = false;
  ValueSetter<int> onPartActionCaller;

  ProjectPartsViewModel(this.prjID, this.onPartActionCaller);

  @override
  void init() async {
    var prj = await ProjectDAO().getDetails(prjID);
    prjUUID = prj!.uuid;
    updateProjectData();
    final address = await Preference().getMainAddress();
    if(address!=''){
      onPartSelect('goto&&${address.split("&&")[1]}');
    }
    //todo this part of code should remove after running one time
    for(var lbl in prj.allLabels){
      if(lbl.uuid==""){
        lbl.uuid=const Uuid().v4();
        await LabelDAO().updateLabel(lbl);
      }
    }
  }

  updateProjectData() async {
    parts = await ProjectDAO().getAllParts(prjID);
    notifyListeners();
  }

  void onPartSelect(String action) async {
    ProjectPartModel? part =
        await ProjectPartDAO().getDetails(int.parse(action.split('&&')[1]));
    switch (action.split('&&')[0]) {
      case 'edit':
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => DlgProjectPart(
            onSaveCaller: onEditPartHandler,
            part: part,
            prjUUID: prjUUID,
          ),
        );
        break;
      case 'record':
        context.goNamed('recordScreens', params: {'partId': part!.id.toString()});
        break;
      case 'chooseImages':
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.image,
            dialogTitle: Strings.chooseImages);
        if (result != null) {
          for (var p in result.files) {
            var imgPath = await DirectoryManager().copyFile(
                p.path!,
                path.join(
                    await DirectoryManager()
                        .getPartImageDirectoryPath(part!.prjUUID, part.uuid),
                    path.basename(p.path!)));
            ObjectModel obj = ObjectModel(-1,const Uuid().v4(), 0, 0, 0, 0);
            obj.actionType = "notSet";
            obj.actX = -1;
            obj.actY = -1;
            final importedImg = await i.decodeImageFile(imgPath);
            var img = ImageModel(-1, const Uuid().v4(), obj.uuid,
                path.basename(p.path!),importedImg!.width.toDouble(),importedImg.height.toDouble(), imgPath);
            img.id = await ImageDAO().add(img);
            obj.image.target = img;
            obj.id = await ObjectDAO().addObject(obj);
            await ProjectPartDAO().addObject(part.id, obj);
          }
        }
        break;
      case 'importZip':
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.any,
            dialogTitle: Strings.chooseZipFile);
        if (result != null) {
          needLoading = true;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 10));
          await importZipFile(result.files[0].path!, part!.uuid);
          needLoading=false;
          updateProjectData();
        }
        break;
      case 'delete':
        await ProjectPartDAO().delete(part!);
        await ProjectDAO().removeAPart(prjID, part);
        onPartActionCaller(-1);
        updateProjectData();
        break;
      case 'goto':
        onPartActionCaller(part!.id);
        break;
    }
  }

  Future<bool> importZipFile(String filePath,String partUUID) async {
    filePath=await DirectoryManager().copyFile(filePath, path.join(await DirectoryManager().getPartDir(prjUUID, partUUID),'DFGE_${getRandomString(10)}.zip'));
    String dirPath = filePath.replaceAll('.zip', '');
    await extractFileToDisk(filePath, dirPath);
    Map<String, dynamic> json = await DirectoryManager().readJsonFile(path.join(dirPath, "exportData.json"));

    var importData = ImportStructureModel.fromJson(json);
    var curPart = await ProjectPartDAO().getDetailsByUUID(partUUID);

    for(var obj in importData.allObjects!){
      importedValue= (100*importData.allObjects!.indexOf(obj))/importData.allObjects!.length;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 10));
      var imgPath=await DirectoryManager().copyFile(path.join(dirPath,obj.image!.path), path.join(await DirectoryManager().getPartImageDirectoryPath(prjUUID, partUUID),obj.image!.name));
      ObjectModel newObj = ObjectModel(-1,obj.uuid!, 0, 0, 0, 0);
      newObj.actionType = obj.actionType!;
      var img =ImageModel(-1, obj.image!.uuid!, newObj.uuid, obj.image!.name,obj.image!.width!,obj.image!.height!, imgPath);
      img.id= await ImageDAO().add(img);
      newObj.actX=obj.actX!;
      newObj.actY=obj.actY!;
      newObj.image.target=img;
      newObj.id=await ObjectDAO().addObject(newObj);
      await ProjectPartDAO().addObject(curPart!.id, newObj);
    }
    return true;
  }


  void onEditPartHandler(ProjectPartModel curPart) async {
    await ProjectPartDAO().update(curPart);
    updateProjectData();
  }

  void onCreatePartHandler(ProjectPartModel curPart) async {
    curPart.id = await ProjectPartDAO().add(curPart);
    await ProjectDAO().addAPart(prjID, curPart);
    await DirectoryManager().createPartDir(curPart.prjUUID, curPart.uuid);
    onPartActionCaller(-1);
    updateProjectData();
  }

  createPart() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => DlgProjectPart(
              onSaveCaller: onCreatePartHandler,
              prjUUID: prjUUID,
            ));
  }
}
