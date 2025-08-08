class BannerListModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Banners>? banners;

  BannerListModel({this.totalSize, this.limit, this.offset, this.banners});

  BannerListModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banners {
  int? id;
  String? title;
  String? type;
  String? image;
  bool? status;
  int? data;
  String? createdAt;
  String? updatedAt;
  int? zoneId;
  int? moduleId;
  bool? featured;
  String? defaultLink;
  String? createdBy;
  String? imageFullUrl;
  List<Translation>? translations;

  Banners({
    this.id,
    this.title,
    this.type,
    this.image,
    this.status,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.zoneId,
    this.moduleId,
    this.featured,
    this.defaultLink,
    this.createdBy,
    this.imageFullUrl,
    this.translations,
  });

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    image = json['image'];
    status = json['status'];
    data = json['data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    featured = json['featured'];
    defaultLink = json['default_link'];
    createdBy = json['created_by'];
    imageFullUrl = json['image_full_url'];
    if (json['translations'] != null) {
      translations = <Translation>[];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['image'] = image;
    data['status'] = status;
    data['data'] = this.data;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['zone_id'] = zoneId;
    data['module_id'] = moduleId;
    data['featured'] = featured;
    data['default_link'] = defaultLink;
    data['created_by'] = createdBy;
    data['image_full_url'] = imageFullUrl;
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Translation {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;

  Translation({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
  });

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    return data;
  }
}
