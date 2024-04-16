import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/viewModels/exportViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/tabSaveInPC.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/tabSaveInServer.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgExport extends StatelessWidget {
  const DlgExport({
    Key? key,
    required this.prjName,
    required this.prjUUID,
    required this.onExportCaller
  }) : super(key: key);

  final String prjUUID,prjName;
  final ValueSetter<String> onExportCaller;
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      ExportViewModel(prjUUID,prjName,onExportCaller),
    );
  }
}

class _View extends StatelessView<ExportViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ExportViewModel vm) {

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogBigWidth,
            height: Dimens.dialogLargeHeight-20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimens.dialogCornerRadius)),
                color: Colors.grey[190],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DialogTitleBar(
                    title: Strings.dlgExportTitle,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      Text(vm.prjName),
                      const SizedBox(width: 10,),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[160]),
                            borderRadius: const BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 8,right: 8,bottom: 11),
                          child: Text(vm.prjName),
                        ),
                      )
                    ],),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TabView(
                          currentIndex: vm.curIndex,
                          onChanged: (index) => vm.onTabChanged(index),
                          tabWidthBehavior: TabWidthBehavior.sizeToContent,
                          closeButtonVisibility: CloseButtonVisibilityMode.never,
                          showScrollButtons: true,
                          onNewPressed: null,
                          tabs: [Strings.inPc,Strings.inAServer].map((e) {
                            return Tab(
                                text: Text(e),
                                semanticLabel: e,
                                onClosed: null,
                                icon: e==Strings.inPc?const Icon(FluentIcons.this_p_c):const Icon(FluentIcons.cloud_upload),
                                body: e==Strings.inPc?
                                TabSaveInPC(pathController:
                                  vm.pathController,
                                  needBackup: vm.needBackup,
                                  selectFolderCaller: (e)=>vm.saveInPcHandler(e),):
                                TabSaveInServer(domainController: vm.domainController, tokenController: vm.tokenController, uploadDomain: "", authToken: "")
                            );
                          }).toList(),
                        ),
                      )
                  ),
                  Container(
                    height: 70,
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(Dimens.dialogCornerRadius),bottomLeft: Radius.circular(Dimens.dialogCornerRadius)),
                      color: Colors.grey[210]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Button(
                        style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.orange.dark),
                          padding: ButtonState.all(const EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10))
                        ),
                        onPressed: vm.onExportBtnHandler(),
                        child: Text(Strings.export,style: TextSystem.textM(Colors.white),),
                      ),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}