import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/strings.dart';
import '../widgets/actionButton.dart';
import '../widgets/circleProfile.dart';

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
            CircleProfile(
                imageUrl:
                "https://eclatsuperior.com/wp-content/uploads/2021/04/man3.jpg",
                description: "sara bagheri kani",
                size: Dimens.actionBtnW),

            if(kind=="library") ...[
              ActionButton(
                icon: FluentIcons.add,
                title: Strings.createACourse,
                toolTip: "Add a new course",
                isSelected: activeOne==Strings.createACourse,
                onActionListener: onActionListener,),
              ActionButton(
                icon: FluentIcons.open_file,
                title: Strings.openACourse,
                toolTip: "Open an existed course",
                isSelected:  activeOne==Strings.openACourse,
                onActionListener: onActionListener,),
            ],
            if (kind == "studio") ...[
              ActionButton(
                icon: FluentIcons.git_graph,
                title: Strings.CVC,
                toolTip: "choose to find bubbles",
                isSelected: activeOne==Strings.CVC,
                onActionListener: onActionListener,),
              ActionButton(
                icon: FluentIcons.view_dashboard,
                title: Strings.info,
                toolTip: "choose to find bubbles",
                isSelected:  activeOne==Strings.info,
                onActionListener: onActionListener,),
              ActionButton(
                icon: FluentIcons.locale_language,
                title: Strings.language,
                toolTip: "choose to find bubbles",
                isSelected:  activeOne==Strings.language,
                onActionListener: onActionListener,),
              ActionButton(
                icon: FluentIcons.test_case,
                title: Strings.preview,
                toolTip: "choose to find bubbles",
                isSelected:  activeOne==Strings.preview,
                onActionListener: onActionListener,),
            ],
          ],
        ),
      ),
    );
  }
}
