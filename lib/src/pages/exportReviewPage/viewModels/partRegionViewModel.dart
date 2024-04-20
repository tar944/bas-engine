import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;

class PartRegionViewModel extends ViewModel {
  List<ObjectModel> itsObjects;
  ObjectModel? curObject;
  int imgW=0,imgH=0;
  final ValueSetter<String> onObjectActionCaller;
  final ImageModel curImage;


  PartRegionViewModel(
      this.itsObjects,
      this.curImage,
      this.onObjectActionCaller);


  @override
  void init() async{
    final img = await i.decodeImageFile(curImage.path!);
    imgH = img!.height;
    imgW = img.width;
    notifyListeners();
  }

  onObjectActionHandler(String action)async{
    var act = action.split("&&");
  }
}
