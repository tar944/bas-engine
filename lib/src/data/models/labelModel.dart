import 'package:objectbox/objectbox.dart';

@Entity()
class LabelModel {
  @Id()
  int id;
  String uuid="";
  String name;
  String isFor;
  String levelName;
  LabelModel(this.id, this.name,this.levelName,this.isFor);
}