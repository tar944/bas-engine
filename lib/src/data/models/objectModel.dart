import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ObjectModel {
  @Id()
  int? id;
  String uuid="";
  double left;
  double right;
  double top;
  double bottom;
  String color="blue";
  String description="";
  String label="";
  String? type;
  String actionType="";
  String typedText="";
  int actX=-1,actY=-1;
  final image = ToOne<ImageModel>();
  final allSubObjects = ToMany<ObjectModel>();
  ObjectModel(
      this.id,
      this.left,
      this.right,
      this.top,
      this.bottom);
}
