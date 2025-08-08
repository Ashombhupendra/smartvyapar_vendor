import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/models/taxi_constant_type_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/models/driver_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/driver/domain/services/driver_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:http/http.dart' as http;

class DriverController extends GetxController implements GetxService {
  final DriverServiceInterface driverServiceInterface;
  DriverController({required this.driverServiceInterface});

  int? _pageSize;
  int? get pageSize => _pageSize;

  final List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Drivers>? _driversList;
  List<Drivers>? get driversList => _driversList;

  XFile? _profileImage;
  XFile? get profileImage => _profileImage;

  final List<TaxiConstantTypeModel> _identityType = TaxiConstantTypeModel.getIdentityTypeList();
  List<TaxiConstantTypeModel> get identityType => _identityType;

  String? _selectedIdentityType;
  String? get selectedIdentityType => _selectedIdentityType;

  String? _selectedIdentityTypeKey;
  String? get selectedIdentityTypeKey => _selectedIdentityTypeKey;

  final List<XFile> _identityImages = [];
  List<XFile> get identityImages => _identityImages;

  bool _driverStatus = false;
  bool get driverStatus => _driverStatus;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  bool _isSearchVisible = false;
  bool get isSearchVisible => _isSearchVisible;

  DriverDetailsModel? _driverDetails;
  DriverDetailsModel? get driverDetails => _driverDetails;

  List<Trips>? _confirmedTrips;
  List<Trips>? get confirmedTrips => _confirmedTrips;

  List<Trips>? _ongoingTrips;
  List<Trips>? get ongoingTrips => _ongoingTrips;

  List<Trips>? _completedTrips;
  List<Trips>? get completedTrips => _completedTrips;

  List<Trips>? _cancelledTrips;
  List<Trips>? get cancelledTrips => _cancelledTrips;

  int? _selectedStatusIndex;
  int? get selectedStatusIndex => _selectedStatusIndex;

  String? _selectedStatus = 'confirmed';
  String? get selectedStatus => _selectedStatus;

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setSearchVisibility() {
    _isSearchVisible = !_isSearchVisible;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<void> getDriverList({required String offset, String? search, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _driversList = null;
      _isSearching = search!.isNotEmpty;
      if (willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      DriverListModel? driverListModel = await driverServiceInterface.getDriverList(offset: offset, search: search);
      if (driverListModel != null) {
        if (offset == '1') {
          _driversList = [];
        }
        _driversList?.addAll(driverListModel.drivers ?? []);
        _pageSize = driverListModel.totalSize;
        _isLoading = false;
        update();
      }
    } else {
      if (_isLoading) {
        _isLoading = false;
        update();
      }
    }
  }

  void pickImage({bool isRemove = false}) async {
    if(isRemove) {
      _profileImage = null;
    }else {
      _profileImage = await driverServiceInterface.pickImageFromGallery();
      update();
    }
  }

  void pickVehicleImages() async {
    XFile? xFile = await driverServiceInterface.pickImageFromGallery();
    if(xFile != null){
      _identityImages.add(xFile);
    }
    update();
  }

  Future<XFile?> urlToXFile(String imageUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${imageUrl.split('/').last}';

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return XFile(filePath);
      } else {
        showCustomSnackBar('${'failed_to_download_file'.tr} ${response.statusCode}');
        return null;
      }
    } catch (e) {
      showCustomSnackBar('Error occurred while converting URL to XFile: $e');
      return null;
    }
  }

  void saveIdentityImages(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _identityImages.add(xFile);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearIdentityImage() {
    _identityImages.clear();
  }

  void removeIdentityImage(int index) {
    _identityImages.removeAt(index);
    update();
  }

  void setSelectedIdentityInitData(String? identityType) {
    _selectedIdentityType = _identityType.firstWhere((element) => element.key == identityType).value;
    _selectedIdentityTypeKey = identityType;
  }

  void setSelectedIdentityType(String? identityType) {
    _selectedIdentityType = identityType;
    update();
  }

  void setSelectedIdentityTypeKey(String? identityTypeKey) {
    _selectedIdentityTypeKey = identityTypeKey;
    update();
  }

  Future<void> addDriver({required Drivers driver, bool isUpdate = false}) async {
    _isLoading = true;
    update();

    bool isSuccess = await driverServiceInterface.addDriver(driver: driver, profileImage: _profileImage, identityImage: _identityImages, isUpdate: isUpdate);
    if(isSuccess) {
      await getDriverList(offset: '1', search: '');
      Get.back();
      showCustomSnackBar(isUpdate ? 'driver_updated_successfully'.tr : 'driver_added_successfully'.tr, isError: false);
    }

    _isLoading = false;
    update();
  }

  Future<void> deleteDriver({required int driverId}) async {
    _isLoading = true;
    update();

    bool isSuccess = await driverServiceInterface.deleteDriver(id: driverId);
    if(isSuccess) {
      await getDriverList(offset: '1', search: '');
      showCustomSnackBar('driver_deleted_successfully'.tr, isError: false);
    }

    _isLoading = false;
    update();
  }

  Future<void> updateDriverStatus({required int driverId}) async {
    bool isSuccess = await driverServiceInterface.updateDriverStatus(driverId: driverId);
    if(isSuccess) {
      await getDriverList(offset: '1', search: '');
      _driverStatus = !_driverStatus;
      showCustomSnackBar('driver_status_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setDriverStatus(bool status) {
    _driverStatus = status;
  }

  Future<void> getDriverDetails({required int driverId}) async {
    DriverDetailsModel? driverDetailsModel = await driverServiceInterface.getDriverDetails(driverId: driverId);
    if(driverDetailsModel != null) {
      _driverDetails = driverDetailsModel;
      _confirmedTrips = [];
      _ongoingTrips = [];
      _completedTrips = [];
      _cancelledTrips = [];
      for(int index = 0; index < driverDetailsModel.allTrips!.length; index++) {
        if(driverDetailsModel.allTrips![index].trip?.tripStatus == 'confirmed') {
          _confirmedTrips?.add(driverDetailsModel.allTrips![index].trip!);
        }else if(driverDetailsModel.allTrips![index].trip?.tripStatus == 'ongoing') {
          _ongoingTrips?.add(driverDetailsModel.allTrips![index].trip!);
        }else if(driverDetailsModel.allTrips![index].trip?.tripStatus == 'completed') {
          _completedTrips?.add(driverDetailsModel.allTrips![index].trip!);
        }else if(driverDetailsModel.allTrips![index].trip?.tripStatus == 'canceled') {
          _cancelledTrips?.add(driverDetailsModel.allTrips![index].trip!);
        }
      }
    }
    update();
  }

  void setSelectedStatusIndex(int? index, String? status) {
    _selectedStatusIndex = index;
    _selectedStatus = status;
    update();
  }
  
}