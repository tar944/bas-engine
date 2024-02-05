import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HeaderBtn extends StatelessWidget {
  const HeaderBtn(
      {Key? key,
        required this.text,
        required this.onPressed,
        required this.isFirst,
        required this.tabKind,
        required this.status})
      : super(key: key);

  final String text;
  final bool isFirst;
  final String status;
  final HeaderTabs tabKind;
  final ValueSetter<HeaderTabs> onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 10),
      child: Row(
        children: [
          if(!isFirst)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(FluentIcons.chevron_right,color: Colors.white.withOpacity(status=="active"?1.0:0.5),),            ),
          Button(
            onPressed: ()=>{onPressed(tabKind)},
            style: ButtonStyle(
              backgroundColor: ButtonState.all(status!="active"?Colors.grey[170]:Colors.teal.darkest),
            ),
            child: Container(
              height: Dimens.tabHeightSmall,
              width: Dimens.tabWidth,
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextSystem.textM(Colors.white.withOpacity(status=="active"?1.0:0.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
