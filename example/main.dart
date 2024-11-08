import 'package:dktech_ads/ads_manager.dart';
import 'package:dktech_ads/ads_utils/admob_utils.dart';
import 'package:dktech_ads/screen2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  AdmobUtils.initAdmob(isDebug: true, isShowAds: true);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    AdsManager.loadNativeMediumWithLayout(context, AdsManager.nativeHolder);
    AdsManager.loadBanner(context, AdsManager.bannerHolder);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            AdmobUtils.bannerView(AdsManager.bannerHolder),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AdsManager.loadAndShowInter(context, AdsManager.interHolder, () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => const Screen2()));
            });
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
