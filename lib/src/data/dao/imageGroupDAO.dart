import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';

class ImageGroupDAO {
  Future<ImageGroupModel?> getDetails(int id) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    ImageGroupModel? part = box.get(id);
    return part;
  }

  Future<int> add(ImageGroupModel newPart) async {
    Box<ImageGroupModel> box = objectbox.store.box<ImageGroupModel>();
    int result = box.put(newPart);
    return result;
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
