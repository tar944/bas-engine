import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';

class TabSaveInPC extends StatelessWidget {
    TabSaveInPC(
      {
        Key? key,
        required this.pathController,
        required this.exportPath,
      }) : super(key: key);

  final String exportPath;
  final TextEditingController pathController;

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
          const SizedBox(
            height: 10,
          ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(Strings.dirPath,style: TextSystem.textS(Colors.white),),
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
                            child: IconButton(onPressed: (){},icon: const Icon(FluentIcons.folder_horizontal,size: 17,),))
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}