import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/rental_module/brand/widgets/shimmer/brand_list_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TaxiBrandScreen extends StatefulWidget {
  const TaxiBrandScreen({super.key});

  @override
  State<TaxiBrandScreen> createState() => _TaxiBrandScreenState();
}

class _TaxiBrandScreenState extends State<TaxiBrandScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ProviderController providerController = Get.find<ProviderController>();

    providerController.getBrandList(offset: '1', willUpdate: false);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!providerController.isLoading && providerController.brandsList != null) {
          int nextPage = (providerController.brandsList!.length ~/ providerController.brandPageSize!) + 1;
          providerController.getBrandList(offset: nextPage.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'brands'.tr),

      body: GetBuilder<ProviderController>(builder: (providerController) {
        return providerController.brandsList != null ? providerController.brandsList!.isNotEmpty ? ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          itemCount: providerController.brandsList?.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
              ),
              child: Row(children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImageWidget(
                    image: providerController.brandsList![index].imageFullUrl ?? '',
                    height: 65, width: 65, fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(providerController.brandsList![index].name ?? '', style: robotoRegular, maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(
                      '${'id'.tr}: ${providerController.brandsList![index].id}',
                      style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                    ),
                  ]),
                ),

              ]),
            );
          },
        ) : Center(child: Text('no_brands_found'.tr)) : const BrandListShimmer();
      }),
    );
  }
}
