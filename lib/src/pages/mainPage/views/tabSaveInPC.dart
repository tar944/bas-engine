import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TabSaveInPC extends StatelessWidget {
    TabSaveInPC(
      {
        Key? key,
        required this.pathController,
        required this.needBackup,
        required this.selectFolderCaller
      }) : super(key: key);

  final bool needBackup;
  final TextEditingController pathController;
  final ValueSetter<String> selectFolderCaller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[170],width: 2.0),
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          color: Colors.grey[180]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10,top: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${Strings.dirPath}:",style: TextSystem.textS(Colors.white),),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: Dimens.dialogBigWidth-150,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.grey[190],
                        border: Border.all(color:Colors.grey[170]),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Stack(
                      children: [
                        Expanded(
                          child: TextBox(
                            controller: pathController,
                            placeholder: Strings.dirPathHint,
                            expands: false,
                          ),
                        ),
                        Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: ()=>selectFolderCaller("chosePath"),
                              icon: const Icon(FluentIcons.folder_horizontal,size: 17,),))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10,top: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(Strings.needBackUp,style: TextSystem.textS(Colors.white),),
                  const SizedBox(
                    width: 10,
                  ),
                  ToggleSwitch(
                    checked: needBackup,
                    content: Text(needBackup ? 'Backup ON' : 'Backup OFF'),
                    onChanged: (bool value) => selectFolderCaller(value?"backupOn":"backupOff"),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
