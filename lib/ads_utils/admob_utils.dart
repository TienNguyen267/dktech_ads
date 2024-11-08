import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dktech_ads/ads_utils/type/banner_collapsible_type.dart';
import 'package:dktech_ads/ads_utils/type/native_type.dart';
import 'package:dktech_ads/ads_utils/view/shimmer/banner_shimmer.dart';
import 'package:dktech_ads/ads_utils/view/shimmer/native_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'holder/banner_holder.dart';
import 'holder/inter_holder.dart';
import 'holder/native_holder.dart';
import 'holder/reward_holder.dart';

class AdmobUtils {
  static bool _isShowAds = false;
  static bool _isDebug = true;

  static const methodChannel = MethodChannel('dktech_ads');
  static const method_medium = 'method_medium';
  static const method_small = 'method_small';

  static final double _adAspectRatioSmall =
      Platform.isAndroid ? (125 / 355) : (100 / 355);
  static final double _adAspectRatioMedium =
      Platform.isAndroid ? (220 / 355) : (330 / 355);

  static InterstitialAd? _interstitialAd;
  static RewardedInterstitialAd? _rewardInterstitialdAd;

  static var isLoad = true;
  static ValueNotifier<Pair> adsNativeController =
      ValueNotifier(Pair(null, ""));
  static late NativeAd nativeAd;

  static final _idTestBannerAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/2934735716";
  static final _idTestBannerCollapsibleAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/2014213617"
      : 'ca-app-pub-3940256099942544/8388050270';
  static final _idTestInterstitialAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/1033173712"
      : "ca-app-pub-3940256099942544/4411468910";
  static final _idTestRewardedInterAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/5354046379"
      : "ca-app-pub-3940256099942544/6978759866";

  static final _idTestNativeAd = Platform.isAndroid
      ? "ca-app-pub-3940256099942544/2247696110"
      : "ca-app-pub-3940256099942544/3986624511";

  static initAdmob({required bool isDebug, required bool isShowAds}) async {
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    _isDebug = isDebug;
    _isShowAds = isShowAds;
    configLoading();
  }

