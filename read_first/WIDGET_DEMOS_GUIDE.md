# Widget Demos Guide

## 🚀 วิธีการรัน Widget Demos

### วิธีที่ 1: รันผ่าน Home Page (แนะนำ)

```bash
flutter run
```

จะเห็นหน้า Home ที่มีรายการ Demos ทั้งหมด:

```
┌─────────────────────────────────────┐
│        Form Demos                   │
├─────────────────────────────────────┤
│ 1. Customer Details Form            │
│ 2. Product Registration Form        │
│ 3. Employee Survey Form             │
├─────────────────────────────────────┤
│        Widget Demos                 │
├─────────────────────────────────────┤
│ • Switch Demo                       │
│ • Slider Demo                       │
│ • SegmentedButton Demo              │
│ • Chip Demo                         │
│ • DatePicker Demo                   │
└─────────────────────────────────────┘
```

### วิธีที่ 2: รัน Widget แต่ละตัวโดยตรง

```bash
# Switch Demo
flutter run lib/widgets/switch_demo_page.dart

# Slider Demo
flutter run lib/widgets/slider_demo_page.dart

# SegmentedButton Demo
flutter run lib/widgets/segmented_button_demo_page.dart

# Chip Demo
flutter run lib/widgets/chip_demo_page.dart

# DatePicker Demo
flutter run lib/widgets/date_picker_demo_page.dart
```

---

## 📱 หน้าจอที่เห็นใน App

### Home Page
```
╔═══════════════════════════════════════╗
║     Select a Demo to Explore          ║
╠═══════════════════════════════════════╣
║                                       ║
║  📋 1. Customer Details Form          ║
║     Customer registration with...     ║
║                                       ║
║  📦 2. Product Registration Form      ║
║     Register new products with...     ║
║                                       ║
║  📊 3. Employee Survey Form           ║
║     Employee satisfaction survey...   ║
║                                       ║
║  ─────────────────────────────────    ║
║                                       ║
║         Widget Demos                  ║
║                                       ║
║  🔘 Switch Demo                       ║
║     Toggle switches for settings...   ║
║                                       ║
║  🎚  Slider Demo                      ║
║     Adjustable sliders for values...  ║
║                                       ║
║  ▫️  SegmentedButton Demo             ║
║     Material 3 segmented buttons...   ║
║                                       ║
║  🏷  Chip Demo                         ║
║     Choice, Filter, and Input chips...║
║                                       ║
║  📅 DatePicker Demo                   ║
║     Date and time picker dialogs...   ║
║                                       ║
╚═══════════════════════════════════════╝
```

---

## 🎯 Widget Demos รายละเอียด

### 1. Switch Demo
**หน้าจอ:**
- ✅ Enable Notifications (on/off)
- 🌙 Dark Mode (on/off)
- 💾 Auto Save (on/off)
- 📊 Current Settings Display

**คุณสมบัติ:**
- SwitchListTile widget
- Real-time state updates
- BLoC pattern

### 2. Slider Demo
**หน้าจอ:**
- 🔊 Volume (0-100)
- 💡 Brightness (0-100)
- 🌡  Temperature (10-30°C)

**คุณสมบัติ:**
- Slider widget with divisions
- Label display
- Different ranges and steps

### 3. SegmentedButton Demo
**หน้าจอ:**
- 👕 Size Selection (S/M/L/XL)
- 🚚 Delivery Speed (express/standard/economy)
- 🍕 Toppings (multi-select)

**คุณสมบัติ:**
- Material 3 SegmentedButton
- Single selection mode
- Multi selection mode
- Icon support

### 4. Chip Demo
**หน้าจอ:**
- ⭐ Priority (ChoiceChip: low/medium/high)
- 🏷  Categories (FilterChip: work/personal/urgent)
- ❤️  Interests (InputChip: tech/sports/music/travel)

**คุณสมบัติ:**
- ChoiceChip (single select)
- FilterChip (multi select)
- InputChip (multi select)

