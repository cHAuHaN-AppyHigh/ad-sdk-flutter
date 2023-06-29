import 'dart:async';
import 'package:applovin_max/applovin_max.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/interstitial_ad/interstitial_ad.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:adsdk/src/internal/listeners/ad_show_listener.dart';

class ApplovinInterstitialAd extends InterstitialAd
    implements InterstitialListener {
  MaxAd? _ad;

  MaxAd get interstitialAd => _ad!;

  ApplovinInterstitialAd(super.adId) {
    AppLovinMAX.setInterstitialListener(this);
  }

  late AdLoadListener _loadListener;

  late AdShowListener _showListener;

  @override
  Future<void> loadAd({
    int retryCounts = 3,
    required AdLoadListener adLoadListener,
  }) async {
    _loadListener = adLoadListener;
    AppLovinMAX.loadInterstitial(adId);
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    _showListener = adShowListener;
    AppLovinMAX.showInterstitial(adId);
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
  Function(MaxAd ad) get onAdDisplayedCallback => (MaxAd ad) {
        if (ad.adUnitId == adId) {
          _showListener.onAdSuccess();
        }
      };

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
}
