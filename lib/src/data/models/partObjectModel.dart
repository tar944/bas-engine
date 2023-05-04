
import 'package:objectbox/objectbox.dart';

@Entity()
class PartObjectModel {
  @Id()
  int? id;
  double? left;
  double? right;
  double? top;
  double? bottom;
  String? color; //red blue grey white orange purple green black
  String? imageName;
  String? path;
  String? description;
  String? label;
  String? type;//checkbox,label,button,radioButton,icon,selectBox,table,chart,menu,menuItem,cell,editBox,textBox,richEditBox
  String? status; //passed,finished,deleted,created
  String? actionKind; //click,rightClick,slideRight,slideLeft,scrollHorizontal,scrollVertical,type,drag,hold,typeNumber
}
