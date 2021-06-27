import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get_done/ad/ad_helper.dart';

class MyNativeAd extends StatefulWidget {
  const MyNativeAd({Key? key}) : super(key: key);

  @override
  _MyNativeAdState createState() => _MyNativeAdState();
}

class _MyNativeAdState extends State<MyNativeAd> {
  late NativeAd _ad;
  bool isADLoaded = false;

  @override
  void initState() {
    _ad = NativeAd(
      adUnitId: AdHelper.nativeAdUnitId,
      factoryId: "listTile",
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            isADLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          // ignore: avoid_print
          print(
              "AD Failed to Loaded - CODE - ${error.code}, MESSAGE - ${error.message}");
        },
      ),
      request: const AdRequest(),
    );
    _ad.load();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _ad.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return isADLoaded
        // ignore: sized_box_for_whitespace
        ? AdWidget(
            ad: _ad,
          )
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
            ),
          );
  }
}

class MyBannerAd extends StatefulWidget {
  const MyBannerAd({Key? key}) : super(key: key);

  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  late BannerAd bad;
  bool _bannerAdLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bad = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            setState(() {
              _bannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            // ignore: avoid_print
            print(
                "AD Failed to Loaded - CODE - ${error.code}, MESSAGE - ${error.message}");
          },
        ),
        request: const AdRequest())
      ..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAdLoaded
        ? AdWidget(ad: bad)
        : const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
            ),
          );
  }
}

//
