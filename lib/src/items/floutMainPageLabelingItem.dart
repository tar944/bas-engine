import 'package:fluent_ui/fluent_ui.dart';

import '../../assets/values/textStyle.dart';

class FlyoutMainPageLabelingItem extends StatelessWidget {
  const FlyoutMainPageLabelingItem({Key? key, required this.title}) : super(key: key);
  final String title;

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
                          'Label Box',
                          style: TextSystem.textMB(Colors.white),
                        ),
                        const SizedBox(height: 10),
                        TextBox(

                          placeholder: title,
                          style: TextSystem.textS(Colors.grey),
                          expands: false,
                        ),
                        const SizedBox(height: 10),
                        TextBox(
                          
                          placeholder: 'description',
                          style: TextSystem.textS(Colors.grey),
                          expands: false,
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
                                child: Center(child: Text('Save',style: TextSystem.textS(Colors.white),)),
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
            width: 80,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(child: Text(title,style: TextSystem.textS(Colors.white),)),
          ),
        )
    );
  }
}
