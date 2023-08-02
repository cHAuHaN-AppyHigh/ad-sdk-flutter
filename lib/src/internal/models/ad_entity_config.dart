import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/enums/ad_size.dart';
import 'package:adsdk/src/internal/enums/ad_type.dart';

class AdEntityConfig {
  final List<String> primaryIds;
  final List<String> secondaryIds;
  late final List<String> fallbackIds;
  final String id;
  final String adName;
  final AdProvider primaryAdProvider;
  final AdProvider secondaryAdProvider;
  late final AdProvider fallbackAdProvider;
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

  void setFallbackAds(AdProvider fallbackAdProvider, List<String> fallbackIds) {
    this.fallbackAdProvider = fallbackAdProvider;
    this.fallbackIds = fallbackIds;
  }

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
      primaryAdLoadTimeoutMs: map['primary_adload_timeout_ms'] ?? 5000,
      backgroundThreshold: map['background_threshold'] ?? 1000,
      mediaHeight: map['mediaHeight'] ?? 0,
    );
  }
}
