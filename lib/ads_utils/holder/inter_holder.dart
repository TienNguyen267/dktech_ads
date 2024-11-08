import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterHolder {
  String idAndroid = "";
  String idIOS = "";
  bool check = true;
  ValueNotifier<InterstitialAd?> adsInterController = ValueNotifier(null);

  InterHolder({required this.idAndroid, required this.idIOS});
}
