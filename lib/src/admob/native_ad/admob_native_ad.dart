import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:adsdk/src/internal/native_ad/native_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;

import '../../internal/enums/ad_size.dart';

class AdmobNativeAd extends NativeAd {
  final google_ads.AdRequest adRequest;
  final AdSdkAdSize _sdkAdSize;

  AdmobNativeAd(
    super.adId,
    this._sdkAdSize, {
    required this.adRequest,
  });

  google_ads.NativeAd? _ad;

  google_ads.NativeAd get nativeAd => _ad!;

  bool _isAdLoaded = false;

  bool _failedToLoad = false;

  @override
  void dispose() {
    _isAdLoaded = false;
    _failedToLoad = false;
    _ad?.dispose();
    _ad = null;
  }

  Size get _nativeSize {
    switch (_sdkAdSize) {
      case AdSdkAdSize.mediumNative:
        return const Size(468, 250);
      case AdSdkAdSize.smallNative:
        return const Size(468, 72);
      default:
        return const Size(468, 72);
    }
  }

  String get _factoryId {
    switch (_sdkAdSize) {
      case AdSdkAdSize.mediumNative:
        return 'nativeAdView';
      case AdSdkAdSize.smallNative:
        return 'smallNativeAdView';
      default:
        return 'nativeAdView';
    }
  }

  @override
  Future<void> loadAd({required AdLoadListener adLoadListener}) async {
    google_ads.NativeAd(
      request: adRequest,
      adUnitId: adId,
      factoryId: _factoryId,
      listener: google_ads.NativeAdListener(onAdLoaded: (ad) {
        adLoadListener.onAdLoaded();
        _ad = ad as google_ads.NativeAd;
        _isAdLoaded = true;
        _failedToLoad = false;
      }, onAdFailedToLoad: (ad, error) {
        adLoadListener.onFailedToLoadAd();
        _failedToLoad = true;
        _isAdLoaded = false;
      }),
    ).load();
  }

  @override
  AdProvider get provider => AdProvider.admob;

  @override
  Widget build() => SizedBox(
        height: height,
        width: width,
        child: google_ads.AdWidget(
          ad: nativeAd,
        ),
      );

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  bool get adFailedToLoad => _failedToLoad;

  @override
  double get height => _nativeSize.height;

  @override
  double get width => _nativeSize.width;
}
