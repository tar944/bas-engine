import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';

class ImageGroupDAO {
  Future<ImageGroupModel?> getDetails(int id) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    ImageGroupModel? part = box.get(id);
    return part;
  }

  Future<ImageGroupModel?> getDetailsByUUID(String uuid) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    ImageGroupModel? grp = box.query(ImageGroupModel_.uuid.equals(uuid)).build().findFirst();
    return grp;
  }

  Future<int> add(ImageGroupModel newPart) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    int result = box.put(newPart);
    return result;
  }

  addObject(int groupId,ObjectModel obj)async{
    var group = await getDetails(groupId);
    group!.allStates.add(obj);
    update(group);
  }

  removeObject(int groupId,ObjectModel obj)async{
    var group = await getDetails(groupId);
    group!.allStates.removeWhere((element) => element.id == obj.id);
    update(group);
  }

  addSubObject(int groupId,ObjectModel obj)async{
    var group = await getDetails(groupId);
    group!.subObjects.add(obj);
    update(group);
  }

  addMainState(int groupId,ObjectModel obj)async{
    var group = await getDetails(groupId);
    group!.mainState.target=obj;
    group.allStates.removeWhere((element) => element.id!=obj.srcObject.target!.id);
    group.allStates.add(obj);
    group.state=GroupState.editOtherStates.name;
    update(group);
  }

  removeSubObject(int groupId,ObjectModel obj)async{
    var group = await getDetails(groupId);
    group!.subObjects.removeWhere((element) => element.id == obj.id);
    update(group);
  }

  Future<int> update(ImageGroupModel part) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    int result = box.put(part);
    return result;
  }

  Future<bool> delete(ImageGroupModel part) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    bool result = box.remove(part.id);
    return result;
  }
}
