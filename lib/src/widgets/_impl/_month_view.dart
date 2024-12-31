part of '../calendar_date_picker2.dart';

class _MonthView extends StatefulWidget {
  /// Creates a month picker.
  const _MonthView({
    required this.config,
    required this.initialYear,
    required this.selectedDates,
    required this.onChanged,
    required this.onDisplayedYearChanged,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The initial month to display.
  final DateTime initialYear;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// Called when the user navigates to a new month.
  final ValueChanged<DateTime> onDisplayedYearChanged;

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<_MonthView> {
  final GlobalKey _pageViewKey = GlobalKey();
  late DateTime _currentYear;
  late PageController _pageController;
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;
  Map<ShortcutActivator, Intent>? _shortcutMap;
  Map<Type, Action<Intent>>? _actionMap;
  late FocusNode _monthGridFocus;
  DateTime? _focusedMonth;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.initialYear;
    _pageController = widget.config.monthPageViewController ??
        PageController(
          initialPage: _currentYear.year - widget.config.firstDate.year,
        );
    _shortcutMap = const <ShortcutActivator, Intent>{
      SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(TraversalDirection.left),
      SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(TraversalDirection.right),
      SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
      SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent: CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(onInvoke: _handleDirectionFocus),
    };
    _monthGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
  }

  @override
  void didUpdateWidget(_MonthView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialYear != oldWidget.initialYear && widget.initialYear != _currentYear) {
      // We can't interrupt this widget build with a scroll, so do it next frame
      // Add workaround to fix Flutter 3.0.0 compiler issue
      // https://github.com/flutter/flutter/issues/103561#issuecomment-1125512962
      // https://github.com/flutter/website/blob/3e6d87f13ad2a8dd9cf16081868cc3b3794abb90/src/development/tools/sdk/release-notes/release-notes-3.0.0.md#your-code
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback(
        (Duration timeStamp) => _showYear(widget.initialYear, jump: widget.config.animateToDisplayedMonthDate != true),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _monthGridFocus.dispose();
    super.dispose();
  }

  void _handleDateSelected(DateTime selectedDate) {
    _focusedMonth = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleYearPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate = DateTime(monthPage + widget.config.firstDate.year, 1, 1);

      _currentYear = DateTime(monthDate.year, monthDate.month);
      widget.onDisplayedYearChanged(_currentYear);
      if (_focusedMonth != null && _currentYear.year != _focusedMonth!.year) {
        // We have navigated to a new month with the grid focused, but the
        // focused day is not in this month. Choose a new one trying to keep
        // the same day of the month.
        _focusedMonth = _focusableMonthForYear(_currentYear, _focusedMonth!.month);
      }
      SemanticsService.announce(
        _localizations.formatMonthYear(_currentYear),
        _textDirection,
      );
    });
  }

  /// Returns a focusable date for the given month.
  ///
  /// If the preferredDay is available in the month it will be returned,
  /// otherwise the first selectable day in the month will be returned. If
  /// no dates are selectable in the month, then it will return null.
  DateTime? _focusableMonthForYear(DateTime year, int preferredMonth) {
    final int monthInYear = year.month;

    // Can we use the preferred day in this month?
    if (preferredMonth <= monthInYear) {
      final DateTime newFocus = DateTime(year.year, preferredMonth);
      if (_isSelectable(newFocus)) return newFocus;
    }

    // Start at the 1st and take the first selectable date.
    for (int month = 1; month <= monthInYear; month++) {
      final DateTime newFocus = DateTime(year.year, month);
      if (_isSelectable(newFocus)) return newFocus;
    }
    return null;
  }

  /// Navigate to the next month.
  void _handleNextYear() {
    if (!_isDisplayingLastYear) {
      _pageController.nextPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the previous month.
  void _handlePreviousYear() {
    if (!_isDisplayingFirstYear) {
      _pageController.previousPage(
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// Navigate to the given month.
  void _showYear(DateTime year, {bool jump = false}) {
    final int yearPage = year.year - widget.config.firstDate.year;
    if (jump) {
      _pageController.jumpToPage(yearPage);
    } else {
      _pageController.animateToPage(
        yearPage,
        duration: _monthScrollDuration,
        curve: Curves.ease,
      );
    }
  }

  /// True if the earliest allowable month is displayed.
  bool get _isDisplayingFirstYear {
    return _currentYear.year == widget.config.firstDate.year;
  }

  /// True if the latest allowable month is displayed.
  bool get _isDisplayingLastYear {
    return _currentYear.year == widget.config.lastDate.year;
  }

  /// Handler for when the overall day grid obtains or loses focus.
  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused && _focusedMonth == null && widget.selectedDates.isNotEmpty) {
        if (DateUtils.isSameMonth(widget.selectedDates[0], _currentYear)) {
          _focusedMonth = widget.selectedDates[0];
        } else if (DateUtils.isSameMonth(widget.config.currentDate, _currentYear)) {
          _focusedMonth = _focusableMonthForYear(_currentYear, widget.config.currentDate.day);
        } else {
          _focusedMonth = _focusableMonthForYear(_currentYear, 1);
        }
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _monthGridFocus.requestFocus();
    _monthGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _monthGridFocus.requestFocus();
    _monthGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    setState(() {
      if (_focusedMonth != null) {
        final nextMonth = _nextDateInDirection(_focusedMonth!, intent.direction);
        if (nextMonth != null) {
          _focusedMonth = nextMonth;
          if (!DateUtils.isSameMonth(_focusedMonth, _currentYear)) {
            _showYear(_focusedMonth!);
          }
        }
      } else {
        _focusedMonth ??= widget.initialYear;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset = <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left) {
        traversalDirection = TraversalDirection.right;
      } else if (traversalDirection == TraversalDirection.right) {
        traversalDirection = TraversalDirection.left;
      }
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    DateTime nextDate = DateUtils.addDaysToDate(date, _dayDirectionOffset(direction, textDirection));
    while (!nextDate.isBefore(widget.config.firstDate) && !nextDate.isAfter(widget.config.lastDate)) {
      if (_isSelectable(nextDate)) {
        return nextDate;
      }
      nextDate = DateUtils.addDaysToDate(nextDate, _dayDirectionOffset(direction, textDirection));
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.config.selectableDayPredicate?.call(date) ?? true;
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime year = DateTime(widget.config.firstDate.year + index, 1, 1);
    return _MonthRangePicker(
      key: ValueKey<DateTime>(year),
      selectedDates: widget.selectedDates.whereType<DateTime>().toList(),
      onChanged: _handleDateSelected,
      config: widget.config,
      displayedYear: year,
      dayRowsCount: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color controlColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.60);

    return Semantics(
      child: Column(
        children: <Widget>[
          Container(
            padding: widget.config.centerAlignModePicker != true
                ? const EdgeInsetsDirectional.only(start: 16, end: 4)
                : const EdgeInsetsDirectional.only(start: 8, end: 8),
            height: (widget.config.controlsHeight ?? _subHeaderHeight),
            child: Row(
              children: <Widget>[
                if (widget.config.centerAlignModePicker != true) const Spacer(),
                IconButton(
                  splashRadius: widget.config.dayMaxWidth != null ? widget.config.dayMaxWidth! * 2 / 3 : null,
                  icon: widget.config.lastMonthIcon ?? const Icon(Icons.chevron_left),
                  color: controlColor,
                  onPressed: _isDisplayingFirstYear ? null : _handlePreviousYear,
                ),
                if (widget.config.centerAlignModePicker == true) const Spacer(),
                IconButton(
                  splashRadius: widget.config.dayMaxWidth != null ? widget.config.dayMaxWidth! * 2 / 3 : null,
                  icon: widget.config.nextMonthIcon ?? const Icon(Icons.chevron_right),
                  color: controlColor,
                  onPressed: _isDisplayingLastYear ? null : _handleNextYear,
                ),
              ],
            ),
          ),
          Expanded(
            child: FocusableActionDetector(
              shortcuts: _shortcutMap,
              actions: _actionMap,
              focusNode: _monthGridFocus,
              onFocusChange: _handleGridFocusChange,
              child: _FocusedDate(
                date: _monthGridFocus.hasFocus ? _focusedMonth : null,
                child: PageView.builder(
                  key: _pageViewKey,
                  physics: widget.config.calendarViewScrollPhysics,
                  controller: _pageController,
                  itemBuilder: _buildItems,
                  itemCount: widget.config.lastDate.year - widget.config.firstDate.year + 1,
                  onPageChanged: _handleYearPageChanged,
                ),
              ),
            ),
          ),
          Container(
            height: 12,
          ),
          Text(
            "可左右滑动切换年份",
            style: widget.config.dayTextStyle
                ?.copyWith(color: const Color(0xff999999), fontSize: TextStyleUtils.getFixedFontSize(context, 14)),
          ),
        ],
      ),
    );
  }
}
