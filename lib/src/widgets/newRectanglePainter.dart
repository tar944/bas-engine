import 'package:bas_dataset_generator_engine/src/data/models/scenePartModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/rectanglePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NewRectanglePainter extends HookWidget {
  NewRectanglePainter({Key? key, required this.onNewListener})
      : super(key: key);

  ValueSetter<ScenePartModel> onNewListener;

  @override
  Widget build(BuildContext context) {
    final left = useState(0.0);
    final top = useState(0.0);
    final right = useState(0.0);
    final bottom = useState(0.0);
    final isPainting = useState(false);

    return Listener(
      onPointerDown: (e) {
        top.value = e.localPosition.dy;
        bottom.value = e.localPosition.dy;
        left.value = e.localPosition.dx;
        right.value = e.localPosition.dx;

        isPainting.value = true;
      },
      onPointerMove: (e) {
        if (isPainting.value) {
          right.value = e.localPosition.dx;
          bottom.value = e.localPosition.dy;
        }
      },
      onPointerUp: (e) {
        isPainting.value = false;
        onNewListener(ScenePartModel(
            0,
            right.value > left.value ? left.value : right.value,
            right.value > left.value ? right.value : left.value,
            top.value > bottom.value ? bottom.value : top.value,
            top.value > bottom.value ? top.value : bottom.value));
        top.value = 0.0;
        left.value = 0.0;
        right.value = 0.0;
        bottom.value = 0.0;
      },
      child: CustomPaint(
        painter: RectanglePainter(
            ScenePartModel(0,left.value, right.value, top.value, bottom.value)),
      ),
    );
  }
}
