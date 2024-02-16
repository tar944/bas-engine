import 'package:bas_dataset_generator_engine/assets/values/dimens.dart';
import 'package:bas_dataset_generator_engine/assets/values/strings.dart';
import 'package:bas_dataset_generator_engine/assets/values/textStyle.dart';
import 'package:bas_dataset_generator_engine/src/items/labelingObjectItem.dart';
import 'package:bas_dataset_generator_engine/src/parts/LabelingDetails.dart';
import 'package:bas_dataset_generator_engine/src/parts/regionManager.dart';
import 'package:bas_dataset_generator_engine/src/parts/topBarPanel.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:go_router/go_router.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:window_manager/window_manager.dart';

class LabelingPage extends HookWidget with WindowListener {
  int? groupId;

  LabelingPage(this.groupId ,{super.key});

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);

    windowManager.waitUntilReadyToShow().then((_) async {
      if (kIsLinux || kIsWindows) {
        if (kIsLinux) {
          await windowManager.setAsFrameless();
        } else {
          await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        }
        await windowManager.setPosition(Offset.zero);
      }
      await windowManager.setSkipTaskbar(true);
      await windowManager.setFullScreen(true);
      await Future.delayed(const Duration(milliseconds: 100));
      await _windowShow();
    });
  }

  Future<void> _windowShow({
    bool isShowBelowTray = false,
  }) async {
    bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
    if (kIsLinux) {
      await windowManager.setPosition(Offset.zero);
    }

    bool isVisible = await windowManager.isVisible();
    if (!isVisible) {
      await windowManager.show();
    } else {
      await windowManager.focus();
    }

    if (kIsLinux && !isAlwaysOnTop) {
      await windowManager.setAlwaysOnTop(true);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.setAlwaysOnTop(false);
      await Future.delayed(const Duration(milliseconds: 10));
      await windowManager.focus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listData = useState([]);
    final indexImage = useState(0);
    final selectedScreenId = useState(-1);
    final selectedPartId = useState(-1);
    final curList = useState('screen');

    setScreenAsData() async {
      // curList.value = 'screen';
      // final group = await RecordedScreenGroupDAO().getGroup(groupId!);
      // if (group!.screenShoots.toList().isNotEmpty) {
      //   listData.value = group.screenShoots
      //       .toList()
      //       .map((e) => LabelingDataModel(curList.value)..screen = e)
      //       .toList();
      //   if(selectedScreenId.value!=-1){
      //     for (final screen in listData.value) {
      //       if (screen.getId() == selectedScreenId.value) {
      //         indexImage.value = listData.value.indexOf(screen);
      //         break;
      //       }
      //     }
      //   }
      // }
    }

    setPartAsData(int screenId) async{
      // ScreenShootModel? screen =
      //     await ScreenDAO().getScreen(screenId);
      // curList.value = 'part';
      // listData.value = screen!.partsList
      //     .toList()
      //     .map((e) => LabelingDataModel(curList.value)..part = e)
      //     .toList();
      // if(selectedPartId.value!=-1){
      //   for (final part in listData.value) {
      //     if (part.getId() == selectedPartId.value) {
      //       indexImage.value = listData.value.indexOf(part);
      //       break;
      //     }
      //   }
      // }
    }

    setObjectAsData(int partId) async{
      // RegionDataModel? part =
      //     await PartDAO().getPart(partId);
      // curList.value = 'object';
      // listData.value = part!.objectsList
      //     .toList()
      //     .map((e) => LabelingDataModel(curList.value)..object = e)
      //     .toList();
    }

    useEffect(() {
      _init();
      Future<void>.microtask(() async {
        await setScreenAsData();
        for (final screen in listData.value) {
          if (screen.getStatus() == 'created') {
            indexImage.value = listData.value.indexOf(screen);
            break;
          }
        }
      });
      return null;
    }, const []);

    nextImage() {
      indexImage.value = ++indexImage.value;
      if (indexImage.value == listData.value.length) {
        return indexImage.value = 0;
      }
    }

    perviousImage() {
      if (indexImage.value == 0) return;
      indexImage.value = --indexImage.value;
    }

    doScreenAction(String action) async {
      var actions = action.split('&&');
      switch (actions[0]) {
        case 'refreshParts':
          await setScreenAsData();
          break;
        case 'edit':
          // ScreenShootModel? screen =
          //     await ScreenDAO().getScreen(int.parse(actions[1]));
          // screen!.type = actions[2];
          // screen.description = actions[3];
          // screen.status = 'finished';
          // await ScreenDAO().updateScreen(screen);
          // await setScreenAsData();
          break;
        case 'delete':
          // ScreenShootModel? screen =
          //     await ScreenDAO().getScreen(int.parse(actions[1]));
          // await ScreenDAO().deleteScreen(screen!);
          // await setScreenAsData();
          break;
        case 'show':
          // ScreenShootModel? screen =
          //     await ScreenDAO().getScreen(int.parse(actions[1]));
          // for (final item in listData.value) {
          //   if (item.getId() == screen!.id) {
          //     indexImage.value = listData.value.indexOf(item);
          //     break;
          //   }
          // }
          break;
        case 'goto':
          selectedScreenId.value = listData.value[indexImage.value].getId();
          indexImage.value = 0;
          setPartAsData(selectedScreenId.value);
          break;
      }
    }

    doPartAction(String action) async {
      var actions = action.split('&&');
      switch (actions[0]) {
        case 'refreshObjects':
          await setPartAsData(selectedScreenId.value);
          break;
        case 'edit':
          // RegionDataModel? part =
          //     await PartDAO().getPart(int.parse(actions[1]));
          // part!.type = actions[2];
          // part.description = actions[3];
          // part.status = 'finished';
          // await PartDAO().updatePart(part);
          // await setPartAsData(selectedScreenId.value);
          break;
        case 'delete':
          // RegionDataModel? part =
          //     await PartDAO().getPart(int.parse(actions[1]));
          // await PartDAO().deletePart(part!);
          // await setPartAsData(selectedScreenId.value);
          break;
        case 'show':
          // RegionDataModel? part =
          //     await PartDAO().getPart(int.parse(actions[1]));
          // for (final item in listData.value) {
          //   if (item.getId() == part!.id) {
          //     indexImage.value = listData.value.indexOf(item);
          //     break;
          //   }
          // }
          break;
        case 'goto':
          selectedPartId.value = listData.value[indexImage.value].getId();
          indexImage.value = 0;
          setObjectAsData(selectedPartId.value);
          break;
      }
    }

    doObjectAction(String action) async{
      var actions = action.split('&&');
      switch (actions[0]) {
        case 'edit':
          // RegionDataModel? object =
          //     await PartObjectDAO().getObject(int.parse(actions[1]));
          // object!.type = actions[2];
          // object.actionOne = actions[3];
          // object.actionTwo = actions[4];
          // object.status = 'finished';
          // await PartObjectDAO().updateObject(object);
          // await setObjectAsData(selectedPartId.value);
          break;
        case 'delete':
          // RegionDataModel? object =
          //     await PartObjectDAO().getObject(int.parse(actions[1]));
          // await PartObjectDAO().deleteObject(object!);
          // await setObjectAsData(selectedPartId.value);
          break;
        case 'show':
          // RegionDataModel? object = await PartObjectDAO().getObject(int.parse(actions[1]));
          // for (final item in listData.value) {
          //   if (item.getId() == object!.id) {
          //     indexImage.value = listData.value.indexOf(item);
          //     break;
          //   }
          // }
          break;
      }
    }

    onActionHandler(String action) async {
      switch (curList.value) {
        case 'screen':
          doScreenAction(action);
          break;
        case 'part':
          doPartAction(action);
          break;
        case 'object':
          doObjectAction(action);
          break;
      }
    }

    onBackClicked(){
      context.goNamed('mainPage');
    }

    return ScaffoldPage(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        content: SizedBox.expand(
          child: Column(children: [
            TopBarPanel(
              title: listData.value.isNotEmpty
                  ? '${'${Strings.pageLabeling}   ( ' + listData.value[indexImage.value].getName()} )'
                  : Strings.pageLabeling,
              needBack: true,
              needHelp: false,
              onBackCaller: onBackClicked,
            ),
            if (listData.value.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey[150],
                  child: Column(
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
                        'your Screen list is empty...',
                        style: TextSystem.textL(Colors.white),
                      ),
                    ],
                  ),
                ),
              )
            else
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        (Dimens.topBarHeight),
                    color: Colors.grey[180],
                    child: RegionManager(
                      itemKind: curList.value,
                      item: listData.value[indexImage.value],
                      nextClick: nextImage,
                      perviousClick: perviousImage,
                      onPartsChanged: onActionHandler,
                    ),
                  ),
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (listData.value[indexImage.value]
                                      .getDescription() !=
                                  null &&
                              listData.value[indexImage.value]
                                      .getDescription() !=
                                  '')
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 10.0,
                                      left: 8.0,
                                      right: 8.0),
                                  child: Text(
                                    'Description : ${listData.value[indexImage.value].getDescription()}',
                                    style: TextSystem.textM(Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                if (curList.value != 'screen')
                                  IconButton(
                                      style: ButtonStyle(
                                          padding: ButtonState.all(
                                              const EdgeInsets.only(
                                                  right: 10))),
                                      icon: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                          ),
                                          child: const Icon(
                                            FluentIcons.chevron_left_med,
                                            size: 25,
                                          )),
                                      onPressed: () async {
                                        if(curList.value=='part') {
                                          await setScreenAsData();
                                          selectedScreenId.value = -1;
                                        }else if(curList.value=='object'){
                                          await setPartAsData(selectedScreenId.value);
                                          selectedPartId.value = -1;
                                        }
                                      }),
                                LabelingDetails(
                                  onActionCaller: onActionHandler,
                                  data: listData.value[indexImage.value],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Container(
                              height: 110,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 5, bottom: 5),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey),
                                  child: ListView.builder(
                                      itemCount: listData.value.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return LabelingObjectItem(
                                          data: listData.value[index],
                                          onActionCaller: onActionHandler,
                                          isSelected: indexImage.value == index,
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              )
          ]),
        ));
  }
}