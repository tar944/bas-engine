import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageGroupDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class DlgCutToPieceViewModel extends ViewModel {

  final confirmController = FlyoutController();
  final int groupId;
  final double dlgSizeScale;
  final String partUUID,prjUUID;
  final String title;
  final VoidCallback onCloseCaller;
  Size imgSize = const Size(0, 0);
  ImageGroupModel? group;
  ObjectModel? curObject;
  List<ObjectModel>subObject=[];
  List<int>minimizedObjects=[];
  int indexImage = 0, imgH = 0,imgW = 0;

  DlgCutToPieceViewModel(this.groupId,this.dlgSizeScale, this.partUUID,this.prjUUID,this.title,this.onCloseCaller);

  @override
  void init() async{

    group=await ImageGroupDAO().getDetails(groupId);
    subObject=group!.subObjects;

    curObject=group!.allStates[0];
    updatePageData();
  }

  updatePageData()async{
    curObject=group!.allStates[indexImage];
    final img = await i.decodeImageFile(curObject!.image.target!.path!);
    imgH = img!.height;
    imgW = img.width;
    imgSize = Size(
        imgW > MediaQuery.of(context).size.width
            ? MediaQuery.of(context).size.width
            : imgW.toDouble(),
        imgH>(MediaQuery.of(context).size.height - Dimens.topBarHeight)?
        (MediaQuery.of(context).size.height - Dimens.topBarHeight):
        imgH.toDouble()
    );
    notifyListeners();
  }

  onPartObjectHandler(String action){
    var act=action.split("&&");
    if(act[0]=="minimize"){
      minimizedObjects.add(int.parse(act[1]));
    }else{
      minimizedObjects.removeWhere((element) => element==int.parse(act[1]));
    }
    notifyListeners();
  }

  double getX(double x) {
    if (imgW > MediaQuery.of(context).size.width) {
      return ((x * imgW) ~/ MediaQuery.of(context).size.width).toDouble();
    } else {
      return x;
    }
  }

  double getY(double y) {
    final curHeight = MediaQuery.of(context).size.height - (Dimens.topBarHeight);
    if (imgH > curHeight) {
      return ((y * imgH) ~/ curHeight).toDouble();
    } else {
      return y;
    }
  }

  nextImage() async{
    indexImage = ++indexImage;
    if (indexImage == group!.allStates.length) {
      return indexImage = 0;
    }
    updatePageData();
  }

  perviousImage() async{
    if (indexImage == 0) return;
    indexImage = --indexImage;
    updatePageData();
  }

  onObjectActionHandler(String action) async {
    var actions = action.split('&&');
    if(actions[0]=="confirm"){
      var grp = await ImageGroupDAO().getDetails(groupId);
      grp!.state=GroupState.finishCutting.name;
      await ImageGroupDAO().update(grp);
      onCloseClicked();
    }
  }

  onNewPartCreatedHandler(ObjectModel newObject) async {
    newObject.uuid=const Uuid().v4();
    newObject.srcObject.target=curObject!;

    newObject.left=newObject.left>0?getX(newObject.left):0;
    newObject.right=getX(newObject.right)>imgSize.width?imgSize.width:getX(newObject.right);
    newObject.top=newObject.top>0?getY(newObject.top):0;
    newObject.bottom=getY(newObject.bottom)>imgSize.height?imgSize.height:getY(newObject.bottom);

    final path = await DirectoryManager().getObjectImagePath(prjUUID, partUUID);
    int w =(newObject.right - newObject.left).abs().toInt();
    int h =(newObject.bottom - newObject.top).toInt();

    final cmd = i.Command()
      ..decodeImageFile(curObject!.image.target!.path!)
      ..copyCrop(
          x: newObject.left.toInt(),
          y: newObject.top.toInt(),
          width: w,
          height: h)
      ..writeToFile(path);
    await cmd.executeThread();
    var img = ImageModel(-1, const Uuid().v4(), newObject.uuid, p.basename(path),w.toDouble(),h.toDouble(), path);
    img.id =await ImageDAO().add(img);
    newObject.image.target=img;

    newObject.id=await ObjectDAO().addObject(newObject);
    await ImageGroupDAO().addSubObject(groupId, newObject);
    group=await ImageGroupDAO().getDetails(groupId);
    subObject=group!.subObjects;
    notifyListeners();
  }

  void onCloseClicked() {
    onCloseCaller();
    Navigator.pop(context);
  }
}