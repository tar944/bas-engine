import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expObjectModel.dart';

class ExpGroupModel {

  String uuid;
  String partUUID;
  String groupUUID;
  String mainStateUUID;
  String name;
  String type;
  String state;
  List<String> navObjects;
  List<ExpObjectModel> allStates;
  List<ExpObjectModel> subObjects;
  List<ExpGroupModel> allGroups;
  List<ExpGroupModel> otherShapes;
  String labelUUID;

  ExpGroupModel(
      this.uuid,
      this.partUUID,
      this.groupUUID,
      this.name,
      this.mainStateUUID,
      this.type,
      this.state,
      this.labelUUID,
      this.navObjects,
      this.allGroups,
      this.otherShapes,
      this.subObjects,
      this.allStates
      );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['partUUID'] = partUUID;
    data['groupUUID'] = groupUUID;
    data['name'] = name;
    data['type'] = type;
    data['state'] = state;
    data['mainStateUUID']=mainStateUUID;
    data['navObjects'] = navObjects.map((v) => v).toList();

    if (allStates.isNotEmpty) {
      data['allStates'] = allStates.map((v) => v.toJson()).toList();
    }
    if (subObjects.isNotEmpty) {
      data['subObjects'] = subObjects.map((v) => v.toJson()).toList();
    }
    if (allGroups.isNotEmpty) {
      data['allGroups'] = allGroups.map((v) => v.toJson()).toList();
    }
    if (otherShapes.isNotEmpty) {
      data['otherShapes'] = otherShapes.map((v) => v.toJson()).toList();
    }
    data['labelUUID'] = labelUUID;
    return data;
  }
}
