import 'dart:collection';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/address/domain/models/place_details_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_model.dart';
import 'package:sixam_mart_store/features/address/domain/models/zone_response_model.dart';
import 'package:sixam_mart_store/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_list_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/services/trip_service_interface.dart';
import 'package:sixam_mart_store/util/images.dart';

class TripController extends GetxController implements GetxService {
  final TripServiceInterface tripServiceInterface;
  TripController({required this.tripServiceInterface});

  bool _isTripTypeHourly = false;
  bool get isTripTypeHourly => _isTripTypeHourly;

  int? _expandedIndex;
  int? get expandedIndex => _expandedIndex;

  int? _pageSize;
  int? get pageSize => _pageSize;

  final List<String> _offsetList = [];
  int _offset = 1;
  int get offset => _offset;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isEditLoading = false;
  bool get isEditLoading => _isEditLoading;

  List<Trips>? _tripsList;
  List<Trips>? get tripsList => _tripsList;

  int? _selectedStatusIndex;
  int? get selectedStatusIndex => _selectedStatusIndex;

  String? _selectedStatus = 'pending';
  String? get selectedStatus => _selectedStatus;

  int? _selectedStatusHistoryIndex;
  int? get selectedStatusHistoryIndex => _selectedStatusHistoryIndex;

  String? _selectedHistoryStatus = 'pending';
  String? get selectedHistoryStatus => _selectedHistoryStatus;

  bool _isStatusLoading = false;
  bool get isStatusLoading => _isStatusLoading;

  bool _isCancelLoading = false;
  bool get isCancelLoading => _isCancelLoading;

  TripDetailsModel? _tripDetailsModel;
  TripDetailsModel? get tripDetailsModel => _tripDetailsModel;

  List<bool> _selectedVehicleLicense = [];
  List<bool> get selectedVehicleLicense => _selectedVehicleLicense;

  final List<int> _selectedVehicleLicenseIdList = [];
  List<int> get selectedVehicleLicenseIdList => _selectedVehicleLicenseIdList;

  final Map<String, dynamic> _selectedDriverIds = {};
  Map<String, dynamic> get selectedDriverIds => _selectedDriverIds;

  final List<TextEditingController> _quantityControllers = [];
  List<TextEditingController> get quantityControllers => _quantityControllers;

  final List<TextEditingController> _fairControllers = [];
  List<TextEditingController> get fairControllers => _fairControllers;

  List<double> tripAmount = [];
  List<int> quantity = [];
  List<double> liveTripAmount = [];
  String tripType = '';
  double tripDistance = 0.0;
  int tripHour = 0;

  final double _systemEstimatedFair = 0.0;
  double get systemEstimatedFair => _systemEstimatedFair;

  void setSelectedStatusIndex(int? index, String? status) {
    _selectedStatusIndex = index;
    _selectedStatus = status;
    update();
  }

  void setSelectedHistoryStatusIndex(int? index, String? status) {
    _selectedStatusHistoryIndex = index;
    _selectedHistoryStatus = status;
    update();
  }

  void setTripType(bool value) {
    _isTripTypeHourly = value;
    update();
  }

