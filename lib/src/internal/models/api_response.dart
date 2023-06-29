import 'dart:convert';
import '../enums/ad_provider.dart';
import '../enums/ad_size.dart';
import '../enums/ad_type.dart';

class AdSdkApiResponse {
  final String? status;
  final String? message;
  final AdSdkAppConfig app;

  AdSdkApiResponse({
    required this.status,
    required this.message,
    required this.app,
  });

  factory AdSdkApiResponse.fromMap(Map<String, dynamic> map) {
    return AdSdkApiResponse(
      status: map['status'],
      message: map['message'],
      app: AdSdkAppConfig.fromMap(map['app'] as Map<String, dynamic>),
    );
  }
}

class AdSdkAppConfig {
  final bool showAppAds;
  final bool isActive;
  final String? redirectLinkDescription;
  final String? redirectLink;
  final bool? enablePopup;
  final String id;
  final String appName;
  final String packageId;
  final String platform;
  final int latestVersion;
  final int criticalVersion;
  final String appUid;
  final List<AdEntityConfig> ads;
  final String createdAt;
  final String updatedAt;
  final int v;

  AdSdkAppConfig({
    required this.showAppAds,
    required this.isActive,
    required this.redirectLinkDescription,
    required this.redirectLink,
    required this.enablePopup,
    required this.id,
    required this.appName,
    required this.packageId,
    required this.platform,
    required this.latestVersion,
    required this.criticalVersion,
    required this.appUid,
    required this.ads,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AdSdkAppConfig.fromMap(Map<String, dynamic> map) {
    return AdSdkAppConfig(
      showAppAds: map['showAppAds'],
      isActive: map['isActive'],
      redirectLinkDescription: map['redirectLinkDescription'],
      redirectLink: map['redirectLink'],
      enablePopup: map['enablePopup'],
      id: map['_id'],
      appName: map['appName'],
      packageId: map['packageId'],
      platform: map['platform'],
      latestVersion: map['latestVersion'],
      criticalVersion: map['criticalVersion'],
      appUid: map['appUid'],
      ads: List<AdEntityConfig>.from(
        (map['adMob']).map<AdEntityConfig>(
          (x) => AdEntityConfig.fromMap(x),
        ),
      ),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      v: map['__v'],
    );
  }
}

class AdEntityConfig {
  final List<String> primaryIds;
  final List<String> secondaryIds;
  final String id;
  final String adName;
  final AdProvider primaryAdProvider;
  final AdProvider secondaryAdProvider;
  final AdUnitType adType;
  final bool isActive;
  final int refreshRateMs;
  final String colorHex;
  final String colorHexDark;
  final String textColor;
  final String textColorDark;
  final String bgColor;
  final String bgColorDark;
  final AdSdkAdSize size;
  final int primaryAdLoadTimeoutMs;
  final int backgroundThreshold;
  final int mediaHeight;

  AdEntityConfig({
    required this.primaryIds,
    required this.secondaryIds,
    required this.id,
    required this.adName,
    required this.primaryAdProvider,
    required this.secondaryAdProvider,
    required this.adType,
    required this.isActive,
    required this.refreshRateMs,
    required this.colorHex,
    required this.colorHexDark,
    required this.textColor,
    required this.textColorDark,
    required this.bgColor,
    required this.bgColorDark,
    required this.size,
    required this.primaryAdLoadTimeoutMs,
    required this.backgroundThreshold,
    required this.mediaHeight,
  });

  factory AdEntityConfig.fromMap(Map<String, dynamic> map) {
    return AdEntityConfig(
      primaryIds: List<String>.from(map['primary_ids']),
      secondaryIds: List<String>.from(map['secondary_ids']),
      id: map['_id'],
      adName: map['ad_name'],
      primaryAdProvider: AdProvider.values.firstWhere(
        (element) =>
            element.key.toLowerCase() ==
            map['primary_adprovider'].toLowerCase(),
        orElse: () => AdProvider.admob,
      ),
      secondaryAdProvider: AdProvider.values.firstWhere(
        (element) =>
            element.key.toLowerCase() ==
            map['secondary_adprovider'].toLowerCase(),
        orElse: () => AdProvider.admob,
      ),
      adType: AdUnitType.values.firstWhere(
        (element) => element.key.toLowerCase() == map['ad_type'].toLowerCase(),
        orElse: () => AdUnitType.interstitial,
      ),
      isActive: map['isActive'],
      refreshRateMs: map['refresh_rate_ms'],
      colorHex: map['color_hex'],
      colorHexDark: map['color_hex_dark'],
      textColor: map['text_color'],
      textColorDark: map['text_color_dark'],
      bgColor: map['bg_color'],
      bgColorDark: map['bg_color_dark'],
      size: AdSdkAdSize.values.firstWhere(
        (element) => element.key.toLowerCase() == map['size'].toLowerCase(),
        orElse: () => AdSdkAdSize.banner,
      ),
      primaryAdLoadTimeoutMs: map['primary_adload_timeout_ms'] ?? 0,
      backgroundThreshold: map['background_threshold'] ?? 0,
      mediaHeight: map['mediaHeight'] ?? 0,
    );
  }
}
