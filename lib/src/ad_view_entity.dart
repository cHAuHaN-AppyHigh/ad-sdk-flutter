import 'package:adsdk/src/internal/ad.dart';
import 'ad_entity.dart';
import 'internal/listeners/ad_show_listener.dart';

class AdViewEntity extends AdEntity {
  AdViewEntity(super.appyhighId);

  Future<void> showAd(AdShowListener adShowListener) {
    if (ad == null) {
      throw Exception('Ad Couldn\'t load');
    }
    return (ad as WidgetLessAd).show(adShowListener: adShowListener);
  }
}
