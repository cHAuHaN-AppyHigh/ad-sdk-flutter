import 'package:adsdk/src/internal/ad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ad_entity.dart';

class AdWidgetHandler extends AdEntity {
  AdWidgetHandler(super.appyhighId);

  Widget build() => (ad as WidgetAd).build();
}

class AdWidget extends StatefulWidget {
  final AdWidgetHandler adHandler;
  final Widget? onLoadingWidget;
  final Widget? onErrorWidget;

  const AdWidget({
    Key? key,
    required this.adHandler,
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

  _setListener() async {
    widget.adHandler.onAdLoadStateChanged.listen((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.adHandler.isActive || widget.adHandler.adLoadState == null) {
      return const SizedBox();
    }

    switch (widget.adHandler.adLoadState!) {
      case AdLoadState.success:
        WidgetAd widgetAd = widget.adHandler.ad as WidgetAd;
        return widgetAd.build();
      case AdLoadState.failed:
        return widget.onErrorWidget != null
            ? Center(
                child: widget.onErrorWidget,
              )
            : const SizedBox();
      case AdLoadState.loading:
        return widget.onLoadingWidget != null
            ? Center(
                child: widget.onLoadingWidget,
              )
            : const SizedBox();
    }
  }
}
