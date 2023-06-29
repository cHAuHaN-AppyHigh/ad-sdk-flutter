import 'package:adsdk/src/internal/ad.dart';

import '../listeners/ad_load_listener.dart';
import '../listeners/ad_show_listener.dart';

abstract class RewardedAd extends Ad implements WidgetLessAd {
  RewardedAd(super.adId);
}
