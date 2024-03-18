import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLabelingManagement.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class LabelingBodyViewModel extends ViewModel {
  List<ObjectModel> objects;
  List<ImageGroupModel> subGroups=[];
  ImageGroupModel? curGroup;
  String prjUUID,grpUUID,partUUID;
  LabelModel curLabel=LabelModel(-1, "", "");

  LabelingBodyViewModel(this.objects,this.grpUUID,this.partUUID,this.prjUUID);

  @override
  void init() async{
    if(partUUID!=""){
      var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
      subGroups=part!.allGroups;
    }else{
      var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
      subGroups=grp!.allGroups;
    }
    notifyListeners();
  }

  onLabelActionHandler(String action)async{
    var act = action.split("&&");
    switch(act[0]){
      case "showDialog":
        var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgLabelManagement(
                labelList: prj!.allLabels,
                prjUUID: prjUUID,
                onActionCaller: onLabelActionHandler,
              ),
        );
        break;
      case "saveName":
        var newGroup = ImageGroupModel(-1,partUUID,grpUUID , act[2], "");
        newGroup.uuid=const Uuid().v4();
        var lbl=await LabelDAO().getLabel(int.parse(act[1]));
        newGroup.label.target=lbl;
        await ImageGroupDAO().add(newGroup);
        newGroup = (await ImageGroupDAO().getDetailsByUUID(newGroup.uuid))!;
        if(partUUID!=""){
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          part!.allGroups.add(newGroup);
          await ProjectPartDAO().update(part);
        }else{
          var grp =await ImageGroupDAO().getDetailsByUUID(grpUUID);
          grp!.allGroups.add(newGroup);
          await ImageGroupDAO().update(grp);
        }
        subGroups.add(newGroup);
        notifyListeners();
        break;
      case "remove":
        var grp = await ImageGroupDAO().getDetails(int.parse(act[1]));
        if(grp!.allGroups.isEmpty&&grp.subObjects.isEmpty){
          await ImageGroupDAO().delete(grp);
          subGroups.removeWhere((element) => element.id==grp.id);
          notifyListeners();
        }else{
          Toast(Strings.errRemoveGroup, false).showWarning(context);
        }
        break;
    }
  }

  int getLabelObjectNumber(LabelModel lbl){
    return 0;
  }

  onObjectActionHandler(String action)async{
    var act = action.split("&&");
    switch (act[0]) {
      case 'gotoCutToPieces':
        // final curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
        // final curPart = await ProjectPartDAO().getDetails(partId);
        // await Preference().setMainAddress('${curProject!.id}&&${curPart!.id}&&${curGroup!.id}');
        // context.goNamed('cutToPieces',params: {
        //   'objId':action.split('&&')[1],
        //   'groupId':curGroup!.id.toString(),
        //   'partUUID':partUUID,
        //   'prjUUID':prjUUID,
        //   'title': '${curProject.title} > ${curPart.name} > ${curGroup!.name}'
        // });
        break;
      case 'addToGroup':
        var obj = await ObjectDAO().getDetails(int.parse(act[2]));
        if(grpUUID==""){
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          await ProjectPartDAO().removeObject(part!.id, obj!);
          await ImageGroupDAO().addObject(int.parse(act[1]), obj);
        }else{
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          await ImageGroupDAO().removeObject(grp!.id, obj!);
          await ImageGroupDAO().addObject(int.parse(act[1]), obj);
        }
        subGroups[subGroups.indexWhere((element) => element.id==int.parse(act[1]))].subObjects.add(obj);
        notifyListeners();
        break;
      case 'removeFromGroup':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[2]));
        // await ProjectPartDAO().addObject(partId, obj!);
        // await ImageGroupDAO().removeObject(int.parse(action.split("&&")[1]), obj);
        subGroups[subGroups.indexWhere((element) => element.id==int.parse(act[1]))].subObjects.removeWhere((element) => element.id==obj!.id);
        // updateProjectData(curGroup.id);
        break;
      case 'delete':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[1]));
        await ObjectDAO().deleteObject(obj!);
        objects.remove(obj);
        notifyListeners();
        break;

    }
  }

}