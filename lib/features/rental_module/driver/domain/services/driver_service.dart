import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/repositories/driver_repository_interface.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/services/driver_service_interface.dart';

class DriverService implements DriverServiceInterface{
  final DriverRepositoryInterface driverRepositoryInterface;
  DriverService({required this.driverRepositoryInterface});

  @override
  Future<DriverListModel?> getDriverList({required String offset, String? search}) async {
    return await driverRepositoryInterface.getDriverList(offset: offset, search: search);
  }

  @override
  Future<bool> addDriver({required Drivers driver, required XFile? profileImage, required List<XFile> identityImage, bool isUpdate = false}) async {
    return await driverRepositoryInterface.addDriver(driver: driver, profileImage: profileImage, identityImage: identityImage, isUpdate: isUpdate);
  }

  @override
  Future<bool> deleteDriver({required int id}) async {
    return await driverRepositoryInterface.delete(id);
  }

  @override
  Future<bool> updateDriverStatus({required int driverId}) async {
    return await driverRepositoryInterface.updateDriverStatus(driverId: driverId);
  }

  @override
  Future<DriverDetailsModel?> getDriverDetails({int? driverId}) async {
    return await driverRepositoryInterface.getDriverDetails(driverId: driverId);
  }

  @override
  Future<XFile?> pickImageFromGallery() async {
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      int imageSize = await pickImage.length();
      if (imageSize > 1000000) {
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return pickImage;
      }
    }
    return pickImage;
  }

}