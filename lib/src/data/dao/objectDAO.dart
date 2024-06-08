import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';

class ObjectDAO {
  Future<ObjectModel?> getDetails(int id) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    ObjectModel? part = box.get(id);
    return part;
  }


  Future<ObjectModel?> getDetailsByUUID(String uuid) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    ObjectModel? obj = box.query(ObjectModel_.uuid.equals(uuid)).build().findFirst();
    return obj;
  }

  Future<List<ObjectModel>?> getByLabel(int lblId) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    var listObjects = box.query(ObjectModel_.label.equals(lblId)).build().find();
    return listObjects;
  }

  Future<int> addObject(ObjectModel newObject) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    int result = box.put(newObject);
    return result;
  }

  Future<int> update(ObjectModel object) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    int result = box.put(object);
    return result;
  }

  updateExportState(String objUUID,String state) async {
    var obj=await getDetailsByUUID(objUUID);
    obj!.exportState=state;
    update(obj);
  }

  Future<bool> deleteObject(ObjectModel object) async {
    Box<ObjectModel> box = objectbox.store.box<ObjectModel>();
    bool result = box.remove(object.id!);
    if(object.image.target==null){
      await ImageDAO().delete(object.image.target!);
    }
    return result;
  }
}