import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/models/user_model.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'internal/models/ad_entity_config.dart';
import 'internal/models/ad_sdk_app_config.dart';
import 'internal/models/ad_sdk_configuration.dart';
import 'internal/models/api_response.dart';
import 'internal/service/ad_config_service.dart';
import 'internal/utils/adsdk_logger.dart';

class AdSdk {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static late final AdSdkConfiguration _adSdkConfig;

  static late final Map<String, AdEntityConfig> _adConfigs;

  static Map<String, AdEntityConfig> get adConfigs => _adConfigs;

  static AdSdkConfiguration get adSdkConfig => _adSdkConfig;

  static Future<void> initialise({
    required AdSdkAppConfig defaultAdSdkAppConfig,
    required String userId,
    AdSdkConfiguration? adSdkConfiguration,
    bool isDebug = false,
    String? appLovinKey,
  }) async {
    currentUser = UserModel(id: userId);

    _adSdkConfig = adSdkConfiguration ?? AdSdkConfiguration();

    AdSdkAppConfig adSdkAppConfig =
        (await _fetchAdConfig()) ?? defaultAdSdkAppConfig;

    _adConfigs = {};

    if (!adSdkAppConfig.showAppAds) {
      AdSdkLogger.error("Ads disabled from backend.");
      return;
    }

    for (var ad in adSdkAppConfig.ads) {
      _adConfigs[ad.adName] = ad;
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

  static Future<AdSdkAppConfig?> _fetchAdConfig() async {
    try {
      return AdConfigService().fetch();
    } catch (_) {
      return null;
    }
  }
}
