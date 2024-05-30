import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixvalley_delivery_boy/theme/dark_theme.dart';
import 'package:sixvalley_delivery_boy/theme/light_theme.dart';
import 'package:sixvalley_delivery_boy/utill/app_constants.dart';
import 'package:sixvalley_delivery_boy/utill/messages.dart';
import 'package:sixvalley_delivery_boy/features/splash/screens/splash_screen.dart';
import 'common/controllers/localization_controller.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'theme/controllers/theme_controller.dart';
import 'helper/get_di.dart' as di;
import 'package:url_strategy/url_strategy.dart';
import 'helper/notification_helper.dart';
import 'package:permission_handler/permission_handler.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _deleteCacheDir();
  _deleteAppDir();
  FlutterNativeSplash.remove();
  Map<String, Map<String, String>> _languages = await di.init();
  try {
    if (GetPlatform.isMobile) {
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  }catch(e) {
    debugPrint('');
  }
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(MyApp(languages: _languages));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({Key? key, required this.languages}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return  GetMaterialApp(

            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            theme: themeController.darkTheme ? dark : light,
            locale: localizeController.locale,
            translations: Messages(languages: languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode),
            home: const SplashScreen(),
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
              builder:(context,child){
                return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling), child: child!);
              }
          );
        });
      });
    });
  }
}

Future<void> _deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();

  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}

Future<void> _deleteAppDir() async {
  final appDir = await getApplicationSupportDirectory();

  if(appDir.existsSync()){
    appDir.deleteSync(recursive: true);
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}