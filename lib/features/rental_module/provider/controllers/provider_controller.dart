import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sixam_mart_store/api/api_client.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/taxi_review_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_brand_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_category_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/vehicle_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/services/provider_service_interface.dart';
import 'package:sixam_mart_store/features/rental_module/profile/domain/models/taxi_profile_model.dart';
import 'package:sixam_mart_store/features/rental_module/common/models/taxi_constant_type_model.dart';

class ProviderController extends GetxController implements GetxService {
  final ProviderServiceInterface providerServiceInterface;
  ProviderController({required this.providerServiceInterface});

  bool _isTripTypeHourly = false;
  bool get isTripTypeHourly => _isTripTypeHourly;

  bool _isTripTypeDistanceWise = false;
  bool get isTripTypeDistanceWise => _isTripTypeDistanceWise;

  bool _isAc = false;
  bool get isAc => _isAc;

  bool _isSameModelMultipleVehicle = false;
  bool get isSameModelMultipleVehicle => _isSameModelMultipleVehicle;

  List<TextEditingController> _vinNumberControllerList = [TextEditingController()];
  List<TextEditingController> get vinNumberControllerList => _vinNumberControllerList;

  List<TextEditingController> _licensePlateNumberControllerList = [TextEditingController()];
  List<TextEditingController> get licensePlateNumberControllerList => _licensePlateNumberControllerList;

  XFile? _logo;
  XFile? get logo => _logo;

  XFile? _cover;
  XFile? get cover => _cover;

  XFile? _vehicleThumbnail;
  XFile? get vehicleThumbnail => _vehicleThumbnail;

  final List<XFile> _vehicleImages = [];
  List<XFile> get vehicleImages => _vehicleImages;

  final List<FilePickerResult> _licenseFiles = [];
  List<FilePickerResult>? get licenseFiles => _licenseFiles;

  Vehicles? _vehicleDetailsModel;
  Vehicles? get vehicleDetailsModel => _vehicleDetailsModel;

  Vehicles? _vehicleDetailsWithTrans;
  Vehicles? get vehicleDetailsWithTrans => _vehicleDetailsWithTrans;

  bool _vehicleActive = false;
  bool get vehicleActive => _vehicleActive;

  bool _vehicleNewTag = false;
  bool get vehicleNewTag => _vehicleNewTag;

  int? _currentVehicleImageIndex = 0;
  int? get currentVehicleImageIndex => _currentVehicleImageIndex;

  int? _categoryPageSize;
  int? get categoryPageSize => _categoryPageSize;

  int? _vehiclePageSize;
  int? get vehiclePageSize => _vehiclePageSize;

  int? _brandPageSize;
  int? get brandPageSize => _brandPageSize;

  final List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Vehicles>? _vehicleList;
  List<Vehicles>? get vehicleList => _vehicleList;

  List<Categories>? _categories;
  List<Categories>? get categoriesList => _categories;

  List<Categories>? _vehicleCategoryList;
  List<Categories>? get vehicleCategoryList => _vehicleCategoryList;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  String? _selectedCategoryId;
  String? get selectedCategoryId => _selectedCategoryId;

  int? _selectedCategoryIndex = 0;
  int? get selectedCategoryIndex => _selectedCategoryIndex;

  List<Brands>? _brandsList;
  List<Brands>? get brandsList => _brandsList;

  String? _selectedBrand;
  String? get selectedBrand => _selectedBrand;

  String? _selectedBrandId;
  String? get selectedBrandId => _selectedBrandId;

  final List<TaxiConstantTypeModel> _vehicleTypeList = TaxiConstantTypeModel.getVehicleTypeList();
  List<TaxiConstantTypeModel> get vehicleTypeList => _vehicleTypeList;

  String? _selectedVehicleType;
  String? get selectedVehicleType => _selectedVehicleType;

  String? _selectedVehicleTypeKey;
  String? get selectedVehicleTypeKey => _selectedVehicleTypeKey;

  final List<TaxiConstantTypeModel> _fuelTypeList = TaxiConstantTypeModel.getFuelTypeList();
  List<TaxiConstantTypeModel> get fuelTypeList => _fuelTypeList;

  String? _selectedFuelType;
  String? get selectedFuelType => _selectedFuelType;

  String? _selectedFuelTypeKey;
  String? get selectedFuelTypeKey => _selectedFuelTypeKey;

