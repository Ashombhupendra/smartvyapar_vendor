import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_tool_tip_widget.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class BillTitleAmountWidget extends StatefulWidget {
  final String title;
  final double amount;
  final bool isBoldText;
  final bool isAdd;
  final bool isSubtract;
  final bool isInfo;
  final bool isEditAmount;

  const BillTitleAmountWidget({
    super.key,
    required this.title,
    required this.amount,
    this.isBoldText = false,
    this.isAdd = false,
    this.isSubtract = false,
    this.isInfo = false,
    this.isEditAmount = false,
  });

  @override
  State<BillTitleAmountWidget> createState() => _BillTitleAmountWidgetState();
}

class _BillTitleAmountWidgetState extends State<BillTitleAmountWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Text(widget.title, style: widget.isBoldText ? robotoBold : robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))),
        SizedBox(width: widget.isInfo ? Dimensions.paddingSizeExtraSmall : 0),

        widget.isInfo ? CustomToolTip(message: 'This is the amount of the bill', child: Icon(Icons.info_outline, size: 15, color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7))) : const SizedBox(),
      ]),

      Row(children: [
        widget.isEditAmount ? Text('(${'edited'.tr})', style: robotoRegular.copyWith(color: Colors.blue),) : const SizedBox(),
        SizedBox(width: widget.isEditAmount ? Dimensions.paddingSizeSmall : 0),

        Text(
          widget.isAdd ? '+ ${PriceConverterHelper.convertPrice(widget.amount)}' : widget.isSubtract ? '- ${PriceConverterHelper.convertPrice(widget.amount)} ' : PriceConverterHelper.convertPrice(widget.amount),
          style: widget.isBoldText ? robotoBold : robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color?.withValues(alpha: 0.7)),
        ),
      ]),
    ]);
  }
}
