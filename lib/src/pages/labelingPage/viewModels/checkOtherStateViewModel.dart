import 'dart:typed_data';

import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;

class CheckOtherStateViewModel extends ViewModel {

  String bigImage="both";//src,curState
  final controller = PageController();
  int curImage=0;
  List<Uint8List> allImages=[];
  final List<ObjectModel> allObjects;
  final ObjectModel curObject;


  CheckOtherStateViewModel(this.allObjects,this.curObject);

  @override
  void onMount() async{
    for(var obj in allObjects){
      var img = await getCroppedImage(obj);
      allImages.add(img!);
    }
    notifyListeners();
  }

  changeImageSize(String name){
    bigImage=name==bigImage?"both":name;
    notifyListeners();
  }

  nextImage()async{
    if(curImage<allObjects.length-1) {
      curImage+=1;
      controller.nextPage(duration: const Duration(milliseconds: 200), curve:Curves.decelerate );
      notifyListeners();
    }
  }

  Future<Uint8List?> getCroppedImage(ObjectModel obj)async{
    final cmd = i.Command()
      ..decodeImageFile(obj.image.target!.path!)
      ..copyCrop(
          x: curObject.left.toInt(),
          y: curObject.top.toInt(),
          width: (curObject.right.toInt() - curObject.left.toInt()).abs().toInt(),
          height: (curObject.bottom.toInt() - curObject.top.toInt()))
      ..encodeJpg();
    await cmd.executeThread();
    return cmd.outputBytes;
  }
  
  previousImage()async{
    if(curImage>0) {
      curImage-=1;
      controller.previousPage(duration: const Duration(milliseconds: 200), curve:Curves.decelerate );
      notifyListeners();
    }
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}