  static void loadAndShowInter(InterHolder interHolder,
      {required Function() onAdClosed,
      required Function() onAdFail,
      required bool enableLoadingDialog}) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      onAdFail();
      return;
    }

    if (enableLoadingDialog) {
      EasyLoading.show(status: 'Loading ads...');
    }

    final String adUnitId = _isDebug
        ? _idTestInterstitialAd
        : Platform.isAndroid
            ? interHolder.idAndroid
            : interHolder.idIOS;

    InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
                  log("message onAdShowedFullScreenContent $ad");
                  Future.delayed(const Duration(milliseconds: 800), () {
                    EasyLoading.dismiss();
                  });
                },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  onAdFail();
                  EasyLoading.dismiss();
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  onAdClosed();
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            _interstitialAd?.show();
            _interstitialAd = null;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            onAdFail();
            log('InterstitialAd failed to load: $error');
            _interstitialAd = null;
          },
        ));
  }

  static void loadAndShowRewardedInterstitial(RewardHolder rewardHolder,
      {required Function() onEarned,
      required Function() onAdClosed,
      required Function() onAdFail,
      required bool enableLoadingDialog}) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      onAdFail();
      return;
    }

    if (enableLoadingDialog) {
      EasyLoading.show(status: 'Loading ads...');
    }

    final String adUnitId = _isDebug
        ? _idTestRewardedInterAd
        : Platform.isAndroid
            ? rewardHolder.idAndroid
            : rewardHolder.idIOS;

    RewardedInterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {
                  Future.delayed(const Duration(milliseconds: 800), () {
                    EasyLoading.dismiss();
                  });
                },
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  onAdFail();
                  EasyLoading.dismiss();
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  onAdClosed();
                  EasyLoading.dismiss();
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});
            // Keep a reference to the ad so you can show it later.
            _rewardInterstitialdAd = ad;
            _rewardInterstitialdAd?.show(onUserEarnedReward:
                (AdWithoutView view, RewardItem rewardItem) {
              onEarned();
            });
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            onAdFail();
            EasyLoading.dismiss();
          },
        ));
  }

  static void loadBannerCollapsible(BuildContext context,
      BannerHolder bannerHolder, BannerCollapsibleType type) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      bannerHolder.isLoad = false;
      bannerHolder.adsBannerController.value = Banner(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestBannerCollapsibleAd
        : Platform.isAndroid
            ? bannerHolder.idAndroid
            : bannerHolder.idIOS;

    if (!context.mounted) {
      return;
    }

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) {
      // Unable to get the size.
      return;
    }

    bannerHolder.isLoad = true;
    bannerHolder.adsBannerController.value = Banner(null, "");

    // Create an extra parameter that aligns the bottom of the expanded ad to the
    // bottom of the banner ad.
    var adRequest = AdRequest(extras: {
      "collapsible":
          (type == BannerCollapsibleType.COLLAPSIBLE_BOTTOM) ? "bottom" : "top",
    });

    BannerAd(
        adUnitId: adUnitId,
        request: adRequest,
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log("message load banner collap  $ad");
            bannerHolder.adsBannerController.value =
                Banner(ad as BannerAd, "success");
          },
          onAdFailedToLoad: (ad, err) {
            log("message load banner collap err: $err");
            bannerHolder.isLoad = false;
            bannerHolder.adsBannerController.value =
                Banner(ad as BannerAd, "error");
            ad.dispose();
          },
        )).load();
  }

  static void loadBanner(
      BuildContext context, BannerHolder bannerHolder) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      bannerHolder.isLoad = false;
      bannerHolder.adsBannerController.value = Banner(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestBannerAd
        : Platform.isAndroid
            ? bannerHolder.idAndroid
            : bannerHolder.idIOS;

    if (!context.mounted) {
      return;
    }

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.sizeOf(context).width.truncate());

    if (size == null) {
      // Unable to get the size.
      return;
    }

    bannerHolder.isLoad = true;
    bannerHolder.adsBannerController.value = Banner(null, "");

    var adRequest = const AdRequest();

    BannerAd(
        adUnitId: adUnitId,
        request: adRequest,
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            log("message load banner collap  $ad");
            bannerHolder.adsBannerController.value =
                Banner(ad as BannerAd, "success");
          },
          onAdFailedToLoad: (ad, err) {
            log("message load banner collap err: $err");
            bannerHolder.isLoad = false;
            bannerHolder.adsBannerController.value =
                Banner(ad as BannerAd, "error");
            ;
            ad.dispose();
          },
        )).load();
  }

  static Widget bannerView(BannerHolder bannerHolder) {
    return ValueListenableBuilder<Banner>(
        valueListenable: bannerHolder.adsBannerController,
        builder: (context, snapshot, child) {
          if (snapshot.bannerAd != null) {
            return (snapshot.bannerAd!.responseInfo != null)
                ? SizedBox(
                    width: snapshot.bannerAd!.size.width.toDouble(),
                    height: snapshot.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: snapshot.bannerAd!),
                  )
                : const SizedBox(
                    height: 0,
                  );
          } else {
            return (snapshot.msg == "no internet" || snapshot.msg == "error")
                ? const SizedBox(
                    height: 0,
                  )
                : const BannerShimmer();
          }
        });
  }

  static void loadNative(BuildContext context, NativeHolder nativeHolder,
      NativeAdmobType nativeType) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      nativeHolder.isLoad = false;
      nativeHolder.adsNativeController.value = Pair(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestNativeAd
        : Platform.isAndroid
            ? nativeHolder.idAndroid
            : nativeHolder.idIOS;

    if (!context.mounted) {
      return;
    }

    if (nativeHolder.adsNativeController.value.nativeAd != null) {
      log("message native not null");
      return;
    }
    nativeHolder.isLoad = true;
    nativeHolder.adsNativeController.value = Pair(null, "");

    NativeAd(
            adUnitId: adUnitId,
            listener: NativeAdListener(
              onAdLoaded: (ad) {
                nativeHolder.adsNativeController.value =
                    Pair(ad as NativeAd, "success");
              },
              onAdFailedToLoad: (ad, error) {
                nativeHolder.isLoad = false;
                nativeHolder.adsNativeController.value =
                    Pair(ad as NativeAd, "error");
                ad.dispose();
              },
              // Called when a click is recorded for a NativeAd.
              onAdClicked: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when an ad removes an overlay that covers the screen.
              onAdClosed: (ad) {},
              // Called when an ad opens an overlay that covers the screen.
              onAdOpened: (ad) {},
              // For iOS only. Called before dismissing a full screen view
              onAdWillDismissScreen: (ad) {},
              // Called when an ad receives revenue value.
              onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
            ),
            request: const AdRequest(),
            // Styling
            nativeTemplateStyle: NativeTemplateStyle(
                // Required: Choose a template.
                templateType: (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? TemplateType.medium
                    : TemplateType.small,
                // Optional: Customize the ad's style.
                mainBackgroundColor: Colors.transparent,
                cornerRadius: 10.0,
                callToActionTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.cyan,
                    backgroundColor: Colors.red,
                    style: NativeTemplateFontStyle.monospace,
                    size: 16.0),
                primaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.red,
                    backgroundColor: Colors.transparent,
                    style: NativeTemplateFontStyle.italic,
                    size: 16.0),
                secondaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.green,
                    backgroundColor: Colors.black,
                    style: NativeTemplateFontStyle.bold,
                    size: 16.0),
                tertiaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.brown,
                    backgroundColor: Colors.transparent,
                    style: NativeTemplateFontStyle.normal,
                    size: 16.0)))
        .load();
  }

  static void loadAndShowNative(BuildContext context, NativeHolder nativeHolder,
      NativeAdmobType nativeType) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      isLoad = false;
      adsNativeController.value = Pair(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestNativeAd
        : Platform.isAndroid
            ? nativeHolder.idAndroid
            : nativeHolder.idIOS;

    if (!context.mounted) {
      return;
    }
    adsNativeController.value.nativeAd?.dispose();
    isLoad = true;
    adsNativeController.value = Pair(null, "");

    NativeAd(
            adUnitId: adUnitId,
            listener: NativeAdListener(
              onAdLoaded: (ad) {
                adsNativeController.value = Pair(ad as NativeAd, "success");
              },
              onAdFailedToLoad: (ad, error) {
                isLoad = false;
                adsNativeController.value = Pair(ad as NativeAd, "error");
                ad.dispose();
              },
              // Called when a click is recorded for a NativeAd.
              onAdClicked: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when an ad removes an overlay that covers the screen.
              onAdClosed: (ad) {},
              // Called when an ad opens an overlay that covers the screen.
              onAdOpened: (ad) {},
              // For iOS only. Called before dismissing a full screen view
              onAdWillDismissScreen: (ad) {},
              // Called when an ad receives revenue value.
              onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
            ),
            request: const AdRequest(),
            // Styling
            nativeTemplateStyle: NativeTemplateStyle(
                // Required: Choose a template.
                templateType: (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? TemplateType.medium
                    : TemplateType.small,
                // Optional: Customize the ad's style.
                mainBackgroundColor: Colors.transparent,
                cornerRadius: 10.0,
                callToActionTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.cyan,
                    backgroundColor: Colors.red,
                    style: NativeTemplateFontStyle.monospace,
                    size: 16.0),
                primaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.red,
                    backgroundColor: Colors.transparent,
                    style: NativeTemplateFontStyle.italic,
                    size: 16.0),
                secondaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.green,
                    backgroundColor: Colors.black,
                    style: NativeTemplateFontStyle.bold,
                    size: 16.0),
                tertiaryTextStyle: NativeTemplateTextStyle(
                    textColor: Colors.brown,
                    backgroundColor: Colors.transparent,
                    style: NativeTemplateFontStyle.normal,
                    size: 16.0)))
        .load();
  }

  static void loadNativeWithLayout(BuildContext context,
      NativeHolder nativeHolder, NativeAdmobType nativeType,
      {required Function(String) onAdLoaded}) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      nativeHolder.isLoad = false;
      nativeHolder.adsNativeController.value = Pair(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestNativeAd
        : Platform.isAndroid
            ? nativeHolder.idAndroid
            : nativeHolder.idIOS;

    if (!context.mounted) {
      return;
    }

    if (nativeHolder.adsNativeController.value.nativeAd != null) {
      log("message native not null");
      return;
    }

    nativeHolder.isLoad = true;
    nativeHolder.adsNativeController.value = Pair(null, "");

    NativeAd(
      adUnitId: adUnitId,
      factoryId: (nativeType == NativeAdmobType.NATIVE_MEDIUM)
          ? 'NativeCustomMedium'
          : 'NativeCustomSmall',
      listener: NativeAdListener(
        onAdLoaded: (ad) async {
          var result = await methodChannel.invokeMethod(
              ((nativeType == NativeAdmobType.NATIVE_MEDIUM)
                  ? method_medium
                  : method_small));
          log("TAG===== headline $result");
          nativeHolder.adsNativeController.value =
              Pair(ad as NativeAd, "success");
          onAdLoaded(result);
        },
        onAdFailedToLoad: (ad, error) {
          nativeHolder.isLoad = false;
          nativeHolder.adsNativeController.value =
              Pair(ad as NativeAd, "error");
          ad.dispose();
        },
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (ad) {},
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (ad) {},
        // For iOS only. Called before dismissing a full screen view
        onAdWillDismissScreen: (ad) {},
        // Called when an ad receives revenue value.
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    ).load();
  }

  static void loadAndShowNativeWithLayout(BuildContext context,
      NativeHolder nativeHolder, NativeAdmobType nativeType) async {
    if (!_isShowAds || await isNetworkConnected() == false) {
      isLoad = false;
      adsNativeController.value = Pair(null, "no internet");
      return;
    }

    final String adUnitId = _isDebug
        ? _idTestNativeAd
        : Platform.isAndroid
            ? nativeHolder.idAndroid
            : nativeHolder.idIOS;

    if (!context.mounted) {
      return;
    }
    adsNativeController.value.nativeAd?.dispose();
    isLoad = true;
    adsNativeController.value = Pair(null, "");
    NativeAd(
      adUnitId: adUnitId,
      factoryId: (nativeType == NativeAdmobType.NATIVE_MEDIUM)
          ? 'NativeCustomMedium'
          : 'NativeCustomSmall',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log("TAG==== onAdLoaded ${ad.responseInfo}");
          adsNativeController.value = Pair(ad as NativeAd, "success");
        },
        onAdFailedToLoad: (ad, error) {
          log("TAG==== onAdFailedToLoad ${ad.responseInfo}");
          isLoad = false;
          adsNativeController.value = Pair(ad as NativeAd, "error");
          ad.dispose();
        },
        // Called when a click is recorded for a NativeAd.
        onAdClicked: (ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (ad) {},
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (ad) {},
        // For iOS only. Called before dismissing a full screen view
        onAdWillDismissScreen: (ad) {},
        // Called when an ad receives revenue value.
        onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
      ),
      request: const AdRequest(),
    ).load();
  }

  static Widget nativeView(
      NativeHolder nativeHolder, NativeAdmobType nativeType) {
    return ValueListenableBuilder<Pair>(
        valueListenable: nativeHolder.adsNativeController,
        builder: (context, snapshot, child) {
          if (snapshot.nativeAd != null) {
            return (snapshot.nativeAd!.responseInfo != null)
                ? (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? _viewNativeMedium(context, snapshot.nativeAd!)
                    : _viewNativeSmall(context, snapshot.nativeAd!)
                : const SizedBox(
                    height: 0,
                  );
          } else {
            return (snapshot.msg == "no internet" || snapshot.msg == "error")
                ? const SizedBox(
                    height: 0,
                  )
                : (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? const NativeShimmer()
                    : const BannerShimmer();
          }
        });
  }

  static Widget nativeViewLoadAndShow(
      NativeHolder nativeHolder, NativeAdmobType nativeType) {
    return ValueListenableBuilder<Pair>(
        valueListenable: adsNativeController,
        builder: (context, snapshot, child) {
          log("TAG====== ${snapshot.msg}");
          if (snapshot.nativeAd != null) {
            return (snapshot.nativeAd!.responseInfo != null)
                ? (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? _viewNativeMedium(context, snapshot.nativeAd!)
                    : _viewNativeSmall(context, snapshot.nativeAd!)
                : const SizedBox(
                    height: 0,
                  );
          } else {
            return (snapshot.msg == "no internet" || snapshot.msg == "error")
                ? const SizedBox(
                    height: 0,
                  )
                : (nativeType == NativeAdmobType.NATIVE_MEDIUM)
                    ? const NativeShimmer()
                    : const BannerShimmer();
          }
        });
  }

  static Widget _viewNativeMedium(BuildContext context, NativeAd nativeAd) {
    return SizedBox(
      height: MediaQuery.of(context).size.width * _adAspectRatioMedium,
      width: MediaQuery.of(context).size.width,
      child: AdWidget(ad: nativeAd),
    );
  }

  static Widget _viewNativeSmall(BuildContext context, NativeAd nativeAd) {
    log("TAG===== _viewNativeSmall");
    return SizedBox(
      height: MediaQuery.of(context).size.width * _adAspectRatioSmall,
      width: MediaQuery.of(context).size.width,
      child: AdWidget(ad: nativeAd),
    );
  }

  static Future<bool> isNetworkConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.other);
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 64.0
      ..radius = 10.0
      ..progressColor = Colors.blueAccent
      ..backgroundColor = Colors.white
      ..indicatorColor = Colors.blueAccent
      ..textColor = Colors.blue
      ..maskColor = Colors.white
      ..maskType = EasyLoadingMaskType.custom
      ..userInteractions = true;
  }
}

class Pair {
  NativeAd? nativeAd;
  String msg = "";

  Pair(this.nativeAd, this.msg);
}

class Banner {
  BannerAd? bannerAd;
  String msg = "";

  Banner(this.bannerAd, this.msg);
}
