import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/projectPartPage/views/dlgProjectPart.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class ProjectPartsViewModel extends ViewModel {
  List<ProjectPartModel> parts = [];
  int prjID;
  String prjUUID = "";
  ValueSetter<int> onPartActionCaller;

  ProjectPartsViewModel(this.prjID, this.onPartActionCaller);

  @override
  void init() async {
    var prj = await ProjectDAO().getDetails(prjID);
    prjUUID = prj!.uuid;
    updateProjectData();
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
        Navigator.pop(context);
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
            ObjectModel obj = ObjectModel(-1, 0, 0, 0, 0, 'created');
            obj.actionType = "notSet";
            obj.actX = -1;
            obj.actY = -1;
            var img = ImageModel(-1, const Uuid().v4(), obj.uuid,
                path.basename(p.path!), imgPath);
            img.id = await ImageDAO().add(img);
            obj.image.target = img;
            obj.id = await ObjectDAO().addObject(obj);
            await ProjectPartDAO().addObject(part.id, obj);
          }
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

  void onEditPartHandler(ProjectPartModel curPart) async {
    await ProjectPartDAO().update(curPart);
    updateProjectData();
  }

  void onCreateProjectHandler(ProjectPartModel curPart) async {
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
              onSaveCaller: onCreateProjectHandler,
              prjUUID: prjUUID,
            ));
  }
}
