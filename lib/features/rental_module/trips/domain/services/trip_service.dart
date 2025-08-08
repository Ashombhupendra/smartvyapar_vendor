import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/repositories/trip_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/services/trip_service_interface.dart';

class TripService implements TripServiceInterface{
  final TripRepositoryInterface tripRepositoryInterface;
  TripService({required this.tripRepositoryInterface});

  @override
  Future<TripListModel?> getTripList({required String status, required String offset}) async {
    return await tripRepositoryInterface.getTripList(status: status, offset: offset);
  }

  @override
  Future<bool> updateTripStatus({required int tripId, required String status}) async {
    return await tripRepositoryInterface.updateTripStatus(tripId: tripId, status: status);
  }

  @override
  Future<bool> updateTripPaymentStatus({required int tripId, required String paymentStatus}) async {
    return await tripRepositoryInterface.updateTripPaymentStatus(tripId: tripId, paymentStatus: paymentStatus);
  }

  @override
  Future<TripDetailsModel?> getTripDetails({required int tripId}) async {
    return await tripRepositoryInterface.getTripDetails(tripId: tripId);
  }

  @override
  Future<bool> assignVehicle({required int tripId, required int tripDetailsId, required int vehicleId, required List<int> vehicleIdentityIds}) async {
    return await tripRepositoryInterface.assignVehicle(tripId: tripId, tripDetailsId: tripDetailsId, vehicleId: vehicleId, vehicleIdentityIds: vehicleIdentityIds);
  }

  @override
  Future<bool> assignDriver({required int tripId, required Map<String, dynamic> driverIds}) async {
    return await tripRepositoryInterface.assignDriver(tripId: tripId, driverIds: driverIds);
  }

  @override
  Future<List<PredictionModel>> searchLocation(String text) async {
    return await tripRepositoryInterface.searchLocation(text);
  }

  @override
  Future<bool> checkInZone(String? lat, String? lng, int zoneId) async {
    return await tripRepositoryInterface.checkInZone(lat, lng, zoneId);
  }

  @override
  Future<Response> getPlaceDetails(String? placeID) async {
    return await tripRepositoryInterface.getPlaceDetails(placeID);
  }

  @override
  Future<bool> editTripDetails({required Map<String, dynamic> body}) async {
    return await tripRepositoryInterface.editTripDetails(body: body);
  }

  @override
  Future<Response> getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    return await tripRepositoryInterface.getRouteBetweenCoordinates(origin, destination);
  }

}