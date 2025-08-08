import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/taxi_review_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_brand_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_category_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/repositories/provider_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class ProviderRepository implements ProviderRepositoryInterface {
  final ApiClient apiClient;
  ProviderRepository({required this.apiClient});

  @override
  Future<Vehicles?> getVehicleDetails({required int vehicleId}) async {
    Vehicles? vehicleDetailsModel;
    Response response = await apiClient.getData('${AppConstants.taxiVehicleDetailsUri}/$vehicleId');
    if(response.statusCode == 200) {
      vehicleDetailsModel = Vehicles.fromJson(response.body);
    }
    return vehicleDetailsModel;
  }

  @override
  Future<bool> updateVehicleActivity({required int vehicleId}) async {
    Response response = await apiClient.getData('${AppConstants.taxiActiveStatusUri}/$vehicleId');
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateVehicleNewTag({required int vehicleId}) async {
    Response response = await apiClient.getData('${AppConstants.taxiNewTagStatusUri}/$vehicleId');
    return response.statusCode == 200;
  }

  @override
  Future<VehicleListModel?> getVehicleList({required String offset, String? categoryId, String? brandId, String? vehicleType, String? seatingCapacity, String? airCondition, String? transmissionType, String? fuelType, String? search}) async {
    VehicleListModel? vehicleListModel;
    Response response = await apiClient.getData('${AppConstants.taxiVehicleListUri}?offset=$offset&limit=10&category_id=$categoryId&brand_id=$brandId&vehicle_type=$vehicleType&seating_capacity=$seatingCapacity&air_condition=$airCondition&transmission_type=$transmissionType&fuel_type=$fuelType&search=$search');
    if(response.statusCode == 200) {
      vehicleListModel = VehicleListModel.fromJson(response.body);
    }
    return vehicleListModel;
  }

  @override
  Future<bool> deleteVehicle({required int vehicleId}) async {
    Response response = await apiClient.deleteData('${AppConstants.taxiDeleteVehicleUri}/$vehicleId');
    return response.statusCode == 200;
  }

  @override
  Future<VehicleCategoryModel?> getCategoryList({required String offset}) async {
    VehicleCategoryModel? categoryModel;
    Response response = await apiClient.getData('${AppConstants.taxiCategoryListUri}?offset=$offset&limit=20');
    if(response.statusCode == 200) {
      categoryModel = VehicleCategoryModel.fromJson(response.body);
    }
    return categoryModel;
  }

  @override
  Future<VehicleBrandModel?> getBrandList({required String offset}) async {
    VehicleBrandModel? brandModel;
    Response response = await apiClient.getData('${AppConstants.taxiBrandListUri}?offset=$offset&limit=20');
    if(response.statusCode == 200) {
      brandModel = VehicleBrandModel.fromJson(response.body);
    }
    return brandModel;
  }

  @override
  Future<Response> addVehicle({required Vehicles? vehicle, required bool isAdd, XFile? vehicleThumbnail, required List<XFile> vehicleImages, required List<MultipartDocument> licenseFiles}) async {

    Map<String, String> fields = {};

    fields.addAll({
      'translations': jsonEncode(vehicle?.translations),
      'provider_id': vehicle!.providerId.toString(),
      'brand_id': vehicle.brandId.toString(),
      'category_id': vehicle.categoryId.toString(),
      'type' : vehicle.type.toString(),
      'engine_capacity' : vehicle.engineCapacity.toString(),
      'engine_power' : vehicle.enginePower.toString(),
      'seating_capacity' : vehicle.seatingCapacity.toString(),
      'air_condition' : vehicle.airCondition.toString(),
      'fuel_type' : vehicle.fuelType.toString(),
      'transmission_type' : vehicle.transmissionType.toString(),
      'trip_hourly' : vehicle.tripHourly.toString(),
      'trip_distance' : vehicle.tripDistance.toString(),
      'hourly_price' : vehicle.hourlyPrice.toString(),
      'distance_price' : vehicle.distancePrice.toString(),
      'discount_type' : vehicle.discountType.toString(),
      'discount_price' : vehicle.discountPrice.toString(),
      'multiple_vehicles' : vehicle.multipleVehicles.toString(),
    });

    for(int i = 0; i < vehicle.tag!.length; i++){
      fields.addAll({
        'tag[$i]': vehicle.tag![i].toString(),
      });
    }

    for(int i = 0; i < vehicle.vehicleIdentities!.length; i++){
      fields.addAll({
        'vehicle[vin_number][$i]': vehicle.vehicleIdentities![i].vinNumber.toString(),
        'vehicle[license_plate_number][$i]': vehicle.vehicleIdentities![i].licensePlateNumber.toString(),
      });
    }

    List<MultipartBody> images = [];
    images.add(MultipartBody('thumbnail', vehicleThumbnail));
    for(int index = 0; index < vehicleImages.length; index++) {
      images.add(MultipartBody('images[$index]', vehicleImages[index]));
    }

    Response response = await apiClient.postMultipartData(isAdd ? AppConstants.taxiAddVehicleUri : '${AppConstants.taxiUpdateVehicleUri}/${vehicle.id}', fields, images, multipartDocument: licenseFiles);
    return response;
  }

  @override
  Future<int?> add(Schedules schedule) async {
    int? scheduleID;
    Response response = await apiClient.postData(AppConstants.taxiAddScheduleUri, schedule.toJson());
    if(response.statusCode == 200) {
      scheduleID = int.parse(response.body['id'].toString());
    }
    return scheduleID;
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.taxiDeleteScheduleUri}/$id');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateProviderBusinessSetup({required Store provider, required String minTime, required String maxTime, required String timeType, XFile? logo, XFile? coverImage}) async {

    Map<String, String> fields = {};

    fields.addAll({
      'translations': jsonEncode(provider.translations),
      'contact_number': provider.phone.toString(),
      'schedule_trip': provider.scheduleOrder == true ? '1' : '0',
      'gst' : provider.gstCode.toString(),
      'gst_status' : provider.gstStatus == true ? '1' : '0',
      'minimum_pickup_time' : minTime,
      'maximum_pickup_time' : maxTime,
      'pickup_time_type' : timeType,
      'pickup_zone_id' : jsonEncode(provider.pickupZoneId),
    });

    List<MultipartBody> images = [];
    images.add(MultipartBody('logo', logo));
    images.add(MultipartBody('cover_photo', coverImage));

    Response response = await apiClient.postMultipartData(AppConstants.taxiUpdateProviderBusinessSetupUri, fields, images, handleError: false);
    return response.statusCode == 200;
  }

  @override
  Future<List<TaxiReviewModel>?> getProviderReviewList(String? searchText) async {
    List<TaxiReviewModel>? providerReviewList;
    Response response = await apiClient.getData('${AppConstants.taxiReviewListUri}?search=$searchText&limit=50&offset=1');
    if(response.statusCode == 200) {
      providerReviewList = [];
      response.body['reviews'].forEach((review) => providerReviewList!.add(TaxiReviewModel.fromJson(review)));
    }
    return providerReviewList;
  }

  @override
  Future<bool> updateReply(int reviewID, String reply) async {
    Map<String, String> fields = {'id': reviewID.toString(), 'reply': reply, '_method': 'put'};
    Response response = await apiClient.postData(AppConstants.taxiReviewReplyUri, fields);
    return (response.statusCode == 200);
  }

  @override
  Future<Vehicles?> get(int? id) async{
    Vehicles? vehicleDetailsWithTrans;
    Response response = await apiClient.getData('${AppConstants.taxiVehicleDetailsWithTransUri}/$id');
    if(response.statusCode == 200) {
      vehicleDetailsWithTrans = Vehicles.fromJson(response.body);
    }
    return vehicleDetailsWithTrans;
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