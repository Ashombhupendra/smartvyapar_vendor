import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/interface/repository_interface.dart';

abstract class DriverRepositoryInterface extends RepositoryInterface {
  Future<DriverListModel?> getDriverList({required String offset, String? search});
  Future<bool> addDriver({required Drivers driver, required XFile? profileImage, required List<XFile> identityImage, bool isUpdate = false});
  Future<bool> updateDriverStatus({required int driverId});
  Future<DriverDetailsModel?> getDriverDetails({int? driverId});
}