import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ScreenShootModel {
  @Id()
  int? id;
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? type; //mainPage,subPage,dialog,menu,submenu,rightMenu
  String? status; //passed,finished,deleted,created
  final sceneParts = ToMany<ScenePartModel>();
}
