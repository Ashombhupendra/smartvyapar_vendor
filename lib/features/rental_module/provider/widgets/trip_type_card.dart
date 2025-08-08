import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TripTypeCard extends StatelessWidget {
  final String tripType;
  final double amount;
  final String fareType;
  final String? tripTypeImage;
  final bool fromEditTrip;
  final TripController? tripController;
  final bool isTripTypeHourly;

  const TripTypeCard({
    super.key,
    required this.tripType,
    required this.amount,
    required this.fareType,
    this.tripTypeImage,
    this.fromEditTrip = false,
    this.tripController,
    this.isTripTypeHourly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
      ),
      child: Column(children: [

        Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, spreadRadius: 0)],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            Text(tripType, style: robotoMedium),

            Image.asset(tripTypeImage!, height: 25, width: 25),

          ]),
        ),

        !fromEditTrip ? Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            fromEditTrip ? Text('start_from'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)) : const SizedBox(),

            Row(mainAxisAlignment: MainAxisAlignment.start, children: [

              Text(
                PriceConverterHelper.convertPrice(amount),
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              Text(fareType, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),

            ]),
          ]),
        ) : const SizedBox(),

      ]),
    );
  }
}