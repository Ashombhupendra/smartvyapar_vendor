import 'package:flutter/foundation.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_module_permission_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/services/taxi_profile_service_interface.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TaxiProfileController extends GetxController implements GetxService {
  final TaxiProfileServiceInterface taxiProfileServiceInterface;
  TaxiProfileController({required this.taxiProfileServiceInterface});

  TaxiProfileModel? _profileModel;
  TaxiProfileModel? get profileModel => _profileModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  XFile? _pickedFile;
  XFile? get pickedFile => _pickedFile;

  TaxiModulePermissionModel? _taxiModulePermission;
  TaxiModulePermissionModel? get taxiModulePermission => _taxiModulePermission;

  bool _trialWidgetNotShow = false;
  bool get trialWidgetNotShow => _trialWidgetNotShow;

  bool _showLowStockWarning = true;
  bool get showLowStockWarning => _showLowStockWarning;

  void hideLowStockWarning(){
    _showLowStockWarning = !_showLowStockWarning;
  }

  Future<void> getProfile() async {
    TaxiProfileModel? profileModel = await taxiProfileServiceInterface.getProfileInfo();
    if (profileModel != null) {
      _profileModel = profileModel;
      Get.find<SplashController>().setModule(_profileModel!.stores![0].module!.id, _profileModel!.stores![0].module!.moduleType);
      taxiProfileServiceInterface.updateHeader(_profileModel!.stores![0].module!.id);
      _allowModulePermission(_profileModel?.roles);
    }
    update();
  }

  Future<bool> updateUserInfo(TaxiProfileModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    bool isSuccess = await taxiProfileServiceInterface.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (isSuccess) {
      await getProfile();
      Get.back();
      showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
    }
    update();
    return isSuccess;
  }

  void pickImage() async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(picked != null) {
      _pickedFile = picked;
    }
    update();
  }

  Future deleteVendor() async {
    _isLoading = true;
    update();
    ResponseModel responseModel = await taxiProfileServiceInterface.deleteVendor();
    _isLoading = false;
    if (responseModel.isSuccess) {
      showCustomSnackBar(responseModel.message, isError: false);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }else{
      Get.back();
      showCustomSnackBar(responseModel.message, isError: true);
    }
  }

  void _allowModulePermission(List<String>? roles) {
    debugPrint('---permission--->>$roles');
    if(roles != null && roles.isNotEmpty){
      List<String> module = roles;
      if (kDebugMode) {
        print(module);
      }
      _taxiModulePermission = TaxiModulePermissionModel(
        trip: module.contains('trip'),
        vehicle: module.contains('vehicle'),
        driver: module.contains('driver'),
        marketing: module.contains('marketing'),
        storeSetup: module.contains('store_setup'),
        myWallet: module.contains('my_wallet'),
        profile: module.contains('profile'),
        rentalEmployees: module.contains('rental_employees'),
        myShop: module.contains('my_shop'),
        reviews: module.contains('reviews'),
        chat: module.contains('chat'),
        rentalReport: module.contains('rental_report'),
      );
    }else{
      _taxiModulePermission = TaxiModulePermissionModel(
        trip: true, vehicle: true, driver: true, marketing: true, storeSetup: true, myWallet: true,
        profile: true, rentalEmployees: true, myShop: true, reviews: true, chat: true, rentalReport: true,
      );
    }
  }

  void initData() {
    _pickedFile = null;
  }

  Future<bool> trialWidgetShow({required String route}) async {
    const Set<String> routesToHideWidget = {
      RouteHelper.mySubscription, 'show-dialog', RouteHelper.success, RouteHelper.payment, RouteHelper.signIn,
    };
    _trialWidgetNotShow = routesToHideWidget.contains(route);
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
    return _trialWidgetNotShow;
  }

}