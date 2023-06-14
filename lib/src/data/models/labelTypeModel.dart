import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LabelTypeModel {
  @Id()
  int id;
  String name;
  String isFor;
  LabelTypeModel(this.id, this.name, this.isFor);
}