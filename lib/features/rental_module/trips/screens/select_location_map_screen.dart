import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/common/controllers/theme_controller.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_loader_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_store/features/address/widgets/permission_dialog_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/address_input_field.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/animated_map_icon_extended.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/animated_map_icon_minimized.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/custom_floating_action_button.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/custom_icon_layout.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/location/custom_vertical_dotted_line.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';

class SelectLocationMapScreen extends StatefulWidget {
  final PickupLocation? pickupLocation;
  final PickupLocation? destinationLocation;
  const SelectLocationMapScreen({super.key, this.pickupLocation, this.destinationLocation});

  @override
  State<SelectLocationMapScreen> createState() => _SelectLocationMapScreenState();
}

class _SelectLocationMapScreenState extends State<SelectLocationMapScreen> {

  GoogleMapController? _mapController;
  CameraPosition? _cameraPosition;
  double _currentZoomLevel = 16.0;

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    Future.delayed(const Duration(milliseconds: 400), (){
      tripController.setAddressFromUpdate(pickAddress: widget.pickupLocation?.locationName ?? '', destinationAddress: widget.destinationLocation?.locationName ?? '');
      tripController.getInitialLocation(widget.pickupLocation, widget.destinationLocation, _mapController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Scaffold(
        appBar: CustomAppBarWidget(title: 'location'.tr, onTap: (){
          if(tripController.fromAddress == null && tripController.toAddress == null){
            tripController.setFromAddress(tripController.tempFromAddress!);
            tripController.setToAddress(tripController.tempToAddress!);
            tripController.setFromToMarker(
              fromLocation: true,
              _mapController,
              from: LatLng(tripController.tempFromAddress!.lat!, tripController.tempFromAddress!.lng!),
              to: LatLng(tripController.tempToAddress!.lat!,tripController.tempToAddress!.lng!),
            );
          }else if(tripController.fromAddress == null) {
            tripController.setFromAddress(tripController.tempFromAddress!);
            tripController.setFromToMarker(
              fromLocation: true,
              _mapController,
              from: LatLng(tripController.tempFromAddress!.lat!, tripController.tempFromAddress!.lng!),
              to: LatLng(tripController.tempToAddress!.lat!,tripController.tempToAddress!.lng!),
            );
          }else if(tripController.toAddress == null){
            tripController.setToAddress(tripController.tempToAddress!);
            tripController.setFromToMarker(
              fromLocation: true,
              _mapController,
              from: LatLng(tripController.tempFromAddress!.lat!, tripController.tempFromAddress!.lng!),
              to: LatLng(tripController.tempToAddress!.lat!,tripController.tempToAddress!.lng!),
            );
          }else{
            tripController.setFromToMarker(
              fromLocation: true,
              _mapController,
              from: LatLng(tripController.tempFromAddress!.lat!, tripController.tempFromAddress!.lng!),
              to: LatLng(tripController.tempToAddress!.lat!,tripController.tempToAddress!.lng!),
            );
          }
        }),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeDefault,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              child: GoogleMap(
                mapType: MapType.normal,
                markers: tripController.markers,
                polygons: tripController.polygons,
                polylines: Set<Polyline>.of(tripController.polyLines.values),
                zoomControlsEnabled: false,
                style: Get.isDarkMode ? Get.find<ThemeController>().darkMap : Get.find<ThemeController>().lightMap,
                initialCameraPosition: CameraPosition(target: tripController.initialPosition, zoom: _currentZoomLevel),
                onMapCreated: (controller) {
                  _mapController = controller;
                  tripController.getInitialLocation(widget.pickupLocation, widget.destinationLocation, _mapController);
                },
                onCameraMove: (CameraPosition cameraPosition) {
                  _cameraPosition = cameraPosition;
                },
                onCameraMoveStarted: () {
                  tripController.updateCameraMovingStatus(true);
                  tripController.disableButton();
                },
                onCameraIdle: () {
                  tripController.updateCameraMovingStatus(false);
                  try{
                    if(!tripController.showFromToMarker) {
                      tripController.updatePosition(_cameraPosition?.target, tripController.isFormSelected, _mapController);
                    }
                  }catch(e){
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
            ),
          ),

          !tripController.showFromToMarker ? Center(child: Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.pickMapIconSize * 0.65),
            child: tripController.isCameraMoving ? const AnimatedMapIconExtended() : const AnimatedMapIconMinimised(),
          )) : const SizedBox(),

          Positioned(
            top: 30, left: 30, right: 30,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.3), spreadRadius: 2, blurRadius: 4, offset: const Offset(0, 2))],
              ),
              //margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(children: [
                    CustomIconLayout(height: 20, width: 20, icon: Icons.location_on_rounded),

                    CustomVerticalDottedLine(dotCount: 6),

                    CustomIconLayout(height: 15, width: 15, iconImage: Images.navigationArrowIcon),
                  ]),
                ),

                Expanded(child: Column(children: [
                  AddressInputField(isFormAddress: true, mapController: _mapController),

                  const Divider(endIndent: 10),
                  AddressInputField(isFormAddress: false, mapController: _mapController),
                ])),

              ]),
            ),
          ),

          Positioned(
            right: 25, bottom: GetPlatform.isIOS ? 120 : 100,
            child: Column(children: [

              CustomFloatingActionButton(
                icon: Icons.add, heroTag: 'add_button',
                onTap: () {
                  _currentZoomLevel++;
                  _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                },
              ),

              CustomFloatingActionButton(
                icon: Icons.remove, heroTag: 'remove_button',
                onTap: () {
                  _currentZoomLevel--;
                  _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
                },
              ),

              Container(
                width: 35, height: 35,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6, spreadRadius: 0.5, offset: const Offset(0, 4))],
                ),
                child: FloatingActionButton(backgroundColor: Colors.white,
                  onPressed: () {
                    Get.dialog(const CustomLoaderWidget());
                    _checkPermission(() {
                      Get.find<AddressController>().getCurrentLocation(mapController: _mapController).then((value) {
                        Navigator.pop(Get.context!);
                      });
                    });
                  },
                  child: Icon(Icons.my_location, size: 25, color: Theme.of(context).primaryColor),
                ),
              )]
            ),
          ),

          Positioned(
            bottom: 0, right: 0, left: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Theme.of(context).disabledColor.withValues(alpha: 0.2), blurRadius: 10)],
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: SafeArea(
                child: CustomButtonWidget(
                  buttonText: 'confirm'.tr,
                  onPressed: ((tripController.isFormSelected && tripController.fromAddress == null) ||
                      (!tripController.isFormSelected && tripController.toAddress == null) || !Get.find<AddressController>().inZone ||
                      tripController.isLoading) ? null : () {
                    if(tripController.fromAddress == null || tripController.toAddress == null) {
                      showCustomSnackBar('please_select_both_addresses'.tr);
                    }else{
                      tripController.setFromToMarker(
                        fromLocation: true,
                        _mapController,
                        from: LatLng(tripController.fromAddress!.lat!, tripController.fromAddress!.lng!),
                        to: LatLng(tripController.toAddress!.lat!,tripController.toAddress!.lng!),
                      );
                    }
                  },
                ),
              ),
            ),
          ),

        ]),
      );
    });
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(const PermissionDialogWidget());
    }else {
      onTap();
    }
  }

}
