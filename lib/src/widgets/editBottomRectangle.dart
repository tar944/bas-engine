import 'package:fluent_ui/fluent_ui.dart';

import '../items/flyoutPageItemDelete.dart';
import '../items/flyoutPageItemEdit.dart';


class EditBottomRectangle extends StatelessWidget {
  const EditBottomRectangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FlyoutPageItemEdit(),
        SizedBox(width: 10,),
        FlyoutPageItemDelete(),
      ],
    );
  }
}
