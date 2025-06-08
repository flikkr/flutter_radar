import 'package:flutter/material.dart';
import 'package:flutter_radar/src/env.dart' as env;
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdItem extends StatefulWidget {
  const NativeAdItem({super.key});

  @override
  State<NativeAdItem> createState() => _NativeAdItemState();
}

class _NativeAdItemState extends State<NativeAdItem> {
  NativeAd? nativeAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  /// Loads a native ad.
  void loadAd() {
    nativeAd = NativeAd(
      adUnitId: env.mainListAdUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('$NativeAd loaded.');
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Dispose the ad here to free resources.
          debugPrint('$NativeAd failed to load: $error');
          ad.dispose();
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(templateType: TemplateType.small, cornerRadius: 10.0),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: isAdLoaded && nativeAd != null ? AdWidget(ad: nativeAd!) : const SizedBox(), // or a loading indicator
    );
  }

  @override
  void dispose() {
    super.dispose();
    nativeAd?.dispose();
  }
}
