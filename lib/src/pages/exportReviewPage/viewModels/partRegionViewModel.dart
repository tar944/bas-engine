import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;

class PartRegionViewModel extends ViewModel {
  List<PascalObjectModel> itsObjects;
  ObjectModel? curObject;
  int imgW=0,imgH=0;
  final ValueSetter<String> onObjectActionCaller;
  final String imgPath;


  PartRegionViewModel(
      this.itsObjects,
      this.imgPath,
      this.onObjectActionCaller);


  @override
  void init() async{
    final img = await i.decodeImageFile(imgPath);
    imgH = img!.height;
    imgW = img.width;
    notifyListeners();
  }

  int getY(int y) {
    var curH = MediaQuery.of(context).size.height - Dimens.topBarHeight;
    if (imgH > curH) {
      return (y * curH) ~/ imgH;
    } else {
      return y;
    }
  }

  int getX(int x) {
    var curW=MediaQuery.of(context).size.width;
    if (imgW > curW) {
      return (x * curW) ~/ imgW;
    } else {
      return x;
    }
  }
}
