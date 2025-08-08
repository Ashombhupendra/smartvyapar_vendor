import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/features/profile/widgets/notification_status_change_bottom_sheet.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/screens/taxi_update_profile_screen.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/switch_button_widget.dart';
import 'package:sixam_mart_store/features/profile/widgets/profile_bg_widget.dart';
import 'package:sixam_mart_store/features/profile/widgets/profile_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiProfileScreen extends StatefulWidget {
  const TaxiProfileScreen({super.key});

  @override
  State<TaxiProfileScreen> createState() => _TaxiProfileScreenState();
}

class _TaxiProfileScreenState extends State<TaxiProfileScreen> {
  late bool _isOwner;

  @override
  void initState() {
    super.initState();

    Get.find<TaxiProfileController>().getProfile();
    _isOwner = Get.find<AuthController>().getUserType() == 'owner';
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<TaxiProfileController>(builder: (taxiProfileController) {
        return taxiProfileController.profileModel == null ? const Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: true,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(child: CustomImageWidget(
              image: taxiProfileController.profileModel?.imageFullUrl ?? '',
              height: 100, width: 100, fit: BoxFit.cover,
            )),
          ),
          mainWidget: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Center(child: Container(
            width: 1170, color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              _isOwner ? Text(
                '${taxiProfileController.profileModel!.fName} ${taxiProfileController.profileModel!.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ) : Text(
                '${taxiProfileController.profileModel!.employeeInfo!.fName} ${taxiProfileController.profileModel!.employeeInfo!.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: 30),

              Row(children: [
                _isOwner ? ProfileCardWidget(title: 'since_joining'.tr, data: '${taxiProfileController.profileModel!.memberSinceDays} ${'days'.tr}') : const SizedBox(),
                SizedBox(width: Get.find<TaxiProfileController>().taxiModulePermission!.trip! && _isOwner ? Dimensions.paddingSizeSmall : 0),
                Get.find<TaxiProfileController>().taxiModulePermission!.trip! ? ProfileCardWidget(title: 'total_trip'.tr, data: taxiProfileController.profileModel!.orderCount.toString()) : const SizedBox(),
              ]),
              const SizedBox(height: 30),

              SwitchButtonWidget(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              GetBuilder<AuthController>(builder: (authController) {
                return SwitchButtonWidget(
                  icon: Icons.notifications, title: 'notification'.tr,
                  isButtonActive: authController.notification, onTap: () {
                    showCustomBottomSheet(
                      child: const NotificationStatusChangeBottomSheet(),
                    );
                  },
                );
              }),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _isOwner ? SwitchButtonWidget(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeSmall : 0),

              _isOwner ? SwitchButtonWidget(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.to(() => TaxiUpdateProfileScreen());
              }) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeSmall : 0),

              _isOwner ? SwitchButtonWidget(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(ConfirmationDialogWidget(icon: Images.warning, title: 'are_you_sure_to_delete_account'.tr,
                    description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                    onYesPressed: () => taxiProfileController.deleteVendor()),
                    useSafeArea: false,
                  );
                },
              ) : const SizedBox(),
              SizedBox(height: _isOwner ? Dimensions.paddingSizeLarge : 0),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text(AppConstants.appVersion.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}