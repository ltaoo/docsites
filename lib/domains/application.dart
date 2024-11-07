import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '/database/database.dart';
import '/utils.dart';

class ApplicationPaths {
  String root;
  String site;
  String archive;
  String database;
  String download;

  ApplicationPaths({required this.root, required this.site, required this.archive, required this.database, required this.download});

  ensure() async {
    Directory directory = await getApplicationDocumentsDirectory();
    if (Util.isWindows()) {
      final path = Platform.environment['APPData'];
      if (kDebugMode) {
        print("in windows platform, read AppData env as db folder $path");
      }
      if (path != null) {
        directory = Directory(path);
      }
    }
    root = path.join(directory.path, "docsites");
    site = path.join(root, "site");
    await Util.ensureDirectoriesExist(site);
    archive = path.join(root, "archive");
    await Util.ensureDirectoriesExist(archive);
    database = path.join(root, "database");
    await Util.ensureDirectoriesExist(database);
    Directory? directory_download = await getDownloadsDirectory();
    if (directory_download != null) {
      download = directory_download.path;
    }
  }
}

class ApplicationCore with ChangeNotifier {
  ApplicationPaths paths;
  AppDatabase db;

  ApplicationCore({required this.paths, required this.db});

  ensure() async {
    await paths.ensure();
  }

  close() {
    db.close();
  }
}
