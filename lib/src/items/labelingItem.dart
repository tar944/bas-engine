import 'dart:io';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:image/image.dart' as i;

import 'package:bas_dataset_generator_engine/src/data/dao/screenPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/screenShootModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../widgets/partRegionExplorer.dart';


class LabelingItem extends HookWidget {
  const LabelingItem(   {
    Key? key,
    required this.item,
    required this.onPartsChanged,
    required this.nextClick,
    required this.perviousClick,
  }) : super(key: key);
  final ScreenShootModel item;
  final ValueSetter<String> onPartsChanged;
  final VoidCallback nextClick;
  final VoidCallback perviousClick;

  @override
  Widget build(BuildContext context) {
    final imgHeight = useState(0);
    useEffect(() {
      Future<void>.microtask(() async {
        final img =await i.decodeImageFile(item.path!);
        imgHeight.value = img!.height;
      });
      return null;
    }, const []);

    int getOrgPoint(int yPoint){
      print(imgHeight.value);
      print(MediaQuery.of(context).size.height);
      final curHeight = MediaQuery.of(context).size.height - (Dimens.topBarHeight);
      return (yPoint*imgHeight.value)~/curHeight;
    }

    onNewPartCreatedHandler(ScenePartModel newPart)async{
      await PartDAO().addPart(newPart);
      final cmd = i.Command()
        ..decodeImageFile(item.path!)
        ..copyCrop(x: newPart.left.toInt(), y: getOrgPoint(newPart.top.toInt()), width: (newPart.right-newPart.left).abs().toInt(), height: (getOrgPoint(newPart.bottom.toInt())-getOrgPoint(newPart.top.toInt())))
        ..writeToFile(await DirectoryManager().getPartImagePath('${item.video.target!.software.target!.id}_${item.video.target!.software.target!.title!}', item.video.target!.name!));
      await cmd.executeThread();
      onPartsChanged('refreshParts&&${item.id}');
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:Image.file(File(item.path!)).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(child: PartRegionExplorer(screenId:item.id!,allParts: item.sceneParts ?? [],onNewPartHandler: onNewPartCreatedHandler,)),
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
                    child: Center(
                        child: Icon(
                          CupertinoIcons.left_chevron,
                          color: Colors.white,
                          size: 40,
                        ))),
                onPressed:() =>perviousClick()),

            IconButton(
                icon: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[170].withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Icon(
                          CupertinoIcons.right_chevron,
                          color: Colors.white,
                          size: 40,
                        ))),
                onPressed: () =>nextClick()),
          ],
        ),)
      ],
    );
  }
}
