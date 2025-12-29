# Widget Implementation Guide

## 📋 สรุปไฟล์ที่สร้าง

### ✅ Widget Demo Pages (5 widgets, 10 files)

| Widget Type | Files Created | Status |
|-------------|---------------|--------|
| **Switch** | `switch_demo_page.dart`<br>`switch_demo_cubit.dart` | ✅ Ready |
| **Slider** | `slider_demo_page.dart`<br>`slider_demo_cubit.dart` | ✅ Ready |
| **SegmentedButton** | `segmented_button_demo_page.dart`<br>`segmented_button_demo_cubit.dart` | ✅ Ready |
| **Chip** | `chip_demo_page.dart`<br>`chip_demo_cubit.dart` | ✅ Ready |
| **DatePicker** | `date_picker_demo_page.dart`<br>`date_picker_demo_cubit.dart` | ✅ Ready |

---

## 🎯 Widget Keys สำหรับ Testing

### 1. Switch Demo
```dart
switch_01_notifications_switch
switch_02_darkmode_switch
switch_03_autosave_switch
switch_04_status_text
```

**PICT Factors:**
- `switch_01_notifications_switch`: on, off
- `switch_02_darkmode_switch`: on, off
- `switch_03_autosave_switch`: on, off

### 2. Slider Demo
```dart
slider_01_volume_slider          // 0-100, divisions: 20
slider_02_volume_text
slider_03_brightness_slider      // 0-100, divisions: 10
slider_04_brightness_text
slider_05_temperature_slider     // 10-30°C, divisions: 20
slider_06_temperature_text
```

**PICT Factors:**
- `slider_01_volume_slider`: 0, 50, 100
- `slider_03_brightness_slider`: 0, 50, 100
- `slider_05_temperature_slider`: 10, 20, 30

### 3. SegmentedButton Demo
```dart
segmented_01_size_button         // Single select: S/M/L/XL
segmented_02_delivery_button     // Single select: express/standard/economy
segmented_03_toppings_button     // Multi select: cheese/pepperoni/mushroom/olive
segmented_04_status_text
```

**PICT Factors:**
- `segmented_01_size_button`: S, M, L, XL
- `segmented_02_delivery_button`: express, standard, economy
- `segmented_03_toppings_button`: (combinations of toppings)

### 4. Chip Demo
```dart
chip_01_priority_low             // ChoiceChip
chip_02_priority_medium
chip_03_priority_high
chip_04_filter_work              // FilterChip
chip_05_filter_personal
chip_06_filter_urgent
chip_07_interest_tech            // InputChip
chip_08_interest_sports
chip_09_interest_music
chip_10_interest_travel
chip_11_status_text
```

**PICT Factors:**
- `chip_priority`: low, medium, high (ChoiceChip - single select)
- `chip_filter`: work, personal, urgent (FilterChip - multi select)
- `chip_interest`: tech, sports, music, travel (InputChip - multi select)

### 5. DatePicker Demo
```dart
datepicker_01_birthdate_tile
datepicker_02_appointment_date_tile
datepicker_03_appointment_time_tile
datepicker_04_status_text
```

**PICT Factors:**
- `datepicker_01_birthdate`: past_date, today, null
- `datepicker_02_appointment_date`: today, future_date, null
- `datepicker_03_appointment_time`: morning, afternoon, evening, null

---

## 🚀 วิธีการรัน Widget Demos

### วิธีที่ 1: เพิ่มใน main.dart

แก้ไข `lib/main.dart`:

```dart
import 'package:master_project/widgets/switch_demo_page.dart';
import 'package:master_project/widgets/slider_demo_page.dart';
import 'package:master_project/widgets/segmented_button_demo_page.dart';
import 'package:master_project/widgets/chip_demo_page.dart';
import 'package:master_project/widgets/date_picker_demo_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Demos',
      routes: {
        '/': (context) => HomePage(),
        SwitchDemoPage.route: (context) => const SwitchDemoPage(),
        SliderDemoPage.route: (context) => const SliderDemoPage(),
        SegmentedButtonDemoPage.route: (context) => const SegmentedButtonDemoPage(),
        ChipDemoPage.route: (context) => const ChipDemoPage(),
        DatePickerDemoPage.route: (context) => const DatePickerDemoPage(),
      },
    );
  }
}
```

