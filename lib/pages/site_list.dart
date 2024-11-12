import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;
import 'package:dotted_border/dotted_border.dart';
import 'package:cross_file/cross_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '/database/database.dart';
import '/biz/docsite.dart';
import '/components/docsite_values.dart';
import '/domains/application.dart';
import '/pages/home_index.dart';
import '/utils.dart';

// Future<List<DocSite>> fetchTaskList() async {
//   final response = await http.get(Uri.parse('https://example.com/api/users'));
//   if (response.statusCode == 200) {
//     List jsonResponse = json.decode(response.body);
//     return jsonResponse.map((site) => DocSite.fromJson(site)).toList();
//   } else {
//     throw Exception('Failed to load users');
//   }
// }

class SiteListPage extends StatefulWidget {
  SiteListPage({super.key});

  static const name = "site_list";
  static const routeName = '/home/$name';

  @override
  SiteListPageState createState() => SiteListPageState();
}

class SiteListPageState extends State<SiteListPage> {
  List<DocSite> sites = [];
  bool isLoading = true;
  bool _isHovering = false;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();

    fetchSiteList();
  }

  void _showSiteCreateDialog(BuildContext context) async {
    final values = DocsiteValuesCore();
    final app = Provider.of<ApplicationCore>(context, listen: false);
    final $core = DocsiteCore(app: app);
    bool _loading1 = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext c, StateSetter s) {
          $core.onLoadingChange((_) {
            s(() {
              _loading1 = $core.loading;
            });
          });
          return AlertDialog(
            content: DocsiteValues(store: values),
            actions: <Widget>[
              TextButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _loading1
                        ? Container(
                            width: 16,
                            height: 16,
                            child: const CircularProgressIndicator(),
                          )
                        : Container(),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text("创建")
                  ],
                ),
                onPressed: () async {
                  if ($core.loading) {
                    return;
                  }
                  if (values.url == "") {
                    BotToast.showText(text: "请输入地址");
                    return;
                  }
                  if (values.name == "") {
                    BotToast.showText(text: "请输入名称");
                    return;
                  }
                  await $core.create(values);
                  Navigator.of(context).pop();
                  fetchSiteList();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showSiteUpdateDialog(BuildContext context, DocSite site) async {
    final values = DocsiteValuesCore(showImage: true);
    final app = Provider.of<ApplicationCore>(context, listen: false);
    final $core = DocsiteCore(app: app);
    bool _loading1 = false;

    values.setValues({
      "url": site.url,
      "name": site.name,
      "version": site.version,
      "overview": site.overview,
      "favicon": site.favicon,
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext c, StateSetter s) {
          $core.onLoadingChange((_) {
            s(() {
              _loading1 = $core.loading;
            });
          });
          return AlertDialog(
            content: DocsiteValues(store: values),
            actions: <Widget>[
              TextButton(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _loading1
                        ? Container(
                            width: 16,
                            height: 16,
                            child: const CircularProgressIndicator(),
                          )
                        : Container(),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text("保存")
                  ],
                ),
                onPressed: () async {
                  if ($core.loading) {
                    return;
                  }
                  if (values.url == "") {
                    BotToast.showText(text: "请输入地址");
                    return;
                  }
                  if (values.name == "") {
                    BotToast.showText(text: "请输入名称");
                    return;
                  }
                  await $core.update(values, site.id);
                  Navigator.of(context).pop();
                  fetchSiteList();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void fetchSiteList() async {
    final app = Provider.of<ApplicationCore>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    try {
      List<DocSite> result = await app.db.select(app.db.docSites).get();
      setState(() {
        sites = result;
      });
    } catch (err) {
      // ...
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Refreshed!')),
    // );
    setState(() {
      isLoading = false;
    });
  }

  refreshFavicon(ApplicationCore app, DocSite item) async {
    var r = await fetchWebsiteAndFindFavicon(item.url);
    if (r.error != null) {
      return;
    }
    await (app.db.update(app.db.docSites)..where((t) => t.id.equals(item.id))).write(DocSitesCompanion(favicon: drift.Value(r.data)));
    fetchSiteList();
  }

  createSite() {}

  removeSite(ApplicationCore app, DocSite item) async {
    await (app.db.delete(app.db.docSites)..where((t) => t.id.equals(item.id))).go();
    await (app.db.delete(app.db.webResources)..where((t) => t.siteFrom.equals(item.id))).go();
    Directory folderToDelete = Directory(path.join(app.paths.site, item.id.toString()));
    await Util.deleteFolder(folderToDelete);
    Navigator.of(context).pop(); // 关闭对话框
    BotToast.showText(text: "删除成功");
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('记录已删除')),
    // );
    fetchSiteList();
  }

  archiveSite(ApplicationCore app, DocSite item) async {
    final $core = DocsiteCore(id: item.id, app: app);

    bool _loading1 = true;
    String _error = "";
    String _dir = "";
    String _filename = "";
    String _filepath = "";

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        $core.archive();
        return StatefulBuilder(builder: (BuildContext c, StateSetter s) {
          $core.onError((v) {
            s(() {
              _error = v["error"];
            });
          });
          $core.onLoadingChange((_) {
            s(() {
              _loading1 = $core.loading;
            });
          });
          $core.onArchiveCompleted((v) {
            s(() {
              _dir = v['dir'];
              _filename = v['filename'];
              _filepath = v['filepath'];
            });
          });
          return AlertDialog(
              content: SizedBox(
            width: 168,
            height: 168,
            child: Column(
              children: [
                _loading1
                    ? Container(
                        width: 88,
                        height: 88,
                        child: Center(
                          child: Container(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 8,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 88,
                        height: 88,
                        child: Icon(
                          Icons.check,
                          size: 48,
                          color: Colors.purple[400],
                        ),
                      ),
                SizedBox(
                  height: 12,
                ),
                _filepath != ""
                    ? MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (Util.isWindows()) {
                              Process.run('explorer.exe', ['/select,', _filepath]).then((result) {
                                // print('打开文件夹并高亮文件的结果: ${result.stdout}');
                              }).catchError((error) {
                                BotToast.showText(text: "打开失败");
                              });
                            }
                            // final Uri uri = Uri.file(_filepath);
                            // if (await canLaunchUrl(uri)) {
                            //   await launchUrl(uri);
                            //   return;
                            // }
                            // BotToast.showText(text: "打开失败");
                          },
                          child: Text(
                            _filepath,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    : Container(
                        child: Text(
                        "正在打包",
                        style: TextStyle(fontSize: 16),
                      )),
                _error != ""
                    ? Text(
                        _error,
                        style: TextStyle(fontSize: 16),
                      )
                    : Container()
              ],
            ),
          ));
        });
      },
    );
  }

  createSiteFromZIP(File zipFile, ApplicationCore app) async {
    final List<int> bytes = await zipFile.readAsBytes();
    final Archive archive = ZipDecoder().decodeBytes(bytes);
    bool isContainMainJS = false;
    int recordId = 0;
    for (final ArchiveFile file in archive) {
      if (file.name == 'main.json') {
        final List<int> jsonBytes = file.content as List<int>;
        Map<String, dynamic> tmp = jsonDecode(utf8.decode(jsonBytes));
        String name = tmp['name'] as String;
        String url = tmp['url'] as String;
        String? version = tmp['version'] as String?;
        String overview = tmp['overview'] as String;
        String favicon = tmp['favicon'] as String;
        List<dynamic> filesJson = tmp['files'];
        List<DocsiteArchiveMainJSFile> files = filesJson.map((fileJson) {
          String url = fileJson['url'] as String;
          String method = fileJson['method'] as String;
          String headers = fileJson['headers'] as String;
          String filekey = fileJson['file_key'] as String;
          return DocsiteArchiveMainJSFile(url: url, method: method, headers: headers, filekey: filekey);
        }).toList();

        final data = DocsiteArchiveMainJS(name: name, url: url, overview: overview, version: version, favicon: favicon, files: files);

        if (data.name != "" && data.url != "") {
          isContainMainJS = true;
          final $core = DocsiteCore(app: app);
          final $values = DocsiteValuesCore();
          $values.setURL(data.url);
          $values.setName(data.name);
          $values.setOverview(data.overview);
          $values.setFavicon(data.favicon);
          recordId = await $core.create($values);
          for (final f in data.files) {
            await $core.createFile(f, recordId);
          }
        }
      }
    }
    if (!isContainMainJS) {
      return;
    }
    if (recordId == 0) {
      return;
    }
    for (final ArchiveFile file in archive) {
      if (file.name.startsWith('assets/')) {
        final String filepath = path.join(app.paths.site, recordId.toString(), path.relative(file.name, from: 'assets'));
        if (file.isFile) {
          final File outFile = File(filepath);
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        }
      }
    }
    print('解压完成到: $recordId');
  }

  Widget buildMoreBtn(ApplicationCore app, DocSite item) {
    final key = GlobalKey();
    return IconButton(
        key: key,
        icon: Icon(Icons.more_horiz_outlined),
        onPressed: () {
          RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
          final pp = box.localToGlobal(Offset.zero);
          final x = pp.dx + box.size.width;
          final y = pp.dy;
          print("$x, $y, ${box.size.width}, ${box.size.height}");
          Offset offset = box.localToGlobal(Offset.zero);
          showMenu(
            context: context,
            // position: RelativeRect.fromLTRB(100.0, 50.0, 0.0, 0.0),
            position: RelativeRect.fromLTRB(
                x,
                y,
                MediaQuery.of(context).size.width - offset.dx, // 右侧位置
                MediaQuery.of(context).size.height - (offset.dy + box.size.height)),
            items: [
              PopupMenuItem<String>(
                value: 'edit',
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text("编辑")
                  ],
                ),
                onTap: () {
                  _showSiteUpdateDialog(context, item);
                },
              ),
              PopupMenuItem<String>(
                value: 'browser',
                child: const Row(
                  children: [
                    Icon(Icons.open_in_browser_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text("在浏览器打开")
                  ],
                ),
                onTap: () async {
                  final uri = Uri.parse(item.url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                    return;
                  }
                  BotToast.showText(text: "打开${item.url}失败");
                },
              ),
              PopupMenuItem<String>(
                value: 'archive',
                child: const Row(
                  children: [
                    Icon(Icons.folder_zip_outlined),
                    SizedBox(
                      width: 8,
                    ),
                    Text("归档")
                  ],
                ),
                onTap: () {
                  archiveSite(app, item);
                },
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 8,
                    ),
                    Text("删除")
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('删除'),
                        content: Text('缓存文件将一并删除，确定要删除该网站吗？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // 关闭对话框
                            },
                            child: Text('取消'),
                          ),
                          TextButton(
                            onPressed: () {
                              removeSite(app, item);
                            },
                            child: Text('确认'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        });
  }

  Widget buildSiteListView(ApplicationCore app) {
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    // if (snapshot.hasError) {
    //   return Center(child: Text('Error: ${snapshot.error}'));
    // }
    if (sites.isEmpty) {
      return const Center(child: Text('暂无任何网站'));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: sites.map((item) {
          return SizedBox(
            width: 280,
            height: 138,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Card(
                elevation: 4,
                child: MouseRegion(
                  // cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            clipBehavior: Clip.hardEdge,
                            child: Center(
                              child: item.favicon != ""
                                  ? Image.memory(
                                      base64Decode(item.favicon!),
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        item.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 24),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    item.version != null
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0), // 内边距
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue, // 背景颜色
                                                    borderRadius: BorderRadius.circular(12.0), // 圆角
                                                  ),
                                                  child: Text(
                                                    item.version!,
                                                    style: TextStyle(
                                                      color: Colors.white, // 字体颜色
                                                      fontSize: 12.0, // 字体大小
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 6,
                                          ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeIndexPageView(
                                              app: app,
                                              id: item.id,
                                              url: item.url,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    buildMoreBtn(app, item),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDropContainer(ApplicationCore app) {
    return DropTarget(
      onDragDone: (detail) async {
        final files = detail.files;
        showDialog(
            context: context,
            builder: (BuildContext c) {
              return AlertDialog(
                content: Container(
                  width: 68,
                  height: 68,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          child: Center(
                            child: Container(
                              width: 36,
                              height: 36,
                              child: CircularProgressIndicator(
                                strokeWidth: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text("处理中"),
                      ],
                    ),
                  ),
                ),
              );
            });
        for (int i = 0; i < files.length; i += 1) {
          final File zipFile = File(files[i].path);
          await createSiteFromZIP(zipFile, app);
        }
        fetchSiteList();
        Navigator.of(context).pop();
      },
      onDragEntered: (detail) {
        setState(() {
          _isHovering = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Stack(
        children: [
          buildSiteListView(app),
          _isHovering
              ? Container(
                  color: Colors.black26,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(8),
                      dashPattern: [8, 4],
                      strokeWidth: 2,
                      child: Center(
                          child: Text(
                        '拖动到此处上传',
                        style: TextStyle(fontSize: 24),
                      )),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<ApplicationCore>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white10,
        floatingActionButton: FloatingActionButton(
          tooltip: '新增网站',
          onPressed: () {
            _showSiteCreateDialog(context);
          },
          child: const Icon(Icons.add),
        ),
        body: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: _handleKeyEvent,
          child: buildDropContainer(app),
        ));
  }

  final Map<String, bool> pressingKeys = {};
  // Method to handle keyboard events
  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      pressingKeys[event.logicalKey.debugName ?? 'Unknown'] = true;
      // Check if the Ctrl key is pressed and the R key is pressed
      // print(event.logicalKey.keyLabel);
      if (pressingKeys["Control Left"] == true && event.logicalKey == LogicalKeyboardKey.keyR) {
        fetchSiteList();
      }
    }
    if (event is KeyUpEvent) {
      pressingKeys[event.logicalKey.debugName ?? 'Unknown'] = false;
    }
  }
}
