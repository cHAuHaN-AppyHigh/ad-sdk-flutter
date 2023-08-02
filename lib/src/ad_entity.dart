import 'dart:async';
import 'dart:ui';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:adsdk/src/util/ad_provider_factory.dart';
import 'ad_sdk.dart';
import 'internal/ad.dart';
import 'internal/listeners/ad_load_listener.dart';
import 'internal/models/ad_entity_config.dart';

enum AdLoadState { success, failed, loading }

enum AdPriority { primary, secondary, fallback }

abstract class AdEntity {
  final String appyhighId;

  Ad? _ad;

  Ad? get ad => _ad;

  AdEntity(this.appyhighId) {
    if (!AdSdk.adConfigs.containsKey(appyhighId)) {
      AdSdkLogger.error('$appyhighId Doesn\'t exist');
      return;
    }
    AdSdkLogger.info(AdSdk.adConfigs.toString());
    _adConfig = AdSdk.adConfigs[appyhighId]!;
    _isActive = _adConfig.isActive;
  }

  late AdEntityConfig _adConfig;

  bool _isActive = false;

  bool get isActive => _isActive;

  late final StreamController<AdLoadState> _adLoadStateController =
      StreamController<AdLoadState>.broadcast(onListen: () {
    if (_adLoadState != null) {
      _adLoadStateController.sink.add(_adLoadState!);
    }
  });

  Stream<AdLoadState> get onAdLoadStateChanged => _adLoadStateController.stream;

  AdLoadState? _adLoadState;

  AdLoadState? get adLoadState => _adLoadState;

  void _setAdState(AdLoadState loadState) {
    _adLoadState = loadState;
    _adLoadStateController.sink.add(_adLoadState!);
  }

  Future<void> loadAd({
    required VoidCallback onAdLoaded,
    required VoidCallback onAdFailedToLoad,
  }) async {
    if (!_isActive) {
      onAdFailedToLoad();
      _setAdState(AdLoadState.failed);
      AdSdkLogger.info('$appyhighId is not active');
      return;
    }
    if (_adLoadState == AdLoadState.loading ||
        _adLoadState == AdLoadState.success) return;
    _adLoadState = AdLoadState.loading;
    return _loadAd((Ad ad) async {
      if (_adLoadState == AdLoadState.loading) {
        _ad = ad;
        onAdLoaded();
        _setAdState(AdLoadState.success);
        AdSdkLogger.info('$appyhighId ${ad.adId} loaded ${ad.provider}');
      }
    }, () {
      if (_adLoadState == AdLoadState.loading) {
        onAdFailedToLoad();
        _setAdState(AdLoadState.failed);
        AdSdkLogger.info('$appyhighId failed to load');
      }
    });
  }

  Future<void> _loadAd(
    Function(Ad ad) onAdLoaded,
    VoidCallback onAdFailedToLoad, {
    AdPriority adPriority = AdPriority.primary,
    int index = 0,
  }) async {
    AdSdkLogger.info('$appyhighId $adPriority Loading');

    Ad ad;

    switch (adPriority) {
      case AdPriority.primary:
        try {
          ad = _provideAd(
            _adConfig.primaryIds[index],
            _adConfig.primaryAdProvider,
          );
        } catch (_) {
          return _loadAd(
            onAdLoaded,
            onAdFailedToLoad,
            adPriority: AdPriority.secondary,
            index: 0,
          );
        }
        break;
      case AdPriority.secondary:
        try {
          ad = _provideAd(
            _adConfig.secondaryIds[index],
            _adConfig.secondaryAdProvider,
          );
        } catch (_) {
          return _loadAd(
            onAdLoaded,
            onAdFailedToLoad,
            adPriority: AdPriority.fallback,
            index: 0,
          );
        }
        break;
      case AdPriority.fallback:
        try {
          ad = _provideAd(
            _adConfig.fallbackIds[index],
            _adConfig.fallbackAdProvider,
          );
        } catch (_) {
          onAdFailedToLoad();
          return;
        }
        break;
    }

    AdSdkLogger.info(
      '$appyhighId $adPriority Loading ${_ad?.adId} for ${_ad?.provider} loadAd',
    );

    ///Incase if Ad wasn't loaded in t seconds
    _loadAdWithTimeout(
      ad,
      onAdLoaded: onAdLoaded,

      ///Both are same
      onAdFailedToLoad: () => _loadAd(
        onAdLoaded,
        onAdFailedToLoad,
        adPriority: adPriority,
        index: ++index,
      ),
      onAdDidNotLoadInTime: () => _loadAd(
        onAdLoaded,
        onAdFailedToLoad,
        adPriority: adPriority,
        index: ++index,
      ),
      timeoutDuration: Duration(milliseconds: _adConfig.primaryAdLoadTimeoutMs),
    );
  }

  _loadAdWithTimeout(Ad ad,
      {required Function(Ad ad) onAdLoaded,
      required VoidCallback onAdFailedToLoad,
      required VoidCallback onAdDidNotLoadInTime,
      required Duration timeoutDuration}) {
    Timer timer = Timer(timeoutDuration, () {
      AdSdkLogger.info(
        '$appyhighId Coulnd\'t load ${_ad?.adId} for ${_ad?.provider} loadAd, under timer $timeoutDuration',
      );
      onAdDidNotLoadInTime();
    });

    DateTime start = DateTime.now();
    ad.loadAd(
      adLoadListener: CustomAdLoadListener(
        onAdLoadSuccess: () {
          AdSdkLogger.info(
            '$appyhighId ${_ad?.adId} for ${_ad?.provider} loaded in ${DateTime.now().difference(start)}',
          );
          timer.cancel();
          onAdLoaded(ad);
        },
        onAdLoadFailure: () {
          if (timer.isActive) {
            timer.cancel();
            onAdFailedToLoad();
          }
        },
      ),
    );
  }

  void resetAdState() {
    _adLoadState = null;
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }

  Ad _provideAd(String adId, AdProvider adProvider) =>
      AdProviderFactory.provideAd(
        adId,
        adProvider,
        _adConfig,
        AdSdk.adSdkConfig,
      );
}

class CustomAdLoadListener implements AdLoadListener {
  final VoidCallback onAdLoadSuccess;
  final VoidCallback onAdLoadFailure;

  CustomAdLoadListener({
    required this.onAdLoadSuccess,
    required this.onAdLoadFailure,
  });

  @override
  void onAdLoaded() => onAdLoadSuccess();

  @override
  void onFailedToLoadAd() => onAdLoadFailure();
}
