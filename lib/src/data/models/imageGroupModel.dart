import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
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
  String? type;
  String path;
  final allImages = ToMany<ImageModel>();//todo: need to delete this line?
  final mainImage = ToOne<ImageModel>();
  final allObjects = ToMany<ObjectModel>();
  final allGroups = ToMany<ImageGroupModel>();
  final label = ToOne<LabelModel>();

  ImageGroupModel(this.id,this.partUUID,this.groupUUID, this.name, this.path);
}
