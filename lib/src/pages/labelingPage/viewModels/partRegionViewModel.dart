import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:pmvvm/pmvvm.dart';

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
}