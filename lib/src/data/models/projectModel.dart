import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
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
  final  allLabels= ToMany<LabelModel>();

  ProjectModel(
      this.id,
      this.uuid,
      this.title,
      this.companyId,
      this.companyName,
      this.description,
      this.icon,
      this.companyLogo);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['title'] = title;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['description'] = description;
    if (allParts.isNotEmpty) {
      data['allParts'] = allParts.map((v) => v.toJson()).toList();
    }
    if (allLabels.isNotEmpty) {
      data['allLabels'] = allLabels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