  void setExpandedIndex(int? index) {
    _expandedIndex = index;
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<void> getTripList({required String status, required String offset, bool willUpdate = true}) async {
    if (offset == '1') {
      _offsetList.clear();
      _offset = 1;
      _tripsList = null;
      if(willUpdate) {
        update();
      }
    }

    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      TripListModel? tripListModel = await tripServiceInterface.getTripList(offset: offset, status: status);
      if (tripListModel != null) {
        if (offset == '1') {
          _tripsList = [];
        }
        _tripsList?.addAll(tripListModel.trips ?? []);
        _pageSize = tripListModel.totalSize;
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

  Future<void> updateTripStatus({required int tripId, required String status}) async {
    status == 'canceled' ? _isCancelLoading = true : _isStatusLoading = true;
    update();

    bool isUpdated = await tripServiceInterface.updateTripStatus(tripId: tripId, status: status);
    if (isUpdated) {
      showCustomSnackBar('trip_status_updated'.tr, isError: false);
      getTripDetails(tripId: tripId);
      await getTripList(status: 'pending', offset: '1');
    }

    status == 'canceled' ? _isCancelLoading = false : _isStatusLoading = false;
    update();
  }

  Future<void> updateTripPaymentStatus({required int tripId, required String paymentStatus}) async {
    _isStatusLoading = true;
    update();

    bool isUpdated = await tripServiceInterface.updateTripPaymentStatus(tripId: tripId, paymentStatus: paymentStatus);
    if (isUpdated) {
      getTripDetails(tripId: tripId);
      await getTripList(status: 'pending', offset: '1');
    }else {
      showCustomSnackBar('payment_status_update_failed'.tr);
    }

    _isStatusLoading = false;
    update();
  }

  Future<void> getTripDetails({required int tripId}) async {
    _tripDetailsModel = null;
    TripDetailsModel? tripDetailsModel = await tripServiceInterface.getTripDetails(tripId: tripId);
    if (tripDetailsModel != null) {
      _tripDetailsModel = tripDetailsModel;
    }
    update();
  }

  void initializeVehicleLicenseSelection(int length, {bool willUpdate = false}) {
    _selectedVehicleLicense.clear();
    _selectedVehicleLicenseIdList.clear();
    _selectedVehicleLicense = List.generate(length, (_) => false);
    if(willUpdate) {
      update();
    }
  }

  void toggleVehicleLicenseSelection(int index, int id) {
    if (_selectedVehicleLicense[index]) {
      _selectedVehicleLicenseIdList.remove(id);
    } else {
      _selectedVehicleLicenseIdList.add(id);
    }
    _selectedVehicleLicense[index] = !_selectedVehicleLicense[index];
    update();
  }

  void initSelectedVehicleLicenseIdList() {
    _selectedVehicleLicenseIdList.clear();
  }

  Future<void> assignVehicle({required int tripId, required int tripDetailsId, required int vehicleId}) async {
    _isLoading = true;
    update();

    bool isAssigned = await tripServiceInterface.assignVehicle(tripId: tripId, tripDetailsId: tripDetailsId, vehicleId: vehicleId, vehicleIdentityIds: _selectedVehicleLicenseIdList);
    if (isAssigned) {
      await getTripDetails(tripId: tripId);
      showCustomSnackBar('vehicle_assigned_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void updateSelectedDriver({required String vehicleId, required int driverId, bool willUpdate = false}) {
    _selectedDriverIds[vehicleId] = driverId;
    if(willUpdate) {
      update();
    }
  }

  void clearSelectedDriver() {
    _selectedDriverIds.clear();
  }

  Future<void> assignDriver({required int tripId}) async {
    _isLoading = true;
    update();

    bool isAssigned = await tripServiceInterface.assignDriver(tripId: tripId, driverIds: _selectedDriverIds);
    if (isAssigned) {
      await getTripDetails(tripId: tripId);
      showCustomSnackBar('driver_assigned_successfully'.tr, isError: false);
    }
    _isLoading = false;
    update();
  }

  void setQuantityAndFairData({required TripDetailsModel tripDetails}){
    _quantityControllers.clear();
    _fairControllers.clear();
    tripAmount.clear();
    quantity.clear();
    liveTripAmount.clear();

    for (int i = 0; i < tripDetails.tripDetails!.length; i++) {
      _quantityControllers.add(TextEditingController(text: tripDetails.tripDetails![i].quantity.toString()));
      _fairControllers.add(TextEditingController(text: tripDetails.tripDetails![i].calculatedPrice.toString()));
      tripAmount.add(tripDetails.tripDetails![i].calculatedPrice!);
      quantity.add(tripDetails.tripDetails![i].quantity!);
      liveTripAmount.add(tripDetails.tripType == 'hourly' ? tripDetails.tripDetails![i].vehicle!.hourlyPrice! : tripDetails.tripDetails![i].vehicle!.distancePrice!);
    }
  }

  void calculateTripFair(int index) {
    if(_quantityControllers[index].text.isEmpty) {
      _fairControllers[index].text = tripAmount[index].toStringAsFixed(1);
    }else {
      double quantity = double.parse(_quantityControllers[index].text);
      double fair = double.parse(liveTripAmount[index].toStringAsFixed(1));

      if(tripType == 'hourly') {
        double total = fair * quantity * tripHour;
        _fairControllers[index].text = total.toStringAsFixed(1);
      }else {
        double total = fair * quantity * tripDistance;
        _fairControllers[index].text = total.toStringAsFixed(1);
      }
    }
    update();
  }

  void resetCalculateTripFair(int index) {
    _quantityControllers[index].text = quantity[index].toString();
    _fairControllers[index].text = tripAmount[index].toStringAsFixed(1);
    update();
  }

  double systemEstimatedFairCalculation(int index) {
    double qan = double.parse(_quantityControllers[index].text);
    double fair = double.parse(liveTripAmount[index].toStringAsFixed(1));

    if(tripType == 'hourly') {
      double total = fair * qan * tripHour;
      return total;
    }else {
      double total = fair * qan * tripDistance;
      return total;
    }
  }

  ///Update Location Part

  final TextEditingController _formTextEditingController = TextEditingController();
  TextEditingController get formTextEditingController => _formTextEditingController;

  final TextEditingController _toTextEditingController = TextEditingController();
  TextEditingController get toTextEditingController => _toTextEditingController;

  List<PredictionModel> _predictionList = [];
  List<PredictionModel> get predictionList => _predictionList;

  bool _isFormSelected = true;
  bool get isFormSelected => _isFormSelected;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  Set<Polygon> _polygons = {};
  Set<Polygon> get polygons => _polygons;

  final Map<PolylineId, Polyline> _polyLines = {};
  Map<PolylineId, Polyline> get polyLines => _polyLines;

  PickupLocation? _fromAddress;
  PickupLocation? get fromAddress => _fromAddress;

  PickupLocation? _toAddress;
  PickupLocation? get toAddress => _toAddress;

  bool _showFromToMarker = false;
  bool get showFromToMarker => _showFromToMarker;

  List<ZoneModel>? _zoneList;
  List<ZoneModel>? get zoneList => _zoneList;

  bool _isCameraMoving = false;
  bool get isCameraMoving => _isCameraMoving;

  bool _updateAddAddressData = true;

  final MarkerId _fromMarkerId = const MarkerId('from_marker');
  final MarkerId _toMarkerId = const MarkerId('to_marker');

  Uint8List? _mapScreenshot;
  Uint8List? get mapScreenshot => _mapScreenshot;

  bool _buttonDisabled = true;
  bool get buttonDisabled => _buttonDisabled;

  bool _inZone = false;
  bool get inZone => _inZone;

  PickupLocation? _tempFromAddress;
  PickupLocation? get tempFromAddress => _tempFromAddress;

  PickupLocation? _tempToAddress;
  PickupLocation? get tempToAddress => _tempToAddress;

  LatLng _initialPosition = LatLng(
    double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lat ?? '0'),
    double.parse(Get.find<SplashController>().configModel!.defaultLocation!.lng ?? '0'),
  );
  LatLng get initialPosition => _initialPosition;

  void selectLocationType({required bool isForm}) {
    _isFormSelected = isForm;
    update();
  }

  void setAddressFromUpdate({required String pickAddress, required String destinationAddress}) async {
    _formTextEditingController.text = pickAddress;
    _toTextEditingController.text = destinationAddress;
  }

  void clearAddress(bool isFrom){
    if(isFrom){
      _formTextEditingController.text = '';
      _fromAddress = null;
    }else{
      _toTextEditingController.text = '';
      _toAddress = null;
    }
    _showFromToMarker = false;
    _markers.clear();
    _polyLines.clear();
    update();
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      List<PredictionModel> predictionList = await tripServiceInterface.searchLocation(text);
      if(predictionList.isNotEmpty) {
        _predictionList = [];
        _predictionList.addAll(predictionList);
      }
    }
    Future.delayed(const Duration(milliseconds: 150), () {
      update();
    });
    return _predictionList;
  }

  void setLocationFromPlace(String? placeID, String? address, bool isFrom, GoogleMapController? mapController) async {
    Response response = await tripServiceInterface.getPlaceDetails(placeID);
    if(response.statusCode == 200) {
      PlaceDetailsModel placeDetails = PlaceDetailsModel.fromJson(response.body);
      if(placeDetails.status == 'OK') {
        PickupLocation address0 = PickupLocation(
          locationName: address, lat: placeDetails.result!.geometry!.location!.lat,
          lng: placeDetails.result!.geometry!.location!.lng,
        );
        ZoneResponseModel response0 = await Get.find<AddressController>().getZone(address0.lat.toString(), address0.lng.toString(), false);

        if(response0.zoneIds.isNotEmpty && isFrom) {
          _inZone = await tripServiceInterface.checkInZone(address0.lat.toString(), address0.lng.toString(), response0.zoneIds[0]);
        }

        if(mapController != null) {
          clearAddress(isFrom);
          selectLocationType(isForm: isFrom);
          mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(address0.lat!, address0.lng!), zoom: 17)));
        }

        ///create polygon
        await _createPolygon(isFrom ? _inZone : true);

        ///Data setup
        if (response0.isSuccess && _inZone && isFrom) {
          _formTextEditingController.text = address0.locationName ?? '';
          setFromAddress(address0, mapController: mapController);
        } else if(response0.isSuccess && !isFrom) {
          _toTextEditingController.text = address0.locationName ?? '';
          setToAddress(address0, mapController: mapController);
        }
      }
    }
    update();
  }

