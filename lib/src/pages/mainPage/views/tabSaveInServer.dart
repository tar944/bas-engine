import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TabSaveInServer extends HookWidget {
  TabSaveInServer(
      {
        Key? key,
        required this.domainController,
        required this.tokenController,
        required this.needToken,
        required this.onAuthCaller,
      }) : super(key: key);

  final bool needToken;
  final TextEditingController domainController;
  final TextEditingController tokenController;
  final ValueSetter<String> onAuthCaller;

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
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10,top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("${Strings.uploadDomain}:",style: TextSystem.textS(Colors.white),),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  width: Dimens.dialogBigWidth-150,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Colors.grey[190],
                      border: Border.all(color:Colors.grey[170]),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0))
                  ),
                  child: Expanded(
                    child: TextBox(
                      controller: domainController,
                      placeholder: Strings.domainHint,
                      expands: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10,top: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(Strings.needBackUp,style: TextSystem.textS(Colors.white),),
                const SizedBox(
                  width: 8,
                ),
                ToggleSwitch(
                  checked: needToken,
                  content: Text(needToken ? 'Auth ON' : 'Auth OFF'),
                  onChanged: (bool value) => onAuthCaller(value?"authOn":"authOff"),
                )
              ],
            ),
          ),
          Opacity(
            opacity: needToken?1.0:0.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10,top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${Strings.authToken}:",style: TextSystem.textS(Colors.white),),
                  const SizedBox(
                    width: 22,
                  ),
                  Container(
                    width: Dimens.dialogBigWidth-150,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Colors.grey[190],
                        border: Border.all(color:Colors.grey[170]),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Expanded(
                      child: TextBox(
                        controller: tokenController,
                        placeholder: Strings.authTokenHint,
                        expands: false,
                        enabled: needToken,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
