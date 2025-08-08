import 'package:get/get.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/models/taxi_coupon_model.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/repositories/taxi_coupon_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class TaxiCouponRepository implements TaxiCouponRepositoryInterface {
  final ApiClient apiClient;
  TaxiCouponRepository({required this.apiClient});

  @override
  Future<TaxiCouponModel?> getCouponList({required String offset}) async {
    TaxiCouponModel? taxiCouponModel;
    Response response = await apiClient.getData('${AppConstants.taxiCouponListUri}?limit=10&offset=$offset');
    if(response.statusCode == 200) {
      taxiCouponModel = TaxiCouponModel.fromJson(response.body);
    }
    return taxiCouponModel;
  }

  @override
  Future<ResponseModel> addCoupon(Map<String, String?> data) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.taxiAddCouponUri, data, handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> updateCoupon(Map<String, dynamic> body, int? id) async {
    ResponseModel responseModel;
    Response response = await apiClient.postData('${AppConstants.taxiUpdateCouponUri}/$id', body, handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<Coupons?> get(int? id) async {
    Coupons? couponDetails;
    Response response = await apiClient.getData('${AppConstants.taxiCouponDetailsUri}/$id');
    if(response.statusCode == 200) {
      couponDetails = Coupons.fromJson(response.body);
    }
    return couponDetails;
  }

  @override
  Future<bool> changeStatus(int? couponId) async {
    bool success = false;
    Response response = await apiClient.getData('${AppConstants.taxiChangeCouponStatusUri}/$couponId');
    if(response.statusCode == 200) {
      success = true;
      showCustomSnackBar('coupon_status_updated'.tr, isError: false);
    }
    return success;
  }

  @override
  Future<ResponseModel> delete(int? id) async {
    ResponseModel responseModel;
    Response response = await apiClient.deleteData('${AppConstants.taxiDeleteCouponUri}/$id', handleError: false);
    if(response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}