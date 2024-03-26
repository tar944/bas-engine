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

class CheckOtherStateViewModel extends ViewModel {

  String bigImage="both";//src,curState
  GroupState grpState=GroupState.editOtherStates;
  final controller = PageController();
  int curImage=0,curSrc=0;
  final int groupId;
  String prjUUID,partUUID;
  List<Uint8List> allImages=[];
  List<int> finishedObjectsId =[];
  final List<ObjectModel> allObjects;
  final List<ObjectModel> srcObjects;


  CheckOtherStateViewModel(this.allObjects,this.srcObjects,this.prjUUID,this.partUUID,this.groupId);

  @override
  void onMount() async{
    var grp = await ImageGroupDAO().getDetails(groupId);
    grpState=GroupState.values.firstWhere((element) => element.name==grp!.state);
    for(var obj in allObjects){
      var img = await getCroppedImage(obj);
      allImages.add(img!);
    }
    if(allImages.isNotEmpty){
      notifyListeners();
    }else{
      grp!.state= GroupState.findSubObjects.name;
      await ImageGroupDAO().update(grp);
      onCloseClicked();
    }
  }

  changeImageSize(String name){
    bigImage=name==bigImage?"both":name;
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
    if(action =="yes"){
      var obj = ObjectModel(-1, const Uuid().v4(), srcObjects[curSrc].left, srcObjects[curSrc].right, srcObjects[curSrc].top, srcObjects[curSrc].bottom);
      obj.srcObject.target=allObjects[curImage];
      final path = await DirectoryManager().getObjectImagePath(prjUUID, partUUID);
      i.Command()
        ..decodeJpg(allImages[curImage])
        ..writeToFile(path)
        ..executeThread();
      var img = ImageModel(-1, const Uuid().v4(), obj.uuid, p.basename(path), path);
      img.id =await ImageDAO().add(img);
      obj.image.target=img;
      obj.id=await ObjectDAO().addObject(obj);
      await ImageGroupDAO().replaceObject(groupId, obj);
    }else if(action =="no"){
      var curGroup = await ImageGroupDAO().getDetails(groupId);
      await ImageGroupDAO().removeObject(groupId, allObjects[curImage]);
      if(curGroup!.partUUID!=""){
        var part = await ProjectPartDAO().getDetailsByUUID(curGroup.partUUID);
        await ProjectPartDAO().addObject(part!.id, allObjects[curImage]);
      }else if(curGroup.groupUUID!=""){
        var grp = await ProjectPartDAO().getDetailsByUUID(curGroup.groupUUID);
        await ImageGroupDAO().addSubObject(grp!.id, allObjects[curImage]);
      }
    }
    finishedObjectsId.add(allObjects[curImage].id!);
    if(finishedObjectsId.length==allImages.length){
      var grp = await ImageGroupDAO().getDetails(groupId);
      grp!.state= GroupState.findSubObjects.name;
      await ImageGroupDAO().update(grp);
      onCloseClicked();
    }
    nextImage();
  }

  Future<Uint8List?> getCroppedImage(ObjectModel obj)async{
    final cmd = i.Command()
      ..decodeImageFile(obj.image.target!.path!)
      ..copyCrop(
          x: srcObjects[curSrc].left.toInt(),
          y: srcObjects[curSrc].top.toInt(),
          width: (srcObjects[curSrc].right.toInt() - srcObjects[curSrc].left.toInt()).abs().toInt(),
          height: (srcObjects[curSrc].bottom.toInt() - srcObjects[curSrc].top.toInt()))
      ..encodeJpg();
    await cmd.executeThread();
    return cmd.outputBytes;
  }

  bool isObjectDone(){
    if(finishedObjectsId.isNotEmpty
        &&finishedObjectsId.contains(allObjects[curImage].id)){
      return true;
    }
    return false;
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