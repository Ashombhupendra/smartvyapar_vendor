import 'package:get/get.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/models/taxi_coupon_model.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/services/taxi_coupon_service_interface.dart';

class TaxiCouponController extends GetxController implements GetxService {
  final TaxiCouponServiceInterface taxiCouponServiceInterface;
  TaxiCouponController({required this.taxiCouponServiceInterface});

  int _couponTypeIndex = 0;
  int get couponTypeIndex => _couponTypeIndex;

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  int? _pageSize;
  int? get pageSize => _pageSize;

  final List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Coupons>? _couponList;
  List<Coupons>? get couponList => _couponList;

  Coupons? _couponDetails;
  Coupons? get couponDetails => _couponDetails;

  void setCouponTypeIndex(int index, bool notify) {
    _couponTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  Future<void> getCouponList({required String offset, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _couponList = null;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      TaxiCouponModel? taxiCouponModel = await taxiCouponServiceInterface.getCouponList(offset: offset);
      if (taxiCouponModel != null) {
        if (offset == '1') {
          _couponList = [];
        }
        _couponList?.addAll(taxiCouponModel.coupons ?? []);
        _pageSize = taxiCouponModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<Coupons?> getCouponDetails(int id) async {
    _couponDetails = null;
    Coupons? couponDetails = await taxiCouponServiceInterface.getCouponDetails(id);
    if(couponDetails != null) {
      _couponDetails = couponDetails;
    }
    update();
    return _couponDetails;
  }

  Future<bool> changeStatus(int? couponId) async {
    bool success = await taxiCouponServiceInterface.changeStatus(couponId);
    return success;
  }

  Future<bool> deleteCoupon(int? couponId) async {
    _isLoading = true;
    update();
    bool success = false;
    ResponseModel responseModel = await taxiCouponServiceInterface.deleteCoupon(couponId);
    if(responseModel.isSuccess) {
      success = true;
      getCouponList(offset: '1');
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
    return success;
  }

  Future<void> addCoupon({String? code, String? title, String? startDate, String? expireDate, String? discount, String? couponType, String? discountType,
    String? limit, String? maxDiscount, String? minPurches}) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    ResponseModel responseModel = await taxiCouponServiceInterface.addCoupon(data);
    if(responseModel.isSuccess) {
      getCouponList(offset: '1');
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateCoupon({String? couponId, String? code, String? title, String? startDate, String? expireDate, String? discount, String? couponType,
    String? discountType, String? limit, String? maxDiscount, String? minPurches}) async {
    _isLoading = true;
    update();
    Map<String, String?> data = {
      "code": code,
      "translations": title,
      "start_date": startDate,
      "expire_date": expireDate,
      "discount": discount != null && discount.isNotEmpty ? discount : '0',
      "coupon_type": couponType,
      "discount_type": discountType,
      "limit": limit,
      "max_discount": maxDiscount,
      "min_purchase": minPurches,
    };

    ResponseModel responseModel = await taxiCouponServiceInterface.updateCoupon(data, int.parse(couponId!));
    if(responseModel.isSuccess) {
      Get.back();
      showCustomSnackBar(responseModel.message, isError: false);
      getCouponList(offset: '1');
    }else {
      showCustomSnackBar(responseModel.message, isError: true);
    }
    _isLoading = false;
    update();
  }

}