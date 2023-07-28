import 'dart:async';

import 'package:adsdk/src/internal/ad.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'package:flutter/foundation.dart';
import 'ad_entity.dart';
import 'internal/listeners/ad_show_listener.dart';

class AdViewHandler extends AdEntity {
  AdViewHandler(super.appyhighId);

  Future<void> showAd(AdShowListener adShowListener) async {
    if (!isActive) {
      throw Exception('Ad is not active');
    }
    AdSdkLogger.info('Trying to show Ad $appyhighId');
    final Completer<AdLoadState> completer = Completer<AdLoadState>();
    StreamSubscription<AdLoadState> subscription =
        onAdLoadStateChanged.listen((event) {
      if (event != AdLoadState.loading && !completer.isCompleted) {
        completer.complete(event);
      }
    });
    AdLoadState adLoadState = await completer.future;
    subscription.cancel();
    resetAdState();
    return _showAd(adLoadState, adShowListener);
  }

  Future<void> _showAd(AdLoadState adLoadState, AdShowListener adShowListener) {
    if (adLoadState == AdLoadState.success) {
      return (ad as WidgetLessAd).show(adShowListener: adShowListener);
    } else {
      throw Exception('Ad Couldn\'t load');
    }
  }
}

class CustomAdShowListener implements AdShowListener {
  final VoidCallback onAdClosedSuccess;
  final VoidCallback onAdShowFailure;
  final VoidCallback onAdSuccessful;

  CustomAdShowListener({
    required this.onAdClosedSuccess,
    required this.onAdShowFailure,
    required this.onAdSuccessful,
  });

  @override
  void onAdClosed() => onAdClosedSuccess();

  @override
  void onAdFailedToShow() => onAdShowFailure();

  @override
  void onAdSuccess() => onAdSuccessful();
}
