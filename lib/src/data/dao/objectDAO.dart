import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';

class ObjectDAO {
  Future<ObjectModel?> getObject(int id) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    ObjectModel? part = box.get(id);
    return part;
  }

  Future<int> addObject(ObjectModel newObject) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    int result = box.put(newObject);
    return result;
  }

  Future<int> updateObject(ObjectModel object) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    int result = box.put(object);
    return result;
  }

  Future<bool> deleteObject(ObjectModel object) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    bool result = box.remove(object.id!);
    await ImageDAO().delete(object.image.target!);
    return result;
  }
}