import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({
    super.key,
    required this.bannerAd,
  });

  final BannerAd? bannerAd;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AdSize.banner.height.toDouble(),
      child:
          bannerAd == null ? const SizedBox.shrink() : AdWidget(ad: bannerAd!),
    );
  }
}
