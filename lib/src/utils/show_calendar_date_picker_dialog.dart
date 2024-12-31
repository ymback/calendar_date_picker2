import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_date_picker2/src/models/month_date_range_response.dart';
import 'package:calendar_date_picker2/src/utils/TextStyleUtils.dart';
import 'package:flutter/material.dart';

/// Display CalendarDatePicker with action buttons
Future<MonthDateRangeResponse?> showCalendarDatePicker2Dialog({
  required BuildContext context,
  required CalendarDatePicker2WithActionButtonsConfig config,
  required Size dialogSize,
  required Color selectColor,
  required int initIndex,
  required bool monthSingleChoose,
  required bool daySingleChoose,
  required bool supportChangeMode,
  List<DateTime?> monthValue = const [],
  List<DateTime?> dayValue = const [],
  BorderRadius? borderRadius,
  bool useRootNavigator = true,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  Color? dialogBackgroundColor,
  RouteSettings? routeSettings,
  String? barrierLabel,
  TransitionBuilder? builder,
}) {
  return showDialog<MonthDateRangeResponse?>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      var dialog = Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        backgroundColor: dialogBackgroundColor ?? Theme
            .of(context)
            .canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: DateSelectDialogPage(
            selectColor,
            config,
            monthValue,
            dayValue,
            dialogSize,
            initIndex,
            monthSingleChoose,
            daySingleChoose,
            supportChangeMode),
      );

      return builder == null ? dialog : builder(context, dialog);
    },
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
  );
}

/**
 *@author:Lai Weipeng
 *@time:2024/7/12 11:21
 *@description:请描述功能
 */

class DateSelectDialogPage extends StatefulWidget {
  final Color selectColor;
  final CalendarDatePicker2WithActionButtonsConfig config;
  final List<DateTime?> monthValue;
  final List<DateTime?> dayValue;
  final Size dialogSize;
  final int initIndex;
  final bool monthSingleChoose;
  final bool daySingleChoose;
  final bool supportChangeMode;

  const DateSelectDialogPage(this.selectColor, this.config, this.monthValue, this.dayValue, this.dialogSize,
      this.initIndex, this.monthSingleChoose, this.daySingleChoose, this.supportChangeMode,
      {key})
      : super(key: key);

  @override
  _DateSelectDialogPageState createState() => _DateSelectDialogPageState(monthValue, dayValue, initIndex);
}

class _DateSelectDialogPageState extends State<DateSelectDialogPage> {
  List<DateTime?> monthValue;
  List<DateTime?> dayValue;
  int index;
  Key key1 = UniqueKey();
  Key key2 = UniqueKey();

  @override
  void dispose() {
    super.dispose();
  }

  _DateSelectDialogPageState(this.monthValue, this.dayValue, this.index);

  @override
  Widget build(BuildContext context) {
    return getMainPage();
  }

  Widget getMainPage() {
    final dialogHeight =
    widget.config.dayMaxWidth != null ? widget.dialogSize.height : max(widget.dialogSize.height, 410);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          alignment: Alignment.center,
          child: Text(
            widget.supportChangeMode ? "时间选择" : (
                index==1 ? "月份选择" : "日期选择"
            ),
            style: TextStyle(
              fontSize: TextStyleUtils.getFixedFontSize(context, 16),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        widget.supportChangeMode ? Container(height: 1.0, color: Colors.grey.withOpacity(0.5)) : Container(),
        widget.supportChangeMode
            ? Row(
          children: [
            Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      return;
                    }
                    index = 0;
                    setState(() {});
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                      width: 52.0,
                      height: 3,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "按日选择",
                        style: TextStyle(
                          fontSize: TextStyleUtils.getFixedFontSize(context, 15),
                          color: index == 0 ? widget.selectColor : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 52.0,
                      decoration: BoxDecoration(
                        color: index == 0 ? widget.selectColor : Colors.transparent,
                        borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                      ),
                      height: 3,
                    )
                  ]),
                )),
            Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (index == 1) {
                      return;
                    }
                    index = 1;
                    setState(() {});
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                      width: 52.0,
                      height: 3,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "按月选择",
                        style: TextStyle(
                          fontSize: TextStyleUtils.getFixedFontSize(context, 15),
                          color: index == 1 ? widget.selectColor : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      width: 52.0,
                      decoration: BoxDecoration(
                        color: index == 1 ? widget.selectColor : Colors.transparent,
                        borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100), topRight: Radius.circular(100)),
                      ),
                      height: 3,
                    )
                  ]),
                )),
          ],
        )
            : Container(),
        Container(height: 1.0, color: Colors.grey.withOpacity(0.5)),
        SizedBox(
          width: widget.dialogSize.width,
          height: dialogHeight.toDouble(),
          child: index == 0
              ? CalendarDatePicker2WithActionButtons(
            key: key1,
            value: dayValue,
            config: widget.config.copyWith(
              openedFromDialog: true,
              isOnlyMonthRange: false,
              calendarViewMode: CalendarDatePicker2Mode.scroll,
              scrollViewConstraints: BoxConstraints(maxHeight: dialogHeight.toDouble() - 32 * 2),
              calendarType:
              widget.daySingleChoose ? CalendarDatePicker2Type.single : CalendarDatePicker2Type.range,
            ),
          )
              : CalendarDatePicker2WithActionButtons(
            key: key2,
            value: monthValue,
            config: widget.config.copyWith(
              openedFromDialog: true,
              isOnlyMonthRange: true,
              calendarViewMode: CalendarDatePicker2Mode.month,
              calendarType:
              widget.monthSingleChoose ? CalendarDatePicker2Type.single : CalendarDatePicker2Type.range,
              scrollViewConstraints: widget.config.scrollViewConstraints ??
                  (widget.config.calendarViewMode == CalendarDatePicker2Mode.scroll
                      ? BoxConstraints(maxHeight: dialogHeight.toDouble() - 25 * 2)
                      : null),
            ),
          ),
        ),
      ],
    );
  }
}
