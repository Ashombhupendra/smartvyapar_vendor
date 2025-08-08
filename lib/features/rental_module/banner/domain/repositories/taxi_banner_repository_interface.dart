import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/models/taxi_banner_list_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class TaxiBannerRepositoryInterface extends RepositoryInterface {
  Future<dynamic> addBanner({required Banners? taxiBanner, required XFile image});
  Future<dynamic> updateBanner({required Banners? taxiBanner, XFile? image});
  Future<BannerListModel?> getBannerList({required String offset});
}