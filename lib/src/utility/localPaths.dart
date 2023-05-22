import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


class LocalPaths{

  final appDirName='DSGE_folder';

  createLocalDir()async{
    final docsDir=await getApplicationDocumentsDirectory();
    final path= Directory(p.join(docsDir.path,appDirName));
    if ((await path.exists())){
      // TODO:
      print("exist");
    }else{
      // TODO:
      print("not exist");
      path.create();
    }
  }

  get dbPath async{
    final docsDir=await getApplicationDocumentsDirectory();
    return p.join(docsDir.path,appDirName, "dataBase");
  }

  get thumbnailPath async{
    final docsDir=await getApplicationDocumentsDirectory();
    return p.join(docsDir.path,appDirName, "thumbnailDir");
  }
}