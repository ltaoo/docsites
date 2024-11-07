import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;
import 'package:dotted_border/dotted_border.dart';
import 'package:cross_file/cross_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // late Future<List<DocSite>> items;

  @override
  void initState() {
    super.initState();

    fetchSiteList();
  }

  void _showSiteCreateDialog() async {
    final values = DocsiteValuesCore();
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
                final $core = DocsiteCore(app: app);
                await $core.create(values);
                // var r = await fetchWebsiteAndFindFavicon(values.url);
                // if (r.data != null) {
                //   values.setFavicon(r.data!);
                // }
                // var record = await app.db.into(app.db.docSites).insert(DocSitesCompanion.insert(
                //     url: values.url, name: values.name, overview: drift.Value(values.overview), favicon: drift.Value(values.favicon), createdAt: DateTime.now()));
                // String dir = path.join(app.paths.site, record.toString());
                // await Util.ensureDirectoriesExist(dir);
                Navigator.of(context).pop();
                fetchSiteList();
              },
            ),
          ],
        );
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

  Widget buildBody(ApplicationCore app) {
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    // if (snapshot.hasError) {
    //   return Center(child: Text('Error: ${snapshot.error}'));
    // }
    if (sites.isEmpty) {
      return Center(child: Text('No Site found'));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: sites.map((item) {
          return SizedBox(
            width: 280,
            height: 120,
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
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(48)),
                            child: item.favicon != "" ? Image.memory(base64Decode(item.favicon!)) : Container(),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    item.name,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
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
                                    // IconButton(
                                    //   icon: const Icon(Icons.refresh_outlined),
                                    //   onPressed: () async {
                                    //     var r = await fetchWebsiteAndFindFavicon(item.url);
                                    //     if (r.error != null) {
                                    //       return;
                                    //     }
                                    //     await (app.db.update(app.db.docSites)..where((t) => t.id.equals(item.id))).write(DocSitesCompanion(favicon: drift.Value(r.data)));
                                    //     fetchSiteList();
                                    //   },
                                    // ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.edit_outlined),
                                    //   onPressed: () {},
                                    // ),
                                    IconButton(
                                      icon: const Icon(Icons.folder_zip_outlined),
                                      onPressed: () async {
                                        final archive = ZipFileEncoder();
                                        final zipFilePath = path.join(app.paths.download, '${item.name}.zip');
                                        archive.create(zipFilePath);
                                        final folder = Directory(path.join(app.paths.site, item.id.toString()));
                                        if (folder.existsSync()) {
                                          final files = folder.listSync(recursive: true);
                                          for (var file in files) {
                                            if (file is File) {
                                              final relativePath = path.relative(file.path, from: folder.path);
                                              archive.addFile(file, path.join("assets", relativePath));
                                            }
                                          }
                                        }
                                        final jsonFile = File(path.join(app.paths.archive, "main.json"));
                                        List<WebResource> files = await (app.db.select(app.db.webResources)..where((t) => t.siteFrom.equals(item.id))).get();
                                        await jsonFile.writeAsString(jsonEncode({
                                          "url": item.url,
                                          "name": item.name,
                                          "overview": item.overview,
                                          "favicon": item.favicon,
                                          "version": item.version,
                                          "files": files.map((f) {
                                            return {
                                              "url": f.url,
                                              "headers": f.headers,
                                              "method": f.method,
                                              "file_key": f.filekey,
                                            };
                                          }).toList(),
                                        }));
                                        archive.addFile(jsonFile, 'main.json');
                                        archive.close();
                                        print("创建成功");
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () {
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
                                                  onPressed: () async {
                                                    await (app.db.delete(app.db.docSites)..where((t) => t.id.equals(item.id))).go();
                                                    await (app.db.delete(app.db.webResources)..where((t) => t.siteFrom.equals(item.id))).go();
                                                    Directory folderToDelete = Directory(path.join(app.paths.site, item.id.toString()));
                                                    await Util.deleteFolder(folderToDelete);
                                                    Navigator.of(context).pop(); // 关闭对话框
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('记录已删除')),
                                                    );
                                                    fetchSiteList();
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
        for (int i = 0; i < files.length; i += 1) {
          final File zipFile = File(files[i].path);
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

              final data = DocsiteArchiveMainJS(name: name, url: url, overview: overview, favicon: favicon, files: files);

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
            break;
          }
          if (recordId == 0) {
            break;
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
          fetchSiteList();
        }
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
          buildBody(app),
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
            child: Icon(Icons.add),
            tooltip: '新增网站',
            onPressed: () {
              _showSiteCreateDialog();
            }),
        body: KeyboardListener(focusNode: FocusNode()..requestFocus(), child: buildDropContainer(app), onKeyEvent: _handleKeyEvent));
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
