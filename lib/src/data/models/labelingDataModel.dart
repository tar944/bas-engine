import 'package:bas_dataset_generator_engine/src/data/models/recordedScreenGroup.dart';
import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/softwareModel.dart';

import '../../utility/directoryManager.dart';

class LabelingDataModel{
  String kind;
  ScreenShootModel? _screen;
  RegionDataModel? _part;

  LabelingDataModel(this.kind);

  int? getId(){
    switch (kind){
      case 'screen':
        return _screen!.id;
      case 'part':
        return _part!.id;
    }
    return -1;
  }

  String? getPath(){
    switch (kind){
      case 'screen':
        return _screen!.path;
      case 'part':
        return _part!.path;
    }
    return '';
  }

  String? getStatus(){
    switch (kind){
      case 'screen':
        return _screen!.status;
      case 'part':
        return _part!.status;
    }
    return '';
  }
  List<RegionDataModel>? getRegionsList(){
    switch (kind){
      case 'screen':
        return _screen!.partsList;
      case 'part':
        return _part!.objectsList;
    }
    return [];
  }

  String? getName(){
    switch (kind){
      case 'screen':
        return _screen!.imageName;
      case 'part':
        return _part!.imageName;
    }
    return 'notSet';
  }

  String? getDescription(){
    switch (kind){
      case 'screen':
        return _screen!.description;
      case 'part':
        return _part!.description;
    }
    return '';
  }

  String? getLabel(){
    switch (kind){
      case 'screen':
        return _screen!.label;
      case 'part':
        return _part!.label;
    }
    return '';
  }

  String? getType(){
    switch (kind){
      case 'screen':
        return _screen!.type;
      case 'part':
        return _part!.type;
    }
    return '';
  }

  Future<String> getPartPath()async{
    SoftwareModel? software;
    RecordedScreenGroup? group;
    switch (kind){
      case 'screen':
        group = _screen!.group.target;
        break;
      case 'part':
        group =_part!.screen.target!.group.target;
        break;
    }
    software=group!.software.target;
    return await DirectoryManager().getPartImagePath(
        '${software!.id}_${software.title!}',
        '${group.id}_${group.name!}');
  }

  Future<String> getObjectPath()async{
    SoftwareModel? software;
    RecordedScreenGroup? group;
    switch (kind){
      case 'screen':
        group = _screen!.group.target;
        break;
      case 'part':
        group =_part!.screen.target!.group.target;
        break;
    }
    software=group!.software.target;
    return await DirectoryManager().getObjectImagePath(
        '${software!.id}_${software.title!}',
        '${group.id}_${group.name!}');
  }

  set part(RegionDataModel value) {
    _part = value;
  }

  set screen(ScreenShootModel value) {
    _screen = value;
  }
}