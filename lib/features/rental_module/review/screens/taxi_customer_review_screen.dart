import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/features/rental_module/common/widgets/search_field_widget.dart';
import 'package:sixam_mart_store/features/rental_module/provider/controllers/provider_controller.dart';
import 'package:sixam_mart_store/features/rental_module/provider/domain/models/taxi_review_model.dart';
import 'package:sixam_mart_store/features/rental_module/review/widgets/customer_review_screen_shimmer.dart';
import 'package:sixam_mart_store/features/rental_module/review/widgets/review_card_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class TaxiCustomerReviewScreen extends StatefulWidget {
  const TaxiCustomerReviewScreen({super.key});

  @override
  State<TaxiCustomerReviewScreen> createState() => _TaxiCustomerReviewScreenState();
}

class _TaxiCustomerReviewScreenState extends State<TaxiCustomerReviewScreen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<ProviderController>().getProviderReviewList('', willUpdate: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBarWidget(title: 'customer_reviews'.tr),
      body: GetBuilder<ProviderController>(builder: (providerController) {

        List<TaxiReviewModel>? searchReviewList;
        if(providerController.isSearching) {
          searchReviewList = providerController.searchReviewList;
        } else {
          searchReviewList = providerController.providerReviewList;
        }

        return Column(children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: SizedBox(
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: SearchFieldWidget(
                  fromReview: true,
                  controller: _searchController,
                  hint: '${'search_by_trip_id_vehicle_or_customer'.tr}...',
                  suffixIcon: providerController.isSearching ? CupertinoIcons.clear_thick : CupertinoIcons.search,
                  iconPressed: () {
                    if (!providerController.isSearching) {
                      if (_searchController.text.trim().isNotEmpty) {
                        providerController.getProviderReviewList(_searchController.text.trim());
                      } else {
                        showCustomSnackBar('write_trip_id_vehicle_name_for_search'.tr);
                      }
                    } else {
                      _searchController.clear();
                      providerController.getProviderReviewList("");
                    }
                  },
                  onSubmit: (String text) {
                    if (_searchController.text.trim().isNotEmpty) {
                      providerController.getProviderReviewList(_searchController.text.trim());
                    } else {
                      showCustomSnackBar('write_order_id_food_name_for_search'.tr);
                    }
                  },
                ),

              ),
            ),
          ),

          Expanded(
            child: searchReviewList != null ? searchReviewList.isNotEmpty ? ListView.builder(
              itemCount: searchReviewList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                  child: ReviewCardWidget(review: searchReviewList![index]),
                );
              },
            ) : Padding(padding: EdgeInsets.only(top: context.height * 0.35), child: Text('no_review_found'.tr)) : const CustomerReviewScreenShimmer(),
          ),
        ]);
      }),
    );
  }
}
