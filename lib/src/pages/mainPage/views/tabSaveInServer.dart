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
        required this.uploadDomain,
        required this.authToken
      }) : super(key: key);

  String uploadDomain,authToken;
  TextEditingController domainController;
  TextEditingController tokenController;

  @override
  Widget build(BuildContext context) {
    final isChecked=useState(false);
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
          const SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(Strings.uploadDomain,style: TextSystem.textS(Colors.white),),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                height: 35,
                child: TextBox(
                  controller: domainController,
                  placeholder: Strings.domainHint,
                  expands: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(checked: isChecked.value, onChanged: (e)=>isChecked.value=e!),
              Text(Strings.dirPath,style: TextSystem.textS(isChecked.value?Colors.white:Colors.white.withOpacity(0.5)),),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 500,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.grey[190],
                    border: Border.all(color:Colors.grey[170]),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))
                ),
                child: TextBox(
                  controller: domainController,
                  placeholder: Strings.dirPathHint,
                  expands: false,
                  enabled: isChecked.value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(FluentIcons.warning,color: Colors.orange.dark,size: 18,),
              const SizedBox(
                height: 10,
              ),
              Text(Strings.uploadWarning,style: TextSystem.textS(Colors.white.withOpacity(0.5)),)
            ],
          ),
        ],
      ),
    );
  }
}
