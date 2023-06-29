abstract class ApplovinListener {
  String get applovinAdId;

  void onFailedToLoadAd();

  void onAdLoaded();

  void onAdClosed();

  void onAdSuccess();

  void onAdFailedToShow();
}
