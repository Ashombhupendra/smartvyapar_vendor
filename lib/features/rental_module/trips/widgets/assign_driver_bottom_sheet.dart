import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AssignDriverBottomSheet extends StatefulWidget {
  final List<VehicleIdentity>? vehicleIdentity;
  final bool isEdit;
  const AssignDriverBottomSheet({super.key, this.vehicleIdentity, this.isEdit = false});

  @override
  State<AssignDriverBottomSheet> createState() => _AssignDriverBottomSheetState();
}

class _AssignDriverBottomSheetState extends State<AssignDriverBottomSheet> {

  @override
  void initState() {
    super.initState();
    DriverController driverController = Get.find<DriverController>();
    TripController tripController = Get.find<TripController>();

    driverController.getDriverList(offset: '1', willUpdate: false, search: '');

    if (widget.isEdit && widget.vehicleIdentity != null) {
      tripController.clearSelectedDriver();
      for (var vehicle in widget.vehicleIdentity!) {
        if (vehicle.vehicleDriverId != null) {
          tripController.updateSelectedDriver(vehicleId: vehicle.id.toString(), driverId: vehicle.vehicleDriverId!);
        }
      }
    } else {
      tripController.clearSelectedDriver();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return GetBuilder<DriverController>(builder: (driverController) {
        return driverController.driversList != null ? driverController.driversList!.isNotEmpty ? Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radiusExtraLarge),
              topRight: Radius.circular(Dimensions.radiusExtraLarge),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

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
              child: Text('assign_driver'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            ),

            Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeDefault),
              child: Text('${widget.vehicleIdentity!.length} ${'vehicle_need_to_assign_driver'.tr}', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
            ),

            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall,
                ),
                shrinkWrap: true,
                itemCount: widget.vehicleIdentity!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 4)],
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Column(children: [

                      Row(children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImageWidget(
                            image: widget.vehicleIdentity?[index].vehicles?.thumbnailFullUrl ?? '',
                            height: 50, width: 70, fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(widget.vehicleIdentity?[index].vehicles?.name ?? '', style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                            Row(children: [
                              Text('${'license'.tr}:', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5))),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Flexible(child: Text(widget.vehicleIdentity?[index].vehicleIdentityData?.licensePlateNumber ?? 'N/A', style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            ]),
                          ]),
                        ),

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      CustomDropdownButton(
                        hintText: 'select_driver'.tr,
                        dropdownMenuItems: driverController.driversList?.map((driver) {
                          final driverName = '${driver.firstName ?? ''} ${driver.lastName ?? ''} (${driver.phone ?? ''})';
                          return DropdownMenuItem<String>(
                            value: driverName,
                            child: Text(driverName, style: robotoRegular),
                          );
                        }).toList(),
                        onChanged: (value) {
                          final vehicleId = widget.vehicleIdentity![index].id.toString();
                          final driver = driverController.driversList?.firstWhere((element) => '${element.firstName} ${element.lastName} (${element.phone})' == value);

                          if (driver != null) {
                            final driverId = driver.id;

                            if (tripController.selectedDriverIds.containsValue(driverId)) {
                              showCustomSnackBar('driver_already_assigned'.tr);
                            } else {
                              tripController.updateSelectedDriver(vehicleId: vehicleId, driverId: driverId!);
                            }
                          }
                        },
                        selectedItemBuilder: (context) {
                          final vehicleId = widget.vehicleIdentity![index].id.toString();
                          final selectedDriverId = tripController.selectedDriverIds[vehicleId];

                          return driverController.driversList?.map((driver) {
                            if (selectedDriverId == driver.id) {
                              return Text(
                                '${driver.firstName ?? ''} ${driver.lastName ?? ''} (${driver.phone ?? ''})',
                                style: robotoRegular,
                              );
                            }
                            return Text('select_driver'.tr, style: robotoRegular.copyWith(color: Colors.grey),);
                          }).toList() ?? [Text('select_driver'.tr, style: robotoRegular.copyWith(color: Colors.grey))];
                        },
                        selectedValue: () {
                          final vehicleId = widget.vehicleIdentity![index].id.toString();
                          final selectedDriverId = tripController.selectedDriverIds[vehicleId];
                          if (selectedDriverId != null) {
                            final selectedDriver = driverController.driversList?.firstWhere((driver) => driver.id == selectedDriverId);
                            if (selectedDriver != null) {
                              return '${selectedDriver.firstName ?? ''} ${selectedDriver.lastName ?? ''} (${selectedDriver.phone ?? ''})';
                            }
                          }
                          return null;
                        }(),
                      ),

                    ]),
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
                      tripController.assignDriver(tripId: widget.vehicleIdentity!.first.tripId!).then((value) {
                        Navigator.pop(Get.context!);
                      });
                    },
                    buttonText: 'add'.tr,
                  ),
                ),

              ]),
            ),

          ]),
        ) : Center(child: Text('no_driver_found'.tr)) : const Center(child: CircularProgressIndicator());
      });
    });
  }
}
