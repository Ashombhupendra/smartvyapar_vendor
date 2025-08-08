import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_store/features/address/domain/models/prediction_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';

class AddressInputField extends StatelessWidget {
  final bool isFormAddress;
  final GoogleMapController? mapController;
  const AddressInputField({super.key, required this.isFormAddress, this.mapController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [

            Expanded(
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: isFormAddress ? tripController.formTextEditingController : tripController.toTextEditingController,
                  textInputAction: TextInputAction.search,
                  autofocus: false,
                  onTap: ()=> tripController.selectLocationType(isForm: isFormAddress),
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.streetAddress,
                  decoration: InputDecoration(
                    hintText: isFormAddress ? 'enter_pickup_location'.tr : 'enter_destination_location'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(style: BorderStyle.none, width: 0),
                    ),
                    hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                    ),
                    filled: true, fillColor: Theme.of(context).cardColor,
                  ),
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
                suggestionsCallback: (pattern) async {
                  return await tripController.searchLocation(context, pattern);
                },
                itemBuilder: (context, PredictionModel suggestion) {
                  return Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Row(children: [
                      isFormAddress ? Image.asset(Images.taxiPickup, height: 16, width: 16, color: Theme.of(context).primaryColor)
                          : Icon(Icons.location_on_rounded, size: 16, color: Theme.of(context).primaryColor),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Expanded(
                        child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: Dimensions.fontSizeLarge,
                        )),
                      ),
                    ]),
                  );
                },
                onSuggestionSelected: (PredictionModel suggestion) {
                  tripController.setLocationFromPlace(suggestion.placeId, suggestion.description, isFormAddress, mapController);
                  //Get.back();
                },
              ),
            ),

            (isFormAddress ? tripController.formTextEditingController.text != '' : tripController.toTextEditingController.text != '') ? InkWell(
              onTap: () {
                tripController.clearAddress(isFormAddress);
                tripController.selectLocationType(isForm: isFormAddress);
              },
              child: const SizedBox(
                height: 30, width: 30,
                child: Icon(Icons.clear, size: 16),
              ),
            ) : const SizedBox()

          ],
        ),
      );
    });
  }
}
