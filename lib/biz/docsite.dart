import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;

import '/database/database.dart';
import '/domains/application.dart';
import '/domains/result.dart';
import '/domains/mitt.dart';
import '/utils.dart';

class DocsiteCore {
  ApplicationCore app;
  final bus = EventEmitter();

  int? id;
  bool _loading = false;
  String DEFAULT_FAVICON =
      "iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAIAAAD/gAIDAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAEXRFWHRTb2Z0d2FyZQBTbmlwYXN0ZV0Xzt0AAADoSURBVHic7dDBDcAgEMCw0v13PlYgL4RkTxBlzczHmf92wEvMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKzArMCswKNs/xA8XKprxoAAAAAElFTkSuQmCC";

  get loading => _loading;

  DocsiteCore({this.id, required this.app});

  Future<int> create(DocsiteValuesCore values) async {
    _loading = true;
    bus.emit("loading-change", {});
    if (values.favicon == "") {
      var r = await fetchWebsiteAndFindFavicon(values.url);
      if (r.data != null) {
        values.setFavicon(r.data!);
      }
    }
    if (values.favicon == "") {
      values.setFavicon(DEFAULT_FAVICON);
    }
    var record = await app.db.into(app.db.docSites).insert(DocSitesCompanion.insert(
        url: values.url,
        name: values.name,
        overview: drift.Value(values.overview),
        favicon: drift.Value(values.favicon),
        version: drift.Value(values.version),
        createdAt: DateTime.now()));
    String dir = path.join(app.paths.site, record.toString());
    await Util.ensureDirectoriesExist(dir);
    _loading = false;
    bus.emit("loading-change", {});
    return record;
  }

  Future<int> update(DocsiteValuesCore values, int id) async {
    _loading = true;
    bus.emit("loading-change", {});
    if (values.favicon == "") {
      var r = await fetchWebsiteAndFindFavicon(values.url);
      if (r.data != null) {
        values.setFavicon(r.data!);
      }
    }
    if (values.favicon == "") {
      values.setFavicon(DEFAULT_FAVICON);
    }
    final record = await (app.db.update(app.db.docSites)..where((t) => t.id.equals(id))).write(DocSitesCompanion(
      url: drift.Value(values.url),
      name: drift.Value(values.name),
      overview: drift.Value(values.overview),
      favicon: drift.Value(values.favicon),
      version: drift.Value(values.version),
    ));
    _loading = false;
    bus.emit("loading-change", {});
    return record;
  }

  Future<Result<DocSite>> profile() async {
    if (id == null) {
      return Result.error("缺少 id");
    }
    var result = await (app.db.select(app.db.docSites)..where((t) => t.id.equals(id!))).get();
    if (result.isNotEmpty) {
      return Result.ok(result[0]);
    }
    return Result.error("没有匹配的记录");
  }

  Future<int> createFile(DocsiteArchiveMainJSFile values, int fromId) async {
    var record = await app.db.into(app.db.webResources).insert(WebResourcesCompanion.insert(
        url: values.url, method: drift.Value(values.method), headers: drift.Value(values.headers), filekey: drift.Value(values.filekey), siteFrom: fromId));
    return record;
  }

