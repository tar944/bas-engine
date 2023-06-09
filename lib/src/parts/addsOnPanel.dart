import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../widgets/actionButton.dart';

class AddsOnPanel extends HookWidget {
  AddsOnPanel({Key? key,  this.onActionCaller,required this.kind, this.activeOne,})
      : super(key: key);

  final String kind;
  String? activeOne="none";
  ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    onActionListener(String actionName) {
      onActionCaller!(actionName);
    }

    return Container(
      width: Dimens.actionBtnW + 15,
      height: MediaQuery.of(context).size.height - (Dimens.topBarHeight),
      decoration: BoxDecoration(color: Colors.grey[210]),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          children: [
            kind=="video"?

            ActionButton(
              icon: FluentIcons.add,
              title: Strings.addScreens,
              toolTip: "Record new screenshots",
              isSelected: activeOne==Strings.addScreens,
              onActionListener: onActionListener,):
            ActionButton(
              icon: FluentIcons.add,
              title: Strings.addSoftware,
              toolTip: "Add a new software",
              isSelected: activeOne==Strings.addSoftware,
              onActionListener: onActionListener,)
          ],
        ),
      ),
    );
  }
}
