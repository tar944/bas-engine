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
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgViewObjects.dart';
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
  List<ImageGroupModel> subGroups = [];
  List<ImageGroupModel> otherShapes = [];
  ImageGroupModel? curGroup;
  GroupState tagLineState = GroupState.none;
  String prjUUID, grpUUID, partUUID;
  final int partId;
  int labelGroupId = -1, deletedObjId = -1, imgW = 0, imgH = 0;
  double progressValue = -1;
  bool isLoading = false, isState = true;
  LabelModel curLabel = LabelModel(-1, "", "", "", "");
  ValueSetter<String> onGroupActionCaller;

  LabelingBodyViewModel(
      this.objects,
      this.grpUUID,
      this.partId,
      this.partUUID,
      this.prjUUID,
      this.onGroupActionCaller);

  @override
  void init() async {
    await updateData();
  }

  @override
  void onMount() async {
    if (grpUUID != "") {
      var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
      var part = await ProjectPartDAO().getDetails(partId);
      if (grp!.state == GroupState.editOtherStates.name) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => DlgCheckOtherState(
                  srcObject: grp.mainState.target!,
                  allObjects: grp.allStates
                      .where((element) => element.needToCompare == true)
                      .toList(),
                  grpID: grp.id,
                  prjUUID: prjUUID,
                  partUUID: part!.uuid,
                  onUpdateCaller: () => updateData(),
                ));
      } else if (grp.state == GroupState.finishCutting.name) {
        isLoading = true;
        notifyListeners();
        ImageGroupModel? newGrp;
        final img =
            await i.decodeImageFile(grp.mainState.target!.image.target!.path!);
        imgH = img!.height;
        imgW = img.width;
        while (grp.subObjects.isNotEmpty) {
          var curSub = grp.subObjects[0];
          newGrp = ImageGroupModel(-1, "", grp.uuid, Strings.emptyStr);
          newGrp.uuid = const Uuid().v4();
          newGrp.state = GroupState.generated.name;
          await ImageGroupDAO().add(newGrp);
          newGrp = await ImageGroupDAO().getDetailsByUUID(newGrp.uuid);
          newGrp!.allStates.add(curSub);
          await ImageGroupDAO().update(newGrp);
          grp.subObjects.removeWhere((element) => element.id == curSub.id);
          grp.allGroups.add(newGrp);
          await ImageGroupDAO().update(grp);
          //ready to compare images
          var srcImg = i.decodeImage(
            File(
              curSub.image.target!.path!,
            ).readAsBytesSync(),
          );
          for (var curState in grp.allStates) {
            if (curSub.srcObject.targetId != curState.id) {
              var curImg = await getCroppedImage(curSub, curState);
              var imgDiff = DiffImage.compareFromMemory(srcImg!, curImg!, asPercentage: true).diffValue;
              print("${curSub.image.target!.name} compare to=> ${curState.image.target!.name!} image diff: $imgDiff");
              if (imgDiff > 0.8) {
                var obj = ObjectModel(
                  -1,
                  const Uuid().v4(),
                  curSub.left,
                  curSub.right,
                  curSub.top,
                  curSub.bottom,
                );
                obj.srcObject.target = curState;
                final path = await DirectoryManager()
                    .getObjectImagePath(prjUUID, part!.uuid);
                int w =
                    (curSub.right.toInt() - curSub.left.toInt()).abs().toInt();
                int h = (curSub.bottom.toInt() - curSub.top.toInt());
                final cmd = i.Command()
                  ..decodeImageFile(curState.image.target!.path!)
                  ..copyCrop(
                      x: curSub.left.toInt(),
                      y: curSub.top.toInt(),
                      width: w,
                      height: h)
                  ..writeToFile(path);
                await cmd.executeThread();
                var img = ImageModel(-1, const Uuid().v4(), obj.uuid, p.basename(path), w.toDouble(), h.toDouble(), path);
                img.id = await ImageDAO().add(img);
                obj.image.target = img;
                obj.id = await ObjectDAO().addObject(obj);
                newGrp.allStates.add(obj);
                await ImageGroupDAO().update(newGrp);
              }
            }
          }
          if (newGrp.allStates.length == 1) {
            newGrp.mainState.target = newGrp.allStates[0];
            newGrp.allStates[0].isMainObject = true;
            await ObjectDAO().update(newGrp.allStates[0]);
            await ImageGroupDAO().update(newGrp);
          }
        }
        grp.state = GroupState.readyToWork.name;
        await ImageGroupDAO().update(grp);
        isLoading = false;
        await updateData();
      }
    }
  }

  updateData() async {
    if (partUUID != "") {
      var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
      subGroups = part!.allGroups;
      otherShapes = [];
      isState = false;
    } else {
      var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
      subGroups = grp!.allGroups;
      otherShapes= grp.otherShapes;
      tagLineState = GroupState.values.firstWhere((element) => element.name == grp.state);
    }
    notifyListeners();
  }

  Future<i.Image?> getCroppedImage(ObjectModel subObj, ObjectModel srcObj) async {
    final cmd = i.Command()
      ..decodeImageFile(srcObj.image.target!.path!)
      ..copyCrop(
          x: subObj.left.toInt(),
          y: subObj.top.toInt(),
          width: subObj.image.target!.width.toInt(),
          height: subObj.image.target!.height.toInt())
      ..encodeJpg();
    await cmd.executeThread();
    return cmd.outputImage;
  }

  findSimilarImages(List<ObjectModel> allObjects) async {
    isLoading = true;
    progressValue = 0.0;
    notifyListeners();
    var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
    var allSize = allObjects.length;
    while (allObjects.length > 1) {
      print("all objects length is > ${allObjects.length}");
      progressValue = ((allSize - allObjects.length) * 100) / allSize;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 10));
      var simObjects = <ObjectModel>[];
      var curObject = allObjects[0];
      allObjects.removeAt(0);
      simObjects.add(curObject);
      final srcImg = i.decodeImage(
        File(curObject.image.target!.path!).readAsBytesSync(),
      );
      var j = 0;
      while (j < allObjects.length) {
        final curImg = i.decodeImage(
          File(allObjects[j].image.target!.path!).readAsBytesSync(),
        );
        var imgDiff =
            DiffImage.compareFromMemory(srcImg!, curImg!, asPercentage: true)
                .diffValue;
        print("${j + 1} of ${allObjects.length}: ${curObject.image.target!.name} compare to=> ${allObjects[j].image.target!.name!} image diff: $imgDiff");
        if (imgDiff < 5) {
          simObjects.add(allObjects[j]);
          allObjects.removeAt(j);
          j--;
        }
        j++;
      }
      if (simObjects.length > 1) {
        var newGrp = ImageGroupModel(-1, partUUID, '', Strings.emptyStr);
        newGrp.uuid = const Uuid().v4();
        newGrp.state = GroupState.generated.name;
        newGrp.id = await ImageGroupDAO().add(newGrp);
        await ProjectPartDAO().addGroup(part!.id, newGrp);
        for (var obj in simObjects) {
          await ImageGroupDAO().addObject(newGrp.id, obj);
          await ProjectPartDAO().removeObject(part.id, obj);
        }
      }
    }
    isLoading = false;
    progressValue = -1;
    updateData();
  }

  onLabelActionHandler(String action) async {
    var act = action.split("&&");
    switch (act[0]) {
      case "findSimilar":
        await findSimilarImages(objects);
        break;
      case "showStates":
        isState = true;
        var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
        objects = grp!.allStates;
        notifyListeners();
        break;
      case "showSubs":
        isState = false;
        var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
        objects = grp!.subObjects;
        notifyListeners();
        break;
      case "open":
        onGroupActionCaller(action);
        break;
      case "choose":
        curGroup = await ImageGroupDAO().getDetails(int.parse(act[1]));
        objects = curGroup!.allStates;
        isState = false;
        notifyListeners();
        break;
      case "labelIt":
        labelGroupId = int.parse(act[1]);
        gotoLabelingDialog(act[0]);
        break;
      case "showDialog":
        gotoLabelingDialog(act[0]);
        break;
      case "editGroup":
        labelGroupId = int.parse(act[1]);
        gotoLabelingDialog("labelIt");
        break;
      case "removeGroup":
        var grp = await ImageGroupDAO().getDetails(int.parse(act[1]));
        if (grpUUID != "") {
          var parGroup = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          for (var obj in grp!.allStates) {
            obj.isMainObject = false;
            await ObjectDAO().update(obj);
            parGroup!.subObjects.add(obj);
          }
          await ImageGroupDAO().update(parGroup!);
          objects = parGroup.subObjects;
        }
        await ImageGroupDAO().delete(grp!);
        subGroups.removeWhere((element) => element.id == grp.id);
        notifyListeners();
        break;
      case "saveName":
        var newGroup = ImageGroupModel(-1, partUUID, grpUUID, act[2]);
        newGroup.uuid = const Uuid().v4();
        var lbl = await LabelDAO().getLabel(int.parse(act[1]));
        newGroup.label.target = lbl;
        await ImageGroupDAO().add(newGroup);
        newGroup = (await ImageGroupDAO().getDetailsByUUID(newGroup.uuid))!;
        if (partUUID != "") {
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          part!.allGroups.add(newGroup);
          await ProjectPartDAO().update(part);
        } else {
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          grp!.allGroups.add(newGroup);
          await ImageGroupDAO().update(grp);
        }
        subGroups.add(newGroup);
        notifyListeners();
        break;
      case "changeName":
        var grp = await ImageGroupDAO().getDetails(labelGroupId);
        labelGroupId = -1;
        var lbl = await LabelDAO().getLabel(int.parse(act[1]));
        if (grp!.mainState.target == null && lbl!.levelName == "objects") {
          grp.mainState.target = grp.allStates[0];
          grp.allStates[0].isMainObject = true;
          await ObjectDAO().update(grp.allStates[0]);
        }
        grp.name = act[2];
        grp.label.target = lbl;
        grp.state = grp.mainState.target == null
            ? GroupState.findMainState.name
            : GroupState.findSubObjects.name;
        await ImageGroupDAO().update(grp);
        if (grpUUID != "") {
          grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          subGroups = grp!.allGroups;
          otherShapes = grp.otherShapes;
        } else {
          final part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          subGroups = part!.allGroups;
          otherShapes = [];
        }
        notifyListeners();
        break;
      case "remove":
        var grp = await ImageGroupDAO().getDetails(int.parse(act[1]));
        if (grp!.allStates.isEmpty) {
          await ImageGroupDAO().delete(grp);
          subGroups.removeWhere((element) => element.id == grp.id);
          notifyListeners();
        } else {
          Toast(Strings.errRemoveGroup, false).showWarning(context);
        }
        break;
    }
  }

  gotoLabelingDialog(String act) async {
    var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => DlgLabelManagement(
        labelList: prj!.allLabels,
        prjUUID: prjUUID,
        returnAction: act == "showDialog" ? 'saveName' : 'changeName',
        onActionCaller: onLabelActionHandler,
      ),
    );
  }

  onObjectActionHandler(String action) async {
    var act = action.split("&&");
    switch (act[0]) {
      case 'goToCuttingPage':
      case 'setMainState':
        onGroupActionCaller(action);
        break;
      case 'addToGroup':
        var obj = await ObjectDAO().getDetails(int.parse(act[2]));
        await ImageGroupDAO().addObject(int.parse(act[1]), obj!);
        if (grpUUID == "") {
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          await ProjectPartDAO().removeObject(part!.id, obj);
        } else {
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          if (isState) {
            await ImageGroupDAO().removeObject(grp!.id, obj);
          } else {
            await ImageGroupDAO().removeSubObject(grp!.id, obj);
            objects.removeWhere((element) => element.id == obj.id);
            notifyListeners();
          }
        }
        subGroups[subGroups
                .indexWhere((element) => element.id == int.parse(act[1]))]
            .allStates
            .add(obj);
        notifyListeners();
        break;
      case 'removeFromGroup':
        var obj =
            await ObjectDAO().getDetails(int.parse(action.split("&&")[2]));
        if (partUUID == "") {
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          await ImageGroupDAO().addSubObject(grp!.id, obj!);
          await ImageGroupDAO().removeObject(int.parse(act[1]), obj);
        } else {
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          await ProjectPartDAO().addObject(part!.id, obj!);
          await ImageGroupDAO().removeObject(int.parse(act[1]), obj);
        }
        subGroups[subGroups.indexWhere((element) => element.id == int.parse(act[1]))].allStates.removeWhere((element) => element.id == obj.id);
        notifyListeners();
        break;
      case 'delete':
        var obj =
            await ObjectDAO().getDetails(int.parse(action.split("&&")[1]));
        if (grpUUID != "" && obj!.isMainObject) {
          var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
          grp!.state = GroupState.findMainState.name;
          await ImageGroupDAO().update(grp);
        }
        await ObjectDAO().deleteObject(obj!);
        objects.removeWhere((element) => element.id == obj.id);
        notifyListeners();
        break;
      case "setItMain":
        var obj = await ObjectDAO().getDetails(int.parse(act[1]));
        final img = await i.decodeImageFile(obj!.image.target!.path!);
        var newObject = ObjectModel(-1, const Uuid().v4(), 0.0, img!.width.toDouble(), 0.0, img.height.toDouble());
        newObject.srcObject.target = obj;
        newObject.image.target = obj.image.target;
        newObject.isMainObject = true;
        newObject.id = await ObjectDAO().addObject(newObject);
        var grp = await ImageGroupDAO().getDetailsByUUID(grpUUID);
        await ImageGroupDAO().addMainState(grp!.id, newObject);
        onMount();
        break;
      case "showImg":
        var obj = await ObjectDAO().getDetails(int.parse(act[1]));
        List<ImageGroupModel> subGroups=[];
        bool showSubObjects=false;
        if(grpUUID!=""){
          var grp=await ImageGroupDAO().getDetailsByUUID(grpUUID);
          subGroups = grp!.allGroups;
          otherShapes = grp.otherShapes;
          showSubObjects=grp.label.target!=null&&grp.label.target!.levelName=="windows"?true:false;
        }else{
          var part = await ProjectPartDAO().getDetailsByUUID(partUUID);
          subGroups = part!.allGroups;
          otherShapes =[];
        }
        final img = await i.decodeImageFile(obj!.image.target!.path!);
        double mediaW = MediaQuery.sizeOf(context).width;
        double mediaH = MediaQuery.sizeOf(context).height;
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => DlgViewObjects(
            dlgW: img!.width > (mediaW * 0.9) ? (mediaW * 0.9).toDouble() : img.width.toDouble(),
            dlgH: img.width > (mediaW * 0.9) ? (mediaH * 0.9).toDouble() : img.height.toDouble(),
            allObjects: objects,
            grpUUID: grpUUID,
            showSubObjects: showSubObjects,
            subGroups: subGroups,
            showObjectId: int.parse(act[1]),
            onActionCaller: onObjectActionHandler,
          ),
        );
        break;
    }
  }
}
