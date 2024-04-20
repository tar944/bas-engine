import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as i;

class FormatManager{

  Future<String> generateFile(String prjUUID,bool needBackUp) async {
    String filePath = "";
    // String filePath = await DirectoryManager().getFinalExportPath(await Preference().getExportPath(prjUUID));
    // if(filePath=="errNotFoundDirectory"){
    //   return filePath;
    // }
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    print("creating Export file =========================================");


    // for(var part in curProject!.allParts){
    //   print("==============================");
    //   trackAllGroups(part.allGroups);
    // }

    // getBytesFromCanvas(100, 200, curProject!.allParts[0].allGroups[0].allStates[0].image.target!.path!);

    // if(needBackUp){
    //   await generateBackupData(filePath,prjUUID);
    // }
    //
    // ZipFileEncoder().zipDirectory(Directory(filePath), filename: '$filePath.zip');
    return filePath;
  }

  trackAllGroups(List<ImageGroupModel> allGroups)
  {
    for(var grp in allGroups){
      if(grp.mainState.target!=null&&grp.label.target!=null){
        for(var obj in grp.allStates){
          if(obj.srcObject.target!=null){
            print("${grp.label.target!.levelName}.${grp.label.target!.name}.${grp.name} ${obj.srcObject.target!.image.target!.name} ");
          }
        }
        if(grp.allGroups.isNotEmpty){
          print("----------------------------------");
          trackAllGroups(grp.allGroups);
        }
      }

    }
  }

  generateBackupData(String exportPath,String prjUUID) async{
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    await DirectoryManager().saveFileInLocal(
        path.join(exportPath, 'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'), jsonEncode(curProject!.toJson()));
  }
}