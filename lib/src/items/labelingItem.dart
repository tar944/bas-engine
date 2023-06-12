import 'dart:io';
import 'package:bas_dataset_generator_engine/src/data/models/labelingDataModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/regionDataModel.dart';
import 'package:image/image.dart' as i;
import 'package:bas_dataset_generator_engine/src/data/dao/screenPartDAO.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../assets/values/dimens.dart';
import '../widgets/partRegionExplorer.dart';
import 'package:path/path.dart' as p;

class LabelingItem extends HookWidget {
  const LabelingItem({
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
    useEffect(() {
      Future<void>.microtask(() async {
        final img = await i.decodeImageFile(item.getPath()!);
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

    onNewPartCreatedHandler(RegionDataModel newPart) async {
      final path = await item.getGroupDir();
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
      newPart.imageName = p.basename(path);
      newPart.path = path;
      newPart.status = 'created';
      await PartDAO().addPart(newPart);
      onPartsChanged('refreshParts&&${item.getId()}');
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.file(File(item.getPath()!)).image,
              fit: itemKind=='screen'?BoxFit.fill:BoxFit.none,
            ),
          ),
        ),
        Positioned.fill(
            child: PartRegionExplorer(
          screenId: item.getId()!,
          allParts: item.getRegionsList() ?? [],
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
