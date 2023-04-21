import 'package:bas_dataset_generator_engine/src/models/partObjectModel.dart';

import '../utility/enum.dart';

class ScenePartModel {
  String? id, imageName,path,description,label;
  late ImageStatus status;
  late List<PartObjectModel> partObjects;
}