import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/taxi_review_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_brand_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_category_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';

abstract class ProviderServiceInterface {
  Future<XFile?> pickImageFromGallery();
  Future<Vehicles?> getVehicleDetails({required int vehicleId});
  Future<bool> updateVehicleActivity({required int vehicleId});
  Future<bool> updateVehicleNewTag({required int vehicleId});
  Future<VehicleListModel?> getVehicleList({required String offset, String? categoryId, String? brandId, String? vehicleType, String? seatingCapacity, String? airCondition, String? transmissionType, String? fuelType, String? search});
  Future<bool> deleteVehicle({required int vehicleId});
  Future<VehicleCategoryModel?> getCategoryList({required String offset});
  Future<VehicleBrandModel?> getBrandList({required String offset});
  Future<Response> addVehicle({required Vehicles? vehicle, required bool isAdd, XFile? vehicleThumbnail, required List<XFile> vehicleImages, required List<MultipartDocument> licenseFiles});
  Future<int?> addSchedule(Schedules schedule);
  Future<bool> deleteSchedule(int? scheduleID);
  Future<bool> updateProviderBusinessSetup({required Store provider, required String minTime, required String maxTime, required String timeType, XFile? logo, XFile? coverImage});
  Future<List<TaxiReviewModel>?> getProviderReviewList(String? searchText);
  Future<bool> updateReply(int reviewID, String reply);
  Future<Vehicles?> getVehicleDetailsWithTrans(int vehicleId);
}