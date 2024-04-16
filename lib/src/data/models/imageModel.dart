import 'package:objectbox/objectbox.dart';

@Entity()
class ImageModel {
  @Id()
  int? id;
  String uuid;
  String objUUID;
  String? name;
  String? path;
  double width;
  double height;

  ImageModel(this.id,
      this.uuid,
      this.objUUID,
      this.name,
      this.width,
      this.height,
      this.path);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['objUUID'] = objUUID;
    data['name'] = name;
    data['path'] = path;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}