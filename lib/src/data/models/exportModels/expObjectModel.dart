import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expImageModel.dart';

class ExpObjectModel {
  String uuid;
  double left;
  double right;
  double top;
  double bottom;
  String color = "blue";
  String exportName;
  String actionType;
  String typedText;
  String srcObjectUUID;
  String labelUUID;
  int actX, actY;
  bool isNavTool;
  bool isMainObject;
  bool needToCompare;
  ExpImageModel? image;

  ExpObjectModel(
      this.uuid,
      this.left,
      this.right,
      this.top,
      this.bottom,
      this.color,
      this.exportName,
      this.actionType,
      this.actX,
      this.actY,
      this.isNavTool,
      this.isMainObject,
      this.needToCompare,
      this.typedText,
      this.srcObjectUUID,
      this.image,
      this.labelUUID
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['left'] = left;
    data['right'] = right;
    data['top'] = top;
    data['bottom'] = bottom;
    data['exportName'] = exportName;
    data['color'] = color;
    data['actionType'] = actionType;
    data['isNavTool'] = isNavTool;
    data['isMainObject'] = isMainObject;
    data['needToCompare'] = needToCompare;
    data['actX'] = actX;
    data['actY'] = actY;
    data['typedText'] = typedText;
    data['srcObjectUUID'] = srcObjectUUID;
    data['image'] = image==null?null:image!.toJson();
    data['labelUUID'] = labelUUID;
    return data;
  }
}
