// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

// import 'package:chatcupid/controllers/overlay_controllers.dart';
// import 'package:chatcupid/screens/overlay_screens/overlay_content.dart';

// class MessangerChatHead extends StatefulWidget {
//   const MessangerChatHead({Key? key}) : super(key: key);

//   @override
//   State<MessangerChatHead> createState() => _MessangerChatHeadState();
// }

// class _MessangerChatHeadState extends State<MessangerChatHead> {
//   Color color = const Color(0xFFFFFFFF);
//   BoxShape _currentShape = BoxShape.circle;
//   static const String _kPortNameOverlay = 'OVERLAY';
//   static const String _kPortNameHome = 'UI';
//   final _receivePort = ReceivePort();
//   SendPort? homePort;
//   String? messageFromOverlay;
//   ScreenshotController screenshotController =
//       ScreenshotController(); // Screenshot controller

//   @override
//   void initState() {
//     Get.put(OverlayControllers());
//     super.initState();
//     if (homePort != null) return;
//     final res = IsolateNameServer.registerPortWithName(
//       _receivePort.sendPort,
//       _kPortNameOverlay,
//     );
//     log("$res : HOME");
//     _receivePort.listen((message) {
//       log("message from UI: $message");
//       setState(() {
//         messageFromOverlay = 'message from UI: $message';
//       });
//     });
//   }

//   static const platform = MethodChannel('com.app.chatcupid');

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Material(
//         color: Colors.transparent,
//         elevation: 0.0,
//         child: GestureDetector(
//           onTap: () async {
//             // if (_currentShape == BoxShape.rectangle) {
//             //   await _takeScreenshot();
//             //   await FlutterOverlayWindow.resizeOverlay(100, 100, true);
//             //   setState(() {
//             //     _currentShape = BoxShape.circle;
//             //   });
//             //   _bringAppToForeground();
//             // } else {
//             //   await FlutterOverlayWindow.resizeOverlay(
//             //     WindowSize.matchParent,
//             //     WindowSize.matchParent,
//             //     false,
//             //   );
//             //   setState(() {
//             //     _currentShape = BoxShape.rectangle;
//             //   });
//             // }

//             // try {
//             //   await platform.invokeMethod('bringAppToForeground');
//             // } on PlatformException catch (e) {
//             //   print("Failed to bring app to foreground: '${e.message}'.");
//             // }
//           },
//           child: Screenshot(
//             // Wrap with Screenshot widget
//             controller: screenshotController,
//             child: Scaffold(
//               backgroundColor: Colors.transparent,
//               body: Container(
//                 height: MediaQuery.of(context).size.height,
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(0, 206, 206, 206),
//                   shape: _currentShape,
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       _currentShape == BoxShape.rectangle
//                           // ? messageFromOverlay == null
//                           ? OverlayContent()
//                           // : Text(messageFromOverlay ?? '')
//                           : Transform.scale(
//                               scale: 1,
//                               child: Image.network(
//                                   fit: BoxFit.fill,
//                                   // width: Get.width,
//                                   "https://firebasestorage.googleapis.com/v0/b/chatcupid-87b76.appspot.com/o/users%2FGroup%2010.png?alt=media&token=25a6fc25-a6e8-4a76-a395-b2a8e76c9c4b"),
//                             )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _takeScreenshot() async {
//     try {
//       final image = await screenshotController.capture();

//       if (image != null) {
//         // 1. Convert image to Base64 string
//         final base64Image = base64Encode(image);

//         // 2. Save Base64 string to Firestore
//         final userId =
//             FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID
//         final userDocRef =
//             FirebaseFirestore.instance.collection('users').doc(userId);

//         final docSnapshot = await userDocRef.get();
//         if (!docSnapshot.exists) {
//           // Create the document
//           await userDocRef.set({'screenshot': ''}); // Or any initial data
//         }

//         await userDocRef.update({
//           'screenshot': base64Image,
//         });

//         print("Screenshot saved as Base64 to Firestore");
//       }
//     } catch (e) {
//       print("Error capturing/saving screenshot: $e");
//     }
//   }
// }
