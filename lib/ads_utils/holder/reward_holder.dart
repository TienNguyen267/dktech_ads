import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardHolder {
  String idAndroid = "";
  String idIOS = "";
  bool check = true;
  ValueNotifier<InterstitialAd?> adsRewardController = ValueNotifier(null);

  RewardHolder({required this.idAndroid,required this.idIOS});

}
