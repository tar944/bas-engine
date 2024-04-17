import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:path/path.dart' as path;

class FormatManager{

  Future<String> generateFile(String prjUUID,bool needBackUp) async {
    String filePath = "";
    // String filePath = await DirectoryManager().getFinalExportPath(await Preference().getExportPath(prjUUID));
    // if(filePath=="errNotFoundDirectory"){
    //   return filePath;
    // }
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    print("creating Export file =========================================");

    int count=0;
    for(var part in curProject!.allParts){
      for(var grp in part.allGroups){
        for(var obj in grp.allStates){
          if(obj.srcObject.target!=null){
            count++;
            print("$count = ${obj.srcObject.target!.image.target!.name}");
          }
        }
      }
    }

    // if(needBackUp){
    //   await generateBackupData(filePath,prjUUID);
    // }
    //
    // ZipFileEncoder().zipDirectory(Directory(filePath), filename: '$filePath.zip');
    return filePath;
  }

  generateBackupData(String exportPath,String prjUUID) async{
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    await DirectoryManager().saveFileInLocal(
        path.join(exportPath, 'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'), jsonEncode(curProject!.toJson()));
  }
}