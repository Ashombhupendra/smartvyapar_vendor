class VehicleCategoryModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Categories>? categories;

  VehicleCategoryModel({this.totalSize, this.limit, this.offset, this.categories});

  VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? image;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? imageFullUrl;

  Categories({
    this.id,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageFullUrl,
  });

  Categories.fromJson(Map<String, dynamic> json) {
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
