import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/flyObjectItem.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showFlyImagesList(
    List<ObjectModel> allObjects,
    int curObjId,
    FlyoutController controller,
    FlyoutPlacementMode placementMode,
    ValueSetter<String> onActionListener) {

  controller.showFlyout(
    autoModeConfiguration: FlyoutAutoConfiguration(
      preferredMode: placementMode,
    ),
    barrierDismissible: true,
    dismissOnPointerMoveAway: false,
    dismissWithEsc: true,
    builder: (context) {

      return FlyoutContent(
        color: Colors.grey[200],
        child: SizedBox(
          width: 600,
          height: 600,
          child: GridView(
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3.2 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            children: allObjects
                .map((item) =>
                FlyObjectItem(
                  key: GlobalKey(),
                  isSelected:item.id==curObjId,
                  object: item,
                  onActionCaller: (e)
                                    {
                                      onActionListener(e);
                                      Navigator.pop(context);
                                    },
                )).toList(),
          )
        ),
      );
    },
  );
}
