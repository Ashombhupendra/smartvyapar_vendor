import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/repositories/driver_repository_interface.dart';
import 'package:sixam_mart_store/util/app_constants.dart';

class DriverRepository implements DriverRepositoryInterface {
  final ApiClient apiClient;
  DriverRepository({required this.apiClient});

  @override
  Future<DriverListModel?> getDriverList({required String offset, String? search}) async {
    DriverListModel? driverListModel;
    Response response = await apiClient.getData('${AppConstants.taxiDriverListUri}?limit=10&offset=$offset&search=$search');
    if(response.statusCode == 200) {
      driverListModel = DriverListModel.fromJson(response.body);
    }
    return driverListModel;
  }

  @override
  Future<bool> addDriver({required Drivers driver, required XFile? profileImage, required List<XFile> identityImage, bool isUpdate = false}) async {
    Map<String, String> fields = {};

    fields.addAll({
      'first_name': driver.firstName ?? '',
      'last_name': driver.lastName ?? '',
      'email': driver.email ?? '',
      'phone': driver.phone ?? '',
      'identity_type': driver.identityType ?? '',
      'identity_number': driver.identityNumber ?? '',
    });

    List<MultipartBody> images = [];
    images.add(MultipartBody('image', profileImage));
    for(int index = 0; index < identityImage.length; index++) {
      images.add(MultipartBody('identity_image[$index]', identityImage[index]));
    }

    Response response = await apiClient.postMultipartData(isUpdate ? '${AppConstants.taxiUpdateDriverUri}/${driver.id}' : AppConstants.taxiAddDriverUri, fields, images);
    return response.statusCode == 200;
  }

  @override
  Future<bool> delete(int? id) async{
    Response response = await apiClient.deleteData('${AppConstants.taxiDeleteDriverUri}/$id', handleError: false);
    return response.statusCode == 200;
  }

  @override
  Future<bool> updateDriverStatus({required int driverId}) async {
    Response response = await apiClient.getData('${AppConstants.taxiUpdateDriverStatusUri}/$driverId', handleError: false);
    return response.statusCode == 200;
  }

  @override
  Future<DriverDetailsModel?> getDriverDetails({int? driverId}) async {
    DriverDetailsModel? driverDetailsModel;
    Response response = await apiClient.getData('${AppConstants.taxiDriverDetailsUri}/$driverId');
    if(response.statusCode == 200) {
      driverDetailsModel = DriverDetailsModel.fromJson(response.body);
    }
    return driverDetailsModel;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future get(int? id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}