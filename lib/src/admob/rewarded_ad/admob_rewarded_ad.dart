import '../../internal/enums/ad_provider.dart';
import '../../internal/listeners/ad_load_listener.dart';
import '../../internal/listeners/ad_show_listener.dart';
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart' as google_ads;
import '../../internal/rewarded_ad/rewarded_ad.dart';
import '../utils/admob_config.dart';

class AdmobRewardedAd extends RewardedAd {
  final google_ads.AdRequest adRequest;

  google_ads.RewardedAd? _ad;

  final Completer _adCompleter = Completer();

  google_ads.RewardedAd get rewardedAd => _ad!;

  AdmobRewardedAd(
    super.adId, {
    required this.adRequest,
  });

  @override
  Future<void> loadAd({
    int retryCounts = 3,
    required AdLoadListener adLoadListener,
  }) async {
    google_ads.RewardedAd.load(
      adUnitId: adId,
      request: adRequest,
      rewardedAdLoadCallback: google_ads.RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          adLoadListener.onAdLoaded();
          _adCompleter.complete(null);
        },
        onAdFailedToLoad: (error) {
          if (retryCounts > 0) {
            loadAd(
              retryCounts: retryCounts - 1,
              adLoadListener: adLoadListener,
            );
          } else {
            _adCompleter.complete(null);
            adLoadListener.onFailedToLoadAd();
          }
        },
      ),
    );
  }

  @override
  Future<void> show({
    required AdShowListener adShowListener,
  }) async {
    Future.delayed(AdmobConfig().retryingDuration, () {
      if (!_adCompleter.isCompleted) {
        _adCompleter.complete(null);
      }
    });
    await _adCompleter.future;
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
