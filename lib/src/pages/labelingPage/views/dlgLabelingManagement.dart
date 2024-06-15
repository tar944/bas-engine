import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelManagementViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgTabView.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgLabelManagement extends StatelessWidget {
  DlgLabelManagement({
    Key? key,
    required this.labelList,
    required this.prjUUID,
    required this.returnAction,
    required this.onActionCaller,
  }) : super(key: key);

  final ValueSetter<String> onActionCaller;
  final List<LabelModel> labelList;
  final String prjUUID,returnAction;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      LabelManagementViewModel(prjUUID,labelList,returnAction, onActionCaller),
    );
  }
}

class _View extends StatelessView<LabelManagementViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, LabelManagementViewModel vm) {

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: Dimens.dialogLargeWidth,
            height: Dimens.dialogLargeHeight+100,
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
                    title: Strings.dlgLabeling,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TabView(
                        currentIndex: vm.curIndex,
                        onChanged: (index) => vm.onTabChanged(index),
                        tabWidthBehavior: TabWidthBehavior.sizeToContent,
                        closeButtonVisibility: CloseButtonVisibilityMode.onHover,
                        showScrollButtons: true,
                        onNewPressed: ()=>vm.onNewLevelHandler(),
                        tabs: vm.allLevels.map((e) {
                          return Tab(
                            text: Text(e),
                            semanticLabel: e,
                            onClosed: ()=>vm.onTabClosed(e),
                            icon: null,
                            body: DlgTabView(
                              key: GlobalKey(),
                                allLabels: vm.allLabels.where((element) => element.levelName==e).toList(),
                                lvlName: e,
                                selLabelId: vm.selectedLabel==null?-1:vm.selectedLabel!.id,
                                onActionCaller: vm.onLabelActionHandler)
                          );
                        }).toList(),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        Container(
                          width: Dimens.circleW,
                          height: Dimens.circleW,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey[170])
                          ),
                          child: Text("1",style: TextSystem.textL(Colors.orange.dark),),
                        ),
                        const SizedBox(width: 10,),
                        Text(Strings.labelFirstStep,style: TextSystem.textM(Colors.white),)
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: vm.selectedLabel==null?0.3:1.0,
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Container(
                              width: Dimens.circleW,
                              height: Dimens.circleW,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey[170])
                              ),
                              child: Text("2",style: TextSystem.textL(Colors.orange.dark),),
                            ),
                            const SizedBox(width: 10,),
                            Text("${Strings.labelSecondStep} ${vm.selectedLabel==null?"label":vm.selectedLabel!.name}: "),
                            SizedBox(
                              width: 250,
                              height: 35,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextBox(
                                      enabled: vm.selectedLabel!=null,
                                      controller: vm.ctlName,
                                      placeholder: Strings.dlgSoftwareTitleHint,
                                      expands: false,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(const EdgeInsets.all(6))),
                                      icon: Icon(FluentIcons.check_mark, size: 20, color: Colors.green.dark,
                                      ),
                                      onPressed: vm.selectedLabel==null?null:() =>
                                          vm.onLabelActionHandler('saveName&&${vm.ctlName.text}')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            )),
      ],
    );
  }
}
