import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/viewModels/imageGroupViewModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/imageGroupPage/views/objectItem.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class ImageGroups extends StatelessWidget {
  ImageGroups(
      {super.key, required this.partId, required this.onGroupActionCaller});

  int partId;
  ValueSetter<String> onGroupActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: ImageGroupsViewModel(partId, onGroupActionCaller),
    );
  }
}

class _View extends StatelessView<ImageGroupsViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, ImageGroupsViewModel vm) {
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: vm.objects.isNotEmpty
              ? GridView(
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 3.2 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20),
                children: vm.objects
                    .map((item) => ObjectItem(
                          key: GlobalKey(),
                          object: item,
                          isSelected: vm.selectedObjects.contains(item.id),
                          onActionCaller: vm.onObjectActionHandler,
                        ))
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
                          image: AssetImage('lib/assets/images/emptyBox.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      Strings.emptyPart,
                      style: TextSystem.textL(Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
