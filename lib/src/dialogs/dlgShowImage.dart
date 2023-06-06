import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/dimens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../assets/values/strings.dart';
import '../parts/dialogTitleBar.dart';
import 'dart:ui' as ui;

class DlgShowImage extends HookWidget {
  DlgShowImage({Key? key, required this.image}) : super(key: key);
  final ui.Image image;
  @override
  Widget build(BuildContext context) {

    void onCloseClicked() {
      Navigator.pop(context);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: Dimens.dialogLargeWidth,
          height: Dimens.dialogBigHeight,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.dialogCornerRadius)),
            color: Colors.grey[190],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DialogTitleBar(
                title: Strings.dlgNewSoftware,
                onActionListener: onCloseClicked,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          RawImage(image: image,)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
