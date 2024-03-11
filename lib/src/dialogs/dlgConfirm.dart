import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showConfirmDialog(
    BuildContext context,
    String message,
    String title,
    ValueSetter<String>? onActionListener) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title,style: TextSystem.textLB(Colors.white),),
      content: Text(message),
      actions: [
        Button(
          child: const Text(Strings.cancel),
          onPressed: () {
            onActionListener!("decline");
            Navigator.pop(context);
          },
        ),
        FilledButton(
          child: const Text(Strings.confirm),
          onPressed: () {
            onActionListener!("confirm");
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
