import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sixam_mart_store/features/business/controllers/business_controller.dart';
import 'package:sixam_mart_store/features/business/domain/models/package_model.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/profile/domain/models/profile_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/auth/domain/services/auth_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:http/http.dart' as http;
import 'package:sixam_mart_store/util/helper/v_logger.dart';

enum ImageType {
  logo,
  cover,
  gst,
  aadhar,
  msme,
  pancard,
  fssai,
}

class AuthController extends GetxController implements GetxService {
  final tag="AuthController";
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface}){
    _notification = authServiceInterface.isNotificationActive();
  }
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController panCardrController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _notification = true;
  bool get notification => _notification;

  XFile? _pickedLogo;
  XFile? get pickedLogo => _pickedLogo;

  XFile? _pickedCover;
  XFile? get pickedCover => _pickedCover;

  XFile? _pickGst;
  XFile? get pickedGst => _pickGst;

  XFile? _pickedAadhar;
  XFile? get pickedAadhar => _pickedAadhar;

  XFile? _pickedMsme;
  XFile? get pickedMsme => _pickedMsme;

  XFile? _pickedPancard;
  XFile? get pickedPancard => _pickedPancard;

  XFile? _pickedFssai;
  XFile? get pickedFssai => _pickedFssai;

  final List<String?> _deliveryTimeTypeList = ['minute', 'hours', 'days'];
  List<String?> get deliveryTimeTypeList => _deliveryTimeTypeList;

  int _deliveryTimeTypeIndex = 0;
  int get deliveryTimeTypeIndex => _deliveryTimeTypeIndex;

  int _vendorTypeIndex = 0;
  int get vendorTypeIndex => _vendorTypeIndex;

  bool _lengthCheck = false;
  bool get lengthCheck => _lengthCheck;

  bool _numberCheck = false;
  bool get numberCheck => _numberCheck;

  bool _uppercaseCheck = false;
  bool get uppercaseCheck => _uppercaseCheck;

  bool _lowercaseCheck = false;
  bool get lowercaseCheck => _lowercaseCheck;

  bool _spatialCheck = false;
  bool get spatialCheck => _spatialCheck;

  double _storeStatus = 0.1;
  double get storeStatus => _storeStatus;

  String _storeMinTime = '--';
  String get storeMinTime => _storeMinTime;

  String _storeMaxTime = '--';
  String get storeMaxTime => _storeMaxTime;

  String _storeTimeUnit = 'minute';
  String get storeTimeUnit => _storeTimeUnit;

  bool _showPassView = false;
  bool get showPassView => _showPassView;

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel => _profileModel;

  String? _subscriptionType;
  String? get subscriptionType => _subscriptionType;

  String? _expiredToken;
  String? get expiredToken => _expiredToken;

  bool _notificationLoading = false;
  bool get notificationLoading => _notificationLoading;

  var loder = false.obs;
  var loder1 = false.obs;

  Future<ResponseModel?> login(String? email, String password, String type) async {
    _isLoading = true;
    update();
    Response response = await authServiceInterface.login(email, password, type);
    ResponseModel? responseModel = await authServiceInterface.manageLogin(response, type);
    _isLoading = false;
    update();
    return responseModel;
  }

  void pickImageForReg(ImageType type, bool isRemove, {String? option}) async {
    if(option ==null){
      return;
    }
    if (isRemove) {
      switch (type) {
        case ImageType.logo:
          _pickedLogo = null;
          break;
        case ImageType.cover:
          _pickedCover = null;
          break;
        case ImageType.gst:
          _pickGst = null;
          break;
        case ImageType.aadhar:
          _pickedAadhar = null;
          break;
        case ImageType.msme:
          _pickedMsme = null;
          break;
        case ImageType.pancard:
          _pickedPancard = null;
          break;
        case ImageType.fssai:
          _pickedFssai = null;
          break;
      }
    } else {
      /*Change by yg 12/7/25  for camera option */

      final XFile? picked = await ImagePicker().pickImage(source: option != "camera" ? ImageSource.gallery : ImageSource.camera);
      switch (type) {
        case ImageType.logo:
          _pickedLogo = picked;
          break;
        case ImageType.cover:
          _pickedCover = picked;
          break;
        case ImageType.gst:
          _pickGst = picked;
          break;
        case ImageType.aadhar:
          _pickedAadhar = picked;
          break;
        case ImageType.msme:
          _pickedMsme = picked;
          break;
        case ImageType.pancard:
          _pickedPancard = picked;
          break;
        case ImageType.fssai:
          _pickedFssai = picked;
          break;
      }

      // Get.dialog(
      //   AlertDialog(
      //     title: Text("Select Image"),
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         ListTile(
      //           leading: Icon(Icons.camera_alt),
      //           title: Text("Camera"),
      //           onTap: () async {
      //             Get.back();
      //             final XFile? picked = await ImagePicker().pickImage(source: ImageSource.camera);
      //             _setPickedImage(type, picked);
      //           },
      //         )       ,
      //         ListTile(
      //           leading: Icon(Icons.photo_library),
      //           title: Text("Gallary"),
      //           onTap: () async {
      //             Get.back();
      //             final XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      //             _setPickedImage(type, picked);
      //             },
      //         )
      //       ],
      //     ),
      //     actions: [
      //       TextButton(onPressed: () => Get.back(), child: Text("Cancel"))
      //     ],
      //   )
      // );
    }
    update();
  }


  // void pickImageForReg(bool isLogo, bool isRemove) async {
  //   if(isRemove) {
  //     _pickedLogo = null;
  //     _pickedCover = null;
  //   }else {
  //     if (isLogo) {
  //       _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     } else {
  //       _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     }
  //     update();
  //   }
  // }
void _setPickedImage(ImageType type, XFile?picked){
  switch (type) {
    case ImageType.logo:
      _pickedLogo = picked;
      break;
    case ImageType.cover:
      _pickedCover = picked;
      break;
    case ImageType.gst:
      _pickGst = picked;
      break;
    case ImageType.aadhar:
      _pickedAadhar = picked;
      break;
    case ImageType.msme:
      _pickedMsme = picked;
      break;
    case ImageType.pancard:
      _pickedPancard = picked;
      break;
    case ImageType.fssai:
      _pickedFssai = picked;
      break;
  }
}
  Future<void> updateToken() async {
    await authServiceInterface.updateToken();
  }


  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  void storeStatusChange(double value, {bool isUpdate = true}){
    _storeStatus = value;
    if(isUpdate) {
      update();
    }
  }

  void minTimeChange(String time){
    _storeMinTime = time;
    update();
  }

  void maxTimeChange(String time){
    _storeMaxTime = time;
    update();
  }

  void timeUnitChange(String unit){
    _storeTimeUnit = unit;
    update();
  }

  void changeVendorType(int index, {bool isUpdate = true}){
    _vendorTypeIndex = index;
    if(isUpdate) {
      update();
    }
  }

  Future<bool> clearSharedData() async {
    Get.find<SplashController>().setModule(null, null);
    return await authServiceInterface.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String type) {
    authServiceInterface.saveUserNumberAndPassword(number, password, type);
  }

  String getUserNumber() {
    return authServiceInterface.getUserNumber();
  }
  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }
  String getUserType() {
    return authServiceInterface.getUserType();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authServiceInterface.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  Future<bool> setNotificationActive(bool isActive) async {
    _notificationLoading = true;
    update();
    _notification = isActive;
    await authServiceInterface.setNotificationActive(isActive);
    _notificationLoading = false;
    update();
    return _notification;
  }

  void clearText(){
    aadhaarController.clear();
    panCardrController.clear();
    gstNumberController.clear();
    _pickedFssai = null;
    _pickedPancard = null;
    _pickedMsme = null;
    _pickedAadhar = null;
    _pickGst = null;
  }

  Future<void> toggleStoreClosedStatus() async {
    bool isSuccess = await authServiceInterface.toggleStoreClosedStatus();
    if (isSuccess) {
      if(getModuleType() == 'rental'){
        await Get.find<TaxiProfileController>().getProfile();
      }else{
        Get.find<ProfileController>().getProfile();
      }
    }
    update();
  }

  Future<void> registerStore(Map<String, String> data) async {
    _isLoading = true;
    update();
    print("data pinrt here=>> ${data}");

    Response response = await authServiceInterface.registerRestaurant(data, _pickedLogo, _pickedCover );
     print("response image1=>> ${response.body}");
    if(response.statusCode == 200){
      int? storeId = response.body['store_id'];
      int? packageId = response.body['package_id'];
      print(storeId);
      await postRegistrationData(storeId);
      if(packageId == null) {
        Get.find<BusinessController>().submitBusinessPlan(storeId: storeId!, packageId: null);
      }else{
        Get.toNamed(RouteHelper.getSubscriptionPaymentRoute(storeId: storeId, packageId: packageId));
      }
    }

    _isLoading = false;
    update();
  }

  void setDeliveryTimeTypeIndex(String? type, bool notify) {
    _deliveryTimeTypeIndex = _deliveryTimeTypeList.indexOf(type);
    if(notify) {
      update();
    }
  }

  void showHidePass({bool isUpdate = true}){
    _showPassView = ! _showPassView;
    if(isUpdate) {
      update();
    }
  }

  void validPassCheck(String pass, {bool isUpdate = true}){
    _lengthCheck = false;
    _numberCheck = false;
    _uppercaseCheck = false;
    _lowercaseCheck = false;
    _spatialCheck = false;

    if(pass.length > 7){
      _lengthCheck = true;
    }
    if(pass.contains(RegExp(r'[a-z]'))){
      _lowercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[A-Z]'))){
      _uppercaseCheck = true;
    }
    if(pass.contains(RegExp(r'[ .!@#$&*~^%]'))){
      _spatialCheck = true;
    }
    if(pass.contains(RegExp(r'[\d+]'))){
      _numberCheck = true;
    }
    if(isUpdate) {
      update();
    }
  }

  Future<bool> saveIsStoreRegistrationSharedPref(bool status) async {
    return await authServiceInterface.saveIsStoreRegistration(status);
  }

  bool getIsStoreRegistrationSharedPref() {
    return authServiceInterface.getIsStoreRegistration();
  }

  String _businessPlanStatus = 'business';
  String get businessPlanStatus => _businessPlanStatus;

  int _paymentIndex = 0;
  int get paymentIndex => _paymentIndex;

  int _businessIndex = 0;
  int get businessIndex => _businessIndex;

  int _activeSubscriptionIndex = 0;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  PackageModel? _packageModel;
  PackageModel? get packageModel => _packageModel;

  void changeFirstTimeStatus() {
    _isFirstTime = !_isFirstTime;
  }

  void resetBusiness(){
    _businessIndex = (Get.find<SplashController>().configModel!.commissionBusinessModel == 0) ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    _isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel!.subscriptionFreeTrialStatus! ? 0 : 1;
  }

  Future<void> getPackageList({bool isUpdate = true, int? moduleId}) async {
    _packageModel = await authServiceInterface.getPackageList(moduleId: moduleId);
    if(isUpdate) {
      update();
    }
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }

  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }

  String getModuleType() {
    return authServiceInterface.getModuleType();
  }

  void setModuleType(String type){
    authServiceInterface.setModuleType(type);
  }

  Future<void> postRegistrationData(int? storeID) async {
    var uri = Uri.parse('https://smartvyapaar.com/node-api/store/$storeID/documents');
    var request = http.MultipartRequest('POST', uri);
    request.fields['gst_number'] = gstNumberController.text;
    request.fields['aadhaar_number'] = aadhaarController.text;
    request.fields['pan_number'] = panCardrController.text;
    if (_pickGst != null) {
      request.files.add(await http.MultipartFile.fromPath('gst_image', _pickGst!.path));
    }
    if (_pickedAadhar != null) {
      request.files.add(await http.MultipartFile.fromPath('aadhaar_image', _pickedAadhar!.path));
    }
    if (_pickedMsme != null) {
      request.files.add(await http.MultipartFile.fromPath('msme_image', _pickedMsme!.path));
    }
    if (_pickedPancard != null) {
      request.files.add(await http.MultipartFile.fromPath('pan_image', _pickedPancard!.path));
    }
    if (_pickedFssai != null) {
      request.files.add(await http.MultipartFile.fromPath('fssai_image', _pickedFssai!.path));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        clearText();
        print('Success ✅');
      } else {
        print('Failed ❌');
      }
    } catch (e) {
      print('Error during request: $e');
    }
  }


  Future<bool> loginOtp(String? phone) async {
    print("Sending OTP to =>> $phone");
    loder1.value = true;

    try {
      final response = await http.post(
        Uri.parse('https://smartvyapaar.com/api/v1/auth/vendor/sent_otp_on_phone_number'),
        body: {
          "phone_number": '+91$phone',
          "phone_number_without_extension": "$phone"
        },
      );
      if (response.statusCode == 200) {
        print("response body ----==> ${response.body}");
        final jsonBody = jsonDecode(response.body);
        final message = jsonBody['message'] ?? 'OTP sent successfully';
        final otp=jsonBody['otp']??"";
        // Get.snackbar('Success', "$message otp:$otp", snackPosition: SnackPosition.TOP);
        Get.snackbar('Success', "$message", snackPosition: SnackPosition.TOP);
        return true;
      } else {
        print("response body ----==> ${response.body}");
        try {
          final errorBody = jsonDecode(response.body);
          final errorMessage = errorBody['errors']?[0]?['message'] ?? 'Failed to send OTP';
          Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
        } catch (e) {
          Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.BOTTOM);
        }
        return false;
      }
    } catch (e) {
      loder1.value = false;
      Get.snackbar('Error', 'Network error: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    }finally{
      loder1.value = false;
    }
  }


  Future<ResponseModel?> loginOtpVerify(String? phone, String? otp, String type) async {
    vdDebug("phone: $phone, otp: $otp, type: $type",tag: tag);
    try {
      final response = await http.post(
        Uri.parse('https://smartvyapaar.com/api/v1/auth/vendor/login'),
        body: {
          "phone": "+91$phone",
          "entered_otp": otp,
          "vendor_type": type
        },
      );
vdDebug("resopnse: ${response.body}, status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print("Success response: $jsonBody");

        final apiResponse = Response(
          body: jsonBody,
          statusCode: 200,
          statusText: "OK",
        );

        return await authServiceInterface.manageLogin(apiResponse, type);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['errors']?[0]?['message'] ?? 'Something went wrong';
        print("Server responded with error: $errorMessage");

        return ResponseModel(false, errorMessage);
      }
    } catch (e, stack) {
      print("Exception: $e");
      print("Stack trace: $stack");
      return ResponseModel(false, "Unexpected error: $e");
    }
  }





}