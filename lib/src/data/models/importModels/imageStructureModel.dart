
class ImageStructureModel {
  String? uuid;
  String? path;
  String? objUUID;
  double? width,height;
  String? name;

  ImageStructureModel({
    this.uuid,
    this.path,
    this.objUUID,
    this.width,
    this.height,
    this.name
  });

  ImageStructureModel.fromJson(Map<String, dynamic> json) {
    uuid = json['_id'];
    path = json['path'];
    width = json['width'];
    height = json['height'];
    objUUID = json['objUUID'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['path'] = path;
    data['width'] = width;
    data['height'] = height;
    data['objUUID'] = objUUID;
    data['name'] = name;
    return data;
  }
}