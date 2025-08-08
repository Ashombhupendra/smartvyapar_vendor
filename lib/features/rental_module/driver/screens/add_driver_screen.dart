import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/helper/custom_validator_helper.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class AddDriverScreen extends StatefulWidget {
  final Drivers? driver;
  const AddDriverScreen({super.key, this.driver});

  @override
  State<AddDriverScreen> createState() => _AddDriverScreenState();
}

class _AddDriverScreenState extends State<AddDriverScreen> {

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _identityNumController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _identityNumFocus = FocusNode();

  String? _countryDialCode;
  late bool _update;
  Drivers? _driver;

  @override
  void initState() {
    super.initState();
    DriverController driverController = Get.find<DriverController>();
    _driver = widget.driver;
    _update = widget.driver != null;
    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;

    driverController.pickImage(isRemove: true);
    driverController.clearIdentityImage();
    if(_update) {
      _fNameController.text = _driver?.firstName ?? '';
      _lNameController.text = _driver?.lastName ?? '';
      _emailController.text = _driver?.email ?? '';
      _phoneController.text = _driver?.phone ?? '';
      _identityNumController.text = _driver?.identityNumber ?? '';
      driverController.setSelectedIdentityInitData(_driver!.identityType);
      if(_driver!.identityImageFullUrl != null && _driver!.identityImageFullUrl!.isNotEmpty) {
        driverController.clearIdentityImage();
        for(String image in _driver!.identityImageFullUrl!) {
          driverController.saveIdentityImages(image);
        }
      }
      _splitPhone(_driver?.phone);
    }else {
      _driver = Drivers();
    }

  }

