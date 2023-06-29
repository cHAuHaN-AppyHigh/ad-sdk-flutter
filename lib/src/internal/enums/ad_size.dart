import 'dart:io';

import 'package:applovin_max/applovin_max.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdSdkAdSize {
  banner("banner"),
  largeBanner("large_banner"),
  mediumBanner("medium_rectangle"),
  smallNative("small"),
  mediumNative("medium");

  final String key;

  const AdSdkAdSize(this.key);
}