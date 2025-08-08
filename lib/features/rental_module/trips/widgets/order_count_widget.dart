import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class OrderCountWidget extends StatelessWidget {
  final String title;
  final int? count;
  final Color? color;
  const OrderCountWidget({super.key, required this.title, required this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all( Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: color ?? Theme.of(context).cardColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(count.toString(), style: robotoBold.copyWith(
            fontSize: Dimensions.fontSizeExtraLarge, color: color ?? Theme.of(context).cardColor,
          )),

        ]),
      ),
    );
  }
}
