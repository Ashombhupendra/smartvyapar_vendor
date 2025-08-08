import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/models/taxi_coupon_model.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/repositories/taxi_coupon_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/domain/services/taxi_coupon_service_interface.dart';

class TaxiCouponService implements TaxiCouponServiceInterface {
  final TaxiCouponRepositoryInterface taxiCouponRepositoryInterface;
  TaxiCouponService({required this.taxiCouponRepositoryInterface});

  @override
  Future<ResponseModel> addCoupon(Map<String, String?> data) async {
    return await taxiCouponRepositoryInterface.addCoupon(data);
  }

  @override
  Future<ResponseModel> updateCoupon(Map<String, dynamic> body, int? id) async {
    return await taxiCouponRepositoryInterface.updateCoupon(body, id);
  }

  @override
  Future<TaxiCouponModel?> getCouponList({required String offset}) async {
    return await taxiCouponRepositoryInterface.getCouponList(offset: offset);
  }

  @override
  Future<Coupons?> getCouponDetails(int id) async {
    return await taxiCouponRepositoryInterface.get(id);
  }

  @override
  Future<bool> changeStatus(int? couponId) async {
    return await taxiCouponRepositoryInterface.changeStatus(couponId);
  }

  @override
  Future<ResponseModel> deleteCoupon(int? couponId) async {
    return await taxiCouponRepositoryInterface.delete(couponId);
  }

}