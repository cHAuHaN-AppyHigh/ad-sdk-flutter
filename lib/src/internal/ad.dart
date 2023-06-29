import 'package:flutter/material.dart';

import 'enums/ad_provider.dart';
import 'listeners/ad_load_listener.dart';
import 'listeners/ad_show_listener.dart';

abstract class Ad {
  final String adId;

  Ad(this.adId);

  Future<void> loadAd({
    int retryCounts = 3,
    required AdLoadListener adLoadListener,
  });

  void dispose();

  AdProvider get provider;
}

abstract class WidgetAd {
  bool get isAdLoaded;

  bool get adFailedToLoad;

  double get height;

  double get width;

  Widget build();
}

abstract class WidgetLessAd {
  Future<void> show({
    required AdShowListener adShowListener,
  });
}
