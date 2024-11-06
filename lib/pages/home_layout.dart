import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tools/pages/task_list.dart';
import 'package:tray_manager/tray_manager.dart';
// import 'package:window_manager_plus/window_manager_plus.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:multi_window/multi_window.dart';
// import 'package:windows_notification/notification_message.dart';
// import 'package:windows_notification/windows_notification.dart';

// import 'package:tools/components/task_values.dart';
import '/database/database.dart';
// import 'package:tools/biz/calendar.dart';
// import 'package:tools/biz/countdown.dart';
// import 'package:tools/src/sample_feature/calendar_page.dart';
import '/utils.dart';
import '/biz/docsite.dart';
import '/components/docsite_values.dart';
import '/domains/application.dart';
import '/pages/home_index.dart';
import '/pages/site_list.dart';

const _kIconTypeDefault = 'default';
const _kIconTypeOriginal = 'original';

@immutable
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
  String _iconType = _kIconTypeOriginal;
  Menu? _menu;
  Timer? _timer;
  // final _winNotifyPlugin = WindowsNotification(applicationId: null);
  final _navigatorKey = GlobalKey<NavigatorState>();

  void _init() async {
    // Add this line to override the default close handler
    // await WindowManagerPlus.current.setPreventClose(true);
    await windowManager.setPreventClose(true);
    setState(() {});
  }

