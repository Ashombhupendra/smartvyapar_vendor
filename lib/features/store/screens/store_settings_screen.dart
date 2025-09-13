import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/features/store/controllers/store_controller.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/config_model.dart';
import 'package:sixam_mart_store/features/store/domain/models/item_model.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart' as profile;
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/text_field_widget.dart';
import 'package:sixam_mart_store/common/widgets/switch_button_widget.dart';
import 'package:sixam_mart_store/features/store/widgets/daily_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSettingsScreen extends StatefulWidget {
  final profile.Store store;
  const StoreSettingsScreen({super.key, required this.store});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {

  final List<TextEditingController> _nameController = [];
  final TextEditingController _contactController = TextEditingController();
  final List<TextEditingController> _addressController = [];
  final TextEditingController _orderAmountController = TextEditingController();
  final TextEditingController _minimumDeliveryFeeController = TextEditingController();
  final TextEditingController _maximumDeliveryFeeController = TextEditingController();
  final TextEditingController _processingTimeController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _minimumController = TextEditingController();
  final TextEditingController _maximumController = TextEditingController();
  final TextEditingController _deliveryChargePerKmController = TextEditingController();
  final TextEditingController _extraPackagingController = TextEditingController();
  final TextEditingController _minimumStockController = TextEditingController();

  final List<TextEditingController> _metaTitleController = [];
  final List<TextEditingController> _metaDescriptionController = [];
  final List<FocusNode> _nameNode = [];
  final FocusNode _contactNode = FocusNode();
  final List<FocusNode> _addressNode = [];
  final FocusNode _orderAmountNode = FocusNode();
  final FocusNode _minimumDeliveryFeeNode = FocusNode();
  final FocusNode _maximumDeliveryFeeNode = FocusNode();
  final FocusNode _minimumNode = FocusNode();
  final FocusNode _maximumNode = FocusNode();
  final FocusNode _minimumProcessingTimeNode = FocusNode();
  final FocusNode _deliveryChargePerKmNode = FocusNode();
  final FocusNode _minimumStockNode = FocusNode();
  final List<FocusNode> _metaTitleNode = [];
  final List<FocusNode> _metaDescriptionNode = [];
  late profile.Store _store;
  final Module? _module = Get.find<SplashController>().configModel!.moduleConfig!.module;
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  final List<Translation>? translation = Get.find<ProfileController>().profileModel!.translations!;

  @override
  void initState() {
    super.initState();

    Get.find<StoreController>().initStoreData(widget.store);

    for(int index=0; index<_languageList!.length; index++) {

      _nameController.add(TextEditingController());
      _addressController.add(TextEditingController());
      _metaTitleController.add(TextEditingController());
      _metaDescriptionController.add(TextEditingController());
      _nameNode.add(FocusNode());
      _addressNode.add(FocusNode());
      _metaTitleNode.add(FocusNode());
      _metaDescriptionNode.add(FocusNode());

      for (var trans in translation!) {
        if(_languageList[index].key == trans.locale && trans.key == 'name') {
          _nameController[index] = TextEditingController(text: trans.value);
        }else if(_languageList[index].key == trans.locale && trans.key == 'address') {
          _addressController[index] = TextEditingController(text: trans.value);
        }else if (_languageList[index].key == trans.locale && trans.key == 'meta_title') {
          _metaTitleController[index] = TextEditingController(text: trans.value);
        }  else if (_languageList[index].key == trans.locale && trans.key == 'meta_description') {
          _metaDescriptionController[index] = TextEditingController(text: trans.value);

        }
      }
    }

    _contactController.text = widget.store.phone!;
    _orderAmountController.text = widget.store.minimumOrder.toString();
    _minimumDeliveryFeeController.text = widget.store.minimumShippingCharge.toString();
    _maximumDeliveryFeeController.text = widget.store.maximumShippingCharge != null ? widget.store.maximumShippingCharge.toString() : '';
    _deliveryChargePerKmController.text = widget.store.perKmShippingCharge.toString();
    _gstController.text = widget.store.gstCode!;
    _processingTimeController.text = widget.store.orderPlaceToScheduleInterval.toString();
    _extraPackagingController.text = widget.store.extraPackagingAmount.toString();
    _minimumStockController.text = widget.store.minimumStockForWarning.toString();
    if(widget.store.deliveryTime != null && widget.store.deliveryTime!.isNotEmpty) {
      try {
        List<String> typeList = widget.store.deliveryTime!.split(' ');
        List<String> timeList = typeList[0].split('-');
        _minimumController.text = timeList[0];
        _maximumController.text = timeList[1];
        Get.find<StoreController>().setDurationType(Get.find<StoreController>().durations.indexOf(typeList[1]) + 1, false);
      }catch(_) {}
    }
    _store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBarWidget(title: _module!.showRestaurantText! ? 'restaurant_settings'.tr : 'store_settings'.tr),

      body: SafeArea(
        child: GetBuilder<StoreController>(builder: (storeController) {
          return Column(children: [

            Expanded(child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              physics: const BouncingScrollPhysics(),
              child: Column(children: [

                Row(children: [

                  Text(
                    'logo'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                  Text(
                    '(${'max_size_10_mb'.tr})',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).colorScheme.error),
                  ),

                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Align(alignment: Alignment.center, child: Stack(children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: storeController.rawLogo != null ? GetPlatform.isWeb ? Image.network(
                      storeController.rawLogo!.path, width: 150, height: 120, fit: BoxFit.cover,
                    ) : Image.file(
                      File(storeController.rawLogo!.path), width: 150, height: 120, fit: BoxFit.cover,
                    ) : FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      image: '${widget.store.logoFullUrl}',
                      height: 120, width: 150, fit: BoxFit.cover,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 120, width: 150, fit: BoxFit.cover),
                    ),
                  ),

                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => storeController.pickImage(true, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                ])),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                ListView.builder(
                  itemCount: _languageList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      child: TextFieldWidget(
                        hintText: '${_module.showRestaurantText! ? 'restaurant_name'.tr : 'store_name'.tr}  (${_languageList[index].value!})',
                        controller: _nameController[index],
                        focusNode: _nameNode[index],
                        nextFocus: index != _languageList.length-1 ? _nameNode[index+1] : _contactNode,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                      ),
                    );
                  },
                ),

                TextFieldWidget(
                  hintText: 'contact_number'.tr,
                  controller: _contactController,
                  focusNode: _contactNode,
                  nextFocus: _addressNode[0],
                  inputType: TextInputType.phone,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                ListView.builder(
                  itemCount: _languageList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                      child: TextFieldWidget(
                        hintText: '${'address'.tr} (${_languageList[index].value!})',
                        controller: _addressController[index],
                        focusNode: _addressNode[index],
                        nextFocus: index != _languageList.length-1 ? _addressNode[index+1] : _orderAmountNode,
                        inputType: TextInputType.streetAddress,
                      ),
                    );
                  },
                ),

                Row(children: [

                  Expanded(child: TextFieldWidget(
                    hintText: 'minimum_order_amount'.tr,
                    controller: _orderAmountController,
                    focusNode: _orderAmountNode,
                    nextFocus: _store.selfDeliverySystem == 1 ? _deliveryChargePerKmNode : _minimumNode,
                    inputType: TextInputType.number,
                    isAmount: true,
                  )),
                  SizedBox(width: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

                  _store.selfDeliverySystem == 1 ? Expanded(child: TextFieldWidget(
                    hintText: 'delivery_charge_per_km'.tr,
                    controller: _deliveryChargePerKmController,
                    focusNode: _deliveryChargePerKmNode,
                    nextFocus: _minimumDeliveryFeeNode,
                    inputType: TextInputType.number,
                    isAmount: true,
                  )) : const SizedBox(),

                ]),
                SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeLarge : 0),

                _store.selfDeliverySystem == 1 ? Row(children: [

                  Expanded(
                    child: TextFieldWidget(
                    hintText: 'minimum_delivery_charge'.tr,
                    controller: _minimumDeliveryFeeController,
                    focusNode: _minimumDeliveryFeeNode,
                    nextFocus: _maximumDeliveryFeeNode,
                    inputType: TextInputType.number,
                    isAmount: true,
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: TextFieldWidget(
                    hintText: 'maximum_delivery_charge'.tr,
                    controller: _maximumDeliveryFeeController,
                    focusNode: _maximumDeliveryFeeNode,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.number,
                    nextFocus: _minimumNode,
                    isAmount: true,
                    ),
                  ),

                ]) : const SizedBox(),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Align(alignment: Alignment.centerLeft, child: Text(
                  'approximate_delivery_time'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                )),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Row(children: [

                  Expanded(child: TextFieldWidget(
                    hintText: 'minimum'.tr,
                    controller: _minimumController,
                    focusNode: _minimumNode,
                    nextFocus: _maximumNode,
                    inputType: TextInputType.number,
                    isNumber: true,
                    title: false,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: TextFieldWidget(
                    hintText: 'maximum'.tr,
                    controller: _maximumController,
                    focusNode: _maximumNode,
                    inputAction: TextInputAction.done,
                    inputType: TextInputType.number,
                    isNumber: true,
                    title: false,
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: CustomDropDownWidget(
                    value: storeController.durationIndex.toString(), title: null,
                    dataList: storeController.durations, onChanged: (String value) {
                      storeController.setDurationType(int.parse(value), true);
                    },
                  )),

                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                _module.orderPlaceToScheduleInterval! ? TextFieldWidget(
                  hintText: 'minimum_processing_time'.tr,
                  controller: _processingTimeController,
                  focusNode: _minimumProcessingTimeNode,
                  nextFocus: _minimumStockNode,
                  inputType: TextInputType.number,
                  isAmount: true,
                ) : const SizedBox(),
                SizedBox(height: _module.orderPlaceToScheduleInterval! ? Dimensions.paddingSizeLarge : 0),

                !_module.showRestaurantText! ? Column(
                  children: [

                    Row(children: [
                      Text(
                        'minimum_stock_for_warning'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      CustomToolTip(
                        preferredDirection: AxisDirection.up,
                        message: 'minimum_stock_for_warning_tooltip'.tr,
                      ),
                    ]),

                    TextFieldWidget(
                      hintText: 'minimum_stock_for_warning'.tr,
                      controller: _minimumStockController,
                      focusNode: _minimumStockNode,
                      title: false,
                      // nextFocus: _deliveryChargePerKmNode,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.number,
                      isAmount: true,
                    ),
                  ],
                ) : const SizedBox(),
                SizedBox(height: !_module.showRestaurantText! ? Dimensions.paddingSizeLarge : 0),

                ListView.builder(
                  itemCount: _languageList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      child: TextFieldWidget(
                        hintText:  '${'meta_title'.tr}  (${_languageList[index].value!})',
                        controller: _metaTitleController[index],
                        focusNode: _metaTitleNode[index],
                        nextFocus: index != _languageList.length-1 ? _metaTitleNode[index+1] : _metaDescriptionNode[0],
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                      ),
                    );
                  },
                ),

                ListView.builder(
                  itemCount: _languageList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                      child: TextFieldWidget(
                        hintText:  '${'meta_description'.tr}  (${_languageList[index].value!})',
                        controller: _metaDescriptionController[index],
                        focusNode: _metaDescriptionNode[index],
                        nextFocus: index != _languageList.length-1 ? _metaDescriptionNode[index+1] : null,
                        capitalization: TextCapitalization.words,
                        inputType: TextInputType.name,
                      ),
                    );
                  },
                ),

                (_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Align(alignment: Alignment.centerLeft, child: Text(
                  'item_type'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                )) : const SizedBox(),
                (_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Row(children: [

                  Expanded(child: InkWell(
                    onTap: () => storeController.setStoreVeg(!storeController.isStoreVeg!, true),
                    child: Row(children: [

                      Checkbox(
                        value: storeController.isStoreVeg,
                        onChanged: (bool? isActive) => storeController.setStoreVeg(isActive, true),
                        activeColor: Theme.of(context).primaryColor,
                      ),

                      Text('veg'.tr),

                    ]),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: InkWell(
                    onTap: () => storeController.setStoreNonVeg(!storeController.isStoreNonVeg!, true),
                    child: Row(children: [

                      Checkbox(
                        value: storeController.isStoreNonVeg,
                        onChanged: (bool? isActive) => storeController.setStoreNonVeg(isActive, true),
                        activeColor: Theme.of(context).primaryColor,
                      ),

                      Text('non_veg'.tr),

                    ]),
                  )),

                ]) : const SizedBox(),
                SizedBox(height: (_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) ? Dimensions.paddingSizeLarge : 0),

                Row(children: [

                  Expanded(child: Text(
                    'gst'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  )),

                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: storeController.isGstEnabled!,
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      onChanged: (bool isActive) => storeController.toggleGst(),
                    ),
                  ),

                ]),

                TextFieldWidget(
                  hintText: 'gst'.tr,
                  controller: _gstController,
                  inputAction: TextInputAction.done,
                  title: false,
                  isEnabled: storeController.isGstEnabled,
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Row(children: [

                  Expanded(child: Text(
                    'extra_packaging_charge'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  )),

                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: storeController.isExtraPackagingEnabled!,
                      activeTrackColor: Theme.of(context).primaryColor,
                      inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                      onChanged: (bool isActive) => storeController.toggleExtraPackaging(),
                    ),
                  ),

                ]),

                TextFieldWidget(
                  hintText: 'extra_packaging'.tr,
                  controller: _extraPackagingController,
                  inputAction: TextInputAction.done,
                  title: false,
                  isAmount: true,
                  isEnabled: storeController.isExtraPackagingEnabled,
                ),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                _module.alwaysOpen! ? const SizedBox() : Align(alignment: Alignment.centerLeft, child: Text(
                  'daily_schedule_time'.tr,
                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                )),
                SizedBox(height: _module.alwaysOpen! ? 0 : Dimensions.paddingSizeExtraSmall),
                _module.alwaysOpen! ? const SizedBox() : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return DailyTimeWidget(weekDay: index);
                  },
                ),
                SizedBox(height: _module.alwaysOpen! ? 0 : Dimensions.paddingSizeLarge),

                Get.find<SplashController>().configModel!.scheduleOrder! ? SwitchButtonWidget(
                  icon: Icons.alarm_add, title: 'schedule_order'.tr, isButtonActive: storeController.isScheduleOrderEnabled, onTap: () {
                    storeController.toggleScheduleOrder();
                  },
                ) : const SizedBox(),
                SizedBox(height: Get.find<SplashController>().configModel!.scheduleOrder! ? Dimensions.paddingSizeSmall : 0),

                SwitchButtonWidget(icon: Icons.delivery_dining, title: 'delivery'.tr, isButtonActive: storeController.isDeliveryEnabled, onTap: () {
                  storeController.toggleDelivery();
                }),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                widget.store.module!.moduleType.toString() == 'food' ? SwitchButtonWidget(icon: Icons.flatware, title: 'cutlery'.tr, isButtonActive: storeController.isCutleryEnabled, onTap: () {
                  storeController.toggleCutlery();
                }) : const SizedBox(),
                SizedBox(height: widget.store.module!.moduleType.toString() == 'food' ? Dimensions.paddingSizeSmall : 0),

                _store.selfDeliverySystem == 1 ? SwitchButtonWidget(icon: Icons.deblur_outlined, title: 'free_delivery'.tr, isButtonActive: storeController.isFreeDeliveryEnabled, onTap: () {
                  storeController.toggleFreeDelivery();
                }) : const SizedBox(),
                SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

                SwitchButtonWidget(icon: Icons.house_siding, title: 'take_away'.tr, isButtonActive: storeController.isTakeAwayEnabled, onTap: () {
                  storeController.toggleTakeAway();
                }),
                SizedBox(height: widget.store.module!.moduleType.toString() == 'pharmacy' ? Dimensions.paddingSizeSmall : 0),

                (widget.store.module!.moduleType.toString() == 'pharmacy' && Get.find<SplashController>().configModel!.prescriptionOrderStatus!) ? SwitchButtonWidget(
                  icon: Icons.local_hospital_outlined, title: 'prescription_order'.tr, isButtonActive: storeController.isPrescriptionStatusEnable,
                  onTap: () {
                    storeController.togglePrescription();
                  },
                ) : const SizedBox(),

                // SizedBox(height: _store.selfDeliverySystem == 1 ? Dimensions.paddingSizeSmall : 0),

                // SwitchButtonWidget(icon: Icons.house_siding, title: 'take_away'.tr, isButtonActive: widget.store.takeAway, onTap: () {
                //   _store.takeAway = !_store.takeAway!;
                // }),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                Stack(children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: storeController.rawCover != null ? GetPlatform.isWeb ? Image.network(
                      storeController.rawCover!.path, width: context.width, height: 170, fit: BoxFit.cover,
                    ) : Image.file(
                      File(storeController.rawCover!.path), width: context.width, height: 170, fit: BoxFit.cover,
                    ) : FadeInImage.assetNetwork(
                      placeholder: Images.restaurantCover,
                      image: '${widget.store.coverPhotoFullUrl}',
                      height: 170, width: context.width, fit: BoxFit.cover,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 170, width: context.width, fit: BoxFit.cover),
                    ),
                  ),

                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => storeController.pickImage(false, false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),
                ]),

              ]),
            )),

            !storeController.isLoading ? CustomButtonWidget(
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              onPressed: () {
                bool defaultNameNull = false;
                bool defaultAddressNull = false;
                bool defaultMetaTitleNull = false;
                bool defaultMetaDescriptionNull = false;
                for(int index=0; index<_languageList.length; index++) {
                  if(_languageList[index].key == 'en') {
                    if (_nameController[index].text.trim().isEmpty) {
                      defaultNameNull = true;
                    }
                    if(_addressController[index].text.trim().isEmpty){
                      defaultAddressNull = true;
                    }
                    if(_metaTitleController[index].text.trim().isEmpty){
                      defaultMetaTitleNull = true;
                    }
                    if(_metaDescriptionController[index].text.trim().isEmpty){
                      defaultMetaDescriptionNull = true;
                    }
                    break;
                  }
                }

                String contact = _contactController.text.trim();
                String minimumOrder = _orderAmountController.text.trim();
                String deliveryFee = _minimumDeliveryFeeController.text.trim();
                String minimum = _minimumController.text.trim();
                String maximum = _maximumController.text.trim();
                String processingTime = _processingTimeController.text.trim();
                String deliveryChargePerKm = _deliveryChargePerKmController.text.trim();
                String gstCode = _gstController.text.trim();
                String extraPackagingAmount = _extraPackagingController.text.trim();
                String maximumFee = _maximumDeliveryFeeController.text.trim();
                bool? showRestaurantText = _module.showRestaurantText;
                String minimumStockForWarning = _minimumStockController.text.trim();
                if(defaultNameNull) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_your_restaurant_name'.tr : 'enter_your_store_name'.tr);
                }else if(contact.isEmpty) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_contact_number'.tr : 'enter_store_contact_number'.tr);
                }else if(defaultAddressNull) {
                  showCustomSnackBar(showRestaurantText! ? 'enter_restaurant_address'.tr : 'enter_store_address'.tr);
                }else if(minimumOrder.isEmpty) {
                  showCustomSnackBar('enter_minimum_order_amount'.tr);
                }else if(_store.selfDeliverySystem == 1 && deliveryFee.isEmpty && maximumFee.isNotEmpty) {
                  showCustomSnackBar('enter_delivery_fee'.tr);
                }else if(_store.selfDeliverySystem == 1 && deliveryFee.isNotEmpty && maximumFee.isNotEmpty && double.parse(maximumFee) != 0 && (double.parse(deliveryFee) > double.parse(maximumFee))) {
                  showCustomSnackBar('minimum_charge_can_not_be_more_then_maximum_charge'.tr);
                }else if(defaultMetaTitleNull) {
                  showCustomSnackBar('enter_meta_title'.tr);
                }else if(defaultMetaDescriptionNull) {
                  showCustomSnackBar('enter_meta_description'.tr);
                }else if(minimum.isEmpty) {
                  showCustomSnackBar('enter_minimum_delivery_time'.tr);
                }else if(maximum.isEmpty) {
                  showCustomSnackBar('enter_maximum_delivery_time'.tr);
                }else if(deliveryChargePerKm.isEmpty) {
                  showCustomSnackBar('enter_delivery_charge_per_km'.tr);
                }else if(storeController.durationIndex == 0) {
                  showCustomSnackBar('select_delivery_time_type'.tr);
                }else if(_module.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                  showCustomSnackBar('enter_minimum_processing_time'.tr);
                }else if((_module.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!) &&
                    !storeController.isStoreVeg! && !storeController.isStoreNonVeg!){
                  showCustomSnackBar('select_at_least_one_item_type'.tr);
                }else if(_module.orderPlaceToScheduleInterval! && processingTime.isEmpty) {
                  showCustomSnackBar('enter_minimum_processing_time'.tr);
                }else if(storeController.isGstEnabled! && gstCode.isEmpty) {
                  showCustomSnackBar('enter_gst_code'.tr);
                } else if(storeController.isExtraPackagingEnabled! && extraPackagingAmount.isEmpty) {
                  showCustomSnackBar('enter_extra_packaging_amount_more_than_0'.tr);
                }else if(storeController.isExtraPackagingEnabled! && extraPackagingAmount.isNotEmpty && double.parse(extraPackagingAmount) == 0) {
                  showCustomSnackBar('enter_extra_packaging_amount_more_than_0'.tr);
                }else {
                  List<Translation> translation = [];
                  for(int index=0; index<_languageList.length; index++) {
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'name',
                      value: _nameController[index].text.trim().isNotEmpty ? _nameController[index].text.trim()
                          : _nameController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'address',
                      value: _addressController[index].text.trim().isNotEmpty ? _addressController[index].text.trim()
                          : _addressController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_title',
                      value: _metaTitleController[index].text.trim().isNotEmpty ? _metaTitleController[index].text.trim()
                          : _metaTitleController[0].text.trim(),
                    ));
                    translation.add(Translation(
                      locale: _languageList[index].key, key: 'meta_description',
                      value: _metaDescriptionController[index].text.trim().isNotEmpty ? _metaDescriptionController[index].text.trim()
                          : _metaDescriptionController[0].text.trim(),
                    ));
                  }

                  _store.phone = contact;
                  _store.minimumOrder = double.parse(minimumOrder);
                  _store.gstStatus = storeController.isGstEnabled;
                  _store.gstCode = gstCode;
                  _store.orderPlaceToScheduleInterval = _module.orderPlaceToScheduleInterval! ? double.parse(_processingTimeController.text).toInt() : 0;
                  _store.minimumShippingCharge = double.parse(deliveryFee);
                  _store.maximumShippingCharge = maximumFee.isNotEmpty ? double.parse(maximumFee) : null;
                  _store.perKmShippingCharge = double.parse(deliveryChargePerKm);
                  _store.veg = (_module.vegNonVeg! && storeController.isStoreVeg!) ? 1 : 0;
                  _store.nonVeg = (!_module.vegNonVeg! || storeController.isStoreNonVeg!) ? 1 : 0;
                  _store.extraPackagingStatus = storeController.isExtraPackagingEnabled;
                  _store.extraPackagingAmount = extraPackagingAmount.isNotEmpty ? double.parse(extraPackagingAmount) : 0;
                  _store.scheduleOrder = storeController.isScheduleOrderEnabled;
                  _store.delivery = storeController.isDeliveryEnabled;
                  _store.cutlery = storeController.isCutleryEnabled;
                  _store.freeDelivery = storeController.isFreeDeliveryEnabled;
                  _store.takeAway = storeController.isTakeAwayEnabled;
                  _store.prescriptionStatus = storeController.isPrescriptionStatusEnable;
                  _store.minimumStockForWarning = double.parse(minimumStockForWarning);

                  storeController.updateStore(_store, minimum, maximum, storeController.durations[storeController.durationIndex-1], translation);
                }
              },
              buttonText: 'update'.tr,
            ) : const Center(child: CircularProgressIndicator()),

          ]);
        }),
      ),
    );
  }
}