  final List<TaxiConstantTypeModel> _transmissionTypeList = TaxiConstantTypeModel.getTransmissionTypeList();
  List<TaxiConstantTypeModel> get transmissionTypeList => _transmissionTypeList;

  String? _selectedTransmissionType;
  String? get selectedTransmissionType => _selectedTransmissionType;

  String? _selectedTransmissionTypeKey;
  String? get selectedTransmissionTypeKey => _selectedTransmissionTypeKey;

  final List<TaxiConstantTypeModel> _seatList = TaxiConstantTypeModel.getVehicleSeatList();
  List<TaxiConstantTypeModel> get seatList => _seatList;

  final List<TaxiConstantTypeModel> _coolingList = TaxiConstantTypeModel.getVehicleCoolingList();
  List<TaxiConstantTypeModel> get coolingList => _coolingList;

  List<String?> _tagList = [];
  List<String?> get tagList => _tagList;

  String? _discountType;
  String? get discountType => _discountType;

  String? _discountTypeKey;
  String? get discountTypeKey => _discountTypeKey;

  List<Schedules>? _scheduleList;
  List<Schedules>? get scheduleList => _scheduleList;

  bool _scheduleLoading = false;
  bool get scheduleLoading => _scheduleLoading;

  bool _scheduleTripStatus = false;
  bool get scheduleTripStatus => _scheduleTripStatus;

  bool _gstStatus = false;
  bool get gstStatus => _gstStatus;

  final List<TaxiConstantTypeModel> _durations = TaxiConstantTypeModel.getTimeDurationList();
  List<TaxiConstantTypeModel> get durations => _durations;

  String? _selectedDuration;
  String? get selectedDuration => _selectedDuration;

  String? _selectedDurationKey;
  String? get selectedDurationKey => _selectedDurationKey;

  List<TaxiReviewModel>? _providerReviewList;
  List<TaxiReviewModel>? get providerReviewList => _providerReviewList;

  List<TaxiReviewModel>? _searchReviewList;
  List<TaxiReviewModel>? get searchReviewList => _searchReviewList;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  String? _filterSelectedBrand;
  String? get filterSelectedBrand => _filterSelectedBrand;

  String? _filterSelectedVehicleType;
  String? get filterSelectedVehicleType => _filterSelectedVehicleType;

  String? _filterSelectedSeat;
  String? get filterSelectedSeat => _filterSelectedSeat;

  String? _filterSelectedCooling;
  String? get filterSelectedCooling => _filterSelectedCooling;

  String? _isCooling;
  String? get isCooling => _isCooling;

  String? _filterSelectedTransmissionType;
  String? get filterSelectedTransmissionType => _filterSelectedTransmissionType;

  String? _filterSelectedFuelType;
  String? get filterSelectedFuelType => _filterSelectedFuelType;

  bool _isFabVisible = true;
  bool get isFabVisible => _isFabVisible;

  bool _isSearchVisible = false;
  bool get isSearchVisible => _isSearchVisible;

  void initVehicleData({required Vehicles? vehicle}){
    _isTripTypeHourly = vehicle?.tripHourly == 1 ? true : false;
    _isTripTypeDistanceWise = vehicle?.tripDistance == 1 ? true : false;
    _discountType = vehicle?.discountType;
    _discountTypeKey = vehicle?.discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol!;
    _selectedBrand = vehicle?.brand?.name;
    _selectedBrandId = vehicle?.brand?.id.toString();
    _selectedCategory = vehicle?.category?.name;
    _selectedCategoryId = vehicle?.category?.id.toString();
    _selectedVehicleType = _vehicleTypeList.firstWhere((element) => element.key == vehicle?.type).value.tr;
    _selectedVehicleTypeKey = vehicle?.type;
    _selectedFuelType = _fuelTypeList.firstWhere((element) => element.key == vehicle?.fuelType).value.tr;
    _selectedFuelTypeKey = vehicle?.fuelType;
    _selectedTransmissionType = _transmissionTypeList.firstWhere((element) => element.key == vehicle?.transmissionType).value.tr;
    _selectedTransmissionTypeKey = vehicle?.transmissionType;
    _isAc = vehicle?.airCondition == 1 ? true : false;
    _isSameModelMultipleVehicle = vehicle?.multipleVehicles == 1 ? true : false;
    _vinNumberControllerList = [];
    _licensePlateNumberControllerList = [];
    if(vehicle?.vehicleIdentities != null && vehicle!.vehicleIdentities!.isNotEmpty) {
      for (int i = 0; i < vehicle.vehicleIdentities!.length; i++) {
        _vinNumberControllerList.add(TextEditingController(text: vehicle.vehicleIdentities![i].vinNumber));
        _licensePlateNumberControllerList.add(TextEditingController(text: vehicle.vehicleIdentities![i].licensePlateNumber));
      }
    }
    update();
  }

