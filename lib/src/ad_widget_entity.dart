import 'package:adsdk/adsdk.dart';
import 'package:adsdk/src/internal/ad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ad_entity.dart';

class AdWidgetEntity extends AdEntity {
  AdWidgetEntity(super.appyhighId);

  Widget build() => (ad as WidgetAd).build();
}

class AdWidget extends StatefulWidget {
  final AdWidgetEntity adEntity;
  final Widget? onLoadingWidget;
  final Widget? onErrorWidget;

  const AdWidget({
    Key? key,
    required this.adEntity,
    this.onLoadingWidget,
    this.onErrorWidget,
  }) : super(key: key);

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _setListener());
  }

  ///Todo: Left
  _setListener() async {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.adEntity.ad == null) {
      return const SizedBox();
    }
    WidgetAd widgetAd = widget.adEntity.ad as WidgetAd;
    if (widgetAd.adFailedToLoad) {
      return widget.onErrorWidget != null
          ? SizedBox(
              height: widgetAd.height,
              width: widgetAd.width,
              child: Center(
                child: widget.onErrorWidget,
              ),
            )
          : const SizedBox();
    } else if (!widgetAd.isAdLoaded) {
      return widget.onLoadingWidget != null
          ? SizedBox(
              height: widgetAd.height,
              width: widgetAd.width,
              child: Center(
                child: widget.onLoadingWidget,
              ),
            )
          : const SizedBox();
    }
    return widgetAd.build();
  }
}
