import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/textStyle.dart';

void showFlyDescription(
    String description,
    FlyoutController controller,
    FlyoutPlacementMode placementMode,
    ValueSetter<String> onActionListener) {
  var ctlDescription = TextEditingController(text:description);

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
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Page description',
                style: TextSystem.textMB(Colors.white),
              ),
              const SizedBox(height: 20),
              TextBox(
                placeholder: 'description',
                style: TextSystem.textM(Colors.white),
                expands: false,
                maxLines: 5,
                controller: ctlDescription,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      onActionListener(ctlDescription.text);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: Text(
                            'Save',
                            style: TextSystem.textS(Colors.white),
                          )),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
