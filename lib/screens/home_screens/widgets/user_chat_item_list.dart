import 'dart:math';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/constants/theme/custom_icons.dart';
import 'package:chatcupid/controllers/chat_controllers.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/screens/home_screens/widgets/streak_asset_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserChatItemList extends StatelessWidget {
  final String name;
  final String message;
  final String imageUrl;
  final bool isOnline;
  final int fireIconCount;
  final int index;
  final bool isFavorite;

  final String userName; // Add logged-in user name
  final String lovedOnesName;

  UserChatItemList({
    super.key,
    required this.name,
    required this.message,
    required this.imageUrl,
    this.isOnline = false,
    this.fireIconCount = 0,
    this.isFavorite = false,
    // required this.onPressed,
    required this.userName,
    required this.lovedOnesName,
    required this.index,
    // required this.onPressed,
  });
 

  final List<String> profilePics = [
    "https://i.pinimg.com/236x/58/a2/cc/58a2cc4ca9e95c1c0c86caae83574acf.jpg",
    "https://w0.peakpx.com/wallpaper/264/475/HD-wallpaper-profile-pic-girl-profile.jpg",
    "https://play-lh.googleusercontent.com/4kjW5ZzvqS0qt207RCG8mCmKei_spnyX5Ctt0GJrECwVXqafdWetYioQrkAAFPLOd_I=w526-h296-rw",
    "https://play-lh.googleusercontent.com/050MUO_KcXxnSjq6V9B4OIbiTGPjv6fxHFhIGNNJsaHj2uld5mwzxO3Uf85Cp6q4Fn2B=w2560-h1440-rw",
    "https://play-lh.googleusercontent.com/t2tJJ3PvHpZwSVH20B7zGBqcqMrUMnNpQ8re_BiS6vqdxboDm_RM_pcJvuRY-n8KvGA=w526-h296-rw",
    "https://play-lh.googleusercontent.com/uYyPNapgIIo9yloQOyZ1TGCSNgBiUqpDpnVycPM21fEXC2rNk2F21kVQ2DnDu64OHw=w526-h296-rw",
  ];
  Future<bool> _wasWelcomeMessageShown(String personaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('welcomeShown_$personaName') ?? false;
  }

  Future<void> _setWelcomeMessageShown(String personaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeShown_$personaName', true);
  }

  @override
  Widget build(BuildContext context) {
    final ChatControllers controllers = Get.put(
      ChatControllers(personaName: name),
      tag: name, // Use persona's name as tag
    );

    return InkWell(
      onTap: () async {
        // Get a random welcome message
        // if (!(await _wasWelcomeMessageShown(lovedOnesName))) {
        //   // Get a random welcome message
        //   String welcomeMessage = getRandomWelcomeMessage(
        //     userName,
        //     lovedOnesName,
        //   );

        //   // Add the welcome message to the chat controller
        //   // Get.find<ChatControllers>().addMessage(welcomeMessage, false);
        //   final ChatControllers controllers = Get.put(
        //     ChatControllers(personaName: name),
        //     tag: name, // Use persona's name as tag
        //   );
        //   // Mark the welcome message as shown for this persona
        //   await _setWelcomeMessageShown(lovedOnesName);
        // }

        // Add the welcome message to the chat controller
        // Get.find<ChatControllers>().addMessage(welcomeMessage, false);

        Get.toNamed(RoutesHelper.getchatScreen(name));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppPallete.backgroundColor.withOpacity(.50),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.w,
            horizontal: 10.h,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    NetworkImage(profilePics[index % profilePics.length]),
                child: isOnline
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 6.w,
                          backgroundColor: Colors.green,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        if (isFavorite)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.favorite,
                                color: Colors.red, size: 16),
                          ),
                      ],
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              if (fireIconCount > 0)
                Row(
                  children: [
                    StreakAssetWidget(),
                    SizedBox(width: 5),
                    Text(
                      fireIconCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
