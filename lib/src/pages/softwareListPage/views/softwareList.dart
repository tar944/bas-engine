
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/softwareDAO.dart';
import 'package:bas_dataset_generator_engine/src/pages/softwareListPage/views/dlgNewSoftware.dart';
import 'package:bas_dataset_generator_engine/src/items/softwareItem.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../assets/values/dimens.dart';
import '../../../../assets/values/strings.dart';
import '../../../data/models/softwareModel.dart';
import '../../../parts/addsOnPanel.dart';
import '../../../parts/topBarPanel.dart';
import '../../../utility/platform_util.dart';

class SoftwareList extends HookWidget{

  void _init() async {
  }

  @override
  Widget build(BuildContext context) {
    final software = useState([]);

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        software.value = await SoftwareDAO().getAllSoftware();
      });
      return null;
    }, const []);

    void onCreateCourseHandler(SoftwareModel curSoftware) async {
      final id = await SoftwareDAO().updateSoftware(curSoftware);
      await DirectoryManager().createSoftwareDir('${id}_${curSoftware.title!}');
      software.value = await SoftwareDAO().getAllSoftware();
    }

    void onSoftwareSelect(String action) async{
      SoftwareModel? soft =  await SoftwareDAO().getSoftware(int.parse(action.split('&&')[1]));
      switch(action.split('&&')[0]){
        case 'edit':
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) =>DlgNewSoftware(onSaveCaller: onCreateCourseHandler,software:soft),);
          break;
        case 'delete':
          await SoftwareDAO().deleteSoftware(soft!);
          software.value = await SoftwareDAO().getAllSoftware();
          break;
        case 'goto':
          context.goNamed('screensSource',params: {'softwareId':soft!.id.toString()});
          break;
      }
    }

    void onNewSoftwareHandler(String action) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) =>
              DlgNewSoftware(onSaveCaller: onCreateCourseHandler));
    }

    return Container(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20,left: 20,right: 20),
        child: software.value.isNotEmpty
            ? GridView(
          controller: ScrollController(
              keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate:
          const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 3 / 1.8,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20),
          children: software.value
              .map((item) => SoftwareItem(
              software: item,
              onActionCaller:
              onSoftwareSelect))
              .toList(),
        )
            : Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Container(
              height: 350,
              width: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/assets/images/emptyBox.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              Strings.emptySoftware,
              style: TextSystem.textL(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
