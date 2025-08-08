import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleFilterWidget extends StatefulWidget {
  const VehicleFilterWidget({super.key});

  @override
  State<VehicleFilterWidget> createState() => _VehicleFilterWidgetState();
}

class _VehicleFilterWidgetState extends State<VehicleFilterWidget> {
  @override
  void initState() {
    super.initState();
    final ProviderController providerController = Get.find<ProviderController>();
    providerController.getBrandList(offset: '1', willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProviderController>(builder: (providerController) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(Dimensions.radiusExtraLarge),
            topRight: Radius.circular(Dimensions.radiusExtraLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).disabledColor.withValues(alpha: 0.6)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            Center(
              child: Text(
                'filter_by'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
              ),
            ),

            // Filters
            Flexible(
              child: ListView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                children: [

                  providerController.brandsList != null ? providerController.brandsList!.isNotEmpty ? _buildFilterSection(
                    context,
                    title: 'brands'.tr,
                    options: providerController.brandsList!.map((brand) => brand.name.toString()).toList(),
                    optionsKey: providerController.brandsList!.map((brand) => brand.id.toString()).toList(),
                    selectedOption: providerController.filterSelectedBrand,
                    onSelect: providerController.selectBrand,
                    isImageOption: true,
                    images: providerController.brandsList?.map((brand) => brand.imageFullUrl!).toList(),
                  ) : const SizedBox() : SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Shimmer(
                            direction: const ShimmerDirection.fromLTRB(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              child: Container(
                                height: 60,
                                width: 65,
                                color: Theme.of(context).shadowColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildFilterSection(
                    context,
                    title: 'vehicle_type'.tr,
                    options: providerController.vehicleTypeList.map((vehicleType) => vehicleType.value).toList(),
                    optionsKey: providerController.vehicleTypeList.map((vehicleType) => vehicleType.key).toList(),
                    selectedOption: providerController.filterSelectedVehicleType,
                    onSelect: providerController.selectVehicleType,
                  ),
                  _buildFilterSection(
                    context,
                    title: 'seats'.tr,
                    options: providerController.seatList.map((seat) => '${seat.value} ${'seats'.tr}').toList(),
                    optionsKey: providerController.seatList.map((seat) => seat.key).toList(),
                    selectedOption: providerController.filterSelectedSeat?.toString(),
                    onSelect: providerController.selectSeat,
                  ),
                  _buildFilterSection(
                    context,
                    title: 'cooling'.tr,
                    options: providerController.coolingList.map((cooling) => cooling.value).toList(),
                    optionsKey: providerController.coolingList.map((cooling) => cooling.key).toList(),
                    selectedOption: providerController.filterSelectedCooling,
                    onSelect: providerController.selectCooling,
                  ),
                  _buildFilterSection(
                    context,
                    title: 'transmission_type'.tr,
                    options: providerController.transmissionTypeList.map((transmissionType) => transmissionType.value).toList(),
                    optionsKey: providerController.transmissionTypeList.map((transmissionType) => transmissionType.key).toList(),
                    selectedOption: providerController.filterSelectedTransmissionType,
                    onSelect: providerController.selectTransmissionType,
                  ),
                  _buildFilterSection(
                    context,
                    title: 'fuel_type'.tr,
                    options: providerController.fuelTypeList.map((fuelType) => fuelType.value).toList(),
                    optionsKey: providerController.fuelTypeList.map((fuelType) => fuelType.key).toList(),
                    selectedOption: providerController.filterSelectedFuelType,
                    onSelect: providerController.selectFuelType,
                  ),
                ],
              ),
            ),

            // Apply Filter Button
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
                        providerController.resetFilters();
                      },
                      buttonText: 'reset'.tr,
                      textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                      color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: CustomButtonWidget(
                    onPressed: providerController.isFilterValid() ? providerController.applyFilters : null,
                    buttonText: 'apply_filter'.tr,
                  ),
                ),
              ]),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterSection(
      BuildContext context, {
        required String title,
        required List<String> options,
        required List<String> optionsKey,
        required String? selectedOption,
        required Function(String?) onSelect,
        bool isImageOption = false,
        List<String>? images,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: robotoBold),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        SizedBox(
          height: isImageOption ? 80 : 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final optionKey = optionsKey[index];
              final isSelected = optionKey == selectedOption;
              return InkWell(
                onTap: () => onSelect(isSelected ? null : optionKey),
                child: isImageOption ? Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: CustomImageWidget(
                          image: images?[index] ?? '',
                          height: 60, width: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      child: SizedBox(
                        width: 65,
                        child: Text(
                          option,
                          style: robotoRegular,
                          textAlign: TextAlign.center,
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    if (isSelected) const Positioned(
                      right: 10,
                      top: 0,
                      child: Icon(Icons.check_circle_outline, size: 16),
                    ),

                  ],
                ) : Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        option.tr,
                        style: robotoMedium.copyWith(
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          color: isSelected ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5),
                        ),
                      ),
                    ),

                    if (isSelected) const Positioned(
                      right: 10,
                      top: 0,
                      child: Icon(Icons.check_circle_outline, size: 16),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
      ],
    );
  }
}

