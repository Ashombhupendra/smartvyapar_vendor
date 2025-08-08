import 'package:country_code_picker/country_code_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/auth/widgets/store_registartion_success_bottom_sheet.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/helper/validate_check.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/check_app_version.dart';
import '../widgets/otp_login_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkAppVersion(Get.context);

    });
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
    if(Get.find<AuthController>().getUserType() == 'employee'){
      Get.find<AuthController>().changeVendorType(1, isUpdate: false);
    }else{
      Get.find<AuthController>().changeVendorType(0, isUpdate: false);
    }

    _showRegistrationSuccessBottomSheet();
  }

  _showRegistrationSuccessBottomSheet() {
    bool canShowBottomSheet = Get.find<AuthController>().getIsStoreRegistrationSharedPref();
    if(canShowBottomSheet){
      Future.delayed(const Duration(seconds: 1), () {
        showModalBottomSheet(
          context: Get.context!, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (con) => const StoreRegistrationSuccessBottomSheet(),
        ).then((value) {
          Get.find<AuthController>().saveIsStoreRegistrationSharedPref(false);
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: GetBuilder<AuthController>(builder: (authController) {

                return Column(children: [

                  Image.asset(Images.logo, width: 200),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text('sign_in'.tr.toUpperCase(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  const SizedBox(height: 50),

                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(children: [

                      Expanded(
                        child: InkWell(
                          onTap: () => authController.changeVendorType(0),
                          child: Column(children: [

                            Expanded(
                              child: Center(child: Text(
                                'vendor_owner'.tr,
                                style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 0
                                    ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.3)),
                              )),
                            ),

                            Container(
                              height: 2,
                              color: authController.vendorTypeIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                            ),

                          ]),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: () => authController.changeVendorType(1),
                          child: Column(children: [

                            Expanded(
                              child: Center(child: Text(
                                'vendor_employee'.tr,
                                style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 1
                                    ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: 0.3)),
                              )),
                            ),

                            Container(
                              height: 2,
                              color: authController.vendorTypeIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                            ),

                          ]),
                        ),
                      ),

                    ]),
                  ),
                  const SizedBox(height: 50),

                  Form(
                    key: _formKeyLogin,
                    child: Column(children: [

                      // CustomTextFieldWidget(
                      //   labelText: 'Phone Number'.tr,
                      //   hintText: 'Enter Number'.tr,
                      //   // labelText: 'email'.tr,
                      //   // hintText: 'enter_email'.tr,
                      //   controller: _emailController,
                      //   // focusNode: _emailFocus,
                      //   // nextFocus: _passwordFocus,
                      //   inputType: TextInputType.phone,
                      //   prefixImage: Images.call,
                      //
                      //   required: true,
                      //  // validator: (value) => ValidateCheck.validateEmail(value),
                      // ),
                      CustomTextFieldWidget(
                        hintText: 'phone'.tr,
                        controller: _emailController,
                        // focusNode: _phoneFocus,
                        // nextFocus: _passwordFocus,
                        inputType: TextInputType.phone,
                        divider: true,
                        isPhone: true,
                          maxLength: 10,
                          // onCountryChanged: (CountryCode countryCode) {
                        //   countryDialCode = countryCode.dialCode;
                        // },
                        countryDialCode: '+91'//countryDialCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
                      ),
                      // const SizedBox(height: 20),
                      //
                      // CustomTextFieldWidget(
                      //   labelText: 'password'.tr,
                      //   hintText: '8+characters'.tr,
                      //   controller: _passwordController,
                      //   focusNode: _passwordFocus,
                      //   inputAction: TextInputAction.done,
                      //   inputType: TextInputType.visiblePassword,
                      //   prefixIcon: Icons.lock_outline_rounded,
                      //   iconSize: 24,
                      //   isPassword: true,
                      //   onSubmit: (text) => GetPlatform.isWeb ? _login(authController) : null,
                      //   validator: (value) => ValidateCheck.validatePassword(value, null),
                      // ),

                    ]),
                  ),
                  const SizedBox(height: 10),

                  Row(children: [

                    Expanded(
                      child: ListTile(
                        onTap: () => authController.toggleRememberMe(),
                        leading: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: authController.isActiveRememberMe,
                          onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                        ),
                        title: Text('remember_me'.tr),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        horizontalTitleGap: 0,
                      ),
                    ),

                    authController.vendorTypeIndex == 1 ? const SizedBox() : TextButton(
                      onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                      child: Text('${'forgot_password'.tr}?'),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                 Obx((){
                   return  CustomButtonWidget(
                     isLoading: authController.loder1.value,
                     buttonText: 'sign_in'.tr,
                     onPressed: () {
                       _login(authController);
                     },
                   );
                 }),
                  SizedBox(height: Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? Dimensions.paddingSizeSmall : 0),

                  Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 40),
                    ),
                    onPressed: () async {
                      Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                    },
                    child: RichText(text: TextSpan(

                        children: [
                      TextSpan(
                          text: 'Register as a',
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).disabledColor,
                          fontSize: 20
                          )),
                      TextSpan(
                        text: 'Seller',
                        style: robotoMedium.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 15
                        ),
                      ),
                    ])),
                  ) : const SizedBox(),

                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }
  void _login(AuthController authController) async {
    String phone = _emailController.text.trim();
    
    String type = authController.vendorTypeIndex == 0 ? 'owner' : 'employee';

    if (_formKeyLogin!.currentState!.validate()) {
      if (phone.isEmpty) {
        showCustomSnackBar('enter_phone_number'.tr);
      } else if (phone.length < 10) {
        showCustomSnackBar('enter_a_valid_phone_number'.tr);
      } else {
        bool otpSent = await authController.loginOtp(phone);

        if (otpSent) {
          // Show OTP dialog only if OTP was sent successfully
          showDialog(
            context: context,
            builder: (context) {
              String otp = '';

              return AlertDialog(
                title: Text('Enter OTP'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Pinput(
                      length: 6,
                      onChanged: (value) => otp = value,
                      onCompleted: (value) => otp = value,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  Obx(() => Container(
                    height: 50,
                    width: 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        if (otp.length == 6) {
                          authController.loder.value = true;

                          authController
                              .loginOtpVerify(phone, otp, type)
                              .then((status) async {
                            authController.loder.value = false;

                            if (status != null && status.isSuccess) {
                              if (authController.isActiveRememberMe) {
                                authController.saveUserNumberAndPassword(phone, '', type);
                              } else {
                                authController.clearUserNumberAndPassword();
                              }

                              if (authController.getModuleType() == 'rental') {
                                await Get.find<TaxiProfileController>().getProfile();
                              } else {
                                await Get.find<ProfileController>().getProfile();
                              }

                              Get.find<ProfileController>().initTrialWidgetNotShow();
                              Get.offAllNamed(RouteHelper.getInitialRoute());
                            } else {
                              showCustomSnackBar(status?.message ?? 'Something went wrong');
                            }
                          }).catchError((e) {
                            authController.loder.value = false;
                            showCustomSnackBar('Something went wrong: $e');
                            print('Login OTP Verify Error: $e');
                          });
                        } else {
                          Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
                        }
                      },
                      child: authController.loder.value
                          ? Center(child: CircularProgressIndicator(color:  Colors.white,))
                          : Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  )),
                ],
              );
            },
          );
        }
      }
    }
  }


  // void _login(AuthController authController) async {
  //   String email = _emailController.text.trim();
  //   String password = _passwordController.text.trim();
  //   String type = authController.vendorTypeIndex == 0 ? 'owner' : 'employee';
  //
  //   if(_formKeyLogin!.currentState!.validate()) {
  //     if (email.isEmpty) {
  //       showCustomSnackBar('enter_email_address'.tr);
  //     }else if (!GetUtils.isEmail(email)) {
  //       showCustomSnackBar('enter_a_valid_email_address'.tr);
  //     }else if (password.isEmpty) {
  //       showCustomSnackBar('enter_password'.tr);
  //     }else if (password.length < 6) {
  //       showCustomSnackBar('password_should_be'.tr);
  //     }else {
  //       authController.login(email, password, type).then((status) async {
  //         if(status != null){
  //           if (status.isSuccess) {
  //             if (authController.isActiveRememberMe) {
  //               authController.saveUserNumberAndPassword(email, password, type);
  //             } else {
  //               authController.clearUserNumberAndPassword();
  //             }
  //             authController.getModuleType() == 'rental' ?
  //             await Get.find<TaxiProfileController>().getProfile() :
  //             await Get.find<ProfileController>().getProfile();
  //             Get.find<ProfileController>().initTrialWidgetNotShow();
  //             Get.offAllNamed(RouteHelper.getInitialRoute());
  //           }else {
  //             showCustomSnackBar(status.message);
  //           }
  //         }
  //       });
  //     }
  //   }
  // }
}
