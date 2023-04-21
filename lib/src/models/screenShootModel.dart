import 'package:bas_dataset_generator_engine/src/models/scenePartModel.dart';

import '../utility/enum.dart';

class ScreenShootModel {
  String? id, imageName,path,description,label;
  late PageType type;
  late ImageStatus status;
  late List<ScenePartModel> sceneParts;
}
