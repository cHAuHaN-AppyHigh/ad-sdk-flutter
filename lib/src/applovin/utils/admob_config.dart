import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobConfig{
  AdRequest get adRequest => const AdRequest();

  Duration get retryingDuration => const Duration(seconds: 3);
}