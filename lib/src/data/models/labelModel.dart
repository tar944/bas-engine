import 'package:objectbox/objectbox.dart';

@Entity()
class LabelModel {
  @Id()
  int id;
  String uuid="";
  String name;
  String action="";
  String levelName;
  LabelModel(this.id,this.uuid, this.name,this.levelName,this.action);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['name'] = name;
    data['action'] = action;
    data['levelName'] = levelName;
    return data;
  }
}