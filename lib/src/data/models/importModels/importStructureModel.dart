
import 'package:bas_dataset_generator_engine/src/data/models/importModels/objectStructureModel.dart';

class ImportStructureModel {

  List<ObjectStructureModel>? allObjects=[];

  ImportStructureModel({this.allObjects});

  ImportStructureModel.fromJson(Map<String, dynamic> json) {
    if (json['allObjects'] != null) {
      allObjects = <ObjectStructureModel>[];
      json['allObjects'].forEach((v) {
        allObjects!.add(ObjectStructureModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allObjects'] =allObjects!=null&&allObjects!.isNotEmpty? allObjects!.map((v) => v.toJson()).toList():[];
    return data;
  }
}