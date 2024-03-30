import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ObjectModel {
  @Id()
  int? id;
  String uuid;
  double left;
  double right;
  double top;
  double bottom;
  String color = "blue";
  String actionType = "";
  bool isNavTool = false;
  bool isMainObject = false;
  bool needToCompare=false;
  String typedText = "";
  int actX = -1, actY = -1;
  final srcObject = ToOne<ObjectModel>();
  final image = ToOne<ImageModel>();
  final label = ToOne<LabelModel>();

  ObjectModel(
      this.id,
      this.uuid,
      this.left,
      this.right,
      this.top,
      this.bottom);
}
