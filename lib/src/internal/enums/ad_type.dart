enum AdUnitType {
  appOpen("appopen"),
  interstitial("interstitial"),
  rewarded("rewarded"),
  rewardInterstitial("rewardInterstitial"),
  banner("banner"),
  native("native");

  final String key;

  const AdUnitType(this.key);
}