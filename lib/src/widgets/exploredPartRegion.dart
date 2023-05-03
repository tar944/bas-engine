
import 'package:bas_dataset_generator_engine/src/widgets/rectanglePainter.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../data/models/rectangleModel.dart';
import '../items/flyoutPageItemDelete.dart';
import '../items/flyoutPageItemEdit.dart';

class ExploredPartRegion extends StatelessWidget {

  ExploredPartRegion({Key? key, required this.curRectangle}) : super(key: key);

  RectangleModel curRectangle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (curRectangle.right-curRectangle.left).abs(),
      height: (curRectangle.bottom-curRectangle.top).abs()+30,
      child: Stack(
        children: [
          CustomPaint(
            painter: RectanglePainter(RectangleModel(
                0.0, curRectangle.right - curRectangle.left, 0.0, curRectangle.bottom-curRectangle.top)),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlyoutPageItemEdit(),
                SizedBox(width: 10,),
                FlyoutPageItemDelete(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
