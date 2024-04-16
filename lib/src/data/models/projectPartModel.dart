import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProjectPartModel {
  @Id()
  int id;
  String uuid;
  String prjUUID;
  String? name;
  String? description;
  String path;
  final allGroups= ToMany<ImageGroupModel>();
  final allObjects= ToMany<ObjectModel>();

  ProjectPartModel(this.id,this.prjUUID,this.uuid, this.name,this.path,this.description);


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