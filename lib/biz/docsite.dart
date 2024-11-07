import 'dart:convert';
import 'dart:typed_data';

import 'package:docsites/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' as drift;
import 'package:path/path.dart' as path;

import '/domains/application.dart';
import '/domains/result.dart';
import '/utils.dart';

class DocsiteCore {
  ApplicationCore app;

  DocsiteCore({required this.app});

  Future<int> create(DocsiteValuesCore values) async {
    if (values.favicon == "") {
      var r = await fetchWebsiteAndFindFavicon(values.url);
      if (r.data != null) {
        values.setFavicon(r.data!);
      }
    }
    var record = await app.db.into(app.db.docSites).insert(
        DocSitesCompanion.insert(url: values.url, name: values.name, overview: drift.Value(values.overview), favicon: drift.Value(values.favicon), createdAt: DateTime.now()));
    String dir = path.join(app.paths.site, record.toString());
    await Util.ensureDirectoriesExist(dir);
    return record;
  }

  Future<int> createFile(DocsiteArchiveMainJSFile values, int fromId) async {
    var record = await app.db.into(app.db.webResources).insert(WebResourcesCompanion.insert(
        url: values.url, method: drift.Value(values.method), headers: drift.Value(values.headers), filekey: drift.Value(values.filekey), siteFrom: fromId));
    return record;
  }
}

class DocsiteValuesCore {
  String _url = "";
  String _name = "";
  String _overview = "";
  String _favicon = "";

  Map<String, String> get values => {
        'url': _url,
        'name': _name,
        'content': _overview,
        'favicon': _overview,
      };
  String get url => _url;
  String get name => _name;
  String get overview => _overview;
  String get favicon => _favicon;

  setURL(String v) {
    _url = v;
  }

  setName(String v) {
    _name = v;
  }

  setOverview(String v) {
    _overview = v;
  }

  setFavicon(String v) {
    _favicon = v;
  }

  setValues(Map<String, String> data) {
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
