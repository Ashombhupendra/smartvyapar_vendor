import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/time/custom_time_picker.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateTimePickerSheet extends StatefulWidget {
  final String? scheduleAt;
  const DateTimePickerSheet({super.key, required this.scheduleAt});

  @override
  State<DateTimePickerSheet> createState() => _DateTimePickerSheetState();
}

class _DateTimePickerSheetState extends State<DateTimePickerSheet> {

  DateTime? selectTripDate;
  DateTime? selectTripTime;
  bool canUpdate = true;

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();
    tripController.resetTripDateTime();

    selectTripDate = widget.scheduleAt != null ? DateConverterHelper.dateTimeStringToDate(widget.scheduleAt!) : tripController.selectedTripDate;
    selectTripTime = widget.scheduleAt != null ? DateConverterHelper.dateTimeStringToDate(widget.scheduleAt!) : tripController.selectedTripTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {
      return Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.radiusLarge), topRight: Radius.circular(Dimensions.radiusLarge)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 33, height: 4.0,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),

          //cross icon
          Container(
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.close, size: 24, color: Colors.grey[300],),
              )
          ),

          //heading
          Text('set_date_and_time'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
          const SizedBox(height: 16),

          //calender
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade100, width: 1)),
            height: 250,
            padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
            child: SfDateRangePicker(
              //minDate: DateTime.now(),
              backgroundColor: Colors.white,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.transparent,
                textAlign: TextAlign.center,
                textStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                DateTime selectedDate = DateConverterHelper.dateTimeStringToDate(args.value.toString());
                setState(() {
                  selectTripDate = selectedDate;
                });
              },
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: selectTripDate ?? DateTime.now(),
                selectableDayPredicate: (DateTime val) {
                  return val.isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-1));
                }
            ),
          ),

          //TimePicker
          Container(
            margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text('time'.tr, style: robotoMedium),

              CustomTimePicker(
                selectTripTime: selectTripTime,
                callback: (DateTime time) {
                  setState(() {
                    selectTripTime = time;
                  });
                },
                scrollOff: (status) {
                  setState(() {
                    canUpdate = status;
                  });
                },
              ),
            ]),
          ),
          const SizedBox(height: 20,),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              child: Row(children: [
                TextButton(
                  onPressed: () {
                    tripController.setTripTime(DateTime.now());
                    tripController.setTripDate(DateTime.now());
                    tripController.setFinalTripDateTime(DateTime.now());

                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text(
                    'pickup_now'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyMedium!.color),
                  ),
                ),
                const Spacer(),

                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('cancel'.tr, style: robotoRegular.copyWith(fontSize:14, color: Colors.black),),
                ),
                const SizedBox(width: 9),

                CustomButtonWidget(
                  buttonText: 'okay'.tr,
                  height: 35, width: 80,
                  onPressed: canUpdate ? () {
                    tripController.setTripDate(selectTripDate);
                    tripController.setTripTime(selectTripTime);
                    DateTime date = DateConverterHelper.formattingTripDateTime(tripController.selectedTripTime!, tripController.selectedTripDate!);

                    if(DateConverterHelper.isAfterCurrentDateTime(date)) {
                      tripController.setFinalTripDateTime(date);
                      Get.back();
                    } else {
                      showCustomSnackBar('you_cannot_select_before_current_time'.tr);
                    }
                    date = date;
                  } : null,
                ),

              ]),
            ),
          ),

        ]),
      );
    });
  }
}