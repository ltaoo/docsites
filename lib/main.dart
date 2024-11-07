// import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';

import '/domains/application.dart';
import '/settings/controller.dart';
import '/settings/service.dart';
import '/database/database.dart';
import '/pages/home_index.dart';
import '/pages/home_layout.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  // if (args.firstOrNull == 'multi_window') {
  //   final windowId = int.parse(args[1]);
  //   final argument = args[2].isEmpty ? const {} : jsonDecode(args[2]) as Map<String, dynamic>;
  //   runApp(ChildWindow());
  //   return;
  // }
  // await WindowManagerPlus.ensureInitialized(args.isEmpty ? 0 : int.tryParse(args[0]) ?? 0);
  const size = Size(1220, 800);
  WindowOptions windowOptions = const WindowOptions(
    size: size,
    center: true,
    // backgroundColor: Colors.transparent,
    skipTaskbar: false,
  );
  // WindowManagerPlus.current.waitUntilReadyToShow(windowOptions, () async {
  //   await WindowManagerPlus.current.show();
  //   await WindowManagerPlus.current.focus();
  // });
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  var paths = ApplicationPaths(root: "", site: "", archive: "", database: "", download: "");
  await paths.ensure();
  print(paths.download);
  var database = AppDatabase();
  var application = ApplicationCore(paths: paths, db: database);

  Provider.debugCheckInvalidValueType = null;

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(Provider<ApplicationCore>(
    create: (_) => application,
    // child: MyApp(settingsController: settingsController),
    child: ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(), //1.调用BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',
          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<dynamic>(
                settings: routeSettings,
                builder: (context) {
                  late Widget page;
                  // if (routeSettings.name == "/") {
                  page = HomeLayoutView(
                    route: HomeIndexPageView.routeName,
                  );
                  // }
                  // if (routeSettings.name == SettingsView.routeName) {
                  //   page = SettingsView(controller: settingsController);
                  // }
                  // if (routeSettings.name!.startsWith(HomeLayoutView.routeName)) {
                  //   final subRoute = routeSettings.name!.substring(HomeLayoutView.routeName.length);
                  //   page = HomeLayoutView(
                  //     route: subRoute,
                  //   );
                  // }
                  return page;
                });
          },
        );
      },
    ),
    dispose: (context, app) => app.close(),
  ));
}
