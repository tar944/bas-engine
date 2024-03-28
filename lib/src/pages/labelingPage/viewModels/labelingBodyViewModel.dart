import 'dart:io';

import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgCheckOtherState.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgLabelingManagement.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;
import 'package:diff_image2/diff_image2.dart';

class LabelingBodyViewModel extends ViewModel {
  List<ObjectModel> objects;
  List<ImageGroupModel> subGroups=[];
  ImageGroupModel? curGroup;
  GroupState tagLineState=GroupState.none;
  String prjUUID,grpUUID,partUUID;
  final int partId;
  bool isLoading=false;
  LabelModel curLabel=LabelModel(-1, "", "");
  ValueSetter<String> onGroupActionCaller;

  LabelingBodyViewModel(
      this.objects,
      this.grpUUID,
      this.partId,
      this.partUUID,
      this.prjUUID,
      this.onGroupActionCaller);


  @override
  void init() async{
    if(partUUID!=""){
      var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
      subGroups=part!.allGroups;
    }else{
      var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
      subGroups=grp!.allGroups;
      tagLineState=GroupState.values.firstWhere((element) => element.name==grp.state);
    }
    notifyListeners();
  }


  @override
  void onMount() async{
    if(grpUUID!=""){
      var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
      var part = await ProjectPartDAO().getDetails(partId);
      if(grp!.state==GroupState.editOtherStates.name){
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) =>
                DlgCheckOtherState(
                  srcObject:grp.mainState.target!,
                  allObjects:grp.allStates.where((element) => element.srcObject.target==null).toList(),
                  grpID: grp.id,
                  prjUUID: prjUUID,
                  partUUID: part!.uuid,
                ));
      }else if(grp.state==GroupState.finishCutting.name){
        isLoading=true;
        notifyListeners();
        ImageGroupModel? newGrp;
        for(var curSub in grp.subObjects){
          newGrp=null;
          var srcImg = i.decodeImage(File(curSub.image.target!.path!,).readAsBytesSync(),);
          for(var curState in grp.allStates){
            var curImg = await getCroppedImage(curSub, curState);
            var imgDiff = DiffImage.compareFromMemory(srcImg!, curImg!).diffValue;
            if(imgDiff>0.1){
              var obj = ObjectModel(-1, const Uuid().v4(), curSub.left, curSub.right, curSub.top, curSub.bottom);
              obj.srcObject.target=curState;
              final path = await DirectoryManager().getObjectImagePath(prjUUID, part!.uuid);
              final cmd = i.Command()
                ..decodeImageFile(curState.image.target!.path!)
                ..copyCrop(
                    x: curSub.left.toInt(),
                    y: curSub.top.toInt(),
                    width: (curSub.right.toInt() - curSub.left.toInt()).abs().toInt(),
                    height: (curSub.bottom.toInt() - curSub.top.toInt()))
                ..writeToFile(path);
              await cmd.executeThread();
              var img = ImageModel(-1, const Uuid().v4(), obj.uuid, p.basename(path), path);
              img.id =await ImageDAO().add(img);
              obj.image.target=img;
              obj.id=await ObjectDAO().addObject(obj);
              if(newGrp==null){
                newGrp= ImageGroupModel(-1, "", grp.uuid,Strings.emptyStr, "");
                newGrp.uuid= const Uuid().v4();
                newGrp.state= GroupState.generated.name;
                newGrp.id= await ImageGroupDAO().add(newGrp);
                grp.allGroups.add(newGrp);
                await ImageGroupDAO().update(grp);
              }
              await ImageGroupDAO().addSubObject(newGrp.id, obj);
            }
          }
        }
        grp.state=GroupState.readyToWork.name;
        await ImageGroupDAO().update(grp);
        isLoading=false;
        notifyListeners();
      }
    }
  }

  Future<i.Image?> getCroppedImage(ObjectModel srcObject,ObjectModel obj)async{
    final cmd = i.Command()
      ..decodeImageFile(obj.image.target!.path!)
      ..copyCrop(
          x: srcObject.left.toInt(),
          y: srcObject.top.toInt(),
          width: (srcObject.right.toInt() - srcObject.left.toInt()).abs().toInt(),
          height: (srcObject.bottom.toInt() - srcObject.top.toInt()))
      ..encodeJpg();
    await cmd.executeThread();
    return cmd.outputImage;
  }

  onLabelActionHandler(String action)async{
    var act = action.split("&&");
    switch(act[0]){
      case "open":
        onGroupActionCaller(action);
        break;
      case "showAll":
        curGroup= null;
        if(partUUID!=""){
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          objects=part!.allObjects;
        }else{
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          objects=grp!.allStates;
        }
        notifyListeners();
        break;
      case "choose":
        curGroup= await ImageGroupDAO().getDetails(int.parse(act[1]));
        objects=curGroup!.allStates;
        notifyListeners();
        break;
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
      case 'goToCuttingPage':
      case 'setMainState':
        onGroupActionCaller(action);
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
        subGroups[subGroups.indexWhere((element) => element.id==int.parse(act[1]))].allStates.add(obj);
        notifyListeners();
        break;
      case 'removeFromGroup':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[2]));
        if(partUUID==""){
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          await ImageGroupDAO().addObject(grp!.id, obj!);
          await ImageGroupDAO().removeObject(int.parse(act[1]), obj);
        }else{
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          await ProjectPartDAO().addObject(part!.id, obj!);
          await ImageGroupDAO().removeObject(int.parse(act[1]), obj);
        }
        subGroups[subGroups.indexWhere((element) => element.id==int.parse(act[1]))].allStates.removeWhere((element) => element.id==obj.id);
        notifyListeners();
        break;
      case 'delete':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[1]));
        await ObjectDAO().deleteObject(obj!);
        objects.removeWhere((element) => element.id==obj.id);
        notifyListeners();
        break;

    }
  }
}