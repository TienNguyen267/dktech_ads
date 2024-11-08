import 'dart:core';

import 'package:dktech_ads/ads_utils/admob_utils.dart';
import 'package:flutter/cupertino.dart';

class NativeHolder {
  String idAndroid = "";
  String idIOS = "";
  bool isLoad = true;
  ValueNotifier<Pair> adsNativeController = ValueNotifier(Pair(null, ""));

  NativeHolder({required this.idAndroid, required this.idIOS});
}
