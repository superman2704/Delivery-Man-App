import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_delivery_boy/features/profile/controllers/profile_controller.dart';
import 'package:sixvalley_delivery_boy/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/features/auth/screens/login_screen.dart';
import 'package:sixvalley_delivery_boy/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_delivery_boy/features/onboard/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center)));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });
    Get.find<SplashController>().initSharedData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(const Duration(seconds: 1), () async {
          if (Get.find<AuthController>().isLoggedIn()) {
            Get.find<AuthController>().updateToken();
            await Get.find<ProfileController>().getProfile();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const DashboardScreen(pageIndex: 0)));
          } else {
            if (Get.find<SplashController>().showIntro()!) {
              Get.offAll(const OnBoardingScreen());
            } else {
              Get.offAll(const LoginScreen());
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,

      body: Center(child: Padding(padding:  EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(Images.splashLogo, width: Dimensions.splashLogoWidth),
             SizedBox(height: Dimensions.paddingSizeDefault),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppConstants.appName,
                    style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center),
                 SizedBox(width: Dimensions.fontSizeExtraSmall),
                Text('APP', style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeOverLarge,
                    color: Theme.of(context).primaryColor), textAlign: TextAlign.center)]),
          ]))),
    );
  }
}