import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expObjectModel.dart';

class ExpPartModel {
  String uuid;
  String prjUUID;
  String? name;
  String? description;
  String path;
  List<ExpGroupModel> allGroups;
  List<ExpObjectModel> allObjects;

  ExpPartModel(
      this.prjUUID,
      this.uuid,
      this.name,
      this.path,
      this.description,
      this.allGroups,
      this.allObjects
      );


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['prjUUID'] = prjUUID;
    data['name'] = name;
    data['description'] = description;
    data['path'] = path;
    if (allGroups.isNotEmpty) {
      data['allGroups'] = allGroups.map((v) => v.toJson()).toList();
    }
    if (allObjects.isNotEmpty) {
      data['allObjects'] = allObjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}