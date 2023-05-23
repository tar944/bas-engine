import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ScreenShootModel {
  @Id()
  int? id;
  int? hashDifference;
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? type; //mainPage,subPage,dialog,menu,submenu,rightMenu
  String? status; //passed,finished,deleted,created
  final video = ToOne<VideoModel>();
  final sceneParts = ToMany<ScenePartModel>();

  ScreenShootModel(this.id, this.hashDifference, this.imageName, this.path, this.status);
}
