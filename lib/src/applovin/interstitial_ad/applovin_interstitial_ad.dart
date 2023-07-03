import 'dart:async';
import 'package:adsdk/src/applovin/interstitial_ad/applovin_interstitial_listener.dart';
import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/interstitial_ad/interstitial_ad.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:adsdk/src/internal/listeners/ad_show_listener.dart';

class ApplovinInterstitialAd extends InterstitialAd
    implements ApplovinListener {
  MaxAd? _ad;

  MaxAd get interstitialAd => _ad!;

  ApplovinInterstitialAd(super.adId) {
    ApplovinInterstitialListener.instance.addListener(this);
  }

  late AdLoadListener _loadListener;

  late AdShowListener _showListener;

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    _loadListener = adLoadListener;
    AppLovinMAX.loadInterstitial(adId);
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    bool? isReady = await AppLovinMAX.isInterstitialReady(adId);
    if (isReady == true) {
      _showListener = adShowListener;
      AppLovinMAX.showInterstitial(adId);
    } else {
      throw Exception('Ad is not ready');
    }
  }

  @override
  void dispose() {
    ApplovinInterstitialListener.instance.removeListener(this);
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
