import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_switch_button.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/add_vehicle_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/trip_type_card.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/vehicle_delete_bottom_sheet.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/vehicle_grid_item.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int vehicleId;
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {

  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    ProviderController providerController = Get.find<ProviderController>();

    providerController.getVehicleDetails(vehicleId: widget.vehicleId).then((value) {
      providerController.setVehicleActive(providerController.vehicleDetailsModel!.status == 1);
      providerController.setVehicleNewTag(providerController.vehicleDetailsModel!.newTag == 1);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'vehicle_details'.tr),
      body: GetBuilder<ProviderController>(builder: (providerController) {
        return providerController.vehicleDetailsModel != null ? Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [

                CarouselSlider.builder(
                  itemCount: providerController.vehicleDetailsModel!.imagesFullUrl!.length,
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 180,
                    viewportFraction: 1,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      providerController.setCurrentVehicleImageIndex(index);
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Stack(children: [
                      CustomImageWidget(
                        image: providerController.vehicleDetailsModel?.imagesFullUrl?[index] ?? '',
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),

                      providerController.vehicleNewTag ? Positioned(
                        top: 10, right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall - 3),
                          decoration: const BoxDecoration(
                            color: Color(0xffF88C20),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusSmall + 2), bottomLeft: Radius.circular(Dimensions.radiusSmall + 2)),
                          ),
                          child: Text('newly_arrived'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
                        ),
                      ) : const SizedBox(),

                    ]);
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(providerController.vehicleDetailsModel!.imagesFullUrl!.length, (index) {
                    return Container(
                      width: providerController.currentVehicleImageIndex == index ? 8.0 : 5,
                      height: providerController.currentVehicleImageIndex == index ? 8.0 : 5,
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: providerController.currentVehicleImageIndex == index ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      ),
                    );
                  }),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('activity'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        CustomSwitchButton(
                          value: providerController.vehicleActive,
                          isOnOffText: true,
                          onChanged: (bool value) {
                            providerController.updateVehicleActivity(vehicleId: widget.vehicleId);
                          },
                        ),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('new_tag'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        CustomSwitchButton(
                          value: providerController.vehicleNewTag,
                          isOnOffText: true,
                          onChanged: (bool value) {
                            providerController.updateVehicleNewTag(vehicleId: widget.vehicleId);
                          },
                        ),

                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Text(
                          '${providerController.vehicleDetailsModel?.brand?.name ?? ''} ' '-' '${providerController.vehicleDetailsModel?.name ?? ''}',
                          style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        ),

                        Text(
                          '${'car_no'.tr}: ${List.generate(providerController.vehicleDetailsModel!.vehicleIdentities!.length, (index) => providerController.vehicleDetailsModel!.vehicleIdentities![index].licensePlateNumber).join(', ')}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault),
                          child: Text(
                            providerController.vehicleDetailsModel?.description ?? '',
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                        ),

                        Row(children: [
                          VehicleGridItem(
                          label: double.parse(providerController.vehicleDetailsModel!.avgRating!).toStringAsFixed(1),
                          assetImage: Images.ratingIcon,
                          ),

                          VehicleGridItem(
                            label: providerController.vehicleDetailsModel?.category?.name ?? '',
                            assetImage: Images.carSideIcon,
                          ),

                          VehicleGridItem(
                            label: '${providerController.vehicleDetailsModel?.seatingCapacity} ${'seats'.tr}',
                            assetImage: Images.setCapacityIcon,
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(children: [
                          VehicleGridItem(
                            label: providerController.vehicleDetailsModel!.airCondition == 1 ? 'ac'.tr : 'non_ac'.tr,
                            assetImage: Images.acIcon,
                          ),

                          VehicleGridItem(
                            label: providerController.vehicleDetailsModel!.transmissionType?.tr ?? '',
                            assetImage: Images.automaticIcon,
                          ),

                          VehicleGridItem(
                            label: '${providerController.vehicleDetailsModel!.engineCapacity} cc',
                            assetImage: Images.fuelExpenseIcon,
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        Row(children: [

                          VehicleGridItem(
                            label: providerController.vehicleDetailsModel!.fuelType?.tr ?? '',
                            assetImage: Images.fuelIcon,
                          ),

                          VehicleGridItem(
                            label: providerController.vehicleDetailsModel!.enginePower ?? '',
                            assetImage: Images.chargeIcon,
                          ),

                          const Expanded(child: SizedBox()),
                        ]),

                      ]),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
                      child: Text("trip_type".tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      if (providerController.vehicleDetailsModel!.tripHourly == 1 && providerController.vehicleDetailsModel!.tripDistance == 1) ...[
                        Expanded(child: TripTypeCard(
                          tripType: 'hourly'.tr,
                          amount: providerController.vehicleDetailsModel!.hourlyPrice!,
                          fareType: ' /hr',
                          tripTypeImage: Images.hourlyIcon,
                        )),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(child: TripTypeCard(
                          tripType: 'distance_wise'.tr,
                          amount: providerController.vehicleDetailsModel!.distancePrice!,
                          fareType: ' /km',
                          tripTypeImage: Images.distanceIcon,
                        )),
                      ] else if (providerController.vehicleDetailsModel!.tripHourly == 1) ...[
                        Expanded(flex: 5, child: TripTypeCard(
                          tripType: 'hourly'.tr,
                          amount: providerController.vehicleDetailsModel!.hourlyPrice!,
                          fareType: ' /hr',
                          tripTypeImage: Images.hourlyIcon,
                        )),
                        const Expanded(flex: 5, child: SizedBox()),
                      ] else if (providerController.vehicleDetailsModel!.tripDistance == 1) ...[
                        Expanded(flex: 5, child: TripTypeCard(
                          tripType: 'distance_wise'.tr,
                          amount: providerController.vehicleDetailsModel!.distancePrice!,
                          fareType: ' /km',
                          tripTypeImage: Images.distanceIcon,
                        )),
                        const Expanded(flex: 5, child: SizedBox()),
                      ],
                    ]),
                  ]),
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
                      showCustomBottomSheet(child: VehicleDeleteBottomSheet(vehicleId: widget.vehicleId, fromDetails: true));
                    },
                    buttonText: 'delete'.tr,
                    textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomButtonWidget(
                  onPressed: () {
                    providerController.getVehicleDetailsWithTrans(vehicleId: widget.vehicleId).then((vehicleDetailsWithTrans) {
                      if(vehicleDetailsWithTrans != null) {
                        Get.to(() => AddVehicleScreen(vehicle: vehicleDetailsWithTrans));
                      }
                    });
                  },
                  buttonText: 'edit'.tr,
                ),
              ),

            ]),
          ),
        ]) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
