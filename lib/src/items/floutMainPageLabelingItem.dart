import 'package:bas_dataset_generator_engine/src/dialogs/flyScreenDescription.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/textStyle.dart';

class FlyoutMainPageLabelingItem extends StatelessWidget {
  const FlyoutMainPageLabelingItem(
      {Key? key,
      required this.title,
      required this.isSelected,
      required this.onActionListener,
      required this.description})
      : super(key: key);
  final String title;
  final String description;
  final ValueSetter<String> onActionListener;
  final bool isSelected;

  onSaveHandler(String newDescription) {
    onActionListener('$title&&$newDescription');
  }

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();
    return FlyoutTarget(
        key: GlobalKey(),
        controller: controller,
        child: GestureDetector(
          onTap: () => showFlyDescription(description, controller,
              FlyoutPlacementMode.topCenter, onSaveHandler),
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
