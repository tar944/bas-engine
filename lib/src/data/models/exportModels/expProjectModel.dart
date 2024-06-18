import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expLabelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expPartModel.dart';

class ExpProjectModel {

  String uuid;
  String? title;
  String? companyId;
  String? companyName;
  String? description;
  String? icon;
  String? companyLogo;
  List<ExpPartModel> allParts;
  List<ExpLabelModel> allLabels;

  ExpProjectModel(
      this.uuid,
      this.title,
      this.companyId,
      this.companyName,
      this.description,
      this.icon,
      this.companyLogo,
      this.allParts,
      this.allLabels);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = uuid;
    data['title'] = title;
    data['companyId'] = companyId;
    data['companyName'] = companyName;
    data['description'] = description;
    if (allParts.isNotEmpty) {
      data['allParts'] = allParts.map((v) => v.toJson()).toList();
    }
    if (allLabels.isNotEmpty) {
      data['allLabels'] = allLabels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
