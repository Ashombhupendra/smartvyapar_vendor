import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class TripListShimmer extends StatelessWidget {
  const TripListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
            child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: Get.isDarkMode ? 0.5 : 0.2)),
          ),
          child: const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmerWidget(height: 15, width: 100),
                      SizedBox(height: Dimensions.paddingSizeDefault),
                      CustomShimmerWidget(height: 10, width: 150),
                    ],
                  ),
                  CustomShimmerWidget(height: 15, width: 50),
                ],
              ),
            ],
          )),
        );
      },
    );
  }
}
