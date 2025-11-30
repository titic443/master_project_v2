# generator_pict.dart

## ภาพรวม
Module สำหรับ **Pairwise Combinatorial Testing** โดยใช้ Microsoft PICT (Pairwise Independent Combinatorial Testing) tool หรือ internal algorithm เพื่อสร้าง test combinations ที่มีประสิทธิภาพ

## ความสามารถหลัก
1. สร้าง PICT model files จาก UI manifests
2. รัน PICT binary และ parse ผลลัพธ์
3. Internal pairwise algorithm (fallback เมื่อไม่มี PICT)
4. สกัด factors จาก widgets (TEXT, Radio, Dropdown, Checkbox)

## PICT Tool

### ดาวน์โหลด PICT
- GitHub: https://github.com/Microsoft/pict
- Windows: pict.exe
- Linux/Mac: สามารถ compile จาก source

### วาง PICT Binary
```bash
# วาง PICT binary ที่ project root
./pict
```

หรือระบุ path ใน command:
```bash
dart run tools/script_v2/generate_test_data.dart --pict-bin=/path/to/pict
```

## API Functions

### 1. generatePictModel()
สร้าง PICT model content จาก factors map

**Input:**
```dart
final factors = {
  'TEXT': ['valid', 'invalid'],
  'Radio1': ['yes', 'no', 'maybe'],
  'Dropdown': ['mr', 'mrs', 'ms']
};
final model = generatePictModel(factors);
```

**Output:**
```
TEXT: valid, invalid
Radio1: yes, no, maybe
Dropdown: "mr", "mrs", "ms"
```

### 2. generateValidOnlyPictModel()
สร้าง PICT model ที่มีเฉพาะ valid values (ไม่รวม invalid)

**Input:**
```dart
final validModel = generateValidOnlyPictModel(factors);
```

**Output:**
```
TEXT: valid
Radio1: yes, no, maybe
Dropdown: "mr", "mrs", "ms"
```

### 3. executePict()
รัน PICT binary และ return pairwise combinations

**Usage:**
```dart
final combos = await executePict(factors, pictBin: './pict');
// Result: [
//   {'TEXT': 'valid', 'Radio1': 'yes', 'Dropdown': 'mr'},
//   {'TEXT': 'invalid', 'Radio1': 'no', 'Dropdown': 'mrs'},
//   ...
// ]
```

### 4. parsePictResult()
แปลง PICT output (tab-separated) เป็น List of Maps

**Input:**
```
TEXT	Radio1	Dropdown
valid	yes	mr
invalid	no	mrs
```

**Output:**
```dart
[
  {'TEXT': 'valid', 'Radio1': 'yes', 'Dropdown': 'mr'},
  {'TEXT': 'invalid', 'Radio1': 'no', 'Dropdown': 'mrs'}
]
```

### 5. extractFactorsFromManifest()
สกัด factors จาก UI manifest widgets

**Input:**
```dart
final widgets = [
  {
    'widgetType': 'TextFormField',
    'key': 'firstname_textfield',
    'meta': {...}
  },
  {
    'widgetType': 'Radio<int>',
    'key': 'age_10_20_radio',
    'meta': {'groupValueBinding': 'state.age'}
  },
  {
    'widgetType': 'DropdownButtonFormField',
    'key': 'title_dropdown',
    'meta': {
      'options': [
        {'value': 'mr', 'text': 'Mr.'},
        {'value': 'mrs', 'text': 'Mrs.'}
      ]
    }
  }
];

final factors = extractFactorsFromManifest(widgets);
```

**Output:**
```dart
{
  'TEXT': ['valid', 'invalid'],
  'Radio1': ['age_10_20_radio', 'age_21_30_radio', 'age_31_40_radio'],
  'Dropdown': ['mr', 'mrs', 'ms']
}
```

### 6. writePictModelFiles()
สร้าง PICT model files และรัน PICT เพื่อสร้าง result files

**Usage:**
```dart
await writePictModelFiles(
  factors: factors,
  pageBaseName: 'register_page',
  pictBin: './pict',
);
```

**Generated Files:**
- `output/model_pairwise/register_page.full.model.txt`
- `output/model_pairwise/register_page.valid.model.txt`
- `output/model_pairwise/register_page.full.result.txt`
- `output/model_pairwise/register_page.valid.result.txt`

### 7. generatePairwiseInternal()
Internal pairwise algorithm (ใช้เมื่อไม่มี PICT binary)

**Algorithm:** Greedy set cover
**Coverage:** ครอบคลุมทุกคู่ของ factor values

**Usage:**
```dart
final combos = generatePairwiseInternal(factors);
```

### 8. generatePairwiseFromManifest()
High-level API สำหรับสร้าง pairwise combinations จาก manifest

**Usage:**
```dart
final result = await generatePairwiseFromManifest(
  manifestPath: 'output/manifest/register_page.manifest.json',
  uiFilePath: 'lib/demos/register_page.dart',
  pictBin: './pict',
  usePict: true,
);

print('Combinations: ${result.combinations.length}');
print('Valid combinations: ${result.validCombinations.length}');
print('Method: ${result.method}'); // 'pict' or 'internal'
```

## Factor Types

### TEXT Factors
- จาก TextFormField/TextField widgets
- Values: `['valid', 'invalid']`
- Naming: `TEXT`, `TEXT2`, `TEXT3`, ...

