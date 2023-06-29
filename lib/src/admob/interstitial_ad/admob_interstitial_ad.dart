import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/enums/ad_provider.dart';
import '../../internal/interstitial_ad/interstitial_ad.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';

class AdmobInterstitialAd extends InterstitialAd {
  final google_ads.AdRequest adRequest;

  google_ads.InterstitialAd? _ad;

  google_ads.InterstitialAd get interstitialAd => _ad!;

  AdmobInterstitialAd(
    super.adId, {
    required this.adRequest,
  });

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    google_ads.InterstitialAd.load(
      adUnitId: adId,
      request: adRequest,
      adLoadCallback: google_ads.InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          adLoadListener.onAdLoaded();
        },
        onAdFailedToLoad: (error) {
          adLoadListener.onFailedToLoadAd();
        },
      ),
    );
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    if (_ad == null) {
      throw Exception('Ad not loaded');
    }
    _ad!.fullScreenContentCallback = google_ads.FullScreenContentCallback(
        onAdDismissedFullScreenContent: (google_ads.InterstitialAd ad) async {
      adShowListener.onAdClosed();
      dispose();
    }, onAdFailedToShowFullScreenContent:
            (google_ads.InterstitialAd ad, _) async {
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
