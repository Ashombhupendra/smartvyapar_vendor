import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/menu/domain/models/menu_model.dart';
import 'package:sixam_mart_store/helper/responsive_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/features/menu/widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> menuList = [];

    menuList.add(MenuModel(icon: '', title: 'profile'.tr, route: RouteHelper.getProfileRoute()));

    if(Get.find<ProfileController>().modulePermission!.item!) {
      menuList.add(MenuModel(
        icon: Images.addFood, title: 'add_item'.tr, route: RouteHelper.getAddItemRoute(null),
        isBlocked: !Get.find<ProfileController>().profileModel!.stores![0].itemSection!,
      ));
    }
    if(Get.find<ProfileController>().modulePermission!.item!) {
      menuList.add(MenuModel(
        icon: Images.pendingItemIcon, title: 'pending_item'.tr, route: RouteHelper.getPendingItemRoute(),
      ));
    }
    if(Get.find<ProfileController>().modulePermission!.item!) {
      menuList.add(MenuModel(icon: Images.categories, title: 'categories'.tr, route: RouteHelper.getCategoriesRoute()));
    }
    if(Get.find<ProfileController>().modulePermission!.campaign!) {
      menuList.add(MenuModel(icon: Images.bannerIcon, title: 'banner'.tr, route: RouteHelper.getBannerListRoute()));
    }

    menuList.add(MenuModel(icon: Images.adsMenu, title: 'advertisements'.tr, route: RouteHelper.getAdvertisementListRoute()));

    if(Get.find<ProfileController>().modulePermission!.campaign!) {
      menuList.add(MenuModel(icon: Images.campaign, title: 'campaign'.tr, route: RouteHelper.getCampaignRoute()));
    }

    if(Get.find<ProfileController>().profileModel!.stores![0].selfDeliverySystem == 1 && Get.find<AuthController>().getUserType() == 'owner' && Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel != 'subscription') {
      menuList.add(MenuModel(icon: Images.deliveryMan, iconColor: Colors.white, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute()));
    } else if(Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription') {
      menuList.add(MenuModel(
        icon: Images.deliveryMan, iconColor: Colors.white, title: 'delivery_man'.tr, route: RouteHelper.getDeliveryManRoute(),
        isNotSubscribe: Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.selfDelivery == 0,
      ));
    }

    menuList.add(MenuModel(icon: Images.warning, iconColor: Colors.white, title: 'low_stock'.tr, route: RouteHelper.getLowStockRoute()));

    menuList.add(MenuModel(icon: Images.review, title: 'reviews'.tr, route: RouteHelper.getCustomerReviewRoute(), isNotSubscribe: Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.review == 0));

    menuList.add(MenuModel(icon: Images.mySubscriptionIcon, title: 'my_business_plan'.tr, route: RouteHelper.getMySubscriptionRoute()));

    if(Get.find<SplashController>().configModel!.moduleConfig!.module!.addOn! && Get.find<ProfileController>().modulePermission!.addon!) {
      menuList.add(MenuModel(icon: Images.addon, title: 'addons'.tr, route: RouteHelper.getAddonsRoute()));
    }
    if(Get.find<ProfileController>().modulePermission!.chat!) {
      menuList.add(
        MenuModel(
          icon: Images.chat, title: 'conversation'.tr, route: RouteHelper.getConversationListRoute(),
          isNotSubscribe: (Get.find<ProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription' && Get.find<ProfileController>().profileModel!.subscription!.chat == 0),
        ),
      );
    }
    menuList.add(MenuModel(icon: Images.language, title: 'language'.tr, route: '', isLanguage: true));
    menuList.add(MenuModel(icon: Images.coupon, title: 'coupon'.tr, route: RouteHelper.getCouponRoute()));
    menuList.add(MenuModel(icon: Images.expense, title: 'expense_report'.tr, route: RouteHelper.getExpenseRoute()));
    menuList.add(MenuModel(icon: Images.chat, title: 'Help'.tr, route: 'help'));

    if(Get.find<SplashController>().configModel!.disbursementType == 'automated') {
      menuList.add(MenuModel(icon: Images.disbursementIcon, title: 'disbursement'.tr, route: RouteHelper.getDisbursementMenuRoute()));
    }

    menuList.add(MenuModel(icon: Images.policy, title: 'privacy_policy'.tr, route: RouteHelper.getPrivacyRoute()));
    menuList.add(MenuModel(icon: Images.terms, title: 'terms_condition'.tr, route: RouteHelper.getTermsRoute()));
    menuList.add(MenuModel(icon: Images.logOut, title: 'logout'.tr, route: ''));

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
            return MenuButtonWidget(menu: menuList[index], isProfile: index == 0, isLogout: index == menuList.length-1);
          },
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

      ]),
    );
  }

}
