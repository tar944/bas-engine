import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ViewObjectsViewModel extends ViewModel {
  final controller = PageController();
  int curImage = 0;
  final double dlgW, dlgH;
  final int showObjectId;
  final List<ObjectModel> allObjects;
  final List<ImageGroupModel> subGroups;
  List<ObjectModel> subObjects = [];

  ViewObjectsViewModel(
      this.dlgW, this.dlgH, this.subGroups, this.allObjects, this.showObjectId);

  @override
  void onMount() {
    curImage = allObjects.indexWhere((element) => element.id == showObjectId);
    subObjects=findSubObjects(subGroups, 0, 0);
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

  List<ObjectModel> findSubObjects(List<ImageGroupModel> subGroups, double startX, double startY) {
    List<ObjectModel> allSubs = [];
    print("===================================");
    for (var grp in subGroups) {
      double offsetX = 0, offsetY = 0;
      if (grp.mainState.target != null && grp.label.target != null && grp.label.target!.levelName == "objects") {
        var obj = ObjectModel(
            grp.allStates[0].id,
            grp.allStates[0].uuid,
            grp.allStates[0].left+startX,
            grp.allStates[0].right+startX,
            grp.allStates[0].top+startY,
            grp.allStates[0].bottom+startY
        );
        allSubs.add(obj);
      } else if (grp.mainState.target != null && grp.label.target != null) {
        if (grp.mainState.target!.left == 0 && grp.mainState.target!.top == 0) {
          offsetX = startX + grp.mainState.target!.srcObject.target!.left;
          offsetY = startY + grp.mainState.target!.srcObject.target!.top;
        } else {
          offsetX = startX + grp.mainState.target!.left;
          offsetY = startY + grp.mainState.target!.top;
        }
        allSubs.addAll(findSubObjects(grp.allGroups, offsetX, offsetY));
      }
    }
    return allSubs;
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
