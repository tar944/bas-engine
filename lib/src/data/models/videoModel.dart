import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VideoModel {
  @Id()
  int id;
  String? name;
  String? path;
  String? time;
  final  screenShoots= ToMany<ScreenShootModel>();
  final  software= ToOne<SoftwareModel>();

  VideoModel(this.id, this.name, this.path, this.time);
}