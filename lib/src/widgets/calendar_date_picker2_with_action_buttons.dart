import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:calendar_date_picker2/src/models/month_date_range_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Display CalendarDatePicker with action buttons
class CalendarDatePicker2WithActionButtons extends StatefulWidget {
  CalendarDatePicker2WithActionButtons({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    this.onCancelTapped,
    this.onOkTapped,
    Key? key,
  }) : super(key: key) {
    if (config.calendarViewMode == CalendarDatePicker2Mode.scroll) {
      assert(
        config.scrollViewConstraints?.maxHeight != null,
        'scrollViewConstraint with maxHeight must be provided when used withCalendarDatePicker2WithActionButtons under scroll mode',
      );
    }
  }

  /// The selected [DateTime]s that the picker should display.
  final List<DateTime?> value;

  /// Called when the user taps 'OK' button
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker under non-scroll mode
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The calendar configurations including action buttons
  final CalendarDatePicker2WithActionButtonsConfig config;

  /// The callback when cancel button is tapped
  final Function? onCancelTapped;

  /// The callback when ok button is tapped
  final Function? onOkTapped;

  @override
  State<CalendarDatePicker2WithActionButtons> createState() => _CalendarDatePicker2WithActionButtonsState();
}

class _CalendarDatePicker2WithActionButtonsState extends State<CalendarDatePicker2WithActionButtons> {
  List<DateTime?> _values = [];
  List<DateTime?> _editCache = [];

  @override
  void initState() {
    _values = widget.value;
    _editCache = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CalendarDatePicker2WithActionButtons oldWidget) {
    var isValueSame = oldWidget.value.length == widget.value.length;

    if (isValueSame) {
      for (var i = 0; i < oldWidget.value.length; i++) {
        var isSame = (oldWidget.value[i] == null && widget.value[i] == null) ||
            DateUtils.isSameDay(oldWidget.value[i], widget.value[i]);
        if (!isSame) {
          isValueSame = false;
          break;
        }
      }
    }

    if (!isValueSame) {
      _values = widget.value;
      _editCache = widget.value;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MediaQuery.removePadding(
          context: context,
          child: CalendarDatePicker2(
            value: [..._editCache],
            config: widget.config,
            onValueChanged: (values) {
              setState(() {
                _editCache = values;
              });
            },
            onDisplayedMonthChanged: widget.onDisplayedMonthChanged,
          ),
        ),
        SizedBox(height: widget.config.gapBetweenCalendarAndButtons ?? 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            getText(),
            Expanded(child: Container()),
            _buildCancelButton(Theme.of(context).colorScheme, localizations),
            if ((widget.config.gapBetweenCalendarAndButtons ?? 0) > 0)
              SizedBox(width: widget.config.gapBetweenCalendarAndButtons),
            _buildOkButton(Theme.of(context).colorScheme, localizations),
          ],
        ),
      ],
    );
  }

  Widget getText() {
    if (_editCache.isEmpty) {
      return Container();
    }
    DateTime? start = _editCache[0];
    DateTime? end;
    if (_editCache.length > 1) {
      end = _editCache[1];
    }
    if (start == null) {
      return Container();
    }
    String hint = "";
    if (widget.config.isOnlyMonthRange) {
      hint = "${start.year}-${start.month < 10 ? "0${start.month}" : start.month.toString()}";
      if (end != null) {
        hint += " - ${end.year}-${end.month < 10 ? "0${end.month}" : end.month.toString()}";
      }
    } else {
      hint =
          "${start.year}-${start.month < 10 ? "0${start.month}" : start.month.toString()}-${start.day < 10 ? "0${start.day}" : start.day.toString()}";
      if (end != null) {
        hint +=
            " - ${end.year}-${end.month < 10 ? "0${end.month}" : end.month.toString()}-${end.day < 10 ? "0${end.day}" : end.day.toString()}";
      }
    }
    return Container(
      padding: widget.config.buttonPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(hint, style: widget.config.dayRangeTextStyle),
    );
  }

  Widget _buildCancelButton(ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        _editCache = _values;
        widget.onCancelTapped?.call();
        if ((widget.config.openedFromDialog ?? false) && (widget.config.closeDialogOnCancelTapped ?? true)) {
          Navigator.pop(context);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.cancelButton ??
            Text(
              localizations.cancelButtonLabel.toUpperCase(),
              style: widget.config.cancelButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }

  Widget _buildOkButton(ColorScheme colorScheme, MaterialLocalizations localizations) {
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: () => setState(() {
        if (widget.config.calendarType == CalendarDatePicker2Type.single) {
          if (_editCache.isEmpty) {
            if (widget.config.isOnlyMonthRange) {
              Fluttertoast.showToast(
                msg: "请选择月份",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              Fluttertoast.showToast(
                msg: "请选择日期",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            }
            return;
          }
        }
        if (widget.config.calendarType == CalendarDatePicker2Type.range) {
          if (_editCache.length < 2) {
            if (widget.config.isOnlyMonthRange) {
              Fluttertoast.showToast(
                msg: "请选择月份区间",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              Fluttertoast.showToast(
                msg: "请选择日期区间",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
              );
            }
            return;
          }
        }
        if (widget.config.needSameYear && widget.config.calendarType == CalendarDatePicker2Type.range) {
          if (_editCache[0]!.year != _editCache[1]!.year) {
            Fluttertoast.showToast(
              msg: "请选择同一年内的时间区间",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }
        }
        if (!widget.config.isOnlyMonthRange &&
            widget.config.needSameMonth &&
            widget.config.calendarType == CalendarDatePicker2Type.range) {
          if (_editCache[0]!.year != _editCache[1]!.year || _editCache[0]!.month != _editCache[1]!.month) {
            Fluttertoast.showToast(
              msg: "请选择同一月内的时间区间",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
            return;
          }
        }
        _values = _editCache;
        widget.onValueChanged?.call(_values);
        widget.onOkTapped?.call();
        if ((widget.config.openedFromDialog ?? false) && (widget.config.closeDialogOnOkTapped ?? true)) {
          MonthDateRangeResponse response = MonthDateRangeResponse();
          response.values = _values;
          response.isMonthChoose = widget.config.isOnlyMonthRange;
          Navigator.pop(context, response);
        }
      }),
      child: Container(
        padding: widget.config.buttonPadding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: widget.config.okButton ??
            Text(
              localizations.okButtonLabel.toUpperCase(),
              style: widget.config.okButtonTextStyle ??
                  TextStyle(
                    color: widget.config.selectedDayHighlightColor ?? colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
            ),
      ),
    );
  }
}