  void setTempAddress({required PickupLocation addressModel, required bool isFrom}) {
    if(isFrom) {
      _tempFromAddress = addressModel;
    }else{
      _tempToAddress = addressModel;
    }
  }

  Future<void> setFromAddress(PickupLocation addressModel, {GoogleMapController? mapController, bool willUpdate = true}) async {
    _fromAddress = addressModel;
    LatLng from = LatLng(_fromAddress!.lat!, _fromAddress!.lng!);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: from, zoom: 17)));
    if(willUpdate) {
      update();
    }
  }

  Future<void> setToAddress(PickupLocation addressModel, {GoogleMapController? mapController, bool willUpdate = true}) async {
    _toAddress = addressModel;
    LatLng to = LatLng(_toAddress!.lat!,_toAddress!.lng!);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: to, zoom: 17)));
    if(willUpdate) {
      update();
    }
  }

  void updatePosition(LatLng? positionLatLng, bool fromAddress, GoogleMapController? mapController) async {
    if(_updateAddAddressData && positionLatLng != null) {
      _isLoading = true;
      update();

      ZoneResponseModel response0 = await Get.find<AddressController>().getZone(
          positionLatLng.latitude.toString(), positionLatLng.longitude.toString(), false);

      String addressFromGeocode = await Get.find<AddressController>().getAddressFromGeocode(
          LatLng(positionLatLng.latitude, positionLatLng.longitude));

      PickupLocation address0 = PickupLocation(
        locationName: addressFromGeocode,
        lat: positionLatLng.latitude,
        lng: positionLatLng.longitude,
      );

      if(response0.zoneIds.isNotEmpty && fromAddress) {
        _inZone = await tripServiceInterface.checkInZone(address0.lat.toString(), address0.lng.toString(), response0.zoneIds[0]);
      }

      ///create polygon
      await _createPolygon(fromAddress ? _inZone : true);

      ///Data setup
      if (response0.isSuccess && _inZone && fromAddress) {
        _formTextEditingController.text = address0.locationName ?? '';
        _fromAddress = address0;
      } else if(response0.isSuccess && !fromAddress) {
        _toTextEditingController.text = address0.locationName ?? '';
        _toAddress = address0;
      }
    } else {
      _updateAddAddressData = true;
    }

    _buttonDisabled = false;
    _isLoading = false;
    update();
  }

  _createPolygon(bool inZone) async{
    if(inZone) {
      _polygons = {};
      update();
    } else {
      List<Polygon> polygonList = [];
      List<List<LatLng>> zoneLatLongList = [];

      for (var zoneModel in _zoneList!) {
        zoneLatLongList.add([]);
        zoneModel.formatedCoordinates?.forEach((coordinate) {
          zoneLatLongList[_zoneList!.indexOf(zoneModel)].add(LatLng(coordinate.lat!, coordinate.lng!));
        });
      }

      for (var zonesLatLng in zoneLatLongList) {
        polygonList.add(
          Polygon(
            polygonId: PolygonId('${zoneLatLongList.indexOf(zonesLatLng)}'),
            points: zonesLatLng,
            strokeWidth: 2,
            strokeColor: Get.theme.colorScheme.primary,
            fillColor: Get.theme.colorScheme.primary.withValues(alpha: .2),
          ),
        );
      }

      _polygons = HashSet<Polygon>.of(polygonList);
      update();
    }
  }

  void updateCameraMovingStatus(bool status){
    _isCameraMoving = status;
    update();
  }

  Future<Position?> getInitialLocation(PickupLocation? pickupLocation, PickupLocation? destinationLocation, GoogleMapController? mapController) async {
    Position? position;

    try {
      if(pickupLocation == null || destinationLocation == null) {
        await Geolocator.requestPermission();
        position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
        _initialPosition = LatLng(position.latitude, position.longitude);
      }else{
        if(_isFormSelected){
          _initialPosition = LatLng(pickupLocation.lat ?? 0, pickupLocation.lng ?? 0);
          _formTextEditingController.text = pickupLocation.locationName ?? '';
        }else{
          _initialPosition = LatLng(destinationLocation.lat ?? 0, destinationLocation.lng ?? 0);
          _toTextEditingController.text = destinationLocation.locationName ?? '';
        }
      }
      if(mapController != null) {
        mapController.animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 17));
      }
      update();
    }catch(_){}
    return position;
  }

  void disableButton() {
    _buttonDisabled = true;
    update();
  }

  Future<void> setFromToMarker(GoogleMapController? mapController, {required LatLng from, required LatLng to, clickFromButton = true, fromLocation = false}) async {

    _isLoading = true;
    if(clickFromButton) {
      update();
    }
    final Uint8List fromMarkerIcon = await getBytesFromAsset(Images.taxiPickup, 40);
    final Uint8List toMarkerIcon = await getBytesFromAsset(Images.taxiDestination, 40);

    _markers = {};
    Marker fromMarker = Marker(
      markerId: _fromMarkerId, position: from, visible: true,
      icon: BitmapDescriptor.bytes(fromMarkerIcon),
    );
    _markers.add(fromMarker);
    Marker toMarker = Marker(
      markerId: _toMarkerId, position: to,
      icon: BitmapDescriptor.bytes(toMarkerIcon),
    );
    _markers.add(toMarker);
    _showFromToMarker = true;

    try {
      LatLngBounds? bounds;
      if(mapController != null) {
        bounds = _boundWithMaximumLatLngPoint([from, to]);
      }
      LatLng centerBounds = LatLng(
        (bounds!.northeast.latitude + bounds.southwest.latitude)/2,
        (bounds.northeast.longitude + bounds.southwest.longitude)/2,
      );
      double bearing = Geolocator.bearingBetween(from.latitude, from.longitude, to.latitude, to.longitude);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: bearing, target: centerBounds, zoom: 16,
      )));
      _zoomToFit(mapController, bounds, centerBounds, bearing, padding: 2.5);
    }catch(e) {
      if (kDebugMode) {
        print('Bounds Error: $e');
      }
    }

    await generatePolyLines(from: from, to: to);
    update();

