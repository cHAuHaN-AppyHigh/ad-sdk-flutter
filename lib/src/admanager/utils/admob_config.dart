import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManagerConfig{
  AdManagerAdRequest get adRequest => const AdManagerAdRequest();

  Duration get retryingDuration => const Duration(seconds: 3);
}