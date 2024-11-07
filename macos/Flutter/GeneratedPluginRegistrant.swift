//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import desktop_drop
import desktop_multi_window
import flutter_inappwebview_macos
import path_provider_foundation
import screen_retriever_macos
import shared_preferences_foundation
import sqlite3_flutter_libs
import tray_manager
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DesktopDropPlugin.register(with: registry.registrar(forPlugin: "DesktopDropPlugin"))
  FlutterMultiWindowPlugin.register(with: registry.registrar(forPlugin: "FlutterMultiWindowPlugin"))
  InAppWebViewFlutterPlugin.register(with: registry.registrar(forPlugin: "InAppWebViewFlutterPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverMacosPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverMacosPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  Sqlite3FlutterLibsPlugin.register(with: registry.registrar(forPlugin: "Sqlite3FlutterLibsPlugin"))
  TrayManagerPlugin.register(with: registry.registrar(forPlugin: "TrayManagerPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
