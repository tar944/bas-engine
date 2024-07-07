import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ObjectModel {
  @Id()
  int? id;
  String uuid;
  double left;
  double right;
  double top;
  double bottom;
  String color = "blue";
  String exportName = "";
  String actionType = "";
  bool isNavTool = false;
  bool isMainObject = false;
  bool needToCompare = false;
  bool isGlobalObject = false;
  String typedText = "";
  int actX = -1, actY = -1;
  final srcObject = ToOne<ObjectModel>();
  final labelObjects = ToMany<ObjectModel>();
  final trainObjects = ToMany<ObjectModel>();
  final validObjects = ToMany<ObjectModel>();
  final testObjects = ToMany<ObjectModel>();
  final banObjects = ToMany<ObjectModel>();
  final image = ToOne<ImageModel>();
  final label = ToOne<LabelModel>();

  ObjectModel(this.id, this.uuid, this.left, this.right, this.top, this.bottom);

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
    if (labelObjects.isNotEmpty) {
      data['labelObjects'] = labelObjects.map((v) => v.toJson()).toList();
    }
    if (banObjects.isNotEmpty) {
      data['banObjects'] = banObjects.map((v) => v.toJson()).toList();
    }
    if (trainObjects.isNotEmpty) {
      data['trainObjects'] = trainObjects.map((v) => v.toJson()).toList();
    }
    if (testObjects.isNotEmpty) {
      data['testObjects'] = testObjects.map((v) => v.toJson()).toList();
    }
    if (validObjects.isNotEmpty) {
      data['validObjects'] = validObjects.map((v) => v.toJson()).toList();
    }
    if (srcObject.target != null) {
      data['srcObjectId'] = srcObject.target!.uuid;
    }
    if (image.target != null) {
      data['image'] = image.target!.toJson();
    }
    if (label.target != null) {
      data['labelId'] = label.target!.uuid;
    }
    return data;
  }

  double curLeft(ImageModel img, BuildContext context) {
    if (img.width > MediaQuery.of(context).size.width) {
      return ((left * MediaQuery.of(context).size.width) ~/ img.width)
          .toDouble();
    } else {
      return left;
    }
  }

  double curRight(ImageModel img, BuildContext context) {
    if (img.width > MediaQuery.of(context).size.width) {
      return ((right * MediaQuery.of(context).size.width) ~/ img.width)
          .toDouble();
    } else {
      return right;
    }
  }

  double curTop(ImageModel img, BuildContext context, double offsetY) {
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (img.height > curHeight) {
      return ((top * curHeight) ~/ img.height).toDouble();
    } else {
      return top;
    }
  }

  double curBottom(ImageModel img, BuildContext context, double offsetY) {
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (img.height > curHeight) {
      return ((bottom * curHeight) ~/ img.height).toDouble();
    } else {
      return bottom;
    }
  }
}
