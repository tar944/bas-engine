import 'package:bas_dataset_generator_engine/src/dialogs/flyObjectAction.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyScreenDescription.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

import '../../assets/values/textStyle.dart';

class LabelingItem extends StatelessWidget {
  const LabelingItem(
      {Key? key,
      required this.title,
      required this.actions,
      required this.isSelected,
      required this.onActionListener,
      required this.description})
      : super(key: key);
  final String title;
  final List<String> actions;
  final String description;
  final ValueSetter<String> onActionListener;
  final bool isSelected;

  onSaveHandler(String newDescription) {
    onActionListener('$title&&$newDescription');
  }

  onObjectSaveHandler(List<String>actions){
    switch (actions.length){
      case 0:
        onActionListener('$title&& && ');
        break;
      case 1:
        onActionListener('$title&&${actions[0]}&& ');
        break;
      case 2:
        onActionListener('$title&&${actions[0]}&&${actions[1]}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();
    return FlyoutTarget(
        key: GlobalKey(),
        controller: controller,
        child: GestureDetector(
          onTap: () {
            if(actions.isNotEmpty){
              showFlyObjectAction(actions, controller, FlyoutPlacementMode.topCenter, onObjectSaveHandler);
            }else{
              showFlyDescription(
                  description,
                  controller,
                  FlyoutPlacementMode.topCenter,
                  onSaveHandler
              );
            }

          },
          child: Container(
            width: 90,
            height: 30,
            decoration: BoxDecoration(
              color: isSelected ? Colors.grey[210] : Colors.grey[180],
              border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
                child: Text(
              title,
              style: TextSystem.textS(Colors.white),
            )),
          ),
        ));
  }
}
