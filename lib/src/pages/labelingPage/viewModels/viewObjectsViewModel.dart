import 'dart:typed_data';

import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ViewObjectsViewModel extends ViewModel {

  final controller = PageController();
  int curImage=0;
  final int showObjectId;
  final List<ObjectModel> allObjects;

  ViewObjectsViewModel(this.allObjects,this.showObjectId);

  @override
  void onMount() {
    curImage=allObjects.indexWhere((element) => element.id==showObjectId);
    print(showObjectId);
    print(curImage);
    controller.jumpToPage(curImage);
    notifyListeners();
  }

  nextImage(){
    if(curImage<allObjects.length-1) {
      curImage+=1;
      controller.nextPage(duration: const Duration(milliseconds: 200), curve:Curves.decelerate );
      notifyListeners();
    }
  }

  actionBtnHandler(String action)async{
    nextImage();
  }

  previousImage(){
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