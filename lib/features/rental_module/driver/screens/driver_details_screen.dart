import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_switch_button.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/screens/add_driver_screen.dart';
import 'package:sixam_mart_store/features/rental_module/driver/widgets/driver_delete_bottom_sheet.dart';
import 'package:sixam_mart_store/features/rental_module/driver/widgets/status_wise_order_button_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/status_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/trip_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/order_count_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/taxi_order_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class DriverDetailsScreen extends StatefulWidget {
  final Drivers? driver;
  const DriverDetailsScreen({super.key, this.driver});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {

  @override
  void initState() {
    super.initState();
    DriverController driverController = Get.find<DriverController>();

    driverController.getDriverDetails(driverId: widget.driver!.id!);
    driverController.setDriverStatus(widget.driver!.status == 1);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return GetBuilder<DriverController>(builder: (driverController) {
        List<StatusListModel> statusList = StatusListModel.getDriverStatusList();
        List<Trips>? tripsList = [];

        switch (driverController.selectedStatus) {
          case 'confirmed':
            tripsList = driverController.confirmedTrips;
            break;
          case 'ongoing':
            tripsList = driverController.ongoingTrips;
            break;
          case 'completed':
            tripsList = driverController.completedTrips;
            break;
          case 'canceled':
            tripsList = driverController.cancelledTrips;
            break;
          default:
            tripsList = [];
            break;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.95),
            title: Text('driver_details'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).cardColor)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).cardColor,
              onPressed: () => Get.back(),
            ),
            actions: [
              PopupMenuButton(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                menuPadding: const EdgeInsets.all(0),
                icon: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Icon(Icons.more_vert, color: Theme.of(context).cardColor),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'status',
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Status'.tr, style: robotoRegular),
                          trailing: CustomSwitchButton(
                            value: driverController.driverStatus,
                            onChanged: (value) {
                              driverController.updateDriverStatus(driverId: widget.driver!.id!);
                            },
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'edit',
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('edit'.tr, style: robotoRegular),
                          trailing: const CustomAssetImageWidget(Images.editIcon, height: 20, width: 20),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      title: Text('delete'.tr, style: robotoRegular),
                      trailing: const CustomAssetImageWidget(Images.deleteIcon, height: 20, width: 20),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
                onSelected: (value) {
                  if(value == 'edit') {
                    Get.to(() => AddDriverScreen(driver: widget.driver));
                  }else if(value == 'delete') {
                    showCustomBottomSheet(child: DriverDeleteBottomSheet(driverId: widget.driver!.id!));
                  }else {
                    driverController.updateDriverStatus(driverId: widget.driver!.id!);
                  }
                },
              ),
            ],
          ),

          body: driverController.driverDetails != null ? Column(children: [

            Stack(clipBehavior: Clip.none, children: [
              Container(
                height: 140,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).cardColor, width: 1.5),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        image: widget.driver?.imageFullUrl ?? '',
                        height: 60, width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text(
                        '${widget.driver?.firstName ?? ' '} ${widget.driver?.lastName ?? ' '}',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),

                      Text(widget.driver?.phone ?? '', style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withValues(alpha: 0.7))),

                      Text(widget.driver?.email ?? '', style: robotoRegular.copyWith(color: Theme.of(context).cardColor.withValues(alpha: 0.7))),

                    ]),
                  ),

                ]),
              ),

              Positioned(
                right: 20, bottom: -40, left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Row(children: [
                    OrderCountWidget(title: 'total_trip'.tr, count: driverController.driverDetails?.tripsCount, color: Colors.blue),

                    Container(height: 35, width: 0.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.4)),

                    OrderCountWidget(title: 'completed'.tr, count: driverController.driverDetails?.totalTripCompleted, color: Theme.of(context).primaryColor),

                    Container(height: 35, width: 0.5, color: Theme.of(context).disabledColor.withValues(alpha: 0.4)),

                    OrderCountWidget(title: 'canceled'.tr, count: driverController.driverDetails?.totalTripCanceled, color: Theme.of(context).colorScheme.error),
                  ]),
                ),
              ),

            ]),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60, left: Dimensions.paddingSizeLarge,
                  right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
                ),
                child: Column(children: [

                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: statusList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: StatusWiseOrderButtonWidget(
                            statusListModel: statusList[index],
                            index: index,
                            driverController: driverController,
                            titleLength: statusList.length,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Expanded(
                    child: tripsList != null ? tripsList.isNotEmpty ? ListView.builder(
                      itemCount: tripsList.length,
                      itemBuilder: (context, index) {
                        return GetBuilder<TripController>(builder: (tripController) {
                          return InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Get.to(() => TripDetailsScreen(tripId: tripsList![index].id!, tripStatus: tripsList[index].tripStatus));
                            },
                            child: TaxiOrderWidget(
                              index: index,
                              trips: tripsList![index],
                              isExpanded: tripController.expandedIndex == index,
                              fromDriverDetails: true,
                              onToggle: () {
                                tripController.setExpandedIndex(tripController.expandedIndex == index ? null : index);
                              },
                            ),
                          );
                        });
                      },
                    ) : Center(child: Text('no_trip_found'.tr)) : const Center(child: CircularProgressIndicator()),
                  ),

                ]),
              ),
            ),

          ]) : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}
