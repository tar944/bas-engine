import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class RegionDataModel {
  @Id()
  int? id;
  double left;
  double right;
  double top;
  double bottom;
  String kind;//part or object of part
  String? color;
  String? imageName;
  String? path;
  String? description;
  String? label;
  //checkbox,label,button,radioButton,icon,selectBox,table,chart,menu,menuItem,cell,editBox,textBox,richEditBox
  String? type; //menuBar,contentTabBar,statusBar,optionBox,toolsBar,toolsPallet,menu,submenu,rightClick
  String status; //finished,created
  String? actionKind; //click,rightClick,slideRight,slideLeft,scrollHorizontal,scrollVertical,type,drag,hold,typeNumber
  final screen = ToOne<ScreenShootModel>();
  final part = ToOne<RegionDataModel>();
  final objectsList = ToMany<RegionDataModel>();
  RegionDataModel(this.id,this.kind,this.left, this.right, this.top, this.bottom,this.status);
}
