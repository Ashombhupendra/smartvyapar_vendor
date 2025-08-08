import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/status_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/shimmer/trip_list_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/taxi_order_button_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/taxi_order_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class TaxiHomeScreen extends StatefulWidget {
  const TaxiHomeScreen({super.key});

  @override
  State<TaxiHomeScreen> createState() => _TaxiHomeScreenState();
}

class _TaxiHomeScreenState extends State<TaxiHomeScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    TripController tripController = Get.find<TripController>();

    tripController.getTripList(status: 'pending', offset: '1', willUpdate: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!tripController.isLoading && tripController.tripsList != null) {
          int nextPage = (tripController.tripsList!.length ~/ tripController.pageSize!) + 1;
          tripController.showBottomLoader();
          tripController.getTripList(status: tripController.selectedStatus!, offset: nextPage.toString());
        }
      }
    });

  }

  Future<void> _loadData() async {
    await Get.find<TaxiProfileController>().getProfile();
    await Get.find<ProfileController>().getProfile();
    await Get.find<NotificationController>().getNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaxiProfileController>(builder: (profileController) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          leading: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: CustomImageWidget(
                image: profileController.profileModel != null ? profileController.profileModel!.stores![0].logoFullUrl ?? '' : '',
                height: 30, width: 30, fit: BoxFit.cover,
              ),
            ),
          ),
          titleSpacing: 0,
          surfaceTintColor: Theme.of(context).cardColor,
          shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
          elevation: 2,
          title: Text(
            profileController.profileModel != null ? profileController.profileModel!.stores![0].name ?? '' : '',
            maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault),
          ),
          actions: [IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              return Stack(children: [
                Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
                notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : const SizedBox(),
              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          )],
        ),

        body: RefreshIndicator(
          onRefresh: () async {
            await Get.find<TripController>().getTripList(status: Get.find<TripController>().selectedStatus!, offset: '1', willUpdate: true);
            await Get.find<NotificationController>().getNotificationList();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [

              profileController.taxiModulePermission != null && profileController.taxiModulePermission!.storeSetup! ? Row(children: [
                Expanded(child: Text(
                  'provider_temporary_off'.tr, style: robotoMedium,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),

                profileController.profileModel != null ? Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: !profileController.profileModel!.stores![0].active!,
                    activeTrackColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                    onChanged: (bool isActive) {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning,
                        description: isActive ? 'are_you_sure_to_close_service'.tr : 'are_you_sure_to_open_service'.tr,
                        onYesPressed: () {
                          Get.back();
                          Get.find<AuthController>().toggleStoreClosedStatus();
                        },
                      ));
                    },
                  ),
                ) : Shimmer(duration: const Duration(seconds: 2), child: Container(height: 30, width: 50, color: Colors.grey[300])),
              ]) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              profileController.taxiModulePermission != null && profileController.taxiModulePermission!.myWallet! ? Row(children: [
                Expanded(
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Image.asset(Images.wallet, width: 70, height: 70),
                      const Spacer(),

                      Text(
                        'today'.tr,
                        style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withValues(alpha: 0.7)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text(
                        profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.todaysEarning) : '0',
                        style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                      ),

                    ]),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity, height: 95,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            'this_week'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withValues(alpha: 0.7)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisWeekEarning) : '0',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      Container(
                        width: double.infinity, height: 95,
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            'this_month'.tr,
                            style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withValues(alpha: 0.7)),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            profileController.profileModel != null ? PriceConverterHelper.convertPrice(profileController.profileModel!.thisMonthEarning) : '0',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                          ),

                        ]),
                      ),
                    ],
                  ),
                ),
              ]) : const SizedBox(),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),

              GetBuilder<TripController>(builder: (tripController) {
                List<StatusListModel> statusList = StatusListModel.getHomeStatusList();

                return profileController.taxiModulePermission != null ? profileController.taxiModulePermission!.trip! ? Column(children: [

                  SizedBox(
                    height: 35,
                    child: Wrap(
                      spacing: 0,
                      children: List.generate(statusList.length, (index) {
                        return TaxiOrderButtonWidget(
                          statusListModel: statusList[index],
                          index: index,
                          tripController: tripController,
                          titleLength: statusList.length,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  tripController.tripsList != null ? tripController.tripsList!.isNotEmpty ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tripController.tripsList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => TripDetailsScreen(tripId: tripController.tripsList![index].id!, tripStatus: tripController.tripsList?[index].tripStatus));
                        },
                        child: TaxiOrderWidget(
                          trips: tripController.tripsList![index],
                          index: index,
                          isExpanded: tripController.expandedIndex == index,
                          onToggle: () {
                            tripController.setExpandedIndex(tripController.expandedIndex == index ? null : index);
                          },
                        ),
                      );
                    },
                  ) : Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: Dimensions.paddingSizeLarge),
                    child: Center(child: Text('no_trip_found'.tr)),
                  ) : const TripListShimmer(),

                ]) : Center(child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium),
                )) : const TripListShimmer();
              }),

            ]),
          ),
        ),
      );
    });
  }
}
