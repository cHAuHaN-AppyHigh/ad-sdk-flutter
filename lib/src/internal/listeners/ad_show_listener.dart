abstract class AdShowListener {
  void onAdClosed();
  ///On this callback we can start the next process, for interstitial, app open it will be shown when it's viewed
  ///But for rewarded it will be only called when user has got the reward
  void onAdSuccess();

  void onAdFailedToShow();
}
