import 'package:bas_dataset_generator_engine/src/data/models/actionModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
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
  String? status; //finished,created
  final video = ToOne<VideoModel>();
  final group = ToOne<RecordedScreenGroup>();
  final action = ToOne<ActionModel>();
  final partsList = ToMany<RegionDataModel>();

  ScreenShootModel(this.id, this.hashDifference, this.imageName, this.path, this.status);
}
