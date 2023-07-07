import 'dart:async';
import 'dart:ui';

import 'package:adsdk/src/admanager/utils/admob_config.dart';
import 'package:adsdk/src/admob/banner_ad/admob_banner_ad.dart';
import 'package:adsdk/src/admob/rewarded_interstitial_ad/admob_rewarded_interstitial_ad.dart';
import 'package:adsdk/src/applovin/app_open_ad/applovin_app_open_ad.dart';
import 'package:adsdk/src/applovin/interstitial_ad/applovin_interstitial_ad.dart';
import 'package:adsdk/src/applovin/rewarded_ad/applovin_rewarded_ad.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';

import 'ad_sdk.dart';
import 'admanager/interstitial_ad/admanager_interstitial_ad.dart';
import 'admob/app_open_ad/admob_app_open_ad.dart';
import 'admob/interstitial_ad/admob_interstitial_ad.dart';
import 'admob/native_ad/admob_native_ad.dart';
import 'admob/rewarded_ad/admob_rewarded_ad.dart';
import 'admob/utils/admob_config.dart';
import 'internal/ad.dart';
import 'internal/enums/ad_provider.dart';
import 'internal/enums/ad_type.dart';
import 'internal/listeners/ad_load_listener.dart';
import 'internal/listeners/ad_show_listener.dart';
import 'internal/models/ad_entity_config.dart';

enum AdLoadState { success, failed }

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
      AdSdkLogger.info('$appyhighId ${ad?.adId} loaded ${ad?.provider}');
    }, () {
      onAdFailedToLoad();
      _setAdState(AdLoadState.failed);
      AdSdkLogger.info(
          '$appyhighId ${ad?.adId} failed to load ${ad?.provider}');
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
      '$appyhighId ${isPrimary ? 'Primary' : 'Secondary'} Loading ${_ad?.adId} for ${_ad?.provider} loadAd',
    );


    _loadAdWithMultipleTries(
      _ad!,
      onAdLoaded: () {
        onAdLoaded();
      },
      onAdFailedToLoad: () {
        _loadAd(
          onAdLoaded,
          onAdFailedToLoad,
          isPrimary: isPrimary,
          index: ++index,
        );
      },
    );
  }

  _loadAdWithMultipleTries(
    Ad ad, {
    required VoidCallback onAdLoaded,
    required VoidCallback onAdFailedToLoad,
    int maxRetry = 3,
  }) {
    AdSdkLogger.info(
        '$appyhighId Loading ${ad.adId} for ${ad.provider} loadAdWithMultipleTries $maxRetry');
    ad.loadAd(
      adLoadListener: CustomAdLoadListener(
        onAdLoadSuccess: onAdLoaded,
        onAdLoadFailure: () {
          if (maxRetry > 0) {
            _loadAdWithMultipleTries(
              ad,
              onAdLoaded: onAdLoaded,
              onAdFailedToLoad: onAdFailedToLoad,
              maxRetry: maxRetry - 1,
            );
          } else {
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

  Ad _provideAd(String adId, AdProvider adProvider) {
    AdUnitType adUnitType = _adConfig!.adType;
    switch (adProvider) {
      case AdProvider.admob:
        final config = AdmobConfig();
        switch (adUnitType) {
          case AdUnitType.appOpen:
            return AdmobAppOpenAd(adId, adRequest: config.adRequest);
          case AdUnitType.interstitial:
            return AdmobInterstitialAd(adId, adRequest: config.adRequest);
          case AdUnitType.rewarded:
            return AdmobRewardedAd(adId, adRequest: config.adRequest);
          case AdUnitType.rewardInterstitial:
            return AdmobRewardedInterstitialAd(adId,
                adRequest: config.adRequest);
          case AdUnitType.banner:
            return AdmobBannerAd(adId, _adConfig!.size,
                adRequest: config.adRequest);
          case AdUnitType.native:
            return AdmobNativeAd(adId, _adConfig!.size,
                adRequest: config.adRequest);
        }
      case AdProvider.admanager:
        final config = AdManagerConfig();
        switch (adUnitType) {
          case AdUnitType.interstitial:
            return AdManagerInterstitialAd(adId, adRequest: config.adRequest);
          default:
            throw Exception();
        }
      case AdProvider.applovin:
        switch (adUnitType) {
          case AdUnitType.interstitial:
            return ApplovinInterstitialAd(adId);
          case AdUnitType.appOpen:
            return ApplovinAppOpenAd(adId);
          case AdUnitType.rewarded:
            return ApplovinRewardedAd(adId);
          case AdUnitType.rewardInterstitial:
            return ApplovinRewardedAd(adId);
          default:
            throw Exception();
        }
    }
  }
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
