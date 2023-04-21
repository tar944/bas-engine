import 'package:bas_dataset_generator_engine/src/models/softwareModel.dart';
import 'package:bas_dataset_generator_engine/src/widgets/CButton.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../assets/values/dimens.dart';
import '../../assets/values/textStyle.dart';
import '../utility/measureSize.dart';

class SoftwareItem extends HookWidget {
  const SoftwareItem(
      {Key? key, required this.software, required this.onActionListener})
      : super(key: key);

  final SoftwareModel software;
  final ValueSetter<String>? onActionListener;

  @override
  Widget build(BuildContext context) {
    var size = useState(const Size(213.3, 284.4));

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
              border: Border.all(color: Colors.magenta, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: (size.value.width - 57),
                        child: Text(
                          software.title!,
                          style: TextSystem.textS(Colors.white),
                          maxLines: 2,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5.0,
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
                      flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Videos'),
                    )),
                    Expanded(
                      flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Text('Main pages',style: TextSystem.textM(Colors.blue.lighter),),
                    ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
