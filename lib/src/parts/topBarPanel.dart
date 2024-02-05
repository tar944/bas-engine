import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';

class TopBarPanel extends StatelessWidget {
  TopBarPanel({
    Key? key,
    required this.title,
    required this.needBack,
    required this.needHelp,
    this.onBackCaller,
    this.description,
  }) : super(key: key);

  final String title;
  String? description = "";
  final bool needBack, needHelp;
  VoidCallback? onBackCaller;
  VoidCallback? onHelpCaller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimens.topBarHeight,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.grey[220],),
      child: Row(
        children: [
          if (needBack)
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                  style: ButtonStyle(
                      padding: ButtonState.all(const EdgeInsets.all(3))),
                  icon: Container(
                    width: Dimens.actionBtnW - 11,
                    alignment: Alignment.center,
                    child: const Icon(FluentIcons.back),
                  ),
                  onPressed: () =>onBackCaller!()),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextSystem.textM(Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (description != null)
                  Text(
                    "( $description )",
                    style: TextSystem.textXs(Colors.grey[130]),
                  ),
              ],
            ),
          ),
          const Spacer(),
          if (needHelp)
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: IconButton(
                  style:
                      ButtonStyle(padding: ButtonState.all(EdgeInsets.all(3))),
                  icon: Container(
                      width: Dimens.btnHelpW,
                      height: Dimens.btnHelpW,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange.lighter),
                          shape: BoxShape.circle),
                      child: Icon(
                        FluentIcons.help,
                        color: Colors.orange.lighter,
                      )),
                  onPressed: () => onBackCaller),
            ),
          IconButton(icon: Icon(CupertinoIcons.xmark,color: Colors.white,), onPressed: (){exit(0);}),
        ],
      ),
    );
  }
}
