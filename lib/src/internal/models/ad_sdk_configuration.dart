class AdSdkConfiguration {
  final bool isTestMode;
  final bool personalisedAds;
  final List<String> applovinTestDevices;
  final List<String> googleAdsTestDevices;

  AdSdkConfiguration({
    this.isTestMode = true,
    this.applovinTestDevices = const [],
    this.googleAdsTestDevices = const [],
    this.personalisedAds = false,
  });
}
