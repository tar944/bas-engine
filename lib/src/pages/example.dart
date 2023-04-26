//
// import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:simple_animations/animation_builder/custom_animation_builder.dart';
// import 'package:window_manager/window_manager.dart';
// import '../../assets/values/dimens.dart';
// import '../../assets/values/strings.dart';
//
// import '../utility/platform_util.dart';
//
// class StudioPage extends HookWidget with WindowListener {
//   const StudioPage({super.key});
//
//   void _init() async {
//     // Add this line to override the default close handler
//     await windowManager.setPreventClose(true);
//
//     windowManager.waitUntilReadyToShow().then((_) async {
//       if (kIsLinux || kIsWindows) {
//         if (kIsLinux) {
//           await windowManager.setAsFrameless();
//         } else {
//           await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
//         }
//         await windowManager.setPosition(Offset.zero);
//       }
//       await windowManager.setSkipTaskbar(true);
//       await windowManager.setFullScreen(true);
//       await Future.delayed(const Duration(milliseconds: 100));
//       await _windowShow();
//     });
//   }
//
//   Future<void> _windowShow({
//     bool isShowBelowTray = false,
//   }) async {
//     bool isAlwaysOnTop = await windowManager.isAlwaysOnTop();
//     if (kIsLinux) {
//       await windowManager.setPosition(Offset.zero);
//     }
//
//     bool isVisible = await windowManager.isVisible();
//     if (!isVisible) {
//       await windowManager.show();
//     } else {
//       await windowManager.focus();
//     }
//
//     if (kIsLinux && !isAlwaysOnTop) {
//       await windowManager.setAlwaysOnTop(true);
//       await Future.delayed(const Duration(milliseconds: 10));
//       await windowManager.setAlwaysOnTop(false);
//       await Future.delayed(const Duration(milliseconds: 10));
//       await windowManager.focus();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedTools = useState('none');
//     final addsOnAnimType = useState('close');
//     final selectedAdds = useState('none');
//     final toolsAnimType = useState('close');
//     final selectedParts = useState('none');
//
//     final chapterState = useState(PanelStates.isClose);
//     final lessonState = useState(PanelStates.isClose);
//     final groupState = useState(PanelStates.isClose);
//     final actionState = useState(PanelStates.isClose);
//
//     useEffect(() {
//       _init();
//       return null;
//     }, const []);
//
//     onToolsSelectedListener(String action) {
//       if (action != selectedTools.value) {
//         toolsAnimType.value =
//         toolsAnimType.value == "close" ? "opening" : "closeOpen";
//         selectedTools.value = action;
//       } else {
//         toolsAnimType.value = 'closing';
//         selectedTools.value = 'none';
//       }
//     }
//
//     onAddsOnSelectedListener(String action) {
//       print(action);
//       if (action != selectedAdds.value) {
//         addsOnAnimType.value =
//         addsOnAnimType.value == "close" ? "opening" : "closeOpen";
//         selectedAdds.value = action;
//       } else {
//         addsOnAnimType.value = 'closing';
//         selectedAdds.value = 'none';
//       }
//     }
//
//     addsOnAnimStatusListener(AnimationStatus status) {
//       if (status == AnimationStatus.dismissed ||
//           status == AnimationStatus.completed) {
//         if (addsOnAnimType.value == 'closeOpen') {
//           addsOnAnimType.value = "opening";
//         } else if (addsOnAnimType.value == 'closing') {
//           addsOnAnimType.value = "close";
//         } else if (addsOnAnimType.value == 'opening') {
//           addsOnAnimType.value = 'open';
//         }
//       }
//     }
//
//     toolsOnAnimStatusListener(AnimationStatus status) {
//       if (status == AnimationStatus.dismissed ||
//           status == AnimationStatus.completed) {
//         if (toolsAnimType.value == 'closeOpen') {
//           toolsAnimType.value = "opening";
//         } else if (toolsAnimType.value == 'closing') {
//           toolsAnimType.value = "close";
//         } else if (toolsAnimType.value == 'opening') {
//           toolsAnimType.value = 'open';
//         }
//       }
//     }
//
//     panelsAnimStatusListener(AnimationStatus status, String kind) {
//       if (status != AnimationStatus.completed &&
//           status != AnimationStatus.dismissed) {
//         return;
//       }
//       switch (kind) {
//         case Strings.chapters:
//           chapterState.value = status == AnimationStatus.completed
//               ? PanelStates.isOpen
//               : PanelStates.isClose;
//           selectedParts.value = chapterState.value == PanelStates.isOpen
//               ? Strings.chapters
//               : 'none';
//           break;
//         case Strings.lessons:
//           lessonState.value = status == AnimationStatus.completed
//               ? PanelStates.isOpen
//               : PanelStates.isClose;
//           selectedParts.value = lessonState.value == PanelStates.isOpen
//               ? Strings.lessons
//               : Strings.chapters;
//           break;
//         case Strings.groups:
//           groupState.value = status == AnimationStatus.completed
//               ? PanelStates.isOpen
//               : PanelStates.isClose;
//           selectedParts.value = groupState.value == PanelStates.isOpen
//               ? Strings.groups
//               : Strings.lessons;
//           break;
//         case Strings.actions:
//           actionState.value = status == AnimationStatus.completed
//               ? PanelStates.isOpen
//               : PanelStates.isClose;
//           selectedParts.value = actionState.value == PanelStates.isOpen
//               ? Strings.actions
//               : Strings.groups;
//           break;
//       }
//       print('end anim=> $status => $kind => ${selectedParts.value}');
//     }
//
//     onPartSelectListener(BtmPartsModel action) {
//       print('select part=> ${selectedParts.value}');
//       print(action.kind);
//       switch (action.kind) {
//         case Strings.chapters:
//           if (selectedParts.value == Strings.chapters ||
//               selectedParts.value == 'none') {
//             chapterState.value = chapterState.value == PanelStates.isClose
//                 ? PanelStates.open
//                 : PanelStates.closeChapter;
//           } else {
//             lessonState.value = lessonState.value == PanelStates.isOpen
//                 ? PanelStates.closeLesson
//                 : PanelStates.isClose;
//             groupState.value = groupState.value == PanelStates.isOpen
//                 ? PanelStates.closeGroup
//                 : PanelStates.isClose;
//             actionState.value = actionState.value == PanelStates.isOpen
//                 ? PanelStates.closeAction
//                 : PanelStates.isClose;
//           }
//           break;
//         case Strings.lessons:
//           if (selectedParts.value == Strings.lessons ||
//               selectedParts.value == Strings.chapters) {
//             lessonState.value = lessonState.value == PanelStates.isClose
//                 ? PanelStates.open
//                 : PanelStates.closeLesson;
//           } else {
//             groupState.value = groupState.value == PanelStates.isOpen
//                 ? PanelStates.closeGroup
//                 : PanelStates.isClose;
//             actionState.value = actionState.value == PanelStates.isOpen
//                 ? PanelStates.closeAction
//                 : PanelStates.isClose;
//           }
//           break;
//         case Strings.groups:
//           if (selectedParts.value == Strings.groups ||
//               selectedParts.value == Strings.lessons) {
//             groupState.value = groupState.value == PanelStates.isClose
//                 ? PanelStates.open
//                 : PanelStates.closeGroup;
//           } else {
//             actionState.value = actionState.value == PanelStates.isOpen
//                 ? PanelStates.closeAction
//                 : PanelStates.isClose;
//           }
//           break;
//         case Strings.actions:
//           actionState.value = actionState.value == PanelStates.isClose
//               ? PanelStates.open
//               : PanelStates.closeAction;
//           break;
//       }
//     }
//
//     int getDelayAmount(String which) {
//       switch (which) {
//         case Strings.chapters:
//           return selectedParts.value == Strings.lessons
//               ? 50
//               : selectedParts.value == Strings.groups
//               ? 100
//               : 150;
//         case Strings.lessons:
//           return selectedParts.value == Strings.groups ? 50 : 100;
//         case Strings.groups:
//           return selectedParts.value == Strings.actions ? 50 : 0;
//       }
//       return 0;
//     }
//
//     onAddsOnBackListener() {
//       addsOnAnimType.value = 'closing';
//       selectedAdds.value = 'none';
//     }
//
//     return Container();
//   }
// }
//
// enum PanelStates {
//   /// need open animation.
//   open,
//
//   /// need close animation until chapter panel.
//   closeChapter,
//
//   /// need close animation until lesson panel.
//   closeLesson,
//
//   /// need close animation until group panel.
//   closeGroup,
//
//   /// need close animation until action panel.
//   closeAction,
//
//   /// panel is open.
//   isOpen,
//
//   /// panel is close
//   isClose,
// }
