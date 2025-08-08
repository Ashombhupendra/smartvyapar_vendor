import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/models/taxi_banner_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/repositories/taxi_banner_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/services/taxi_banner_service_interface.dart';

class TaxiBannerService implements TaxiBannerServiceInterface {
  final TaxiBannerRepositoryInterface taxiBannerRepositoryInterface;
  TaxiBannerService({required this.taxiBannerRepositoryInterface});

  @override
  Future<bool> addBanner({required Banners? taxiBanner, required XFile image}) async {
    return await taxiBannerRepositoryInterface.addBanner(taxiBanner: taxiBanner, image: image);
  }

  @override
  Future<BannerListModel?> getBannerList({required String offset}) async {
    return await taxiBannerRepositoryInterface.getBannerList(offset: offset);
  }

  @override
  Future<bool> deleteBanner(int? bannerID) async {
    return await taxiBannerRepositoryInterface.delete(bannerID);
  }

  @override
  Future<bool> updateBanner({required Banners? taxiBanner, XFile? image}) async {
    return await taxiBannerRepositoryInterface.updateBanner(taxiBanner: taxiBanner, image: image);
  }

  @override
  Future<Banners?> getBannerDetails(int id) async {
    return await taxiBannerRepositoryInterface.get(id);
  }

}