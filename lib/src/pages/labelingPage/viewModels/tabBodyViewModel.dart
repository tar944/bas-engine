import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class TabBodyViewModel extends ViewModel {

  List<LabelModel> allLabels;
  final String lvlName;
  String actValue="choseAction";
  final ValueSetter<String> onActionCaller;
  var ctlTitle = TextEditingController();

  TabBodyViewModel(this.allLabels,this.lvlName, this.onActionCaller);

  onComboBoxChangedHandler(String newValue){
    actValue=newValue;
    notifyListeners();
  }

  onSaveHandler(){
    if(ctlTitle.text==""){
      Toast(Strings.emptyNameError, false).showWarning(context);
      return;
    }
    if(lvlName=="objects"&&actValue=="choseAction"){
      Toast(Strings.emptyActionError, false).showWarning(context);
      return;
    }
    onActionCaller('create&&${ctlTitle.text}${lvlName=="objects"?"&&$actValue":""}');
    actValue="choseAction";
    ctlTitle.text="";
    notifyListeners();
  }
}