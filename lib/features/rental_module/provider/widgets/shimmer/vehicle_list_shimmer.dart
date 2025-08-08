import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleListShimmer extends StatelessWidget {
  const VehicleListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge,
            top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall,
          ),
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).disabledColor.withValues(alpha: 0.2)),
            ),
            child: Column(children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Shimmer(
                  child: Container(
                    width: 100,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                    ),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall - 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6), size: 20),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                      Text(
                        '0.0',
                        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                child: Shimmer(
                  child: Container(
                    height: 145,
                    decoration: BoxDecoration(
                      color: Theme.of(context).shadowColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(children: [

                Expanded(
                  child: Shimmer(
                    child: Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).shadowColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 70),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),
                const SizedBox(width: Dimensions.paddingSizeDefault),

                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                ),

              ]),
            ]),
          ),
        );
      },
        childCount: 10,
      ),
    );
  }
}
