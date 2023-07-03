import 'dart:async';

import 'package:adsdk/src/internal/ad.dart';
import 'package:adsdk/src/internal/utils/adsdk_logger.dart';
import 'ad_entity.dart';
import 'internal/listeners/ad_show_listener.dart';

class AdViewEntity extends AdEntity {
  AdViewEntity(super.appyhighId);

  Future<void> showAd(AdShowListener adShowListener) async {
    if (ad == null) {
      throw Exception('Ad Couldn\'t load');
    }
    AdSdkLogger.info('Trying to show Ad ${ad!.adId} with ${ad!.provider}');
    final Completer<AdLoadState> completer = Completer<AdLoadState>();
    StreamSubscription<AdLoadState> subscription =
        onAdLoadStateChanged.listen((event) {
      if (!completer.isCompleted) {
        completer.complete(event);
      }
    });
    AdLoadState result = await completer.future;
    subscription.cancel();
    return _showAd(result, adShowListener);
  }

  Future<void> _showAd(AdLoadState adLoadState, AdShowListener adShowListener) {
    if (adLoadState == AdLoadState.success) {
      return (ad as WidgetLessAd).show(adShowListener: adShowListener);
    } else {
      throw Exception('Ad Couldn\'t load');
    }
  }
}
