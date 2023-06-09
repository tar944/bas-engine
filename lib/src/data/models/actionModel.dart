import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ActionModel {
  @Id()
  int id;
  bool isMouse;
  String actionType;
  String? typedText;
  int? x,y;
  ActionModel(this.id, this.isMouse,this.x, this.y, this.actionType);
}