import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class DialogTitleBar extends StatelessWidget {
  const DialogTitleBar(
      {Key? key, required this.title, required this.onActionListener})
      : super(key: key);

  final String title;
  final VoidCallback? onActionListener;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.dialogTitleBarHeight,
      child:Padding(
        padding:const EdgeInsets.only( left: 10,right: 10),
        child: Row(
            children: [
              Text(
                title,
                style: TextSystem.subtitle2(Colors.white),
              ),
              const Spacer(),
              IconButton(
                  icon: const Icon(
                    FluentIcons.calculator_multiply,
                    size: 17.0,
                  ),
                  onPressed: () => onActionListener!()),
            ]),
      )

    );
  }
}
