import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({Key? key, required this.curRectangle}) : super(key: key);

  ScenePartModel curRectangle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (curRectangle.right - curRectangle.left).abs(),
      height: (curRectangle.bottom - curRectangle.top).abs() + 30,
      child: Stack(
        children: [
          CustomPaint(
            painter: RectanglePainter(ScenePartModel(
                0,
                0.0,
                curRectangle.right - curRectangle.left,
                0.0,
                curRectangle.bottom - curRectangle.top)),
          ),
        ],
      ),
    );
  }
}