  Future<Result<String>> archive() async {
    _loading = true;
    bus.emit("loading-change", {});
    final r = await profile();
    if (r.error != null) {
      _loading = false;
      bus.emit("loading-change", {});
      bus.emit("error", {"message": r.error!.message});
      print("[]archive - error ${r.error!.message}");
      return Result.error(r.error!.message);
    }
    final record = r.data!;
    final archive = ZipFileEncoder();
    final filename = '${record.name}.zip';
    final zipFilePath = path.join(app.paths.download, filename);
    archive.create(zipFilePath);
    final folder = Directory(path.join(app.paths.site, record.id.toString()));
    await Util.sleep(1);
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
    List<WebResource> files = await (app.db.select(app.db.webResources)..where((t) => t.siteFrom.equals(record.id))).get();
    await jsonFile.writeAsString(jsonEncode({
      "url": record.url,
      "name": record.name,
      "overview": record.overview,
      "favicon": record.favicon,
      "version": record.version,
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
    _loading = false;
    bus.emit("loading-change", {});
    bus.emit("archive-completed", {
      "dir": app.paths.download,
      "filename": filename,
      "filepath": zipFilePath,
    });
    return Result.ok(zipFilePath);
  }

  onLoadingChange(Handler handler) {
    return bus.on("loading-change", handler);
  }

  onError(Handler handler) {
    return bus.on("error", handler);
  }

  onArchiveCompleted(Handler handler) {
    return bus.on("archive-completed", handler);
  }

  dispose() {
    bus.dispose();
  }
}

// 定义一个泛型的 debounce 函数
Function debounce(Function func, {Duration duration = const Duration(milliseconds: 500)}) {
  Timer? timer;
  return (dynamic arg) {
    if (timer?.isActive ?? false) {
      timer!.cancel();
    }
    timer = Timer(duration, () {
      func(arg);
    });
  };
}

class DocsiteValuesCore {
  String _url = "";
  String _name = "";
  String _overview = "";
  String _version = "0.0.1";
  String _favicon = "";
  bool showImage;

  final bus = EventEmitter();

  Map<String, String> get values => {
        'url': _url,
        'name': _name,
        'content': _overview,
        'version': _version,
        'favicon': _overview,
      };
  String get url => _url;
  String get name => _name;
  String get overview => _overview;
  String get version => _version;
  String get favicon => _favicon;

  late final Function update;

  DocsiteValuesCore({this.showImage = false}) {
    // 初始化 `update` 成员
    update = debounce((String url) {
      final matched = extractDomain(url);
      if (matched != null) {
        _name = matched;
        bus.emit("name-change", {});
      }
    });
  }

  String? extractDomain(String url) {
    // 使用正则表达式匹配 URL 中的主机名部分
    final RegExp exp = RegExp(r'^(?:https?:\/\/)?(?:www\.)?([^\/:]+)'); // 这里的正则表达式可以匹配不同格式的 URL
    final match = exp.firstMatch(url);

    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  setURL(String v) {
    _url = v;
    update(v);
  }

  setName(String v) {
    _name = v;
  }

  setOverview(String v) {
    _overview = v;
  }

  setVersion(String v) {
    _version = v;
  }

  setFavicon(String v) {
    _favicon = v;
    bus.emit("favicon-change", {});
  }

  setValues(Map<String, String?> data) {
    final url = data['url'];
    if (url != null) {
      setURL(url);
    }
    final name = data['name'];
    if (name != null) {
      setName(name);
    }
    final overview = data['overview'];
    if (overview != null) {
      setOverview(overview);
    }
    final favicon = data['favicon'];
    if (favicon != null) {
      setFavicon(favicon);
    }
    bus.emit("values-change", {});
  }

  onValuesChange(Handler handler) {
    return bus.on('values-change', handler);
  }

  onNameChange(Handler handler) {
    return bus.on('name-change', handler);
  }

  onFaviconChange(Handler handler) {
    return bus.on('favicon-change', handler);
  }

  @override
  String toString() {
    return '{name: $_name, url: $_url}';
  }
}

class DocsiteArchiveMainJSFile {
  final String url;
  final String method;
  final String headers;
  final String filekey;

  DocsiteArchiveMainJSFile({required this.url, required this.method, required this.headers, required this.filekey});

  @override
  String toString() {
    return 'url:$url, method:$method';
  }
}

class DocsiteArchiveMainJS {
  final String url;
  final String name;
  final String overview;
  final String favicon;
  final String? version;
  final List<DocsiteArchiveMainJSFile> files;

  DocsiteArchiveMainJS({required this.name, required this.url, required this.overview, required this.favicon, this.version, required this.files});

  @override
  String toString() {
    return 'name:$name, url$url, files:${files.length}';
  }
}

String? findFaviconUrl(String html, String baseUrl) {
  final regex = RegExp(
    r'<link([^>]{1,})/{0,1}>',
    caseSensitive: false,
  );
  final matches = regex.allMatches(html);
  List<String> iconHrefs = [];
  // print(matches);
  for (var match in matches) {
    String relValue = match.group(1)?.toLowerCase() ?? '';
    // 判断 rel 值中是否包含 'icon'
    if (relValue.contains('icon')) {
      RegExp hrefRegExp = RegExp(r'href="([^">]{1,})"');
      var hrefMatch = hrefRegExp.firstMatch(relValue);
      // print("hrefMatch ${hrefMatch?.group(0)} ${hrefMatch?.group(1)}");
      if (hrefMatch != null) {
        String hrefValue = hrefMatch.group(1)!;
        iconHrefs.add(hrefValue);
      }
    }
  }
  if (iconHrefs.isNotEmpty) {
    var first = iconHrefs[0];
    if (!first.startsWith('http')) {
      first = Uri.parse(baseUrl).resolve(first).toString();
    }
    return first;
  }
  return null;
}

Future<Result<String>> fetchWebsiteAndFindFavicon(String url) async {
  try {
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      final faviconUrl = findFaviconUrl(resp.body, url);
      if (faviconUrl != null) {
        print!("favicon url is $faviconUrl");
        final resp2 = await http.get(Uri.parse(faviconUrl));
        if (resp2.statusCode == 200) {
          final bytes = resp2.bodyBytes;
          return Result.ok(base64Encode(bytes));
        }
      }
    }
  } catch (e) {
    // print(e);
  }
  print!("no favicon founded");
  return Result.error("there maybe some error");
}
