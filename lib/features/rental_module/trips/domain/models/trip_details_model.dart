class TripDetailsModel {
  int? id;
  int? userId;
  int? providerId;
  int? zoneId;
  int? moduleId;
  int? cashBackId;
  double? tripAmount;
  double? discountOnTrip;
  String? discountOnTripBy;
  double? couponDiscountAmount;
  String? couponDiscountBy;
  String? couponCode;
  String? tripStatus;
  String? paymentStatus;
  String? paymentMethod;
  String? transactionReference;
  double? taxAmount;
  String? taxStatus;
  int? taxPercentage;
  String? tripType;
  double? additionalCharge;
  double? partiallyPaidAmount;
  double? distance;
  int? estimatedHours;
  double? refBonusAmount;
  String? canceledBy;
  String? cancellationReason;
  PickupLocation? pickupLocation;
  PickupLocation? destinationLocation;
  String? tripNote;
  String? callback;
  String? otp;
  bool? isGuest;
  int? edited;
  int? checked;
  int? scheduled;
  String? scheduleAt;
  String? pending;
  String? confirmed;
  String? ongoing;
  String? completed;
  String? canceled;
  String? paymentFailed;
  int? quantity;
  String? estimatedTripEndTime;
  String? createdAt;
  String? updatedAt;
  int? pickupZoneId;
  String? attachment;
  UserInfo? userInfo;
  Customer? customer;
  List<TripDetails>? tripDetails;
  List<VehicleIdentity>? vehicleIdentity;

  TripDetailsModel({
    this.id,
    this.userId,
    this.providerId,
    this.zoneId,
    this.moduleId,
    this.cashBackId,
    this.tripAmount,
    this.discountOnTrip,
    this.discountOnTripBy,
    this.couponDiscountAmount,
    this.couponDiscountBy,
    this.couponCode,
    this.tripStatus,
    this.paymentStatus,
    this.paymentMethod,
    this.transactionReference,
    this.taxAmount,
    this.taxStatus,
    this.taxPercentage,
    this.tripType,
    this.additionalCharge,
    this.partiallyPaidAmount,
    this.distance,
    this.estimatedHours,
    this.refBonusAmount,
    this.canceledBy,
    this.cancellationReason,
    this.pickupLocation,
    this.destinationLocation,
    this.tripNote,
    this.callback,
    this.otp,
    this.isGuest,
    this.edited,
    this.checked,
    this.scheduled,
    this.scheduleAt,
    this.pending,
    this.confirmed,
    this.ongoing,
    this.completed,
    this.canceled,
    this.paymentFailed,
    this.quantity,
    this.estimatedTripEndTime,
    this.createdAt,
    this.updatedAt,
    this.pickupZoneId,
    this.attachment,
    this.userInfo,
    this.customer,
    this.tripDetails,
    this.vehicleIdentity,
  });

  TripDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    providerId = json['provider_id'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    cashBackId = json['cash_back_id'];
    tripAmount = json['trip_amount'].toDouble();
    discountOnTrip = json['discount_on_trip'].toDouble();
    discountOnTripBy = json['discount_on_trip_by'];
    couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    couponDiscountBy = json['coupon_discount_by'];
    couponCode = json['coupon_code'];
    tripStatus = json['trip_status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    taxAmount = json['tax_amount'].toDouble();
    taxStatus = json['tax_status'];
    taxPercentage = json['tax_percentage'];
    tripType = json['trip_type'];
    additionalCharge = json['additional_charge'].toDouble();
    partiallyPaidAmount = json['partially_paid_amount'].toDouble();
    distance = json['distance'].toDouble();
    estimatedHours = json['estimated_hours'];
    refBonusAmount = json['ref_bonus_amount'].toDouble();
    canceledBy = json['canceled_by'];
    cancellationReason = json['cancellation_reason'];
    pickupLocation = json['pickup_location'] != null ? PickupLocation.fromJson(json['pickup_location']) : null;
    destinationLocation = json['destination_location'] != null ? PickupLocation.fromJson(json['destination_location']) : null;
    tripNote = json['trip_note'];
    callback = json['callback'];
    otp = json['otp'];
    isGuest = json['is_guest'] == 1 ? true : false;
    edited = json['edited'];
    checked = json['checked'];
    scheduled = json['scheduled'];
    scheduleAt = json['schedule_at'];
    pending = json['pending'];
    confirmed = json['confirmed'];
    ongoing = json['ongoing'];
    completed = json['completed'];
    canceled = json['canceled'];
    paymentFailed = json['payment_failed'];
    quantity = json['quantity'];
    estimatedTripEndTime = json['estimated_trip_end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pickupZoneId = json['pickup_zone_id'];
    attachment = json['attachment'];
    userInfo = json['user_info'] != null ? UserInfo.fromJson(json['user_info']) : null;
    customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    if (json['trip_details'] != null) {
      tripDetails = <TripDetails>[];
      json['trip_details'].forEach((v) {
        tripDetails!.add(TripDetails.fromJson(v));
      });
    }
    if (json['vehicle_identity'] != null) {
      vehicleIdentity = <VehicleIdentity>[];
      json['vehicle_identity'].forEach((v) {
        vehicleIdentity!.add(VehicleIdentity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['zone_id'] = zoneId;
    data['module_id'] = moduleId;
    data['cash_back_id'] = cashBackId;
    data['trip_amount'] = tripAmount;
    data['discount_on_trip'] = discountOnTrip;
    data['discount_on_trip_by'] = discountOnTripBy;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_by'] = couponDiscountBy;
    data['coupon_code'] = couponCode;
    data['trip_status'] = tripStatus;
    data['payment_status'] = paymentStatus;
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['tax_amount'] = taxAmount;
    data['tax_status'] = taxStatus;
    data['tax_percentage'] = taxPercentage;
    data['trip_type'] = tripType;
    data['additional_charge'] = additionalCharge;
    data['partially_paid_amount'] = partiallyPaidAmount;
    data['distance'] = distance;
    data['estimated_hours'] = estimatedHours;
    data['ref_bonus_amount'] = refBonusAmount;
    data['canceled_by'] = canceledBy;
    data['cancellation_reason'] = cancellationReason;
    if (pickupLocation != null) {
      data['pickup_location'] = pickupLocation!.toJson();
    }
    if (destinationLocation != null) {
      data['destination_location'] = destinationLocation!.toJson();
    }
    data['trip_note'] = tripNote;
    data['callback'] = callback;
    data['otp'] = otp;
    data['is_guest'] = isGuest;
    data['edited'] = edited;
    data['checked'] = checked;
    data['scheduled'] = scheduled;
    data['schedule_at'] = scheduleAt;
    data['pending'] = pending;
    data['confirmed'] = confirmed;
    data['ongoing'] = ongoing;
    data['completed'] = completed;
    data['canceled'] = canceled;
    data['payment_failed'] = paymentFailed;
    data['quantity'] = quantity;
    data['estimated_trip_end_time'] = estimatedTripEndTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['pickup_zone_id'] = pickupZoneId;
    data['attachment'] = attachment;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (tripDetails != null) {
      data['trip_details'] = tripDetails!.map((v) => v.toJson()).toList();
    }
    if (vehicleIdentity != null) {
      data['vehicle_identity'] =
          vehicleIdentity!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PickupLocation {
  double? lat;
  double? lng;
  String? locationName;

  PickupLocation({this.lat, this.lng, this.locationName});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'] != null ? double.parse(json['lat'].toString()) : 0.0;
    lng = json['lng'] != null ? double.parse(json['lng'].toString()) : 0.0;
    locationName = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['location_name'] = locationName;
    return data;
  }
}

class UserInfo {
  String? contactPersonName;
  String? contactPersonNumber;
  String? contactPersonEmail;

  UserInfo({
    this.contactPersonName,
    this.contactPersonNumber,
    this.contactPersonEmail,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    contactPersonEmail = json['contact_person_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['contact_person_email'] = contactPersonEmail;
    return data;
  }
}

class Customer {
  int? id;
  String? fName;
  String? lName;
  String? phone;
  String? email;
  String? image;
  int? tripsCount;
  String? imageFullUrl;

  Customer({
    this.id,
    this.fName,
    this.lName,
    this.phone,
    this.email,
    this.image,
    this.tripsCount,
    this.imageFullUrl,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    tripsCount = json['trips_count'];
    imageFullUrl = json['image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['trips_count'] = tripsCount;
    data['image_full_url'] = imageFullUrl;
    return data;
  }
}

class TripDetails {
  int? id;
  int? tripId;
  int? vehicleId;
  int? quantity;
  double? price;
  double? discountOnTrip;
  double? taxAmount;
  String? taxStatus;
  int? taxPercentage;
  String? discountType;
  String? discountOnTripBy;
  int? discountPercentage;
  VehicleDetails? vehicleDetails;
  String? rentalType;
  int? estimatedHours;
  double? distance;
  int? scheduled;
  String? scheduleAt;
  String? estimatedTripEndTime;
  String? createdAt;
  String? updatedAt;
  double? originalPrice;
  int? isEdited;
  Vehicle? vehicle;
  double? calculatedPrice;

  TripDetails({
    this.id,
    this.tripId,
    this.vehicleId,
    this.quantity,
    this.price,
    this.discountOnTrip,
    this.taxAmount,
    this.taxStatus,
    this.taxPercentage,
    this.discountType,
    this.discountOnTripBy,
    this.discountPercentage,
    this.vehicleDetails,
    this.rentalType,
    this.estimatedHours,
    this.distance,
    this.scheduled,
    this.scheduleAt,
    this.estimatedTripEndTime,
    this.createdAt,
    this.updatedAt,
    this.originalPrice,
    this.isEdited,
    this.vehicle,
    this.calculatedPrice,
  });

  TripDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    vehicleId = json['vehicle_id'];
    quantity = json['quantity'];
    price = json['price'].toDouble();
    discountOnTrip = json['discount_on_trip'].toDouble();
    taxAmount = json['tax_amount'].toDouble();
    taxStatus = json['tax_status'];
    taxPercentage = json['tax_percentage'];
    discountType = json['discount_type'];
    discountOnTripBy = json['discount_on_trip_by'];
    discountPercentage = json['discount_percentage'];
    vehicleDetails = json['vehicle_details'] != null ? VehicleDetails.fromJson(json['vehicle_details']) : null;
    rentalType = json['rental_type'];
    estimatedHours = json['estimated_hours'];
    distance = json['distance'].toDouble();
    scheduled = json['scheduled'];
    scheduleAt = json['schedule_at'];
    estimatedTripEndTime = json['estimated_trip_end_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    originalPrice = json['original_price'] != null ? double.parse(json['original_price'].toString()) : 0.0;
    isEdited = json['is_edited'];
    vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    calculatedPrice = json['calculated_price'] != null ? double.parse(json['calculated_price'].toString()) : 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trip_id'] = tripId;
    data['vehicle_id'] = vehicleId;
    data['quantity'] = quantity;
    data['price'] = price;
    data['discount_on_trip'] = discountOnTrip;
    data['tax_amount'] = taxAmount;
    data['tax_status'] = taxStatus;
    data['tax_percentage'] = taxPercentage;
    data['discount_type'] = discountType;
    data['discount_on_trip_by'] = discountOnTripBy;
    data['discount_percentage'] = discountPercentage;
    if (vehicleDetails != null) {
      data['vehicle_details'] = vehicleDetails!.toJson();
    }
    data['rental_type'] = rentalType;
    data['estimated_hours'] = estimatedHours;
    data['distance'] = distance;
    data['scheduled'] = scheduled;
    data['schedule_at'] = scheduleAt;
    data['estimated_trip_end_time'] = estimatedTripEndTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['original_price'] = originalPrice;
    data['is_edited'] = isEdited;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    data['calculated_price'] = calculatedPrice;
    return data;
  }
}

class VehicleDetails {
  int? id;
  String? name;
  String? description;
  String? thumbnail;
  String? images;
  int? providerId;
  int? brandId;
  int? categoryId;
  String? model;
  String? type;
  String? engineCapacity;
  String? enginePower;
  String? seatingCapacity;
  int? airCondition;
  String? fuelType;
  String? transmissionType;
  int? multipleVehicles;
  int? tripHourly;
  int? tripDistance;
  double? hourlyPrice;
  double? distancePrice;
  String? discountType;
  double? discountPrice;
  String? tag;
  String? documents;
  int? status;
  int? newTag;
  int? totalTrip;
  String? avgRating;
  int? totalReviews;
  String? createdAt;
  String? updatedAt;
  int? zoneId;
  String? rating;
  String? thumbnailFullUrl;
  List<String>? imagesFullUrl;
  List<String>? documentsFullUrl;

  VehicleDetails({
    this.id,
    this.name,
    this.description,
    this.thumbnail,
    this.images,
    this.providerId,
    this.brandId,
    this.categoryId,
    this.model,
    this.type,
    this.engineCapacity,
    this.enginePower,
    this.seatingCapacity,
    this.airCondition,
    this.fuelType,
    this.transmissionType,
    this.multipleVehicles,
    this.tripHourly,
    this.tripDistance,
    this.hourlyPrice,
    this.distancePrice,
    this.discountType,
    this.discountPrice,
    this.tag,
    this.documents,
    this.status,
    this.newTag,
    this.totalTrip,
    this.avgRating,
    this.totalReviews,
    this.createdAt,
    this.updatedAt,
    this.zoneId,
    this.rating,
    this.thumbnailFullUrl,
    this.imagesFullUrl,
    this.documentsFullUrl,
  });

  VehicleDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    images = json['images'];
    providerId = json['provider_id'];
    brandId = json['brand_id'];
    categoryId = json['category_id'];
    model = json['model'];
    type = json['type'];
    engineCapacity = json['engine_capacity'];
    enginePower = json['engine_power'];
    seatingCapacity = json['seating_capacity'];
    airCondition = json['air_condition'];
    fuelType = json['fuel_type'];
    transmissionType = json['transmission_type'];
    multipleVehicles = json['multiple_vehicles'];
    tripHourly = json['trip_hourly'];
    tripDistance = json['trip_distance'];
    hourlyPrice = json['hourly_price'].toDouble();
    distancePrice = json['distance_price'].toDouble();
    discountType = json['discount_type'];
    discountPrice = json['discount_price'].toDouble();
    tag = json['tag'];
    documents = json['documents'];
    status = json['status'];
    newTag = json['new_tag'];
    totalTrip = json['total_trip'];
    avgRating = json['avg_rating'].toString();
    totalReviews = json['total_reviews'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    rating = json['rating'];
    thumbnailFullUrl = json['thumbnail_full_url'];
    imagesFullUrl = json['images_full_url'].cast<String>();
    documentsFullUrl = json['documents_full_url'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['thumbnail'] = thumbnail;
    data['images'] = images;
    data['provider_id'] = providerId;
    data['brand_id'] = brandId;
    data['category_id'] = categoryId;
    data['model'] = model;
    data['type'] = type;
    data['engine_capacity'] = engineCapacity;
    data['engine_power'] = enginePower;
    data['seating_capacity'] = seatingCapacity;
    data['air_condition'] = airCondition;
    data['fuel_type'] = fuelType;
    data['transmission_type'] = transmissionType;
    data['multiple_vehicles'] = multipleVehicles;
    data['trip_hourly'] = tripHourly;
    data['trip_distance'] = tripDistance;
    data['hourly_price'] = hourlyPrice;
    data['distance_price'] = distancePrice;
    data['discount_type'] = discountType;
    data['discount_price'] = discountPrice;
    data['tag'] = tag;
    data['documents'] = documents;
    data['status'] = status;
    data['new_tag'] = newTag;
    data['total_trip'] = totalTrip;
    data['avg_rating'] = avgRating;
    data['total_reviews'] = totalReviews;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['zone_id'] = zoneId;
    data['rating'] = rating;
    data['thumbnail_full_url'] = thumbnailFullUrl;
    data['images_full_url'] = imagesFullUrl;
    data['documents_full_url'] = documentsFullUrl;
    return data;
  }
}

class VehicleIdentity {
  int? id;
  int? tripId;
  int? vehicleId;
  int? vehicleIdentityId;
  int? vehicleDriverId;
  String? createdAt;
  String? updatedAt;
  String? estimatedTripEndTime;
  int? tripDetailsId;
  DriverData? driverData;
  VehicleIdentityData? vehicleIdentityData;
  Vehicles? vehicles;

  VehicleIdentity({
    this.id,
    this.tripId,
    this.vehicleId,
    this.vehicleIdentityId,
    this.vehicleDriverId,
    this.createdAt,
    this.updatedAt,
    this.estimatedTripEndTime,
    this.tripDetailsId,
    this.driverData,
    this.vehicleIdentityData,
    this.vehicles,
  });

  VehicleIdentity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    vehicleId = json['vehicle_id'];
    vehicleIdentityId = json['vehicle_identity_id'];
    vehicleDriverId = json['vehicle_driver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    estimatedTripEndTime = json['estimated_trip_end_time'];
    tripDetailsId = json['trip_details_id'];
    driverData = json['driver_data'] != null ? DriverData.fromJson(json['driver_data']) : null;
    vehicleIdentityData = json['vehicle_identity_data'] != null ? VehicleIdentityData.fromJson(json['vehicle_identity_data']) : null;
    vehicles = json['vehicles'] != null ? Vehicles.fromJson(json['vehicles']) : null;
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
    if (driverData != null) {
      data['driver_data'] = driverData!.toJson();
    }
    if (vehicleIdentityData != null) {
      data['vehicle_identity_data'] = vehicleIdentityData!.toJson();
    }
    if (vehicles != null) {
      data['vehicles'] = vehicles!.toJson();
    }
    return data;
  }
}

class DriverData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? imageFullUrl;
  List<String>? identityImageFullUrl;

  DriverData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.imageFullUrl,
    this.identityImageFullUrl,
  });

  DriverData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    imageFullUrl = json['image_full_url'];
    if (json['identity_image_full_url'] != null) {
      identityImageFullUrl = json['identity_image_full_url'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['image_full_url'] = imageFullUrl;
    if (identityImageFullUrl != null) {
      data['identity_image_full_url'] = identityImageFullUrl;
    }
    return data;
  }
}

class VehicleIdentityData {
  int? id;
  String? vinNumber;
  String? licensePlateNumber;

  VehicleIdentityData({this.id, this.vinNumber, this.licensePlateNumber});

  VehicleIdentityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vinNumber = json['vin_number'];
    licensePlateNumber = json['license_plate_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vin_number'] = vinNumber;
    data['license_plate_number'] = licensePlateNumber;
    return data;
  }
}

class Vehicle {
  int? id;
  double? hourlyPrice;
  double? distancePrice;
  String? discountType;
  double? discountPrice;
  int? totalVehicleCount;

  Vehicle({
    this.id,
    this.hourlyPrice,
    this.distancePrice,
    this.discountType,
    this.discountPrice,
    this.totalVehicleCount,
  });

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hourlyPrice = json['hourly_price'].toDouble();
    distancePrice = json['distance_price'].toDouble();
    discountType = json['discount_type'];
    discountPrice = json['discount_price'].toDouble();
    totalVehicleCount = json['total_vehicle_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['hourly_price'] = hourlyPrice;
    data['distance_price'] = distancePrice;
    data['discount_type'] = discountType;
    data['discount_price'] = discountPrice;
    data['total_vehicle_count'] = totalVehicleCount;
    return data;
  }
}

class Vehicles {
  int? id;
  String? name;
  String? thumbnail;
  String? thumbnailFullUrl;

  Vehicles({
    this.id,
    this.name,
    this.thumbnail,
    this.thumbnailFullUrl,
  });

  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    thumbnailFullUrl = json['thumbnail_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['thumbnail'] = thumbnail;
    data['thumbnail_full_url'] = thumbnailFullUrl;
    return data;
  }
}