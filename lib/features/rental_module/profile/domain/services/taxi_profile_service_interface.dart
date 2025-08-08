import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/models/response_model.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';

abstract class TaxiProfileServiceInterface {
  Future<TaxiProfileModel?> getProfileInfo();
  Future<bool> updateProfile(TaxiProfileModel userInfoModel, XFile? data, String token);
  Future<ResponseModel> deleteVendor();
  updateHeader(int? moduleID);
}