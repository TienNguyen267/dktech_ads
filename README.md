# DKTech Ads

# Init Ads
    AdmobUtils.initAdmob(isDebug: true, isShowAds: true);
    - isDebug : ads thật/ads test
    - isShowAds : bật tắt show qc
# Banner
    1. Tạo biến static
        static BannerHolder bannerHolder = BannerHolder(idAndroid: "", idIOS: "");
    2. Load banner
        AdsManager.loadBanner(context, AdsManager.bannerHolder);
    3. Show banner
        AdmobUtils.bannerView(AdsManager.bannerHolder),

# Native( Load trước show sau)
    1. Tạo biến static
        static NativeHolder nativeHolder = NativeHolder(idAndroid: "", idIOS: "");
    2. Load native
         AdsManager.loadNativeMediumWithLayout(context, AdsManager.nativeHolder);
    3. Show native
        AdmobUtils.bannerView(AdsManager.bannerHolder),

    (gọi hàm load trước khi vào màn muốn show native)

# Inter
    1. Tạo biến static
          static InterHolder interHolder = InterHolder(idAndroid: "", idIOS: "");
    2. Load and show inter
      AdmobUtils.loadAndShowInter(interHolder, onAdClosed: () {
      // Action khi tắt qc
    }, onAdFail: () {
      // Action khi qc fail
    }, enableLoadingDialog: true);
    (enableLoadingDialog: bật/tắt dialog loading)

# Reward Interstitial
    1. Tạo biến static
        static RewardHolder rewardHolder = RewardHolder(idAndroid: "", idIOS: "");
    2. Load and show Reward Interstitial
        AdmobUtils.loadAndShowRewardedInterstitial(rewardHolder,
        onEarned: () {
            //action khi nhận được reward
        }, onAdClosed: () {
            //action khi tắt qc
        }, onAdFail: () {
            //action khi qc fail
        }, enableLoadingDialog: true);
        (enableLoadingDialog: bật/tắt dialog loading)

# NOTE
-  Native được custom riêng từng platfrom( mới có android)
-  Code native android ở trong file MainActivity
-  File layout ở trong thư mục res/layout
-  Các file background của native ở trong thư mực res/drawable