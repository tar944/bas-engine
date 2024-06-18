import 'package:bas_dataset_generator_engine/main.dart';
import 'package:bas_dataset_generator_engine/objectbox.g.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:objectbox/objectbox.dart';

class ImageDAO {
  Future<ImageModel?> getDetails(int id) async {
    Box<ImageModel> box = objectbox.store.box<ImageModel>();
    ImageModel? screen = box.get(id);
    return screen;
  }

  Future<ImageModel?> getDetailsByPath(String path) async {
    Box<ImageModel> box = objectbox.store.box<ImageModel>();
    ImageModel? img = box.query(ImageModel_.path.equals(path)).build().findFirst();
    return img;
  }

  Future<int> add(ImageModel newScreen) async {
    Box<ImageModel> box = objectbox.store.box<ImageModel>();
    int result = box.put(newScreen);
    return result;
  }

  Future<int> update(ImageModel image) async {
    Box<ImageModel> box = objectbox.store.box<ImageModel>();
    int result = box.put(image);
    return result;
  }

  Future<bool> delete(ImageModel screen) async {
    Box<ImageModel> box = objectbox.store.box<ImageModel>();
    bool result = box.remove(screen.id!);
    DirectoryManager().deleteImage(screen.path!);
    return result;
  }
}
