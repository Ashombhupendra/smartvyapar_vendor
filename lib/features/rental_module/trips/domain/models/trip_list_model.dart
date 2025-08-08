import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';

class TripListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Trips>? trips;

  TripListModel({this.totalSize, this.limit, this.offset, this.trips});

  TripListModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['trips'] != null) {
      trips = <Trips>[];
      json['trips'].forEach((v) {
        trips!.add(Trips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (trips != null) {
      data['trips'] = trips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trips {
  int? id;
  int? userId;
  int? providerId;
  int? zoneId;
  int? moduleId;
  int? cashBackId;
  int? tripDetailsId;
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
  int? isGuest;
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

  Trips({
    this.id,
    this.userId,
    this.providerId,
    this.zoneId,
    this.moduleId,
    this.cashBackId,
    this.tripDetailsId,
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
  });

  Trips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    providerId = json['provider_id'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    cashBackId = json['cash_back_id'];
    tripDetailsId = json['trip_details_id'];
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
    isGuest = json['is_guest'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['provider_id'] = providerId;
    data['zone_id'] = zoneId;
    data['module_id'] = moduleId;
    data['cash_back_id'] = cashBackId;
    data['trip_details_id'] = tripDetailsId;
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
    return data;
  }
}