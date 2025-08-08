import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ItemScrollPhysics extends ScrollPhysics {
  final double? itemHeight;
  final double targetPixelsLimit;

  const ItemScrollPhysics({
    super.parent,
    this.itemHeight,
    this.targetPixelsLimit = 3.0,
  })  : assert(itemHeight != null && itemHeight > 0);

  @override
  ItemScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return ItemScrollPhysics(
        parent: buildParent(ancestor), itemHeight: itemHeight);
  }

  double _getItem(ScrollPosition position) {
    double maxScrollItem =
    (position.maxScrollExtent / itemHeight!).floorToDouble();
    return min(max(0, position.pixels / itemHeight!), maxScrollItem);
  }

  double _getPixels(ScrollPosition position, double item) {
    return item * itemHeight!;
  }

  double _getTargetPixels(
      ScrollPosition position, Tolerance tolerance, double velocity) {
    double item = _getItem(position);
    if (velocity < -tolerance.velocity) {
      item -= targetPixelsLimit;
    } else if (velocity > tolerance.velocity) {
      item += targetPixelsLimit;
    }
    return _getPixels(position, item.roundToDouble());
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    Tolerance tolerance = const Tolerance();
    final double target =
    _getTargetPixels(position as ScrollPosition, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(spring, position.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

typedef SelectedIndexCallback = void Function(int);
typedef TimePickerCallback = void Function(DateTime);



class TimePickerSpinner extends StatefulWidget {
  final DateTime? time;
  final int minutesInterval;
  final int secondsInterval;
  final bool is24HourMode;
  final bool isShowSeconds;
  final TextStyle? highlightedTextStyle;
  final TextStyle? normalTextStyle;
  final double? itemHeight;
  final double? itemWidth;
  final AlignmentGeometry? alignment;
  final double? spacing;
  final bool isForce2Digits;
  final TimePickerCallback? onTimeChange;
  final Function(bool) scrollOff;

  const TimePickerSpinner(
      {super.key,
        this.time,
        this.minutesInterval = 1,
        this.secondsInterval = 1,
        this.is24HourMode = true,
        this.isShowSeconds = false,
        this.highlightedTextStyle,
        this.normalTextStyle,
        this.itemHeight,
        this.itemWidth,
        this.alignment,
        this.spacing,
        this.isForce2Digits = false,
        this.onTimeChange,
        required this.scrollOff,
      })
  ;

  @override
  TimePickerSpinnerState createState() => TimePickerSpinnerState();
}

class TimePickerSpinnerState extends State<TimePickerSpinner> {
  ScrollController hourController = ScrollController();
  ScrollController minuteController = ScrollController();
  ScrollController secondController = ScrollController();
  ScrollController apController = ScrollController();
  int currentSelectedHourIndex = -1;
  int currentSelectedMinuteIndex = -1;
  int currentSelectedSecondIndex = -1;
  int currentSelectedAPIndex = -1;
  DateTime? currentTime;
  bool isHourScrolling = false;
  bool isMinuteScrolling = false;
  bool isSecondsScrolling = false;
  bool isAPScrolling = false;

  TextStyle defaultHighlightTextStyle =
  const TextStyle(fontSize: 32, color: Colors.black);
  TextStyle defaultNormalTextStyle =
  const TextStyle(fontSize: 32, color: Colors.black54);
  double defaultItemHeight = 60;
  double defaultItemWidth = 45;
  double defaultSpacing = 20;
  AlignmentGeometry defaultAlignment = Alignment.centerRight;

  TextStyle? _getHighlightedTextStyle() {
    return widget.highlightedTextStyle ?? defaultHighlightTextStyle;
  }

  TextStyle? _getNormalTextStyle() {
    return widget.normalTextStyle ?? defaultNormalTextStyle;
  }

  int _getHourCount() {
    return widget.is24HourMode ? 24 : 12;
  }

  int _getMinuteCount() {
    return (60 / widget.minutesInterval).floor();
  }

  int _getSecondCount() {
    return (60 / widget.secondsInterval).floor();
  }

  double? _getItemHeight() {
    return widget.itemHeight ?? defaultItemHeight;
  }

  double? _getItemWidth() {
    return widget.itemWidth ?? defaultItemWidth;
  }

  double? _getSpacing() {
    return widget.spacing ?? defaultSpacing;
  }

  AlignmentGeometry? _getAlignment() {
    return widget.alignment ?? defaultAlignment;
  }

  bool isLoop(int value) {
    return value > 10;
  }

  DateTime getDateTime() {
    int hour = currentSelectedHourIndex - _getHourCount();
    if (!widget.is24HourMode && currentSelectedAPIndex == 2) hour += 12;
    int minute = (currentSelectedMinuteIndex -
        (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1)) *
        widget.minutesInterval;
    int second = (currentSelectedSecondIndex -
        (isLoop(_getSecondCount()) ? _getSecondCount() : 1)) *
        widget.secondsInterval;
    return DateTime(currentTime!.year, currentTime!.month, currentTime!.day,
        hour, minute, second);
  }

  void setAmPm(int value) {
    setState(() {
      currentSelectedAPIndex = value;
    });
    isAPScrolling = false;
    if (widget.onTimeChange != null) {
      widget.onTimeChange!(getDateTime());
    }
  }

  @override
  void initState() {
    currentTime = widget.time ?? DateTime.now();

    currentSelectedHourIndex =
        (currentTime!.hour % (widget.is24HourMode ? 24 : 12)) + _getHourCount();
    hourController = ScrollController(
        initialScrollOffset:
        (currentSelectedHourIndex - 1) * _getItemHeight()!);

    currentSelectedMinuteIndex =
        (currentTime!.minute / widget.minutesInterval).floor() +
            (isLoop(_getMinuteCount()) ? _getMinuteCount() : 1);
    minuteController = ScrollController(
        initialScrollOffset:
        (currentSelectedMinuteIndex - 1) * _getItemHeight()!);

    currentSelectedSecondIndex =
        (currentTime!.second / widget.secondsInterval).floor() +
            (isLoop(_getSecondCount()) ? _getSecondCount() : 1);
    secondController = ScrollController(
        initialScrollOffset:
        (currentSelectedSecondIndex - 1) * _getItemHeight()!);

    currentSelectedAPIndex = currentTime!.hour >= 12 ? 2 : 1;
    apController = ScrollController(
        initialScrollOffset: (currentSelectedAPIndex - 1) * _getItemHeight()!);

    super.initState();

    if (widget.onTimeChange != null) {

    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> contents = [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.symmetric(vertical: 1),
        width: _getItemWidth(),
        height: _getItemHeight()! * 2.9,
        child: spinner(
          hourController,
          _getHourCount(),
          currentSelectedHourIndex,
          isHourScrolling,
          1, (index) {
          currentSelectedHourIndex = index;
          isHourScrolling = true;
        }, () => isHourScrolling = false,
        ),
      ),
      Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Text(':',style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
      ),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.symmetric(vertical: 1),
        width: _getItemWidth(),
        height: _getItemHeight()! * 2.9,
        child: spinner(
          minuteController,
          _getMinuteCount(),
          currentSelectedMinuteIndex,
          isMinuteScrolling,
          widget.minutesInterval,
              (index) {
            currentSelectedMinuteIndex = index;
            isMinuteScrolling = true;
          },
              () => isMinuteScrolling = false,
        ),
      ),
    ];

    if (widget.isShowSeconds) {
      contents.add(spacer());
      contents.add(Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.symmetric(vertical: 1),
        width: _getItemWidth(),
        height: _getItemHeight()! * 2.9,
        child: spinner(
          secondController,
          _getSecondCount(),
          currentSelectedSecondIndex,
          isSecondsScrolling,
          widget.secondsInterval,
              (index) {
            currentSelectedSecondIndex = index;
            isSecondsScrolling = true;
          },
              () => isSecondsScrolling = false,
        ),
      ));
    }

    if (!widget.is24HourMode) {
      contents.add(const SizedBox(width: Dimensions.paddingSizeSmall,));
      contents.add(SizedBox(
        width: 120,
        height: 70,
        child: apSpinner(),
      ));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: contents,
    );
  }

  Widget spacer() {
    return SizedBox(
      width: _getSpacing(),
      height: _getItemHeight()! * 3,
    );
  }

  Widget spinner(
      ScrollController controller,
      int max,
      int selectedIndex,
      bool isScrolling,
      int interval,
      SelectedIndexCallback onUpdateSelectedIndex,
      VoidCallback onScrollEnd) {

    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() == "ScrollDirection.idle") {
            if (isLoop(max)) {
              int segment = (selectedIndex / max).floor();
              if (segment == 0) {
                onUpdateSelectedIndex(selectedIndex + max);
                controller.jumpTo(controller.offset + (max * _getItemHeight()!));
              } else if (segment == 2) {
                onUpdateSelectedIndex(selectedIndex - max);
                controller
                    .jumpTo(controller.offset - (max * _getItemHeight()!));
              }
            }
            setState(() {
              onScrollEnd();
              widget.scrollOff(true);
              if (widget.onTimeChange != null) {
                widget.onTimeChange!(getDateTime());
              }
            });
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            widget.scrollOff(false);
            onUpdateSelectedIndex(
                (controller.offset / _getItemHeight()!).round() + 1);
          });
        }
        return true;
      },
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          itemBuilder: (context, index) {
            String text = '';
            if (isLoop(max)) {
              text = ((index % max) * interval).toString();
            } else if (index != 0 && index != max + 1) {
              text = (((index - 1) % max) * interval).toString();
            }
            if (!widget.is24HourMode &&
                controller == hourController &&
                text == '0') {
              text = '12';
            }
            if (widget.isForce2Digits && text != '') {
              text = text.padLeft(2, '0');
            }
            return Container(
              height: _getItemHeight(),
              alignment: _getAlignment(),
              child: Center(
                child: Text(
                  text,
                  style: selectedIndex == index
                      ? _getHighlightedTextStyle()
                      : _getNormalTextStyle(),
                ),
              ),
            );
          },
          controller: controller,
          itemCount: isLoop(max) ? max * 3 : max + 2,
          physics: ItemScrollPhysics(itemHeight: _getItemHeight(),targetPixelsLimit: 0),
          padding: EdgeInsets.zero,
        ),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isScrolling
            ? Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0),
            ))
            : Container()
      ],
    );
  }

  Widget apSpinner() {
    bool isAmSelect = currentSelectedAPIndex == 1;
    bool isPmSelect = currentSelectedAPIndex == 2;
    Widget spinner = NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction.toString() == "ScrollDirection.idle") {
            isAPScrolling = false;
            if (widget.onTimeChange != null) {
              widget.onTimeChange!(getDateTime());
            }
          }
        } else if (scrollNotification is ScrollUpdateNotification) {
          setState(() {
            currentSelectedAPIndex = (apController.offset / _getItemHeight()!).round() + 1;
            isAPScrolling = true;
          });
        }
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).disabledColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Row(mainAxisSize: MainAxisSize.min, children: [

          InkWell(
            onTap: () => setAmPm(1),
            child: Container(
              decoration: BoxDecoration(
                color: isAmSelect ? Theme.of(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(
                'am'.tr, style: robotoMedium.copyWith(color: isAmSelect ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          InkWell(
            onTap: () => setAmPm(2),
            child: Container(
              decoration: BoxDecoration(
                color: isPmSelect ? Theme.of(context).primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Text(
                'pm'.tr, style: robotoMedium.copyWith(color: isPmSelect ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color),
              ),
            ),
          ),
        ]),
      ),

    );

    return Stack(
      children: <Widget>[
        Positioned.fill(child: spinner),
        isAPScrolling ? Positioned.fill(child: Container()) : Container()
      ],
    );
  }
}