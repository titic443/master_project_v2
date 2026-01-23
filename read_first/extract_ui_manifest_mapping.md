# Mapping จาก `extract_ui_manifest.dart` ไปยังไฟล์ `.manifest.json`

ไฟล์ `tools/script_v2/extract_ui_manifest.dart` อ่านโค้ด Dart ของ widget แต่ละตัว แล้วบันทึกผลเป็น JSON ใน `output/manifest/<subfolder>/<page>.manifest.json` โดยมีการแมปพารามิเตอร์และค่าต่าง ๆ ตามตารางด้านล่าง

| Widget + พารามิเตอร์ | ฟิลด์ใน `<page>.manifest.json` | หมายเหตุ |
| --- | --- | --- |
| `key: Key('...')`, `ValueKey`, `ObjectKey` | `widgets[].key` | ค่าถูกดึงเป็นสตริงเดียว ไม่รวม `const` |
| `Text('literal')`, `Text(data: 'literal')` | `widgets[].textLiteral` | เก็บเฉพาะ literal ไม่รวมตัวแปร |
| `Text` ที่อ้าง `state.someField` และมี key | `widgets[].displayBinding` (`key`, `stateField`) | ใช้จับคู่ข้อความกับ state field |
| `onPressed`, `onChanged`, `onTap`, `onSubmitted`, `onFieldSubmitted`, `onSaved` | `widgets[].actions[]` (`event`, `argType`, `calls`) | แมปชื่ออีเวนต์ พร้อมวิเคราะห์เมธอดที่ถูกเรียก เช่น `RegisterCubit.onEmailChanged` |
| `context.read<Cubit>().method()` / `_cubit.method()` ใน callback | `widgets[].actions[].calls[]` (`target`, `method`) | แยก target + method สำหรับรายงานเส้นทางการเรียก |
| `Radio<T>(value: ...)` | `widgets[].meta.valueExpr` | เก็บนิพจน์ตามที่ปรากฏในโค้ด เช่น `0`, `state.gender` |
| `Radio<T>(groupValue: ...)` | `widgets[].meta.groupValueBinding` | ใช้บอกว่า radio ทั้งกลุ่มแชร์ค่าอะไร |
| `FormField` ที่ภายในมี `Radio` | `widgets[].meta.options[]` (`key`, `value`, `label`) | สกัด key/value/label ของ radio แต่ละตัว |
| `validator: ...` ภายใน `TextFormField`/`DropdownButtonFormField`/`FormField` | `widgets[].meta.validator` = `true`, `required` = `true` | มีเมื่อพบตัวแปร `validator` |
| `if (...) return 'ข้อความ';` หรือ ternary ใน `validator` | `widgets[].meta.validatorRules[]` (`condition`, `message`) | พยายามจับคู่เงื่อนไขกับข้อความแจ้งเตือน |
| `autovalidateMode: AutovalidateMode.xxx` | `widgets[].meta.autovalidateMode` | บันทึกชื่อโหมดเป็นสตริง |
| `DropdownButton(FormField)` ที่มี `DropdownMenuItem` | `widgets[].meta.itemsCount` + `widgets[].meta.options[]` (`value`, `text`) | นับจำนวน item และดึง label/value |
| `DropdownButton(FormField)(value: ...)` | `widgets[].meta.hasValue` = `true` | ใช้ระบุว่ามีค่าเริ่มต้น |
| `Checkbox/Switch(value: ...)` | `widgets[].meta.valueBinding` | เก็บนิพจน์ที่ใช้ควบคุมค่า true/false |
| `TextField`/`TextFormField` `keyboardType: TextInputType.xxx` | `widgets[].meta.keyboardType` | บันทึกชื่อ type เช่น `emailAddress` |
| `TextField`/`TextFormField` `obscureText: true` | `widgets[].meta.obscureText` | แปลงเป็น boolean |
| `TextField`/`TextFormField` `maxLength: n` | `widgets[].meta.maxLength` | เก็บเป็นจำนวนเต็ม |
| `FilteringTextInputFormatter.digitsOnly`/`singleLine` | `widgets[].meta.inputFormatters[]` (`type`) | ตัวอย่าง `{ "type": "digitsOnly" }` |
| `FilteringTextInputFormatter.allow(RegExp(...))` | `widgets[].meta.inputFormatters[]` (`type`: `allow`, `pattern`, `replacement?`) | รองรับทั้ง literal regex และตัวแปรที่ถูกเก็บไว้จาก `RegExp` |
| `FilteringTextInputFormatter.deny(...)` | `widgets[].meta.inputFormatters[]` (`type`: `deny`, `pattern`, `replacement?`) | เช่นเดียวกับ `allow` |
| `LengthLimitingTextInputFormatter(n)` | `widgets[].meta.inputFormatters[]` (`type`: `lengthLimit`, `max`) | ระบุจำนวนอักขระสูงสุด |
| Formatter อื่น ๆ ที่ลงท้ายด้วย `Formatter(...)` | `widgets[].meta.inputFormatters[]` (`type`: `custom`, `name`, `args?`) | ใช้ระบุชื่อ formatter กำหนดเอง |
| Widget ที่ถูกห่อด้วย `BlocListener`/`BlocBuilder`/`BlocSelector` | `widgets[].wrappers[]` | รายชื่อ wrapper ถูกตรวจจากโค้ดบริเวณก่อนหน้า widget |

ฟิลด์ทั่วไปอื่น ๆ เช่น `source.file`, `source.pageClass`, `source.route` มาจากข้อมูลของไฟล์เพจเอง ไม่เกี่ยวกับพารามิเตอร์ของ widget
