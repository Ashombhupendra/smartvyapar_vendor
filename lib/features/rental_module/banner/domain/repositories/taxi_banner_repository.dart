import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/models/taxi_banner_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/repositories/taxi_banner_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:get/get.dart';

class TaxiBannerRepository implements TaxiBannerRepositoryInterface {
  final ApiClient apiClient;
  TaxiBannerRepository({required this.apiClient});

  @override
  Future<bool> addBanner({required Banners? taxiBanner, required XFile image}) async {
    Map<String, String> body = {};
    body.addAll({
      'translations': jsonEncode(taxiBanner?.translations),
      'default_link': taxiBanner?.defaultLink ?? ''
    });
    Response response = await apiClient.postMultipartData(AppConstants.taxiAddBannerUri, body, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future<BannerListModel?> getBannerList({required String offset}) async {
    BannerListModel? bannerListModel;
    Response response = await apiClient.getData('${AppConstants.taxiBannerListUri}?offset=$offset&limit=10');
    if(response.statusCode == 200) {
      bannerListModel = BannerListModel.fromJson(response.body);
    }
    return bannerListModel;
  }

  @override
  Future<bool> delete(int? id) async {
    Response response = await apiClient.deleteData('${AppConstants.taxiDeleteBannerUri}/$id');
    return (response.statusCode == 200);
  }

  @override
  Future<bool> updateBanner({required Banners? taxiBanner, XFile? image}) async {
    Map<String, String> body = {};
    body.addAll({
      'translations': jsonEncode(taxiBanner?.translations),
      'default_link': taxiBanner?.defaultLink ?? ''
    });
    Response response = await apiClient.postMultipartData('${AppConstants.taxiUpdateBannerUri}/${taxiBanner?.id}', body, [MultipartBody('image', image)]);
    return (response.statusCode == 200);
  }

  @override
  Future<Banners?> get(int? id) async {
    Banners? bannersDetails;
    Response response = await apiClient.getData('${AppConstants.taxiBannerDetailsUri}/$id');
    if(response.statusCode == 200) {
      bannersDetails = Banners.fromJson(response.body);
    }
    return bannersDetails;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

}