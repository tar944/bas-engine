import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/dlgObjProperties.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class AllNamesViewModel extends ViewModel {

  final List<PascalObjectModel> objects;
  ValueSetter<List<PascalObjectModel>> onObjectChangeCaller;
  bool needUpdate=false;

  AllNamesViewModel(this.objects,this.onObjectChangeCaller);

  onEditNameHandler(PascalObjectModel obj){
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          DlgObjProperties(
              object: obj,
              needMore: false,
              onActionCaller:(e)=> onObjPropertiesHandler(e)),
    );
  }

  onObjPropertiesHandler(String action)async{
    var act=action.split('&&');
    var obj= await ObjectDAO().getDetailsByUUID(act[1]);
    obj!.exportName=act[2];
    await ObjectDAO().update(obj);
    objects[objects.indexWhere((element) => element.objUUID==act[1])].exportName=act[2];
    needUpdate=true;
    notifyListeners();

  }

  void onCloseClicked() {
    onObjectChangeCaller(needUpdate?objects:[]);
    Navigator.pop(context);
  }
}