import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AddVehicleScreen extends StatefulWidget {
  final Vehicles? vehicle;
  const AddVehicleScreen({super.key, this.vehicle});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> with TickerProviderStateMixin {

  final List<TextEditingController> _vehicleNameControllerList = [];
  final List<TextEditingController> _vehicleDescriptionControllerList = [];
  final TextEditingController _hourlyPriceController = TextEditingController();
  final TextEditingController _distancePriceController = TextEditingController();
  final TextEditingController _discountPriceController = TextEditingController();
  final TextEditingController _settingCapacityController = TextEditingController();
  final TextEditingController _engineCapacityController = TextEditingController();
  final TextEditingController _enginePowerController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final List<FocusNode> _vehicleNameFocusList = [];
  final List<FocusNode> _vehicleDescriptionFocusList = [];
  final FocusNode _hourlyPriceFocus = FocusNode();
  final FocusNode _distancePriceFocus = FocusNode();
  final FocusNode _settingCapacityFocus = FocusNode();
  final FocusNode _engineCapacityFocus = FocusNode();
  final FocusNode _enginePowerFocus = FocusNode();


  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;

  TabController? _tabController;
  final List<Tab> _tabs = [];

  late bool _update;
  Vehicles? _vehicle;

  @override
  void initState() {
    super.initState();
    ProviderController providerController = Get.find<ProviderController>();
    _update = widget.vehicle != null;
    _vehicle = widget.vehicle;

    _callApi().then((value) {
      if(_update){
        Future.delayed(const Duration(milliseconds: 500), () {
          providerController.initVehicleData(vehicle: widget.vehicle);
        });
      }else {
        providerController.resetVehicleData(willUpdate: false);
      }
    });

    _tabController = TabController(length: _languageList!.length, vsync: this);
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _vehicleNameControllerList.add(TextEditingController());
      _vehicleDescriptionControllerList.add(TextEditingController());
      _vehicleNameFocusList.add(FocusNode());
      _vehicleDescriptionFocusList.add(FocusNode());
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    if(_update) {
      for(int index = 0; index<_languageList.length; index++) {
        _vehicleNameControllerList.add(TextEditingController(
          text: _vehicle!.translations![_vehicle!.translations!.length-2].value,
        ));
        _vehicleDescriptionControllerList.add(TextEditingController(
          text: _vehicle!.translations![_vehicle!.translations!.length-1].value,
        ));
        _vehicleNameFocusList.add(FocusNode());
        _vehicleDescriptionFocusList.add(FocusNode());
        for (var translation in widget.vehicle!.translations!) {
          if(_languageList[index].key == translation.locale && translation.key == 'name') {
            _vehicleNameControllerList[index] = TextEditingController(text: translation.value);
          }else if(_languageList[index].key == translation.locale && translation.key == 'description') {
            _vehicleDescriptionControllerList[index] = TextEditingController(text: translation.value);
          }
        }
      }
    }else {
      for (var language in _languageList) {
        if (kDebugMode) {
          print(language);
        }
        _vehicleNameControllerList.add(TextEditingController());
        _vehicleDescriptionControllerList.add(TextEditingController());
        _vehicleNameFocusList.add(FocusNode());
        _vehicleDescriptionFocusList.add(FocusNode());
      }
      _vehicle = Vehicles();
    }

    if(_update) {
      if(_vehicle?.tag != null && _vehicle!.tag!.isNotEmpty){
        providerController.clearTags();
        for (var tag in _vehicle!.tag!) {
          providerController.setTag(tag, isUpdate: false);
        }
      }
      if(_vehicle!.imagesFullUrl != null && _vehicle!.imagesFullUrl!.isNotEmpty) {
        providerController.clearVehicleImage();
        for(String image in _vehicle!.imagesFullUrl!) {
          providerController.saveVehicleImage(image);
        }
      }
      if(_vehicle!.documentsFullUrl != null && _vehicle!.documentsFullUrl!.isNotEmpty) {
        providerController.clearLicenseFile();
        for(String file in _vehicle!.documentsFullUrl!) {
          providerController.saveLicenseFile(file);
        }
      }
      _hourlyPriceController.text = _vehicle!.hourlyPrice.toString();
      _distancePriceController.text = _vehicle!.distancePrice.toString();
      _discountPriceController.text = _vehicle!.discountPrice.toString();
      _settingCapacityController.text = _vehicle!.seatingCapacity ?? '';
      _engineCapacityController.text = _vehicle!.engineCapacity ?? '';
      _enginePowerController.text = _vehicle!.enginePower ?? '';
    }

  }

  Future<void> _callApi() async {
    ProviderController providerController = Get.find<ProviderController>();
    if(providerController.brandsList == null) {
      await providerController.getBrandList(offset: '1', willUpdate: false);
    }
    if(providerController.categoriesList == null) {
      await providerController.getCategoryList(offset: '1', willUpdate: false);
    }
  }

  /*void _validateDiscount() {
    ProviderController providerController = Get.find<ProviderController>();
    double hourlyRate = double.parse(_vehicle!.hourlyPrice.toString());
    double distanceRate = double.parse(_vehicle!.distancePrice.toString());
    double discountPrice = double.parse(_discountPriceController.text == '' ? '0' : _discountPriceController.text);

    if (providerController.discountType == '%') {
      if (discountPrice > 100) {
        showCustomSnackBar('discount_percentage_should_be_less_than_100'.tr);
        _discountPriceController.text = '0';
        return;
      }
    }

    if (providerController.isTripTypeHourly && !providerController.isTripTypeDistanceWise) {
      // Validate only for hourly type
      if (discountPrice > hourlyRate) {
        showCustomSnackBar('discount_cannot_exceed_hourly_rate'.tr);
        _discountPriceController.text = '0';
      }
    } else if (!providerController.isTripTypeHourly && providerController.isTripTypeDistanceWise) {
      // Validate only for distance type
      if (discountPrice > distanceRate) {
        showCustomSnackBar('discount_cannot_exceed_distance_rate'.tr);
        _discountPriceController.text = '0';
      }
    } else if (providerController.isTripTypeHourly && providerController.isTripTypeDistanceWise) {
      // Both types are active, compare rates
      double cheaperRate = hourlyRate < distanceRate ? hourlyRate : distanceRate;
      if (discountPrice > cheaperRate) {
        showCustomSnackBar('discount_cannot_exceed_cheaper_rate'.tr);
        _discountPriceController.text = '0';
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: _update ? 'update_vehicle'.tr : 'add_new_vehicle'.tr),
      body: GetBuilder<ProviderController>(builder: (providerController) {
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('general_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(children: [

                    Padding(
                      padding: const EdgeInsets.only(
                        left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault,
                        top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeDefault,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        SizedBox(
                          height: 40,
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: _tabController,
                            indicatorColor: Theme.of(context).textTheme.bodyLarge?.color,
                            indicatorWeight: 3,
                            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
                            unselectedLabelColor: Theme.of(context).disabledColor,
                            unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                            labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                            labelPadding: const EdgeInsets.only(right: Dimensions.radiusDefault),
                            isScrollable: true,
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            tabs: _tabs,
                            onTap: (int ? value) {
                              setState(() {});
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                          child: Divider(height: 0),
                        ),

                        CustomTextFieldWidget(
                          hintText: 'type_vehicle_name'.tr,
                          labelText: 'name'.tr,
                          controller: _vehicleNameControllerList[_tabController!.index],
                          capitalization: TextCapitalization.words,
                          focusNode: _vehicleNameFocusList[_tabController!.index],
                          nextFocus: _tabController!.index != _languageList!.length-1 ? _vehicleDescriptionFocusList[_tabController!.index] : _vehicleDescriptionFocusList[0],
                          showTitle: false,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          hintText: 'type_vehicle_description'.tr,
                          labelText: 'description'.tr,
                          controller: _vehicleDescriptionControllerList[_tabController!.index],
                          focusNode: _vehicleDescriptionFocusList[_tabController!.index],
                          capitalization: TextCapitalization.sentences,
                          maxLines: 3,
                          inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                          nextFocus: _tabController!.index != _languageList.length-1 ? _vehicleNameFocusList[_tabController!.index + 1] : null,
                          showTitle: false,
                        ),

                      ]),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('images'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('vehicle_thumbnail'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('image_format_and_ratio_for_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Align(alignment: Alignment.center, child: Stack(children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: providerController.vehicleThumbnail != null ? Image.file(
                          File(providerController.vehicleThumbnail!.path), width: 220, height: 130, fit: BoxFit.cover,
                        ) : _vehicle!.thumbnailFullUrl != null ? CustomImageWidget(
                          image: _vehicle!.thumbnailFullUrl ?? '',
                          height: 130, width: 220, fit: BoxFit.cover,
                        ) : const SizedBox(height: 130, width: 220),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => providerController.pickImage(isVehicleThumbnail: true),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                            dashPattern: const [8, 4],
                            strokeWidth: 1,
                            color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                            child: _vehicle!.thumbnailFullUrl != null || providerController.vehicleThumbnail != null ? const SizedBox() : Container(
                              height: 130, width: 220,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                const SizedBox(height: Dimensions.paddingSizeDefault),

                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(text: 'click_to_upload'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
                                    const TextSpan(text: '\n'),
                                    TextSpan(text: 'or_drag_and_drop'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                  ]),
                                ),

                              ]),
                            ),
                          ),
                        ),
                      ),

                    ])),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text('vehicle_images'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('image_format_and_ratio_for_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Center(
                      child: SizedBox(
                        width: 220,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, mainAxisExtent: 130,
                            mainAxisSpacing: 10, crossAxisSpacing: 10,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: providerController.vehicleImages.length + 1,
                          itemBuilder: (context, index) {

                            if(index == (providerController.vehicleImages.length)) {
                              return InkWell(
                                onTap: () {
                                  if((providerController.vehicleImages.length) < 6) {
                                    providerController.pickVehicleImages();
                                  }else {
                                    showCustomSnackBar('maximum_image_limit_is_6'.tr);
                                  }
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(Dimensions.radiusDefault),
                                  dashPattern: const [8, 4],
                                  strokeWidth: 1,
                                  color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                  child: Container(
                                    height: 130, width: 220,
                                    decoration: BoxDecoration(
                                      color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                      CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                      const SizedBox(height: Dimensions.paddingSizeDefault),

                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(children: [
                                          TextSpan(text: 'click_to_upload'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
                                          const TextSpan(text: '\n'),
                                          TextSpan(text: 'or_drag_and_drop'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                        ]),
                                      ),

                                    ]),
                                  ),
                                ),
                              );
                            }
                            return DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(Dimensions.radiusDefault),
                              dashPattern: const [8, 5],
                              strokeWidth: 1,
                              color: const Color(0xFFE5E5E5),
                              child: SizedBox(
                                width: 220,
                                child: Stack(children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    child: providerController.vehicleImages.isNotEmpty ? Image.file(
                                      File(providerController.vehicleImages[index].path), height: 130, width: 220, fit: BoxFit.cover,
                                    ) : CustomImageWidget(
                                      image: _vehicle!.imagesFullUrl?[index] ?? '',
                                      height: 130, width: 220, fit: BoxFit.cover,
                                    ),
                                  ),

                                  Positioned(
                                    right: 0, top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        providerController.removeVehicleImage(index);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ),
                                  ),

                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('pricing_and_discount'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    Stack(clipBehavior: Clip.none, children: [

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Row(children: [

                          Expanded(
                            child: Row(children: [

                              Checkbox(
                                value: providerController.isTripTypeHourly,
                                onChanged: (bool? value) {
                                  providerController.setTripTypeHourly(value!);
                                },
                              ),

                              Text('hourly'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                            ]),
                          ),

                          Expanded(
                            child: Row(children: [

                              Checkbox(
                                value: providerController.isTripTypeDistanceWise,
                                onChanged: (bool? value) {
                                  providerController.setTripTypeDistanceWise(value!);
                                },
                              ),

                              Text('distance_wise'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),

                            ]),
                          ),

                        ]),
                      ),

                      Positioned(
                        left: 10, top: -15,
                        child: Container(
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          padding: const EdgeInsets.all(5),
                          child: Text('trip_type'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                        ),
                      ),

                    ]),
                    SizedBox(height: providerController.isTripTypeHourly || providerController.isTripTypeDistanceWise ? Dimensions.paddingSizeLarge : 0),

                    providerController.isTripTypeHourly ? CustomTextFieldWidget(
                      hintText: 'enter_price'.tr,
                      labelText: '${'hourly_price'.tr} (${Get.find<SplashController>().configModel!.currencySymbol!})',
                      controller: _hourlyPriceController,
                      inputType: TextInputType.number,
                      focusNode: _hourlyPriceFocus,
                      nextFocus: _distancePriceFocus,
                      showTitle: false,
                    ) : const SizedBox(),
                    SizedBox(height: providerController.isTripTypeHourly ? Dimensions.paddingSizeLarge : 0),

                    providerController.isTripTypeDistanceWise ? CustomTextFieldWidget(
                      hintText: 'enter_price'.tr,
                      labelText: '${'distance_wise_price'.tr} (${Get.find<SplashController>().configModel!.currencySymbol!})',
                      controller: _distancePriceController,
                      inputType: TextInputType.number,
                      focusNode: _distancePriceFocus,
                      showTitle: false,
                    ) : const SizedBox(),
                    SizedBox(height: providerController.isTripTypeDistanceWise ? Dimensions.paddingSizeLarge : 0),

                    providerController.isTripTypeHourly || providerController.isTripTypeDistanceWise ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(children: [
                        Expanded(
                          child: TextField(
                            controller: _discountPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              hintText: 'discount'.tr,
                              hintStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                              border: InputBorder.none,
                            ),
                            /*onChanged: (String value) {
                              _validateDiscount();
                            },*/
                          ),
                        ),

                        SizedBox(
                          width: 70,
                          child: CustomDropdownButton(
                            items: ['%', Get.find<SplashController>().configModel!.currencySymbol!],
                            isBorder: false,
                            borderRadius: 0,
                            hintText: '%',
                            backgroundColor: Theme.of(context).disabledColor.withValues(alpha: 0.2),
                            onChanged: (String? value) {
                              providerController.setDiscountType(value!);
                              //_validateDiscount();
                            },
                            selectedValue: providerController.discountTypeKey,
                          ),
                        ),
                      ]),
                    ) : const SizedBox(),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('vehicle_information'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(children: [

                    CustomDropdownButton(
                      hintText: 'brand'.tr,
                      dropdownMenuItems: providerController.brandsList?.map((item) => DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(
                          item.name ?? '', style: robotoRegular,
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        providerController.setSelectedBrand(value!);
                        int? brandId = providerController.brandsList?.firstWhere((element) => element.name == value).id;
                        providerController.setSelectedBrandId(brandId.toString());
                      },
                      selectedValue: providerController.selectedBrand,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomDropdownButton(
                      hintText: 'category'.tr,
                      dropdownMenuItems: providerController.categoriesList?.map((item) => DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(
                          item.name ?? '', style: robotoRegular,
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        providerController.setSelectedCategory(value!);
                        int? categoryId = providerController.categoriesList?.firstWhere((element) => element.name == value).id;
                        providerController.setSelectedCategoryId(categoryId.toString());
                      },
                      selectedValue: providerController.selectedCategory,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomDropdownButton(
                      hintText: 'vehicle_type'.tr,
                      dropdownMenuItems: providerController.vehicleTypeList.map((item) => DropdownMenuItem<String>(
                        value: item.value.tr,
                        child: Text(
                          item.value.tr, style: robotoRegular,
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        providerController.setSelectedVehicleType(value!);
                        String? vehicleTypeKey = providerController.vehicleTypeList.firstWhere((element) => element.value.tr == value).key;
                        providerController.setSelectedVehicleTypeKey(vehicleTypeKey);
                      },
                      selectedValue: providerController.selectedVehicleType,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 'ex_10'.tr,
                      labelText: 'setting_capacity'.tr,
                      controller: _settingCapacityController,
                      inputType: TextInputType.phone,
                      focusNode: _settingCapacityFocus,
                      showTitle: false,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 'ex_10'.tr,
                      labelText: 'engine_capacity_cc'.tr,
                      controller: _engineCapacityController,
                      inputType: TextInputType.phone,
                      focusNode: _engineCapacityFocus,
                      showTitle: false,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 'ex_10'.tr,
                      labelText: 'engine_power_hp'.tr,
                      controller: _enginePowerController,
                      inputType: TextInputType.phone,
                      focusNode: _enginePowerFocus,
                      showTitle: false,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomDropdownButton(
                      hintText: 'fuel_type'.tr,
                      dropdownMenuItems: providerController.fuelTypeList.map((item) => DropdownMenuItem<String>(
                        value: item.value.tr,
                        child: Text(
                          item.value.tr, style: robotoRegular,
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        providerController.setSelectedFuelType(value!);
                        String? fuelTypeKey = providerController.fuelTypeList.firstWhere((element) => element.value.tr == value).key;
                        providerController.setSelectedFuelTypeKey(fuelTypeKey);
                      },
                      selectedValue: providerController.selectedFuelType,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomDropdownButton(
                      hintText: 'transmission_type'.tr,
                      dropdownMenuItems: providerController.transmissionTypeList.map((item) => DropdownMenuItem<String>(
                        value: item.value.tr,
                        child: Text(
                          item.value.tr, style: robotoRegular,
                        ),
                      )).toList(),
                      onChanged: (String? value) {
                        providerController.setSelectedTransmissionType(value!);
                        String? transmissionTypeKey = providerController.transmissionTypeList.firstWhere((element) => element.value.tr == value).key;
                        providerController.setSelectedTransmissionTypeKey(transmissionTypeKey);
                      },
                      selectedValue: providerController.selectedTransmissionType,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Stack(clipBehavior: Clip.none, children: [

                      Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Row(children: [
                              Radio(
                                value: 1,
                                groupValue: providerController.isAc ? 1 : 0,
                                onChanged: (int? value) {
                                  providerController.setAc(value == 1 ? true : false);
                                },
                              ),
                              Text('yes'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            ]),
                          ),
                          Expanded(
                            child: Row(children: [
                              Radio(
                                value: 0,
                                groupValue: providerController.isAc ? 1 : 0,
                                onChanged: (int? value) {
                                  providerController.setAc(value == 1 ? true : false);
                                },
                              ),
                              Text('no'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                            ]),
                          ),
                        ]),
                      ),

                      Positioned(
                        left: 10, top: -15,
                        child: Container(
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          padding: const EdgeInsets.all(5),
                          child: Text('air_condition'.tr, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall)),
                        ),
                      ),

                    ]),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('identity'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                  Row(children: [
                    Text('same_model_multiple_vehicles'.tr, style: robotoRegular),

                    Checkbox(
                      value: providerController.isSameModelMultipleVehicle,
                      onChanged: (bool? value) {
                        providerController.setSameModelMultipleVehicle(value!);
                      },
                    ),
                  ]),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ListView.builder(
                  itemCount: providerController.vinNumberControllerList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(
                            '${'vehicle'.tr} ${index + 1}',
                            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.5)),
                          ),

                          index == 0 ? const SizedBox() : InkWell(
                            onTap: () {
                              providerController.removeIdentity(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                              ),
                              child: Icon(Icons.close, size: 16, color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        CustomTextFieldWidget(
                          hintText: 'enter_vin_number'.tr,
                          labelText: 'vin_number'.tr,
                          controller: providerController.vinNumberControllerList[index],
                          showTitle: false,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),

                        CustomTextFieldWidget(
                          hintText: 'enter_license_plate_number'.tr,
                          labelText: 'license_plate_number'.tr,
                          controller: providerController.licensePlateNumberControllerList[index],
                          showTitle: false,
                        ),

                      ]),
                    );
                  },
                ),

                providerController.isSameModelMultipleVehicle ? InkWell(
                  onTap: () {
                    providerController.addNewIdentity();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('add_new'.tr, style: robotoBold.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6))),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                        ),
                        child: const Icon(Icons.add, size: 20),
                      ),
                    ]),
                  ),
                ) : const SizedBox(),
                SizedBox(height: providerController.isSameModelMultipleVehicle ? Dimensions.paddingSizeLarge : 0),

                Text('tag'.tr, style: robotoBold),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5)],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Row(children: [

                      Expanded(
                        flex: 8,
                        child: CustomTextFieldWidget(
                          hintText: 'tag'.tr,
                          labelText: 'tag'.tr,
                          controller: _tagController,
                          inputAction: TextInputAction.done,
                          onSubmit: (name){
                            if(name != null && name.isNotEmpty) {
                              providerController.setTag(name);
                              _tagController.text = '';
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      Expanded(
                        flex: 2,
                        child: CustomButtonWidget(buttonText: 'add'.tr, onPressed: (){
                          if(_tagController.text != '' && _tagController.text.isNotEmpty) {
                            providerController.setTag(_tagController.text.trim());
                            _tagController.text = '';
                          }
                        }),
                      ),

                    ]),
                    SizedBox(height: providerController.tagList.isNotEmpty ? Dimensions.paddingSizeDefault : 0),

                    providerController.tagList.isNotEmpty ? SizedBox(
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true, scrollDirection: Axis.horizontal,
                        itemCount: providerController.tagList.length,
                        itemBuilder: (context, index){
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: Center(child: Row(children: [
                              Text(providerController.tagList[index]!, style: robotoRegular.copyWith(color: Theme.of(context).disabledColor.withValues(alpha: 0.7))),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              InkWell(onTap: () => providerController.removeTag(index), child: Icon(Icons.clear, size: 18, color: Theme.of(context).disabledColor.withValues(alpha: 0.7))),
                            ])),
                          );
                        },
                      ),
                    ) : const SizedBox(),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('vehicle_other_documents'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('vehicle_license'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('vehicle_doc_format'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    SizedBox(
                      height: 70,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisExtent: 220,
                          mainAxisSpacing: 10, crossAxisSpacing: 10,
                        ),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: providerController.licenseFiles!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == providerController.licenseFiles?.length) {
                            return InkWell(
                              onTap: () {
                                if ((providerController.licenseFiles?.length)! < 6) {
                                  providerController.pickFiles();
                                } else {
                                  showCustomSnackBar('maximum_image_limit_is_6'.tr);
                                }
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(Dimensions.radiusDefault),
                                dashPattern: const [8, 4],
                                strokeWidth: 1,
                                color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                                child: Container(
                                  height: 70,
                                  width: 220,
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                                      const SizedBox(width: Dimensions.paddingSizeSmall),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'click_to_upload'.tr,
                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue),
                                            ),
                                            const TextSpan(text: '\n'),
                                            TextSpan(
                                              text: 'or_drag_and_drop'.tr,
                                              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                            dashPattern: const [8, 4],
                            strokeWidth: 1,
                            color: const Color(0xFFE5E5E5),
                            child: SizedBox(
                              width: 220,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                                    height: 70,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Builder(
                                                builder: (context) {
                                                  final filePath = providerController.licenseFiles![index].paths[0];
                                                  final fileName = filePath!.split('/').last.toLowerCase();

                                                 if (fileName.endsWith('.pdf')) {
                                                    // Show PDF preview
                                                    return Row(
                                                      children: [
                                                        const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            fileName,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 35),
                                                      ],
                                                    );
                                                  } else if (fileName.endsWith('.doc') || fileName.endsWith('.docx')) {
                                                    // Show Word document preview
                                                    return Row(
                                                      children: [
                                                        const Icon(Icons.description, size: 40, color: Colors.blue),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            fileName,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 35),
                                                      ],
                                                    );
                                                  } else {
                                                    // Show generic file preview
                                                    return Row(
                                                      children: [
                                                        const Icon(Icons.insert_drive_file, size: 40, color: Colors.grey),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                          child: Text(
                                                            fileName,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 35),
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        providerController.removeFile(index);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        child: Icon(Icons.delete_forever, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                        },
                      ),
                    ),

                  ]),
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),
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
                    border: _update ? null : Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: CustomButtonWidget(
                    onPressed: () {
                      if(_update) {
                        Get.back();
                      }else{
                        providerController.resetVehicleData();
                        _vehicleNameControllerList[0].text = '';
                        _vehicleDescriptionControllerList[0].text = '';
                        _hourlyPriceController.text = '';
                        _distancePriceController.text = '';
                        _discountPriceController.text = '';
                        _settingCapacityController.text = '';
                        _engineCapacityController.text = '';
                        _enginePowerController.text = '';
                        _tagController.text = '';
                        _tabController!.animateTo(0);
                      }
                    },
                    buttonText: _update ? 'cancel'.tr : 'reset'.tr,
                    textColor: _update ? Theme.of(context).colorScheme.error : Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                    color: _update ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1) : Theme.of(context).disabledColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: CustomButtonWidget(
                  isLoading: providerController.isLoading,
                  onPressed: () {

                    bool defaultLanguageDataNull = false;
                    for(int index=0; index<_languageList.length; index++) {
                      if(_languageList[index].key == 'en') {
                        if (_vehicleNameControllerList[index].text.trim().isEmpty || _vehicleDescriptionControllerList[index].text.trim().isEmpty) {
                          defaultLanguageDataNull = true;
                        }
                        break;
                      }
                    }

                    String? hourlyPrice = _hourlyPriceController.text.trim();
                    String? distancePrice = _distancePriceController.text.trim();
                    String? discountPrice = _discountPriceController.text.trim();
                    String settingCapacity = _settingCapacityController.text.trim();
                    String engineCapacity = _engineCapacityController.text.trim();
                    String enginePower = _enginePowerController.text.trim();


                    if(defaultLanguageDataNull) {
                      showCustomSnackBar('enter_data_for_english'.tr);
                    }else if(_vehicle!.thumbnailFullUrl == null && providerController.vehicleThumbnail == null) {
                      showCustomSnackBar('upload_vehicle_thumbnail_image'.tr);
                    }else if(!_update && providerController.vehicleImages.isEmpty) {
                      showCustomSnackBar('upload_vehicle_images'.tr);
                    }else if(!providerController.isTripTypeHourly && !providerController.isTripTypeDistanceWise) {
                      showCustomSnackBar('select_trip_type'.tr);
                    }else if(providerController.isTripTypeHourly && hourlyPrice.isEmpty) {
                      showCustomSnackBar('enter_hourly_price'.tr);
                    }else if(providerController.isTripTypeHourly && hourlyPrice.isNotEmpty && (hourlyPrice == '0' || hourlyPrice == '0.0')) {
                      showCustomSnackBar('hourly_price_cannot_be_zero'.tr);
                    }else if(providerController.isTripTypeDistanceWise && distancePrice.isEmpty) {
                      showCustomSnackBar('enter_distance_price'.tr);
                    }else if(providerController.isTripTypeDistanceWise && distancePrice.isNotEmpty && (distancePrice == '0' || distancePrice == '0.0')) {
                      showCustomSnackBar('distance_price_cannot_be_zero'.tr);
                    }else if(discountPrice.isEmpty){
                      showCustomSnackBar('enter_discount'.tr);
                    }else if(providerController.discountType == null) {
                      showCustomSnackBar('select_discount_type'.tr);
                    }else if(providerController.selectedBrandId == null) {
                      showCustomSnackBar('select_brand'.tr);
                    }else if(providerController.selectedCategoryId == null) {
                      showCustomSnackBar('select_category'.tr);
                    }else if(providerController.selectedVehicleTypeKey == null) {
                      showCustomSnackBar('select_vehicle_type'.tr);
                    }else if(settingCapacity.isEmpty) {
                      showCustomSnackBar('enter_setting_capacity'.tr);
                    }else if(engineCapacity.isEmpty) {
                      showCustomSnackBar('enter_engine_capacity'.tr);
                    }else if(enginePower.isEmpty) {
                      showCustomSnackBar('enter_engine_power'.tr);
                    }else if(providerController.selectedFuelTypeKey == null) {
                      showCustomSnackBar('select_fuel_type'.tr);
                    }else if(providerController.selectedTransmissionTypeKey == null) {
                      showCustomSnackBar('select_transmission_type'.tr);
                    }else if(!_update && providerController.licenseFiles!.isEmpty) {
                      showCustomSnackBar('upload_vehicle_license'.tr);
                    }else{

                      List<Translation> translations = [];
                      for(int index=0; index<_languageList.length; index++) {
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'name',
                          value: _vehicleNameControllerList[index].text.trim().isNotEmpty ? _vehicleNameControllerList[index].text.trim() : _vehicleNameControllerList[0].text.trim(),
                        ));
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'description',
                          value: _vehicleDescriptionControllerList[index].text.trim().isNotEmpty ? _vehicleDescriptionControllerList[index].text.trim() : _vehicleDescriptionControllerList[0].text.trim(),
                        ));
                      }

                      List<Identities>? identities = [];
                      for(int index = 0; index<providerController.vinNumberControllerList.length; index++) {
                        identities.add(Identities(
                          vinNumber: providerController.vinNumberControllerList[index].text.trim(),
                          licensePlateNumber: providerController.licensePlateNumberControllerList[index].text.trim(),
                        ));
                      }

                      List<String> tags = [];
                      for(int index = 0; index<providerController.tagList.length; index++) {
                        tags.add(providerController.tagList[index]!);
                      }

                      _vehicle?.providerId = Get.find<TaxiProfileController>().profileModel!.stores?[0].id;
                      _vehicle?.translations = [];
                      _vehicle?.translations!.addAll(translations);
                      _vehicle?.tripHourly = providerController.isTripTypeHourly ? 1 : 0;
                      _vehicle?.tripDistance = providerController.isTripTypeDistanceWise ? 1 : 0;
                      _vehicle?.hourlyPrice = double.tryParse(hourlyPrice) ?? 0;
                      _vehicle?.distancePrice = double.tryParse(distancePrice) ?? 0;
                      _vehicle?.discountPrice = double.tryParse(discountPrice) ?? 0;
                      _vehicle?.discountType = providerController.discountType;
                      _vehicle?.brandId = int.parse(providerController.selectedBrandId!);
                      _vehicle?.categoryId = int.parse(providerController.selectedCategoryId!);
                      _vehicle?.type = providerController.selectedVehicleTypeKey;
                      _vehicle?.seatingCapacity = settingCapacity;
                      _vehicle?.engineCapacity = engineCapacity;
                      _vehicle?.enginePower = enginePower;
                      _vehicle?.fuelType = providerController.selectedFuelTypeKey;
                      _vehicle?.transmissionType = providerController.selectedTransmissionTypeKey;
                      _vehicle?.airCondition = providerController.isAc ? 1 : 0;
                      _vehicle?.multipleVehicles = providerController.isSameModelMultipleVehicle ? 1 : 0;
                      _vehicle?.vehicleIdentities = [];
                      _vehicle?.vehicleIdentities!.addAll(identities);
                      _vehicle?.tag = [];
                      _vehicle?.tag!.addAll(tags);

                      providerController.addVehicle(vehicle: _vehicle, isAdd: !_update);
                    }


                  },
                  buttonText: 'submit'.tr,
                ),
              ),

            ]),
          ),

        ]);
      }),
    );
  }
}
