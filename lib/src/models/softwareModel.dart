import 'package:bas_dataset_generator_engine/src/models/screenShootModel.dart';

class SoftwareModel {
  String? id, title, companyId, companyName, description, icon, companyLogo;
  late List<ScreenShootModel> screenShoots;

  SoftwareModel(this.id, this.title, this.companyId, this.companyName,
      this.description, this.icon, this.companyLogo);
}
