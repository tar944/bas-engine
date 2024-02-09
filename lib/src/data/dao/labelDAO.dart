import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';

class LabelDAO {
  Future<List<LabelModel>> getLabelList(String isFor) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    List<LabelModel> labels=box.query(LabelModel_.isFor.equals(isFor)).build().find();
    return labels;
  }

  Future<LabelModel?> getLabel(int id) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    LabelModel? label = box.get(id);
    return label;
  }

  Future<int> addLabel(LabelModel newObject) async {
    print(newObject.name);
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    return box.put(newObject);
  }

  addList(List<LabelModel>list)async{
    for(var item in list){
      await addLabel(item);
    }
  }

  Future<int> updateLabel(LabelModel object) async {
    Box<LabelModel> box = objectbox.store.box<LabelModel>();
    return box.put(object);
  }

  Future<bool> needAddDefaultValue() async{
    final list =await getLabelList('screen');
    print(list.isEmpty);
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