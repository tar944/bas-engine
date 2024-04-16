import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ImageGroupModel {
  @Id()
  int id;
  String uuid="";
  String partUUID;
  String groupUUID;
  String? name;
  String type="";
  String state=GroupState.findMainState.name;
  final navObjects = ToMany<ObjectModel>();
  final mainState = ToOne<ObjectModel>();
  final allStates = ToMany<ObjectModel>();
  final subObjects = ToMany<ObjectModel>();
  final allGroups = ToMany<ImageGroupModel>();
  final label = ToOne<LabelModel>();

  ImageGroupModel(this.id,this.partUUID,this.groupUUID, this.name);


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['partUUID'] = partUUID;
    data['groupUUID'] = groupUUID;
    data['name'] = name;
    data['type'] = type;
    data['state'] = state;
    if (navObjects.isNotEmpty) {
      data['navObjects'] = navObjects.map((v) => v.toJson()).toList();
    }
    if (mainState.target!=null) {
      data['mainState'] = mainState.target!.toJson();
    }
    if (allStates.isNotEmpty) {
      data['allStates'] = allStates.map((v) => v.toJson()).toList();
    }
    if (subObjects.isNotEmpty) {
      data['subObjects'] = subObjects.map((v) => v.toJson()).toList();
    }
    if (allGroups.isNotEmpty) {
      data['allGroups'] = allGroups.map((v) => v.toJson()).toList();
    }
    if (label.target!=null) {
      data['label'] = label.target!.toJson();
    }
    return data;
  }
}
