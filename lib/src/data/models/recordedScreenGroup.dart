import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RecordedScreenGroup {
  @Id()
  int id;
  String? name;
  String? description;
  String path;
  int imgNumber;
  final  screenShoots= ToMany<ScreenShootModel>();
  final software = ToOne<SoftwareModel>();

  RecordedScreenGroup(this.id, this.name,this.path,this.description,this.imgNumber);
}