### วิธีที่ 2: รันโดยตรงด้วย initialRoute

```bash
# Switch Demo
flutter run --dart-define=INITIAL_ROUTE=/switch-demo

# Slider Demo
flutter run --dart-define=INITIAL_ROUTE=/slider-demo

# SegmentedButton Demo
flutter run --dart-define=INITIAL_ROUTE=/segmented-button-demo

# Chip Demo
flutter run --dart-define=INITIAL_ROUTE=/chip-demo

# DatePicker Demo
flutter run --dart-define=INITIAL_ROUTE=/date-picker-demo
```

### วิธีที่ 3: สร้าง Home Page ที่มีลิงก์ทั้งหมด

```dart
// lib/widgets/widget_demo_home.dart
import 'package:flutter/material.dart';

class WidgetDemoHome extends StatelessWidget {
  const WidgetDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Demos')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Switch Demo'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/switch-demo'),
          ),
          ListTile(
            title: const Text('Slider Demo'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/slider-demo'),
          ),
          ListTile(
            title: const Text('SegmentedButton Demo'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/segmented-button-demo'),
          ),
          ListTile(
            title: const Text('Chip Demo'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/chip-demo'),
          ),
          ListTile(
            title: const Text('DatePicker Demo'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, '/date-picker-demo'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔧 การเพิ่ม Widget Support ใน Test Generator

### Step 1: เพิ่มใน `extract_ui_manifest.dart`

```dart
// Line ~234
final targets = <String>{
  'TextField', 'TextFormField', 'FormField', 'Radio',
  'ElevatedButton', 'TextButton', 'OutlinedButton', 'IconButton', 'Text',
  'DropdownButton', 'DropdownButtonFormField', 'Checkbox',
  'Switch', 'SwitchListTile',           // ← เพิ่ม Switch
  'Slider',                              // ← เพิ่ม Slider
  'SegmentedButton',                     // ← เพิ่ม SegmentedButton
  'ChoiceChip', 'FilterChip', 'InputChip',  // ← เพิ่ม Chips
  'Visibility', 'SnackBar',
};
```

### Step 2: เพิ่มใน `generator_pict.dart`

```dart
// Line ~320: หลัง Checkbox section
// Switch Support (เหมือน Checkbox)
if ((widgetType == 'Switch' || widgetType == 'SwitchListTile') && key.isNotEmpty) {
  factors[key] = ['on', 'off'];
}

// Slider Support
if (widgetType == 'Slider' && key.isNotEmpty) {
  final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
  final min = (meta['min'] ?? 0).toDouble();
  final max = (meta['max'] ?? 100).toDouble();

  // สร้าง 3 values: min, mid, max
  factors[key] = [
    min.toString(),
    ((min + max) / 2).toString(),
    max.toString(),
  ];
}

// SegmentedButton Support
if (widgetType == 'SegmentedButton' && key.isNotEmpty) {
  final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
  final segments = (meta['segments'] as List?)?.cast<String>() ?? [];

  if (segments.isNotEmpty) {
    factors[key] = segments;
  }
}

// ChoiceChip Support (single select)
if (widgetType == 'ChoiceChip' && key.isNotEmpty) {
  // Group chips by base name (e.g., chip_01_priority_*)
  final baseName = _extractChipGroupName(key);
  if (!factors.containsKey(baseName)) {
    factors[baseName] = [];
  }
  // Extract chip value from key
  final value = _extractChipValue(key);
  if (!factors[baseName]!.contains(value)) {
    factors[baseName]!.add(value);
  }
}
```

### Step 3: เพิ่ม Test Step Generation

```dart
// ใน generate_test_data.dart
// สำหรับ Switch
if (widgetType == 'Switch' || widgetType == 'SwitchListTile') {
  steps.add({
    'action': 'tap',
    'target': key,
    'comment': 'Toggle switch ${value == "on" ? "ON" : "OFF"}',
  });
}