### 5. DatePicker Demo
**หน้าจอ:**
- 🎂 Birth Date (past dates only)
- 📅 Appointment Date (future dates)
- ⏰ Appointment Time

**คุณสมบัติ:**
- showDatePicker dialog
- showTimePicker dialog
- Date formatting with intl package

---

## 🔧 การทดสอบ

### Manual Testing
1. เปิด app: `flutter run`
2. เลือก widget demo จาก home page
3. ทดสอบการทำงานของ widget
4. สังเกต state changes ใน UI

### Hot Reload
```bash
# ระหว่างรัน app กด 'r' เพื่อ hot reload
# หรือกด 'R' เพื่อ hot restart
```

### Debug Mode
```bash
# รันในโหมด debug
flutter run --debug

# ดู logs
flutter logs
```

---

## 📊 Widget Keys สำหรับ Testing (อนาคต)

### Switch Demo
```dart
switch_01_notifications_switch
switch_02_darkmode_switch
switch_03_autosave_switch
switch_04_status_text
```

### Slider Demo
```dart
slider_01_volume_slider
slider_02_volume_text
slider_03_brightness_slider
slider_04_brightness_text
slider_05_temperature_slider
slider_06_temperature_text
```

### SegmentedButton Demo
```dart
segmented_01_size_button
segmented_02_delivery_button
segmented_03_toppings_button
segmented_04_status_text
```

### Chip Demo
```dart
chip_01_priority_low to chip_03_priority_high
chip_04_filter_work to chip_06_filter_urgent
chip_07_interest_tech to chip_10_interest_travel
chip_11_status_text
```

### DatePicker Demo
```dart
datepicker_01_birthdate_tile
datepicker_02_appointment_date_tile
datepicker_03_appointment_time_tile
datepicker_04_status_text
```

---

## 🎨 Customization

### เปลี่ยนสี Theme
แก้ไขใน `lib/main.dart`:

```dart
theme: ThemeData(
  primarySwatch: Colors.blue,  // เปลี่ยนสีหลัก
  useMaterial3: true,
),
```

### เพิ่ม Widget Demo ใหม่
1. สร้างไฟล์ใน `lib/widgets/`
2. สร้าง Cubit ใน `lib/cubit/widgets/`
3. เพิ่มใน `lib/main.dart`:

```dart
import 'widgets/new_widget_demo_page.dart';

// ใน HomePage
_buildFormCard(
  context,
  title: 'New Widget Demo',
  description: 'Description here',
  icon: Icons.new_icon,
  color: Colors.purple,
  onTap: () => _navigateToPage(context, const NewWidgetDemoPage()),
),
```

---

## 🐛 Troubleshooting

### ปัญหา: App ไม่รัน
```bash
# ลอง clean แล้ว rebuild
flutter clean
flutter pub get
flutter run
```

### ปัญหา: Package not found
```bash
# ติดตั้ง dependencies ใหม่
flutter pub get
```

### ปัญหา: Hot reload ไม่ทำงาน
```bash
# Hot restart แทน (กด R)
# หรือ restart app ใหม่
```

---

## 📚 เอกสารเพิ่มเติม

- [lib/widgets/README.md](lib/widgets/README.md) - Widget overview
- [lib/widgets/WIDGET_IMPLEMENTATION_GUIDE.md](lib/widgets/WIDGET_IMPLEMENTATION_GUIDE.md) - Implementation details
- [INTERACTIVE_MODE_GUIDE.md](INTERACTIVE_MODE_GUIDE.md) - Test generator guide

---

## ✅ Checklist การใช้งาน

- [ ] รัน `flutter run` เพื่อเปิด app
- [ ] ทดลองเปิด Form Demos (Customer, Product, Employee)
- [ ] ทดลองเปิด Widget Demos ทั้ง 5 ตัว
- [ ] ทดสอบ state management ของแต่ละ widget
- [ ] สังเกตการทำงานของ BLoC pattern

---

พร้อมใช้งานแล้ว! 🎉

รัน `flutter run` แล้วสำรวจ widgets ต่างๆ ได้เลยครับ
