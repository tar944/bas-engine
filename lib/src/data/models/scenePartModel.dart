import 'package:bas_dataset_generator_engine/src/data/models/partObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ScenePartModel {
  @Id()
  int? id;
  double left;
  double right;
  double top;
  double bottom;
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? type; //menuBar,contentTabBar,statusBar,optionBox,toolsBar,toolsPallet,menu,submenu,rightClick
  String? status; //finished,created
  final screen = ToOne<ScreenShootModel>();
  final partObjects = ToMany<PartObjectModel>();

  ScenePartModel(this.id,this.left, this.right, this.top, this.bottom);
}
