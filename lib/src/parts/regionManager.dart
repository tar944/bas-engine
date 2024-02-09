import 'dart:io';
import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/imageDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/imageModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelingDataModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/partRegionExplorer.dart';
import 'package:image/image.dart' as i;
import 'package:path/path.dart' as p;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:uuid/uuid.dart';

class RegionManager extends HookWidget {
  const RegionManager({
    Key? key,
    required this.itemKind,
    required this.item,
    required this.onPartsChanged,
    required this.nextClick,
    required this.perviousClick,
  }) : super(key: key);
  final String itemKind;
  final LabelingDataModel item;
  final ValueSetter<String> onPartsChanged;
  final VoidCallback nextClick;
  final VoidCallback perviousClick;

  @override
  Widget build(BuildContext context) {
    final imgH = useState(0);
    final imgW = useState(0);
    final imgSize = useState(const Size(0, 0));
    useEffect(() {
      Future<void>.microtask(() async {
        final img = await i.decodeImageFile(item.getPath()!);
        imgH.value = img!.height;
        imgW.value = img.width;
        imgSize.value = Size(
          imgW.value > MediaQuery.of(context).size.width
              ? MediaQuery.of(context).size.width
              : imgW.value.toDouble(),
          imgH.value>(MediaQuery.of(context).size.height - Dimens.topBarHeight)?
          (MediaQuery.of(context).size.height - Dimens.topBarHeight):
              imgH.value.toDouble()
        );
      });
      return null;
    }, [item]);

    int getY(int y) {
      final curHeight =
          MediaQuery.of(context).size.height - (Dimens.topBarHeight);
      if(imgH.value>curHeight){
        return (y * imgH.value) ~/ curHeight;
      }else{
        return y;
      }
    }

    int getX(int x) {
      if(imgW.value>MediaQuery.of(context).size.width)
      {
        return (x * imgW.value) ~/ MediaQuery.of(context).size.width;
      }else{
        return x;
      }
    }

    onNewPartCreatedHandler(ObjectModel newPart) async {
      final path = await item.getPartPath();
      final cmd = i.Command()
        ..decodeImageFile(item.getPath()!)
        ..copyCrop(
            x: getX(newPart.left.toInt()),
            y: getY(newPart.top.toInt()),
            width: (getX(newPart.right.toInt()) - getX(newPart.left.toInt()))
                .abs()
                .toInt(),
            height: (getY(newPart.bottom.toInt()) - getY(newPart.top.toInt())))
        ..writeToFile(path);
      await cmd.executeThread();
      newPart.image.target = await ImageDAO().getDetails(item.getId()!);
      newPart.status = 'created';
      await ObjectDAO().addObject(newPart);
      onPartsChanged('refreshParts&&${item.getId()}');
    }

    onNewObjectCreatedHandler(ObjectModel newObject) async {
      final path = await item.getObjectPath();
      final cmd = i.Command()
        ..decodeImageFile(item.getPath()!)
        ..copyCrop(
            x: getX(newObject.left.toInt()),
            y: getY(newObject.top.toInt()),
            width: (getX(newObject.right.toInt()) - getX(newObject.left.toInt()))
                .abs()
                .toInt(),
            height: (getY(newObject.bottom.toInt()) - getY(newObject.top.toInt())))
        ..writeToFile(path);
      await cmd.executeThread();
      newObject.uuid=const Uuid().v4();
      var img = ImageModel(-1,const Uuid().v4(), newObject.uuid, p.basename(path), path);
      img.id=await ImageDAO().add(img);
      newObject.image.target=img;
      newObject.status = 'created';
      await ObjectDAO().addObject(newObject);
      onPartsChanged('refreshObjects&&${item.getId()}');
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: imgSize.value.width,
          height: imgSize.value.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.file(File(item.getPath()!)).image,
              fit: (imgW.value > MediaQuery.of(context).size.width ||
                      imgH.value >
                          (MediaQuery.of(context).size.height -
                              Dimens.topBarHeight))
                  ? BoxFit.fill
                  : BoxFit.none,
            ),
          ),
          child: itemKind!='object'?PartRegionExplorer(
            allObjects: item.getObjectList() ?? [],
            onNewObjectHandler: itemKind=='screen'?onNewPartCreatedHandler:onNewObjectCreatedHandler,
          ):SizedBox(width: 0,height: 0,),
        ),
        Positioned(
          top: 350,
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[170].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Icon(
                        CupertinoIcons.left_chevron,
                        color: Colors.white,
                        size: 40,
                      ))),
                  onPressed: () => perviousClick()),
              IconButton(
                  icon: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[170].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Icon(
                        CupertinoIcons.right_chevron,
                        color: Colors.white,
                        size: 40,
                      ))),
                  onPressed: () => nextClick()),
            ],
          ),
        )
      ],
    );
  }
}
