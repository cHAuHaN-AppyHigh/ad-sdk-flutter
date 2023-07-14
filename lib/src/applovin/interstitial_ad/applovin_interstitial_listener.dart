import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:applovin_max/applovin_max.dart';

class ApplovinInterstitialListener implements InterstitialListener {
  final List<ApplovinListener> _listeners = [];

  void addListener(ApplovinListener applovinListener) {
    _listeners.add(applovinListener);
  }

  void removeListener(ApplovinListener applovinListener) {
    _listeners.remove(applovinListener);
  }

  static ApplovinInterstitialListener? _instance;

  static ApplovinInterstitialListener get instance =>
      _instance ??= ApplovinInterstitialListener._();

  ApplovinInterstitialListener._() {
    AppLovinMAX.setInterstitialListener(this);
  }

  @override
  Function(MaxAd ad) get onAdClickedCallback => (MaxAd ad) {};

  @override
  Function(MaxAd ad, MaxError error) get onAdDisplayFailedCallback =>
      (MaxAd ad, MaxError error) {
        AdSdkLogger.info('Applovin ${ad.adUnitId} onAdDisplayFailedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdFailedToShow();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdDisplayedCallback => (MaxAd ad) {
        AdSdkLogger.info('Applovin ${ad.adUnitId} onAdDisplayedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdSuccess();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdHiddenCallback => (MaxAd ad) {
        AdSdkLogger.info('Applovin ${ad.adUnitId} onAdHiddenCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdClosed();
          }
        }
      };

  @override
  Function(String adUnitId, MaxError error) get onAdLoadFailedCallback =>
      (String adUnitId, MaxError error) {
        AdSdkLogger.info('Applovin $adUnitId onAdLoadFailedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == adUnitId) {
            element.onFailedToLoadAd();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdLoadedCallback => (MaxAd ad) {
        AdSdkLogger.info('Applovin ${ad.adUnitId} onAdLoadedCallback');
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdLoaded();
          }
        }
      };

  @override
  Function(MaxAd ad)? get onAdRevenuePaidCallback => (MaxAd ad) {};
}
