import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:adsdk/src/applovin/rewarded_ad/applovin_rewarded_listener.dart';
import 'package:applovin_max/applovin_max.dart';

import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';
import '../../internal/rewarded_ad/rewarded_ad.dart';

class ApplovinRewardedAd extends RewardedAd implements ApplovinListener {
  MaxAd? _ad;

  MaxAd get rewardedAd => _ad!;

  ApplovinRewardedAd(super.adId) {
    ApplovinRewardedListener.instance.addListener(this);
  }

  late AdLoadListener _loadListener;

  late AdShowListener _showListener;

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    _loadListener = adLoadListener;
    AppLovinMAX.loadRewardedAd(adId);
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    bool? isReady = await AppLovinMAX.isRewardedAdReady(adId);
    if (isReady == true) {
      _showListener = adShowListener;
      AppLovinMAX.showRewardedAd(adId);
    } else {
      throw Exception('Ad is not ready');
    }
  }

  @override
  void dispose() {
    ApplovinRewardedListener.instance.removeListener(this);
    _ad = null;
  }

  @override
  AdProvider get provider => AdProvider.applovin;

  @override
  String get applovinAdId => adId;

  @override
  void onAdLoaded() => _loadListener.onAdLoaded();

  @override
  void onFailedToLoadAd() => _loadListener.onFailedToLoadAd();

  @override
  void onAdClosed() => _showListener.onAdClosed();

  @override
  void onAdFailedToShow() => _showListener.onAdFailedToShow();

  @override
  void onAdSuccess() => _showListener.onAdSuccess();
}
