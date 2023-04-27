import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';

import '../../assets/values/textStyle.dart';

class FlyoutPageItemDelete extends StatelessWidget {
  const FlyoutPageItemDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = FlyoutController();
    return FlyoutTarget(
        key: GlobalKey(),
        controller: controller,
        child: GestureDetector(
          onTap: () async {
            controller.showFlyout(

              autoModeConfiguration: FlyoutAutoConfiguration(
                preferredMode: FlyoutPlacementMode.topCenter,
              ),
              barrierDismissible: true,
              dismissOnPointerMoveAway: false,
              dismissWithEsc: true,
              builder: (context) {
                return FlyoutContent(
                  color: Colors.grey[200],
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Do you want delete it?',
                          style: TextSystem.textMB(Colors.white),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){Navigator.of(context).pop();},
                              child: Container(
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                child: Center(child: Text('Yes',style: TextSystem.textS(Colors.white),)),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){Navigator.of(context).pop();},
                              child: Container(
                                width: 70,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                                child: Center(child: Text('No',style: TextSystem.textS(Colors.white),)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },

          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(child: Icon(CupertinoIcons.delete,color: Colors.white,size: 15,)
            ),
          ),
        )
    );
  }
}
