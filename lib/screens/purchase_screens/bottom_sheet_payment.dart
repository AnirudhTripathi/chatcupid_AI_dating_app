import 'dart:async';
import 'dart:ui';

import 'package:chatcupid/constants/theme/app_pallete.dart';
import 'package:chatcupid/widgets/auth_button.dart';
import 'package:chatcupid/widgets/gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print('Error listening to purchase updates: $error');
    });

    initStoreInfo(); // Initialize store info
    super.initState();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    // Define your product IDs from the app stores
    const Set<String> _kProductIds = {
      'one_month_premium',
      'one_year_premium',
      'one_week_premium'
    };

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds);
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = [];
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _products.sort((a, b) {
      // Assuming your product IDs are in the format: one_week_premium, one_month_premium, one_year_premium
      if (a.id.contains('week') &&
          (b.id.contains('month') || b.id.contains('year'))) {
        return -1; // a (week) comes before b (month or year)
      } else if (a.id.contains('month') && b.id.contains('year')) {
        return -1; // a (month) comes before b (year)
      } else {
        return 1; // a comes after b
      }
    });

    List<Widget> productCards = [];
    if (productCards.length == 3) {
      final temp = productCards[1]; // Store the 1-month card
      productCards[1] = productCards[0]; // Move 1-week to the middle
      productCards[0] = temp; // Move 1-month to the beginning
    }

    if (_loading) {
      productCards.add(const Center(child: CircularProgressIndicator()));
    } else if (!_isAvailable) {
      productCards.add(const Center(child: Text('Store not available')));
    } else if (_queryProductError != null) {
      productCards.add(Center(child: Text(_queryProductError!)));
    } else {
      productCards.addAll(_products.map((productDetails) {
        return _buildProductCard(productDetails);
      }).toList());
    }

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 310.h,
          width: Get.width,
          padding: EdgeInsets.all(16.0.w),
          decoration: BoxDecoration(
            color: AppPallete.whiteColor.withOpacity(.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 30.w,
                  ),
                  const Text(
                    'Buy premium',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: productCards,
              ),
              SizedBox(height: 36.h),
              AuthButton(
                buttonText: "Continue",
                onPressed: () {},
                buttonTextColor: AppPallete.blackColor,
                backgroundColor: AppPallete.whiteColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductDetails productDetails) {
    return GestureDetector(
      onTap: () {
        _handlePurchase(productDetails);
      },
      child: Stack(
        children: [
          Container(
            height: 100.w,
            width: 100.w,
            decoration: BoxDecoration(
              color: AppPallete.transparentColor,
              border: productDetails.id == "one_month_premium"
                  ? GradientBorder.uniform(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 255, 255, 255),
                          const Color(0xFF00E0FF),
                          const Color(0xFFFF8FF4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      width: 4.0,
                      text: "Most popular",
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                    )
                  : Border.all(
                      color: Colors.white,
                    ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  productDetails.id == "one_year_premium"
                      ? "One Year"
                      : productDetails.id == "one_week_premium"
                          ? "1 Week"
                          : "1 Month",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  productDetails.price,
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePurchase(ProductDetails productDetails) async {
    // Show a loading indicator or disable the button to prevent multiple clicks
    setState(() {
      _purchasePending = true;
    });

    try {
      // Make the purchase
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null, // You can add a user identifier if needed
      );

      if (productDetails.id == 'consumable_product_id') {
        // Use buyConsumable for consumable products
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: true, // Auto consume the product if it's consumable
        );
      } else {
        // Use buyNonConsumable for non-consumable products
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      print('Purchase error: $e');
      // Handle the purchase error appropriately
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Adjust purchasing logic to your use case.
    if (purchaseDetails.productID == 'one_day_premium') {
      // Unlock the premium features for one day
    } else if (purchaseDetails.productID == 'one_week_premium') {
      // Unlock the premium features for one week
    } else if (purchaseDetails.productID == 'one_month_premium') {
      // Unlock the premium features for one month
    }

    // Update the UI to reflect the purchase
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    });
  }

  void handleError(IAPError error) {
    setState(() {
      _purchasePending = false;
    });
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here
  }
}
