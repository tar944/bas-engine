import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelManageItemViewModel extends ViewModel {

  final LabelModel label;
  bool isEditMode=false;
  final ValueSetter<String> onActionCaller;
  final controller = FlyoutController();
  TextEditingController? ctlTitle ;

  LabelManageItemViewModel(this.label, this.onActionCaller);

  @override
  void init() {
    ctlTitle= TextEditingController(text: label.name);
  }

  onEditBtnHandler(){
    if(isEditMode){
      onActionCaller('edit&&${label.id}&&${ctlTitle!.text.toString()}');
      isEditMode=false;
    }else{
      isEditMode=true;
    }
    notifyListeners();
  }

}