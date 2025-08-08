import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class TripRepositoryInterface extends RepositoryInterface{
  Future<TripListModel?> getTripList({required String status, required String offset});
  Future<bool> updateTripStatus({required int tripId, required String status});
  Future<bool> updateTripPaymentStatus({required int tripId, required String paymentStatus});
  Future<TripDetailsModel?> getTripDetails({required int tripId});
  Future<bool> assignVehicle({required int tripId, required int tripDetailsId, required int vehicleId, required List<int> vehicleIdentityIds});
  Future<bool> assignDriver({required int tripId, required Map<String, dynamic> driverIds});
  Future<dynamic> searchLocation(String text);
  Future<bool> checkInZone(String? lat, String? lng, int zoneId);
  Future<Response> getPlaceDetails(String? placeID);
  Future<bool> editTripDetails({required Map<String, dynamic> body});
  Future<Response> getRouteBetweenCoordinates(LatLng origin, LatLng destination);
}