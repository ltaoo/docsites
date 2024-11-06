import 'dart:convert';
import 'dart:typed_data';

import 'package:docsites/domains/result.dart';
import 'package:http/http.dart' as http;

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

  @override
  String toString() {
    return '{name: $_name, url: $_url}';
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
