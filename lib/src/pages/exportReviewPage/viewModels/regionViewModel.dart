import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionViewModel extends ViewModel {
  PascalObjectModel curObject;
  final ValueSetter<String> onObjectActionCaller;
  final double width, height;
  final String mainObjUUID;
  final bool isDivMode;
  bool isHover = false;
  String regionStatus = 'none';
  final objectKey = GlobalKey();
  final objectController = FlyoutController();

  RegionViewModel(
      this.mainObjUUID,
      this.curObject,
      this.width,
      this.height,
      this.isDivMode,
      this.onObjectActionCaller);

  @override
  void init() async {
    var obj = await ObjectDAO().getDetailsByUUID(curObject.objUUID!);
    if (obj!.isGlobalObject) {
      regionStatus = 'global';
    } else {
      var mainObject = await ObjectDAO().getDetailsByUUID(mainObjUUID);
      for (var obj in mainObject!.labelObjects) {
        if (obj.uuid == curObject.objUUID) {
          regionStatus = "active";
          break;
        }
      }
      if (regionStatus != 'active') {
        for (var obj in mainObject.banObjects) {
          if (obj.uuid == curObject.objUUID) {
            regionStatus = "banned";
            break;
          }
        }
      }
    }
    notifyListeners();
  }

  onHoverHandler(bool isHover) {
    this.isHover = isHover;
    notifyListeners();
  }

  onClickHandler(e) {
    if(isDivMode){
      final targetContext = objectKey.currentContext;
      if (targetContext == null) return;
      final box = targetContext.findRenderObject() as RenderBox;
      final position = box.localToGlobal(
        e.localPosition,
        ancestor: Navigator.of(context).context.findRenderObject(),
      );
      objectController.showFlyout(
          barrierColor: Colors.black.withOpacity(0.1),
          position: position,
          builder: (context) {
            onActionHandler(String dirName){
              onObjectActionCaller('${curObject.objUUID}&&$dirName&&${curObject.dirKind!.contains(dirName)}');
              if(curObject.dirKind!.contains(dirName)){
                curObject.dirKind=curObject.dirKind!.replaceAll('$dirName&&', '');
              }else{
                curObject.dirKind ='${curObject.dirKind}$dirName&&';
              }
              notifyListeners();
              Navigator.pop(context);
            }
            return FlyoutContent(
              child: SizedBox(
                width: 260.0,
                child: CommandBar(
                  isCompact:false,
                  mainAxisAlignment:MainAxisAlignment.center,
                  direction: Axis.horizontal,
                  primaryItems: [
                    CommandBarButton(
                      icon:Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: curObject.dirKind!.contains('train')?Colors.teal.dark:Colors.teal.dark.withOpacity(.5),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      label: const Text('train'),
                      onPressed: ()=>onActionHandler('train'),
                    ),
                    CommandBarButton(
                      icon: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: curObject.dirKind!.contains('valid')?Colors.orange.dark:Colors.orange.dark.withOpacity(.5),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      label: const Text('valid'),
                      onPressed: ()=>onActionHandler('valid'),
                    ),
                    CommandBarButton(
                      icon: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: curObject.dirKind!.contains('test')?Colors.magenta.dark:Colors.magenta.dark.withOpacity(.5),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      label: const Text('test'),
                      onPressed: ()=>onActionHandler('test'),
                    ),
                  ],
                ),
              ),
            );});
    }else{
      switch (regionStatus) {
        case 'none':
          regionStatus = 'active';
          onObjectActionCaller("${curObject.objUUID}&&active");
          break;
        case 'global':
          regionStatus = 'none';
          onObjectActionCaller("${curObject.objUUID}&&setGlobal");
          break;
        case 'active':
          regionStatus = 'none';
          onObjectActionCaller("${curObject.objUUID}&&none");
          break;
        default:
          regionStatus = 'none';
      }
      notifyListeners();
    }

  }

  onDivisionHandler(String dirName){
    onObjectActionCaller('${curObject.objUUID}&&$dirName&&${curObject.dirKind!.contains(dirName)}');
    if(curObject.dirKind!.contains(dirName)){
      curObject.dirKind=curObject.dirKind!.replaceAll('$dirName&&', '');
    }else{
      curObject.dirKind ='${curObject.dirKind}$dirName&&';
    }
    notifyListeners();
  }

  onMiddleHandler() {
    if(!isDivMode){
      if (regionStatus == "banned") {
        onObjectActionCaller("${curObject.objUUID}&&unBanned");
      } else {
        if (regionStatus == 'active') {
          onObjectActionCaller("${curObject.objUUID}&&none");
          regionStatus = 'deActive';
          notifyListeners();
        } else if (regionStatus == 'deActive') {
          onObjectActionCaller("${curObject.objUUID}&&banned");
        } else {
          regionStatus = 'deActive';
          notifyListeners();
        }
      }
    }
  }

  onRightClickHandler() {
    if(!isDivMode){
      if (['global', 'active'].contains(regionStatus)) {
        onObjectActionCaller('${curObject.objUUID}&&showProperties');
      } else {
        onObjectActionCaller('${curObject.objUUID}&&setGlobal');
      }
    }
  }

  double getSize(){
    if(width<40){
      return 5;
    }else if(width>40&&width<80){
      return 8;
    }else if(width>80&&width<160){
      return 12;
    }else{
      return 20;
    }
  }

  Color getColor() {
    if(isDivMode){
      if(curObject.dirKind==''){
        return Colors.blue.light;
      }else{
        return Colors.purple;
      }
    }else{
      if (regionStatus == "active") {
        return Colors.green;
      } else if (regionStatus == "none") {
        return Colors.orange;
      }else if(regionStatus=='global'){
        return Colors.magenta;
      }else{
        return Colors.red;
      }
    }

  }
}
