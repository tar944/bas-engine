import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:pmvvm/pmvvm.dart';

class LabelingBodyViewModel extends ViewModel {
  List<ObjectModel> objects = [];
  ImageGroupModel curGroup;
  LabelModel curLabel=LabelModel(-1, "", "");

  LabelingBodyViewModel(this.objects,this.curGroup);

  onLabelActionHandler(String action)async{
    switch(action.split('&&')[0]){
      case "choose":
        break;
      case "added":
        break;
      case "remove":
        break;
    }
  }

  int getLabelObjectNumber(LabelModel lbl){
    return 0;
  }

  onObjectActionHandler(String action)async{
    switch (action.split('&&')[0]) {
      case 'gotoCutToPieces':
        // final curProject = await ProjectDAO().getDetailsByUUID(prjUUID);
        // final curPart = await ProjectPartDAO().getDetails(partId);
        // await Preference().setMainAddress('${curProject!.id}&&${curPart!.id}&&${curGroup!.id}');
        // context.goNamed('cutToPieces',params: {
        //   'objId':action.split('&&')[1],
        //   'groupId':curGroup!.id.toString(),
        //   'partUUID':partUUID,
        //   'prjUUID':prjUUID,
        //   'title': '${curProject.title} > ${curPart.name} > ${curGroup!.name}'
        // });
        break;
      case 'addToGroup':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[2]));
        // await ProjectPartDAO().removeObject(partId, obj!);
        // await ImageGroupDAO().addObject(int.parse(action.split("&&")[1]), obj);
        // updateProjectData(-1);
        break;
      case 'removeFromGroup':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[2]));
        // await ProjectPartDAO().addObject(partId, obj!);
        // await ImageGroupDAO().removeObject(int.parse(action.split("&&")[1]), obj);
        // updateProjectData(curGroup.id);
        break;
      case 'delete':
        var obj = await ObjectDAO().getDetails(int.parse(action.split("&&")[1]));
        await ObjectDAO().deleteObject(obj!);
        // if(curGroup==null){
        //   await ProjectPartDAO().removeObject(partId, obj);
        //   updateProjectData(-1);
        // }else{
        //   await ImageGroupDAO().removeObject(curGroup!.id, obj);
        //   updateProjectData(curGroup!.id);
        // }
        break;

    }
    // onGroupActionCaller('refreshPart&&');
  }

}