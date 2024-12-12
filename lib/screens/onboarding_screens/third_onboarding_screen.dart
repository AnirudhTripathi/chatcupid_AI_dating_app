import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/onboarding_controllers.dart';
import 'package:chatcupid/screens/onboarding_screens/widgets/indicator_container.dart';
import 'package:chatcupid/routes/routes_helper.dart';
import 'package:chatcupid/widgets/auth_button.dart';
// import 'package:currency_picker/currency_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ThirdOnboardingScreen extends StatefulWidget {
  ThirdOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<ThirdOnboardingScreen> createState() => _ThirdOnboardingScreenState();
}

class _ThirdOnboardingScreenState extends State<ThirdOnboardingScreen> {
  final OnboardingController onboardingController =
      Get.find<OnboardingController>();

  String selectedCountry = "Select Country";
  TextEditingController ageController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/third_onboarding_screen.png",
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 65.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IndicatorContainer(index: 0),
                  SizedBox(width: 10.w),
                  IndicatorContainer(index: 1),
                  SizedBox(width: 10.w),
                  IndicatorContainer(index: 2),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 80.h,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    "How young are you and what's your gender? We can't wait to get to know you better! 🎂✨",
                    style: TextStyle(
                      fontSize: 24.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                // Age TextField
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35.w,
                        vertical: 15.h,
                      ),
                      hintText: "Enter Age",
                      filled: true,
                      fillColor:
                          AppPallete.onboardingButtonColor.withOpacity(.21),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // Gender Dropdown
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 35.w,
                        vertical: 15.h,
                      ),
                      hintText: "Gender",
                      filled: true,
                      fillColor:
                          AppPallete.onboardingButtonColor.withOpacity(.21),
                      border: OutlineInputBorder(
                        // gapPadding: ,
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedGender,
                    items: [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(
                          value: "Prefer not to say",
                          child: Text("Prefer not to say")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: AuthButton(
                    onPressed: () {
                      // if (await FlutterOverlayWindow.isActive()) return;
                      // await FlutterOverlayWindow.showOverlay(
                      //   enableDrag: true,
                      //   alignment: OverlayAlignment.topRight,
                      //   overlayTitle: "X-SLAYER",
                      //   overlayContent: 'Overlay Enabled',
                      //   flag: OverlayFlag.defaultFlag,
                      //   visibility: NotificationVisibility.visibilityPublic,
                      //   positionGravity: PositionGravity.auto,
                      //   height: 500.toInt(),
                      //   width: 500.toInt(),
                      //   startPosition: const OverlayPosition(0, 200),
                      // );

                      showCountryPicker(
                        context: context,
                        // showFlag: true,
                        // showSearchField: true,
                        // showCurrencyName: true,
                        useRootNavigator: true,
                        searchAutofocus: false,
                        showWorldWide: false,
                        showSearch: true,
                        useSafeArea: false,
                        //  useRootNavigator = false,
                        moveAlongWithKeyboard: false,
                        showPhoneCode: false,
                        // showCurrencyCode: false,
                        onSelect: (Country country) {
                          setState(() {
                            selectedCountry = country.name;
                          });
                        },
                      );
                    },
                    buttonText: selectedCountry,
                    mainAxisAlignment: MainAxisAlignment.start,
                    backgroundColor:
                        AppPallete.onboardingButtonColor.withOpacity(.21),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 26.h,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthButton(
                  buttonText: "Next",
                  onPressed: () {
                    if (selectedCountry != "Select Country" &&
                        selectedGender != null &&
                        ageController.text.isNotEmpty) {
                      onboardingController.saveUserDetails(
                        age: ageController.text,
                        gender: selectedGender,
                        country: selectedCountry,
                      );

                      Get.offNamed(RoutesHelper.bottomNavbar);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text("Please Complete the above details status"),
                        ),
                      );
                    }
                  },
                  buttonTextColor: AppPallete.blackColor,
                  backgroundColor: AppPallete.whiteColor,
                  googleIcon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
