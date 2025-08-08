import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_store/features/order/widgets/slider_button_widget.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomSliderButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;
  const CustomSliderButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SliderButton(
      label: Text(buttonText, style: robotoMedium.copyWith(color: Theme.of(context).cardColor, fontSize: 16.0)),
      dismissThresholds: 0.5, dismissible: false, shimmer: true,
      width: 1170, height: 50, buttonSize: 45, radius: 100,
      icon: Center(child: Icon(
        Get.find<LocalizationController>().isLtr ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
        color: Theme.of(context).primaryColor, size: 20.0,
      )),
      isLtr: Get.find<LocalizationController>().isLtr,
      boxShadow: const BoxShadow(blurRadius: 0),
      buttonColor: Theme.of(context).cardColor,
      backgroundColor: Theme.of(context).primaryColor,
      baseColor: Theme.of(context).primaryColor,
      action: onPressed,
    );
  }
}
