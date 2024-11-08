import 'dart:core';

import 'package:flutter/foundation.dart';

import '../admob_utils.dart';

class BannerHolder {
  String idAndroid = "";
  String idIOS = "";
  bool isLoad = true;
  ValueNotifier<Banner> adsBannerController = ValueNotifier(Banner(null, ""));

  BannerHolder({required this.idAndroid, required this.idIOS});
}
