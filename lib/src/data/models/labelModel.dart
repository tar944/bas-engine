import 'package:objectbox/objectbox.dart';

@Entity()
class LabelModel {
  @Id()
  int id;
  String uuid="";
  String name;
  String isFor;
  LabelModel(this.id, this.name, this.isFor);
}