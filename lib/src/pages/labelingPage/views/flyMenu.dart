import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';


void showFlyMenu(FlyoutController controller,
    bool isShowAll,
    ValueSetter<String> onActionListener) {
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
                          Icon(isShowAll?FluentIcons.view:FluentIcons.hide3),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            isShowAll?Strings.hideAll:Strings.showAll,
                            style: TextSystem.textS(Colors.white),
                          )
                        ],
                      ),
                      onPressed: () {
                        onActionListener(isShowAll ? "${Strings.hideAll}&&" : "${Strings.showAll}&&");
                        Navigator.pop(context);
                      }),
                  const SizedBox(height: 6.0),
                  Container(padding:const EdgeInsets.only(left: 5,right: 5),height:1,decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),),
                  const SizedBox(height: 4.0),
                  IconButton(
                      icon: Row(
                        children: [
                          Icon(
                            FluentIcons.delete,
                            color: Colors.red.normal,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            Strings.delete,
                            style: TextSystem.textS(Colors.red.normal),
                          )
                        ],
                      ),
                      onPressed: () {
                        onActionListener("${Strings.delete}&&");
                      }),
                ],
              ),
      ));
    },
  );
}
