import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavItemViewModel extends ViewModel {

  final NavModel navItem;
  final String selectStatus;
  final bool showAddBtn;
  ValueSetter<NavModel> onItemSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;
  ValueSetter<NavModel> onSelectShapeCaller;



  NavItemViewModel(
      this.navItem,
      this.selectStatus,
      this.showAddBtn,
      this.onItemSelectedCaller,
      this.onAddNewShapeCaller,
      this.onSelectShapeCaller);

  onNextShapeHandler(){
    if(navItem.shapeIndex<navItem.otherShapes.length){
      navItem.shapeIndex++;
      onSelectShapeCaller(navItem);
    }
  }
  onPreviousShapeHandler(){
    if(navItem.shapeIndex>0){
      navItem.shapeIndex--;
      onSelectShapeCaller(navItem);
    }
  }
  String getName(){
    String name="";
    if(navItem.otherShapes[navItem.shapeIndex].name==""){
      name= navItem.otherShapes[navItem.shapeIndex].label.target!.name;
    }else{
      name= navItem.otherShapes[navItem.shapeIndex].name!;
    }
    return name.length>12?"${name.substring(0,12)}...":name;
  }
}