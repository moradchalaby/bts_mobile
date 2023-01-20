import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:bts_mobile/main.dart';

class AdState extends ChangeNotifier {
  Future<InitializationStatus> initialization;
  AdState({
    required this.initialization,
  });

  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3500157718156258/5361952056';
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  String get openad {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3500157718156258/7401054319';
      return 'ca-app-pub-3940256099942544/3419835294';
    } else {
      return 'ca-app-pub-3940256099942544/3419835294';
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3500157718156258/1829901159';
      return 'ca-app-pub-3940256099942544/8691691433';
    } else {
      return 'ca-app-pub-3940256099942544/8691691433';
    }
  }

  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3500157718156258/5499733564';
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return 'ca-app-pub-3940256099942544/5224354917';
    }
  }

  get loadAppOpenAd => _loadAppOpenAd;
  void _loadAppOpenAd() {
    AppOpenAd.load(
        adUnitId: openad, //Your ad Id from admob
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
            onAdLoaded: (ad) {
              ad.show();
            },
            onAdFailedToLoad: (error) {}),
        orientation: AppOpenAd.orientationPortrait);
  }

  BannerAdListener get adListener => _adListener;

  final BannerAdListener _adListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  InterstitialAd? _interstitialAd;
  InterstitialAd? get interstitialAd => _interstitialAd;
  // RewardedAd? _rewardedAd;
  // RewardedAd? get rewaededAd => _rewardedAd;
  get loadInterstitialAd => _loadInterstitialAd;
  // get loadRewaredInterstitialAd => _loadRewaredInterstitialAd;

  void _loadInterstitialAd(BuildContext context) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              //Closure: (AdWithoutView, RewardItem) => void
            },
          );

          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {},
      ),
    );
  }

  // void _loadRewaredInterstitialAd(
  //     BuildContext context, WidgetRef ref, String sinavTarih) {
  //   RewardedAd.load(
  //     adUnitId: rewardedAdUnitId,
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {
  //             ad.dispose();
  //             _rewardedAd = null;
  //             Navigator.of(context).push(
  //                 MaterialPageRoute(builder: (_) => SinavPage(sinavTarih)));
  //           },
  //         );
//
  //         _rewardedAd = ad;
  //       },
  //       onAdFailedToLoad: (err) {
  //         print('Failed to load a rewarded ad: ${err.message}');
  //       },
  //     ),
  //   );
  // }

}

class GetBannerAd extends HookConsumerWidget {
  const GetBannerAd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<BannerAd>? bannerAd;
    useEffect((() {
      final adState = ref.read(adStateProvider);
      bannerAd = adState.initialization.then(
        (value) => BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnitId,
            listener: adState.adListener,
            request: const AdRequest())
          ..load(),
      );
      return null;
    }));

    return FutureBuilder<BannerAd>(
        future: bannerAd,
        builder: ((context, snapshot) {
          var data = snapshot.data;
          if (snapshot.hasData) {
            return AdWidget(ad: data!);
          } else {
            return const CircularProgressIndicator();
          }
        }));
  }
}
