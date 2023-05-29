import 'package:bas_dataset_generator_engine/src/data/dao/screenPartDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/screenShotDAO.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/models/scenePartModel.dart';
import 'exploredPartRegion.dart';
import 'newRectanglePainter.dart';

class PartRegionExplorer extends HookWidget {
  PartRegionExplorer( {
    Key? key,
    required this.allParts,
    required this.screenId,
  }) : super(key: key);

  final List<ScenePartModel> allParts;
  final int screenId;

  @override
  Widget build(BuildContext context) {
    final allRectangles = useState(allParts);

    onNewRectangleHandler(ScenePartModel newPart) {
      allRectangles.value = [...allRectangles.value..add(newPart)];
    }

    onPartSaveHandler(String action) async{
      print(action);
      var actions = action.split('&&');
      ScenePartModel? part = await PartDAO().getPart(int.parse(actions[1]));
      switch (actions[0]) {
        case 'edit':
          part!.type = actions[2];
          part.description = actions[3];
          part.status = 'finished';
          await PartDAO().updatePart(part);
          allRectangles.value = await ScreenDAO().getAllParts(screenId);
          break;
        case 'delete':
          await PartDAO().deletePart(part!);
          allRectangles.value = await ScreenDAO().getAllParts(screenId);
          break;
        case 'show':
          // for (final item in allScreens.value) {
          //   if (item.id == screen!.id) {
          //     indexImage.value = allScreens.value.indexOf(item);
          //     break;
          //   }
          // }
          break;
      }
    }

    return Stack(children: [
      Positioned(
        top: 0.0,
        bottom: 0.0,
        right: 0.0,
        left: 0.0,
        child: NewRectanglePainter(
          onNewListener: onNewRectangleHandler,
        ),
      ),
      ...allRectangles.value.map((item) {
        return Positioned(
          top: item.top,
          left: item.left,
          child: ExploredPartRegion(
            curRectangle: item,
          ),
        );
      }).toList(),
    ]);
  }
}
