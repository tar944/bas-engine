import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';
import '../data/models/softwareModel.dart';
import '../dialogs/flyDlgDelete.dart';
import '../utility/measureSize.dart';

class SoftwareItem extends HookWidget {
  const SoftwareItem(
      {Key? key, required this.software, required this.onActionCaller})
      : super(key: key);

  final SoftwareModel software;
  final ValueSetter<String>? onActionCaller;

  @override
  Widget build(BuildContext context) {
    var size = useState(const Size(215, 300));
    final controller = FlyoutController();

    return MeasureSize(
        onChange: (e) {
          size.value = e;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.dialogCornerRadius)),
              color: Colors.grey[170],
              border: Border.all(color: Colors.magenta, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.value.width,
                  child: Text(
                    software.title!,
                    style: TextSystem.textS(Colors.white),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                    width: (size.value.width),
                    child: Text(
                      software.description!,
                      style: TextSystem.textXs(Colors.white),
                      maxLines: 4,
                    )),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                        flex: 30,
                        child: Row(
                          children: [
                            FlyoutTarget(
                                key: GlobalKey(),
                                controller: controller,
                                child: IconButton(
                                    icon: Icon(
                                      FluentIcons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => showFlyDelete(
                                        "Are you sure?",
                                        "yeh",
                                        controller,
                                        FlyoutPlacementMode.topCenter,
                                        software.id,
                                        onActionCaller))),
                            IconButton(
                                icon: const Icon(FluentIcons.edit), onPressed: ()=>onActionCaller!("edit&&${software.id}"))
                          ],
                        )),
                    Expanded(
                        flex: 70,
                        child: IconButton(
                          onPressed: ()=>onActionCaller!('goto&&${software.id}'),
                          icon: Text(
                            Strings.allGroups,
                            style: TextSystem.textS(Colors.white),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
