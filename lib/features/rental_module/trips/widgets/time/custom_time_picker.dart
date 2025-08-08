import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/time/time_picker_spinner.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime? selectTripTime;
  final Function(DateTime) callback;
  final Function(bool) scrollOff;
  const CustomTimePicker({super.key, this.selectTripTime, required this.callback, required this.scrollOff});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    tripController.setTripDate(widget.selectTripTime ?? DateTime.now(), canUpdate: false);
    tripController.setTripTime(widget.selectTripTime ?? DateTime.now(), canUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault ),
      child: TimePickerSpinner(
        time: widget.selectTripTime,
        is24HourMode: false,
        normalTextStyle: robotoRegular.copyWith(color: Colors.black54, fontSize: Dimensions.fontSizeSmall),
        highlightedTextStyle: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge*1, color: Colors.black,),
        spacing: Dimensions.paddingSizeDefault,
        itemHeight: Dimensions.fontSizeLarge + 2,
        itemWidth: 50,
        alignment: Alignment.topCenter,
        isForce2Digits: true,
        onTimeChange: widget.callback,
        scrollOff: widget.scrollOff,
      ),
    );
  }
}