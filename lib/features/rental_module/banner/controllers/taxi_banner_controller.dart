import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/models/taxi_banner_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/banner/domain/services/taxi_banner_service_interface.dart';

class TaxiBannerController extends GetxController implements GetxService {
  final TaxiBannerServiceInterface taxiBannerServiceInterface;
  TaxiBannerController({required this.taxiBannerServiceInterface});

  List<Banners>? _taxiBannerList;
  List<Banners>? get taxiBannerList => _taxiBannerList;

  int? _pageSize;
  int? get pageSize => _pageSize;

  final List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Banners? _taxiBannerDetails;
  Banners? get taxiBannerDetails => _taxiBannerDetails;

  Future<void> addBanner({required Banners? taxiBanner, required XFile image}) async {
    _isLoading = true;
    update();
    bool isSuccess = await taxiBannerServiceInterface.addBanner(taxiBanner: taxiBanner, image: image);
    if(isSuccess) {
      getBannerList(offset: '1');
      Get.back();
      showCustomSnackBar('banner_added_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> getBannerList({required String offset, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _taxiBannerList = null;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      BannerListModel? bannerListModel = await taxiBannerServiceInterface.getBannerList(offset: offset);
      if (bannerListModel != null) {
        if (offset == '1') {
          _taxiBannerList = [];
        }
        _taxiBannerList?.addAll(bannerListModel.banners ?? []);
        _pageSize = bannerListModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if(isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  Future<void> deleteBanner(int? bannerID) async {
    _isLoading = true;
    update();
    bool isSuccess = await taxiBannerServiceInterface.deleteBanner(bannerID);
    if(isSuccess) {
      await getBannerList(offset: '1');
      Get.back();
      showCustomSnackBar('banner_deleted_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> updateBanner({required Banners? taxiBanner, XFile? image}) async {
    _isLoading = true;
    update();
    bool isSuccess = await taxiBannerServiceInterface.updateBanner(taxiBanner: taxiBanner, image: image);
    if(isSuccess) {
      await getBannerList(offset: '1');
      Get.back();
      showCustomSnackBar('banner_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<Banners?> getBannerDetails(int id) async {
    _taxiBannerDetails = null;
    Banners? taxiBannerDetails = await taxiBannerServiceInterface.getBannerDetails(id);
    if(taxiBannerDetails != null) {
      _taxiBannerDetails = taxiBannerDetails;
    }
    update();
    return _taxiBannerDetails;
  }

}