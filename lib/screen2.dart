import 'dart:developer';

import 'package:flutter/material.dart';

import 'ads_manager.dart';
import 'ads_utils/admob_utils.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  @override
  void initState() {
    log("TAG====== initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      AdsManager.loadAndShowRewardInter(
                          context, AdsManager.rewardHolder,
                          onEarned: () {}, onAdClosed: () {}, onAdFail: () {});
                    },
                    child: ListTile(
                      title: Text("test ${index + 1}"),
                    ),
                  );
                },
              ),
            ),
            AdsManager.showNativeMediumWithLayout(
                context, AdsManager.nativeHolder)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    log("TAG===== dispose screen2");
    AdmobUtils.adsNativeController.value.nativeAd?.dispose();
    AdmobUtils.adsNativeController.value = Pair(null, "");
    super.dispose();
  }
}
