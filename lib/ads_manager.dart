import 'package:dktech_ads/ads_utils/holder/reward_holder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ads_utils/admob_utils.dart';
import 'ads_utils/holder/banner_holder.dart';
import 'ads_utils/holder/inter_holder.dart';
import 'ads_utils/holder/native_holder.dart';
import 'ads_utils/type/banner_collapsible_type.dart';
import 'ads_utils/type/native_type.dart';

class AdsManager {
  static BannerHolder bannerCollapsibleHolder = BannerHolder(idAndroid: "", idIOS: "");
  static BannerHolder bannerHolder = BannerHolder(idAndroid: "", idIOS: "");
  static NativeHolder nativeHolder = NativeHolder(idAndroid: "", idIOS: "");
  static InterHolder interHolder = InterHolder(idAndroid: "", idIOS: "");
  static RewardHolder rewardHolder = RewardHolder(idAndroid: "", idIOS: "");

  static var isTestDevice = false;

  static loadAndShowInter(
      BuildContext context, InterHolder interHolder, Function() onAdClosed) {
    if (isTestDevice) {
      onAdClosed();
      return;
    }

    AdmobUtils.loadAndShowInter(interHolder, onAdClosed: () {
      onAdClosed();
    }, onAdFail: () {
      onAdClosed();
    }, enableLoadingDialog: true);
  }

  static loadAndShowRewardInter(BuildContext context, RewardHolder rewardHolder,
      {required Function() onEarned,
      required Function() onAdClosed,
      required Function() onAdFail}) {

    if(isTestDevice) {
      onAdClosed();
      Fluttertoast.showToast(
          msg: "Is Test Device",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    AdmobUtils.loadAndShowRewardedInterstitial(rewardHolder, onEarned: () {
      onEarned();
      Fluttertoast.showToast(
          msg: "on Rewarded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }, onAdClosed: () {
      onAdClosed();
      Fluttertoast.showToast(
          msg: "on Ad close",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }, onAdFail: () {
      onAdFail();
      Fluttertoast.showToast(
          msg: "ad fail",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }, enableLoadingDialog: true);
  }

  static loadBannerCollapsibleBottom(
      BuildContext context, BannerHolder bannerHolder) {
    AdmobUtils.loadBannerCollapsible(
        context, bannerHolder, BannerCollapsibleType.COLLAPSIBLE_BOTTOM);
  }

  static loadBanner(BuildContext context, BannerHolder bannerHolder) {
    AdmobUtils.loadBanner(context, bannerHolder);
  }

  static loadNativeMediumWithLayout(
      BuildContext context, NativeHolder nativeHolder) async {
    AdmobUtils.loadNativeWithLayout(
        context, nativeHolder, NativeAdmobType.NATIVE_SMALL,
        onAdLoaded: (headline) {
        checkAdsTest(headline);
    });
  }

  static Widget showNativeMediumWithLayout(
      BuildContext context, NativeHolder nativeHolder) {
    if (isTestDevice) {
      return const SizedBox();
    }

    return FutureBuilder<bool>(
      future: AdmobUtils.isNetworkConnected(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          // If connected, display the native ad view.
          return AdmobUtils.nativeView(
              nativeHolder, NativeAdmobType.NATIVE_SMALL);
        } else {
          // If not connected or error, return an empty SizedBox.
          return const SizedBox();
        }
      },
    );
  }

  static checkAdsTest(String headline) {
    try {
      if (headline.isNotEmpty) {
        final testAdResponse = headline.replaceAll(" ", "").split(":")[0];
        debugPrint('===Native: $testAdResponse');

        const testAdResponses = [
          'TestAd',
          'Anunciodeprueba',
          'Annoncetest',
          '테스트광고',
          'Annuncioditesto',
          'Testanzeige',
          'TesIklan',
          'Anúnciodeteste',
          'Тестовоеобъявление',
          'পরীক্ষামূলকবিজ্ঞাপন',
          'जाँचविज्ञापन',
          'إعلانتجريبي',
          'Quảngcáothửnghiệm',
        ];
        isTestDevice = testAdResponses.contains(testAdResponse);
      }
    } catch (e) {
      isTestDevice = true;
      debugPrint('===Native: Error');
    }
  }
}
