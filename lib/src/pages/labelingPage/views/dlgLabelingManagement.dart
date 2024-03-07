import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/items/dlgLabelManagementItem.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/viewModels/labelManagementViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage/views/dlgTabView.dart';
import 'package:bas_dataset_generator_engine/src/parts/dialogTitleBar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class DlgLabelManagement extends StatelessWidget {
  DlgLabelManagement({
    Key? key,
    required this.labelList,
    required this.onActionCaller,
  }) : super(key: key);

  final ValueSetter<String> onActionCaller;
  final List<LabelModel> labelList;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel:
      LabelManagementViewModel(labelList, onActionCaller),
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
            width: Dimens.dialogNormalWidth,
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
                    title: Strings.dlgLabeling,
                    onActionListener: vm.onCloseClicked,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15,bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(Strings.createNewLabel),
                        const SizedBox(height: 5,),
                        SizedBox(
                          width: double.infinity,
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 82,
                                child: TextBox(
                                  controller: vm.ctlTitle,
                                  placeholder: Strings.dlgSoftwareTitleHint,
                                  expands: false,
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Expanded(
                                  flex: 7,
                                  child: IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(const EdgeInsets.all(6))),
                                      icon: Icon(
                                        FluentIcons.save,
                                        size: 20,
                                        color: Colors.blue.lighter,
                                      ),
                                      onPressed: () => vm.onActionHandler('create&&${vm.ctlTitle.text}'))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabView(
                      currentIndex: vm.curIndex,
                      onChanged: (index) => vm.onTabChanged(index),
                      tabWidthBehavior: TabWidthBehavior.sizeToContent,
                      closeButtonVisibility: CloseButtonVisibilityMode.never,
                      showScrollButtons: true,
                      onNewPressed: ()=>vm.onNewLevelHandler(),
                      tabs: vm.allLevels.map((e) {
                        return Tab(
                          text: Text(e),
                          semanticLabel: e,
                          body: DlgTabView(
                              allLabels: vm.allLabels.where((element) => vm.allLevels.contains(element.levelName)).toList(),
                              onActionCaller: vm.onLabelActionHandler)
                        );
                      }).toList(),
                    )
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
