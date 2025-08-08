class VehicleListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Vehicles>? vehicles;

  VehicleListModel({this.totalSize, this.limit, this.offset, this.vehicles});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add(Vehicles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (vehicles != null) {
      data['vehicles'] = vehicles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicles {
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
  List<String>? tag;
  String? documents;
  int? status;
  int? newTag;
  int? totalTrip;
  String? avgRating;
  int? totalReviews;
  String? createdAt;
  String? updatedAt;
  String? thumbnailFullUrl;
  List<String>? imagesFullUrl;
  List<String>? documentsFullUrl;
  List<Translation>? translations;
  Provider? provider;
  Category? category;
  Category? brand;
  List<Identities>? vehicleIdentities;

  Vehicles({
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
    this.thumbnailFullUrl,
    this.imagesFullUrl,
    this.documentsFullUrl,
    this.translations,
    this.provider,
    this.category,
    this.brand,
    this.vehicleIdentities,
  });

  Vehicles.fromJson(Map<String, dynamic> json) {
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
    hourlyPrice = double.parse(json['hourly_price'].toString());
    distancePrice = double.parse(json['distance_price'].toString());
    discountType = json['discount_type'];
    discountPrice = double.parse(json['discount_price'].toString());
    if (json['tag'] != null) {
      tag = <String>[];
      json['tag'].forEach((v) {
        tag!.add(v.toString());
      });
    }
    documents = json['documents'];
    status = json['status'];
    newTag = json['new_tag'];
    totalTrip = json['total_trip'];
    avgRating = json['avg_rating'].toString();
    totalReviews = json['total_reviews'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailFullUrl = json['thumbnail_full_url'];
    imagesFullUrl = json['images_full_url'].cast<String>();
    documentsFullUrl = json['documents_full_url'].cast<String>();
    if (json['translations'] != null && json['translations'].isNotEmpty) {
      translations = [];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }else {
      translations = [];
      translations!.add(Translation(id: 0, locale: 'en', key: 'name', value: json['name']));
      translations!.add(Translation(id: 0, locale: 'en', key: 'description', value: json['description']));
    }
    provider = json['provider'] != null ? Provider.fromJson(json['provider']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    brand = json['brand'] != null ? Category.fromJson(json['brand']) : null;
    if (json['vehicle_identities'] != null) {
      vehicleIdentities = <Identities>[];
      json['vehicle_identities'].forEach((v) {
        vehicleIdentities!.add(Identities.fromJson(v));
      });
    }
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
    data['thumbnail_full_url'] = thumbnailFullUrl;
    data['images_full_url'] = imagesFullUrl;
    data['documents_full_url'] = documentsFullUrl;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    if (provider != null) {
      data['provider'] = provider!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (vehicleIdentities != null) {
      data['vehicle_identities'] = vehicleIdentities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Provider {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? logo;
  String? latitude;
  String? longitude;
  String? address;
  String? footerText;
  int? minimumOrder;
  bool? scheduleOrder;
  int? status;
  int? vendorId;
  String? createdAt;
  String? updatedAt;
  bool? freeDelivery;
  List<int>? rating;
  String? coverPhoto;
  bool? delivery;
  bool? takeAway;
  bool? itemSection;
  double? tax;
  int? zoneId;
  bool? reviewsSection;
  bool? active;
  String? offDay;
  int? selfDeliverySystem;
  bool? posSystem;
  int? minimumShippingCharge;
  String? deliveryTime;
  int? veg;
  int? nonVeg;
  int? orderCount;
  int? totalOrder;
  int? moduleId;
  int? orderPlaceToScheduleInterval;
  int? featured;
  int? perKmShippingCharge;
  bool? prescriptionOrder;
  String? slug;
  int? announcement;
  String? announcementMessage;
  String? storeBusinessModel;
  int? packageId;
  bool? gstStatus;
  String? gstCode;
  String? logoFullUrl;
  String? coverPhotoFullUrl;

  Provider({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.logo,
    this.latitude,
    this.longitude,
    this.address,
    this.footerText,
    this.minimumOrder,
    this.scheduleOrder,
    this.status,
    this.vendorId,
    this.createdAt,
    this.updatedAt,
    this.freeDelivery,
    this.rating,
    this.coverPhoto,
    this.delivery,
    this.takeAway,
    this.itemSection,
    this.tax,
    this.zoneId,
    this.reviewsSection,
    this.active,
    this.offDay,
    this.selfDeliverySystem,
    this.posSystem,
    this.minimumShippingCharge,
    this.deliveryTime,
    this.veg,
    this.nonVeg,
    this.orderCount,
    this.totalOrder,
    this.moduleId,
    this.orderPlaceToScheduleInterval,
    this.featured,
    this.perKmShippingCharge,
    this.prescriptionOrder,
    this.slug,
    this.announcement,
    this.announcementMessage,
    this.storeBusinessModel,
    this.packageId,
    this.gstStatus,
    this.gstCode,
    this.logoFullUrl,
    this.coverPhotoFullUrl,
  });

  Provider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    footerText = json['footer_text'];
    minimumOrder = json['minimum_order'];
    scheduleOrder = json['schedule_order'];
    status = json['status'];
    vendorId = json['vendor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    freeDelivery = json['free_delivery'];
    rating = json['rating'].cast<int>();
    coverPhoto = json['cover_photo'];
    delivery = json['delivery'];
    takeAway = json['take_away'];
    itemSection = json['item_section'];
    tax = json['tax'].toDouble();
    zoneId = json['zone_id'];
    reviewsSection = json['reviews_section'];
    active = json['active'];
    offDay = json['off_day'];
    selfDeliverySystem = json['self_delivery_system'];
    posSystem = json['pos_system'];
    minimumShippingCharge = json['minimum_shipping_charge'];
    deliveryTime = json['delivery_time'];
    veg = json['veg'];
    nonVeg = json['non_veg'];
    orderCount = json['order_count'];
    totalOrder = json['total_order'];
    moduleId = json['module_id'];
    orderPlaceToScheduleInterval = json['order_place_to_schedule_interval'];
    featured = json['featured'];
    perKmShippingCharge = json['per_km_shipping_charge'];
    prescriptionOrder = json['prescription_order'];
    slug = json['slug'];
    announcement = json['announcement'];
    announcementMessage = json['announcement_message'];
    storeBusinessModel = json['store_business_model'];
    packageId = json['package_id'];
    gstStatus = json['gst_status'];
    gstCode = json['gst_code'];
    logoFullUrl = json['logo_full_url'];
    coverPhotoFullUrl = json['cover_photo_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['logo'] = logo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['footer_text'] = footerText;
    data['minimum_order'] = minimumOrder;
    data['schedule_order'] = scheduleOrder;
    data['status'] = status;
    data['vendor_id'] = vendorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['free_delivery'] = freeDelivery;
    data['rating'] = rating;
    data['cover_photo'] = coverPhoto;
    data['delivery'] = delivery;
    data['take_away'] = takeAway;
    data['item_section'] = itemSection;
    data['tax'] = tax;
    data['zone_id'] = zoneId;
    data['reviews_section'] = reviewsSection;
    data['active'] = active;
    data['off_day'] = offDay;
    data['self_delivery_system'] = selfDeliverySystem;
    data['pos_system'] = posSystem;
    data['minimum_shipping_charge'] = minimumShippingCharge;
    data['delivery_time'] = deliveryTime;
    data['veg'] = veg;
    data['non_veg'] = nonVeg;
    data['order_count'] = orderCount;
    data['total_order'] = totalOrder;
    data['module_id'] = moduleId;
    data['order_place_to_schedule_interval'] = orderPlaceToScheduleInterval;
    data['featured'] = featured;
    data['per_km_shipping_charge'] = perKmShippingCharge;
    data['prescription_order'] = prescriptionOrder;
    data['slug'] = slug;
    data['announcement'] = announcement;
    data['announcement_message'] = announcementMessage;
    data['store_business_model'] = storeBusinessModel;
    data['package_id'] = packageId;
    data['gst_status'] = gstStatus;
    data['gst_code'] = gstCode;
    data['logo_full_url'] = logoFullUrl;
    data['cover_photo_full_url'] = coverPhotoFullUrl;
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? imageFullUrl;

  Category({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageFullUrl,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageFullUrl = json['image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_full_url'] = imageFullUrl;
    return data;
  }
}

class Identities {
  int? id;
  int? vehicleId;
  int? providerId;
  String? vinNumber;
  String? licensePlateNumber;
  String? createdAt;
  String? updatedAt;

  Identities({
    this.id,
    this.vehicleId,
    this.providerId,
    this.vinNumber,
    this.licensePlateNumber,
    this.createdAt,
    this.updatedAt,
  });

  Identities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    providerId = json['provider_id'];
    vinNumber = json['vin_number'];
    licensePlateNumber = json['license_plate_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_id'] = vehicleId;
    data['provider_id'] = providerId;
    data['vin_number'] = vinNumber;
    data['license_plate_number'] = licensePlateNumber;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Translation {
  int? id;
  String? locale;
  String? key;
  String? value;

  Translation({this.id, this.locale, this.key, this.value});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
