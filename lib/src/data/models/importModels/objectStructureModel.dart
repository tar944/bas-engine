
import 'package:bas_dataset_generator_engine/src/data/models/importModels/imageStructureModel.dart';

class ObjectStructureModel {

  String? uuid;
  String? actionType;
  int? actX, actY;
  ImageStructureModel? image;

  ObjectStructureModel(
      {this.uuid,
        this.actionType,
        this.image,
        this.actX,
        this.actY
      });

  ObjectStructureModel.fromJson(Map<String, dynamic> json) {
    uuid = json['_id'];
    actionType = json['actionType'];
    actX = json['actX'];
    actY = json['actY'];
    image = json['image'] != null ? ImageStructureModel.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['actionType'] = actionType;
    data['actX'] = actX;
    data['actY'] = actY;
    data['image'] = image!=null?image!.toJson():null;
    return data;
  }
}