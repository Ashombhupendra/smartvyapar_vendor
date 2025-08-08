import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class TaxiProfileRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getProfileInfo();
  Future<dynamic> updateProfile(TaxiProfileModel userInfoModel, XFile? data, String token);
  Future<dynamic> deleteVendor();
  updateHeader(int? moduleID);
}