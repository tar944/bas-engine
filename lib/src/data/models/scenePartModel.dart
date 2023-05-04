import 'package:bas_dataset_generator_engine/src/data/models/partObjectModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ScenePartModel {
  @Id()
  int? id;
  double? left;
  double? right;
  double? top;
  double? bottom;
  String? color; //red blue grey white orange purple green black
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? status; //passed,finished,deleted,created
  final partObjects = ToMany<PartObjectModel>();
}
