import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;

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
                var r = await fetchWebsiteAndFindFavicon(values.url);
                if (r.data != null) {
                  values.setFavicon(r.data!);
                }
                await app.db.into(app.db.docSites).insert(DocSitesCompanion.insert(
                    url: values.url, name: values.name, overview: drift.Value(values.overview), favicon: drift.Value(values.favicon), createdAt: DateTime.now()));
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<ApplicationCore>(context, listen: false);

    // final item = widget.items[index];
    if (isLoading == true) {
      return Center(child: CircularProgressIndicator());
    }
    // if (snapshot.hasError) {
    //   return Center(child: Text('Error: ${snapshot.error}'));
    // }
    if (sites.isEmpty) {
      return Center(child: Text('No Site found'));
    }

    return Scaffold(
        backgroundColor: Colors.white10,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: '新增网站',
            onPressed: () {
              _showSiteCreateDialog();
            }),
        body: Padding(
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
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: item.favicon != "" ? ClipOval(child: Image.memory(base64Decode(item.favicon!))) : Container(),
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
        ));
  }
}
