import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class CheckOtherStateViewModel extends ViewModel {

  String bigImage="both";//src,curState
  final controller = PageController();
  int curImage=0;
  final List<ObjectModel> allObjects;
  final ObjectModel curObject;


  CheckOtherStateViewModel(this.allObjects,this.curObject);

  changeImageSize(String name){
    bigImage=name==bigImage?"both":name;
    notifyListeners();
  }

  nextImage(){
    if(curImage<allObjects.length-1) {
      curImage+=1;
      controller.nextPage(duration: const Duration(milliseconds: 300), curve:Curves.bounceIn );
      notifyListeners();
    }
  }

  previousImage(){
    if(curImage>0) {
      curImage-=1;
      controller.jumpToPage(curImage);
      controller.previousPage(duration: const Duration(milliseconds: 300), curve:Curves.bounceIn );
      notifyListeners();
    }
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}