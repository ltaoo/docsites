import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';

import '/domains/result.dart';
import '/database/database.dart';
import '/domains/application.dart';
import '/utils.dart';

class WebResourceDownloadArg {
  final String url;
  final String method;
  final Map<String, String> headers;

  WebResourceDownloadArg({
    required this.url,
    required this.method,
    required this.headers,
  });
}

class WebResourceTmp {
  final String url;
  final String method;
  final Map<String, String> headers;
  final String filekey;

  WebResourceTmp({
    required this.url,
    required this.method,
    required this.filekey,
    required this.headers,
  });
}

class WebResourceResp {
  final String url;
  final Uint8List data;
  final Map<String, String> headers;

  WebResourceResp({
    required this.url,
    required this.data,
    required this.headers,
  });
}

class WebResourceManageCore {
  final ApplicationCore app;
  final int id;
  final String url;
  WebResourceManageCore({required this.app, required this.id, required this.url});

  final Map<String, WebResourceTmp> _urlToLocalPathMap = {};

  Future<Result<String?>> download(WebResourceDownloadArg arg) async {
    var url = Uri.parse(arg.url);
    try {
      final request = http.Request(arg.method, url);
      request.headers.addAll(arg.headers);
      print("[]download $url");
      final response = await request.send();
      if (response.statusCode == 200) {
        var bytes = utf8.encode(arg.url);
        var filename = md5.convert(bytes).toString();
        String parentDir = path.join(app.paths.site, id.toString());
        await Util.ensureDirectoriesExist(parentDir);
        String filepath = path.join(parentDir, filename);
        final file = File(filepath);
        print("[]save $url to $filepath");
        final body = await http.Response.fromStream(response);
        await file.writeAsBytes(body.bodyBytes);
        var tmp = WebResourceTmp(
          url: arg.url,
          method: arg.method,
          headers: response.headers,
          filekey: filename,
        );
        _urlToLocalPathMap[arg.url] = tmp;
        createWebResource(tmp, filename);
        return Result.ok(filepath);
      }
      print('请求失败，状态码: ${response.statusCode}');
    } catch (e) {
      print('发生错误: $e');
    }
    return Result.error("下载失败");
  }

  void createWebResource(WebResourceTmp arg, String filekey) async {
    ApplicationCore _app = app;
    var r = await findWebResourceByURL(arg.url);
    if (r != null) {
      return;
    }
    await _app.db.into(_app.db.webResources).insert(
        WebResourcesCompanion.insert(url: arg.url, method: drift.Value(arg.method), headers: drift.Value(jsonEncode(arg.headers)), filekey: drift.Value(filekey), siteFrom: id));
  }

  Future<WebResource?> findWebResourceByURL(String url) async {
    ApplicationCore _app = app;
    var result = await (_app.db.select(_app.db.webResources)..where((t) => t.url.equals(url))).get();
    if (result.isNotEmpty) {
      return result[0];
    }
    return null;
  }

  Future<Result<WebResourceResp>> getWebResource(String url) async {
    WebResourceTmp? tmp = _urlToLocalPathMap[url];
    if (tmp != null) {
      String filepath = path.join(app.paths.site, id.toString(), tmp.filekey);
      File file = File(filepath);
      Uint8List data = await file.readAsBytes();
      return Result.ok(WebResourceResp(url: url, data: data, headers: tmp.headers));
    }
    var resource = await findWebResourceByURL(url);
    if (resource == null) {
      return Result.error("no matched url");
    }
    String filepath = path.join(app.paths.site, id.toString(), resource.filekey);
    final file = File(filepath);
    final bytes = file.readAsBytesSync();
    Map<String, dynamic> headers1 = jsonDecode(resource.headers ?? "{}");
    Map<String, String> headers = headers1.map((key, value) => MapEntry(key, value.toString()));
    return Result.ok(WebResourceResp(url: url, data: bytes, headers: headers));
  }
}

class HomeIndexPageView extends StatefulWidget {
  final ApplicationCore app;
  final int id;
  final String url;

  const HomeIndexPageView({super.key, required this.app, required this.id, required this.url});

  static const name = 'index';
  static const routeName = '/home/$name';

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<HomeIndexPageView> {
  final GlobalKey webViewKey = GlobalKey();
  late final WebResourceManageCore networkStorage;

  late String url = widget.url;
  String title = '';
  double progress = 0;
  bool? isSecure;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    networkStorage = WebResourceManageCore(app: widget.app, id: widget.id, url: widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(57.0),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<bool>(
                      future: webViewController?.canGoBack() ?? Future.value(false),
                      builder: (context, snapshot) {
                        final canGoBack = snapshot.hasData ? snapshot.data! : false;
                        return IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: !canGoBack
                              ? null
                              : () {
                                  webViewController?.goBack();
                                },
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: webViewController?.canGoForward() ?? Future.value(false),
                      builder: (context, snapshot) {
                        final canGoForward = snapshot.hasData ? snapshot.data! : false;
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: !canGoForward
                              ? null
                              : () {
                                  webViewController?.goForward();
                                },
                        );
                      },
                    ),
                    FutureBuilder<bool>(
                      future: Future.value(true),
                      builder: (context, snapshot) {
                        return IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            webViewController?.reload();
                          },
                        );
                      },
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              Container(
                height: 1.0,
                color: Colors.black12,
              ),
            ],
          )),
      body: Column(children: <Widget>[
        Expanded(
            child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(url)),
              initialSettings:
                  InAppWebViewSettings(transparentBackground: true, safeBrowsingEnabled: true, isFraudulentWebsiteWarningEnabled: true, useShouldInterceptRequest: true),
              shouldInterceptRequest: (controller, request) async {
                final url = request.url.toString();
                // print("handle request ${url}");
                var r = await networkStorage.getWebResource(url);
                if (r.error == null) {
                  // print("using cache of ${url}");
                  var data = r.data!;
                  return WebResourceResponse(contentEncoding: data.headers['ContentEncoding'], contentType: data.headers['ContentType'], headers: data.headers, data: data.data);
                }
                // print("download request ${url}");
                networkStorage.download(WebResourceDownloadArg(url: url, method: request.method ?? "GET", headers: request.headers ?? {}));
              },
              onWebViewCreated: (controller) async {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                if (url != null) {
                  setState(() {
                    this.url = url.toString();
                    isSecure = urlIsSecure(url);
                  });
                }
              },
              onLoadStop: (controller, url) async {
                if (url != null) {
                  setState(() {
                    this.url = url.toString();
                  });
                }
                final sslCertificate = await controller.getCertificate();
                setState(() {
                  isSecure = sslCertificate != null || (url != null && urlIsSecure(url));
                });
              },
              onUpdateVisitedHistory: (controller, url, isReload) {
                if (url != null) {
                  setState(() {
                    this.url = url.toString();
                  });
                }
              },
              onTitleChanged: (controller, title) {
                if (title != null) {
                  setState(() {
                    this.title = title;
                  });
                }
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
            progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
          ],
        )),
      ]),
    );
  }

  void handleClick(int item) async {
    switch (item) {
      case 0:
        await InAppBrowser.openWithSystemBrowser(url: WebUri(url));
        break;
      case 1:
        await webViewController?.clearCache();
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          await webViewController?.clearHistory();
        }
        setState(() {});
        break;
    }
  }

  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || isLocalizedContent(url);
  }

  static bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" || url.scheme == "chrome" || url.scheme == "data" || url.scheme == "javascript" || url.scheme == "about");
  }
}