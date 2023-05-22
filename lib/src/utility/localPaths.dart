import 'dart:io';

import 'package:bas_dataset_generator_engine/src/utility/utility.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class LocalPaths{

  final appDirName='DSGE_folder';

  createLocalDir()async{
    final docsDir=await getApplicationDocumentsDirectory();
    final path= Directory(p.join(docsDir.path,appDirName));
    if (!path.existsSync()){
      path.create();
    }
  }

  get dbPath async{
    final docsDir=await getApplicationDocumentsDirectory();
    return p.join(docsDir.path,appDirName, "dataBase");
  }

  Future<String> generateThumbnailPath(String softwareName,String videoName) async{
    final docsDir=await getApplicationDocumentsDirectory();
    var path= Directory(p.join(docsDir.path,appDirName,softwareName,videoName,"thumbnailDir"));
    if (!path.existsSync()){
      path.create();
    }
    return p.join(docsDir.path,appDirName,softwareName,videoName,"thumbnailDir",'${getRandomString(10)}.jpg');
  }

  Future<bool> createSoftwareDir(String softwareName) async{
    final docsDir=await getApplicationDocumentsDirectory();
    var path= Directory(p.join(docsDir.path,appDirName,softwareName));
    if (path.existsSync()){
      return false;
    }else{
      path.create();
      return true;
    }
  }

  Future<bool> createVideoDir(String softwareName,String videoName) async{
    final docsDir=await getApplicationDocumentsDirectory();
    var path= Directory(p.join(docsDir.path,appDirName,softwareName,videoName));
    if (path.existsSync()){
      return false;
    }else{
      path.create();
      return true;
    }
  }
}