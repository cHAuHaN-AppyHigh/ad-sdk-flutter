import 'package:adsdk/src/applovin/listeners/app_lovin_listener.dart';
import 'package:applovin_max/applovin_max.dart';

class ApplovinAppOpenListener implements AppOpenAdListener {
  final List<ApplovinListener> _listeners = [];

  void addListener(ApplovinListener applovinListener) {
    _listeners.add(applovinListener);
  }

  void removeListener(ApplovinListener applovinListener) {
    _listeners.remove(applovinListener);
  }

  static ApplovinAppOpenListener? _instance;

  static ApplovinAppOpenListener get instance =>
      _instance ??= ApplovinAppOpenListener._();

  ApplovinAppOpenListener._() {
    AppLovinMAX.setAppOpenAdListener(this);
  }

  @override
  Function(MaxAd ad) get onAdClickedCallback => (MaxAd ad) {};

  @override
  Function(MaxAd ad, MaxError error) get onAdDisplayFailedCallback =>
      (MaxAd ad, MaxError error) {
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdFailedToShow();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdDisplayedCallback => (MaxAd ad) {
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdSuccess();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdHiddenCallback => (MaxAd ad) {
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdClosed();
          }
        }
      };

  @override
  Function(String adUnitId, MaxError error) get onAdLoadFailedCallback =>
      (String adUnitId, MaxError error) {
        for (var element in _listeners) {
          if (element.applovinAdId == adUnitId) {
            element.onFailedToLoadAd();
          }
        }
      };

  @override
  Function(MaxAd ad) get onAdLoadedCallback => (MaxAd ad) {
        for (var element in _listeners) {
          if (element.applovinAdId == ad.adUnitId) {
            element.onAdLoaded();
          }
        }
      };

  @override
  Function(MaxAd ad)? get onAdRevenuePaidCallback => (MaxAd ad) {};
}
