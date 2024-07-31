import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showFlyMore(FlyoutController controller, FlyoutPlacementMode placementMode,
    ValueSetter<String> onActionListener) {
  controller.showFlyout(
    autoModeConfiguration: FlyoutAutoConfiguration(
      preferredMode: placementMode,
    ),
    barrierDismissible: true,
    dismissOnPointerMoveAway: false,
    dismissWithEsc: true,
    builder: (context) {

      onClickHandler(String act){
        onActionListener(act);
        Navigator.pop(context);
      }

      return FlyoutContent(
        color: Colors.grey[200],
        child: SizedBox(
            width: 150,
            height: 87,
            child: Column(
              children: [
                IconButton(
                  onPressed: () => onActionListener(Strings.chooseObjects),
                  icon: Row(
                    children: [
                      const Icon(FluentIcons.arrange_send_to_back,color: Colors.white,size: 25,),
                      const SizedBox(width: 10,),
                      Text(Strings.chooseObjects,style: TextSystem.textS(Colors.white),)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                IconButton(
                  onPressed: () => onClickHandler(Strings.export),
                  icon: Row(
                    children: [
                      Icon(
                        FluentIcons.cloud_import_export,
                        color: Colors.teal,
                        size: 25,
                      ),
                      const SizedBox(width: 10,),
                      Text(Strings.export,style: TextSystem.textS(Colors.teal),)
                    ],
                  ),
                ),
              ],
            )),
      );
    },
  );
}
