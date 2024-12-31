part of '../calendar_date_picker2.dart';

/// Displays the days of a given month and allows choosing a day.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _MonthRangePicker extends StatefulWidget {
  /// Creates a day picker.
  const _MonthRangePicker({
    required this.config,
    required this.displayedYear,
    required this.selectedDates,
    required this.onChanged,
    required this.dayRowsCount,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime> selectedDates;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The month whose days are displayed by this picker.
  final DateTime displayedYear;

  /// The number of rows to display in the day picker.
  final int dayRowsCount;

  @override
  _MonthRangePickerState createState() => _MonthRangePickerState();
}

class _MonthRangePickerState extends State<_MonthRangePicker> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _monthFocusNodes;

  @override
  void initState() {
    super.initState();
    int monthInYear = 12;
    _monthFocusNodes = List<FocusNode>.generate(
      monthInYear,
          (int index) => FocusNode(skipTraversal: true, debugLabel: 'Month ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate
        .maybeOf(context)
        ?.date;
    if (focusedDate != null && widget.displayedYear.year == focusedDate.year) {
      _monthFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _monthFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final TextStyle dayStyle = textTheme.bodySmall!;
    final Color enabledDayColor = colorScheme.onSurface.withOpacity(0.87);
    final Color disabledDayColor = colorScheme.onSurface.withOpacity(0.38);
    final Color selectedDayColor = colorScheme.onPrimary;
    final Color selectedDayBackground = colorScheme.primary;
    final Color todayColor = colorScheme.primary;
    final Color daySplashColor = widget.config.daySplashColor ?? selectedDayBackground.withOpacity(0.38);

    final int year = widget.displayedYear.year;
    List<Widget> dayItems = [];
    for (int i = 1; i <= 12; i++) {
      final DateTime dayToBuild = DateTime(year, i, 1);
      final bool isDisabled = dayToBuild.isAfter(widget.config.lastDate) ||
          dayToBuild.isBefore(widget.config.firstDate) ||
          !(widget.config.selectableDayPredicate?.call(dayToBuild) ?? true);
      final bool isSelectedMonth = widget.selectedDates.any((d) => DateUtils.isSameMonth(d, dayToBuild));

      final bool isCurrentMonth = DateUtils.isSameMonth(widget.config.currentDate, dayToBuild);

      BoxDecoration? decoration;
      Color dayColor = enabledDayColor;
      if (isSelectedMonth) {
        // The selected day gets a circle background highlight, and a
        // contrasting text color.
        dayColor = selectedDayColor;
        decoration = BoxDecoration(
          borderRadius: widget.config.dayBorderRadius,
          color: widget.config.selectedDayHighlightColor ?? selectedDayBackground,
          shape: widget.config.dayBorderRadius != null ? BoxShape.rectangle : BoxShape.circle,
        );
      } else if (isDisabled) {
        dayColor = disabledDayColor;
      } else if (isCurrentMonth) {
        // The current day gets a different text color and a circle stroke
        // border.
        dayColor = widget.config.selectedDayHighlightColor ?? todayColor;
        decoration = BoxDecoration(
          borderRadius: widget.config.dayBorderRadius,
          border: Border.all(color: dayColor),
          shape: widget.config.dayBorderRadius != null ? BoxShape.rectangle : BoxShape.circle,
        );
      }

      var customDayTextStyle =
          widget.config.dayTextStylePredicate?.call(date: dayToBuild) ?? widget.config.dayTextStyle;

      if (isCurrentMonth && widget.config.todayTextStyle != null) {
        customDayTextStyle = widget.config.todayTextStyle;
      }

      if (isDisabled) {
        customDayTextStyle = customDayTextStyle?.copyWith(
          color: disabledDayColor,
          fontWeight: FontWeight.normal,
        );
        if (widget.config.disabledDayTextStyle != null) {
          customDayTextStyle = widget.config.disabledDayTextStyle;
        }
      }

      final isFullySelectedRangePicker =
          widget.config.calendarType == CalendarDatePicker2Type.range && widget.selectedDates.length == 2;
      var isDateInBetweenRangePickerSelectedDates = false;

      if (isFullySelectedRangePicker) {
        final startDate = DateUtils.dateOnly(widget.selectedDates[0]);
        final endDate = DateUtils.dateOnly(widget.selectedDates[1]);

        isDateInBetweenRangePickerSelectedDates = !(dayToBuild.isBefore(startDate) || dayToBuild.isAfter(endDate)) &&
            !DateUtils.isSameDay(startDate, endDate);
      }

      if (isDateInBetweenRangePickerSelectedDates && widget.config.selectedRangeDayTextStyle != null) {
        customDayTextStyle = widget.config.selectedRangeDayTextStyle;
      }

      if (isSelectedMonth) {
        customDayTextStyle = widget.config.selectedDayTextStyle;
      }

      final dayTextStyle = customDayTextStyle ?? dayStyle.apply(color: dayColor);

      Widget dayWidget = widget.config.monthRangeBuilder?.call(
        date: dayToBuild,
        textStyle: dayTextStyle,
        decoration: decoration,
        isSelected: isSelectedMonth,
        isDisabled: isDisabled,
        isToday: isCurrentMonth,
      ) ??
          _buildDefaultDayWidgetContent(
            decoration,
            localizations,
            i,
            dayTextStyle,
          );

      if (isDateInBetweenRangePickerSelectedDates) {
        final rangePickerIncludedDayDecoration = BoxDecoration(
          color: widget.config.selectedRangeHighlightColor ??
              (widget.config.selectedDayHighlightColor ?? selectedDayBackground).withOpacity(0.15),
        );

        if (DateUtils.isSameDay(
          DateUtils.dateOnly(widget.selectedDates[0]),
          dayToBuild,
        )) {
          dayWidget = Stack(
            children: [
              Row(children: [
                const Spacer(),
                Expanded(
                  child: Container(
                    decoration: rangePickerIncludedDayDecoration,
                  ),
                ),
              ]),
              dayWidget,
            ],
          );
        } else if (DateUtils.isSameDay(
          DateUtils.dateOnly(widget.selectedDates[1]),
          dayToBuild,
        )) {
          dayWidget = Stack(
            children: [
              Row(children: [
                Expanded(
                  child: Container(
                    decoration: rangePickerIncludedDayDecoration,
                  ),
                ),
                const Spacer(),
              ]),
              dayWidget,
            ],
          );
        } else {
          dayWidget = Stack(
            children: [
              Container(
                decoration: rangePickerIncludedDayDecoration,
              ),
              Container(alignment: Alignment.center,child: dayWidget,),
            ],
          );
        }
      }

      dayWidget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: dayWidget,
      );

      if (isDisabled) {
        dayWidget = ExcludeSemantics(
          child: dayWidget,
        );
      } else {
        var dayInkRadius = _dayPickerRowHeight / 2 + 4;
        if (widget.config.dayMaxWidth != null) {
          dayInkRadius = (widget.config.dayMaxWidth! + 2) / 2 + 4;
        }
        dayWidget = InkResponse(
          focusNode: _monthFocusNodes[i - 1],
          onTap: () => widget.onChanged(dayToBuild),
          radius: dayInkRadius,
          splashColor: daySplashColor,
          child: Semantics(
            // We want the day of month to be spoken first irrespective of the
            // locale-specific preferences or TextDirection. This is because
            // an accessibility user is more likely to be interested in the
            // day of month before the rest of the date, as they are looking
            // for the day of month. To do that we prepend day of month to the
            // formatted full date.
            label: '${localizations.formatDecimal(i)}, ${localizations.formatFullDate(dayToBuild)}',
            selected: isSelectedMonth,
            excludeSemantics: true,
            child: dayWidget,
          ),
        );
      }

      dayItems.add(dayWidget);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const _MonthRangePickerGridDelegate(),
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }

  Widget _buildDefaultDayWidgetContent(BoxDecoration? decoration,
      MaterialLocalizations localizations,
      int day,
      TextStyle dayTextStyle,) {
    return Row(
      children: [
        const Spacer(),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: decoration,
            child: Center(
              child: Text(
                localizations.formatDecimal(day),
                style: dayTextStyle,
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class _MonthRangePickerGridDelegate extends SliverGridDelegate {
  const _MonthRangePickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = constraints.crossAxisExtent /
        _monthPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _monthPickerRowHeight,
      crossAxisCount: _monthPickerColumnCount,
      crossAxisStride: tileWidth,
      mainAxisStride: _monthPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthRangePickerGridDelegate oldDelegate) => false;
}