
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';

class VideoModel {
  String? id, name, path, time;
  late List<ScreenShootModel> screenShoots;

  VideoModel(this.id, this.name, this.path, this.time, this.screenShoots);
}
