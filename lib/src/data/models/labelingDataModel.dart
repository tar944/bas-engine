import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';

class LabelingDataModel{
  String kind;
  ImageModel? _image;
  ObjectModel? _part;
  ObjectModel? _object;

  LabelingDataModel(this.kind);

  int? getId(){
    switch (kind){
      case 'screen':
        return _image!.id;
      case 'part':
        return _part!.id;
      case 'object':
        return _object!.id;
    }
    return -1;
  }

  String? getPath(){
    switch (kind){
      case 'screen':
        return _image!.path;
      case 'part':
        return _part!.image.target!.path;
      case 'object':
        return _object!.image.target!.path;
    }
    return '';
  }

  String? getStatus(){
    switch (kind){
      case 'part':
        return _part!.status;
      case 'object':
        return _object!.status;
    }
    return '';
  }
  List<ObjectModel>? getObjectList(){
    switch (kind){
      case 'part':
        return _part!.allSubObjects;
    }
    return [];
  }

  String? getName(){
    switch (kind){
      case 'screen':
        return _image!.name;
      case 'part':
        return _part!.image.target!.name;
      case 'object':
        return _object!.image.target!.name;
    }
    return 'notSet';
  }

  String? getDescription(){
    switch (kind){
      case 'part':
        return _part!.description;
      case 'object':
        return _object!.description;
    }
    return '';
  }

  String? getLabel(){
    switch (kind){
      case 'part':
        return _part!.label;
      case 'object':
        return _object!.label;
    }
    return '';
  }

  String? getType(){
    switch (kind){
      case 'part':
        return _part!.type;
      case 'object':
        return _object!.type;
    }
    return '';
  }

  Future<String> getPartPath()async{
    // SoftwareModel? software;
    // RecordedScreenGroup? group;
    // switch (kind){
    //   case 'screen':
    //     group = _image!.group.target;
    //     break;
    //   case 'part':
    //     group =_part!.screen.target!.group.target;
    //     break;
    // }
    // software=group!.software.target;
    // return await DirectoryManager().getPartImagePath(
    //     '${software!.id}_${software.title!}',
    //     '${group.id}_${group.name!}');
    return "";
  }

  Future<String> getObjectPath()async{
    // SoftwareModel? software;
    // RecordedScreenGroup? group;
    // switch (kind){
    //   case 'screen':
    //     group = _image!.group.target;
    //     break;
    //   case 'part':
    //     group =_part!.screen.target!.group.target;
    //     break;
    // }
    // software=group!.software.target;
    // return await DirectoryManager().getObjectImagePath(
    //     '${software!.id}_${software.title!}',
    //     '${group.id}_${group.name!}');
    return "";
  }

  set object(ObjectModel value) {
    _object = value;
  }

  set part(ObjectModel value) {
    _part = value;
  }

  set screen(ImageModel value) {
    _image = value;
  }
}