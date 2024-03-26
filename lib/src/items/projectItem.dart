import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/projectModel.dart';
import 'package:bas_dataset_generator_engine/src/dialogs/flyDlgConfirm.dart';
import 'package:bas_dataset_generator_engine/src/utility/measureSize.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProjectItem extends HookWidget {
  const ProjectItem(
      {Key? key, required this.project, required this.onActionCaller})
      : super(key: key);

  final ProjectModel project;
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
                    project.title!,
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
                      project.description!,
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
                                    onPressed: () => showFlyConfirm(
                                        Strings.deleteProject,
                                        Strings.yes,
                                        controller,
                                        FlyoutPlacementMode.topCenter,
                                        "delete&&${project.id}",
                                        onActionCaller))),
                            IconButton(
                                icon: const Icon(FluentIcons.edit),
                                onPressed: () =>
                                    onActionCaller!("edit&&${project.id}"))
                          ],
                        )),
                    Expanded(
                        flex: 70,
                        child: IconButton(
                          onPressed: () =>
                              onActionCaller!('goto&&${project.id}'),
                          icon: Text(
                            Strings.allParts,
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
