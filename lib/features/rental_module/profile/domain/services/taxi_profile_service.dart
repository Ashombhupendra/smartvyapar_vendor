import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/repositories/taxi_profile_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/services/taxi_profile_service_interface.dart';

class TaxiProfileService implements TaxiProfileServiceInterface {
  final TaxiProfileRepositoryInterface taxiProfileRepositoryInterface;
  TaxiProfileService({required this.taxiProfileRepositoryInterface});

  @override
  Future<TaxiProfileModel?> getProfileInfo() async {
    return await taxiProfileRepositoryInterface.getProfileInfo();
  }

  @override
  Future<bool> updateProfile(TaxiProfileModel userInfoModel, XFile? data, String token) async {
    return await taxiProfileRepositoryInterface.updateProfile(userInfoModel, data, token);
  }

  @override
  Future<ResponseModel> deleteVendor() async {
    return await taxiProfileRepositoryInterface.deleteVendor();
  }

  @override
  void updateHeader(int? moduleID) {
    taxiProfileRepositoryInterface.updateHeader(moduleID);
  }

}