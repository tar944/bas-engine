import 'package:bas_dataset_generator_engine/src/dialogs/toast.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

import '../../assets/values/textStyle.dart';

void showFlyObjectAction(
    List<String> actions,
    FlyoutController controller,
    FlyoutPlacementMode placementMode,
    ValueSetter<List<String>> onActionListener) {

  controller.showFlyout(
    autoModeConfiguration: FlyoutAutoConfiguration(
      preferredMode: placementMode,
    ),
    barrierDismissible: true,
    dismissOnPointerMoveAway: false,
    dismissWithEsc: true,
    builder: (context) {
      print(actions);
      return FlyoutContent(
        color: Colors.grey[200],
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Object action',
                style: TextSystem.textMB(Colors.white),
              ),
              const SizedBox(height: 20),
              MultiSelectContainer(
                  items: ActionKind.values
                      .map((e) {
                        return MultiSelectCard(
                        value: e.name,
                        label: e.name,
                        selected: actions.contains(e.name));
                  }).toList(),
                  onChange: (allSelectedItems, selectedItem) {
                    actions = allSelectedItems;
                  },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if(actions.length>2){
                        Toast('You can choose only two action',false).showWarning(context);
                        return;
                      }
                      onActionListener(actions);
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
