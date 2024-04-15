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
  String actionType = "";
  bool isNavTool = false;
  bool isMainObject = false;
  bool needToCompare=false;
  String typedText = "";
  int actX = -1, actY = -1;
  final srcObject = ToOne<ObjectModel>();
  final image = ToOne<ImageModel>();
  final label = ToOne<LabelModel>();

  ObjectModel(
      this.id,
      this.uuid,
      this.left,
      this.right,
      this.top,
      this.bottom);

  double srcLeft(BuildContext context){
    if (image.target!.width > MediaQuery.of(context).size.width) {
      return ((left * image.target!.width) ~/ MediaQuery.of(context).size.width).toDouble();
    } else {
      return left;
    }
  }
  double srcRight(BuildContext context){
    if (image.target!.width > MediaQuery.of(context).size.width) {
      return ((right * image.target!.width) ~/ MediaQuery.of(context).size.width).toDouble();
    } else {
      return right;
    }
  }
  double srcTop(BuildContext context,double offsetY){
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (image.target!.height > curHeight) {
      return ((top * image.target!.height) ~/ curHeight).toDouble();
    } else {
      return top;
    }
  }
  double srcButton(BuildContext context,double offsetY){
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (image.target!.height > curHeight) {
      return ((bottom * image.target!.height) ~/ curHeight).toDouble();
    } else {
      return bottom;
    }
  }
  double curLeft(ImageModel img,BuildContext context){
    if (img.width > MediaQuery.of(context).size.width) {
      return ((left * MediaQuery.of(context).size.width) ~/ img.width).toDouble();
    } else {
      return left;
    }
  }
  double curRight(ImageModel img,BuildContext context){
    if (img.width > MediaQuery.of(context).size.width) {
      return ((right * MediaQuery.of(context).size.width) ~/ img.width).toDouble();
    } else {
      return right;
    }
  }
  double curTop(ImageModel img,BuildContext context,double offsetY){
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (img.height > curHeight) {
      return ((top * curHeight) ~/ img.height).toDouble();
    } else {
      return top;
    }
  }
  double curBottom(ImageModel img,BuildContext context,double offsetY){
    final curHeight = MediaQuery.of(context).size.height - offsetY;
    if (img.height > curHeight) {
      return ((bottom * curHeight) ~/ img.height).toDouble();
    } else {
      return bottom;
    }
  }
}