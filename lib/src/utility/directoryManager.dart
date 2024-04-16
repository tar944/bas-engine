import 'dart:io';

import 'package:bas_dataset_generator_engine/src/utility/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DirectoryManager {
  final appDirName = 'DSGE_folder';

  createLocalDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final path = Directory(p.join(docsDir.path, appDirName));
    if (!path.existsSync()) {
      path.create();
    }
  }

  get dbPath async {
    final docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, appDirName, "dataBase");
  }

  Future<String> generateThumbnailPath(
      String prjUUID, String vidUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(
        docsDir.path, appDirName, prjUUID, vidUUID, "thumbnailDir"));
    if (!path.existsSync()) {
      path.create();
    }
    return p.join(docsDir.path, appDirName, prjUUID, vidUUID,
        "thumbnailDir", '${getRandomString(10)}.jpg');
  }

  Future<String> getScreenDirectoryPath(
      String prjUUID, String vidUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(
        docsDir.path, appDirName, prjUUID, vidUUID, "screenShotsDir"));
    if (!path.existsSync()) {
      path.create();
    }
    return p.join(
        docsDir.path, appDirName, prjUUID, vidUUID, "screenShotsDir");
  }

  Future<bool> createPrjDir(String prjUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(docsDir.path, appDirName, prjUUID));
    if (path.existsSync()) {
      return false;
    } else {
      await path.create();
      return true;
    }
  }

  Future<bool> createVideoDir(String prjUUID, String vidUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, prjUUID, vidUUID));
    if (path.existsSync()) {
      return false;
    } else {
      path.create();
      return true;
    }
  }
  Future<String> createPartDir(String prjUUID, String partUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, prjUUID, partUUID));
    if (path.existsSync()) {
      return path.path;
    } else {
      await path.create();
      return path.path;
    }
  }

  Future<String> getPartDir(String prjUUID, String partUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(docsDir.path, appDirName, prjUUID, partUUID));
    if (path.existsSync()) {
      return path.path;
    } else {
      await path.create();
      await Directory(path.path).create();
      await Directory(p.join(path.path, 'images')).create();
      await Directory(p.join(path.path, 'objectImages')).create();
      return path.path;
    }
  }

  Future<String> getFinalExportPath(String curPath) async {
    var path = Directory(curPath);
    if (!path.existsSync()) {
      return "errNotFoundDirectory";
    }
    final filePath =p.join(path.path, DateTime.now().millisecondsSinceEpoch.toString());
    await Directory(filePath).create();
    await Directory(p.join(filePath, 'trainData')).create();
    await Directory(p.join(filePath, 'dbDta')).create();
    return filePath;
  }

  Future<bool> saveFileInLocal(String path,String dataToSave)async{
    final file = File(path);
    file.writeAsStringSync(dataToSave);
    return true;
  }

  Future<String> getPartImageDirectoryPath(String prjUUID, String partUUID) async {
    return p.join(await getPartDir(prjUUID, partUUID),'images');
  }

  Future<String> getObjectImagePath(String prjUUID, String partUUId) async {
    return p.join(await getPartDir(prjUUID, partUUId),'objectImages','${getRandomString(10)}.jpg');
  }

  deleteVideoDirectory(String prjUUID, String vidUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, prjUUID, vidUUID));
    if (path.existsSync()) {
      path.deleteSync(recursive: true);
    }
  }
  
  deletePartDirectory(String prjUUID, String partUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, prjUUID, partUUID));
    if (path.existsSync()) {
      path.deleteSync(recursive: true);
    }
  }

  Future<String> copyFile(String srcPath,String desPath) async {
    File desFile = File(desPath);
    if(desFile.existsSync()==false){
      File file = File(srcPath);
      file.copySync(desPath);
    }
    return desPath;
  }

  deleteProjectDirectory(String prjUUID) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(docsDir.path, appDirName, prjUUID));
    if (path.existsSync()) {
      path.deleteSync(recursive: true);
    }
  }

  deleteImage(String imagePath) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = File(p.join(docsDir.path, imagePath));
    if (path.existsSync()) {
      path.deleteSync(recursive: true);
    }
  }
}
