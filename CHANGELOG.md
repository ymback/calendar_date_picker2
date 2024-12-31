## [1.1.5]
- refactor: add `isMonthPicker` into `CalendarModePickerTextHandler`
- feat: add `weekdayLabelBuilder` into config
- feat: add `modePickerBuilder` into config

## [1.1.4]
- fix: update README.md

## [1.1.3]
- feat: change `onValueChanged` type to `ValueChanged<List<DateTime>>?`

## [1.1.2]
- fix: pub dev analyzer warning

## [1.1.1]
- feat: add `dynamicCalendarRows` into config

## [1.1.0]
- feat: add `animateToDisplayedMonthDate` into config
- feat: add `dayViewController` into config
- feat: add `monthViewController` into config
- feat: add `yearViewController` into config

## [1.0.9]
- fix: rename `scrollCalendarTopHeaderTextStyle` to `scrollViewTopHeaderTextStyle`
- fix: rename `hideScrollCalendarTopHeader` to `hideScrollViewTopHeader`
- fix: rename  `hideScrollCalendarTopHeaderDivider` to `hideScrollViewTopHeaderDivider`
- fix: rename `hideScrollCalendarMonthWeekHeader` to `hideScrollViewMonthWeekHeader`
- fix: rename `scrollCalendarConstraints` to `scrollViewConstraints`

## [1.0.8]
- feat: add `scrollCalendarTopHeaderTextStyle` into config

## [1.0.7]
- feat: add `scrollViewController` into config

## [1.0.6]
- fix: pub dev analyzer warning

## [1.0.5]
- fix: rename `hideScrollCalendarStickyWeekLabelsHeader` to `hideScrollCalendarTopHeader`
- fix: rename `hideScrollCalendarStickyWeekLabelsHeaderDivider` to `hideScrollCalendarTopHeaderDivider`
- fix: rename `hideScrollCalendarWeekLabelsHeader` to `hideScrollCalendarMonthWeekHeader`

## [1.0.4]
- feat: add `scroll` mode into `CalendarDatePicker2Mode`
- feat: add `hideScrollCalendarStickyWeekLabelsHeader` into config
- feat: add `hideScrollCalendarStickyWeekLabelsHeaderDivider` into config
- feat: add `hideScrollCalendarWeekLabelsHeader` into config
- feat: add `scrollCalendarConstraints` into config
- feat: add `scrollViewMonthYearBuilder` into config
- feat: add `scrollViewOnScrolling` into config

## [1.0.3]
- feat: add `dayMaxWidth` into config
- feat: add `hideMonthPickerDividers` into config
- feat: add `hideYearPickerDividers` into config

## [1.0.2]

- fix: current month & selected validation logics

## [1.0.1]

- doc: update README.md

## [1.0.0]

- **BREAKING**: feat: add month picker
- feat: add `monthBuilder` into config
- feat: add `disableMonthPicker` into config
- feat: add `useAbbrLabelForMonthModePicker` into config
- feat: add `selectableMonthPredicate` into config
- feat: add `selectableYearPredicate` into config

## [0.5.6]

- refactor: change `rangeBidirectional` to `bool?`
- feat: add `daySplashColor` into calendar config
- feat: add `allowSameValueSelection` into calendar config

## [0.5.5]

- doc: update README.md

## [0.5.4]

- feat: add `calendarViewScrollPhysics` into calendar config

## [0.5.3]

- feat: add `rangeBidirectional` into calendar config

## [0.5.2]

- feat: add `displayedMonthDate` into calendar widget
- feat: add `selectedRangeDayTextStyle` into calendar config

## [0.5.1]

- fix: dates value type issue

## [0.5.0]

- feat: add `selectedRangeHighlightColor` into config

## [0.4.9]

- update: README.md

## [0.4.8]

- fix: static analyzer formatting issue

## [0.4.7]

- update: rename `initialValue` to `value`
- update: rename `centerAlignModePickerButton` to `centerAlignModePicker`
- update: rename `customModePickerButtonIcon` to `customModePickerIcon`
- update: rename `modePickerButtonTextHandler` to `modePickerTextHandler`
- update: README.md

## [0.4.6]

- feat: add `modePickerButtonTextHandler` into config
- update: rename `disableYearPicker` to `disableModePicker`

## [0.4.5]

- feat: add `yearBuilder` into config

## [0.4.4]

- fix: wrong month display on selected year tapped

## [0.4.3]

- fix: minimum working sample unmodifiable list exception
- update: README.md

## [0.4.2]

- fix: post-process `firstDate` &  `lastDate` to date-only

## [0.4.1]

- fix: dialog border radius issue when theme uses `useMaterial3:true`
- feat: add action button localizations

## [0.4.0]

- fix: incorrect header padding in `centerAlignModePickerButton` mode

## [0.3.9]

- feat: add `centerAlignModePickerButton` into config
- feat: add `customModePickerButtonIcon` into config
- update: add package screenshot

## [0.3.8]

- feat: add custom wrapping padding `buttonPadding` into config

## [0.3.7]

- fix: remove deprecated styles

## [0.3.6]

- fix: fix textStyle for okButton

## [0.3.5]

- fix: fix copyWith method

## [0.3.4]

- feat: add `disableYearPicker` into config
- refine: refine assertion
- update: update example

## [0.3.3]

- update: readme.md

## [0.3.2]

- feat: add `dayTextStylePredicate` into config
- feat: add `dayBuilder` into config
- refactor: move `selectableDayPredicate` into config
- refine: code clean-up

## [0.3.1]

- fix: fix dart formatting issue

## [0.2.9]

- feat: add new config `selectedYearTextStyle`

## [0.2.8]

- fix: Missing `firstDayOfWeek` in `CalendarDatePicker2WithActionButtonsConfig`

## [0.2.7]

- fix: Dialog OK button not returning selected dates

## [0.2.6]

- feat: add `firstDayOfWeek` into config
- feat: add `closeDialogOnOkTapped` into config
- update: rename `shouldCloseDialogAfterCancelTapped` to `closeDialogOnCancelTapped`
- update: set default value as `true` for both `closeDialogOnOkTapped` & `closeDialogOnCancelTapped`

## [0.2.5]

- feat: add `yearTextStyle` into config
- fix: fix `onCancelTapped` get called on Ok button tapped

## [0.2.4]

- feat: add `dayBorderRadius` into config
- feat: add `yearBorderRadius` into config
- refactor: change param `borderRadius`'type of function `showCalendarDatePicker2Dialog` to `BorderRadius`
- refactor: code clean-up

## [0.2.3]

- feat: add `todayTextStyle` into config
- docs: fix documentation grammar issue
- refactor: clean up codebase and rebase flutter's source code

## [0.2.2]

- Add new config option `disabledDayTextStyle` for disabled calendar days
- Add `selectableDayPredicate` into built-in dialog function

## [0.2.1]

- Fix keyboard assertion when no focused day is set
- Fix time part not respected in range picker mode

## [0.2.0]

- Fix Calendar body's GridView default extra padding

## [0.1.9]

- Update readme

## [0.1.8]

- Fix month label not change issue

## [0.1.7]

- Add `shouldCloseDialogAfterCancelTapped` into `CalendarDatePicker2WithActionButtonsConfig`
- Add `dialogBackgroundColor` into `showCalendarDatePicker2Dialog`

## [0.1.6]

- Initial implementation