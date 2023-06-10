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
  const LabelingItem({
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
    final imgH = useState(0);
    final imgW = useState(0);
    useEffect(() {
      Future<void>.microtask(() async {
        final img = await i.decodeImageFile(item.path!);
        imgH.value = img!.height;
        imgW.value = img.width;
      });
      return null;
    }, const []);

    int getY(int y) {
      final curHeight =
          MediaQuery.of(context).size.height - (Dimens.topBarHeight);
      return (y * imgH.value) ~/ curHeight;
    }

    int getX(int x) {
      return (x * imgW.value) ~/ MediaQuery.of(context).size.width;
    }

    onNewPartCreatedHandler(ScenePartModel newPart) async {
      await PartDAO().addPart(newPart);
      final cmd = i.Command()
        ..decodeImageFile(item.path!)
        ..copyCrop(
            x: getX(newPart.left.toInt()),
            y: getY(newPart.top.toInt()),
            width: (getX(newPart.right.toInt()) - getX(newPart.left.toInt())).abs().toInt(),
            height: (getY(newPart.bottom.toInt()) - getY(newPart.top.toInt())))
        ..writeToFile(await DirectoryManager().getPartImagePath(
            '${item.group.target!.software.target!.id}_${item.group.target!.software.target!.title!}',
            '${item.group.target!.id}_${item.group.target!.name!}'));
      await cmd.executeThread();
      onPartsChanged('refreshParts&&${item.id}');
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.file(File(item.path!)).image,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
            child: PartRegionExplorer(
          screenId: item.id!,
          allParts: item.sceneParts ?? [],
          onNewPartHandler: onNewPartCreatedHandler,
        )),
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
                  onPressed: () => perviousClick()),
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
                  onPressed: () => nextClick()),
            ],
          ),
        )
      ],
    );
  }
}