// 托盘右键菜单
  Menu buildTrayMenus() {
    return Menu(
      items: [
        MenuItem(
          label: 'Look Up "LeanFlutter"',
        ),
        MenuItem(label: 'Search with Google', onClick: (_) async {}),
        MenuItem.separator(),
        MenuItem(
          label: '添加待办',
          onClick: (_) {
            _showSiteCreateDialog();
          },
        ),
        MenuItem(
          label: '测试推送',
          onClick: (_) {},
        ),
        MenuItem(
          label: 'Paste',
          disabled: true,
        ),
        MenuItem.submenu(
          label: 'Share',
          submenu: Menu(
            items: [
              MenuItem.checkbox(
                label: 'Item 1',
                checked: true,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 1');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                },
              ),
              MenuItem.checkbox(
                label: 'Item 2',
                checked: false,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 2');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                },
              ),
            ],
          ),
        ),
        MenuItem.separator(),
        MenuItem.submenu(
          label: 'Font',
          submenu: Menu(
            items: [
              MenuItem.checkbox(
                label: 'Item 1',
                checked: true,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 1');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                },
              ),
              MenuItem.checkbox(
                label: 'Item 2',
                checked: false,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 2');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                },
              ),
              MenuItem.separator(),
              MenuItem(
                label: 'Item 3',
                checked: false,
              ),
              MenuItem(
                label: 'Item 4',
                checked: false,
              ),
              MenuItem(
                label: 'Item 5',
                checked: false,
              ),
            ],
          ),
        ),
        MenuItem.submenu(
          label: 'Speech',
          submenu: Menu(
            items: [
              MenuItem(
                label: 'Item 1',
              ),
              MenuItem(
                label: 'Item 2',
              ),
            ],
          ),
        ),
        MenuItem(
          label: '退出',
          onClick: (menuItem) {
            print("exit application");
            Navigator.of(context).pop();
            // WindowManagerPlus.current.destroy();
            windowManager.destroy();
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
    _init();
    _menu = buildTrayMenus();
    _handleSetIcon(_kIconTypeOriginal);
    trayManager.setToolTip('Calendar');
    trayManager.setContextMenu(_menu!);
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    // WindowManagerPlus.current.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  void _showSiteCreateDialog() async {
    final values = DocsiteValuesCore();
    // final db = Provider.of<AppDatabase>(context, listen: false);
    final app = Provider.of<ApplicationCore>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: DocsiteValues(store: values),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("创建"),
              onPressed: () async {
                var r = await fetchWebsiteAndFindFavicon(values.url);
                if (r.data != null) {
                  values.setFavicon(r.data!);
                }
                await app.db.into(app.db.docSites).insert(DocSitesCompanion.insert(
                    url: values.url, name: values.name, overview: drift.Value(values.overview), favicon: drift.Value(values.favicon), createdAt: DateTime.now()));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSetIcon(String iconType) async {
    _iconType = iconType;
    String iconPath = Platform.isWindows ? 'assets/images/tray_icon.ico' : 'assets/images/tray_icon.png';

    if (_iconType == 'original') {
      iconPath = Platform.isWindows ? 'assets/images/tray_icon_original.ico' : 'assets/images/tray_icon_original.png';
    }

    await trayManager.setIcon(iconPath);
  }

  void _startIconFlashing() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      _handleSetIcon(
        _iconType == _kIconTypeOriginal ? _kIconTypeDefault : _kIconTypeOriginal,
      );
    });
    setState(() {});
  }

  void _stopIconFlashing() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {});
  }

  // @override
  // Future onEventFromWindow(String eventName, int fromWindowId, arguments) {
  //   print(eventName);
  //   print(fromWindowId);
  //   return super.onEventFromWindow(eventName, fromWindowId, arguments);
  // }

  // @override
  // void onWindowFocus([int? windowId]) {
  //   if (kDebugMode) {
  //     print("calendar - onWindowFocus");
  //   }
  //   setState(() {});
  //   if (!Util.isWindows()) {
  //     // WindowManagerPlus.current.setMovable(false);
  //     windowManager.setMovable(false);
  //   }
  // }

  @override
  void onWindowClose([int? windowId]) async {
    // WindowManagerPlus.current.hide();
    windowManager.hide();
    // bool _isPreventClose = await windowManager.isPreventClose();
    // if (_isPreventClose) {
    //   showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         title: Text('Are you sure you want to close this window?'),
    //         actions: [
    //           TextButton(
    //             child: Text('No'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             child: Text('Yes'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //               windowManager.destroy();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  Widget buildSider() {
    return Container(
      width: 250,
      color: Colors.blue,
      child: Column(
        children: [
          // 菜单头部
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // 菜单项
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              String? cur;
              _navigatorKey.currentState?.popUntil((route) {
                cur = route.settings.name;
                return true;
              });
              if (cur == HomeIndexPageView.routeName) {
                return;
              }
              if (cur == "/") {
                return;
              }
              _navigatorKey.currentState!.restorablePushNamed(HomeIndexPageView.routeName);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings, color: Colors.white),
          //   title: Text('Task', style: TextStyle(color: Colors.white)),
          //   onTap: () {
          //     String? cur;
          //     _navigatorKey.currentState?.popUntil((route) {
          //       cur = route.settings.name;
          //       return true;
          //     });
          //     print("click Task $cur");
          //     if (cur == TaskListPage.routeName) {
          //       return;
          //     }
          //     _navigatorKey.currentState!.restorablePushNamed(TaskListPage.routeName);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.white),
            title: Text('新增网站', style: TextStyle(color: Colors.white)),
            onTap: () {
              _showSiteCreateDialog();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Center(
            child: Row(
          children: [
            // buildSider(),
            Expanded(
                child: Navigator(
              key: _navigatorKey,
              initialRoute: widget.route,
              onGenerateRoute: _onGenerateRoute,
            ))
          ],
        )),
        // Positioned(bottom: 0, left: 0, right: 0, child: CountdownProgressBar(store: widget.countdown))
      ]),
    );
  }

  Route<Widget> _onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        final page = switch (settings.name) {
          //
          // CalendarPageView.routeName => const CalendarPageView(),
          //
          // TaskListPage.routeName => TaskListPage(),
          _ => (() {
              // int id = 0;
              // String url = "https://tailwindcss.com/";
              // return HomeIndexPageView(
              //   id: id,
              //   url: url,
              // );
              return SiteListPage();
            })()
        };
        return page;
      },
    );
  }

  @override
  void onTrayIconMouseDown() async {
    // if (kDebugMode) {
    //   print('onTrayIconMouseDown');
    // }
    // final visible = await WindowManagerPlus.current.isVisible();
    final visible = await windowManager.isVisible();
    if (visible) {
      // if (docked == true) {
      //   windowManager.focus();
      //   return;
      // }
      windowManager.hide();
      return;
    }
    // widget.calendar.setDate(DateTime.now());
    // WindowManagerPlus.current.show();
    windowManager.show();
    windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() {
    if (kDebugMode) {
      print('onTrayIconRightMouseDown');
    }
    trayManager.popUpContextMenu();
  }
}
