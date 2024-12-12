import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:chatcupid/firebase_options.dart';
import 'package:chatcupid/helpers/init_dependancy.dart';
import 'package:chatcupid/routes/routes_helper.dart';
// import 'package:chatcupid/screens/overlay_screens/messenger_chat_head.dart';
import 'package:chatcupid/screens/purchase_screens/refer_promotion_card.dart';
import 'package:chatcupid/services/auth_status_service.dart';
import 'package:chatcupid/services/refer_tracking_services.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  InitDependancy.onInit();
  await ReferralTracker.checkAndProcessReferral();
  // if (!await FlutterOverlayWindow.isPermissionGranted()) {
  //   FlutterOverlayWindow.requestPermission();
  // }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

// @pragma("vm:entry-point")
// void overlayMain() async {
//   // WidgetsFlutterBinding.ensureInitialized();

//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   // Future.delayed(Duration(seconds: 2));
//   // FlutterNativeSplash.remove();
//   // import 'package:flutter/services.dart';

//   InitDependancy.onInit();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(ScreenUtilInit(
//       designSize: const Size(390, 813),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: MessangerChatHead(),
//         );
//       }));
// }

class MyApp extends StatefulWidget {
  MyApp({super.key});
  // final bool isLoggedIn;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 813),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'ChatCupid',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          theme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pinkAccent,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          initialRoute: RoutesHelper.splashScreen,
          getPages: RoutesHelper.routes,
          // home: InitialOnboardingScreen(),
        );
      },
    );
  }
}
