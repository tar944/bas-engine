import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/textStyle.dart';

void showFlyDelete(
    String message,
    String btnText,
    FlyoutController controller,
    FlyoutPlacementMode placementMode,
    int id,
    ValueSetter<String>? onActionListener) {
  controller.showFlyout(
    autoModeConfiguration: FlyoutAutoConfiguration(
      preferredMode: placementMode,
    ),
    barrierDismissible: true,
    dismissOnPointerMoveAway: false,
    dismissWithEsc: true,
    builder: (context) {
      return FlyoutContent(
          child: Container(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextSystem.textXsBold(Colors.white),
            ),
            const SizedBox(height: 12.0),
            Button(
              child: Text(btnText),
              onPressed: () {
                onActionListener!("deleteFile&&$id");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ));
    },
  );
}
