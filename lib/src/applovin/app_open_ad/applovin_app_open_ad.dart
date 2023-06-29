import 'dart:async';
import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;

import '../../internal/app_open_ad/app_open_ad.dart';
import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';
import '../utils/admob_config.dart';

class ApplovinAppOpenAd extends AppOpenAd implements AppOpenAdListener {
  MaxAd? _ad;

  MaxAd get appOpenAd => _ad!;

  ApplovinAppOpenAd(super.adId) {
    AppLovinMAX.setAppOpenAdListener(this);
  }

  late AdLoadListener _loadListener;

  late AdShowListener _showListener;

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    _loadListener = adLoadListener;
    AppLovinMAX.loadAppOpenAd(adId);
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    _showListener = adShowListener;
    AppLovinMAX.showAppOpenAd(adId);
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
