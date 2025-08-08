import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_shimmer_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomShimmerWidget(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
          margin: EdgeInsets.only(right: index == 9 ? 0 : Dimensions.paddingSizeSmall),
        );
      },
    );
  }
}
