import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/rewarded_ad/rewarded_ad.dart';
import '../utils/admob_config.dart';

class AdmobRewardedInterstitialAd extends RewardedAd {
  final google_ads.AdRequest adRequest;

  google_ads.RewardedInterstitialAd? _ad;

  google_ads.RewardedInterstitialAd get rewardedInterstitialAd => _ad!;

  AdmobRewardedInterstitialAd(
    super.adId, {
    required this.adRequest,
  });

  @override
  Future<void> loadAd({
    required AdLoadListener adLoadListener,
  }) async {
    google_ads.RewardedInterstitialAd.load(
      adUnitId: adId,
      request: adRequest,
      rewardedInterstitialAdLoadCallback:
          google_ads.RewardedInterstitialAdLoadCallback(
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
    _ad?.fullScreenContentCallback = google_ads.FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        adShowListener.onAdClosed();
        dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        adShowListener.onAdFailedToShow();
        dispose();
      },
    );
    _ad!.show(onUserEarnedReward: (adView, reward) {
      adShowListener.onAdSuccess();
    });
  }

  @override
  void dispose() {
    _ad?.dispose();
    _ad = null;
  }

  @override
  AdProvider get provider => AdProvider.admob;
}
