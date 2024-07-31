import 'package:bas_dataset_generator_engine/src/data/models/imageGroupModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalVOCModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/views/screenItem.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showFlyScreensList(
    List<PascalVOCModel> allScreens,
    List<ImageGroupModel>allGroups,
    String grpUUID,
    String objUUID,
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
          height: 650,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: ComboBox<String>(
                  value: grpUUID,
                  items: allGroups.map((e) {
                    return ComboBoxItem(
                      value: e.uuid,
                      child: Text(e.name!=null&&e.name!=''?e.name!:e.label.target!.name),
                    );
                  }).toList(),
                  onChanged: (uuid) => onActionListener('changeGroup&&$uuid'),
                ),
              ),
              SizedBox(
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
                  children: allScreens
                      .map((item) =>
                      ScreenItem(
                        key: GlobalKey(),
                        isDivision: false,
                        isSelected:item.objUUID==objUUID,
                        showObject: true,
                        object: item,
                        onActionCaller: (e) {onActionListener(e);Navigator.pop(context);},
                      )).toList(),
                ),
              ),
            ],
          )
        ),
      );
    },
  );
}
