import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RegionDataModel {
  @Id()
  int? id;
  double left;
  double right;
  double top;
  double bottom;
  String kind;//part or object of part
  String? color;
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? type;
  String status;
  String? actionKind;
  final screen = ToOne<ScreenShootModel>();
  final part = ToOne<RegionDataModel>();
  final objectsList = ToMany<RegionDataModel>();
  RegionDataModel(this.id,this.kind,this.left, this.right, this.top, this.bottom,this.status);
}
