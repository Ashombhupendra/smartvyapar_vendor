import 'package:sixam_mart_store/features/html/screens/html_viewer_screen.dart';
import 'package:sixam_mart_store/features/subscription/screens/my_subscription_screen.dart';
import 'package:sixam_mart_store/features/rental_module/banner/screens/taxi_banner_list_screen.dart';
import 'package:sixam_mart_store/features/rental_module/brand/screens/taxi_brand_screen.dart';
import 'package:sixam_mart_store/features/rental_module/category/screens/taxi_category_screen.dart';
import 'package:sixam_mart_store/features/rental_module/chat/screens/taxi_conversation_screen.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/screens/taxi_coupon_screen.dart';
import 'package:sixam_mart_store/features/rental_module/driver/screens/driver_list_screen.dart';
import 'package:sixam_mart_store/features/rental_module/expense/screens/expense_screen.dart';
import 'package:sixam_mart_store/features/rental_module/menu/domain/models/taxi_menu_model.dart';
import 'package:sixam_mart_store/features/rental_module/menu/widgets/taxi_menu_button_widget.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/screens/taxi_profile_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/add_vehicle_screen.dart';
import 'package:sixam_mart_store/features/rental_module/review/screens/taxi_customer_review_screen.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiMenuScreen extends StatelessWidget {
  const TaxiMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TaxiMenuModel> menuList = [];

    if(Get.find<TaxiProfileController>().taxiModulePermission!.profile!){
      menuList.add(TaxiMenuModel(icon: '', title: 'profile'.tr, route: const TaxiProfileScreen()));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.vehicle!) {
      menuList.add(TaxiMenuModel(
        icon: Images.taxiAddCarIcon, title: 'add_vehicle'.tr, route: const AddVehicleScreen(),
        isBlocked: !Get.find<TaxiProfileController>().profileModel!.stores![0].itemSection!,
      ));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.vehicle!) {
      menuList.add(TaxiMenuModel(icon: Images.categories, title: 'categories'.tr, route: const TaxiCategoryScreen()));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.vehicle!) {
      menuList.add(TaxiMenuModel(icon: Images.brandIcon, title: 'brands'.tr, route: const TaxiBrandScreen()));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.marketing!) {
      menuList.add(TaxiMenuModel(icon: Images.bannerIcon, title: 'banner'.tr, route: const TaxiBannerListScreen()));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.driver!){
      menuList.add(TaxiMenuModel(icon: Images.driverIcon, iconColor: Colors.white, title: 'drivers'.tr, route: const DriverListScreen()));
    }

    if(Get.find<TaxiProfileController>().taxiModulePermission!.reviews!){
      menuList.add(TaxiMenuModel(icon: Images.review, title: 'reviews'.tr, route: const TaxiCustomerReviewScreen(), isNotSubscribe: Get.find<TaxiProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription' && Get.find<TaxiProfileController>().profileModel!.subscription!.review == 0));
    }

    menuList.add(TaxiMenuModel(icon: Images.mySubscriptionIcon, title: 'business_plan'.tr, route: const MySubscriptionScreen(fromNotification: false)));

    if(Get.find<TaxiProfileController>().taxiModulePermission!.chat!) {
      menuList.add(
        TaxiMenuModel(
          icon: Images.chat, title: 'chatting'.tr, route: const TaxiConversationScreen(),
          isNotSubscribe: (Get.find<TaxiProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription' && Get.find<TaxiProfileController>().profileModel!.subscription!.chat == 0),
        ),
      );
    }
    menuList.add(TaxiMenuModel(icon: Images.language, title: 'language'.tr, route: '', isLanguage: true));
    if(Get.find<TaxiProfileController>().taxiModulePermission!.marketing!) {
      menuList.add(TaxiMenuModel(icon: Images.coupon, title: 'coupon'.tr, route: const TaxiCouponScreen()));
    }
    if(Get.find<TaxiProfileController>().taxiModulePermission!.rentalReport!) {
      menuList.add(TaxiMenuModel(icon: Images.expense, title: 'report'.tr, route: const ExpenseScreen()));
    }
    menuList.add(TaxiMenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: const HtmlViewerScreen(isPrivacyPolicy: true)));
    menuList.add(TaxiMenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: const HtmlViewerScreen(isPrivacyPolicy: false)));
    menuList.add(TaxiMenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''));

    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, childAspectRatio: ResponsiveHelper.isTab(context) ? 1/1.5 : (1/1.22),
            crossAxisSpacing: Dimensions.paddingSizeExtraSmall, mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
          ),
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return TaxiMenuButtonWidget(menu: menuList[index], isProfile: index == 0, isLogout: index == menuList.length-1);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    );
  }
}
