import 'dart:async';
import 'package:adsdk/src/applovin/app_open_ad/applovin_app_open_listener.dart';
import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:applovin_max/applovin_max.dart';
import '../../internal/app_open_ad/app_open_ad.dart';
import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';

class ApplovinAppOpenAd extends AppOpenAd implements ApplovinListener {
  MaxAd? _ad;

  MaxAd get appOpenAd => _ad!;

  ApplovinAppOpenAd(super.adId) {
    ApplovinAppOpenListener.instance.addListener(this);
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
    bool? isReady = await AppLovinMAX.isAppOpenAdReady(adId);
    if (isReady == true) {
      _showListener = adShowListener;
      AppLovinMAX.showAppOpenAd(adId);
    } else {
      throw Exception('Ad is not ready');
    }
  }

  @override
  void dispose() {
    ApplovinAppOpenListener.instance.removeListener(this);
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
