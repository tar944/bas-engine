import 'package:bas_dataset_generator_engine/src/pages/softwaresList.dart';
import 'package:bas_dataset_generator_engine/src/utility/platform_util.dart';
import 'package:bas_dataset_generator_engine/src/utility/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (kIsLinux || kIsMacOS || kIsWindows) {
    await windowManager.ensureInitialized();
  }
  WindowOptions windowOptions = const WindowOptions(
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  await Hive.initFlutter();
  await Hive.openBox('DSGE_DB');
  runApp(const MyApp());
}
class MyApp extends StatelessWidget with WindowListener {
  const MyApp({super.key});


  @override
  void onWindowClose() {
    Hive.box('DSGE_DB').compact();
    Hive.box('DSGE_DB').close();
    Hive.close();
  }

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
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: ThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
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
    // GoRoute(
    //   path: '/',
    //   name: 'Video list',
    //   builder: (context, state) => PagePartLabeling(),
    // ),
    GoRoute(
      path: '/',
      name: 'Software list',
      builder: (context, state) => const SoftWaresList(),
    ),
  ],
);
