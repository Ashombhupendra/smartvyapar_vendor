import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/status_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/shimmer/trip_list_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/taxi_order_button_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/taxi_order_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    tripController.getTripList(status: tripController.selectedHistoryStatus!, offset: '1');

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!tripController.isLoading && tripController.tripsList != null) {
          int nextPage = (tripController.tripsList!.length ~/ tripController.pageSize!) + 1;
          tripController.showBottomLoader();
          tripController.getTripList(status: tripController.selectedHistoryStatus!, offset: nextPage.toString());
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'trip_history'.tr, isBackButtonExist: false),
      body: GetBuilder<TripController>(builder: (tripController) {
        List<StatusListModel> statusList = StatusListModel.getHistoryStatusList();

        return Get.find<TaxiProfileController>().taxiModulePermission!.trip! ? Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(children: [

            GetBuilder<TaxiProfileController>(builder: (profileController) {
              return profileController.profileModel != null ? Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Column(children: [

                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Row(children: [
                      Expanded(child: Text('total_completed_trips'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor))),
                      Text('${profileController.profileModel!.orderCount}', style: robotoBold.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeExtraLarge)),
                    ]),
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                      Text('today'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(profileController.profileModel!.todaysOrderCount.toString(), style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor,
                      )),

                    ]),

                    Container(height: 35, width: 0.5, color: Theme.of(context).cardColor.withValues(alpha: 0.5)),

                    Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                      Text('this_week'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(profileController.profileModel!.thisWeekOrderCount.toString(), style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor,
                      )),

                    ]),

                    Container(height: 35, width: 0.5, color: Theme.of(context).cardColor.withValues(alpha: 0.5)),

                    Column(crossAxisAlignment: CrossAxisAlignment.center, children: [

                      Text('this_month'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor)),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text(profileController.profileModel!.thisMonthOrderCount.toString(), style: robotoBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor,
                      )),

                    ]),

                  ]),
                ]),
              ) : const SizedBox();
            }),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            SizedBox(
              height: 35,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: statusList.length,
                itemBuilder: (context, index) {
                  return TaxiOrderButtonWidget(
                    statusListModel: statusList[index], index: index, tripController: tripController, titleLength: statusList.length,
                    fromHistory: true,
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(
              child: tripController.tripsList != null ? tripController.tripsList!.isNotEmpty ? ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
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
              ) : Center(child: Text('no_trip_found'.tr)) : const TripListShimmer(),
            ),

          ]),
        ) : Center(child: Text('you_have_no_permission_to_access_this_feature'.tr, style: robotoMedium));
      }),
    );
  }
}
