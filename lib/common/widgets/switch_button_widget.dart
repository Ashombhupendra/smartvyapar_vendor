import 'package:flutter/cupertino.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool? isButtonActive;
  final Function onTap;
  const SwitchButtonWidget({super.key, required this.icon, required this.title, required this.onTap, this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
          vertical: isButtonActive != null ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 850 : 200]!, spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          Icon(icon, size: 25),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text(title, style: robotoRegular)),

          isButtonActive != null ? Transform.scale(
           scale: 0.7,
           child: CupertinoSwitch(
             value: isButtonActive!,
             onChanged: (bool? value) => onTap(),
             activeTrackColor: Theme.of(context).primaryColor,
             inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
           ),
         ) : const SizedBox(),

        ]),
      ),
    );
  }
}
