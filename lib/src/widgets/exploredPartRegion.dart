import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ExploredPartRegion extends StatelessWidget {
  ExploredPartRegion({Key? key, required this.curObject, required this.isMine})
      : super(key: key);

  ObjectModel curObject;
  bool isMine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (curObject.right - curObject.left).abs(),
      height: (curObject.bottom - curObject.top).abs() + 30,
      child: Stack(
        children: [
          CustomPaint(
            painter: RectanglePainter(
                object: ObjectModel(
                    0,
                    "",
                    0.0,
                    curObject.right - curObject.left,
                    0.0,
                    curObject.bottom - curObject.top,
                    ""
                ),
                isMine: isMine),
          ),
        ],
      ),
    );
  }
}
