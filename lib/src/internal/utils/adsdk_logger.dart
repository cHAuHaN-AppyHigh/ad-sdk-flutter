import 'dart:developer';
import 'package:adsdk/src/internal/constants/constants.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';

abstract class AdSdkLogger {
  static String info(String message) {
    log(message, name: AdSdkConstants.infoTag);
    return message;
  }

  static String error(String message) {
    log(message, name: AdSdkConstants.errorTag);
    return message;
  }
  static void adLoadedLog({
    required String adName,
    required AdProvider adProvider,
  }) {
    log("Ad Loaded - (AdName: $adName, AdProvider: ${adProvider.key})");
  }
}
