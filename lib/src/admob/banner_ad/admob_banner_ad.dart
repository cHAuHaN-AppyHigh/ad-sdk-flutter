import 'package:adsdk/src/internal/banner_ad/banner_ad.dart';
import 'package:adsdk/src/internal/enums/ad_provider.dart';
import 'package:adsdk/src/internal/listeners/ad_load_listener.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/enums/ad_size.dart';

class AdmobBannerAd extends BannerAd {
  final google_ads.AdRequest adRequest;
  final AdSdkAdSize _sdkAdSize;

  AdmobBannerAd(
    super.adId,
    this._sdkAdSize, {
    required this.adRequest,
  });

  google_ads.BannerAd? _ad;

  google_ads.BannerAd get bannerAd => _ad!;

  bool _isAdLoaded = false;

  bool _failedToLoad = false;

  @override
  void dispose() {
    _isAdLoaded = false;
    _failedToLoad = false;
    _ad?.dispose();
    _ad = null;
  }

  google_ads.AdSize get _bannerSize {
    switch (_sdkAdSize) {
      case AdSdkAdSize.banner:
        return google_ads.AdSize.banner;
      case AdSdkAdSize.largeBanner:
        return google_ads.AdSize.largeBanner;
      case AdSdkAdSize.mediumBanner:
        return google_ads.AdSize.mediumRectangle;
      default:
        return google_ads.AdSize.banner;
    }
  }

  @override
  Future<void> loadAd({required AdLoadListener adLoadListener}) async {
    google_ads.BannerAd(
      size: _bannerSize,
      adUnitId: adId,
      listener: google_ads.BannerAdListener(onAdLoaded: (ad) {
        adLoadListener.onAdLoaded();
        _ad = ad as google_ads.BannerAd;
        _isAdLoaded = true;
        _failedToLoad = false;
      }, onAdFailedToLoad: (ad, error) {
        adLoadListener.onFailedToLoadAd();
        _failedToLoad = true;
        _isAdLoaded = false;
      }),
      request: adRequest,
    ).load();
  }

  @override
  AdProvider get provider => AdProvider.admob;

  @override
  Widget build() => SizedBox(
        height: height,
        width: width,
        child: google_ads.AdWidget(
          ad: bannerAd,
        ),
      );

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  bool get adFailedToLoad => _failedToLoad;

  @override
  double get height => _bannerSize.height.toDouble();

  @override
  double get width => _bannerSize.width.toDouble();
}
