import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class CButton extends StatelessWidget {
  const CButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.textColor,
      required this.onPressed,
      required this.kind})
      : super(key: key);

  final String text;
  final Color color;
  final Color textColor;
  final String kind;
  final VoidCallback? onPressed;

  double getSize(String which) {
    switch (kind) {
      case "normal":
        return which == "w" ? Dimens.btnWidthNormal : Dimens.btnHeightNormal;
      case "long":
        return which == "w" ? Dimens.btnWidthBig : Dimens.btnHeightSmall;
      case "big":
        return which == "w" ? Dimens.btnWidthBig : Dimens.btnHeightNormal;
      default:
        return which == "w" ? Dimens.btnWidthNormal : Dimens.btnHeightNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: ButtonState.all(color),
      ),
      child: Container(
        height: getSize("h"),
        width: getSize("w"),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextSystem.textM(textColor),
        ),
      ),
    );
  }
}
