import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ConfirmPaymentBottomSheet extends StatelessWidget {
  const ConfirmPaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const SizedBox(width: 40),

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
            ),

            IconButton(
              icon: Icon(Icons.close, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
              onPressed: () => Navigator.pop(context),
            ),
          ]),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(children: [
              const CustomAssetImageWidget(Images.confirmPaymentIcon, height: 60, width: 60),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('payment_received'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'confirm_payment_message'.tr,
                  style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeExtremeLarge),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Expanded(
                  child: CustomButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    buttonText: 'no'.tr,
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                    textColor: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: CustomButtonWidget(
                    isLoading: tripController.isStatusLoading,
                    onPressed: () {
                      tripController.updateTripPaymentStatus(tripId: tripController.tripDetailsModel!.id!, paymentStatus: 'paid').then((value) {
                        Navigator.pop(Get.context!);
                      });
                    },
                    buttonText: 'yes'.tr,
                  ),
                ),

              ]),
            ]),
          ),

        ]),
      );
    });
  }
}