/*    await Future.delayed(const Duration(milliseconds: 600)).then((value) async{
      Uint8List? mapImage = await mapController!.takeSnapshot();
      if(mapImage!= null) {
        _mapScreenshot = mapImage;
        Get.back();
      }
    });*/

    if(fromLocation){
      Get.back();
    }

    _isLoading = false;
    update();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<List<LatLng>> generatePolyLines({required LatLng from, required LatLng to}) async {
    List<LatLng> polylineCoordinates = [];
    List<LatLng> results = await _getRouteBetweenCoordinates(from, to);
    if (results.isNotEmpty) {
      polylineCoordinates.addAll(results);
    } else {
      showCustomSnackBar('route_not_found'.tr);
    }
    PolylineId polyId = const PolylineId('my_polyline');
    Polyline polyline = Polyline(
      polylineId: polyId,
      points: polylineCoordinates,
      width: 3,
      color: Colors.black,
    );
    _polyLines[polyId] = polyline;
    update();
    return polylineCoordinates;
  }

  Future<List<LatLng>> _getRouteBetweenCoordinates(LatLng origin, LatLng destination) async {
    List<LatLng> coordinates = [];
    Response response = await tripServiceInterface.getRouteBetweenCoordinates(origin, destination);
    if (response.body["status"]?.toLowerCase() == 'ok' && response.body["routes"] != null && response.body["routes"].isNotEmpty) {
      coordinates.addAll(_decodeEncodedPolyline(response.body["routes"][0]["overview_polyline"]["points"]));
    }
    return coordinates;
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  LatLngBounds _boundWithMaximumLatLngPoint(List<LatLng> list) {
    assert(list.isNotEmpty);
    var firstLatLng = list.first;
    var s = firstLatLng.latitude,
        n = firstLatLng.latitude,
        w = firstLatLng.longitude,
        e = firstLatLng.longitude;
    for (var i = 1; i < list.length; i++) {
      var latLng = list[i];
      s = math.min(s, latLng.latitude);
      n = math.max(n, latLng.latitude);
      w = math.min(w, latLng.longitude);
      e = math.max(e, latLng.longitude);
    }
    return LatLngBounds(southwest: LatLng(s, w), northeast: LatLng(n, e));
  }

  Future<void> _zoomToFit(GoogleMapController? controller, LatLngBounds? bounds, LatLng centerBounds, double bearing, {double padding = 0.5}) async {
    bool keepZoomingOut = true;
    while(keepZoomingOut) {

      final LatLngBounds screenBounds = await controller!.getVisibleRegion();
      if(_fits(bounds!, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - padding;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
          bearing: bearing,
        )));
        break;
      }
      else {
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  bool _fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
    final bool northEastLatitudeCheck = screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
    final bool northEastLongitudeCheck = screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

    final bool southWestLatitudeCheck = screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
    final bool southWestLongitudeCheck = screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

    return northEastLatitudeCheck && northEastLongitudeCheck && southWestLatitudeCheck && southWestLongitudeCheck;
  }

  ///End Update Location Part


  ///Update Date and Time Part

  DateTime? _selectedTripDate;
  DateTime? get selectedTripDate => _selectedTripDate;

  DateTime? _selectedTripTime;
  DateTime? get selectedTripTime => _selectedTripTime;

  DateTime? _finalTripDateTime;
  DateTime? get finalTripDateTime => _finalTripDateTime;

  void setTripDate(DateTime? date, {bool canUpdate = true}) {
    _selectedTripDate = date;
    if(canUpdate) {
      update();
    }
  }

  void setTripTime(DateTime? date, {bool canUpdate = true}) {
    _selectedTripTime = date;
    if(canUpdate) {
      update();
    }
  }

  void setFinalTripDateTime(DateTime? date) {
    _finalTripDateTime = date;
    update();
  }

  void resetTripDateTime() {
    _selectedTripDate = null;
    _selectedTripTime = null;
    _finalTripDateTime = null;
  }

  Future<void> editTripDetails({required int tripId}) async {
    _isEditLoading = true;
    update();

    Map<String, dynamic> vehicleQuantities = {};
    for (int i = 0; i < _tripDetailsModel!.tripDetails!.length; i++) {
      vehicleQuantities.addAll({
        '${_tripDetailsModel!.tripDetails![i].vehicleId}': int.parse(_quantityControllers[i].text),
      });
    }

    Map<String, dynamic> vehicleFairs = {};
    for (int i = 0; i < _tripDetailsModel!.tripDetails!.length; i++) {
      vehicleFairs.addAll({
        '${_tripDetailsModel!.tripDetails![i].vehicleId}': double.parse(_fairControllers[i].text),
      });
    }

    Map<String, dynamic> body = {};
    body.addAll({
      'trip_id': tripId,
      'pickup_location': _fromAddress,
      'destination_location' : _toAddress,
      'schedule_at' : _finalTripDateTime?.toString(),
      'vehicle_quantities' : jsonEncode(vehicleQuantities),
      'modified_prices' : jsonEncode(vehicleFairs),
      '_method': 'put',
    });

    bool isEdited = await tripServiceInterface.editTripDetails(body: body);
    if (isEdited) {
      await getTripDetails(tripId: tripId);
      showCustomSnackBar('trip_details_updated_successfully'.tr, isError: false);
      Navigator.pop(Get.context!);
    }

    _isEditLoading = false;
    update();
  }
///End Update Date and Time Part

}