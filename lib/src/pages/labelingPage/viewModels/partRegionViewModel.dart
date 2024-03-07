import 'package:bas_dataset_generator_engine/src/controllers/regionRecController.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:uuid/uuid.dart';

class PartRegionViewModel extends ViewModel {
  final List<ObjectModel> otherObjects;
  final List<ObjectModel> itsObjects;
  RegionRecController objectController = RegionRecController();
  ObjectModel? curObject;
  final ValueSetter<ObjectModel> onNewObjectHandler;

  double left = 0.0, top = 0.0, right = 0.0, bottom = 0.0;
  bool isPainting = false;

  PartRegionViewModel(
      this.otherObjects, this.itsObjects, this.onNewObjectHandler);

  onNewRectangleHandler(ObjectModel newObject) async {
    onNewObjectHandler(newObject);
  }

  onObjectActionHandler(String objAction) {
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

  pointerHoverHandler(e) {
    if(!isPainting){
      double x =e.localPosition.dx;
      double y =e.localPosition.dy;
      bool found=false;
      for(var item in itsObjects){
        if(x>item.left&&x<item.right){
          if(y>item.top&&y<item.bottom){
            found =true;
            objectController.setActiveID(item.id!);
            notifyListeners();
            break;
          }
        }
      }
      if(!found){
        for(var item in otherObjects){
          if(x>item.left&&x<item.right){
            if(y>item.top&&y<item.bottom){
              found=true;
              objectController.setActiveID(item.id!);
              notifyListeners();
              break;
            }
          }
        }
      }
      if(!found){
        objectController.setActiveID(-1);
        notifyListeners();
      }
    }
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
        "");
    onNewObjectHandler(part);
    top = 0.0;
    left = 0.0;
    right = 0.0;
    bottom = 0.0;
    notifyListeners();
  }
}
