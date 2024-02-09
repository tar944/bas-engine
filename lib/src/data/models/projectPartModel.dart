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
}