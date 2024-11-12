import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:path/path.dart' as paths;
import 'package:path_provider/path_provider.dart';

import 'package:docsites/utils.dart';

part 'database.g.dart';

class DocSites extends Table {
  IntColumn get id => integer().autoIncrement().named("id")();
  // 网站地址
  TextColumn get url => text().named("url")();
  // 网站名称
  TextColumn get name => text().named("name")();
  // 简要描述
  TextColumn get overview => text().nullable().named("overview")();
  // 网站图标
  TextColumn get favicon => text().nullable().named("favicon")();
  // 版本
  TextColumn get version => text().nullable().named("version")();
  // 创建时间
  DateTimeColumn get createdAt => dateTime().named("created_at")();
}

class WebResources extends Table {
  // 资源地址
  TextColumn get url => text().named("url")();
  // 请求方法
  TextColumn get method => text().nullable().named("method")();
  // 请求体
  TextColumn get body => text().nullable().named("body")();
  // 资源响应时 headers
  TextColumn get headers => text().nullable().named("headers")();
  // 缓存到本地后的唯一标志，其实就是「响应内容」
  TextColumn get filekey => text().nullable().named("file_key")();
  // 所属网站
  IntColumn get siteFromId => integer().references(DocSites, #id).named("site_from_id")();
}

class Settings extends Table {
  TextColumn get json => text()();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    Directory dbFolder = await getApplicationDocumentsDirectory();
    if (Util.isWindows()) {
      final path = Platform.environment['APPData'];
      if (kDebugMode) {
        print("in windows platform, read AppData env as db folder $path");
      }
      if (path != null) {
        dbFolder = Directory(path);
      }
    }
    print("the ApplicationDocumentsDirectory is $dbFolder");
    final file = File(paths.join(dbFolder.path, 'docsites', "database", 'store.sqlite'));
    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [DocSites, WebResources, Settings])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // static QueryExecutor _openConnection() {
  //   // `driftDatabase` from `package:drift_flutter` stores the database in
  //   // `getApplicationDocumentsDirectory()`.
  //   return driftDatabase(name: 'store');
  // }
}
