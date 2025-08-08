import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class DriverListShimmer extends StatelessWidget {
  const DriverListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: Get.isDarkMode ? 0.5 : 0.2)),
            ),
            child: const Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmerWidget(height: 60, width: 60),
                    SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomShimmerWidget(height: 15, width: 120),
                          SizedBox(height: Dimensions.paddingSizeSmall),
                          CustomShimmerWidget(height: 12, width: 100),
                        ],
                      ),
                    ),
                    SizedBox(width: Dimensions.paddingSizeSmall),
                    CustomShimmerWidget(height: 20, width: 20),
                  ],
                ),
                SizedBox(height: Dimensions.paddingSizeDefault),
                Padding(
                  padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                  child: Row(
                    children: [
                      Expanded(child: CustomShimmerWidget(height: 50, width: double.infinity)),
                      SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: CustomShimmerWidget(height: 50, width: double.infinity)),
                      SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(child: CustomShimmerWidget(height: 50, width: double.infinity)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
