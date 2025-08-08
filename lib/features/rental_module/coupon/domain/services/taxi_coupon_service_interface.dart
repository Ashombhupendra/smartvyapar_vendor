import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/models/taxi_coupon_model.dart';

abstract class TaxiCouponServiceInterface {
  Future<TaxiCouponModel?> getCouponList({required String offset});
  Future<ResponseModel> addCoupon(Map<String, String?> data);
  Future<ResponseModel> updateCoupon(Map<String, dynamic> body, int? id);
  Future<Coupons?> getCouponDetails(int id);
  Future<bool> changeStatus(int? couponId);
  Future<ResponseModel> deleteCoupon(int? couponId);
}