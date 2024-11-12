import 'dart:io';
import 'package:flutter/foundation.dart';

class Util {
  static bool urlIsSecure(Uri url) {
    return (url.scheme == "https") || Util.isLocalizedContent(url);
  }

  static bool isLocalizedContent(Uri url) {
    return (url.scheme == "file" || url.scheme == "chrome" || url.scheme == "data" || url.scheme == "javascript" || url.scheme == "about");
  }

  static bool isMobile() {
    return isAndroid() || isIOS();
  }

  static bool isAndroid() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  static bool isIOS() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isDesktop() {
    return !isMobile();
  }

  static bool isMacOS() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool isWindows() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static Future<void> sleep(int delay) async {
    await Future.delayed(Duration(seconds: delay));
  }

  static Future<void> ensureDirectoriesExist(String path) async {
    final dir = Directory(path);
    final lastPart = path.split('/').last;
    final isFile = lastPart.contains('.');
    if (isFile) {
      await ensureDirectoriesExist(dir.parent.path);
    } else {
      // 检查当前目录是否存在
      if (!await dir.exists()) {
        await ensureDirectoriesExist(dir.parent.path);
        await dir.create();
        print('Created directory: ${dir.path}');
      } else {
        print('Directory already exists: ${dir.path}');
      }
    }
  }

  static Future<void> deleteFolder(Directory folder) async {
    try {
      if (await folder.exists()) {
        var contents = folder.listSync();
        for (var file in contents) {
          if (file is File) {
            await file.delete();
          } else if (file is Directory) {
            await deleteFolder(file);
          }
        }
        await folder.delete();
        print('文件夹 ${folder.path} 已成功删除');
      } else {
        print('文件夹 ${folder.path} 不存在');
      }
    } catch (e) {
      print('删除文件夹时出错: $e');
    }
  }
}
