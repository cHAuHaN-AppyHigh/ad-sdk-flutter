import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/enums/ad_provider.dart';
import '../../internal/interstitial_ad/interstitial_ad.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';

class AdManagerInterstitialAd extends InterstitialAd {
  final google_ads.AdManagerAdRequest adRequest;

  google_ads.AdManagerInterstitialAd? _ad;

  google_ads.AdManagerInterstitialAd get interstitialAd => _ad!;

  AdManagerInterstitialAd(
    super.adId, {
    required this.adRequest,
  });

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    google_ads.AdManagerInterstitialAd.load(
      adUnitId: adId,
      request: adRequest,
      adLoadCallback: google_ads.AdManagerInterstitialAdLoadCallback(
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
        onAdDismissedFullScreenContent:
            (google_ads.AdManagerInterstitialAd ad) async {
      adShowListener.onAdClosed();
      dispose();
    }, onAdFailedToShowFullScreenContent:
            (google_ads.AdManagerInterstitialAd ad, _) async {
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
  AdProvider get provider => AdProvider.admanager;
}
