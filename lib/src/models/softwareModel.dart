import 'package:bas_dataset_generator_engine/src/models/videoModel.dart';

class SoftwareModel {
  String? id, title, companyId, companyName, description, icon, companyLogo;
  late List<VideoModel> videos;

  SoftwareModel(this.id, this.title, this.companyId, this.companyName,
      this.description, this.icon, this.companyLogo);
}
