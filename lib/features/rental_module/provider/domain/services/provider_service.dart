import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/taxi_review_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_brand_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_category_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/repositories/provider_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/services/provider_service_interface.dart';

class ProviderService implements ProviderServiceInterface {
  final ProviderRepositoryInterface providerRepositoryInterface;
  ProviderService({required this.providerRepositoryInterface});

  @override
  Future<Vehicles?> getVehicleDetails({required int vehicleId}) async {
    return await providerRepositoryInterface.getVehicleDetails(vehicleId: vehicleId);
  }

  @override
  Future<bool> updateVehicleActivity({required int vehicleId}) async {
    return await providerRepositoryInterface.updateVehicleActivity(vehicleId: vehicleId);
  }

  @override
  Future<bool> updateVehicleNewTag({required int vehicleId}) async {
    return await providerRepositoryInterface.updateVehicleNewTag(vehicleId: vehicleId);
  }

  @override
  Future<VehicleListModel?> getVehicleList({required String offset, String? categoryId, String? brandId, String? vehicleType, String? seatingCapacity, String? airCondition, String? transmissionType, String? fuelType, String? search}) async {
    return await providerRepositoryInterface.getVehicleList(offset: offset, categoryId: categoryId ?? '', brandId: brandId ?? '', vehicleType: vehicleType ?? '', seatingCapacity: seatingCapacity ?? '', airCondition: airCondition ?? '', transmissionType: transmissionType ?? '', fuelType: fuelType ?? '', search: search ?? '');
  }

  @override
  Future<bool> deleteVehicle({required int vehicleId}) async {
    return await providerRepositoryInterface.deleteVehicle(vehicleId: vehicleId);
  }

  @override
  Future<VehicleCategoryModel?> getCategoryList({required String offset}) async {
    return await providerRepositoryInterface.getCategoryList(offset: offset);
  }

  @override
  Future<VehicleBrandModel?> getBrandList({required String offset}) async {
    return await providerRepositoryInterface.getBrandList(offset: offset);
  }

  @override
  Future<Response> addVehicle({required Vehicles? vehicle, required bool isAdd, XFile? vehicleThumbnail, required List<XFile> vehicleImages, required List<MultipartDocument> licenseFiles}) async {
    return await providerRepositoryInterface.addVehicle(vehicle: vehicle, isAdd: isAdd, vehicleThumbnail: vehicleThumbnail, vehicleImages: vehicleImages, licenseFiles: licenseFiles);
  }

  @override
  Future<int?> addSchedule(Schedules schedule) async {
    return await providerRepositoryInterface.add(schedule);
  }

  @override
  Future<bool> deleteSchedule(int? scheduleID) async {
    return await providerRepositoryInterface.delete(scheduleID);
  }

  @override
  Future<bool> updateProviderBusinessSetup({required Store provider, required String minTime, required String maxTime, required String timeType, XFile? logo, XFile? coverImage}) async {
    return await providerRepositoryInterface.updateProviderBusinessSetup(provider: provider, minTime: minTime, maxTime: maxTime, timeType: timeType, logo: logo, coverImage: coverImage);
  }

  @override
  Future<List<TaxiReviewModel>?> getProviderReviewList(String? searchText) async {
    return await providerRepositoryInterface.getProviderReviewList(searchText);
  }

  @override
  Future<bool> updateReply(int reviewID, String reply) async {
    return await providerRepositoryInterface.updateReply(reviewID, reply);
  }

  @override
  Future<Vehicles?> getVehicleDetailsWithTrans(int vehicleId) async {
    return await providerRepositoryInterface.get(vehicleId);
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      int imageSize = await pickImage.length();
      if (imageSize > 1000000) {
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return pickImage;
      }
    }
    return pickImage;
  }

}