import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_switch_button.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/daily_time_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/pickup_time_input.dart';
import 'package:sixam_mart_store/features/rental_module/provider/widgets/update_pickup_zone_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';

class ProviderSettingScreen extends StatefulWidget {
  final Store provider;
  const ProviderSettingScreen({super.key, required this.provider});

  @override
  State<ProviderSettingScreen> createState() => _ProviderSettingScreenState();
}

class _ProviderSettingScreenState extends State<ProviderSettingScreen> with TickerProviderStateMixin{

  final List<TextEditingController> _providerNameControllerList = [];
  final List<TextEditingController> _providerAddressControllerList = [];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _minTimeController = TextEditingController();
  final TextEditingController _maxTimeController = TextEditingController();

  final List<FocusNode> _providerNameFocusList = [];
  final List<FocusNode> _providerAddressFocusList = [];
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _gstNumberFocus = FocusNode();

  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  final List<Translation>? _translation = Get.find<TaxiProfileController>().profileModel!.translations;
  TabController? _tabController;
  final List<Tab> _tabs = [];
  late Store _provider;

  @override
  void initState() {
    super.initState();

    ProviderController providerController = Get.find<ProviderController>();
    Get.find<AddressController>().getZoneList();
    Get.find<AddressController>().clearPickupZone();

    providerController.initProviderData(provider: widget.provider);

    _tabController = TabController(length: _languageList!.length, vsync: this);
    for (var language in _languageList) {
      if (kDebugMode) {
        print(language);
      }
      _providerNameControllerList.add(TextEditingController());
      _providerAddressControllerList.add(TextEditingController());
      _providerNameFocusList.add(FocusNode());
      _providerAddressFocusList.add(FocusNode());
    }

    for (var language in _languageList) {
      _tabs.add(Tab(text: language.value));
    }

    for(int index = 0; index<_languageList.length; index++) {
      for (var translation in _translation!) {
        if(_languageList[index].key == translation.locale && translation.key == 'name') {
          _providerNameControllerList[index] = TextEditingController(text: translation.value);
        }else if(_languageList[index].key == translation.locale && translation.key == 'address') {
          _providerAddressControllerList[index] = TextEditingController(text: translation.value);
        }
      }
    }

    _phoneController.text = widget.provider.phone ?? '';
    _gstNumberController.text = widget.provider.gstCode ?? '';
    _minTimeController.text = getDeliveryData(widget.provider.deliveryTime!, 'min');
    _maxTimeController.text = getDeliveryData(widget.provider.deliveryTime!, 'max');
    providerController.setSelectedDurationInitData(getDeliveryData(widget.provider.deliveryTime!, 'type'));
    _provider = widget.provider;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'edit_business'.tr,
      ),
      body: GetBuilder<ProviderController>(builder: (providerController) {
        return Column(children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('basic_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
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
                          hintText: 'type_provider_name'.tr,
                          labelText: 'name'.tr,
                          controller: _providerNameControllerList[_tabController!.index],
                          capitalization: TextCapitalization.words,
                          focusNode: _providerNameFocusList[_tabController!.index],
                          nextFocus: _tabController!.index != _languageList!.length-1 ? _providerAddressFocusList[_tabController!.index] : _providerAddressFocusList[0],
                          showTitle: false,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        CustomTextFieldWidget(
                          hintText: 'type_provider_address'.tr,
                          labelText: 'address'.tr,
                          controller: _providerAddressControllerList[_tabController!.index],
                          focusNode: _providerAddressFocusList[_tabController!.index],
                          capitalization: TextCapitalization.sentences,
                          maxLines: 3,
                          inputAction: _tabController!.index != _languageList.length-1 ? TextInputAction.next : TextInputAction.done,
                          nextFocus: _tabController!.index != _languageList.length-1 ? _providerNameFocusList[_tabController!.index + 1] : null,
                          showTitle: false,
                        ),

                      ]),
                    ),

                    const Divider(height: 0),

                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: CustomTextFieldWidget(
                        hintText: 'xxx-xxxxxxx',
                        labelText: 'phone'.tr,
                        controller: _phoneController,
                        inputType: TextInputType.phone,
                        focusNode: _phoneFocus,
                        showTitle: false,
                      ),
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
                    Text('business_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('image_format_and_ratio_for_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Align(alignment: Alignment.center, child: Stack(children: [

                      ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: providerController.logo != null ? Image.file(
                            File(providerController.logo!.path), width: 120, height: 130, fit: BoxFit.cover,
                          ) : CustomImageWidget(
                            image: widget.provider.logoFullUrl ?? '',
                            height: 130, width: 120, fit: BoxFit.cover,
                          )
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => providerController.pickImage(isLogo: true),
                          child: DottedBorder(
                            options: RectDottedBorderOptions(
                              //borderType: BorderType.RRect,
                              //radius: const Radius.circular(Dimensions.radiusDefault),
                              dashPattern: const [8, 4],
                              strokeWidth: 1,
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                            ),
                            child: (providerController.logo != null) || (widget.provider.logoFullUrl != null) ? const SizedBox() : Container(
                              height: 130, width: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E5E5),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                const CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40),
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

                    Text('cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                    Text('image_format_and_ratio_for_cover'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Align(alignment: Alignment.center, child: Stack(children: [

                      ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: providerController.cover != null ? Image.file(
                            File(providerController.cover!.path), width: 220, height: 130, fit: BoxFit.cover,
                          ) : CustomImageWidget(
                            image: widget.provider.coverPhotoFullUrl ?? '',
                            height: 130, width: 220, fit: BoxFit.cover,
                          )
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => providerController.pickImage(),
                          child: DottedBorder(
                            options: RectDottedBorderOptions(
                              //borderType: BorderType.RRect,
                              //radius: const Radius.circular(Dimensions.radiusDefault),
                              dashPattern: const [8, 4],
                              strokeWidth: 1,
                              color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                            ),
                            child: (providerController.cover != null) || (widget.provider.coverPhotoFullUrl != null) ? const SizedBox() : Container(
                              height: 130, width: 220,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE5E5E5),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              ),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                                const CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40),
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
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('basic_setup'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('scheduled_trip'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        Text('when_on_vendor_will_get_scheduled_trip'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      ]),
                    ),

                    CustomSwitchButton(
                      value: providerController.scheduleTripStatus,
                      onChanged: (bool value) {
                        providerController.updateScheduleTripStatus();
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
                  child: Column(children: [
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('gst'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),

                          Text('when_on_vendor_will_get_extra_charge'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                        ]),
                      ),

                      CustomSwitchButton(
                        value: providerController.gstStatus,
                        onChanged: (bool value) {
                          providerController.updateGstStatus();
                        },
                      ),
                    ]),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    CustomTextFieldWidget(
                      hintText: 'xxxx-xxxx-xxx',
                      labelText: 'gst_number'.tr,
                      controller: _gstNumberController,
                      focusNode: _gstNumberFocus,
                      isEnabled: providerController.gstStatus,
                      inputAction: TextInputAction.done,
                      showTitle: false,
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                PickupTimeInput(
                  minTimeController: _minTimeController,
                  maxTimeController: _maxTimeController,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                UpdatePickupZoneWidget(pickupZoneList: widget.provider.pickupZoneId!),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('provider_active_time'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                  ),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return DailyTimeWidget(weekDay: index);
                    },
                  ),
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
                child: CustomButtonWidget(
                  onPressed: () {
                    Get.back();
                  },
                  buttonText: 'cancel'.tr,
                  textColor: Theme.of(context).colorScheme.error,
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
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
                        if (_providerNameControllerList[index].text.trim().isEmpty || _providerAddressControllerList[index].text.trim().isEmpty) {
                          defaultLanguageDataNull = true;
                        }
                        break;
                      }
                    }

                    String phoneNumber = _phoneController.text.trim();
                    String gstNumber = _gstNumberController.text.trim();
                    String minTime = _minTimeController.text.trim();
                    String maxTime = _maxTimeController.text.trim();

                    if(defaultLanguageDataNull) {
                      showCustomSnackBar('enter_provider_name_and_address_for_english'.tr);
                    }else if(phoneNumber.isEmpty) {
                      showCustomSnackBar('enter_phone_number'.tr);
                    }else if(widget.provider.logoFullUrl == null && providerController.logo == null) {
                      showCustomSnackBar('upload_business_logo'.tr);
                    }else if(widget.provider.coverPhotoFullUrl == null && providerController.cover == null) {
                      showCustomSnackBar('upload_cover_image'.tr);
                    }else if(providerController.gstStatus == true && gstNumber.isEmpty) {
                      showCustomSnackBar('enter_gst_number'.tr);
                    }else if(minTime.isEmpty) {
                      showCustomSnackBar('enter_min_time'.tr);
                    }else if(maxTime.isEmpty) {
                      showCustomSnackBar('enter_max_time'.tr);
                    }else if (providerController.selectedDurationKey == null){
                      showCustomSnackBar('select_duration'.tr);
                    }else {

                      List<Translation> translations = [];
                      for(int index=0; index<_languageList.length; index++) {
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'name',
                          value: _providerNameControllerList[index].text.trim().isNotEmpty ? _providerNameControllerList[index].text.trim() : _providerNameControllerList[0].text.trim(),
                        ));
                        translations.add(Translation(
                          locale: _languageList[index].key, key: 'description',
                          value: _providerAddressControllerList[index].text.trim().isNotEmpty ? _providerAddressControllerList[index].text.trim() : _providerAddressControllerList[0].text.trim(),
                        ));
                      }

                      List<String> pickupZoneIdList = [];

                      for(int i = 0; i< Get.find<AddressController>().pickupZoneIdList.length; i++){
                        pickupZoneIdList.add(Get.find<AddressController>().pickupZoneIdList[i].toString());
                      }

                      _provider.translations = [];
                      _provider.translations!.addAll(translations);
                      _provider.phone = phoneNumber;
                      _provider.scheduleOrder = providerController.scheduleTripStatus;
                      _provider.gstStatus = providerController.gstStatus;
                      _provider.gstCode = gstNumber;
                      _provider.pickupZoneId = pickupZoneIdList;

                      providerController.updateProviderBusinessSetup(provider: _provider, minTime: minTime, maxTime: maxTime, timeType: providerController.selectedDurationKey!);

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

  dynamic getDeliveryData(String deliveryTime, String type) {
    RegExp regExp = RegExp(r'(\d+)-(\d+) (hours|days|min)');
    RegExpMatch? match = regExp.firstMatch(deliveryTime);

    if (match != null) {
      switch (type) {
        case 'min':
          return match.group(1)!;
        case 'max':
          return match.group(2)!;
        case 'type':
          return match.group(3)!;
        default:
          throw ArgumentError('Invalid type requested');
      }
    } else {
      throw const FormatException('Invalid delivery time format');
    }
  }

}
