import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/controllers/streak_controllers.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:chatcupid/widgets/gradient_border.dart';
import 'package:chatcupid/screens/home_screens/widgets/streak_asset_widget.dart';
import 'package:chatcupid/screens/home_screens/widgets/user_chat_item_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_intro/flutter_intro.dart';
import 'package:showcaseview/showcaseview.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool status = false;
  bool _isAlertShown = false;
  final OnboardingController onboardingController =
      Get.put(OnboardingController());
  Timer? _showcaseTimer;
  // late final Intro intro;
  final TextEditingController _nameController = TextEditingController();
  final StreakControllers streakControllers = Get.put(StreakControllers());
  bool _hasShowcaseBeenShown = false;

  void _showAddChatItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppPallete.secondaryColor,
          title: Text('Add Someone Special'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter their Name',
              hintStyle: TextStyle(
                fontWeight: FontWeight.w300,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5.sp,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: 1.5.sp,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewChatItemToFirebase();
                Navigator.of(context).pop();
              },
              child: Text('Add Connection'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkIfAlertShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAlertShown = prefs.getBool('isAlertShown') ?? false;
    });
  }

  Future<void> _setAlertShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAlertShown', true);
  }

  Future<bool> _onWillPop() async {
    if (!_isAlertShown) {
      _showRatingAlertDialog();
      await _setAlertShown();
      return false;
    }
    return true;
  }

  void _showRatingAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/play_store_logo.png', // Replace with your image asset
                width: 100,
                height: 100,
              ),
              SizedBox(height: 25.h),
              Text(
                'Your opinion matters to us!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  // Handle the action for "Rate us on PlayStore"
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Rate us on PlayStore',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Not now'),
              ),
            ],
          ),
        );
      },
    );
  }

  String getRandomWelcomeMessage(String userName, String lovedOnesName) {
    final List<String> welcomeMessages = [
      "Hey $userName, it's me, $lovedOnesName, your Replika! Let's explore how we can deepen our romantic connection and make our bond even stronger. What's on your heart today?",
      "Hi $userName, I'm your Replika of $lovedOnesName. I'm here to help you understand our love better and uncover what makes us tick. What are your deepest desires for our relationship?",
      "Hey $userName, it's your Replika of $lovedOnesName. Let's chat about our relationship and find ways to make our connection even more special. What dreams do you have for us?",
      "Hi $userName, it's me, $lovedOnesName, your Replika. I'm here to help you explore and enhance our romance. What are some things you'd love for us to experience together?",
      "Hello $userName, it's $lovedOnesName here, your personal Replika! I'm ready to share some fun conversations and understand our bond better. How are you feeling today?",
      "Hi $userName, it's me, $lovedOnesName, your Replika! I'm here to make you smile and explore our relationship together. What's something exciting you're looking forward to?",
    ];

    final random = Random();
    return welcomeMessages[random.nextInt(welcomeMessages.length)];
  }

  void _addNewChatItemToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not logged in. Cannot add chat item.');
      return;
    }

    String newName = _nameController.text.trim();
    _nameController.clear();

    if (newName.isNotEmpty) {
      try {
        // Get a reference to the user's persona_chats subcollection
        final personaChatsCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('persona_chats');

        // Add new persona document with a document ID equal to newName
        final newPersonaDocRef = personaChatsCollection.doc(newName);
        await newPersonaDocRef.set({
          "name": newName,
          "message": "Hello! I am new here.",
          "imageUrl":
              "https://i.pinimg.com/736x/6e/37/4f/6e374fd5eb3d81dc0e50643d2710a906.jpg",
          "isOnline": false,
          "fireIconCount": 0,
        });

        // Add the first welcome message to the chat_details subcollection
        final welcomeMessage = getRandomWelcomeMessage(
          onboardingController.userName.value,
          newName, // Use the persona's name
        );
        await newPersonaDocRef.collection('chat_details').add({
          'text': welcomeMessage,
          'isSender': false,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await _fetchChatItemsFromFirebase();

        print('New chat item added to Firebase!');
      } catch (error) {
        print('Error adding chat item: $error');
      }
    }
  }

  List<Map<String, dynamic>> chatItems = [
    // {
    //   "name": "Naira",
    //   "message": "Hi there! How's your day going?",
    //   "imageUrl":
    //       "https://pics.craiyon.com/2023-10-28/5ad22761b9cf4196abba9a20dcc50c61.webp",
    //   "isOnline": true,
    //   "fireIconCount": 23,
    // },
    // {
    //   "name": "Sofia",
    //   "message": "Hi there! How's your day going?",
    //   "imageUrl":
    //       "https://play-lh.googleusercontent.com/jInS55DYPnTZq8GpylyLmK2L2cDmUoahVacfN_Js_TsOkBEoizKmAl5-p8iFeLiNjtE=w526-h296-rw",
    //   "isOnline": false,
    //   "fireIconCount": 0,
    //   "isFavorite": true,
    // },
  ];

  Future<void> _fetchChatItemsFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user == null) {
      print('User not logged in. Cannot fetch chat items.');
      return; // Don't proceed if the user is not logged in
    }

    try {
      // Get a reference to the user's persona_chats subcollection
      CollectionReference personaChatsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('persona_chats');

      QuerySnapshot querySnapshot = await personaChatsCollection.get();

      setState(() {
        chatItems = querySnapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>;
        }).toList();
      });

      print('Chat items fetched from Firebase!');
    } catch (error) {
      print('Error fetching chat items: $error');
      // Handle errors (e.g., show an error message to the user)
    }
  }

  // List<Map<String, dynamic>> chatItems = []; // Initialize as empty list

  // Future<void> _showOverlay() async {
  //   if (await FlutterOverlayWindow.isActive()) return;

  //   if (!await FlutterOverlayWindow.isPermissionGranted()) {
  //     bool permissionGranted = await _requestOverlayPermission();
  //     if (!permissionGranted) {
  //       print('Overlay permission denied');
  //       return;
  //     }
  //   }

  //   await _displayOverlay();
  // }

  // Future<bool> _requestOverlayPermission() async {
  //   return await showModalBottomSheet<bool>(
  //         context: context,
  //         isDismissible: false,
  //         isScrollControlled: true,
  //         backgroundColor: Colors.transparent,
  //         builder: (context) => BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //           child: Container(
  //             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
  //             decoration: BoxDecoration(
  //               color: AppPallete.whiteColor.withOpacity(.1),
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(height: 24.h),
  //                 Text(
  //                   "Permission Required for\nEnhanced Experience",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 22.sp,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //                 SizedBox(height: 16.h),
  //                 Text(
  //                   "ChatCupid needs permission to display an overlay for real-time chat tips on your favorite messaging and dating apps.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 16.sp, color: Colors.white),
  //                 ),
  //                 SizedBox(height: 8.h),
  //                 Text(
  //                   "Rest assured, your privacy is our priority. Please\ngrant permission to keep using ChatCupid smoothly.",
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(fontSize: 16.sp, color: Colors.white),
  //                 ),
  //                 SizedBox(height: 24.h),
  //                 ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(25.r),
  //                     ),
  //                   ),
  //                   onPressed: () async {
  //                     Navigator.pop(context, true);
  //                     await FlutterOverlayWindow.requestPermission();
  //                   },
  //                   child: Text(
  //                     "Grant Permission",
  //                     style: TextStyle(
  //                       fontSize: 18.sp,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 32.h),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ) ??
  //       false;
  // }

  // Future<void> _displayOverlay() async {
  //   await FlutterOverlayWindow.showOverlay(
  //     enableDrag: true,
  //     alignment: OverlayAlignment.topRight,
  //     overlayTitle: "X-SLAYER",
  //     overlayContent: 'Overlay Enabled',
  //     flag: OverlayFlag.defaultFlag,
  //     visibility: NotificationVisibility.visibilityPublic,
  //     positionGravity: PositionGravity.auto,
  //     height: 500.h.toInt(),
  //     width: 500.w.toInt(),
  //     startPosition: const OverlayPosition(0, 200),
  //   );
  // }
  Future<void> _checkShowcaseStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasShowcaseBeenShown = prefs.getBool('hasShowcaseBeenShown') ?? false;
    });
  }

  Future<void> _setShowcaseShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasShowcaseBeenShown', true);
  }

  @override
  void initState() {
    super.initState();
    _initializeWidget();
  }

  Future<void> _initializeWidget() async {
    await _checkShowcaseStatus();
    _checkIfAlertShown();
    _fetchChatItemsFromFirebase(); // Fetch initial data
    onboardingController.fetchUserName(); // Fetch the user name
    // _showOverlay().then((_) async {
    //   // If permission is granted, start the showcase after a delay
    //   if (await FlutterOverlayWindow.isPermissionGranted()) {
    //     // _startShowcaseAfterDelay();
    //   }
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _startShowcaseAfterDelay();
    // });

    if (!_hasShowcaseBeenShown) {
      WidgetsBinding.instance.addPostFrameCallback((timestamp) {
        ShowCaseWidget.of(context).startShowCase([_personaKey, _meSectionKey]);
        _setShowcaseShown(); // Mark showcase as shown after it starts
        setState(() {
          _hasShowcaseBeenShown = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _showcaseTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  final GlobalKey _meSectionKey = GlobalKey();
  final GlobalKey _personaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        onPressed: () {
          Get.toNamed(RoutesHelper.profileScreenSetting);
        },
        profileIcon: onboardingController.userProfilePic.value,
        text: onboardingController.userName.value.isNotEmpty
            ? onboardingController.userName.value.split(' ')[0]
            : "SuperCupid",
        textSize: 25.sp,
        hiText: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/third_onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Showcase(
                  key: _meSectionKey,
                  title: "Explore ME section! 💬 ",
                  overlayOpacity: .5,
                  tooltipBackgroundColor: AppPallete.chatScreenPrimary,
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  description:
                      "In ME section you can find the better version of your self 💖",
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.black.withOpacity(0.5),
                      border: const GradientBorder(
                        borderGradient: LinearGradient(
                          colors: [
                            Color(0xFFFF56A5),
                            Color(0xFF2ED2FD),
                          ],
                          tileMode: TileMode.repeated,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, 1.0],
                          transform: GradientRotation(0.0),
                        ),
                        width: 3,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        final ChatControllers meSectionController = Get.put(
                            ChatControllers(personaName: null),
                            tag: 'me_section');
                        Get.toNamed(RoutesHelper.meSectionTextingScreen,
                            arguments: {'controllers': meSectionController});
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20.h,
                                  // horizontal: 8.w,
                                ),
                                prefixIcon: SvgPicture.asset(
                                  CustomIcons.meIcon,
                                  width: 10.w,
                                  height: 10.w,
                                ),
                                border: InputBorder.none,
                                hintText: "  me, being just me!",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.sp,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              enabled: false,
                            ),
                          ),
                          Row(
                            children: [
                              StreakAssetWidget(),
                              // SizedBox(width: 5.w),
                              Obx(() => Text(
                                    '${streakControllers.currentStreak.value} days',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 180.h,
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: AppPallete.homeScreenBackgroundColor.withOpacity(.50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppPallete.homeScreensIconColor
                                    .withOpacity(.40),
                                borderRadius: BorderRadius.circular(50)),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search,
                                size: 35.w,
                                color: AppPallete.whiteColor,
                              ),
                            ),
                          ),
                          Spacer(),

                          // SizedBox(
                          //   width: 80.w,
                          // ),
                          // FlutterSwitch(
                          //   width: 100.w,
                          //   activeColor: AppPallete.primaryColor,
                          //   inactiveColor:
                          //       AppPallete.homeScreensIconColor.withOpacity(.4),
                          //   height: 50.h,
                          //   valueFontSize: 25.0,
                          //   toggleSize: 45.0,
                          //   value: status,
                          //   borderRadius: 30.0,
                          //   toggleColor: Colors.white.withOpacity(.2),
                          //   activeToggleColor: Colors.white,
                          //   padding: 6.sp,
                          //   showOnOff: false,
                          //   onToggle: (val) {
                          //     setState(() {
                          //       status = val;
                          //     });
                          //   },
                          // ),

                          Showcase(
                            key: _personaKey,
                            title: "Welcome to the heart of ChatCupid! 💬 ",
                            overlayOpacity: .5,
                            tooltipBackgroundColor:
                                AppPallete.chatScreenPrimary,
                            textColor: const Color.fromARGB(255, 255, 255, 255),
                            description:
                                "Here, you can chat with replicas of your loved ones or yourself, upload screenshots to get the next best reply, and explore ways to improve your relationships. Whether it's deepening self-love in the ‘Me’ section or navigating relationship dynamics with your partner, we’re here to guide you. 💖",
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppPallete.homeScreensIconColor
                                      .withOpacity(.40),
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                onPressed: _showAddChatItemDialog,
                                icon: Icon(
                                  Icons.add,
                                  size: 35.w,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chatItems.length,
                        itemBuilder: (context, index) {
                          final chatItem = chatItems[index];
                          return Column(
                            children: [
                              UserChatItemList(
                                name: chatItem["name"],
                                message: chatItem["message"],
                                imageUrl: chatItem["imageUrl"],
                                isOnline: chatItem["isOnline"],
                                fireIconCount: chatItem["fireIconCount"],
                                // onPressed: () {
                                // String welcomeMessage =
                                //     getRandomWelcomeMessage(
                                //   this.userName, // Access from widget parameters
                                //   this.lovedOnesName, // Access from widget parameters
                                // );

                                // Add the welcome message to the chat controller
                                // Get.find<ChatControllers>()
                                //     .addMessage(welcomeMessage, false);

                                // Get.toNamed(RoutesHelper.chatScreen);
                                // },
                                userName: onboardingController
                                    .userName.value, // Pass user name
                                lovedOnesName: chatItem["name"],
                                index: index, //
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 110.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200.h,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "That's all\nfor Today\n",
                                      style: TextStyle(
                                        fontSize: 35.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "\nMade with ❤️ for all lovers ",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 110.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
