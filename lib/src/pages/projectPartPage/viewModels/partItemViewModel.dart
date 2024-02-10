import 'package:bas_dataset_generator_engine/src/data/models/projectPartModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class PartItemViewModel extends ViewModel {

  final ProjectPartModel part;
  final ValueSetter<String>? onActionCaller;
  int allImagesNumber =0;
  double donePercent=0;

  PartItemViewModel(this.part, this.onActionCaller);

  @override
  void init() async {
    allImagesNumber=part.allObjects.isNotEmpty?part.allObjects.length:0;
    int groupsImageNumber=0;
    for(var grp in part.allGroups){
      groupsImageNumber += grp.allObjects.isNotEmpty?grp.allObjects.length:0;
    }
    if(allImagesNumber==0&&groupsImageNumber==0||(allImagesNumber!=0&&groupsImageNumber==0)){
      donePercent=0;
    }else if(allImagesNumber==0&&groupsImageNumber!=0){
      donePercent=100;
    } else{
      donePercent=(allImagesNumber*100/(allImagesNumber+groupsImageNumber));
    }
    allImagesNumber+=groupsImageNumber;
    notifyListeners();
  }

  String getImagePath(){
    if(part.allObjects.isNotEmpty){
      return part.allObjects[0].image.target!.path!;
    }else if(part.allGroups.isNotEmpty){
      return part.allGroups[0].mainImage.target!.path!;
    }
    return "";
  }

}