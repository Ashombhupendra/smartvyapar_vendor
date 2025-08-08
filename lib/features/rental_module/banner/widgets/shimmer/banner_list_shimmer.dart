import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class BannerListShimmer extends StatelessWidget {
  const BannerListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 180, width: Get.width,
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 3),
            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: Get.isDarkMode ? 0.5 : 0.2)),
          ),
          child: const Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                  child: CustomShimmerWidget(height: 150, width: double.infinity),
                ),
              ),
              SizedBox(height: Dimensions.paddingSizeDefault),
              Row(
                children: [
                  Expanded(child: CustomShimmerWidget(height: 20, width: 100)),
                  SizedBox(width: Dimensions.paddingSizeDefault),
                  CustomShimmerWidget(height: 20, width: 20), // For edit button
                  SizedBox(width: Dimensions.paddingSizeSmall),
                  CustomShimmerWidget(height: 20, width: 20), // For delete button
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
