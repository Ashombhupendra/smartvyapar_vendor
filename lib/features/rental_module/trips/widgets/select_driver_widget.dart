import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/assign_driver_bottom_sheet.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class SelectDriverWidget extends StatelessWidget {
  const SelectDriverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {

      bool confirmed = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'confirmed';
      bool ongoing = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'ongoing';

      return Container(
        width: context.width,
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        color: Theme.of(context).cardColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('driver'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            confirmed || ongoing ? InkWell(
              onTap: () {
                showCustomBottomSheet(child: AssignDriverBottomSheet(vehicleIdentity: tripController.tripDetailsModel?.vehicleIdentity!));
              },
              child: Text(
                '+ ${'assign_driver'.tr}',
                style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5), fontSize: Dimensions.fontSizeLarge),
              ),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Container(
            height: 110, width: context.width,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
            child: Column(spacing: Dimensions.paddingSizeSmall, mainAxisAlignment: MainAxisAlignment.center, children: [
              const CustomAssetImageWidget(Images.driverIcon, height: 40, width: 40),

              Text('no_driver_assign_yet'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
            ]),
          ),

        ]),
      );
    });
  }
}
