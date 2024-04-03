import 'dart:typed_data';

import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
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
  final double dlgW,dlgH;
  final int showObjectId;
  final List<ObjectModel> allObjects;
  final List<ImageGroupModel> subGroups;
  List<ObjectModel> subObjects=[];

  ViewObjectsViewModel(this.dlgW,this.dlgH,this.subGroups,this.allObjects,this.showObjectId);

  @override
  void onMount() {
    curImage=allObjects.indexWhere((element) => element.id==showObjectId);
    subObjects=findSubObjects(subGroups,0,0);
    controller.jumpToPage(curImage);
    notifyListeners();
  }

  nextImage(){
    if(curImage<allObjects.length-1) {
      curImage+=1;
      subObjects=findSubObjects(subGroups,0,0);
      controller.nextPage(duration: const Duration(milliseconds: 200), curve:Curves.decelerate );
      notifyListeners();
    }
  }

  List<ObjectModel> findSubObjects(List<ImageGroupModel> subGroups,double offsetX,double offsetY){
    List<ObjectModel>allSubs=[];
    for(var grp in subGroups){
      if(grp.mainState.target!=null&&grp.label.target!=null&&grp.label.target!.levelName=="objects"){
        allSubs.addAll(grp.allStates);
      }else if(grp.mainState.target!=null&&grp.label.target!=null){
        allSubs.addAll(findSubObjects(grp.allGroups,grp.mainState.target!.left+offsetX,grp.mainState.target!.top+offsetY));
      }
    }
    allSubs= allSubs.map((e){
      e.top+=offsetY;
      e.bottom+=offsetY;
      e.left+=offsetX;
      e.right+=offsetY;
      return e;
    }).toList();
    return allSubs;
  }

  actionBtnHandler(String action)async{
    nextImage();
  }

  previousImage()async{
    if(curImage>0) {
      curImage-=1;
      subObjects=findSubObjects(subGroups,0,0);
      controller.previousPage(duration: const Duration(milliseconds: 200), curve:Curves.decelerate );
      notifyListeners();
    }
  }

  void onCloseClicked() {
    Navigator.pop(context);
  }
}