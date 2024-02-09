import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class VideoModel {
  @Id()
  int id;
  String uuid="";
  String prjUUID;
  String? name;
  String path;
  String thumbnailPath;
  String? time;
  final  allImages= ToMany<ImageModel>();
  final project = ToOne<ProjectModel>();

  VideoModel(this.id,this.prjUUID, this.name,this.thumbnailPath, this.path, this.time);
}