// สำหรับ Slider
if (widgetType == 'Slider') {
  steps.add({
    'action': 'drag',
    'target': key,
    'value': value,
    'comment': 'Set slider to $value',
  });
}
```

---

## 📊 ตารางเปรียบเทียบ Widget Types

| Widget | Input Type | Values | Multi-Select | Test Action |
|--------|-----------|--------|--------------|-------------|
| Switch | Boolean | on/off | ❌ | tap |
| Checkbox | Boolean | checked/unchecked | ❌ | tap |
| Radio | Enum | option1/option2/... | ❌ | tap |
| Dropdown | Enum | option1/option2/... | ❌ | tap → tap |
| Slider | Numeric | min/mid/max | ❌ | drag |
| SegmentedButton | Enum | option1/option2/... | ✅ | tap |
| ChoiceChip | Enum | option1/option2/... | ❌ | tap |
| FilterChip | Enum | option1/option2/... | ✅ | tap |
| DatePicker | Date | past/today/future | ❌ | tap → select |
| TimePicker | Time | morning/afternoon/evening | ❌ | tap → select |

---

## 🎓 Best Practices

### 1. Key Naming Convention
```dart
<widget>_<sequence>_<description>_<type>
```

**ตัวอย่าง:**
- ✅ `switch_01_notifications_switch`
- ✅ `slider_03_brightness_slider`
- ✅ `chip_04_filter_work`
- ❌ `notificationSwitch` (ไม่มี sequence)
- ❌ `switch1` (ไม่มี description)

### 2. Cubit State Management
- ใช้ `copyWith()` สำหรับ immutable state
- แยก Cubit ตาม feature (อย่าผสมหลาย widgets ใน Cubit เดียว)
- ใช้ `BlocBuilder` สำหรับ UI updates
- ใช้ `BlocListener` สำหรับ side effects

### 3. Widget Organization
```
lib/
├── widgets/              # Widget demo pages
│   ├── switch_demo_page.dart
│   ├── slider_demo_page.dart
│   └── ...
├── cubit/
│   └── widgets/          # Widget-specific cubits
│       ├── switch_demo_cubit.dart
│       ├── slider_demo_cubit.dart
│       └── ...
└── demos/               # Existing demo pages
    ├── employee_survey_page.dart
    └── ...
```

---

## 🧪 Testing Strategy

### Manual Testing
1. รัน widget demo page
2. ทดสอบทุก state combinations manually
3. ตรวจสอบว่า Cubit state updates ถูกต้อง

### Automated Testing (ในอนาคต)
```bash
# Extract manifest
dart run tools/script_v2/extract_ui_manifest.dart lib/widgets/switch_demo_page.dart

# Generate test data
dart run tools/script_v2/generate_test_data.dart output/manifest/switch_demo_page.manifest.json

# Generate test script
dart run tools/script_v2/generate_test_script.dart output/test_data/switch_demo_page.testdata.json

# Run tests
flutter test test/generated/switch_demo_page_flow_test.dart
```

---

## 📝 Next Steps

1. ✅ สร้าง widget demo pages (เสร็จแล้ว)
2. ⏳ เพิ่ม widget extraction support
3. ⏳ เพิ่ม PICT generation support
4. ⏳ เพิ่ม test step generation
5. ⏳ ทดสอบ end-to-end workflow

---

## 💡 ตัวอย่างการใช้งาน

### ตัวอย่าง: Testing Switch Widget

```bash
# 1. Extract manifest
dart run tools/script_v2/extract_ui_manifest.dart lib/widgets/switch_demo_page.dart

# 2. Generate tests (Interactive mode)
dart run tools/flutter_test_generator.dart
# ? UI file: lib/widgets/switch_demo_page.dart
# ? Skip datasets: y
# ? Use constraints: n
# ? Verbose: n

# 3. Run generated tests
flutter test test/generated/switch_demo_page_flow_test.dart
```

### ตัวอย่าง PICT Constraints สำหรับ Switch

```pict
# output/model_pairwise/switch_demo_page.constraints.txt

# ถ้า dark mode ON ต้อง enable notifications ด้วย
IF [switch_02_darkmode_switch] = "on"
   THEN [switch_01_notifications_switch] = "on";

# Auto save ต้อง ON เสมอ (default)
[switch_03_autosave_switch] = "on";
```

---

พร้อมใช้งานแล้วครับ! 🚀
