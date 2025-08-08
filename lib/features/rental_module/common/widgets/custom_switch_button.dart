import 'package:flutter/material.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CustomSwitchButton extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final bool isOnOffText;

  const CustomSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.thumbColor = Colors.white,
    this.isOnOffText = false,
  });

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {

  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.value;
  }

  void _toggleSwitch() {
    setState(() {
      _isOn = !_isOn;
    });
    widget.onChanged(_isOn);
  }

  @override
  void didUpdateWidget(covariant CustomSwitchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _isOn = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: _toggleSwitch,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.isOnOffText ? 55 : 50,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: _isOn ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withValues(alpha: 0.5),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              left: _isOn ? widget.isOnOffText ? 20 : 25 : 3,
              right: _isOn ? 3 : widget.isOnOffText ? 20 : 25,
              child: Container(
                margin: EdgeInsets.only(top: widget.isOnOffText ? 2.5 : 2),
                width: 30,
                height: 20.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: widget.isOnOffText ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: widget.isOnOffText ? BorderRadius.circular(Dimensions.radiusLarge) : null,
                  color: Theme.of(context).cardColor,
                ),
                child: widget.isOnOffText ? Text(
                  _isOn ? 'On' : 'Off',
                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: _isOn ? Colors.black : widget.inactiveColor),
                ) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
