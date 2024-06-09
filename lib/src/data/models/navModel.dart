import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';

class NavModel{
  int id,imgNumber,rowNumber;
  String kind,title,imgPath,description,lblName;
  List<ImageGroupModel> otherShapes;
  NavModel(
      this.id,
      this.imgNumber,
      this.rowNumber,
      this.kind,
      this.title,
      this.imgPath,
      this.description,
      this.lblName,
      this.otherShapes
      );
}