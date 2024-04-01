import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class TabBodyViewModel extends ViewModel {

  final List<LabelModel> allLabels;
  final String lvlName;
  String actValue="choseAction";
  final ValueSetter<String> onActionCaller;
  var ctlTitle = TextEditingController();

  TabBodyViewModel(this.allLabels,this.lvlName, this.onActionCaller);

  onComboBoxChangedHandler(String newValue){
    actValue=newValue;
    notifyListeners();
  }
}