import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  late PackageInfo _packageInfo;

  static Future<AppInfo> fromPlatform() async {
    AppInfo deviceConfig = AppInfo._();
    await deviceConfig._init();
    return deviceConfig;
  }

  Future<void> _init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  AppInfo._();

  String get versionName => _packageInfo.version;

  String get versionCode => _packageInfo.buildNumber;

  String get packageId => _packageInfo.packageName;
}
