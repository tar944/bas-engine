import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/projectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expImageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expLabelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expPartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/exportModels/expProjectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as path;

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
        path.join(exportPath,'dbData', 'db_${DateTime.now().millisecondsSinceEpoch.toString()}.json'), await getProjectData(curProject!));
  }

  Future<String> getProjectData(ProjectModel prj)async{
    var parts=<ExpPartModel>[];
    var labels = <ExpLabelModel>[];
    for(var part in prj.allParts){
      var allGroups=<ExpGroupModel>[];
      var allObjects=<ExpObjectModel>[];
      for(var grp in part.allGroups){
        var group =await ImageGroupDAO().getDetails(grp.id);
        print('main --');
        allGroups.add(await getGroupData(group!,1));
      }
      for(var obj in part.allObjects){
        allObjects.add(convertObject(obj));
      }
      parts.add(ExpPartModel(prj.uuid, part.uuid, part.name, part.path, part.description, allGroups, allObjects));
    }
    
    for(var lbl in prj.allLabels){
      labels.add(ExpLabelModel(lbl.uuid, lbl.name, lbl.levelName, lbl.action));
    }
    
    return jsonEncode(ExpProjectModel(
        prj.uuid,
        prj.title,
        prj.companyId,
        prj.companyName,
        prj.description,
        prj.icon,
        prj.companyName,
        parts,
        labels).toJson()
    );
  }
  
  ExpObjectModel convertObject(ObjectModel obj){
    return ExpObjectModel(
        obj.uuid,
        obj.left,
        obj.right,
        obj.top,
        obj.bottom,
        obj.color,
        obj.exportName,
        obj.actionType,
        obj.actX,
        obj.actY,
        obj.isNavTool,
        obj.isMainObject,
        obj.needToCompare,
        obj.typedText,
        obj.srcObject.target==null?Strings.notSet:obj.srcObject.target!.uuid,
        ExpImageModel(obj.image.target!.uuid, obj.image.target!.objUUID, obj.image.target!.name, obj.image.target!.width, obj.image.target!.height, obj.image.target!.path),
        obj.label.target==null?Strings.notSet:'${obj.label.target!.levelName}.${obj.label.target!.name}');
  }
  
  Future<ExpGroupModel> getGroupData(ImageGroupModel curGrp,int depthAmount)async{
    print("$depthAmount ==> ${curGrp.uuid}");
    var navObjects = <String>[];
    var subObjects=<ExpObjectModel>[];
    var allStates=<ExpObjectModel>[];
    var allGroups =<ExpGroupModel>[];
    var otherShapes =<ExpGroupModel>[];
    if(curGrp.navObjects.isNotEmpty){
      for(var obj in curGrp.navObjects){
        navObjects.add(obj.uuid);
      }
    }

    if(curGrp.subObjects.isNotEmpty){
      for(var obj in curGrp.subObjects){
        subObjects.add(convertObject(obj));
      }
    }

    if(curGrp.allStates.isNotEmpty){
      for(var obj in curGrp.allStates){
        allStates.add(convertObject(obj));
      }
    }

    if(curGrp.allGroups.isNotEmpty){
      for(var grp in curGrp.allGroups){
        var group =await ImageGroupDAO().getDetails(grp.id);
        print('sub--');
        allGroups.add(await getGroupData(group!,depthAmount+1));
      }
    }

    if(curGrp.otherShapes.isNotEmpty){
      for(var grp in curGrp.otherShapes){
        if(grp.uuid!=curGrp.uuid){
          var group =await ImageGroupDAO().getDetails(grp.id);
          print('sh--');
          otherShapes.add(await getGroupData(group!,depthAmount+1));
        }
      }
    }
    return ExpGroupModel(
        curGrp.uuid,
        curGrp.partUUID,
        curGrp.groupUUID,
        curGrp.name!,
        curGrp.mainState.target!=null?curGrp.mainState.target!.uuid:Strings.notSet,
        curGrp.type,
        curGrp.state,
        curGrp.label.target==null?Strings.notSet:'${curGrp.label.target!.levelName}.${curGrp.label.target!.name}',
        navObjects,
        allGroups,
        otherShapes,
        subObjects,
        allStates);
  }
}