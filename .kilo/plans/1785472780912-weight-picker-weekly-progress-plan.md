# Weight Picker & Weekly Progress Plan

## Goal
Implement a decimal weight selector (iOS-style picker wheel with 0.1 kg steps and +/- buttons) for both the onboarding assessment weight question and the dashboard weight entry. Make the Weekly Change card tappable, navigating to a dedicated Weekly Progress screen with summary data and an interactive trend graph.

## 1. New Shared Widget: `WeightWheelPicker`
**File:** `lib/features/dashboard/view/widgets/weight_wheel_picker.dart`

A decimal-capable `ListWheelScrollView` wheel picker that replaces integer-only `MeasurementWheelPicker` for weight selection.

- **State:** Tracks `double selectedValue`.
- **Items:** Computed from `(maxValue - minValue) / step + 1`. For kg 30.0–200.0 with step 0.1 this is 1,710 items. For lb 66–440 with step 0.2 this is 1,872 items. `FixedExtentScrollPhysics` renders only visible items so performance remains acceptable.
- **Visual:**
  - Selected row: full opacity, `brandTeal`, font size 32 weight 700.
  - Non-selected rows: opacity 0.45, `textSecondary`, font size 22 weight 500.
  - Teal selector lines above/below center (matching existing picker).
- **Exposed API:**
  - `onChanged(double value)` — emitted on scroll.
  - `animateToValue(double value)` — public method for external animated updates (used by +/- buttons).
- **Unit display:** Shows unit suffix (`kg` / `lb`) aligned to the number right, same baseline as existing picker.

## 2. Plus/Minus Buttons
**Where:** Inside `weight_view.dart` (assessment) and `weight_entry_bottom_sheet.dart` (dashboard).

- Layout row: `[- IconButton] [Expanded(WeightWheelPicker)] [+ IconButton]`
- `-` calls `picker.animateToValue(selectedValue - step)` via a `GlobalKey<WeightWheelPickerState>`.
- `+` calls `picker.animateToValue(selectedValue + step)`.
- Animation: `_controller.animateToItem(index, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut)`.

## 3. Update Assessment Weight Question
**File:** `lib/features/assessment/view/pages/weight_view.dart`

- Replace `MeasurementWheelPicker` with `WeightWheelPicker`.
- Change local state from `int _weightKg` / `int _weightLb` to `double`.
- Add Configurable min/max constants in `AssessmentStrings` for decimal limits:
  - `minWeightKg = 30.0`, `maxWeightKg = 200.0`, `defaultWeightKg = 50.0`
  - `minWeightLb = 66.0`, `maxWeightLb = 440.0`, `defaultWeightLb = 110.0`
  - Step stays `0.1` for both units.
- Keep existing unit toggle behavior.

**Note:** Weight is currently only stored in local widget state. The new picker does not change persistence behavior. The selected weight is not persisted to `WeightController` or storage in the assessment flow.

## 4. Update Dashboard Weight Entry Bottom Sheet
**File:** `lib/features/dashboard/view/widgets/weight_entry_bottom_sheet.dart`

- Replace `MeasurementWheelPicker` with `WeightWheelPicker`.
- Change local state from `int _weightKg` / `int _weightLb` to `double`.
- Add +/- buttons.
- When saving, pass the double to `WeightController.addRecord()` or `updateRecord()`.

## 5. True Weekly Change Logic in `WeightController`
**File:** `lib/features/dashboard/controllers/weight_controller.dart`

### New fields
- `final RxDouble weeklyTargetKg = 0.5.obs` — default healthy weight-loss target. Derived later from objective; hardcoded default for v1.
- `final RxBool hasSufficientWeeklyData = false.obs`

### New getters
- `WeightRecord? get previousWeekWeight` — record closest to (now - 7 days), excluding the current record.
- `double get weeklyChange` — `currentWeight.weightKg - previousWeekWeight.weightKg` if data exists, else `0.0`.
- `String get weeklyChangeString` — formatted `±X.X kg` string.
- `DateTime? get comparisonStartDate` — date of `previousWeekWeight`.
- `DateTime? get comparisonEndDate` — date of `currentWeight`.
- `String get comparisonPeriodString` — `"d MMM – d MMM"` format using `intl.DateFormat('d MMM')`.
- `String get weeklyStatus` — derived:
  - `Insufficient data` if `records.length < 2` or `previousWeekWeight` is null.
  - `Maintaining` if `weeklyChange.abs() < 0.15`.
  - `Faster than target` if same direction as target and `abs(weeklyChange) > abs(weeklyTargetKg) * 1.2`.
  - `On target` if same direction as target and `abs(weeklyChange) >= 0.15`.
  - `Slower than target` otherwise (includes opposite direction and below-target same direction).

### Modified getters
- Keep `weightChangeSinceLast` for Current Weight card trend (last-to-previous-record change).

## 6. Make Weekly Change Card Tappable
**File:** `lib/features/dashboard/view/pages/dashboard_view.dart`

- Wrap the Weekly Change `MetricCard` in a `GestureDetector` (or `InkWell`) that pushes `WeeklyProgressView`.
- Current Weight card remains tappable as-is.

## 7. New Weekly Progress Screen
**File:** `lib/features/dashboard/view/pages/weekly_progress_view.dart`

Reuses and extends the existing `weight_trends_view.dart` chart infrastructure.

### Layout
```
Scaffold
  AppBar: transparent, AiFORMA title, back arrow, info icon
  SafeArea -> SingleChildScrollView
    Weekly Summary Section (top, prominent)
      Row: Previous weight | Current weight
      Large `±X.X kg` change value
      Comparison period: `12 May – 19 May`
      Status badge (pill with teal/warning/gray based on status)
    Time range selector (1W, 1M, 3M, 6M, 1Y)
    SizedBox(height: 250)
      `fl_chart` LineChart with touch interaction
    Weight History list (same as trends view)
    Bottom: UPDATE WEIGHT button (opens `WeightEntryBottomSheet`)
```

### Chart touch tooltip enhancement
Modify `LineTouchTooltipData.getTooltipItems` in `WeeklyProgressView` to display:
1. Weight (e.g. `87.4 kg`)
2. Date (e.g. `May 19, 2025`)
3. Change from previous entry (e.g. `+0.2 kg` or `—`)
Handle edge cases: first data point has no previous entry; show `—` for change.

## 8. Routes & Navigation
**File:** `lib/features/dashboard/view/pages/weekly_progress_view.dart` (new route class)

- Instantiate and push via `MaterialPageRoute` from `dashboard_view.dart`.
- No changes needed to shell navigation for now; direct push is consistent with how `WeightTrendsView` is opened.

## 9. Data Model Considerations
**File:** `lib/core/models/weight_record.dart`

No changes required. `WeightRecord` already stores `double weightKg` and `DateTime date`.

## Open Decisions / Assumptions
1. **Weekly Target Source:** `weeklyTargetKg` defaults to `0.5` kg/week. It is not yet linked to assessment objective. This is acceptable for v1; the status labels display correctly once a target is configured.
2. **Assessment Persistence:** Onboarding/assessment weight remains local widget state. It does not yet sync to `WeightController` or persistent storage. The new picker UI does not change this; a future task should pipe assessment answers into the controller.
3. **Comparison Period Definition:** `previousWeekWeight` is the record whose date is closest to (now - 7 days). If the most recent record is today, the period is [7 days ago, today].
