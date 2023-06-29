import 'package:applovin_max/applovin_max.dart';

import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';
import '../../internal/rewarded_ad/rewarded_ad.dart';

class ApplovinRewardedAd extends RewardedAd implements RewardedAdListener {
  MaxAd? _ad;

  MaxAd get rewardedAd => _ad!;

  ApplovinRewardedAd(super.adId) {
    AppLovinMAX.setRewardedAdListener(this);
  }

  late AdLoadListener _loadListener;

  late AdShowListener _showListener;

  @override
  Future<void> loadAd({
    int retryCounts = 3,
    required AdLoadListener adLoadListener,
  }) async {
    _loadListener = adLoadListener;
    AppLovinMAX.loadRewardedAd(adId);
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    _showListener = adShowListener;
    AppLovinMAX.showRewardedAd(adId);
  }

  @override
  void dispose() {
    _ad = null;
  }

  @override
  AdProvider get provider => AdProvider.applovin;

  @override
  Function(MaxAd ad) get onAdClickedCallback => (MaxAd ad) {};

  @override
  Function(MaxAd ad, MaxError error) get onAdDisplayFailedCallback =>
      (MaxAd ad, MaxError error) {
        if (ad.adUnitId == adId) {
          _showListener.onAdFailedToShow();
        }
      };

  @override
  Function(MaxAd ad) get onAdDisplayedCallback => (MaxAd ad) {};

  @override
  Function(MaxAd ad) get onAdHiddenCallback => (MaxAd ad) {};

  @override
  Function(String adUnitId, MaxError error) get onAdLoadFailedCallback =>
      (String adUnitId, MaxError error) {
        if (adUnitId == adId) {
          _loadListener.onFailedToLoadAd();
        }
      };

  @override
  Function(MaxAd ad) get onAdLoadedCallback => (MaxAd ad) {
        if (ad.adUnitId == adId) {
          _loadListener.onAdLoaded();
        }
      };

  @override
  Function(MaxAd ad)? get onAdRevenuePaidCallback => (MaxAd ad) {};

  @override
  Function(MaxAd ad, MaxReward reward) get onAdReceivedRewardCallback =>
      (MaxAd ad, MaxReward reward) {
        if (ad.adUnitId == adId) {
          _showListener.onAdSuccess();
        }
      };
}
