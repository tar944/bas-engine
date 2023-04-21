import 'package:fluent_ui/fluent_ui.dart';
import '../../assets/values/strings.dart';

void showContentDialog(BuildContext context, bool hasChanges,
    ValueSetter<String>? onActionListener) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: const Text(Strings.exitTitle),
      content: hasChanges ? const Text(Strings.exitWarnString) : null,
      actions: [
        Button(
          child: const Text(Strings.cancel),
          onPressed: () {
            onActionListener!("decline");
            Navigator.pop(context);
          },
        ),
        FilledButton(
          child: Text(hasChanges ? Strings.saveAndExit : Strings.confirm),
          onPressed: () {
            onActionListener!("confirm");
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