  void resetVehicleData({bool willUpdate = true}){
    _isTripTypeHourly = false;
    _isTripTypeDistanceWise = false;
    _discountType = '%';
    _selectedBrand = null;
    _selectedBrandId = null;
    _selectedCategory = null;
    _selectedCategoryId = null;
    _selectedVehicleType = null;
    _selectedVehicleTypeKey = null;
    _selectedFuelType = null;
    _selectedFuelTypeKey = null;
    _selectedTransmissionType = null;
    _selectedTransmissionTypeKey = null;
    _isAc = false;
    _isSameModelMultipleVehicle = false;
    _vinNumberControllerList = [TextEditingController()];
    _licensePlateNumberControllerList = [TextEditingController()];
    _logo = null;
    _cover = null;
    _vehicleThumbnail = null;
    _vehicleImages.clear();
    _licenseFiles.clear();
    _tagList.clear();
    if(willUpdate) {
      update();
    }
  }

  void setSearchVisibility() {
    _isSearchVisible = !_isSearchVisible;
    update();
  }

  void setTripTypeHourly(bool value) {
    _isTripTypeHourly = value;
    update();
  }

  void setTripTypeDistanceWise(bool value) {
    _isTripTypeDistanceWise = value;
    update();
  }

  void setAc(bool value) {
    _isAc = value;
    update();
  }

  void setSameModelMultipleVehicle(bool value) {
    _isSameModelMultipleVehicle = value;
    update();
  }

  void addNewIdentity() {
    _vinNumberControllerList.add(TextEditingController());
    _licensePlateNumberControllerList.add(TextEditingController());
    update();
  }

  void removeIdentity(int index) {
    _vinNumberControllerList.removeAt(index);
    _licensePlateNumberControllerList.removeAt(index);
    update();
  }

  void pickImage({bool isLogo = false, bool isVehicleThumbnail = false, bool isRemove = false}) async {
    if(isRemove) {
      _logo = null;
      _cover = null;
    }else {
      isLogo ? _logo = await providerServiceInterface.pickImageFromGallery()
          : isVehicleThumbnail ? _vehicleThumbnail = await providerServiceInterface.pickImageFromGallery()
          : _cover = await providerServiceInterface.pickImageFromGallery();
      update();
    }
  }

  void pickVehicleImages() async {
    XFile? xFile = await providerServiceInterface.pickImageFromGallery();
    if(xFile != null){
      _vehicleImages.add(xFile);
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

  void saveVehicleImage(String imageUrl) async {
    XFile? xFile = await urlToXFile(imageUrl);
    if(xFile != null) {
      _vehicleImages.add(xFile);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearVehicleImage() {
    _vehicleImages.clear();
  }

  void removeVehicleImage(int index) {
    _vehicleImages.removeAt(index);
    update();
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        if (file.size > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          _licenseFiles.add(result);
        }
      }
      update();
    }
  }

  void removeFile(int index) {
    _licenseFiles.removeAt(index);
    update();
  }

  Future<FilePickerResult?> urlToFilePickerResult(String imageUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${imageUrl.split('/').last}';

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        final platformFile = PlatformFile(
          name: imageUrl.split('/').last,
          size: response.contentLength ?? 0,
          path: filePath,
          bytes: null,
        );

        return FilePickerResult([platformFile]);
      } else {
        showCustomSnackBar('${'failed_to_download_file'.tr} ${response.statusCode}');
        return null;
      }
    } catch (e) {
      showCustomSnackBar('Error occurred while converting URL to FilePickerResult: $e');
      return null;
    }
  }

