import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class PartRegionViewModel extends ViewModel {

  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  ObjectModel? curObject;
  final ValueSetter<ObjectModel> onNewObjectHandler;

  double left = 0.0,top =0.0,right = 0.0,bottom = 0.0;
  bool isPainting = false;

  PartRegionViewModel(this.otherObjects,this.itsObjects, this.onNewObjectHandler);
  onNewRectangleHandler(ObjectModel newObject) async {
    onNewObjectHandler(newObject);
  }
  onObjectClickHandler(ObjectModel obj){
    curObject = obj;
    notifyListeners();
  }
  pointerDownHandler(e){
    top = e.localPosition.dy;
    bottom = e.localPosition.dy;
    left = e.localPosition.dx;
    right = e.localPosition.dx;
    isPainting = true;
    notifyListeners();
  }
  pointerMoveHandler(e){

    if (isPainting) {
      right = e.localPosition.dx;
      bottom = e.localPosition.dy;
      notifyListeners();
    }
  }
  pointerHoverHandler(e){
    print(e.localPosition.dx);
    print(e.localPosition.dy);
  }
  pointerUpHandler(e){
    isPainting = false;
    final part = ObjectModel(
        0,
        const Uuid().v4(),
        right > left ? left : right,
        right > left ? right : left,
        top > bottom ? bottom : top,
        top > bottom ? top : bottom,
        ""
    );
    onNewObjectHandler(part);
    top = 0.0;
    left = 0.0;
    right = 0.0;
    bottom = 0.0;
    notifyListeners();
  }
}