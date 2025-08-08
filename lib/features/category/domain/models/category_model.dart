class CategoryModel {
  int? _id;
  String? _name;
  String? _imageFullUrl;

  CategoryModel({
    int? id,
    String? name,
    int? parentId,
    int? position,
    int? status,
    String? createdAt,
    String? updatedAt,
    String? imageFullUrl,
  }) {
    _id = id;
    _name = name;
    _imageFullUrl = imageFullUrl;
  }

  int? get id => _id;
  String? get name => _name;
  String? get imageFullUrl => _imageFullUrl;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _imageFullUrl = json['image_full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['image_full_url'] = _imageFullUrl;
    return data;
  }
}