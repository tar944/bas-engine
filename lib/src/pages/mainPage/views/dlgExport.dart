import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/viewModels/exportViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/tabSaveInPC.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/tabSaveInServer.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgExport extends StatelessWidget {
  const DlgExport({
    Key? key,
    required this.prjName
  }) : super(key: key);

  final String prjName;
  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      ExportViewModel(prjName),
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
            height: Dimens.dialogLargeHeight,
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
                  Row(children: [
                    const Text(Strings.projectName),
                    const SizedBox(width: 10,),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[160]),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Text(vm.prjName),
                    )
                  ],),
                  Row(children: [
                    Text(Strings.exportFormat),
                    SizedBox(width: 10,),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: Colors.grey[170])
                      ),
                      child: Row(
                        children: [
                          RadioButton(checked: false, onChanged: (e){}),
                          Text("Text"),
                          RadioButton(checked: false, onChanged: (e){}),
                          Text("Yaml"),
                          RadioButton(checked: false, onChanged: (e){}),
                          Text("Json"),
                        ],
                      ),
                    )
                  ],),
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
                                  TabSaveInPC(pathController: vm.pathController, exportPath: ""):
                                  TabSaveInServer(domainController: vm.domainController, tokenController: vm.tokenController, uploadDomain: "", authToken: "")
                            );
                          }).toList(),
                        ),
                      )
                  ),
                ],
              ),
            )),
      ],
    );
  }
}