import 'ad_entity_config.dart';

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