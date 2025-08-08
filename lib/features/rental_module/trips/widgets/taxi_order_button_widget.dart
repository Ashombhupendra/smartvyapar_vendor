import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/status_list_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class TaxiOrderButtonWidget extends StatelessWidget {
  final StatusListModel statusListModel;
  final int index;
  final TripController tripController;
  final int titleLength;
  final bool fromHistory;

  const TaxiOrderButtonWidget({
    super.key,
    required this.statusListModel,
    required this.index,
    required this.tripController,
    required this.titleLength,
    this.fromHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = fromHistory ? (tripController.selectedStatusHistoryIndex ?? 0) : (tripController.selectedStatusIndex ?? 0);
    bool isSelected = selectedIndex == index;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = (screenWidth - 30) / titleLength;

    return InkWell(
      onTap: () {
        if (fromHistory) {
          tripController.setSelectedHistoryStatusIndex(index, statusListModel.status);
          tripController.getTripList(status: statusListModel.status, offset: '1');
        } else {
          tripController.setSelectedStatusIndex(index, statusListModel.status);
          tripController.getTripList(status: statusListModel.status, offset: '1');
        }
      },
      child: fromHistory ? Row(children: [

        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
          ),
          alignment: Alignment.center,
          child: Text(
            '${statusListModel.statusTitle.tr} '
            '${(isSelected) ? (tripController.tripsList == null ? '' : (tripController.tripsList!.isEmpty ? '(0)' : '(${tripController.pageSize ?? 0})')) : ''}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            ),
          ),
        ),

        (index != titleLength-1 && index != selectedIndex && index != selectedIndex-1) ? Container(
          height: 15, width: 1, color: Theme.of(context).disabledColor,
        ) : const SizedBox(),

      ]) : Container(
        width: buttonWidth,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          '${statusListModel.statusTitle.tr} '
          '${(isSelected) ? (tripController.tripsList == null ? '' : (tripController.tripsList!.isEmpty ? '(0)' : '(${tripController.pageSize ?? 0})')) : ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
          ),
        ),
      ),
    );
  }
}