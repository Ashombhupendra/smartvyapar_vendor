import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/assign_driver_bottom_sheet.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AssignDriverWidget extends StatefulWidget {
  const AssignDriverWidget({super.key});

  @override
  State<AssignDriverWidget> createState() => _AssignDriverWidgetState();
}

class _AssignDriverWidgetState extends State<AssignDriverWidget> {
  bool _showAllDrivers = false;
  TripDetailsModel? tripDetails;
  List<DriverData>? driverList;
  int? driverCount;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {

      bool confirmed = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'confirmed';
      bool ongoing = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'ongoing';

      tripDetails = tripController.tripDetailsModel;
      driverList = [];

      if(tripDetails != null){
        for(int i = 0; i < tripDetails!.vehicleIdentity!.length; i++) {
          if(tripDetails!.vehicleIdentity![i].driverData != null) {
            driverList!.add(tripDetails!.vehicleIdentity![i].driverData!);
          }
        }
      }

      driverCount = _showAllDrivers ? driverList!.length : driverList!.length > 2 ? 2 : driverList!.length;

      return Container(
        width: context.width,
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        color: Theme.of(context).cardColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('assigned_driver'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            confirmed || ongoing ? InkWell(
              onTap: () {
                showCustomBottomSheet(child: AssignDriverBottomSheet(vehicleIdentity: tripDetails?.vehicleIdentity, isEdit: true));
              },
              child: Row(children: [
                Text('change'.tr, style: robotoBold.copyWith(color: Theme.of(context).disabledColor)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                CustomAssetImageWidget(Images.editIconOutlined, height: 20, width: 20, color: Theme.of(context).primaryColor),
              ]),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            itemCount: driverCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(children: [
                    ClipOval(
                      child: CustomImageWidget(
                        image: driverList![index].imageFullUrl ?? '',
                        height: 60, width: 60, fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${driverList![index].firstName ?? ''} ${driverList![index].lastName ?? ''}', style: robotoBold),

                        Text(driverList![index].phone ?? '', style: robotoRegular),

                        Row(children: [
                          Text('${'license'.tr}:', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                          Text(
                            tripDetails!.vehicleIdentity![index].vehicleIdentityData!.licensePlateNumber ?? '',
                            style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                          ),
                        ]),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    InkWell(
                      onTap: () async {
                        String phoneNumber = driverList![index].phone ?? '';
                        if (await canLaunchUrlString('tel:$phoneNumber')) {
                          launchUrlString('tel:$phoneNumber', mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar('Error', 'Cannot launch $phoneNumber');
                        }
                      },
                      child: const CustomAssetImageWidget(Images.callIcon, height: 25, width: 25),
                    ),
                  ]),

                  if (index != driverCount! - 1) const Divider(height: Dimensions.paddingSizeExtraOverLarge),
                ],
              );
            },
          ),

          driverList!.length > 2 ? Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAllDrivers = !_showAllDrivers;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                child: Text(
                  _showAllDrivers ? 'see_less'.tr : 'see_more'.tr,
                  style: robotoBold.copyWith(color: Colors.blue),
                ),
              ),
            ),
          ) : const SizedBox(),

        ]),
      );
    });
  }
}
