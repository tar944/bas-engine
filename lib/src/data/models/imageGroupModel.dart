import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ImageGroupModel {
  @Id()
  int id;
  String uuid="";
  String partUUID;
  String groupUUID;
  String? name;
  String type="";
  String path;
  final mainState = ToOne<ObjectModel>();
  final allStates = ToMany<ObjectModel>();
  final subObjects = ToMany<ObjectModel>();
  final allGroups = ToMany<ImageGroupModel>();
  final label = ToOne<LabelModel>();

  ImageGroupModel(this.id,this.partUUID,this.groupUUID, this.name, this.path);
}
