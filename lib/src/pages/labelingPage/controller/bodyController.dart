import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';

class BodyController extends ChangeNotifier {
  late List<ObjectModel> _objects;
  late int _partId;
  late String _prjUUID;
  late String _partUUID;
  late String _grpUUID;

  List<ObjectModel> get objects => _objects;

  int get partId => _partId;

  String get prjUUID => _prjUUID;

  String get partUUID => _partUUID;

  String get grpUUID => _grpUUID;

  setObjects(List<ObjectModel> objects) {
    _objects=objects;
    notifyListeners(); // Notify listeners that the data has changed
  }

  removeObject(int objId){
    _objects.removeWhere((element) => element.id==objId);
    notifyListeners();
  }

  setPartId(int id){
    _partId=id;
    notifyListeners();
  }

  setPrjUUID(String uuid){
    _prjUUID = uuid;
    notifyListeners();
  }

  setPartUUID(String uuid){
    _partUUID =uuid;
    notifyListeners();
  }

  setGrpUUID(String uuid){
    _grpUUID =uuid;
    notifyListeners();
  }
}