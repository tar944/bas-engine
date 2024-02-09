import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ProjectModel {
  @Id()
  int id;
  String uuid;
  String? title;
  String? companyId;
  String? companyName;
  String? description;
  String? icon;
  String? companyLogo;
  final  allVideos= ToMany<VideoModel>();
  final  allParts= ToMany<ProjectPartModel>();

  ProjectModel(
      this.id,
      this.uuid,
      this.title,
      this.companyId,
      this.companyName,
      this.description,
      this.icon,
      this.companyLogo);
}
