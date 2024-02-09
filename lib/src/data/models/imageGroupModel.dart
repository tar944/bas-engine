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
  String? name;
  String? type;
  String path;
  final allImages = ToMany<ImageModel>();
  final mainImage = ToOne<ImageModel>();
  final allParts = ToMany<ObjectModel>();
  final label = ToOne<LabelModel>();

  ImageGroupModel(this.id,this.partUUID, this.name, this.path);
}
