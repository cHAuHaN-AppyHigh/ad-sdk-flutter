import 'dart:async';
import 'dart:ui';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:adsdk/src/util/ad_provider_factory.dart';
import 'ad_sdk.dart';
import 'internal/ad.dart';
import 'internal/listeners/ad_load_listener.dart';
import 'internal/models/ad_entity_config.dart';

enum AdLoadState { success, failed }

abstract class AdEntity {
  final String _appyhighId;

  Ad? _ad;

  Ad? get ad => _ad;

  AdEntity(this._appyhighId) {
    if (!AdSdk.adConfigs.containsKey(_appyhighId)) {
      AdSdkLogger.error('$_appyhighId Doesn\'t exist');
      return;
    }
    AdSdkLogger.info(AdSdk.adConfigs.toString());
    _adConfig = AdSdk.adConfigs[_appyhighId]!;
  }

  AdEntityConfig? _adConfig;

  late final StreamController<AdLoadState> _adLoadStateController =
      StreamController<AdLoadState>.broadcast(onListen: () {
    if (_adLoadState != null) {
      _adLoadStateController.sink.add(_adLoadState!);
    }
  });

  Stream<AdLoadState> get onAdLoadStateChanged => _adLoadStateController.stream;

  AdLoadState? _adLoadState;

  void _setAdState(AdLoadState loadState) {
    _adLoadState = loadState;
    _adLoadStateController.sink.add(_adLoadState!);
  }

  Future<void> loadAd(
      {required VoidCallback onAdLoaded,
      required VoidCallback onAdFailedToLoad}) async {
    _adLoadState = null;
    return _loadAd(() async {
      onAdLoaded();
      _setAdState(AdLoadState.success);
      AdSdkLogger.info('$_appyhighId ${ad?.adId} loaded ${ad?.provider}');
    }, () {
      onAdFailedToLoad();
      _setAdState(AdLoadState.failed);
      AdSdkLogger.info(
          '$_appyhighId ${ad?.adId} failed to load ${ad?.provider}');
    });
  }

  Future<void> _loadAd(
    VoidCallback onAdLoaded,
    VoidCallback onAdFailedToLoad, {
    bool isPrimary = true,
    int index = 0,
  }) async {
    if (!isActive) {
      onAdFailedToLoad();
      return;
    }

    AdEntityConfig adConfig = _adConfig!;

    if (isPrimary) {
      try {
        _ad = _provideAd(
          adConfig.primaryIds[index],
          adConfig.primaryAdProvider,
        );
      } catch (_) {
        return _loadAd(
          onAdLoaded,
          onAdFailedToLoad,
          isPrimary: false,
          index: 0,
        );
      }
    } else {
      try {
        _ad = _provideAd(
          adConfig.secondaryIds[index],
          adConfig.secondaryAdProvider,
        );
      } catch (_) {
        onAdFailedToLoad();
        return;
      }
    }
    AdSdkLogger.info(
      '$_appyhighId ${isPrimary ? 'Primary' : 'Secondary'} Loading ${_ad?.adId} for ${_ad?.provider} loadAd',
    );

    ///Incase if Ad wasn't loaded in t seconds
    _loadAdWithTimeout(
      _ad!,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: () => _loadAd(
        onAdLoaded,
        onAdFailedToLoad,
        isPrimary: isPrimary,
        index: ++index,
      ),
      timeoutDuration: Duration(milliseconds: adConfig.primaryAdLoadTimeoutMs),
    );
  }

  _loadAdWithTimeout(Ad ad,
      {required VoidCallback onAdLoaded,
      required VoidCallback onAdFailedToLoad,
      required Duration timeoutDuration}) {
    final Completer adCompleter = Completer();
    Timer timer = Timer(timeoutDuration, () {
      if (!adCompleter.isCompleted) {
        AdSdkLogger.info(
          '$_appyhighId Coulnd\'t load ${_ad?.adId} for ${_ad?.provider} loadAd, closed using timer $timeoutDuration',
        );
        adCompleter.complete(null);
        onAdFailedToLoad();
      }
    });

    DateTime start = DateTime.now();
    ad.loadAd(
      adLoadListener: CustomAdLoadListener(
        onAdLoadSuccess: () {
          AdSdkLogger.info(
            '$_appyhighId ${_ad?.adId} for ${_ad?.provider} loaded in ${DateTime.now().difference(start)}',
          );
          if (!adCompleter.isCompleted) {
            adCompleter.complete(null);
            timer.cancel();
            onAdLoaded();
          }
        },
        onAdLoadFailure: () {
          if (!adCompleter.isCompleted) {
            adCompleter.complete(null);
            timer.cancel();
            onAdFailedToLoad();
          }
        },
      ),
    );
  }

  bool get isActive => _adConfig != null && _adConfig!.isActive;

  void dispose() {
    _ad?.dispose();
    _ad = null;
  }

  Ad _provideAd(String adId, AdProvider adProvider) =>
      AdProviderFactory.provideAd(
        adId,
        adProvider,
        _adConfig!,
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