### Radio Factors
- จาก Radio widgets จัดกลุ่มตาม `groupValueBinding`
- Values: radio key suffixes (เช่น `['age_10_20_radio', 'age_21_30_radio']`)
- Naming: `Radio1`, `Radio2`, `Radio3`, ...

### Dropdown Factors
- จาก DropdownButtonFormField
- Values: option values จาก `meta.options`
- Naming: `Dropdown`, `Dropdown2`, `Dropdown3`, ...

### Checkbox Factors
- จาก Checkbox/FormField<bool>
- Values: `['checked', 'unchecked']`
- Naming: `Checkbox`, `Checkbox2`, `Checkbox3`, ...

## Radio Key Suffix Extraction

**Full Key Pattern:**
```
{page_prefix}_{sequence}_{description}_{value}_radio
```

**Example:**
```
customer_05_age_10_20_radio
```

**Suffix (used in PICT):**
```
age_10_20_radio
```

**Extraction Logic:**
```dart
String _extractRadioKeySuffix(String radioKey) {
  final parts = radioKey.split('_');
  if (parts.length > 2) {
    return parts.skip(2).join('_'); // Skip page prefix and sequence
  }
  return radioKey;
}
```

## PICT Model File Format

### Full Model
```
# Pairwise Test Model
TEXT: valid, invalid
TEXT2: valid, invalid
Radio1: age_10_20_radio, age_21_30_radio, age_31_40_radio
Dropdown: "mr", "mrs", "ms"
Checkbox: checked, unchecked
```

### Valid-Only Model
```
# Valid-only Test Model
TEXT: valid
TEXT2: valid
Radio1: age_10_20_radio, age_21_30_radio, age_31_40_radio
Dropdown: "mr", "mrs", "ms"
Checkbox: checked, unchecked
```

## PICT Result Format

```
TEXT	TEXT2	Radio1	Dropdown	Checkbox
valid	valid	age_10_20_radio	mr	checked
invalid	valid	age_21_30_radio	mrs	unchecked
valid	invalid	age_31_40_radio	ms	checked
invalid	invalid	age_10_20_radio	mr	unchecked
```

## Internal Pairwise Algorithm

### Algorithm: Greedy Set Cover
1. สร้าง set ของทุกคู่ที่ต้องครอบคลุม
   ```
   Pairs needed:
   TEXT=valid|Radio1=yes
   TEXT=valid|Radio1=no
   TEXT=invalid|Radio1=yes
   TEXT=invalid|Radio1=no
   Radio1=yes|Dropdown=mr
   ...
   ```

2. หา test case ที่ครอบคลุม pairs มากที่สุด
3. เพิ่ม test case นั้นและ mark pairs ที่ครอบคลุมแล้ว
4. วนซ้ำจนครอบคลุมทุก pairs

### Complexity
- Time: O(n × m²) where n = test cases, m = factors
- Space: O(m × v²) where v = values per factor

### Comparison with PICT
- PICT: Optimal combinations (minimum test cases)
- Internal: Near-optimal (may have 10-20% more cases)
- PICT: ต้องมี binary
- Internal: Pure Dart, ไม่ต้องมี dependencies

## PairwiseResult Class

```dart
class PairwiseResult {
  final List<Map<String, String>> combinations;      // Full combos
  final List<Map<String, String>> validCombinations; // Valid-only combos
  final Map<String, List<String>> factors;           // Factor definitions
  final String method;                                // 'pict' or 'internal'
}
```

## Integration Example

```dart
import 'generator_pict.dart' as pict;

void main() async {
  // Extract factors from manifest
  final widgets = [...]; // From manifest JSON
  final factors = pict.extractFactorsFromManifest(widgets);

  // Write PICT model files
  await pict.writePictModelFiles(
    factors: factors,
    pageBaseName: 'register_page',
    pictBin: './pict',
  );

  // Generate combinations using PICT
  try {
    final combos = await pict.executePict(factors, pictBin: './pict');
    print('Generated ${combos.length} test cases using PICT');
  } catch (e) {
    // Fallback to internal algorithm
    final combos = pict.generatePairwiseInternal(factors);
    print('Generated ${combos.length} test cases using internal algorithm');
  }
}
```

## Error Handling

### PICT Execution Errors
```dart
try {
  final combos = await executePict(factors);
} catch (e) {
  // PICT not found or failed
  stderr.writeln('PICT failed: $e');
  final combos = generatePairwiseInternal(factors); // Use fallback
}
```

### Empty Factors
```dart
final factors = {};
final combos = await executePict(factors);
// Returns: []
```

## Performance

### PICT Binary
- Very fast: 1000+ combinations in < 1 second
- Optimal: Minimum test cases
- Binary dependency

### Internal Algorithm
- Moderate: 1000 combinations in 1-5 seconds
- Near-optimal: 10-20% more cases than PICT
- Pure Dart: No dependencies

## หมายเหตุ
- PICT แนะนำสำหรับ production use (optimal results)
- Internal algorithm เหมาะสำหรับ development (no setup)
- Dropdown values ต้องใส่ quotes ใน PICT model
- Radio key suffixes จะถูกใช้ใน PICT แทน full keys
- Valid-only model ใช้สำหรับ happy path testing
