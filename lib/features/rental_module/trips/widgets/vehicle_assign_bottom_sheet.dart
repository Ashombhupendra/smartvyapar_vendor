import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleAssignBottomSheet extends StatefulWidget {
  final int vehicleId;
  final int quantity;
  final int tripId;
  final int tripDetailsId;
  final bool isEdit;
  final List<VehicleIdentity>? vehicleIdentity;
  const VehicleAssignBottomSheet({super.key, required this.vehicleId, required this.quantity, required this.tripId,
  required this.tripDetailsId, this.isEdit = false, this.vehicleIdentity});

  @override
  State<VehicleAssignBottomSheet> createState() => _VehicleAssignBottomSheetState();
}

class _VehicleAssignBottomSheetState extends State<VehicleAssignBottomSheet> {

  List<Identities> vehicleIdentities = [];

  @override
  void initState() {
    super.initState();
    ProviderController providerController = Get.find<ProviderController>();
    TripController tripController = Get.find<TripController>();

    providerController.getVehicleDetails(vehicleId: widget.vehicleId).then((_) {
      if (widget.isEdit) {
        vehicleIdentities = providerController.vehicleDetailsModel?.vehicleIdentities ?? [];
        tripController.initializeVehicleLicenseSelection(vehicleIdentities.length, willUpdate: false);
        tripController.initSelectedVehicleLicenseIdList();

        for (int i = 0; i < vehicleIdentities.length; i++) {
          final vehicleIdentity = vehicleIdentities[i];
          if (widget.vehicleIdentity!.any((element) => element.vehicleIdentityId == vehicleIdentity.id)) {
            tripController.toggleVehicleLicenseSelection(i, vehicleIdentity.id!);
          }
        }
      } else {
        vehicleIdentities = providerController.vehicleDetailsModel?.vehicleIdentities ?? [];
        if (vehicleIdentities.isNotEmpty) {
          tripController.initializeVehicleLicenseSelection(vehicleIdentities.length, willUpdate: false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderController>(builder: (providerController) {
      return GetBuilder<TripController>(builder: (tripController) {
        return providerController.vehicleDetailsModel != null ? Container(
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
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeExtraSmall),
              child: Text('assign_licence_number'.tr, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                'assign_the_licence_number_of_the_vehicles_that_you_want_to_send_in_this_trip'.tr,
                style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Row(children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: providerController.vehicleDetailsModel!.thumbnailFullUrl ?? '',
                    height: 70, width: 100, fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(providerController.vehicleDetailsModel!.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Row(children: [
                      Text('${'category'.tr}:', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Flexible(child: Text(providerController.vehicleDetailsModel?.category?.name ?? '', style: robotoRegular, overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ]),

                    Row(children: [
                      Text('${'brand'.tr}:', style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(providerController.vehicleDetailsModel?.brand?.name ?? '', style: robotoRegular),
                    ]),
                  ]),
                ),

              ]),
            ),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
              child: Row(children: [
                Text('vehicles_list'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('(${'${'select_any_of'.tr} ${providerController.vehicleDetailsModel?.vehicleIdentities?.length} ${'vehicles'.tr}'})', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
              ]),
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withValues(alpha: 0.07),
              ),
              child: Row(children: [

                Text('sl'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(
                  child: Text('identity_number'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Text('action'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),

              ]),
            ),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: vehicleIdentities.length,
                itemBuilder: (context, index) {
                  final vehicleIdentity = vehicleIdentities[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeDefault,
                          vertical: Dimensions.paddingSizeSmall,
                        ),
                        child: Row(
                          children: [
                            Text('${index + 1}', style: robotoRegular),
                            const SizedBox(width: Dimensions.paddingSizeLarge),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text('${'vin'.tr}:', style: robotoRegular),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text(vehicleIdentity.vinNumber ?? 'N/A', style: robotoMedium),
                                  ]),
                                  Row(children: [
                                    Text('${'license'.tr}:', style: robotoRegular),
                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                    Text(vehicleIdentity.licensePlateNumber ?? 'N/A', style: robotoMedium),
                                  ]),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),

                            Checkbox(
                              value: tripController.selectedVehicleLicense[index],
                              onChanged: (value) {
                                tripController.toggleVehicleLicenseSelection(index, vehicleIdentity.id!);
                              },
                              activeColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Theme.of(context).disabledColor),
                            ),
                          ],
                        ),
                      ),
                      index == vehicleIdentities.length - 1 ? const SizedBox() : const Divider(),
                    ],
                  );
                },
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
                        Navigator.pop(context);
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
                    isLoading: tripController.isLoading,
                    onPressed: () {
                      if(tripController.selectedVehicleLicenseIdList.isEmpty){
                        showCustomSnackBar('please_select_at_least_one_vehicle'.tr);
                      }else if(tripController.selectedVehicleLicenseIdList.length > widget.quantity){
                        showCustomSnackBar('${'you_can_not_select_more_than'.tr} ${widget.quantity} ${'vehicles'.tr}');
                      }else{
                        tripController.assignVehicle(
                          tripId: widget.tripId,
                          tripDetailsId: widget.tripDetailsId,
                          vehicleId: widget.vehicleId,
                        ).then((value) {
                          Navigator.pop(Get.context!);
                        });
                      }
                    },
                    buttonText: 'add'.tr,
                  ),
                ),

              ]),
            ),

          ]),
        ) : const Center(child: CircularProgressIndicator());
      });
    });
  }
}
