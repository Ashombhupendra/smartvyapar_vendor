import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class VehicleGridItem extends StatelessWidget {
  final String label;
  final String? assetImage;

  const VehicleGridItem({super.key, required this.label, this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [

        Image.asset(assetImage!, height: 20, width: 20),
        const SizedBox(width: Dimensions.paddingSizeSmall + 2),

        Flexible(child: Text(label, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall), maxLines: 1, overflow: TextOverflow.ellipsis)),

      ]),
    );
  }
}
