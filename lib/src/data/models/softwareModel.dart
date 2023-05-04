import 'package:bas_dataset_generator_engine/src/data/models/videoModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SoftwareModel {
  @Id()
  int id;
  String? title;
  String? companyId;
  String? companyName;
  String? description;
  String? icon;
  String? companyLogo;
  final  allVideos= ToMany<VideoModel>();

  SoftwareModel(this.id, this.title, this.companyId, this.companyName,
      this.description, this.icon, this.companyLogo);
}
