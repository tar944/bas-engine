import 'package:bas_dataset_generator_engine/src/data/dao/labelDAO.dart';
import 'package:bas_dataset_generator_engine/src/data/dao/objectBox.dart';
import 'package:bas_dataset_generator_engine/src/data/models/labelModel.dart';
import 'package:bas_dataset_generator_engine/src/pages/labelingPage.dart';
import 'package:bas_dataset_generator_engine/src/pages/mainPage/views/mainPage.dart';
import 'package:bas_dataset_generator_engine/src/pages/recordPage.dart';
import 'package:bas_dataset_generator_engine/src/utility/directoryManager.dart';
import 'package:bas_dataset_generator_engine/src/utility/enum.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:bas_dataset_generator_engine/src/utility/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (kIsLinux || kIsMacOS || kIsWindows) {
    await windowManager.ensureInitialized();
  }
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    fullScreen: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  await DirectoryManager().createLocalDir();
  objectbox = await ObjectBox.create();
  if (await LabelDAO().needAddDefaultValue()) {
    await LabelDAO().addList(PageType.values
        .map((e) => LabelModel(0, e.name, 'screen'))
        .toList());
    await LabelDAO().addList(
        PartType.values.map((e) => LabelModel(0, e.name, 'part')).toList());
    await LabelDAO().addList(ObjectType.values
        .map((e) => LabelModel(0, e.name, 'object'))
        .toList());
    await LabelDAO().addList(ActionKind.values
        .map((e) => LabelModel(0, e.name, 'action'))
        .toList());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp.router(
          title: "test title",
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          color: Colors.transparent,
          darkTheme: FluentThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: FluentThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'mainPage',
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: '/labeling/:groupId',
      name: 'labeling',
      builder: (context, state) =>
          LabelingPage(int.parse(state.params['groupId']!)),
    ),
    GoRoute(
      path: '/recordScreens/:partId',
      name: 'recordScreens',
      builder: (context, state) =>
          RecordPage(int.parse(state.params['partId']!)),
    ),
  ],
);
