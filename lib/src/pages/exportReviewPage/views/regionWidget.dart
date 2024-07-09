import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/src/data/models/objectModel.dart';
import 'package:bas_dataset_generator_engine/src/data/models/pascalObjectModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/cutToPiecesPage/views/rectanglePainter.dart';
import 'package:bas_dataset_generator_engine/src/pages/exportReviewPage/viewModels/regionViewModel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:pmvvm/pmvvm.dart';

class RegionWidget extends StatelessWidget {
  RegionWidget({
    Key? key,
    required this.mainObjUUID,
    required this.activeObjUUID,
    required this.curObject,
    required this.width,
    required this.height,
    required this.onObjectActionCaller,
  }) : super(key: key);

  final PascalObjectModel curObject;
  final String mainObjUUID,activeObjUUID;
  final double width,height;
  final ValueSetter<String> onObjectActionCaller;

  @override
  Widget build(BuildContext context) {
    return MVVM(
      view: () => const _View(),
      viewModel: RegionViewModel(mainObjUUID,activeObjUUID,curObject,width,height, onObjectActionCaller),
    );
  }
}

class _View extends StatelessView<RegionViewModel> {
  const _View({Key? key}) : super(key: key);

  @override
  Widget render(context, RegionViewModel vm) {
   return Tooltip(
     message: vm.curObject.exportName!.replaceAll('**', '.'),
     child: MouseRegion(
       onEnter:(e)=> vm.onHoverHandler(true),
       onExit: (e)=> vm.onHoverHandler(false),
       child: GestureDetector(
         onTapUp: (e)=>vm.onClickHandler(e),
         onSecondaryTapUp: (e)=>vm.onRightClickHandler(),
         onTertiaryTapUp: (e)=>vm.onMiddleHandler(),
         child: FlyoutTarget(
            key: vm.objectKey,
           controller: vm.objectController,
           child: Stack(
             children: [
               SizedBox(
                width: vm.width,
                height: vm.height,
                child: CustomPaint(
                  painter: RectanglePainter(
                      object: ObjectModel(0, "", 0.0,
                        vm.width,
                          0.0,
                        vm.height,
                      ),
                      color: vm.getColor(),
                      isActive: vm.isHover||vm.activeObjUUID==vm.curObject.objUUID),
                ),
              ),
               if(vm.activeObjUUID!=Strings.notSet)
                Positioned(
                  left: 3,
                  top: 3,
                  child: Row(
                     children: [
                       IconButton(
                            style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                           icon: Container(
                             width: vm.getSize(),
                             height: vm.getSize(),
                             decoration: BoxDecoration(
                               color: vm.curObject.dirKind!.contains('train')?Colors.teal.dark:Colors.teal.dark.withOpacity(.3),
                                 borderRadius: BorderRadius.all(Radius.circular(vm.getSize()/2))
                             ),
                           ),
                           onPressed: ()=>vm.onDivisionHandler('train')),
                       const SizedBox(width: 3,),
                       IconButton(
                           style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                           icon: Container(
                             width: vm.getSize(),
                             height: vm.getSize(),
                             decoration: BoxDecoration(
                               color: vm.curObject.dirKind!.contains('valid')?Colors.orange.dark:Colors.orange.dark.withOpacity(.3),
                                 borderRadius: BorderRadius.all(Radius.circular(vm.getSize()/2))
                             ),
                           ),
                           onPressed: ()=>vm.onDivisionHandler('valid')),
                       const SizedBox(width: 3,),
                       IconButton(
                           style: ButtonStyle(padding: ButtonState.all(EdgeInsets.zero)),
                           icon: Container(
                             width: vm.getSize(),
                             height: vm.getSize(),
                             decoration: BoxDecoration(
                               color: vm.curObject.dirKind!.contains('test')?Colors.magenta.dark:Colors.magenta.dark.withOpacity(.3),
                               borderRadius: BorderRadius.all(Radius.circular(vm.getSize()/2))
                             ),
                           ),
                           onPressed: ()=>vm.onDivisionHandler('test')),
                     ],
                   ))
             ]
           ),
         ),
       ),
     ),
   );
  }
}