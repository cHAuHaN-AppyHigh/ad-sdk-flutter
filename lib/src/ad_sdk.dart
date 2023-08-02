import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/models/user_model.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'internal/models/ad_entity_config.dart';
import 'internal/models/ad_sdk_app_config.dart';
import 'internal/models/ad_sdk_configuration.dart';
import 'internal/service/ad_config_service.dart';
import 'internal/utils/adsdk_logger.dart';

class AdSdk {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static late final AdSdkConfiguration _adSdkConfig;

  static late final Map<String, AdEntityConfig> _adConfigs;

  static Map<String, AdEntityConfig> get adConfigs => _adConfigs;

  static AdSdkConfiguration get adSdkConfig => _adSdkConfig;

  static bool _isDebug = false;

  static bool get isDebug => _isDebug;

  static Future<void> initialise({
    required AdSdkAppConfig defaultAdSdkAppConfig,
    required String userId,
    AdSdkConfiguration? adSdkConfiguration,
    bool isDebug = false,
    String? appLovinKey,
    String? enforcePackageId,
    String? enforcePlatform,
  }) async {
    _isDebug = isDebug;

    currentUser = UserModel(id: userId);

    _adSdkConfig = adSdkConfiguration ?? AdSdkConfiguration();

    AdSdkAppConfig adSdkAppConfig = (await _fetchAdConfig(
          enforcePackageId: enforcePackageId,
          enforcePlatform: enforcePlatform,
        )) ??
        defaultAdSdkAppConfig;

    _adConfigs = {};

    if (!adSdkAppConfig.showAppAds) {
      AdSdkLogger.error("Ads disabled from backend.");
      return;
    }

    for (var ad in adSdkAppConfig.ads) {
      _adConfigs[ad.adName] = ad;

      ///Setting Default Fallback ids
      final defaultAdConfig = defaultAdSdkAppConfig.ads.firstWhere(
        (element) => element.adName == ad.adName,
      );
      _adConfigs[ad.adName]!.setFallbackAds(
        defaultAdConfig.primaryAdProvider,
        defaultAdConfig.primaryIds,
      );
    }

    await MobileAds.instance.initialize();
    AdSdkLogger.info("Google ads initialized.");

    if (_adSdkConfig.googleAdsTestDevices.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        testDeviceIds: _adSdkConfig.googleAdsTestDevices,
      ));
    }

    if (appLovinKey != null) {
      if (_adSdkConfig.applovinTestDevices.isNotEmpty) {
        AppLovinMAX.setTestDeviceAdvertisingIds(
          _adSdkConfig.applovinTestDevices,
        );
      }

      await AppLovinMAX.initialize(appLovinKey);

      AdSdkLogger.info("Applovin initialized.");
    }

    _isInitialized = true;
  }

  static Future<AdSdkAppConfig?> _fetchAdConfig({
    String? enforcePackageId,
    String? enforcePlatform,
  }) =>
      AdConfigService().fetch(
        enforcePackageId: enforcePackageId,
        enforcePlatform: enforcePlatform,
      );
}
