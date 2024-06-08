import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image/image.dart' as i;
import 'package:pmvvm/pmvvm.dart';

class ViewObjectsViewModel extends ViewModel {
  final controller = PageController();
  int curImage = 0,imgW=0,imgH=0;
  final double dlgW, dlgH;
  final String grpUUID;
  final int showObjectId;
  final List<ObjectModel> allObjects;
  final List<ImageGroupModel> subGroups;
  final bool showSubObjects;
  List<ObjectModel> subObjects = [];

  ViewObjectsViewModel(
      this.grpUUID,
      this.dlgW,
      this.dlgH,
      this.subGroups,
      this.showSubObjects,
      this.allObjects,
      this.showObjectId);


  @override
  void init() {
    curImage = allObjects.indexWhere((element) => element.id == showObjectId);
    notifyListeners();
  }

  @override
  void onMount() async{
    final img = await i.decodeImageFile(allObjects[curImage].image.target!.path!);
    imgH = img!.height;
    imgW = img.width;
    if(showSubObjects) {
      subObjects=findSubObjects(subGroups, 0, 0);
    }
    controller.jumpToPage(curImage);
    notifyListeners();
  }

  nextImage() {
    if (curImage < allObjects.length - 1) {
      curImage += 1;
      subObjects=findSubObjects(subGroups, 0, 0);
      controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
      notifyListeners();
    }
  }

  onRemoveHandler()async{
    var obj = allObjects[curImage];
    if(grpUUID!=""&&obj.isMainObject){
      var grp=await ImageGroupDAO().getDetailsByUUID(grpUUID);
      grp!.state=GroupState.findMainState.name;
      await ImageGroupDAO().update(grp);
    }
    await ObjectDAO().deleteObject(obj);
    allObjects.removeAt(curImage);
    if(curImage == allObjects.length){
      curImage--;
    }
    notifyListeners();
  }

  List<ObjectModel> findSubObjects(List<ImageGroupModel> subGroups, double startX, double startY) {
    List<ObjectModel> allSubs = [];
    for (var grp in subGroups) {
      double offsetX = 0, offsetY = 0;
      if (grp.mainState.target != null && grp.label.target != null && grp.label.target!.levelName == "objects") {
        var obj = ObjectModel(
            grp.allStates[0].id,
            grp.allStates[0].uuid,
            getX(grp.allStates[0].left.toInt())+startX,
            getX(grp.allStates[0].right.toInt())+startX,
            getY(grp.allStates[0].top.toInt())+startY,
            getY(grp.allStates[0].bottom.toInt())+startY
        );
        obj.isNavTool=grp.allStates[0].isNavTool;
        allSubs.add(obj);
      } else if (grp.mainState.target != null && grp.label.target != null) {
        if (grp.mainState.target!.left == 0 && grp.mainState.target!.top == 0) {
          offsetX = startX + grp.mainState.target!.srcObject.target!.left;
          offsetY = startY + grp.mainState.target!.srcObject.target!.top;
        } else {
          offsetX = getX((startX + grp.mainState.target!.left).toInt()).toDouble();
          offsetY = getY((startY + grp.mainState.target!.top).toInt()).toDouble();
        }
        allSubs.addAll(findSubObjects(grp.allGroups, offsetX, offsetY));
      }
    }
    return allSubs;
  }

  int getY(int y) {
    var curH = dlgH;
    if (imgH > curH) {
      return (y * curH) ~/ imgH;
    } else {
      return y;
    }
  }

  int getX(int x) {
    var curW=dlgW;
    if (imgW > curW) {
      return (x * curW) ~/ imgW;
    } else {
      return x;
    }
  }

  actionBtnHandler(String action) async {
    nextImage();
  }

  previousImage() async {
    if (curImage > 0) {
      curImage -= 1;
      subObjects=findSubObjects(subGroups, 0, 0);
      controller.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate);
      notifyListeners();
    }
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}
