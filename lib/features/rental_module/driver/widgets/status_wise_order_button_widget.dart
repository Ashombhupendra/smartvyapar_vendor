import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/driver/controllers/driver_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/status_list_model.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class StatusWiseOrderButtonWidget extends StatelessWidget {
  final StatusListModel statusListModel;
  final int index;
  final DriverController driverController;
  final int titleLength;

  const StatusWiseOrderButtonWidget({
    super.key,
    required this.statusListModel,
    required this.index,
    required this.driverController,
    required this.titleLength,
  });

  @override
  Widget build(BuildContext context) {
    int selectedIndex = driverController.selectedStatusIndex ?? 0;
    bool isSelected = selectedIndex == index;
    int confirmedTripLength = driverController.confirmedTrips?.length ?? 0;
    int ongoingTripLength = driverController.ongoingTrips?.length ?? 0;
    int completedTripLength = driverController.completedTrips?.length ?? 0;
    int cancelledTripLength = driverController.cancelledTrips?.length ?? 0;

    return InkWell(
      onTap: () {
        driverController.setSelectedStatusIndex(index, statusListModel.status);
      },
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          '${statusListModel.statusTitle.tr} '
           '${statusListModel.status == 'confirmed' ? '($confirmedTripLength)' : statusListModel.status == 'ongoing' ? '($ongoingTripLength)' : statusListModel.status == 'completed' ? '($completedTripLength)' : '($cancelledTripLength)'}',
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