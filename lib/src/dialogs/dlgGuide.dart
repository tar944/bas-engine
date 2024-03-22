import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/preferences/preferencesData.dart';
import 'package:fluent_ui/fluent_ui.dart';

void showGuideDialog(
    BuildContext context,
    String message,
    String title,
    String guideName) async {
  await showDialog<String>(
    context: context,
    builder: (context) => ContentDialog(
      title: Text(title),
      style: ContentDialogThemeData(
        titleStyle: TextSystem.textS(Colors.white),
        bodyStyle: TextSystem.textM(Colors.white)
      ),
      content: Text(message),
      actions: [
        Button(
          child: const Text(Strings.GotIt),
          onPressed: () async{
            await Preference().setShowGuide(guideName,false);
            Navigator.pop(context);
          },
        ),
        FilledButton(
          child: const Text(Strings.ok),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
