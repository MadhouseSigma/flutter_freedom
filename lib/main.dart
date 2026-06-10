import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'providers/app_provider.dart';
import 'app.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  AppVars.appName = packageInfo.appName;
  AppVars.packageName = packageInfo.packageName;
  AppVars.appVersion = packageInfo.version;
  AppVars.buildNumber = packageInfo.buildNumber;

  await windowManager.ensureInitialized();
  const windowOptions = WindowOptions(
    size: Size(960, 720),
    minimumSize: Size(800, 500),
    center: true,
    title: 'Flutter Freedom',
    backgroundColor: Color(0xFF0F2A9E),
    titleBarStyle: TitleBarStyle.hidden,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  final provider = AppProvider();
  await provider.init();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const FlutterFreedomApp(),
    ),
  );
}