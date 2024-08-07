import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as i;

class PartRegionViewModel extends ViewModel {
  final List<ObjectModel> otherObjects;
  List<ObjectModel> itsObjects;
  final List<int> minimumObjects;
  RegionRecController objectController = RegionRecController();
  ObjectModel? curObject;
  ObjectModel mainObject;
  int imgW=0,imgH=0;
  final ValueSetter<ObjectModel> onNewObjectCaller;
  final ValueSetter<String> onObjectActionCaller;
  String prjUUID;
  bool allowDrawing=true;
  final bool isSimpleAction;
  double left = 0.0, top = 0.0, right = 0.0, bottom = 0.0;
  bool isPainting = false;


  PartRegionViewModel(
      this.prjUUID,
      this.mainObject,
      this.minimumObjects,
      this.otherObjects,
      this.itsObjects,
      this.isSimpleAction,
      this.onNewObjectCaller,
      this.onObjectActionCaller);


  @override
  void init() async{
    final img = await i.decodeImageFile(mainObject.image.target!.path);
    imgH = img!.height;
    imgW = img.width;
    notifyListeners();
  }

  pointerDownHandler(e) {
    top = e.localPosition.dy;
    bottom = e.localPosition.dy;
    left = e.localPosition.dx;
    right = e.localPosition.dx;
    isPainting = true;
    objectController.setActiveID(-1);
    notifyListeners();
  }

  pointerMoveHandler(e) {
    if (isPainting) {
      right = e.localPosition.dx;
      bottom = e.localPosition.dy;
      notifyListeners();
    }
  }

  onObjectActionHandler(String action)async{
    var act = action.split("&&");
    switch(act[0]){
      case "maximize":
      case "minimize":
        onObjectActionCaller(action);
        break;
      case "removeRegion":
        itsObjects=[];
        allowDrawing=true;
        notifyListeners();
        break;
      case "confirmRegion":
        onNewObjectCaller(itsObjects[0]);
        break;
      default:
        curObject = itsObjects.firstWhere((element) => element.id==int.parse(action.split("&&")[1]));
        itsObjects.remove(curObject);
        await ObjectDAO().deleteObject(curObject!);
        curObject=null;
        notifyListeners();
    }
  }

  onLabelActionHandler(String action)async{
    var lbl = await LabelDAO().getLabel(int.parse(action.split("&&")[1]));
    curObject!.label.target=lbl;
    await ObjectDAO().update(curObject!);
    itsObjects[itsObjects.indexOf(curObject!)]=curObject!;
    curObject=null;
    notifyListeners();
  }

  pointerUpHandler(e) {
    isPainting = false;
    final part = ObjectModel(
        0,
        const Uuid().v4(),
        right > left ? left : right,
        right > left ? right : left,
        top > bottom ? bottom : top,
        top > bottom ? top : bottom,
    );
    if(!isSimpleAction){
      allowDrawing=false;
      itsObjects.add(part);
    }else{
      onNewObjectCaller(part);
    }
    top = 0.0;
    left = 0.0;
    right = 0.0;
    bottom = 0.0;
    notifyListeners();
  }
}
