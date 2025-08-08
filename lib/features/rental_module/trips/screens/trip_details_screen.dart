import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_bottom_sheet_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/domain/models/taxi_conversation_model.dart';
import 'package:sixam_mart_store/features/rental_module/chat/screens/taxi_chat_screen.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/custom_slider_button.dart';
import 'package:sixam_mart_store/features/rental_module/profile/controllers/taxi_profile_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/controllers/trip_controller.dart';
import 'package:sixam_mart_store/features/rental_module/trips/domain/models/trip_details_model.dart';
import 'package:sixam_mart_store/features/rental_module/trips/screens/edit_trip_details_screen.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/assign_driver_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/bill_title_amount_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/confirm_payment_bottom_sheet.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/select_driver_widget.dart';
import 'package:sixam_mart_store/features/rental_module/trips/widgets/select_vehicle_widget.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  final String? tripStatus;
  final bool fromNotification;
  const TripDetailsScreen({super.key, required this.tripId, this.tripStatus, this.fromNotification = false});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {

  @override
  void initState() {
    super.initState();
    TripController tripController = Get.find<TripController>();

    tripController.getTripDetails(tripId: widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(builder: (tripController) {

      TripDetailsModel? tripDetails = tripController.tripDetailsModel;
      List<DriverData> driverList = [];
      bool isVehicleDeleted = false;

      if(tripDetails != null){
       for(int i = 0; i < tripDetails.tripDetails!.length; i++) {
         if(tripDetails.tripDetails?[i].vehicle == null) {
           isVehicleDeleted = true;
         }
       }
      }

      if(tripDetails != null){
       for(int i = 0; i < tripDetails.vehicleIdentity!.length; i++) {
         if(tripDetails.vehicleIdentity![i].driverData != null) {
           driverList.add(tripDetails.vehicleIdentity![i].driverData!);
         }
       }
      }

      double? tripAmount = 0;
      if(tripDetails != null){
        for(int i = 0; i < tripDetails.tripDetails!.length; i++) {
          tripAmount = (tripAmount! + tripDetails.tripDetails![i].calculatedPrice!);
        }
      }
      double? discountOnTrip = tripDetails != null ? tripDetails.discountOnTrip : 0;
      double? couponDiscountAmount = tripDetails != null ? tripDetails.couponDiscountAmount : 0;
      double? referralDiscount = tripDetails != null ? tripDetails.refBonusAmount : 0;
      double? subTotal = tripAmount! - (discountOnTrip! + couponDiscountAmount! + referralDiscount!);
      double? vatAmount = tripDetails != null ? tripDetails.taxAmount : 0;
      double? serviceFee = tripDetails != null ? tripDetails.additionalCharge : 0;
      double? totalAmount = tripDetails != null ? tripDetails.tripAmount : 0;
      double? partiallyPaidAmount = tripDetails != null ? tripDetails.partiallyPaidAmount : 0;
      double? duePayment = totalAmount! - partiallyPaidAmount!;

      bool pending = tripDetails != null && tripDetails.tripStatus == 'pending';
      bool confirmed = tripDetails != null && tripDetails.tripStatus == 'confirmed';
      bool ongoing = tripDetails != null && tripDetails.tripStatus == 'ongoing';
      bool completed = tripDetails != null && tripDetails.tripStatus == 'completed';
      bool canceled = tripDetails != null && tripDetails.tripStatus == 'canceled';
      bool paymentFailed = tripDetails != null && tripDetails.tripStatus == 'payment_failed';
      bool isPaid = tripDetails != null && tripDetails.paymentStatus == 'paid';
      bool partialPayment = tripDetails != null && tripDetails.paymentMethod == 'partial_payment';
      bool taxIncluded = tripDetails != null && tripDetails.taxStatus == 'included';

      return PopScope(
        canPop: Navigator.canPop(context),
        onPopInvokedWithResult: (didPop, result) async{
          if(widget.fromNotification && !didPop) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            return;
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),

          appBar: AppBar(
            title: Column(children: [
              Text(
                '${'trip_id'.tr} #${tripDetails != null ? tripDetails.id : widget.tripId}',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge!.color),
              ),

              Text(
                tripDetails != null ? tripDetails.tripStatus?.tr ?? '' : widget.tripStatus?.tr ?? '',
                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
              ),
            ]),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: (){
                if(widget.fromNotification) {
                  Get.offAllNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.back();
                }
              },
            ),
            backgroundColor: Theme.of(context).cardColor,
            surfaceTintColor: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).disabledColor.withValues(alpha: 0.5),
            elevation: 2,
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              await tripController.getTripDetails(tripId: widget.tripId);
            },
            child: tripDetails != null ? Column(children: [

              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [

                    Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).cardColor,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                        Text('customer'.tr, style: robotoBold),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          ClipOval(
                            child: CustomImageWidget(
                              image: tripDetails.customer?.imageFullUrl ?? '',
                              height: 60, width: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          Expanded(
                            child: tripDetails.isGuest! ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text(tripDetails.userInfo?.contactPersonName ?? '', style: robotoMedium),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(tripDetails.userInfo?.contactPersonNumber ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(tripDetails.userInfo?.contactPersonEmail ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),
                            ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('${tripDetails.customer?.fName ?? ''} ${tripDetails.customer?.lName ?? ''}', style: robotoMedium),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text('${'total_trips'.tr}: '),
                                  Text(tripDetails.customer?.tripsCount.toString() ?? '0', style: robotoBold),
                                ]),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Text(tripDetails.customer?.phone ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                              Text(tripDetails.customer?.email ?? '', style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),
                            ]),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeSmall),

                          (!completed && !paymentFailed && Get.find<TaxiProfileController>().taxiModulePermission!.chat! && !canceled) ? tripDetails.isGuest! ? const SizedBox() : InkWell(
                            onTap: () async {
                              if(Get.find<TaxiProfileController>().profileModel!.subscription != null && Get.find<TaxiProfileController>().profileModel!.subscription!.chat == 0
                                && Get.find<TaxiProfileController>().profileModel!.stores![0].storeBusinessModel == 'subscription') {
                                showCustomSnackBar('you_have_no_available_subscription'.tr);
                              } else {
                                await Get.to(() => TaxiChatScreen(
                                  notificationBody: NotificationBodyModel(
                                    orderId: tripDetails.id, customerId: tripDetails.customer!.id,
                                  ),
                                  user: User(
                                    id: tripDetails.customer!.id, fName: tripDetails.customer!.fName,
                                    lName: tripDetails.customer!.lName, imageFullUrl: tripDetails.customer!.imageFullUrl,
                                  ),
                                ));
                              }
                            },
                            child: const CustomAssetImageWidget(
                              Images.chatIcon, height: 25, width: 25,
                            ),
                          ) : const SizedBox(),
                          SizedBox(width: tripDetails.isGuest! ? 0 : Dimensions.paddingSizeLarge),

                          InkWell(
                            onTap: () async {
                              if(tripDetails.isGuest!){
                                if(await canLaunchUrlString('tel:${tripDetails.userInfo?.contactPersonNumber ?? '' }')) {
                                  launchUrlString('tel:${tripDetails.userInfo?.contactPersonNumber ?? '' }', mode: LaunchMode.externalApplication);
                                }else {
                                  showCustomSnackBar('${'can_not_launch'.tr} ${tripDetails.userInfo?.contactPersonNumber ?? ''}');
                                }
                              } else {
                                if(await canLaunchUrlString('tel:${tripDetails.customer?.phone ?? '' }')) {
                                  launchUrlString('tel:${tripDetails.customer?.phone ?? '' }', mode: LaunchMode.externalApplication);
                                }else {
                                  showCustomSnackBar('${'can_not_launch'.tr} ${tripDetails.customer?.phone ?? ''}');
                                }
                              }
                            },
                            child: const CustomAssetImageWidget(Images.callIcon, height: 25, width: 25),
                          ),

                        ]),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).cardColor,
                      child: Column(children: [

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('trip_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                          !isVehicleDeleted ? pending ? InkWell(
                            onTap: () {
                              Get.to(() => EditTripDetailsScreen(tripDetails: tripController.tripDetailsModel!));
                            },
                            child: Row(children: [
                              CustomAssetImageWidget(Images.editIconOutlined, height: 20, width: 20, color: Theme.of(context).primaryColor),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Text('edit'.tr, style: robotoBold.copyWith(color: Theme.of(context).disabledColor)),
                            ]),
                          ) : const SizedBox() : const SizedBox(),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: SizedBox(
                            height: 88,
                            child: Row(children: [
                              Column(children: [
                                Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Icon(Icons.location_on_sharp, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                                ),

                                Column(
                                  children: List.generate(4, (index){
                                    return Container(
                                      margin: EdgeInsets.only(top: index == 0 ? 0 : 5),
                                      color: Theme.of(context).disabledColor.withValues(alpha: 0.5),
                                      height: 3,
                                      width: 1,
                                    );
                                  }),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Transform.rotate(
                                    angle: -0.9,
                                    child: Icon(Icons.send_rounded, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                                  ),
                                ),
                              ]),
                              const SizedBox(width: Dimensions.paddingSizeSmall),

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(
                                      'home'.tr,
                                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                    ),
                                    Text(
                                      tripDetails.pickupLocation?.locationName ?? '',
                                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                    ),
                                  ]),
                                  const SizedBox(height: 30),

                                  Text(
                                    tripDetails.destinationLocation?.locationName ?? '',
                                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Icon(Icons.calendar_month, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  tripDetails.scheduled == 1 ? 'scheduled_at'.tr : 'booked_at'.tr,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                ),

                                Text(
                                  DateConverterHelper.dayDateTime(tripDetails.scheduleAt!),
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),
                              ]),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: Row(children: [
                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall + 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              ),
                              child: Icon(Icons.hourglass_empty, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 16),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(
                                  'rent_type'.tr,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,  color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                                ),

                                Text(
                                  '${tripDetails.tripType?.tr} (${tripDetails.tripType == 'hourly' ? '${'estimated'.tr} ${tripDetails.estimatedHours?.toStringAsFixed(2)}hr' : '${'estimated'.tr} ${tripDetails.distance?.toStringAsFixed(2)}km'})',
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),
                              ]),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    tripDetails.tripNote != null ? Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).cardColor,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('additional_notes'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

                        Text(
                          tripDetails.tripNote ?? '',
                          style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7)),
                        ),
                      ]),
                    ) : const SizedBox(),
                    SizedBox(height: tripDetails.tripNote != null ? Dimensions.paddingSizeSmall : 0),

                    const SelectVehicleWidget(),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    tripDetails.vehicleIdentity != null && tripDetails.vehicleIdentity!.isNotEmpty && driverList.isNotEmpty
                     ? const AssignDriverWidget() : tripDetails.vehicleIdentity != null && tripDetails.vehicleIdentity!.isNotEmpty && driverList.isEmpty ? const SelectDriverWidget() : const SizedBox(),

                    Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      color: Theme.of(context).cardColor,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('bill_details'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        BillTitleAmountWidget(
                          title: 'trip_cost'.tr,
                          amount: tripAmount,
                          isEditAmount: tripController.tripDetailsModel?.edited == 1,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        BillTitleAmountWidget(title: 'trip_discount'.tr, amount: discountOnTrip, isSubtract: true),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        BillTitleAmountWidget(title: 'coupon_discount'.tr, amount: couponDiscountAmount, isSubtract: true),
                        referralDiscount == 0 ? const Divider() : const SizedBox(),

                        referralDiscount != 0 ? BillTitleAmountWidget(title: 'referral_discount'.tr, amount: referralDiscount, isSubtract: true) : const SizedBox(),
                        referralDiscount != 0 ? const Divider() : const SizedBox(),

                        BillTitleAmountWidget(title: '${'subtotal'.tr} ${taxIncluded ? '(${'vat_included'.tr})' : ''}', amount: subTotal),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        taxIncluded ? const SizedBox() : BillTitleAmountWidget(title: '${'vat'.tr} (${tripDetails.taxPercentage}%)'.tr, amount: vatAmount!, isAdd: true),
                        SizedBox(height: taxIncluded ? 0 : Dimensions.paddingSizeSmall),

                        BillTitleAmountWidget(title: 'service_fee'.tr, amount: serviceFee!, isAdd: true),
                        const Divider(),

                        BillTitleAmountWidget(title: 'total'.tr, amount: totalAmount, isBoldText: true),
                        SizedBox(height: partialPayment ? Dimensions.paddingSizeSmall : 0),

                        partialPayment ? BillTitleAmountWidget(title: 'wallet_payment'.tr, amount: partiallyPaidAmount, isSubtract: true) : const SizedBox(),
                        SizedBox(height: partialPayment ? Dimensions.paddingSizeSmall : 0),

                        partialPayment ? BillTitleAmountWidget(title: 'due_payment'.tr, amount: duePayment) : const SizedBox(),

                      ]),
                    ),

                  ]),
                ),
              ),

              (completed && isPaid) || canceled || paymentFailed ? const SizedBox() : Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                ),
                child: pending ? Row(children: [

                  Expanded(
                    child: Container(
                      height: 43,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.5)),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: CustomButtonWidget(
                        onPressed: () {
                          Get.dialog(
                            ConfirmationDialogWidget(
                              icon: Images.warning,
                              description: 'are_you_sure_to_cancel'.tr,
                              onYesPressed: (){
                                tripController.updateTripStatus(tripId: tripController.tripDetailsModel!.id!, status: 'canceled').then((value) {
                                  Navigator.pop(Get.context!);
                                });
                              },
                            ),
                          );
                        },
                        buttonText: 'cancel_booking'.tr,
                        textColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
                        color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: CustomButtonWidget(
                      isLoading: tripController.isStatusLoading,
                      onPressed: () {
                        tripController.updateTripStatus(tripId: tripController.tripDetailsModel!.id!, status: 'confirmed');
                      },
                      buttonText: 'confirm'.tr,
                    ),
                  ),
                ]) : CustomSliderButton(
                  buttonText: confirmed ? 'swipe_to_ongoing'.tr : ongoing ? 'swipe_to_complete'.tr : completed ? 'swipe_to_confirm_payment'.tr : '',
                  onPressed: () {
                    if(confirmed){
                      tripController.updateTripStatus(tripId: tripController.tripDetailsModel!.id!, status: 'ongoing');
                    } else if(ongoing){
                      tripController.updateTripStatus(tripId: tripController.tripDetailsModel!.id!, status: 'completed');
                    }else if(completed){
                      showCustomBottomSheet(child: const ConfirmPaymentBottomSheet());
                    }
                  },
                ),
              ),

            ]) : const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    });
  }
}
