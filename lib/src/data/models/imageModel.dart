import 'package:objectbox/objectbox.dart';

@Entity()
class ImageModel {
  @Id()
  int? id;
  String uuid;
  String objUUID;
  String? name;
  String? path;

  ImageModel(this.id,this.uuid,this.objUUID, this.name, this.path);
}