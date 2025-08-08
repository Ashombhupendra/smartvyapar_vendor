import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/overflow_container_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/vehicle_assign_bottom_sheet.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class SelectVehicleWidget extends StatefulWidget {

  const SelectVehicleWidget({super.key});

  @override
  State<SelectVehicleWidget> createState() => _SelectVehicleWidgetState();
}

class _SelectVehicleWidgetState extends State<SelectVehicleWidget> {

  int listLength = 0;
  bool _isExpanded = false;
  List<TripDetails>? tripDetails = [];
  late List<bool> _isExpandedList;

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    tripDetails = tripController.tripDetailsModel?.tripDetails;
    listLength = tripDetails?.length ?? 0;
    _isExpandedList = List.generate(tripDetails?.length ?? 0, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {

      bool isVehicleDeleted = false;
      if(tripDetails != null){
        for(int i = 0; i < tripDetails!.length; i++) {
          if(tripDetails?[i].vehicle == null) {
            isVehicleDeleted = true;
          }
        }
      }

      List<List<String>> vehicleLicensePlateNumbers = [];
      for (int i = 0; i < listLength; i++) {
        List<String> licensePlates = [];
        for (int j = 0; j < tripController.tripDetailsModel!.vehicleIdentity!.length; j++) {
          if (tripController.tripDetailsModel!.vehicleIdentity![j].vehicles!.id == tripDetails![i].vehicleDetails!.id) {
            String licensePlate = tripController.tripDetailsModel!.vehicleIdentity![j].vehicleIdentityData!.licensePlateNumber ?? '';
            licensePlates.add(licensePlate);
          }
        }
        vehicleLicensePlateNumbers.add(licensePlates);
      }

      bool confirmed = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'confirmed';
      bool ongoing = tripController.tripDetailsModel != null && tripController.tripDetailsModel?.tripStatus == 'ongoing';

      return Container(
        width: context.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        color: Theme.of(context).cardColor,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('selected_vehicle'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            listLength >= 3 ? InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall - 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Theme.of(context).cardColor, size: 20),
              ),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Visibility(
            visible: !_isExpanded && listLength >= 3,
            child: Row(children: [
              Expanded(child: Stack(children: [

                OverFlowContainerWidget(image: tripDetails?[0].vehicleDetails?.thumbnailFullUrl ?? ''),

                listLength > 1 ? Positioned(
                  left: 40, bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color: Theme.of(context).cardColor,),
                    padding: const EdgeInsets.only(left: 1) ,
                    child: OverFlowContainerWidget(image: tripDetails?[1].vehicleDetails?.thumbnailFullUrl ?? ''),
                  ),
                ) : const SizedBox(),

                listLength > 2 ? Positioned(
                  left: 85, bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusDefault), color:Colors.white,),
                    padding: const EdgeInsets.only(left: 1),
                    child: OverFlowContainerWidget(image: tripDetails?[2].vehicleDetails?.thumbnailFullUrl ?? ''),
                  ),
                ) : const SizedBox(),

                listLength > 3 ? Positioned(
                  left: 88, bottom: 2,
                  child: Container(height: 55, width: 55,
                    padding: const EdgeInsets.only(left: 3, bottom: 1),
                    decoration:  BoxDecoration(color: Colors.black.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusDefault),),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        '${listLength > 11 ? '12 +' : listLength - 3} ',
                        style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor),
                      ),
                      Text('+', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).cardColor)),
                    ],
                    ),
                  ),
                ) : const SizedBox()
              ])),

              Expanded(
                child: Text('Total ${listLength > 11 ? '12 +' : listLength} Vehicle\nSelected',
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
              ),

            ]),
          ),

          Visibility(
            visible: _isExpanded || listLength < 3,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listLength,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == listLength - 1 ? 0 : Dimensions.paddingSizeDefault),
                  child: Column(children: [

                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImageWidget(
                          image: tripDetails?[index].vehicleDetails?.thumbnailFullUrl ?? '',
                          height: 60, width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(tripDetails?[index].vehicleDetails?.name ?? '', style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Row(children: [
                            Text('${'quantity'.tr}:', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(tripController.tripDetailsModel!.tripDetails![index].quantity.toString(), style: robotoMedium),
                          ]),
                        ]),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      confirmed || ongoing ? vehicleLicensePlateNumbers[index].isNotEmpty ? InkWell(
                        onTap: () {
                          showCustomBottomSheet(
                            child: VehicleAssignBottomSheet(
                              vehicleId: tripDetails![index].vehicleDetails!.id!,
                              quantity: tripController.tripDetailsModel!.tripDetails![index].quantity!,
                              tripId: tripController.tripDetailsModel!.id!,
                              tripDetailsId: tripDetails![index].id!,
                              isEdit: true,
                              vehicleIdentity: tripController.tripDetailsModel!.vehicleIdentity,
                            ),
                          );
                        },
                        child: const CustomAssetImageWidget(Images.editIconOutlined, height: 25, width: 25),
                      ) : !isVehicleDeleted ? InkWell(
                        onTap: () {
                          showCustomBottomSheet(
                            child: VehicleAssignBottomSheet(
                              vehicleId: tripDetails![index].vehicleDetails!.id!,
                              quantity: tripController.tripDetailsModel!.tripDetails![index].quantity!,
                              tripId: tripController.tripDetailsModel!.id!,
                              tripDetailsId: tripDetails![index].id!,
                            ),
                          );
                        },
                        child: Text(
                          '+ ${'assign_vehicle'.tr}',
                          style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5), fontSize: Dimensions.fontSizeLarge),
                        ),
                      ) : const SizedBox() : const SizedBox(),

                    ]),
                    SizedBox(height: vehicleLicensePlateNumbers[index].isNotEmpty ? Dimensions.paddingSizeDefault : 0),

                    vehicleLicensePlateNumbers[index].isNotEmpty ? Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(
                            child: Text('vehicle_license_number'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isExpandedList[index] = !_isExpandedList[index];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall - 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isExpandedList[index] ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ]),

                        Visibility(
                          visible: _isExpandedList[index],
                          child: Text(
                            vehicleLicensePlateNumbers[index].join(', '),
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ]),
                    ) : const SizedBox(),

                  ]),
                );
              },
            ),
          ),
        ]),
      );
    });
  }
}
