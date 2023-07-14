import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/app_open_ad/app_open_ad.dart';
import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';

class AdmobAppOpenAd extends AppOpenAd {
  final google_ads.AdRequest adRequest;

  google_ads.AppOpenAd? _ad;

  google_ads.AppOpenAd get appOpenAd => _ad!;

  AdmobAppOpenAd(
    super.adId, {
    required this.adRequest,
  });

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    google_ads.AppOpenAd.load(
      adUnitId: adId,
      request: adRequest,
      adLoadCallback: google_ads.AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          adLoadListener.onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          adLoadListener.onFailedToLoadAd();
        },
      ),
      orientation: google_ads.AppOpenAd.orientationPortrait,
    );
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    if (_ad == null) {
      throw Exception('Ad not loaded');
    }
    _ad?.fullScreenContentCallback = google_ads.FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
      adShowListener.onAdClosed();
      dispose();
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      adShowListener.onAdFailedToShow();
      dispose();
    }, onAdShowedFullScreenContent: (ad) {
      adShowListener.onAdSuccess();
    });
    _ad!.show();
  }

  @override
  void dispose() {
    _ad?.dispose();
    _ad = null;
  }

  @override
  AdProvider get provider => AdProvider.admob;
}
