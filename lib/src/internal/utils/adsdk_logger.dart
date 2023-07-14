import 'package:flutter/foundation.dart';

import '../enums/ad_provider.dart';
import 'constants.dart';

abstract class AdSdkLogger {
  static String info(String message) {
    debugPrint("\x1B[34m[${AdSdkConstants.tag} - INFO]: $message");
    return message;
  }

  static String error(String message) {
    debugPrint("\x1B[31m[${AdSdkConstants.tag} - INFO]: $message");
    return message;
  }
  
  static void adLoadedLog({
    required String adName,
    required AdProvider adProvider,
  }) {
    info("Ad Loaded - (AdName: $adName, AdProvider: ${adProvider.key})");
  }
}
