class ExpLabelModel {

  String uuid="";
  String name;
  String action="";
  String levelName;
  ExpLabelModel(this.uuid, this.name,this.levelName,this.action);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['name'] = name;
    data['action'] = action;
    data['levelName'] = levelName;
    return data;
  }
}