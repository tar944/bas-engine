import 'package:bas_dataset_generator_engine/src/data/models/labelTypeModel.dart';
import '../../../main.dart';
import '../../../objectbox.g.dart';

class LabelDAO {
  Future<List<LabelTypeModel>> getLabelList(String isFor) async {
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    List<LabelTypeModel> labels=box.query(LabelTypeModel_.isFor.equals(isFor)).build().find();
    return labels;
  }

  Future<LabelTypeModel?> getLabel(int id) async {
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    LabelTypeModel? label = box.get(id);
    return label;
  }

  Future<int> addLabel(LabelTypeModel newObject) async {
    print(newObject.name);
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    return box.put(newObject);
  }

  addList(List<LabelTypeModel>list)async{
    for(var item in list){
      await addLabel(item);
    }
  }

  Future<int> updateLabel(LabelTypeModel object) async {
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    return box.put(object);
  }

  Future<bool> needAddDefaultValue() async{
    final list =await getLabelList('screen');
    print(list.isEmpty);
    return list.isEmpty;
  }

  deleteAll()async{
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    box.removeAll();
  }

  Future<bool> deleteLabel(int id) async {
    Box<LabelTypeModel> box = objectbox.store.box<LabelTypeModel>();
    bool result = box.remove(id);
    return result;
  }
}