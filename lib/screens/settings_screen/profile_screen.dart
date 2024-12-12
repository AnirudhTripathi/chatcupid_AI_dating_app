import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/controllers/profile_controller.dart';
import 'package:chatcupid/widgets/custom_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/routes_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<String> status = [
    'Single 🙂',
    'In a relationship 💏',
    'Crushing 🥰',
    'Married 💑',
    'It’s complicated',
    'Broken hearted 💔',
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    _profileController.fetchUserData().then((_) {
      _nameController.text = _profileController.userData['name'] ?? '';
      _emailController.text = _profileController.userData['email'] ?? '';
      _phoneController.text = _profileController.userData['phone'] ?? '';
      selectedStatus = _profileController.userData['relationshipStatus'];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.transparentColor,
      extendBodyBehindAppBar: true,
      appBar: CustomAppbar(
        text: "      Profile",
        textSize: 25.sp,
        saveIcon: true,
        // mainAxisAlignment: MainAxisAlignment.end,
        // profileIcon: "dsv",
        showProfile: false,

        // onPressed: () {
        //   Get.toNamed(RoutesHelper.chatScreenSetting);
        // },
        backButton: true,
        appbarIcon: false,
      ),
      body: Obx(
        () {
          // <-- Wrap body in Obx
          if (_profileController.isLoading.value) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (_profileController.userData.isEmpty) {
            return Center(
                child: Text('No user data found')); // Handle no data case
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundImage: NetworkImage(
                              _profileController.userData['profilePicture'],
                            ),
                          ),
                          CircleAvatar(
                            radius: 16.r,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.edit,
                                size: 16.sp, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        'Change profile picture',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildProfileTextField(
                      'Name',
                      _profileController.userData['name'] ?? '',
                      _nameController,
                      'name',
                      (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildProfileTextField(
                      'Email',
                      _profileController.userData['email'] ?? '',
                      _emailController,
                      'email',
                      (value) {
                        if (value == null || value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter your email'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please enter a valid email address'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildProfileTextField(
                        // Pass validator to _buildProfileTextField
                        'Phone',
                        _profileController.userData['phone'] ?? '',
                        _phoneController,
                        'phone',
                        _validatePhoneNumber),
                    SizedBox(height: 24.h),
                    //relationship status ship dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Relationship Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedStatus,
                          items: status.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedStatus = newValue;
                              _profileController.updateUserData(
                                  'relationshipStatus', newValue!);
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 40.h),
                    _buildProfileListItem(
                      icon: Icons.handshake,
                      text: 'Term of use',
                      onPressed: () async {
                        await goToWebPage(
                            "https://chatcupid.app/terms-and-condition");
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildProfileListItem(
                      icon: Icons.verified_user,
                      text: 'Privacy Policy',
                      onPressed: () async {
                        await goToWebPage(
                            "https://chatcupid.app/privacy-policy.html");
                      },
                    ),
                    SizedBox(height: 24.h),
                    _buildProfileListItem(
                      icon: Icons.logout,
                      text: 'Logout',
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          Get.toNamed(RoutesHelper.initialOnboardingScreen);
                          SystemNavigator.pop();
                        } catch (e) {
                          // Handle any error that occurs during sign-out
                          Get.snackbar(
                              'Error', 'Failed to log out. Please try again.');
                        }
                      },
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileTextField(
      String label,
      String initialValue,
      TextEditingController controller,
      String fieldName,
      String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 8.h),
        // Use TextFormField for editing
        TextFormField(
          validator: validator,
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit, color: Colors.grey[400], size: 20.sp),
              onPressed: () {
                // Update the field in Firestore
                // _profileController.updateUserData(fieldName, initialValue);
                _profileController.updateUserData(fieldName, controller.text);
              },
            ),
          ),
          onChanged: (newValue) {
            // Update Firebase when text changes
            _profileController.updateUserData(fieldName, newValue);
          },
        ),
      ],
    );
  }

  // Helper function to build list items
  Widget _buildProfileListItem({
    required VoidCallback? onPressed,
    required IconData icon,
    required String text,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20.sp),
          SizedBox(width: 16.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your Phone Number'),
          backgroundColor: Colors.red,
        ),
      );
      return 'Please enter a phone number';
    }
    if (value.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number must be 10 digits'),
          backgroundColor: Colors.red,
        ),
      );
      return 'Phone number must be 10 digits';
    }
    return null; // Return null if validation passes
  }

  Future<void> goToWebPage(String urlString) async {
    final Uri _url = Uri.parse(urlString);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
