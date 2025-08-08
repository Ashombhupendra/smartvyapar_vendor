import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_switch_button.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/screens/add_vehicle_screen.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/vehicle_delete_bottom_sheet.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleCardWidget extends StatelessWidget {
  final Vehicles? vehicle;
  const VehicleCardWidget({super.key, this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderController>(builder: (providerController) {
      return Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
        ),
        child: Column(children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(vehicle?.name ?? '', style: robotoMedium, overflow: TextOverflow.ellipsis, maxLines: 1)),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            double.parse(vehicle?.avgRating ?? '0') > 0 ? Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall - 2),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 20),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    double.parse(vehicle?.avgRating ?? '0').toStringAsFixed(1),
                    style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ) : const SizedBox(),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                child: CustomImageWidget(
                  image: vehicle?.thumbnailFullUrl ?? '',
                  height: 145, width: context.width, fit: BoxFit.cover,
                ),
              ),

              vehicle!.discountPrice != 0 ? Positioned(
                top: 10, left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall - 3),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.radiusSmall + 2), bottomRight: Radius.circular(Dimensions.radiusSmall + 2)),
                  ),
                  child: Text(
                    vehicle?.discountType == 'percent' ? '-${vehicle!.discountPrice!.toStringAsFixed(0)}%' : '-${PriceConverterHelper.convertPrice(vehicle!.discountPrice!)} ${'off'.tr}',
                    style: robotoMedium.copyWith(color: Theme.of(context).cardColor),
                  ),
                ),
              ) : const SizedBox(),

              vehicle?.newTag == 1 ? Positioned(
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

            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

            vehicle?.tripHourly == 1 ? Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                vehicle!.discountPrice != 0 ? Text(
                  PriceConverterHelper.convertPrice(
                    vehicle?.discountType == 'percent' ? calculateDiscountPrice(amount: vehicle?.hourlyPrice ?? 0, discountPercentage: vehicle?.discountPrice ?? 0) : vehicle?.discountPrice,
                  ),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                  ),
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                RichText(
                  text: TextSpan(
                    text: PriceConverterHelper.convertPrice(vehicle?.hourlyPrice),
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    children: [
                      TextSpan(text: ' /hr', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall)),
                    ],
                  ),
                ),
              ]),
            ) : const SizedBox(),

            vehicle?.tripDistance == 1 ? Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                vehicle!.discountPrice != 0 ? Text(
                  PriceConverterHelper.convertPrice(
                    vehicle?.discountType == 'percent' ? calculateDiscountPrice(amount: vehicle?.distancePrice ?? 0, discountPercentage: vehicle?.discountPrice ?? 0) : vehicle?.discountPrice,
                  ),
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                  ),
                ) : const SizedBox(),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                RichText(
                  text: TextSpan(
                    text: PriceConverterHelper.convertPrice(vehicle?.distancePrice),
                    style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color),
                    children: [
                      TextSpan(text: ' /km', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeSmall)),
                    ],
                  ),
                ),
              ]),
            ) : const SizedBox(),

            PopupMenuButton(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              menuPadding: const EdgeInsets.all(0),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'status',
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Status'.tr, style: robotoRegular),
                        trailing: CustomSwitchButton(
                          value: vehicle!.status == 1,
                          onChanged: (value) {
                            providerController.updateVehicleActivity(vehicleId: vehicle!.id!);
                          },
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const Divider(height: 1),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'delete',
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('delete'.tr, style: robotoRegular),
                        trailing: const CustomAssetImageWidget(Images.deleteIcon, height: 20, width: 20),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const Divider(height: 1, ),
                    ],
                  ),
                ),

                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    title: Text('edit'.tr, style: robotoRegular),
                    trailing: const CustomAssetImageWidget(Images.editIcon, height: 20, width: 20),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (value) {
                if(value == 'edit') {
                  providerController.getVehicleDetailsWithTrans(vehicleId: vehicle!.id!).then((vehicleDetailsWithTrans) {
                    if(vehicleDetailsWithTrans != null) {
                      Get.to(() => AddVehicleScreen(vehicle: vehicleDetailsWithTrans));
                    }
                  });
                }else if(value == 'delete') {
                  showCustomBottomSheet(child: VehicleDeleteBottomSheet(vehicleId: vehicle!.id!));
                }else {
                  providerController.updateVehicleActivity(vehicleId: vehicle!.id!);
                }
              },
            ),

          ]),
        ]),
      );
    });
  }

  double calculateDiscountPrice({required double amount, required double discountPercentage}) {
    double discount = (amount * discountPercentage) / 100;
    return discount;
  }

}
