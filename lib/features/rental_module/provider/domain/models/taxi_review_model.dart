class TaxiReviewModel {
  int? id;
  int? providerId;
  int? moduleId;
  int? userId;
  int? tripId;
  int? vehicleId;
  int? vehicleIdentityId;
  int? rating;
  String? comment;
  int? status;
  String? reply;
  String? reviewId;
  String? repliedAt;
  String? createdAt;
  String? updatedAt;
  String? vehicleName;
  String? vehicleImage;
  String? customerName;
  String? customerPhone;
  String? vehicleImageFullUrl;

  TaxiReviewModel({
    this.id,
    this.providerId,
    this.moduleId,
    this.userId,
    this.tripId,
    this.vehicleId,
    this.vehicleIdentityId,
    this.rating,
    this.comment,
    this.status,
    this.reply,
    this.reviewId,
    this.repliedAt,
    this.createdAt,
    this.updatedAt,
    this.vehicleName,
    this.vehicleImage,
    this.customerName,
    this.customerPhone,
    this.vehicleImageFullUrl
  });

  TaxiReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    moduleId = json['module_id'];
    userId = json['user_id'];
    tripId = json['trip_id'];
    vehicleId = json['vehicle_id'];
    vehicleIdentityId = json['vehicle_identity_id'];
    rating = json['rating'];
    comment = json['comment'];
    status = json['status'];
    reply = json['reply'];
    reviewId = json['review_id'];
    repliedAt = json['replied_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicleName = json['vehicle_name'];
    vehicleImage = json['vehicle_image'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    vehicleImageFullUrl = json['vehicle_image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provider_id'] = providerId;
    data['module_id'] = moduleId;
    data['user_id'] = userId;
    data['trip_id'] = tripId;
    data['vehicle_id'] = vehicleId;
    data['vehicle_identity_id'] = vehicleIdentityId;
    data['rating'] = rating;
    data['comment'] = comment;
    data['status'] = status;
    data['reply'] = reply;
    data['review_id'] = reviewId;
    data['replied_at'] = repliedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['vehicle_name'] = vehicleName;
    data['vehicle_image'] = vehicleImage;
    data['customer_name'] = customerName;
    data['customer_phone'] = customerPhone;
    data['vehicle_image_full_url'] = vehicleImageFullUrl;
    return data;
  }
}