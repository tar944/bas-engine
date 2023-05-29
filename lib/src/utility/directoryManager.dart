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
      String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(
        docsDir.path, appDirName, softwareName, videoName, "thumbnailDir"));
    if (!path.existsSync()) {
      path.create();
    }
    return p.join(docsDir.path, appDirName, softwareName, videoName,
        "thumbnailDir", '${getRandomString(10)}.jpg');
  }

  Future<String> getScreenDirectoryPath(
      String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(
        docsDir.path, appDirName, softwareName, videoName, "screenShotsDir"));
    if (!path.existsSync()) {
      path.create();
    }
    return p.join(
        docsDir.path, appDirName, softwareName, videoName, "screenShotsDir");
  }

  Future<bool> createSoftwareDir(String softwareName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(docsDir.path, appDirName, softwareName));
    if (path.existsSync()) {
      return false;
    } else {
      path.create();
      return true;
    }
  }

  Future<bool> createVideoDir(String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, softwareName, videoName));
    if (path.existsSync()) {
      return false;
    } else {
      path.create();
      return true;
    }
  }

  Future<String> getPartDir(String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, softwareName, videoName,'partDir'));
    if (path.existsSync()) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  Future<String> getObjectDir(String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, softwareName, videoName,'objectDir'));
    if (path.existsSync()) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }

  deleteVideoDirectory(String softwareName, String videoName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path =
        Directory(p.join(docsDir.path, appDirName, softwareName, videoName));
    if (path.existsSync()) {
      path.deleteSync(recursive: true);
    }
  }

  deleteSoftwareDirectory(String softwareName) async {
    final docsDir = await getApplicationDocumentsDirectory();
    var path = Directory(p.join(docsDir.path, appDirName, softwareName));
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
