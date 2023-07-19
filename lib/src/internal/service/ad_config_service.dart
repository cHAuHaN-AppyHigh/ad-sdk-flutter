import 'dart:convert';
import 'dart:io';
import 'package:adsdk/src/internal/models/ad_sdk_app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/adsdk_logger.dart';
import '../utils/constants.dart';
import '../utils/app_info.dart';
import 'package:http/http.dart' as http;

import '../utils/rsa_token_generator.dart';

class AdConfigService {
  final _configKey = 'ad_sdk_config';

  Future<AdSdkAppConfig?> fetch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? encodedString = sharedPreferences.getString(_configKey);
    _syncWithServer();
    if (encodedString != null) {
      return AdSdkAppConfig.fromMap(jsonDecode(encodedString));
    }
    return null;
  }

  Future<void> _syncWithServer() async {
    try {
      String authToken = await RSATokenGenerator().getJWTToken();
      AppInfo appInfo = await AppInfo.fromPlatform();
      final response = await http.post(
        Uri.parse("${AdSdkConstants.baseUrl}${AdSdkConstants.endpoint}"),
        body: {
          'packageId': appInfo.packageId,
          'platform': 'FLUTTER-${Platform.isAndroid ? 'ANDROID' : 'IOS'}'
        },
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      var jsonResponse = jsonDecode(response.body);
      AdSdkLogger.info(jsonResponse.toString());
      if (response.statusCode == 200) {
        var data = jsonResponse['app'];
        _cacheResponse(jsonEncode(data));
      } else {
        throw Exception('Bad Response');
      }
    } catch (e, stack) {
      print(stack);
      AdSdkLogger.error(e.toString());
      throw Exception(e.toString());
    }
  }

  _cacheResponse(String encodedString) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_configKey, encodedString);
  }
}
