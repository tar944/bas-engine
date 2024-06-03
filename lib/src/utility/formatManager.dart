import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as i;

class FormatManager{

  Future<String> generateFile(String prjUUID,String exportAction,List<PascalVOCModel>allStates,ValueSetter<int>onItemProcessCaller) async {
    String filePath = await DirectoryManager().getFinalExportPath(await Preference().getExportPath(prjUUID));
    bool needBackup = await Preference().shouldBackUp(prjUUID);
    if(filePath=="errNotFoundDirectory"){
      return filePath;
    }
    print("creating Export file =========================================");

    for(var item in allStates){
      item.filename = item.filename!.replaceAll(".png", ".jpg");
      await DirectoryManager().copyImage(
          srcPath: item.path!,
          desPath: path.join(filePath, "trainData", item.filename),
          quality: 50);
      await DirectoryManager().saveFileInLocal(
          path.join(filePath,'trainData', '${item.filename}.xml'), item.toXML().toXmlString(pretty: true));
      onItemProcessCaller(allStates.indexOf(item)+1);
    }
    print("compression finished");

    if(exportAction=="saveInServer"||needBackup){
      await generateBackupData(filePath,prjUUID);
    }

    ZipFileEncoder().zipDirectory(Directory(filePath), filename: '$filePath.zip');
    onItemProcessCaller(-1);
    return '$filePath.zip';
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
          trackAllGroups(grp.allGroups);
        }
      }

    }
  }

  generateBackupData(String exportPath,String prjUUID) async{
    var curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
    await DirectoryManager().saveFileInLocal(
        path.join(exportPath,'dbData', 'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'), jsonEncode(curProject!.toJson()));
  }
}