  void saveLicenseFile(String imageUrl) async {
    FilePickerResult? filePickerResult = await urlToFilePickerResult(imageUrl);
    if(filePickerResult != null) {
      _licenseFiles.add(filePickerResult);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      update();
    });
  }

  void clearLicenseFile() {
    _licenseFiles.clear();
  }

  Future<void> getVehicleDetails({required int vehicleId}) async {
    Vehicles? vehicleDetailsModel = await providerServiceInterface.getVehicleDetails(vehicleId: vehicleId);
    if(vehicleDetailsModel != null) {
      _vehicleDetailsModel = vehicleDetailsModel;
    }
    update();
  }

  Future<Vehicles?> getVehicleDetailsWithTrans({required int vehicleId}) async {
    _vehicleDetailsWithTrans = null;
    Vehicles? vehicleDetailsWithTrans = await providerServiceInterface.getVehicleDetailsWithTrans(vehicleId);
    if(vehicleDetailsWithTrans != null) {
      _vehicleDetailsWithTrans = vehicleDetailsWithTrans;
    }
    update();
    return _vehicleDetailsWithTrans;
  }

  void setVehicleActive(bool value) {
    _vehicleActive = value;
  }

  Future<void> updateVehicleActivity({required int vehicleId}) async {
    bool status = await providerServiceInterface.updateVehicleActivity(vehicleId: vehicleId);
    if(status) {
      await getVehicleDetails(vehicleId: vehicleId);
      getVehicleList(offset: '1', search: '');
      _vehicleActive = !_vehicleActive;
      showCustomSnackBar('vehicle_activity_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setVehicleNewTag(bool value) {
    _vehicleNewTag = value;
  }

  Future<void> updateVehicleNewTag({required int vehicleId}) async {
    bool status = await providerServiceInterface.updateVehicleNewTag(vehicleId: vehicleId);
    if(status) {
      await getVehicleDetails(vehicleId: vehicleId);
      getVehicleList(offset: '1', search: '');
      _vehicleNewTag = !_vehicleNewTag;
      showCustomSnackBar('vehicle_new_tag_updated_successfully'.tr, isError: false);
    }
    update();
  }

  void setCurrentVehicleImageIndex(int index) {
    _currentVehicleImageIndex = index;
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void setOffset(int offset) {
    _offset = offset;
  }

  Future<void> getVehicleList({required String offset, String? search, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _vehicleList = null;
      _isSearching = search!.isNotEmpty;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      VehicleListModel? vehicleListModel = await providerServiceInterface.getVehicleList(offset: offset, categoryId: _selectedCategoryId, brandId: _filterSelectedBrand,  vehicleType: _filterSelectedVehicleType,
       seatingCapacity: _filterSelectedSeat != null && _filterSelectedSeat!.isNotEmpty ? jsonEncode(_filterSelectedSeat) : _filterSelectedSeat, airCondition: _isCooling, transmissionType: _filterSelectedTransmissionType, fuelType: _filterSelectedFuelType, search: search);
      if (vehicleListModel != null) {
        if (offset == '1') {
          _vehicleList = [];
        }
        _vehicleList?.addAll(vehicleListModel.vehicles ?? []);
        _vehiclePageSize = vehicleListModel.totalSize;
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

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    update();
  }

  void setSelectedCategoryId(String categoryId) {
    _selectedCategoryId = categoryId;
    update();
  }

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    update();
  }

  Future<void> deleteVehicle({required int vehicleId, bool fromDetails = false}) async {
    _isLoading = true;
    update();

    bool status = await providerServiceInterface.deleteVehicle(vehicleId: vehicleId);
    if(status) {
      if(fromDetails) {
        Get.back();
      }
      setCategoryInit();
      await getVehicleList(offset: '1', search: '');
      showCustomSnackBar('vehicle_deleted_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  Future<void> getCategoryList({required String offset, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _categories = null;
      _vehicleCategoryList = null;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      VehicleCategoryModel? vehicleCategoryModel = await providerServiceInterface.getCategoryList(offset: offset);
      if (vehicleCategoryModel != null) {
        if (offset == '1') {
          _categories = [];
          _vehicleCategoryList = [];
          _vehicleCategoryList?.add(Categories(id: 0, name: 'all_vehicle'.tr));
        }
        _categories?.addAll(vehicleCategoryModel.categories ?? []);
        _vehicleCategoryList?.addAll(vehicleCategoryModel.categories ?? []);
        _categoryPageSize = vehicleCategoryModel.totalSize;
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

  Future<void> getBrandList({required String offset, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _brandsList = null;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      VehicleBrandModel? vehicleBrandModel = await providerServiceInterface.getBrandList(offset: offset);
      if (vehicleBrandModel != null) {
        if (offset == '1') {
          _brandsList = [];
        }
        _brandsList?.addAll(vehicleBrandModel.brands ?? []);
        _brandPageSize = vehicleBrandModel.totalSize;
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

  void setSelectedBrand(String brand) {
    _selectedBrand = brand;
    update();
  }

  void setSelectedBrandId(String brandId) {
    _selectedBrandId = brandId;
    update();
  }

  void setSelectedVehicleType(String vehicleType) {
    _selectedVehicleType = vehicleType;
    update();
  }

  void setSelectedVehicleTypeKey(String vehicleTypeKey) {
    _selectedVehicleTypeKey = vehicleTypeKey;
    update();
  }

  void setSelectedFuelType(String fuelType) {
    _selectedFuelType = fuelType;
    update();
  }

  void setSelectedFuelTypeKey(String fuelTypeKey) {
    _selectedFuelTypeKey = fuelTypeKey;
    update();
  }

  void setSelectedTransmissionType(String transmissionType) {
    _selectedTransmissionType = transmissionType;
    update();
  }

  void setSelectedTransmissionTypeKey(String transmissionTypeKey) {
    _selectedTransmissionTypeKey = transmissionTypeKey;
    update();
  }

  void setTag(String? name, {bool isUpdate = true, bool isClear = false}){
    if(isClear){
      _tagList = [];
    }else{
      _tagList.add(name);
      if(isUpdate) {
        update();
      }
    }
  }

  void clearTags(){
    _tagList = [];
  }

  void initializeTags(String name){
    _tagList.add(name);
    update();
  }

  void removeTag(int index){
    _tagList.removeAt(index);
    update();
  }

  void setDiscountType(String type){
    _discountTypeKey = type;
    _discountType = type == '%' ? 'percent' : 'amount';
    update();
  }

  Future<void> addVehicle({required Vehicles? vehicle, required bool isAdd}) async {
    _isLoading = true;
    update();

    List<FilePickerResult> licenseFiles = [];

    for (FilePickerResult element in _licenseFiles) {
      licenseFiles.add(element);
    }

    List<MultipartDocument> document = [];
    for (FilePickerResult result in licenseFiles) {
      document.add(MultipartDocument('documents[]', result));
    }

    Response response = await providerServiceInterface.addVehicle(vehicle: vehicle, isAdd: isAdd, vehicleThumbnail: _vehicleThumbnail, vehicleImages: _vehicleImages, licenseFiles: document);
    if(response.statusCode == 200) {
      Get.back();
      setCategoryInit();
      await getVehicleList(offset: '1', search: '');
      if(!isAdd){
        getVehicleDetails(vehicleId: vehicle!.id!);
      }
      showCustomSnackBar(isAdd ? 'vehicle_added_successfully'.tr : 'vehicle_updated_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void initProviderData({required Store provider}){
    _logo = null;
    _cover = null;
    _scheduleList = [];
    _scheduleList!.addAll(provider.schedules!);
    setScheduleTripStatus(provider.scheduleOrder!);
    setGstStatus(provider.gstStatus!);
  }

  Future<void> addSchedule(Schedules schedule) async {
    schedule.openingTime = '${schedule.openingTime!}:00';
    schedule.closingTime = '${schedule.closingTime!}:00';
    _scheduleLoading = true;
    update();
    int? scheduleID = await providerServiceInterface.addSchedule(schedule);
    if(scheduleID != null) {
      schedule.id = scheduleID;
      _scheduleList!.add(schedule);
      Get.back();
      showCustomSnackBar('schedule_added_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  Future<void> deleteSchedule(int? scheduleID) async {
    _scheduleLoading = true;
    update();
    bool isSuccess = await providerServiceInterface.deleteSchedule(scheduleID);
    if(isSuccess) {
      _scheduleList!.removeWhere((schedule) => schedule.id == scheduleID);
      Get.back();
      showCustomSnackBar('schedule_removed_successfully'.tr, isError: false);
    }
    _scheduleLoading = false;
    update();
  }

  void setScheduleTripStatus(bool value) {
    _scheduleTripStatus = value;
  }

  void updateScheduleTripStatus() {
    _scheduleTripStatus = !_scheduleTripStatus;
    update();
  }

  void setGstStatus(bool value) {
    _gstStatus = value;
  }

  void updateGstStatus() {
    _gstStatus = !_gstStatus;
    update();
  }

  void setSelectedDurationInitData(String duration) {
    _selectedDurationKey = duration;
    _selectedDuration = _durations.firstWhere((element) => element.key == duration).value;
  }

  void setSelectedDuration(String duration, {bool isUpdate = true}) {
    _selectedDuration = duration;
    update();
  }

  void setSelectedDurationKey(String durationKey) {
    _selectedDurationKey = durationKey;
    update();
  }

  Future<void> updateProviderBusinessSetup({required Store provider, required String minTime, required String maxTime, required String timeType}) async {
    _isLoading = true;
    update();
    bool status = await providerServiceInterface.updateProviderBusinessSetup(provider: provider, minTime: minTime, maxTime: maxTime, timeType: timeType, logo: _logo, coverImage: _cover);
    if(status) {
      Get.back();
      showCustomSnackBar('business_setup_updated_successfully'.tr, isError: false);
      await Get.find<TaxiProfileController>().getProfile();
    }
    _isLoading = false;
    update();
  }

  Future<void> getProviderReviewList(String? searchText, {bool willUpdate = true}) async {
    if (searchText!.isEmpty) {
      _providerReviewList = null;
      _isSearching = false;
    } else {
      _searchReviewList = null;
      _isSearching = true;
    }
    if(willUpdate) {
      update();
    }
    _tabIndex = 0;
    List<TaxiReviewModel>? providerReviewList = await providerServiceInterface.getProviderReviewList(searchText);

    if (providerReviewList != null) {
      if (searchText.isEmpty) {
        _providerReviewList = [];
        _providerReviewList!.addAll(providerReviewList);
      } else {
        _searchReviewList = [];
        _searchReviewList!.addAll(providerReviewList);
      }
    }
    update();
  }

  Future<void> updateReply(int reviewID, String reply, {bool isSent = false}) async {
    _isLoading = true;
    update();
    bool isSuccess = await providerServiceInterface.updateReply(reviewID, reply);
    if(isSuccess) {
      Get.back();
      showCustomSnackBar(isSent ? 'reply_sent_successfully'.tr : 'reply_updated_successfully'.tr, isError: false);
      getProviderReviewList('');
    }
    _isLoading = false;
    update();
  }

  /// Vehicle filter part
  void selectBrand(String? brand) {
    _filterSelectedBrand = brand;
    update();
  }

  void selectVehicleType(String? type) {
    _filterSelectedVehicleType = type;
    update();
  }

  void selectSeat(String? seat) {
    _filterSelectedSeat = seat;
    update();
  }

  void selectCooling(String? cooling) {
    _filterSelectedCooling = cooling;
    cooling == 'air_conditioned'.tr ? _isCooling = '1' : _isCooling = '0';
    update();
  }

  void selectTransmissionType(String? type) {
    _filterSelectedTransmissionType = type;
    update();
  }

  void selectFuelType(String? type) {
    _filterSelectedFuelType = type;
    update();
  }

  bool isFilterValid() {
    return (_filterSelectedBrand != null && _filterSelectedBrand!.isNotEmpty) || (_filterSelectedVehicleType != null && _filterSelectedVehicleType!.isNotEmpty)
        || (_filterSelectedSeat != null && _filterSelectedSeat!.isNotEmpty) || (_isCooling != null && _isCooling!.isNotEmpty)
        || (_filterSelectedTransmissionType != null && _filterSelectedTransmissionType!.isNotEmpty) || (_filterSelectedFuelType != null && _filterSelectedFuelType!.isNotEmpty);
  }

  void applyFilters() {
    if (!isFilterValid()) return;
    getVehicleList(offset: '1', search: '');
    Get.back();
    update();
  }

  void setCategoryInit() {
    _selectedCategoryIndex = 0;
    _selectedCategoryId = null;
  }

  void resetFilters({bool willUpdate = true}) {
    _filterSelectedBrand = '';
    _filterSelectedVehicleType = '';
    _filterSelectedSeat = '';
    _isCooling = '';
    _filterSelectedTransmissionType = '';
    _filterSelectedFuelType = '';
    if(willUpdate) {
      getVehicleList(offset: '1', search: '');
      update();
    }
  }
  ///End Vehicle filter part

  void showFab() {
    _isFabVisible = true;
    update();
  }

  void hideFab() {
    _isFabVisible = false;
    update();
  }

}