import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';

class DriverDetailsModel {
  int? id;
  int? providerId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? identityType;
  String? identityNumber;
  String? identityImage;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? tripsCount;
  int? totalTripCompleted;
  int? totalTripCanceled;
  int? totalTripOngoing;
  String? imageFullUrl;
  List<String>? identityImageFullUrl;
  List<AllTrips>? allTrips;

  DriverDetailsModel({
    this.id,
    this.providerId,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.identityType,
    this.identityNumber,
    this.identityImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.tripsCount,
    this.totalTripCompleted,
    this.totalTripCanceled,
    this.totalTripOngoing,
    this.imageFullUrl,
    this.identityImageFullUrl,
    this.allTrips,
  });

  DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    identityType = json['identity_type'];
    identityNumber = json['identity_number'];
    identityImage = json['identity_image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    tripsCount = json['trips_count'];
    totalTripCompleted = json['total_trip_completed'];
    totalTripCanceled = json['total_trip_canceled'];
    totalTripOngoing = json['total_trip_ongoing'];
    imageFullUrl = json['image_full_url'];
    if (json['identity_image_full_url'] != null) {
      identityImageFullUrl = <String>[];
      json['identity_image_full_url'].forEach((v) {
        identityImageFullUrl!.add(v);
      });
    }
    if (json['trips'] != null) {
      allTrips = <AllTrips>[];
      json['trips'].forEach((v) {
        allTrips!.add(AllTrips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['identity_type'] = identityType;
    data['identity_number'] = identityNumber;
    data['identity_image'] = identityImage;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['trips_count'] = tripsCount;
    data['total_trip_completed'] = totalTripCompleted;
    data['total_trip_canceled'] = totalTripCanceled;
    data['total_trip_ongoing'] = totalTripOngoing;
    data['image_full_url'] = imageFullUrl;
    if (identityImageFullUrl != null) {
      data['identity_image_full_url'] = identityImageFullUrl!.map((v) => v).toList();
    }
    if (allTrips != null) {
      data['trips'] = allTrips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllTrips {
  int? id;
  int? tripId;
  int? vehicleId;
  int? vehicleIdentityId;
  int? vehicleDriverId;
  String? createdAt;
  String? updatedAt;
  String? estimatedTripEndTime;
  int? tripDetailsId;
  Trips? trip;

  AllTrips({
    this.id,
    this.tripId,
    this.vehicleId,
    this.vehicleIdentityId,
    this.vehicleDriverId,
    this.createdAt,
    this.updatedAt,
    this.estimatedTripEndTime,
    this.tripDetailsId,
    this.trip,
  });

  AllTrips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    vehicleId = json['vehicle_id'];
    vehicleIdentityId = json['vehicle_identity_id'];
    vehicleDriverId = json['vehicle_driver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    estimatedTripEndTime = json['estimated_trip_end_time'];
    tripDetailsId = json['trip_details_id'];
    trip = json['trip'] != null ? Trips.fromJson(json['trip']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_id'] = tripId;
    data['vehicle_id'] = vehicleId;
    data['vehicle_identity_id'] = vehicleIdentityId;
    data['vehicle_driver_id'] = vehicleDriverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['estimated_trip_end_time'] = estimatedTripEndTime;
    data['trip_details_id'] = tripDetailsId;
    if (trip != null) {
      data['trip'] = trip!.toJson();
    }
    return data;
  }
}
