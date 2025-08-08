import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/controllers/taxi_coupon_controller.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/screens/taxi_add_coupon_screen.dart';
import 'package:sixam_mart_store/features/rental_module/coupon/widgets/taxi_coupon_card_dialogue_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_loader_widget.dart';

class TaxiCouponScreen extends StatefulWidget {
  const TaxiCouponScreen({super.key});

  @override
  State<TaxiCouponScreen> createState() => _TaxiCouponScreenState();
}

class _TaxiCouponScreenState extends State<TaxiCouponScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    TaxiCouponController taxiCouponController = Get.find<TaxiCouponController>();
    
    taxiCouponController.getCouponList(offset: '1', willUpdate: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!taxiCouponController.isLoading && taxiCouponController.couponList != null) {
          int nextPage = (taxiCouponController.couponList!.length ~/ taxiCouponController.pageSize!) + 1;
          taxiCouponController.getCouponList(offset: nextPage.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'coupon'.tr),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const TaxiAddCouponScreen()),
        child: Icon(Icons.add_circle_outline, size: 30, color: Theme.of(context).cardColor),
      ),
      body: GetBuilder<TaxiCouponController>(builder: (taxiCouponController) {
        return RefreshIndicator(
          onRefresh: () async{
            await taxiCouponController.getCouponList(offset: '1');
          },
          child: taxiCouponController.couponList != null ? taxiCouponController.couponList!.isNotEmpty ? ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: taxiCouponController.couponList!.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Get.dialog(TaxiCouponCardDialogueWidget(couponBody: taxiCouponController.couponList![index], index: index), barrierDismissible: true, useSafeArea: true);
                },
                child: SizedBox(
                  height: 150,
                  child: Stack(children: [

                    Transform.rotate(
                      angle: Get.find<LocalizationController>().isLtr ? 0 : pi,
                      child: SizedBox(
                        height: 150,
                        child: Image.asset(Images.couponBgDark, fit: BoxFit.fill),
                      ),
                    ),

                    Row(children: [

                      Expanded(flex: 3, child: Container(
                        height: 50, width: 50, alignment: Alignment.center,
                        padding: EdgeInsets.only(left: Get.find<LocalizationController>().isLtr ? 50.0 : 0, bottom: Get.find<LocalizationController>().isLtr ? 10 : 0, right: 0),
                        child: Stack(
                          children: [
                            Center(child: Image.asset(Images.couponVertical, color: Theme.of(context).primaryColor)),
                            Center(
                              child: Text(taxiCouponController.couponList![index].discountType == 'percent' ? '%' : '\$',
                                style: robotoBold.copyWith(fontSize: 18, color: Theme.of(context).cardColor),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(width: 20),

                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge, horizontal: Dimensions.paddingSizeLarge),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                              Text(
                                '${'${taxiCouponController.couponList![index].couponType == 'free_delivery' ? 'free_delivery'.tr : taxiCouponController.couponList![index].discountType != 'percent' ?
                                PriceConverterHelper.convertPrice(double.parse(taxiCouponController.couponList![index].discount.toString())) :
                                taxiCouponController.couponList![index].discount}'} ${taxiCouponController.couponList![index].couponType == 'free_delivery' ? '' : taxiCouponController.couponList![index].discountType == 'percent' ? '%' : ''}'
                                '${taxiCouponController.couponList![index].couponType == 'free_delivery' ? '' : 'off'.tr}',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                              ),

                              Row(children: [
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    activeTrackColor: Theme.of(context).primaryColor,
                                    inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                                    value: taxiCouponController.couponList![index].status == 1 ? true : false,
                                    onChanged: (bool status){
                                      taxiCouponController.changeStatus(taxiCouponController.couponList![index].id).then((success) {
                                        if(success){
                                          taxiCouponController.getCouponList(offset: '1');
                                        }
                                      });
                                    },
                                  ),
                                ),

                                PopupMenuButton(
                                  itemBuilder: (context) {
                                    return <PopupMenuEntry>[
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Text('edit'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Text('delete'.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.red)),
                                      ),
                                    ];
                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                  offset: const Offset(-20, 20),
                                  child: const Padding(
                                    padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                    child: Icon(Icons.more_vert, size: 25),
                                  ),
                                  onSelected: (dynamic value) {
                                    if (value == 'delete') {
                                      Get.dialog(ConfirmationDialogWidget(
                                        icon: Images.warning, title: 'are_you_sure_to_delete'.tr, description: 'you_want_to_delete_this_coupon'.tr,
                                        onYesPressed: () {
                                          taxiCouponController.deleteCoupon(taxiCouponController.couponList![index].id).then((success) {
                                            if(success){
                                              taxiCouponController.getCouponList(offset: '1');
                                            }
                                          });
                                        },
                                      ), barrierDismissible: false);

                                    }else{
                                      Get.dialog(const CustomLoaderWidget());
                                      taxiCouponController.getCouponDetails(taxiCouponController.couponList![index].id!).then((couponDetails) {
                                        Get.back();
                                        if(couponDetails != null) {
                                          Get.to(() => TaxiAddCouponScreen(coupon: couponDetails));
                                        }
                                      });
                                    }
                                  }
                                ),
                              ]),
                            ]),

                            Text('${'code'.tr}: ${taxiCouponController.couponList![index].code!}', style: robotoMedium),
                            const SizedBox(height: 5),

                            Text('${'total_users'.tr}: ${taxiCouponController.couponList![index].totalUses}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                            const SizedBox(height: 5),

                            Text('${'valid_until'.tr} ${taxiCouponController.couponList![index].startDate!} ${'to'.tr} ${taxiCouponController.couponList![index].expireDate!}',
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall),
                            ),

                          ]),
                        ),
                      ),

                    ]),
                  ]),
                ),
              );
            },
          ) : Center(child: Text('no_coupon_found'.tr)) : const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
