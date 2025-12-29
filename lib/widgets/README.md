# Widget Demo Pages

This directory contains demo pages for various Flutter widgets that are not yet fully supported by the automated test generation system.

## Available Demos

### 1. **Switch Demo** (`switch_demo_page.dart`)
- **Widgets:** `Switch`, `SwitchListTile`
- **Use Case:** Toggle settings (on/off states)
- **Keys:**
  - `switch_01_notifications_switch`
  - `switch_02_darkmode_switch`
  - `switch_03_autosave_switch`
  - `switch_04_status_text`

### 2. **Slider Demo** (`slider_demo_page.dart`)
- **Widgets:** `Slider`
- **Use Case:** Adjustable values (volume, brightness, temperature)
- **Keys:**
  - `slider_01_volume_slider` (0-100)
  - `slider_03_brightness_slider` (0-100)
  - `slider_05_temperature_slider` (10-30°C)

### 3. **SegmentedButton Demo** (`segmented_button_demo_page.dart`)
- **Widgets:** `SegmentedButton` (Material 3)
- **Use Case:** Single/multiple selection from options
- **Keys:**
  - `segmented_01_size_button` (S/M/L/XL)
  - `segmented_02_delivery_button` (express/standard/economy)
  - `segmented_03_toppings_button` (multi-select)

### 4. **Chip Demo** (`chip_demo_page.dart`)
- **Widgets:** `ChoiceChip`, `FilterChip`, `InputChip`
- **Use Case:** Tag selection, filtering, interests
- **Keys:**
  - `chip_01_priority_low` to `chip_03_priority_high` (ChoiceChip)
  - `chip_04_filter_work` to `chip_06_filter_urgent` (FilterChip)
  - `chip_07_interest_tech` to `chip_10_interest_travel` (InputChip)

### 5. **DatePicker Demo** (`date_picker_demo_page.dart`)
- **Widgets:** `DatePicker`, `TimePicker`
- **Use Case:** Date and time selection
- **Keys:**
  - `datepicker_01_birthdate_tile`
  - `datepicker_02_appointment_date_tile`
  - `datepicker_03_appointment_time_tile`

## How to Run

### Run Individual Demo:

```bash
flutter run --dart-define=INITIAL_ROUTE=/switch-demo
flutter run --dart-define=INITIAL_ROUTE=/slider-demo
flutter run --dart-define=INITIAL_ROUTE=/segmented-button-demo
flutter run --dart-define=INITIAL_ROUTE=/chip-demo
flutter run --dart-define=INITIAL_ROUTE=/date-picker-demo
```

### Add to main.dart Routes:

```dart
import 'package:master_project/widgets/switch_demo_page.dart';
import 'package:master_project/widgets/slider_demo_page.dart';
import 'package:master_project/widgets/segmented_button_demo_page.dart';
import 'package:master_project/widgets/chip_demo_page.dart';
import 'package:master_project/widgets/date_picker_demo_page.dart';

MaterialApp(
  routes: {
    SwitchDemoPage.route: (context) => const SwitchDemoPage(),
    SliderDemoPage.route: (context) => const SliderDemoPage(),
    SegmentedButtonDemoPage.route: (context) => const SegmentedButtonDemoPage(),
    ChipDemoPage.route: (context) => const ChipDemoPage(),
    DatePickerDemoPage.route: (context) => const DatePickerDemoPage(),
  },
);
```

## Testing with flutter_test_generator

Once these widgets are added to the extraction and PICT generation pipeline:

```bash
# Extract manifest
dart run tools/script_v2/extract_ui_manifest.dart lib/widgets/switch_demo_page.dart

# Generate tests
dart run tools/flutter_test_generator.dart lib/widgets/switch_demo_page.dart
```

## Widget Support Status

| Widget | Extract | PICT | Test Gen | Priority |
|--------|---------|------|----------|----------|
| Switch | ❌ | ❌ | ❌ | High |
| Slider | ❌ | ❌ | ❌ | High |
| SegmentedButton | ❌ | ❌ | ❌ | Medium |
| ChoiceChip | ❌ | ❌ | ❌ | Medium |
| FilterChip | ❌ | ❌ | ❌ | Medium |
| DatePicker | ❌ | ❌ | ❌ | High |
| TimePicker | ❌ | ❌ | ❌ | High |

## Next Steps

1. **Add to extract_ui_manifest.dart:**
   - Add widget types to `targets` list
   - Extract widget metadata (min/max for Slider, options for chips)

2. **Add to generator_pict.dart:**
   - Add PICT factor generation for each widget type
   - Define value ranges (e.g., Slider: min/mid/max)

3. **Add to generate_test_data.dart:**
   - Generate test steps (tap, drag for slider)
   - Generate assertions

4. **Add to generate_test_script.dart:**
   - Generate Flutter test code for new widget types

## Contributing

To add a new widget demo:

1. Create cubit file: `lib/cubit/widgets/<widget>_demo_cubit.dart`
2. Create page file: `lib/widgets/<widget>_demo_page.dart`
3. Follow naming convention: `<widget>_<sequence>_<description>_<type>`
4. Update this README

## Notes

- All demos use BLoC pattern for state management
- Keys follow the pattern: `<widget>_<sequence>_<description>_<type>`
- Cubits are isolated in `lib/cubit/widgets/` directory
- Ready for automated test generation once support is added
