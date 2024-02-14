import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ObjectItemViewModel extends ViewModel {

  final ObjectModel object;
  final bool isSubGroup;
  final List<ImageGroupModel> allGroups;
  final ValueSetter<String> onActionCaller;

  ObjectItemViewModel(this.isSubGroup,this.allGroups,this.object, this.onActionCaller);

  onGroupSelected(List<int> allSelected,int curSelectedItem){
    if(isSubGroup){
      onActionCaller("removeFromGroup&&$curSelectedItem&&${object.id}");
    }else{
      onActionCaller("addToGroup&&$curSelectedItem&&${object.id}");
    }
  }
}