  void _splitPhone(String? phone) async {
    try {
      if (phone != null && phone.isNotEmpty) {
        PhoneNumber phoneNumber = PhoneNumber.parse(phone);
        _countryDialCode = '+${phoneNumber.countryCode}';
        _phoneController.text = phoneNumber.international.substring(_countryDialCode!.length);
      }
    } catch (e) {
      debugPrint('Phone Number Parse Error: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: _update ? 'update_driver'.tr : 'add_new_driver'.tr),
      body: GetBuilder<DriverController>(builder: (driverController) {
        return Column(children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('driver_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(spacing: Dimensions.paddingSizeExtraLarge, children: [

                    CustomTextFieldWidget(
                      controller: _fNameController,
                      hintText: 'type_first_name'.tr,
                      labelText: 'first_name'.tr,
                      focusNode: _fNameFocus,
                      nextFocus: _lNameFocus,
                    ),

                    CustomTextFieldWidget(
                      controller: _lNameController,
                      hintText: 'type_last_name'.tr,
                      labelText: 'last_name'.tr,
                      focusNode: _lNameFocus,
                      nextFocus: _emailFocus,
                    ),

                    CustomTextFieldWidget(
                      controller: _emailController,
                      hintText: 'type_your_email'.tr,
                      labelText: 'email'.tr,
                      focusNode: _emailFocus,
                      nextFocus: _phoneFocus,
                    ),

                    CustomTextFieldWidget(
                      hintText: 'type_your_phone_number'.tr,
                      labelText: 'phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      nextFocus: _identityNumFocus,
                      inputType: TextInputType.phone,
                      isPhone: true,
                      onCountryChanged: (CountryCode countryCode) {
                        _countryDialCode = countryCode.dialCode;
                      },
                      countryDialCode: _update ? (_countryDialCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code) : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                      required: true,
                      validator: (value) => ValidateCheck.validateEmptyText(value, null),
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('profile_image'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Text('image_format_and_ratio_for_logo'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    Align(alignment: Alignment.center, child: Stack(children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: driverController.profileImage != null ? Image.file(
                          File(driverController.profileImage!.path), height: 130, width: 120, fit: BoxFit.cover,
                        ) : _driver?.imageFullUrl != null ? CustomImageWidget(
                          image: _driver?.imageFullUrl ?? '',
                          height: 130, width: 120, fit: BoxFit.cover,
                        ) : const SizedBox(height: 130, width: 120),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => driverController.pickImage(),
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(Dimensions.radiusDefault),
                            dashPattern: const [8, 4],
                            strokeWidth: 1,
                            color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.2) : const Color(0xFFE5E5E5),
                            child: (driverController.profileImage != null) || (widget.driver?.imageFullUrl != null) ? const SizedBox() : Container(
                              height: 130, width: 120,
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
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('identity_info'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(spacing: Dimensions.paddingSizeExtraLarge, children: [

                    CustomDropdownButton(
                      hintText: 'select_identity_type'.tr,
                      dropdownMenuItems: driverController.identityType.map((item) {
                        return DropdownMenuItem<String>(
                          value: item.value,
                          child: Text(item.value, style: robotoRegular),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        driverController.setSelectedIdentityType(value);
                        String identityTypeKey = driverController.identityType.firstWhere((element) => element.value == value).key;
                        driverController.setSelectedIdentityTypeKey(identityTypeKey);
                      },
                      selectedValue: driverController.selectedIdentityType,
                    ),

                    CustomTextFieldWidget(
                      controller: _identityNumController,
                      hintText: 'type_identity_number'.tr,
                      labelText: 'identity_number'.tr,
                      focusNode: _identityNumFocus,
                      inputAction: TextInputAction.done,
                    ),

                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text('identity_image'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          itemCount: driverController.identityImages.length + 1,
                          itemBuilder: (context, index) {

                            if(index == (driverController.identityImages.length)) {
                              return InkWell(
                                onTap: () {
                                  if((driverController.identityImages.length) < 6) {
                                    driverController.pickVehicleImages();
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

                                      CustomAssetImageWidget(Images.uploadIcon, height: 40, width: 40, color:  Get.isDarkMode ? Colors.grey : null),
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
                              dashPattern: const [8, 4],
                              strokeWidth: 1,
                              color: const Color(0xFFE5E5E5),
                              child: SizedBox(
                                width: 220,
                                child: Stack(children: [

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    child: driverController.identityImages.isNotEmpty ? Image.file(
                                      File(driverController.identityImages[index].path), height: 130, width: 220, fit: BoxFit.cover,
                                    ) : CustomImageWidget(
                                      image: _driver!.identityImageFullUrl?[index] ?? '',
                                      height: 130, width: 220, fit: BoxFit.cover,
                                    ),
                                  ),

                                  Positioned(
                                    right: 0, top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        driverController.removeIdentityImage(index);
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
                        _fNameController.clear();
                        _lNameController.clear();
                        _emailController.clear();
                        _phoneController.clear();
                        _identityNumController.clear();
                        driverController.pickImage(isRemove: true);
                        driverController.setSelectedIdentityType(null);
                        driverController.identityImages.clear();
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
                  isLoading: driverController.isLoading,
                  onPressed: () async {

                    String fName = _fNameController.text.trim();
                    String lName = _lNameController.text.trim();
                    String email = _emailController.text.trim();
                    String phone = _phoneController.text.trim();
                    String identityNumber = _identityNumController.text.trim();

                    String numberWithCountryCode = _countryDialCode!+phone;
                    PhoneValid phoneValid = await CustomValidatorHelper.isPhoneValid(numberWithCountryCode);
                    numberWithCountryCode = phoneValid.phone;

                    if(fName.isEmpty){
                      showCustomSnackBar('enter_driver_first_name'.tr);
                    }else if(lName.isEmpty){
                      showCustomSnackBar('enter_driver_last_name'.tr);
                    }else if(!GetUtils.isEmail(email)) {
                      showCustomSnackBar('enter_a_valid_email_address'.tr);
                    }else if(phone.isEmpty) {
                      showCustomSnackBar('enter_driver_phone_number'.tr);
                    }else if(!phoneValid.isValid) {
                      showCustomSnackBar('enter_a_valid_phone_number'.tr);
                    }else if(!_update && driverController.profileImage == null) {
                      showCustomSnackBar('upload_driver_image'.tr);
                    }else if(driverController.selectedIdentityTypeKey == null) {
                      showCustomSnackBar('select_identity_type'.tr);
                    }else if(identityNumber.isEmpty) {
                      showCustomSnackBar('enter_identity_number'.tr);
                    }else if(!_update && driverController.identityImages.isEmpty) {
                      showCustomSnackBar('upload_identity_image'.tr);
                    }else {

                      _driver?.id = _driver?.id;
                      _driver!.firstName = fName;
                      _driver!.lastName = lName;
                      _driver!.email = email;
                      _driver!.phone = numberWithCountryCode;
                      _driver!.identityType = driverController.selectedIdentityTypeKey;
                      _driver!.identityNumber = identityNumber;

                      driverController.addDriver(driver: _driver!, isUpdate: _update);

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
