import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/repositories/trip_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class TripRepository implements TripRepositoryInterface{
  final ApiClient apiClient;
  TripRepository({required this.apiClient});

  @override
  Future<TripListModel?> getTripList({required String status, required String offset}) async {
    TripListModel? tripListModel;
    Response response = await apiClient.getData('${AppConstants.taxiTripListUri}/$status?limit=25&offset=$offset');
    if(response.statusCode == 200){
      tripListModel = TripListModel.fromJson(response.body);
    }
    return tripListModel;
  }

  @override
  Future<bool> updateTripStatus({required int tripId, required String status}) async {
    Response response = await apiClient.getData('${AppConstants.taxiUpdateTripStatusUri}?trip_id=$tripId&trip_status=$status');
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateTripPaymentStatus({required int tripId, required String paymentStatus}) async {
    Response response = await apiClient.getData('${AppConstants.taxiUpdateTripPaymentStatusUri}?trip_id=$tripId&payment_status=$paymentStatus', handleError: false);
    return response.statusCode == 200;
  }

  @override
  Future<TripDetailsModel?> getTripDetails({required int tripId}) async {
    TripDetailsModel? tripDetailsModel;
    Response response = await apiClient.getData('${AppConstants.taxiTripDetailsUri}?trip_id=$tripId');
    if(response.statusCode == 200){
      tripDetailsModel = TripDetailsModel.fromJson(response.body);
    }
    return tripDetailsModel;
  }

  @override
  Future<bool> assignVehicle({required int tripId, required int tripDetailsId, required int vehicleId, required List<int> vehicleIdentityIds}) async {
    Response response = await apiClient.postData(AppConstants.taxiAssignVehicleUri, {
      'trip_id': tripId,
      'trip_details_id': tripDetailsId,
      'vehicle_id': vehicleId,
      'vehicle_identity_ids': '$vehicleIdentityIds',
      '_method': 'put'
    });
    return response.statusCode == 200;
  }

  @override
  Future<bool> assignDriver({required int tripId, required Map<String, dynamic> driverIds}) async {
    Response response = await apiClient.postData(AppConstants.taxiAssignDriverUri, {
      'trip_id': tripId,
      'driver_ids': jsonEncode(driverIds),
      '_method': 'put'
    });
    return response.statusCode == 200;
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    List<PredictionModel> predictionList = [];
    Response response = await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text', handleError: false);
    if (response.statusCode == 200 && response.body['status'] == 'OK') {
      predictionList = [];
      response.body['predictions'].forEach((prediction) => predictionList.add(PredictionModel.fromJson(prediction)));
    } else {
      showCustomSnackBar(response.body['error_message'] ?? response.bodyString);
    }
    return predictionList;
  }

  @override
  Future<bool> checkInZone(String? lat, String? lng, int zoneId) async {
    Response response = await apiClient.getData('${AppConstants.checkZoneUri}?lat=$lat&lng=$lng&zone_id=$zoneId');
    if(response.statusCode == 200) {
      return response.body;
    } else {
      return response.body;
    }
  }

  @override
  Future<Response> getPlaceDetails(String? placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

  @override
  Future<bool> editTripDetails({required Map<String, dynamic> body}) async {
    Response response = await apiClient.postData(AppConstants.taxiEditTripUri, body);
    return response.statusCode == 200;
  }

  @override
  Future<Response> getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    return await apiClient.getData('${AppConstants.directionUri}''?origin_lat=${origin.latitude}&origin_lng=${origin.longitude}'
    '&destination_lat=${destination.latitude}&destination_lng=${destination.longitude}');
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
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