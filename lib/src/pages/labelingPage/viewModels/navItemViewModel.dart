import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/navModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class NavItemViewModel extends ViewModel {

  final NavModel navItem;
  final String selectStatus;
  final bool showAddBtn;
  int curShape=0;
  ValueSetter<NavModel> onItemSelectedCaller;
  ValueSetter<NavModel> onAddNewShapeCaller;

  NavItemViewModel(this.navItem,this.selectStatus,this.showAddBtn,this.onItemSelectedCaller,this.onAddNewShapeCaller);
  onNextShapeHandler(){
    if(curShape<navItem.otherShapes.length-1){
      curShape++;
      notifyListeners();
    }
  }
  onPreviousShapeHandler(){
    if(curShape>0){
      curShape--;
      notifyListeners();
    }
  }
}