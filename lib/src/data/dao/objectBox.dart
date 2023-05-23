import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';

import '../../../objectbox.g.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store store;

  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final path =await DirectoryManager().dbPath;
    final store = await openStore(directory: path);
    return ObjectBox._create(store);
  }
}