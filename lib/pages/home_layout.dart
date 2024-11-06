import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '/pages/site_list.dart';

class HomeLayoutView extends StatefulWidget {
  static HomeLayoutState of(BuildContext context) {
    return context.findAncestorStateOfType<HomeLayoutState>()!;
  }

  HomeLayoutView({
    super.key,
    required this.route,
  });

  final String route;
  static const routeName = '/home';

  @override
  HomeLayoutState createState() => HomeLayoutState();
}

class HomeLayoutState extends State<HomeLayoutView> with TrayListener, WindowListener {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
            child: Row(
          children: [
            Expanded(
                child: Navigator(
              key: _navigatorKey,
              initialRoute: widget.route,
              onGenerateRoute: _onGenerateRoute,
            ))
          ],
        )),
      ]),
    );
  }

  Route<Widget> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        final page = switch (settings.name) {
          // TaskListPage.routeName => TaskListPage(),
          _ => (() {
              return SiteListPage();
            })()
        };
        return page;
      },
    );
  }
}
