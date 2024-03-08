import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';

class LabelDAO {
  Future<List<LabelModel>> getLabelList(String prjUUID) async {
    var prj = await ProjectDAO().getDetailsByUUID(prjUUID);
    return prj!.allLabels;
  }

  Future<LabelModel?> getLabel(int id) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    LabelModel? label = box.get(id);
    return label;
  }

  Future<int> addLabel(LabelModel newObject) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    return box.put(newObject);
  }

  addList(String prjUUID,List<LabelModel>list)async{
    for(var item in list){
      await addLabel(item);
      await ProjectDAO().addALabel(prjUUID, item);
    }
  }

  Future<int> updateLabel(LabelModel object) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    return box.put(object);
  }

  Future<bool> needAddDefaultValue(String prjUUID) async{
    final list =await getLabelList(prjUUID);
    return list.isEmpty;
  }

  deleteAll()async{
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    box.removeAll();
  }

  Future<bool> deleteLabel(int id) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    bool result = box.remove(id);
    return result;
  }
}