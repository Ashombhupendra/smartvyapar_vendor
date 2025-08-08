import 'package:flutter/material.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/util/dimensions.dart';

class OverFlowContainerWidget extends StatelessWidget {
  final String image;
  const OverFlowContainerWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: 60, width: 60,
      decoration:  BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
      child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: CustomImageWidget(image: image, fit: BoxFit.cover, height: 60, width: 60),
      ),
    );
  }
}
