import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class ActionButton extends StatelessWidget {
  ActionButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.toolTip,
    required this.isSelected,
    this.onActionListener
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String toolTip;
  final bool isSelected;
  ValueSetter<String>? onActionListener;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Tooltip(
        message: toolTip,
        displayHorizontally: true,
        useMousePosition: false,
        style: const TooltipThemeData(preferBelow: true),
        child: IconButton(
          style: ButtonStyle(
            padding: ButtonState.all(EdgeInsets.all(5))
          ),
          icon: Container(
            width: Dimens.actionBtnW,
            decoration: isSelected==true?BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 1.5
              ),
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.actionRadius)),
              color: Colors.black,
            ):null,
            child: Column(
              children: [
                const SizedBox(height: 5,),
                Icon(icon,size: Dimens.actionIcon,color: isSelected?Colors.orange.normal:Colors.grey[100],),
                const SizedBox(height: 5,),
                Text(
                  title,
                  style: TextSystem.textT(isSelected?Colors.white:Colors.grey[100]),
                ),
                const SizedBox(height: 7,),
              ],
            ),
          ),
          onPressed: () => onActionListener!(title),
        ),
      )
    ]);
  }
}
