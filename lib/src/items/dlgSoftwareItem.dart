import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/textStyle.dart';

class DDSoftwareItem extends StatelessWidget {
  const DDSoftwareItem({Key? key, required this.name})
      : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(name,style: TextSystem.textS(Colors.white),)
      ],
    );
  }
}
