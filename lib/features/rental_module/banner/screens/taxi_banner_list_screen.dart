import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:sixam_mart_store/features/rental_module/banner/controllers/taxi_banner_controller.dart';
import 'package:sixam_mart_store/features/rental_module/banner/screens/taxi_add_banner_screen.dart';
import 'package:sixam_mart_store/features/rental_module/banner/widgets/shimmer/banner_list_shimmer.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:sixam_mart_store/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TaxiBannerListScreen extends StatefulWidget {
  const TaxiBannerListScreen({super.key});

  @override
  State<TaxiBannerListScreen> createState() => _TaxiBannerListScreenState();
}

class _TaxiBannerListScreenState extends State<TaxiBannerListScreen> {
  
  final tooltipController = JustTheController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    TaxiBannerController taxiBannerController = Get.find<TaxiBannerController>();
    
    taxiBannerController.getBannerList(offset: '1', willUpdate: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!taxiBannerController.isLoading && taxiBannerController.taxiBannerList != null) {
          int nextPage = (taxiBannerController.taxiBannerList!.length ~/ taxiBannerController.pageSize!) + 1;
          taxiBannerController.getBannerList(offset: nextPage.toString());
        }
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'banner_list'.tr,
        menuWidget: Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
          child: JustTheTooltip(
            backgroundColor: Colors.black87,
            controller: tooltipController,
            preferredDirection: AxisDirection.down,
            tailLength: 14,
            tailBaseWidth: 20,
            content: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  Image.asset(Images.noteIcon, height: 21, width: 21),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text('note'.tr, style: robotoBold.copyWith(color: Colors.white)),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Text('customer_will_see_these_banners_in_your_store_details_page_in_website_and_user_apps'.tr,
                  style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                ),
              ]),
            ),
            child: InkWell(
              onTap: () => tooltipController.showTooltip(),
              child: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            ),
            // child: const Icon(Icons.info_outline),
          ),
        ),
      ),

      body: GetBuilder<TaxiBannerController>(builder: (taxiBannerController) {
        return Column(children: [
          Expanded(
            child: taxiBannerController.taxiBannerList != null ? taxiBannerController.taxiBannerList!.isNotEmpty ? ListView.builder(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              controller: _scrollController,
              shrinkWrap: true,
              itemCount: taxiBannerController.taxiBannerList!.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 200, width: Get.width,
                  margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 3),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                  ),
                  child: Column(children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                        child: CustomImageWidget(
                          image: '${taxiBannerController.taxiBannerList![index].imageFullUrl}',
                          fit: BoxFit.cover, width: Get.width,
                        ),
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                          Wrap(crossAxisAlignment: WrapCrossAlignment.center, runAlignment: WrapAlignment.center, children: [
                            Text('${'redirection_url'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: taxiBannerController.taxiBannerList![index].defaultLink != null ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).disabledColor)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            InkWell(
                              onTap: () {
                                if(taxiBannerController.taxiBannerList![index].defaultLink != null) {
                                  _launchURL(taxiBannerController.taxiBannerList![index].defaultLink.toString());
                                }
                              },
                              child: Text(taxiBannerController.taxiBannerList![index].defaultLink == null ? 'N/A' : taxiBannerController.taxiBannerList![index].defaultLink.toString(),
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: taxiBannerController.taxiBannerList![index].defaultLink != null ? Colors.blue : Theme.of(context).disabledColor),
                              ),
                            ),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Wrap(crossAxisAlignment: WrapCrossAlignment.center, runAlignment: WrapAlignment.center, children: [
                            Text('${'title'.tr}: ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(taxiBannerController.taxiBannerList![index].title.toString(), style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ]),
                        ],
                      )),

                      InkWell(
                        onTap: (){
                          taxiBannerController.getBannerDetails(taxiBannerController.taxiBannerList![index].id!).then((bannerDetails) {
                            if(bannerDetails != null) {
                              Get.to(TaxiAddBannerScreen(taxiBanner: bannerDetails));
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.blue, size: 15,),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      InkWell(
                        onTap: (){
                          Get.dialog(ConfirmationDialogWidget(icon: Images.support, description: 'are_you_sure_to_delete_this_banner'.tr,
                            onYesPressed: () {
                            if(taxiBannerController.taxiBannerList![index].id != null) {
                              taxiBannerController.deleteBanner(taxiBannerController.taxiBannerList![index].id);
                            }
                          }), useSafeArea: false);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.error),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error, size: 15),
                        ),
                      ),

                    ]),
                  ]),
                );
              },
            ) : Center(child: Text('no_banner_found'.tr)) : const BannerListShimmer(),
          ),

          taxiBannerController.isLoading ? const Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: CircularProgressIndicator(),
          )) : const SizedBox(),

          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
            ),
            child: CustomButtonWidget(
              onPressed: () => Get.to(const TaxiAddBannerScreen()),
              buttonText: 'add_new_banner'.tr,
            ),
          ),
        ]);
      }),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

}
