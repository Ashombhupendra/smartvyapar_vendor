import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/trip_type_card.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/select_location_map_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/time/date_time_picker_sheet.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class EditTripDetailsScreen extends StatefulWidget {
  final TripDetailsModel tripDetails;
  const EditTripDetailsScreen({super.key, required this.tripDetails});

  @override
  State<EditTripDetailsScreen> createState() => _EditTripDetailsScreenState();
}

class _EditTripDetailsScreenState extends State<EditTripDetailsScreen> {

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    tripController.setQuantityAndFairData(tripDetails: widget.tripDetails);
    tripController.tripType = widget.tripDetails.tripType!;
    tripController.tripHour = widget.tripDetails.estimatedHours!;
    tripController.tripDistance = widget.tripDetails.distance!;

    tripController.setTempAddress(addressModel: widget.tripDetails.pickupLocation!, isFrom: true);
    tripController.setTempAddress(addressModel: widget.tripDetails.destinationLocation!, isFrom: false);
    tripController.setFromAddress(widget.tripDetails.pickupLocation!, willUpdate: false);
    tripController.setToAddress(widget.tripDetails.destinationLocation!, willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(
            'edit_trip_details'.tr,
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color),
          ),

          Text(
            '${'trip_id'.tr} #${widget.tripDetails.id}',
            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault ,color: Theme.of(context).disabledColor),
          ),
        ]),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Theme.of(context).textTheme.bodyLarge!.color,
          onPressed: () => Get.back(),
        ),
        backgroundColor: Theme.of(context).cardColor,
        surfaceTintColor: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
        elevation: 2,
      ),

      body: GetBuilder<TripController>(builder: (tripController) {
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  child: SizedBox(
                    height: 200,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      markers: tripController.markers,
                      polygons: tripController.polygons,
                      polylines: Set<Polyline>.of(tripController.polyLines.values),
                      zoomControlsEnabled: false,
                      style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          tripController.fromAddress?.lat ?? tripController.tempFromAddress!.lat!,
                          tripController.fromAddress?.lng ?? tripController.tempFromAddress!.lng!,
                        ),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        tripController.setFromToMarker(
                          controller,
                          from: LatLng(tripController.fromAddress?.lat ?? tripController.tempFromAddress!.lat!, tripController.fromAddress?.lng ?? tripController.tempFromAddress!.lng!),
                          to: LatLng(tripController.toAddress?.lat ?? tripController.tempToAddress!.lat!, tripController.toAddress?.lng ?? tripController.tempToAddress!.lng!),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('trip_location'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                  InkWell(
                    onTap: () {
                      Get.to(()=> SelectLocationMapScreen(
                        pickupLocation: tripController.fromAddress,
                        destinationLocation: tripController.toAddress,
                      ));
                    },
                    child: CustomAssetImageWidget(Images.editIconOutlined, height: 20, width: 20, color: Theme.of(context).primaryColor),
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: SizedBox(
                    height: 88,
                    child: Row(children: [
                      Column(children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Icon(Icons.location_on_sharp, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                        ),

                        Column(
                          children: List.generate(4, (index){
                            return Container(
                              margin: EdgeInsets.only(top: index == 0 ? 0 : 5),
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                              height: 3,
                              width: 1,
                            );
                          }),
                        ),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Transform.rotate(
                            angle: -0.9,
                            child: Icon(Icons.send_rounded, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                          ),
                        ),
                      ]),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              'Home',
                              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                            ),
                            Text(
                              tripController.fromAddress?.locationName ?? '',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                          ]),
                          const SizedBox(height: 30),

                          Text(
                            tripController.toAddress?.locationName ?? '',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ]),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('pickup_time'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Icon(Icons.lock_clock, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          tripController.finalTripDateTime != null ?
                          DateConverterHelper.isSameDate(tripController.finalTripDateTime!) ? 'pickup_now'.tr : 'custom'.tr : 'pick_time'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                        ),

                        Text(
                          tripController.finalTripDateTime != null ? DateConverterHelper.utcToDateTime(DateConverterHelper.formatDate(tripController.finalTripDateTime!)) :
                          widget.tripDetails.scheduleAt != null ? DateConverterHelper.utcToDateTime(widget.tripDetails.scheduleAt!) : 'not_set_yet'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                      ]),
                    ),

                    InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          DateTimePickerSheet(scheduleAt: widget.tripDetails.scheduleAt!),
                          backgroundColor: Colors.transparent, isScrollControlled: true,
                        );
                      },
                      child: CustomAssetImageWidget(Images.editIconOutlined, height: 20, width: 20, color: Theme.of(context).primaryColor),
                    ),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('trip_type'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row( children: [
                  widget.tripDetails.tripType == 'hourly' ? Expanded(child: TripTypeCard(
                    tripType: 'hourly'.tr,
                    amount: 0,
                    fromEditTrip: true,
                    fareType: ' /hr',
                    tripTypeImage: Images.hourlyIcon,
                  )) : Expanded(child: TripTypeCard(
                    tripType: 'distance_wise'.tr,
                    amount: 0,
                    fromEditTrip: true,
                    fareType: ' /km',
                    tripTypeImage: Images.distanceIcon,
                  )),
                  const Expanded(child: SizedBox()),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('selected_vehicle'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ListView.builder(
                  itemCount: widget.tripDetails.tripDetails!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: Theme.of(context).cardColor,
                          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Row(children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              child: CustomImageWidget(
                                image: widget.tripDetails.tripDetails![index].vehicleDetails?.thumbnailFullUrl ?? '',
                                height: 60, width: 60, fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(widget.tripDetails.tripDetails![index].vehicleDetails?.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Text(
                                    PriceConverterHelper.convertPrice(
                                      widget.tripDetails.tripType == 'hourly' ? widget.tripDetails.tripDetails![index].vehicleDetails?.hourlyPrice ?? 0
                                       : widget.tripDetails.tripDetails![index].vehicleDetails?.distancePrice ?? 0,
                                    ),
                                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                  ),

                                  Text(
                                    widget.tripDetails.tripType == 'hourly' ? ' /hr' : ' /km',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                  ),
                                ]),
                              ]),
                            ),

                          ]),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('*${'system_est_fair'.tr}: ', style: robotoRegular),
                              Text(
                                PriceConverterHelper.convertPrice(tripController.systemEstimatedFairCalculation(index)),
                                style: robotoRegular.copyWith( color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Row(children: [

                            Expanded(
                              child: CustomTextFieldWidget(
                                controller: tripController.quantityControllers[index],
                                hintText: 'ex_10'.tr,
                                labelText: 'quantity'.tr,
                                inputType: TextInputType.phone,
                                onChanged: (value) {
                                  if(value.isNotEmpty){
                                    if(tripController.tripDetailsModel!.tripDetails![index].vehicle!.totalVehicleCount! >= int.parse(tripController.quantityControllers[index].text)){
                                      tripController.calculateTripFair(index);
                                    }else{
                                      showCustomSnackBar('${"you_can_not_add_more_than".tr} ${tripController.tripDetailsModel!.tripDetails![index].vehicle!.totalVehicleCount} ${'vehicles'.tr}');
                                      tripController.resetCalculateTripFair(index);
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Expanded(
                              child: CustomTextFieldWidget(
                                controller: tripController.fairControllers[index],
                                hintText: 'ex_10'.tr,
                                labelText: 'fair'.tr,
                                inputType: TextInputType.number,
                                inputAction: TextInputAction.done,
                                isAmount: true,
                              ),
                            ),

                          ]),

                        ]),
                      ),
                    );
                  },
                ),

              ]),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: Row(children: [

              Expanded(
                child: Container(
                  height: 43,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: CustomButtonWidget(
                    onPressed: () {
                      Get.back();
                    },
                    buttonText: 'cancel'.tr,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomButtonWidget(
                  isLoading: tripController.isEditLoading,
                  onPressed: () {
                    if(tripController.quantityControllers.any((element) => element.text.isEmpty)){
                      showCustomSnackBar('please_fill_all_quantity_fields'.tr);
                    }else if(tripController.quantityControllers.any((element) => element.text == '0')){
                      showCustomSnackBar('quantity_can_not_be_zero'.tr);
                    }else if(tripController.fairControllers.any((element) => element.text.isEmpty)){
                      showCustomSnackBar('please_fill_all_fair_fields'.tr);
                    }else if(tripController.fairControllers.any((element) => element.text == '0')){
                      showCustomSnackBar('fair_can_not_be_zero'.tr);
                    }else{
                      tripController.editTripDetails(tripId: widget.tripDetails.id!);
                    }
                  },
                  buttonText: 'update'.tr,
                ),
              ),

            ]),
          ),

        ]);
      }),
    );
  }
}
