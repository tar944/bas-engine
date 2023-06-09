import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/strings.dart';
import '../../assets/values/textStyle.dart';

void showFlyRecordMenu(FlyoutController controller,
    ValueSetter<String>? onActionListener) {
  controller.showFlyout(
    autoModeConfiguration: FlyoutAutoConfiguration(
      preferredMode: FlyoutPlacementMode.topCenter,
    ),
    barrierDismissible: false,
    dismissOnPointerMoveAway: true,
    dismissWithEsc: true,
    builder: (context) {
      return FlyoutContent(
          child: SizedBox(
              width: 130,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Row(
                        children: [
                          const Icon(FluentIcons.edit_create),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Strings.saveNext,
                            style: TextSystem.textS(Colors.white),
                          )
                        ],
                      ),
                      onPressed: () => onActionListener!(Strings.saveNext)),
                  const SizedBox(height: 6.0),
                  Container(padding:const EdgeInsets.only(left: 5,right: 5),height:1,decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),),
                  const SizedBox(height: 4.0),
                  IconButton(
                      icon: Row(
                        children: [
                          Icon(
                            FluentIcons.power_button,
                            color: Colors.red.normal,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Strings.saveAndExit,
                            style: TextSystem.textS(Colors.red.normal),
                          )
                        ],
                      ),
                      onPressed: () => onActionListener!(Strings.saveAndExit)),
                ],
              ),
      ));
    },
  );
}
