/// ============================================================================
/// extract_ui_manifest.dart
/// ============================================================================
///
/// Static Code Analyzer สำหรับ Flutter UI
/// อ่าน source code ของ Flutter page แล้วสกัดข้อมูล widgets ออกมาเป็น JSON manifest
///
/// Usage:
///   dart run tools/script_v2/extract_ui_manifest.dart lib/demos/page.dart
///   dart run tools/script_v2/extract_ui_manifest.dart  (scan all pages)
///
/// Output:
///   output/manifest/<subfolder>/<page_name>.manifest.json
///
/// Manifest JSON Structure:
/// {
///   "source": {
///     "file": "lib/demos/page.dart",
///     "pageClass": "MyPage",
///     "cubitClass": "MyCubit",
///     "stateClass": "MyState"
///   },
///   "widgets": [
///     {"widgetType": "TextFormField", "key": "...", "meta": {...}}
///   ]
/// }
/// ============================================================================

import 'dart:convert';
import 'dart:io';

import 'utils.dart' as utils;

/// ============================================================================
/// PUBLIC API
/// ============================================================================

/// Public API สำหรับเรียกจากโปรแกรมภายนอก (เช่น VS Code extension)
///
/// [path] - path ไปยังไฟล์ .dart ที่ต้องการ process
///
/// Returns: path ของไฟล์ manifest ที่สร้าง
///
/// Example:
/// ```dart
/// String manifestPath = processUiFile('lib/demos/my_page.dart');
/// // → 'output/manifest/demos/my_page.manifest.json'
/// ```
String processUiFile(String path) {
  // ตรวจสอบว่าไฟล์มีอยู่จริง
  if (!File(path).existsSync()) {
    throw Exception('File not found: $path');
  }

  // เรียก internal function เพื่อ process ไฟล์
  _processOne(path);

  // คำนวณและ return path ของ output file
  // แปลง backslash เป็น forward slash (Windows compatibility)
  final normalizedPath = path.replaceAll('\\', '/');
  String subfolderPath = '';

  // สกัด subfolder path จาก input path
  // เช่น lib/demos/page.dart → demos
  if (normalizedPath.startsWith('lib/')) {
    final pathAfterLib = normalizedPath.substring(4); // ตัด 'lib/' ออก
    final lastSlash = pathAfterLib.lastIndexOf('/');
    if (lastSlash > 0) {
      subfolderPath = pathAfterLib.substring(0, lastSlash);
    }
  }

  // สร้าง output directory path
  final outDir = subfolderPath.isNotEmpty
      ? Directory('output/manifest/$subfolderPath')
      : Directory('output/manifest');
  return '${outDir.path}/${utils.basenameWithoutExtension(path)}.manifest.json';
}

/// ============================================================================
/// MAIN ENTRY POINT
/// ============================================================================

/// Entry point ของ script
///
/// Usage:
///   dart run tools/script_v2/extract_ui_manifest.dart [file1.dart] [file2.dart] ...
///
/// ถ้าไม่มี arguments:
///   - Scan หาไฟล์ *_page.dart และ *.page.dart ทั้งหมดใน lib/
///   - Process ทุกไฟล์ที่พบ
///
/// ถ้ามี arguments:
///   - Process เฉพาะไฟล์ที่ระบุ
void main(List<String> args) {
  if (args.isEmpty) {
    // ไม่มี arguments → Scan หา page files ทั้งหมดใน lib/
    // Pattern: *_page.dart หรือ *.page.dart
    final pages = utils
        .listFiles(
            'lib', (p) => p.endsWith('_page.dart') || p.endsWith('.page.dart'))
        .toList();

    if (pages.isEmpty) {
      stderr.writeln('No page files found under lib/**');
      exit(1);
    }

    // Process ทุก page ที่พบ
    for (final p in pages) {
      _processOne(p);
    }
    return;
  }

  // มี arguments → Process เฉพาะไฟล์ที่ระบุ
  for (final p in args) {
    _processOne(p);
  }
}

/// ============================================================================
/// CORE PROCESSING FUNCTION
/// ============================================================================

/// Process ไฟล์ .dart หนึ่งไฟล์และสร้าง manifest JSON
///
/// ขั้นตอนการทำงาน:
/// 1. อ่านไฟล์และลบ comments
/// 2. หา page metadata (class name, cubit, state)
/// 3. Scan หา widgets และ extract metadata
/// 4. Filter และ sort widgets
/// 5. เขียน manifest JSON
void _processOne(String path) {
  // ===== STEP 1: อ่านไฟล์ =====
  if (!File(path).existsSync()) {
    stderr.writeln('File not found: $path');
    return;
  }

  // อ่าน source code ทั้งหมด
  final rawSrc = File(path).readAsStringSync();

  // ลบ comments (// และ /* */) เพื่อไม่ให้จับ widgets ใน commented code
  final src = _stripComments(rawSrc);

  // เก็บ const string declarations สำหรับ resolve key interpolations
  // เช่น const prefix = 'customer'; → Key('${prefix}_name')
  final consts = _collectStringConsts(src);

  // ===== STEP 2: หา Page Metadata =====

  // หาชื่อ Widget class (extends StatefulWidget/StatelessWidget)
  final pageClass = _findPageClass(src) ?? utils.basenameWithoutExtension(path);

  // หา Cubit/Bloc type จาก BlocBuilder/BlocListener
  final cubitType = _findCubitType(src);

  // หา State type จาก generic parameter
  final stateType = _findStateType(src);

  // หา file paths ของ cubit และ state จาก import statements
  final cubitFilePath = _findCubitFilePath(src, cubitType);
  final stateFilePath = _findStateFilePath(src, stateType);

  // ===== STEP 3: Scan Widgets =====

  // Scan หา target widgets ทั้งหมดและ extract metadata
  final widgets = _scanWidgets(src, consts: consts, cubitType: cubitType);

  // Scan หา showDatePicker/showTimePicker calls
  // ใช้ rawSrc เพราะต้องการหา method bodies ด้วย
  final pickers = _scanDateTimePickers(rawSrc);

  // ===== STEP 4: Filter และ Deduplicate =====

  final seen = <String>{}; // เก็บ keys ที่เจอแล้ว
  final widgetsWithKeys = <Map<String, dynamic>>[];

  for (final w in widgets) {
    final key = w['key'];

    // ข้าม widgets ที่ไม่มี key
    if (key != null && key is String && key.isNotEmpty) {
      // Deduplicate: เก็บเฉพาะ widget แรกที่มี key ซ้ำ
      if (seen.add(key)) {
        // Link picker metadata ถ้า widget มี onTap ที่เรียก picker method
        final onTap = w['onTap'];
        if (onTap != null && onTap is String && pickers.containsKey(onTap)) {
          w['pickerMetadata'] = pickers[onTap];
        }
        widgetsWithKeys.add(w);
      }
    }
  }

  // ===== STEP 5: Sort Widgets =====

  // เรียงตาม SEQUENCE ใน key ก่อน แล้วตาม source order
  // Pattern: {SEQUENCE}_*_{WIDGET} (เช่น "1_customer_firstname_textfield")
  widgetsWithKeys.sort((a, b) {
    final keyA = (a['key'] as String?) ?? '';
    final keyB = (b['key'] as String?) ?? '';

    // สกัด SEQUENCE number จาก key (ตัวเลขก่อน underscore แรก)
    final seqA = _extractSequence(keyA);
    final seqB = _extractSequence(keyB);

    // Priority 1: Widgets ที่มี SEQUENCE มาก่อน เรียงตาม SEQUENCE
    if (seqA != null && seqB != null) {
      return seqA.compareTo(seqB);
    }
    if (seqA != null) return -1; // A มี sequence, B ไม่มี → A มาก่อน
    if (seqB != null) return 1; // B มี sequence, A ไม่มี → B มาก่อน

    // Priority 2: Widgets ที่ไม่มี SEQUENCE เรียงตาม source order
    final orderA = (a['sourceOrder'] as int?) ?? 0;
    final orderB = (b['sourceOrder'] as int?) ?? 0;
    return orderA.compareTo(orderB);
  });

  // ลบ sourceOrder ออกจาก output (ใช้เฉพาะสำหรับ sorting)
  for (final w in widgetsWithKeys) {
    w.remove('sourceOrder');
  }

  // ===== STEP 6: สร้าง Manifest Object =====

  final ir = {
    'source': {
      'file': path,
      'pageClass': pageClass,
      if (cubitType != null) 'cubitClass': cubitType,
      if (stateType != null) 'stateClass': stateType,
      if (cubitFilePath != null) 'fileCubit': cubitFilePath,
      if (stateFilePath != null) 'fileState': stateFilePath,
    },
    'widgets': widgetsWithKeys,
  };

  // ===== STEP 7: คำนวณ Output Path =====

  // สกัด subfolder structure จาก input path
  // เช่น lib/demos/register_page.dart → output/manifest/demos/register_page.manifest.json
  final normalizedPath = path.replaceAll('\\', '/');
  String subfolderPath = '';

  // ตัด lib/ prefix ออก
  if (normalizedPath.startsWith('lib/')) {
    final pathAfterLib = normalizedPath.substring(4); // ตัด 'lib/'
    final lastSlash = pathAfterLib.lastIndexOf('/');
    if (lastSlash > 0) {
      subfolderPath = pathAfterLib.substring(0, lastSlash);
    }
  }

  // สร้าง output directory
  final outDir = subfolderPath.isNotEmpty
      ? Directory('output/manifest/$subfolderPath')
      : Directory('output/manifest');
  outDir.createSync(recursive: true);

  // ===== STEP 8: เขียน Manifest File =====

  final outPath =
      '${outDir.path}/${utils.basenameWithoutExtension(path)}.manifest.json';
  File(outPath)
      .writeAsStringSync(const JsonEncoder.withIndent('  ').convert(ir) + '\n');
  stdout.writeln('✓ Manifest written: $outPath');
}

/// ============================================================================
/// COMMENT STRIPPING
/// ============================================================================

/// ลบ comments ออกจาก source code โดยไม่ลบ strings
///
/// รองรับ:
/// - Line comments: // ...
/// - Block comments: /* ... */
/// - ไม่ลบ // หรือ /* ที่อยู่ภายใน strings
/// - รองรับ raw strings: r'...' และ r"..."
/// - รองรับ escape characters ใน strings: \'  \"
///
/// ตัวอย่าง:
/// ```dart
/// // Input:
/// final x = 'hello'; // this is comment
/// /* block comment */
/// final y = "contains // not comment";
///
/// // Output:
/// final x = 'hello';
///
/// final y = "contains // not comment";
/// ```
String _stripComments(String s) {
  final b = StringBuffer();

  // State flags สำหรับ track ว่าอยู่ใน context ไหน
  bool inS = false; // อยู่ใน single-quoted string '...'
  bool inD = false; // อยู่ใน double-quoted string "..."
  bool inRawS = false; // อยู่ใน raw single-quoted string r'...'
  bool inRawD = false; // อยู่ใน raw double-quoted string r"..."
  bool inLine = false; // อยู่ใน line comment //
  bool inBlock = false; // อยู่ใน block comment /* */

  for (int i = 0; i < s.length; i++) {
    final c = s[i];
    final next = i + 1 < s.length ? s[i + 1] : '';

    // ----- Handle Line Comment -----
    if (inLine) {
      // Line comment จบที่ newline
      if (c == '\n') {
        inLine = false;
        b.write(c); // เก็บ newline ไว้
      }
      continue; // ข้าม characters ใน comment
    }

    // ----- Handle Block Comment -----
    if (inBlock) {
      // Block comment จบที่ */
      if (c == '*' && next == '/') {
        inBlock = false;
        i++; // ข้าม '/'
      }
      continue; // ข้าม characters ใน comment
    }

    // ----- Detect Start of Comments (เฉพาะนอก strings) -----
    if (!inS && !inD && !inRawS && !inRawD) {
      if (c == '/' && next == '/') {
        inLine = true;
        i++; // ข้าม '/' ตัวที่สอง
        continue;
      }
      if (c == '/' && next == '*') {
        inBlock = true;
        i++; // ข้าม '*'
        continue;
      }
    }

    // ----- Handle Raw String Prefix (r' หรือ r") -----
    if (!inS && !inD && !inRawS && !inRawD && (c == 'r' || c == 'R')) {
      final n2 = i + 1 < s.length ? s[i + 1] : '';
      if (n2 == '\'' || n2 == '"') {
        // เริ่ม raw string
        if (n2 == '\'')
          inRawS = true;
        else
          inRawD = true;
        b.write(c); // เขียน 'r'
        i++;
        b.write(n2); // เขียน quote
        continue;
      }
    }

    // ----- Toggle Normal Strings -----
    if (!inRawS && !inRawD) {
      // Single quote
      if (!inD && c == '\'') {
        inS = !inS;
        b.write(c);
        continue;
      }
      // Double quote
      if (!inS && c == '"') {
        inD = !inD;
        b.write(c);
        continue;
      }
      // Escape character ใน string
      if ((inS || inD) && c == '\\') {
        if (i + 1 < s.length) {
          b.write(c); // เขียน \
          b.write(s[i + 1]); // เขียน escaped char
          i++;
          continue;
        }
      }
    } else {
      // ----- End Raw Strings -----
      // Raw strings ไม่มี escape, จบที่ matching quote
      if (inRawS && c == '\'') {
        inRawS = false;
        b.write(c);
        continue;
      }
      if (inRawD && c == '"') {
        inRawD = false;
        b.write(c);
        continue;
      }
    }

    // ----- เขียน character ปกติ -----
    b.write(c);
  }

  return b.toString();
}

/// ============================================================================
/// PAGE METADATA EXTRACTION
/// ============================================================================

/// หาชื่อ Widget class ที่ extends StatefulWidget หรือ StatelessWidget
///
/// ตัวอย่าง:
/// ```dart
/// class CustomerDetailsPage extends StatelessWidget { ... }
/// // Returns: "CustomerDetailsPage"
/// ```
String? _findPageClass(String src) {
  final m =
      RegExp(r'class\s+(\w+)\s+extends\s+(?:StatefulWidget|StatelessWidget)')
          .firstMatch(src);
  return m?.group(1);
}

/// ============================================================================
/// WIDGET SCANNING
/// ============================================================================

/// Scan หา widgets ทั้งหมดใน source code และ extract metadata
///
/// [src] - source code ที่ลบ comments แล้ว
/// [consts] - map ของ const string declarations สำหรับ resolve keys
/// [cubitType] - ชื่อ Cubit class (ถ้ามี) สำหรับ resolve method calls
///
/// Returns: List ของ widget maps พร้อม metadata
///
/// Target widgets ที่รองรับ:
/// - TextField, TextFormField, FormField
/// - Radio, Checkbox, Switch, SwitchListTile, Slider
/// - ElevatedButton, TextButton, OutlinedButton, IconButton
/// - DropdownButton, DropdownButtonFormField
/// - Text, ListTile, Visibility, SnackBar
List<Map<String, dynamic>> _scanWidgets(String src,
    {Map<String, String> consts = const {}, String? cubitType}) {
  // Target widget types ที่ต้องการ extract
  final targets = <String>{
    'TextField',
    'TextFormField',
    'FormField',
    'Radio',
    'ElevatedButton',
    'TextButton',
    'OutlinedButton',
    'IconButton',
    'Text',
    'DropdownButton',
    'DropdownButtonFormField',
    'Checkbox',
    'Switch',
    'SwitchListTile',
    'Slider',
    'ListTile',
    'Visibility',
    'SnackBar',
  };

  final out = <Map<String, dynamic>>[];

  // เก็บ RegExp variable declarations สำหรับ resolve ใน inputFormatters
  final regexVars = _collectRegexVars(src);

  int i = 0;
  int sourceOrder = 0; // Track ลำดับที่พบใน source

  // Scan ทั้ง source code
  while (i < src.length) {
    // Pattern: WidgetName<GenericType>(
    // Group 1: Widget name (เริ่มด้วยตัวพิมพ์ใหญ่)
    // Group 2: Generic type parameter (optional)
    final m =
        RegExp(r'([A-Z][A-Za-z0-9_]*)\s*(<[^>]*>)?\s*\(').matchAsPrefix(src, i);

    if (m == null) {
      i++;
      continue;
    }

    final type = m.group(1)!; // Widget type name
    final generics = m.group(2); // Generic parameters เช่น <String>

    // ข้าม widgets ที่ไม่ใช่ target
    if (!targets.contains(type)) {
      i = m.end;
      continue;
    }

    // หา matching closing parenthesis
    final startArgs = m.end - 1; // ตำแหน่งของ '('
    final endIdx = _matchParen(src, startArgs);

    if (endIdx == -1) {
      // ไม่เจอ closing paren, ข้ามไป
      i = m.end;
      continue;
    }

    // Extract argument source (ระหว่าง ( และ ))
    final argsSrc = src.substring(startArgs + 1, endIdx);

    // ----- Extract Widget Properties -----

    // Extract key parameter
    final key = _extractKey(argsSrc, consts: consts);

    // Extract Text binding สำหรับ Text widget
    final binding =
        type == 'Text' ? _extractTextBinding(argsSrc, consts: consts) : null;

    // Extract onTap method name (สำหรับ link กับ pickers)
    final onTapMethod = _extractOnTapMethod(argsSrc);

    // ----- Extract Widget-specific Metadata -----
    Map<String, dynamic> meta = {};

    // TextField/TextFormField: keyboardType, maxLength, inputFormatters
    if (type == 'TextField' || type == 'TextFormField') {
      meta.addAll(_extractTextFieldMeta(argsSrc, regexVars: regexVars));
    }

    // Radio: value, groupValue
    if (type.startsWith('Radio')) {
      meta.addAll(_extractRadioMeta(argsSrc));
    }

    // Generic validation/meta for form widgets
    meta.addAll(_extractValidationMeta(type, argsSrc));

    // ----- สร้าง Widget Object -----
    out.add({
      'widgetType': type + (generics != null ? generics : ''),
      if (key != null) 'key': key,
      if (binding != null) 'displayBinding': binding,
      if (type == 'Text') ..._maybeTextLiteral(argsSrc),
      if (meta.isNotEmpty) 'meta': meta,
      if (onTapMethod != null) 'onTap': onTapMethod,
      'sourceOrder': sourceOrder++, // Track source order สำหรับ sorting
    });

    // ----- Scan Nested Widgets -----
    // Recursive scan เพื่อจับ nested widgets
    // เช่น Radio ภายใน FormField builder
    final nested = _scanWidgets(argsSrc, consts: consts, cubitType: cubitType);
    if (nested.isNotEmpty) {
      for (final n in nested) {
        if (!n.containsKey('sourceOrder')) {
          n['sourceOrder'] = sourceOrder++;
        }
      }
      out.addAll(nested);
    }

    i = endIdx + 1;
  }

  return out;
}

/// ============================================================================
/// BRACKET MATCHING UTILITIES
/// ============================================================================

/// หา matching closing parenthesis สำหรับ opening parenthesis ที่ตำแหน่ง openIdx
///
/// ใช้สำหรับ extract argument list ของ widget constructors
/// รองรับ nested parentheses และไม่นับ parentheses ที่อยู่ใน strings
///
/// [s] - source code string
/// [openIdx] - ตำแหน่งของ '(' ที่ต้องการหา matching ')'
///
/// Returns: ตำแหน่งของ ')' ที่ match, หรือ -1 ถ้าไม่เจอ
///
/// ตัวอย่าง:
/// ```dart
/// final src = "Widget(child: Text('hello'), key: Key('x'))";
/// final end = _matchParen(src, 6);  // ตำแหน่งของ '(' หลัง Widget
/// // end = 43 (ตำแหน่งของ ')' สุดท้าย)
/// ```
///
/// Algorithm:
/// 1. Track depth ของ parentheses (เพิ่มเมื่อเจอ '(', ลดเมื่อเจอ ')')
/// 2. Skip parentheses ที่อยู่ใน single-quoted หรือ double-quoted strings
/// 3. Return เมื่อ depth กลับเป็น 0
int _matchParen(String s, int openIdx) {
  int depth = 0; // Track parenthesis nesting level
  bool inS = false; // อยู่ใน single-quoted string '...'
  bool inD = false; // อยู่ใน double-quoted string "..."
  // ignore: unused_local_variable
  bool inRawStr = false; // Reserved สำหรับ raw strings (ยังไม่ได้ใช้)

  for (int i = openIdx; i < s.length; i++) {
    final c = s[i];

    // ถ้าอยู่นอก string
    if (!inS && !inD) {
      // นับ parentheses
      if (c == '(') depth++;
      if (c == ')') {
        depth--;
        if (depth == 0) return i; // พบ matching closing paren
      }
      // เริ่ม string
      if (c == '\'') inS = true;
      if (c == '"') inD = true;
    } else {
      // อยู่ใน string - check end of string
      if (inS && c == '\'') inS = false;
      if (inD && c == '"') inD = false;
    }
  }
  return -1; // ไม่พบ matching paren
}

/// หา matching closing brace สำหรับ opening brace ที่ตำแหน่ง openIdx
///
/// ใช้สำหรับ extract function bodies และ closure bodies
/// รองรับ nested braces และไม่นับ braces ที่อยู่ใน strings
///
/// [s] - source code string
/// [openIdx] - ตำแหน่งของ '{' ที่ต้องการหา matching '}'
///
/// Returns: ตำแหน่งของ '}' ที่ match, หรือ -1 ถ้าไม่เจอ
///
/// ตัวอย่าง:
/// ```dart
/// final src = "validator: (v) { if (v.isEmpty) { return 'Required'; } return null; }";
/// final end = _matchBrace(src, 14);  // ตำแหน่งของ '{' แรก
/// // end = 62 (ตำแหน่งของ '}' สุดท้ายของ validator)
/// ```
///
/// Algorithm: เหมือน _matchParen แต่ใช้ '{' และ '}' แทน
int _matchBrace(String s, int openIdx) {
  int depth = 0; // Track brace nesting level
  bool inS = false; // อยู่ใน single-quoted string '...'
  bool inD = false; // อยู่ใน double-quoted string "..."
  // ignore: unused_local_variable
  bool inRawStr = false; // Reserved สำหรับ raw strings (ยังไม่ได้ใช้)

  for (int i = openIdx; i < s.length; i++) {
    final c = s[i];

    // ถ้าอยู่นอก string
    if (!inS && !inD) {
      // นับ braces
      if (c == '{') depth++;
      if (c == '}') {
        depth--;
        if (depth == 0) return i; // พบ matching closing brace
      }
      // เริ่ม string
      if (c == '\'') inS = true;
      if (c == '"') inD = true;
    } else {
      // อยู่ใน string - check end of string
      if (inS && c == '\'') inS = false;
      if (inD && c == '"') inD = false;
    }
  }
  return -1; // ไม่พบ matching brace
}

/// ============================================================================
/// KEY EXTRACTION
/// ============================================================================

/// Extract key value จาก widget arguments
///
/// รองรับ key patterns หลายแบบ:
/// - Key('literal')  Key("literal")
/// - const Key('...')
/// - ValueKey<T>('...')
/// - ObjectKey([...])
///
/// รองรับ string interpolation กับ const:
/// ```dart
/// const prefix = 'customer';
/// Key('${prefix}_name')  // → 'customer_name'
/// ```
///
/// [args] - argument string ของ widget constructor
/// [consts] - map ของ const string declarations สำหรับ resolve interpolation
///
/// Returns: key value string, หรือ null ถ้าไม่มี key
///
/// ตัวอย่าง:
/// ```dart
/// final args = "key: Key('customer_name_textfield'), onChanged: ...";
/// final key = _extractKey(args);  // 'customer_name_textfield'
/// ```
String? _extractKey(String args, {Map<String, String> consts = const {}}) {
  // Helper function: resolve string interpolation ${varName}
  // แทนที่ ${varName} ด้วยค่าจาก consts map
  String resolve(String s) => s.replaceAllMapped(RegExp(r"\$\{(\w+)\}"), (mm) {
        final name = mm.group(1)!;
        return consts[name] ?? mm.group(0)!; // ถ้าไม่เจอใน consts, คืน original
      });

  // Pattern 1: Key('...')
  // ตัวอย่าง: key: Key('customer_name')
  var m =
      RegExp(r"key\s*:\s*(?:const\s+)?Key\(\s*'([^']+)'\s*\)").firstMatch(args);
  if (m != null) return resolve(m.group(1)!);

  // Pattern 2: Key("...")
  // ตัวอย่าง: key: Key("customer_name")
  m = RegExp(r'key\s*:\s*(?:const\s+)?Key\(\s*"([^\"]+)"\s*\)')
      .firstMatch(args);
  if (m != null) return resolve(m.group(1)!);

  // Pattern 3: ValueKey<T>('...')
  // ตัวอย่าง: key: ValueKey<String>('customer_name')
  m = RegExp(r"key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*'([^']+)'\s*\)")
      .firstMatch(args);
  if (m != null) return resolve(m.group(1)!);

  // Pattern 4: ValueKey("...")
  m = RegExp(r'key\s*:\s*(?:const\s+)?ValueKey(?:<[^>]+>)?\(\s*"([^\"]+)"\s*\)')
      .firstMatch(args);
  if (m != null) return resolve(m.group(1)!);

  // Pattern 5: ObjectKey([...])
  // ตัวอย่าง: key: ObjectKey(['customer', 'name'])
  // → extract string แรกในลิสต์
  m = RegExp(r'key\s*:\s*(?:const\s+)?ObjectKey\(\s*\[([^\]]*)\]\s*\)')
      .firstMatch(args);
  if (m != null) {
    final inside = m.group(1) ?? '';
    // หา string literal แรกใน list
    final ms = RegExp(r"'([^']+)'").firstMatch(inside) ??
        RegExp(r'"([^\"]+)"').firstMatch(inside);
    if (ms != null) return resolve(ms.group(1)!);
  }

  return null; // ไม่พบ key
}

/// ============================================================================
/// EVENT HANDLER EXTRACTION
/// ============================================================================

/// Extract ชื่อ method จาก onTap callback
///
/// ใช้สำหรับ link TextField กับ showDatePicker/showTimePicker
/// เมื่อ user tap TextField จะเรียก method ที่แสดง picker
///
/// รองรับ patterns:
/// 1. Arrow function:  onTap: () => _selectDate(context)
/// 2. Block function:  onTap: () { _selectDate(context); }
/// 3. Direct method:   onTap: _selectDate
///
/// [args] - argument string ของ widget constructor
///
/// Returns: ชื่อ method, หรือ null ถ้าไม่พบ
///
/// ตัวอย่าง:
/// ```dart
/// final args = "onTap: () => _selectBirthDate(context), readOnly: true";
/// final method = _extractOnTapMethod(args);  // '_selectBirthDate'
/// ```
String? _extractOnTapMethod(String args) {
  // Pattern 1: Arrow function
  // onTap: () => _methodName(...)
  // Captures: _methodName
  final arrowPattern =
      RegExp(r'onTap\s*:\s*\(\s*\)\s*=>\s*([A-Za-z_]\w*)\s*\(');
  final arrowMatch = arrowPattern.firstMatch(args);
  if (arrowMatch != null) {
    return arrowMatch.group(1);
  }

  // Pattern 2: Block function (closure with braces)
  // onTap: () { _methodName(...); }
  // Captures: _methodName
  final blockPattern =
      RegExp(r'onTap\s*:\s*\(\s*\)\s*\{\s*([A-Za-z_]\w*)\s*\(');
  final blockMatch = blockPattern.firstMatch(args);
  if (blockMatch != null) {
    return blockMatch.group(1);
  }

  // Pattern 3: Direct method reference
  // onTap: _methodName  (tear-off)
  // ต้อง follow ด้วย comma หรือ closing paren
  final directPattern = RegExp(r'onTap\s*:\s*([A-Za-z_]\w*)(?:\s*[,\)]|$)');
  final directMatch = directPattern.firstMatch(args);
  if (directMatch != null) {
    return directMatch.group(1);
  }

  return null; // ไม่พบ onTap หรือไม่ใช่ pattern ที่รองรับ
}

/// ============================================================================
/// BLOC/CUBIT WRAPPER DETECTION (UNUSED - Reserved for future)
/// ============================================================================

/// ตรวจหา BLoC wrapper widgets ที่ครอบ widget ที่ตำแหน่งนั้น
///
/// ใช้สำหรับ detect context ของ widget ว่าอยู่ใน BlocBuilder/BlocListener หรือไม่
///
/// [src] - source code ทั้งหมด
/// [pos] - ตำแหน่งของ widget ที่ต้องการตรวจ
///
/// Returns: List ของ wrapper types ที่พบ
///
/// หมายเหตุ: Function นี้ยังไม่ได้ใช้งานใน version ปัจจุบัน
/// @deprecated Reserved for future use
// ignore: unused_element
List<String> _detectWrappers(String src, int pos) {
  // ดูย้อนหลังไป 500 characters เพื่อหา wrapper
  final start = (pos - 500).clamp(0, src.length);
  final ctx = src.substring(start, pos);

  final w = <String>[];
  if (ctx.contains('BlocListener<')) w.add('BlocListener');
  if (ctx.contains('BlocBuilder<')) w.add('BlocBuilder');
  if (ctx.contains('BlocSelector<')) w.add('BlocSelector');
  return w;
}

/// ============================================================================
/// ACTION EXTRACTION (UNUSED - Reserved for future)
/// ============================================================================

/// Extract event handlers และ method calls จาก widget arguments
///
/// Scan หา event callbacks (onPressed, onChanged, onTap, etc.)
/// และ extract method calls ที่อยู่ใน callback
///
/// [type] - widget type (เช่น TextField, ElevatedButton)
/// [generics] - generic type parameters (เช่น <String>)
/// [args] - argument string ของ widget
/// [cubitType] - ชื่อ Cubit class สำหรับ resolve method targets
/// [fullSource] - source code ทั้งหมด สำหรับ lookup method bodies
///
/// Returns: List ของ action objects พร้อม event name และ method calls
///
/// ตัวอย่าง output:
/// ```json
/// [
///   {
///     "event": "onPressed",
///     "argType": "void",
///     "calls": [{"target": "CustomerCubit", "method": "submit"}]
///   }
/// ]
/// ```
///
/// หมายเหตุ: Function นี้ยังไม่ได้ใช้งานใน version ปัจจุบัน
/// @deprecated Reserved for future use
// ignore: unused_element
List<Map<String, dynamic>> _extractActions(
    String type, String? generics, String args,
    {String? cubitType, String? fullSource}) {
  // Event types ที่ต้องการ capture
  final events = <String>[
    'onPressed',
    'onChanged',
    'onTap',
    'onSubmitted',
    'onFieldSubmitted',
    'onSaved'
  ];
  final out = <Map<String, dynamic>>[];

  for (final e in events) {
    // หา event handler ใน arguments
    final m = RegExp('\\b$e\\s*:\\s*([^,]+)').firstMatch(args);
    if (m == null) continue;

    final expr = m.group(1)!.trim();

    // Extract method calls จาก expression
    final calls =
        _extractCalls(expr, cubitType: cubitType, fullSource: fullSource);

    // Guess argument type based on widget และ event type
    final argType = _guessArgType(type, generics, e);

    // Filter out internal FormField calls (formState.didChange)
    // เพราะเป็น internal calls ไม่ใช่ user-facing actions
    final meaningfulCalls = calls
        .where((call) =>
            call['target'] != 'formState' || call['method'] != 'didChange')
        .toList();

    // Skip actions ที่ไม่มี meaningful calls สำหรับ FormField
    if (meaningfulCalls.isEmpty && type == 'FormField') continue;

    out.add({
      'event': e,
      if (argType != null) 'argType': argType,
      'calls': meaningfulCalls,
    });
  }
  return out;
}

/// ============================================================================
/// METHOD CALL EXTRACTION
/// ============================================================================

/// Extract method calls จาก expression string
///
/// Analyze expression (เช่น event handler body) และหา method calls ทั้งหมด
/// รองรับ patterns หลายแบบ:
/// - Direct method call: object.method()
/// - Context.read pattern: context.read<Cubit>().method()
/// - Navigator pattern: Navigator.of(context).push()
/// - Ternary expressions: condition ? methodA() : methodB()
/// - Method reference (tear-off): _handleSubmit
///
/// [expr] - expression string ที่ต้องการ analyze
/// [cubitType] - ชื่อ Cubit class สำหรับ resolve _cubit references
/// [fullSource] - source code ทั้งหมด สำหรับ lookup method bodies (tear-off)
///
/// Returns: List ของ maps {target: '...', method: '...'}
///
/// ตัวอย่าง:
/// ```dart
/// final expr = "context.read<CustomerCubit>().submit()";
/// final calls = _extractCalls(expr, cubitType: 'CustomerCubit');
/// // [{'target': 'CustomerCubit', 'method': 'submit'}]
/// ```
List<Map<String, String>> _extractCalls(String expr,
    {String? cubitType, String? fullSource}) {
  final out = <Map<String, String>>[];
  final seen = <String>{}; // Deduplicate calls

  // Helper: เพิ่ม call ถ้ายังไม่เจอ
  void addCall(String target, String method) {
    final k = '$target::$method';
    if (seen.add(k)) out.add({'target': target, 'method': method});
  }

  // ----- Pattern 1: Ternary Expression -----
  // condition ? methodA() : methodB()
  // ต้อง handle ทั้ง true และ false branches
  final ternaryMatch = RegExp(r'([^?]+)\?([^:]+):(.+)').firstMatch(expr.trim());
  if (ternaryMatch != null && fullSource != null) {
    final trueBranch = ternaryMatch.group(2)!.trim();
    final falseBranch = ternaryMatch.group(3)!.trim();

    // Process false branch (ปกติเป็น method call, true branch เป็น null)
    if (falseBranch != 'null') {
      final nestedCalls = _extractCalls(falseBranch,
          cubitType: cubitType, fullSource: fullSource);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
    }

    // Process true branch ถ้าไม่ใช่ null
    if (trueBranch != 'null' && trueBranch != falseBranch) {
      final nestedCalls = _extractCalls(trueBranch,
          cubitType: cubitType, fullSource: fullSource);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
    }

    if (out.isNotEmpty) return out;
  }

  // ----- Pattern 2: Method Reference (Tear-off) -----
  // onPressed: _handleSubmit  (ไม่มี parentheses)
  // ต้องไปหา body ของ method แล้ว extract calls
  if (fullSource != null && RegExp(r'^[A-Za-z_]\w*$').hasMatch(expr.trim())) {
    final methodName = expr.trim();
    final methodBody = _findMethodBody(fullSource, methodName);
    if (methodBody != null) {
      // Recursive extract จาก method body
      // ส่ง fullSource: null เพื่อป้องกัน infinite recursion
      final nestedCalls =
          _extractCalls(methodBody, cubitType: cubitType, fullSource: null);
      for (final call in nestedCalls) {
        addCall(call['target']!, call['method']!);
      }
      return out;
    }
  }

  // ----- Pattern 3: Navigator Pattern -----
  // Navigator.of(context).pop() / push() / pushNamed() / etc.
  final navChain = RegExp(
      r'Navigator\.of\([^)]*\)\.(pop|maybePop|push(?:Named|Replacement|ReplacementNamed)?|pushAndRemoveUntil)\s*\(');
  final navM = navChain.firstMatch(expr);
  if (navM != null) {
    addCall('Navigator', navM.group(1)!);
  }

  // ----- Pattern 4: Property Access (Generic Method Call) -----
  // object.method() หรือ object.property.method()
  // ตัวอย่าง: _cubit.submit() / this._cubit.updateName()
  final m1 = RegExp(r'([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)\.([A-Za-z_]\w*)\s*\(')
      .allMatches(expr);
  for (final m in m1) {
    var target = m.group(1)!;
    final method = m.group(2)!;

    // Skip Navigator.of ถ้าจับ nav action ไปแล้ว
    if (target.startsWith('Navigator') && method == 'of') continue;

    // Resolve _cubit references เป็น actual Cubit type
    if (cubitType != null) {
      if (target == '_cubit' || target == 'this._cubit') target = cubitType;
    }
    addCall(target, method);
  }

  // ----- Pattern 5: Context.read Pattern -----
  // context.read<CustomerCubit>().submit()
  // context.of<CustomerCubit>().submit()
  final m2 =
      RegExp(r'context\.(?:read|of)<\s*(\w+)\s*>\(\)\.([A-Za-z_]\w*)\s*\(')
          .allMatches(expr);
  for (final m in m2) {
    final t = m.group(1)!;
    addCall(cubitType ?? t, m.group(2)!);
  }

  return out;
}

/// หา body ของ method จากชื่อ
///
/// ใช้สำหรับ resolve method references (tear-offs)
/// เมื่อ event handler เป็นแค่ชื่อ method ไม่มี call
///
/// [src] - source code ทั้งหมด
/// [methodName] - ชื่อ method ที่ต้องการหา
///
/// Returns: body ของ method (ไม่รวม braces), หรือ null ถ้าไม่พบ
///
/// ตัวอย่าง:
/// ```dart
/// final src = "void _handleSubmit() { _cubit.submit(); }";
/// final body = _findMethodBody(src, '_handleSubmit');
/// // body = " _cubit.submit(); "
/// ```
String? _findMethodBody(String src, String methodName) {
  // Pattern: returnType methodName(params) { body }
  // ตัวอย่าง: void _handleSubmit() { ... }
  // ตัวอย่าง: Future<void> _handleSubmit() async { ... }
  final methodPattern = RegExp(r'\b' + methodName + r'\s*\([^)]*\)\s*\{');
  final match = methodPattern.firstMatch(src);
  if (match == null) return null;

  // หา opening brace
  final openBrace = src.indexOf('{', match.start);
  if (openBrace == -1) return null;

  // หา matching closing brace
  final closeBrace = _matchBrace(src, openBrace);
  if (closeBrace == -1 || closeBrace <= openBrace) return null;

  // Return body ระหว่าง { และ }
  return src.substring(openBrace + 1, closeBrace);
}

/// ============================================================================
/// TEXT WIDGET EXTRACTION
/// ============================================================================

/// Extract text binding สำหรับ Text widget ที่ bind กับ state field
///
/// Pattern: Text(state.fieldName)
/// ใช้สำหรับ track ว่า Text widget แสดงค่าจาก state field ไหน
///
/// [args] - argument string ของ Text widget
/// [consts] - map ของ const declarations
///
/// Returns: Map {key, stateField} หรือ null ถ้าไม่ใช่ state binding
///
/// ตัวอย่าง:
/// ```dart
/// final args = "state.customerName, key: Key('display_name')";
/// final binding = _extractTextBinding(args);
/// // {'key': 'display_name', 'stateField': 'customerName'}
/// ```
Map<String, String>? _extractTextBinding(String args,
    {Map<String, String> consts = const {}}) {
  // Extract key ของ widget
  final key = _extractKey(args, consts: consts);

  // หา state.fieldName pattern
  final m = RegExp(r'\bstate\.(\w+)\b').firstMatch(args);

  // Return binding ถ้ามีทั้ง key และ state field
  if (key != null && m != null) {
    return {'key': key, 'stateField': m.group(1)!};
  }
  return null;
}

/// Extract text literal จาก Text widget arguments
///
/// ใช้สำหรับ capture static text content ของ Text widget
/// ไม่ capture string interpolations หรือ variable references
///
/// [args] - argument string ของ Text widget
///
/// Returns: Map {textLiteral: '...'} หรือ empty map ถ้าไม่พบ literal
///
/// ตัวอย่าง:
/// ```dart
/// // Static text
/// final args1 = "'Hello World', key: Key('greeting')";
/// _maybeTextLiteral(args1);  // {'textLiteral': 'Hello World'}
///
/// // Variable (ไม่ capture)
/// final args2 = "state.name, key: Key('name')";
/// _maybeTextLiteral(args2);  // {}
/// ```
Map<String, dynamic> _maybeTextLiteral(String args) {
  // Pattern 1: Text('literal') - first positional argument
  // Match string literal ที่อยู่ต้น args หรือหลัง comma/paren
  // ไม่จับ strings ที่เป็น named parameter values
  final m1 = RegExp(
          r"(?:^|[,(])\s*(?:const\s+)?(?:Text\s*\()?\s*'([^']+)'\s*(?:\)|,|$)")
      .firstMatch(args);
  if (m1 != null) {
    return {'textLiteral': m1.group(1)};
  }

  // Pattern 2: data: 'literal' (บาง widgets ใช้ data parameter)
  final m2 = RegExp(r"\bdata\s*:\s*'([^']+)'").firstMatch(args);
  if (m2 != null) return {'textLiteral': m2.group(1)};

  return const {}; // ไม่พบ literal text
}

/// ============================================================================
/// TYPE INFERENCE
/// ============================================================================

/// Guess argument type สำหรับ event callback
///
/// ใช้สำหรับ determine ว่า callback function รับ argument type อะไร
/// based on widget type และ event name
///
/// [type] - widget type (เช่น TextField, Radio)
/// [generics] - generic type parameters (เช่น <String>)
/// [event] - event name (เช่น onChanged, onPressed)
///
/// Returns: inferred type string หรือ null
///
/// ตัวอย่าง:
/// ```dart
/// _guessArgType('TextField', null, 'onChanged');  // 'String'
/// _guessArgType('Radio', '<bool>', 'onChanged');  // 'bool'
/// _guessArgType('ElevatedButton', null, 'onPressed');  // 'void'
/// ```
String? _guessArgType(String type, String? generics, String event) {
  // TextField/TextFormField: text-related events รับ String
  if (type == 'TextField' || type == 'TextFormField') {
    if (event == 'onChanged' ||
        event == 'onSubmitted' ||
        event == 'onFieldSubmitted') {
      return 'String';
    }
  }

  // Radio: ใช้ generic type parameter
  if (type == 'Radio') {
    final g = generics ?? '';
    final m = RegExp(r'<\s*([\w\.]+)\s*>').firstMatch(g);
    return m?.group(1) ?? 'dynamic';
  }

  // Button events: ไม่มี argument
  if (event == 'onPressed' || event == 'onTap') return 'void';

  return null;
}

/// ============================================================================
/// TEXTFIELD METADATA EXTRACTION
/// ============================================================================

/// Extract metadata เฉพาะสำหรับ TextField/TextFormField
///
/// รวมข้อมูล:
/// - keyboardType: ประเภท keyboard (email, number, phone, text)
/// - obscureText: ซ่อนข้อความ (password)
/// - maxLength: จำนวนตัวอักษรสูงสุด
/// - inputFormatters: รายการ formatters ที่ใช้
///
/// [args] - argument string ของ TextField
/// [regexVars] - map ของ RegExp variable declarations สำหรับ resolve
///
/// Returns: Map ของ metadata
///
/// ตัวอย่าง output:
/// ```json
/// {
///   "keyboardType": "emailAddress",
///   "maxLength": 50,
///   "inputFormatters": [
///     {"type": "allow", "pattern": "[a-zA-Z0-9@.]"}
///   ]
/// }
/// ```
Map<String, dynamic> _extractTextFieldMeta(String args,
    {Map<String, String> regexVars = const {}}) {
  final meta = <String, dynamic>{};

  // ----- keyboardType -----
  // Pattern: keyboardType: TextInputType.emailAddress
  // Values: emailAddress, number, phone, text, multiline, etc.
  final kt =
      RegExp(r'keyboardType\s*:\s*TextInputType\.(\w+)').firstMatch(args);
  if (kt != null) meta['keyboardType'] = kt.group(1);

  // ----- obscureText -----
  // Pattern: obscureText: true/false
  // ใช้สำหรับ password fields
  final ob = RegExp(r'obscureText\s*:\s*(true|false)').firstMatch(args);
  if (ob != null) meta['obscureText'] = ob.group(1) == 'true';

  // ----- maxLength -----
  // Pattern: maxLength: 50
  // จำกัดความยาว input
  final ml = RegExp(r'maxLength\s*:\s*(\d+)').firstMatch(args);
  if (ml != null) meta['maxLength'] = int.tryParse(ml.group(1)!);

  // ----- inputFormatters -----
  // List ของ TextInputFormatter objects
  final fm = <Map<String, dynamic>>[];

  // 1. FilteringTextInputFormatter.digitsOnly
  // อนุญาตเฉพาะตัวเลข
  if (RegExp(r'FilteringTextInputFormatter\s*\.\s*digitsOnly').hasMatch(args)) {
    fm.add({'type': 'digitsOnly'});
  }

  // 2. FilteringTextInputFormatter.singleLine
  // ไม่อนุญาต newlines
  if (RegExp(r'FilteringTextInputFormatter\s*\.\s*singleLine').hasMatch(args)) {
    fm.add({'type': 'singleLine'});
  }

  // 3. FilteringTextInputFormatter.allow(RegExp(...))
  // อนุญาตเฉพาะ characters ที่ match pattern
  // ตัวอย่าง: FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
  for (final m in RegExp(
          r"FilteringTextInputFormatter\s*\.\s*allow\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)")
      .allMatches(args)) {
    final inside = m.group(1) ?? '';
    // Extract pattern string (รองรับทั้ง raw และ normal strings)
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    final repl = m.group(2); // Optional replacement string
    if (pat.isNotEmpty) {
      fm.add({
        'type': 'allow',
        'pattern': pat,
        if (repl != null) 'replacement': repl
      });
    }
  }

  // 4. FilteringTextInputFormatter.deny(RegExp(...))
  // ไม่อนุญาต characters ที่ match pattern
  for (final m in RegExp(
          r"FilteringTextInputFormatter\s*\.\s*deny\s*\(\s*RegExp\(([^)]*)\)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*,?\s*\)")
      .allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    final repl = m.group(2);
    if (pat.isNotEmpty) {
      fm.add({
        'type': 'deny',
        'pattern': pat,
        if (repl != null) 'replacement': repl
      });
    }
  }

  // 5. allow/deny with variable reference
  // ตัวอย่าง: FilteringTextInputFormatter.allow(emailPattern)
  // ต้อง resolve variable จาก regexVars map
  for (final m in RegExp(
          r"FilteringTextInputFormatter\s*\.\s*(allow|deny)\s*\(\s*([A-Za-z_]\w*)\s*(?:,\s*replacementString\s*:\s*'([^']*)')?\s*\)")
      .allMatches(args)) {
    final kind = m.group(1)!; // 'allow' หรือ 'deny'
    final varName = m.group(2)!;
    final repl = m.group(3);
    // Resolve variable name เป็น pattern
    final pat = regexVars[varName];
    if (pat != null && pat.isNotEmpty) {
      fm.add({
        'type': kind,
        'pattern': pat,
        if (repl != null) 'replacement': repl
      });
    }
  }

  // 6. Legacy WhitelistingTextInputFormatter (deprecated)
  // เหมือน FilteringTextInputFormatter.allow
  for (final m
      in RegExp(r"WhitelistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)")
          .allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    if (pat.isNotEmpty) fm.add({'type': 'allowLegacy', 'pattern': pat});
  }

  // 7. Legacy BlacklistingTextInputFormatter (deprecated)
  // เหมือน FilteringTextInputFormatter.deny
  for (final m
      in RegExp(r"BlacklistingTextInputFormatter\s*\(\s*RegExp\(([^)]*)\)\s*\)")
          .allMatches(args)) {
    final inside = m.group(1) ?? '';
    final s1 = RegExp(r"r?'([^']*)'").firstMatch(inside);
    final s2 = s1 ?? RegExp(r'r?\"([^\"]*)\"').firstMatch(inside);
    final pat = (s2?.group(1)) ?? '';
    if (pat.isNotEmpty) fm.add({'type': 'denyLegacy', 'pattern': pat});
  }

  // 8. LengthLimitingTextInputFormatter(n)
  // จำกัดความยาวเหมือน maxLength
  for (final m in RegExp(r'LengthLimitingTextInputFormatter\s*\(\s*(\d+)\s*\)')
      .allMatches(args)) {
    fm.add({'type': 'lengthLimit', 'max': int.tryParse(m.group(1) ?? '')});
  }

  // 9. Custom formatters
  // ตัวอย่าง: ThousandsFormatter(), CurrencyFormatter(symbol: '\$')
  for (final m
      in RegExp(r'([A-Za-z_]\w*Formatter)\s*\(([^)]*)\)').allMatches(args)) {
    final name = m.group(1)!;
    final a = (m.group(2) ?? '').trim();

    // Skip built-in formatters ที่จัดการแล้ว
    if (name.contains('FilteringTextInputFormatter') ||
        name.contains('LengthLimitingTextInputFormatter')) continue;

    fm.add({'type': 'custom', 'name': name, if (a.isNotEmpty) 'args': a});
  }

  if (fm.isNotEmpty) meta['inputFormatters'] = fm;

  return meta;
}

/// ============================================================================
/// VALIDATION METADATA EXTRACTION
/// ============================================================================

/// Extract validation และ widget-specific metadata
///
/// Function นี้ extract ข้อมูลที่หลากหลายขึ้นอยู่กับ widget type:
///
/// สำหรับ form widgets (TextFormField, DropdownButtonFormField):
/// - validatorRules: validation rules พร้อม conditions และ messages
/// - autovalidateMode: validation trigger mode
///
/// สำหรับ DropdownButton:
/// - options: list ของ dropdown options {value, text}
///
/// สำหรับ Checkbox/Switch:
/// - valueBinding: expression ที่ bind กับ value
///
/// สำหรับ FormField (Radio groups):
/// - options: list ของ radio options
///
/// [widgetType] - ประเภทของ widget
/// [args] - argument string ของ widget
///
/// Returns: Map ของ metadata
///
/// ตัวอย่าง output:
/// ```json
/// {
///   "validatorRules": [
///     {"condition": "value.isEmpty", "message": "Required"}
///   ],
///   "autovalidateMode": "onUserInteraction"
/// }
/// ```
Map<String, dynamic> _extractValidationMeta(String widgetType, String args) {
  final meta = <String, dynamic>{};

  // ========== VALIDATOR EXTRACTION ==========
  // Extract validation rules จาก validator: parameter
  if (RegExp(r'\bvalidator\s*:').hasMatch(args)) {
    final idx = args.indexOf('validator');
    if (idx >= 0) {
      final tail = args.substring(idx);

      // ----- Extract Validator Body -----
      // หา body ของ validator function
      String body;
      final braceOpen = tail.indexOf('{');

      if (braceOpen >= 0) {
        // Block-style validator: validator: (value) { ... }
        final braceClose = _matchBrace(tail, braceOpen);
        body = tail.substring(braceOpen + 1, braceClose);
        //!TODO RECHECK NO NEED
        // if (braceClose > braceOpen) {
        //   body = tail.substring(braceOpen + 1, braceClose);
        // }
        // else {
        //   // Fallback: ใช้ heuristic หา end ของ validator
        //   final stop = RegExp(r",\s*\n\s*[A-Za-z_]\\w*\s*:").firstMatch(tail)?.start ??
        //       RegExp(r"\)[,\)]").firstMatch(tail)?.start ??
        //       (tail.length > 300 ? 300 : tail.length);
        //   body = tail.substring(0, stop);
        // }
      } else {
        // Arrow-style หรือ short form: validator: (v) => v.isEmpty ? 'Required' : null
        final stop =
            RegExp(r",\s*\n\s*[A-Za-z_]\\w*\s*:").firstMatch(tail)?.start ??
                RegExp(r"\)[,\)]").firstMatch(tail)?.start ??
                (tail.length > 300 ? 300 : tail.length);
        body = tail.substring(0, stop);
      }

      // ----- Collect All String Literals -----
      // รวบรวม string literals ทั้งหมดใน validator body
      // สำหรับใช้ pair กับ conditions
      final msgs = <String>{};
      for (final m in RegExp(r"'([^']+)'").allMatches(body)) {
        msgs.add(m.group(1)!);
      }
      for (final m in RegExp(r'"([^"]+)"').allMatches(body)) {
        msgs.add(m.group(1)!);
      }

      // ----- Extract Validation Rules -----
      // Pattern: if (condition) return 'message';
      final rules = <Map<String, String>>[];
      int pos = 0;

      // Scan หา if statements
      while (true) {
        final ifIdx = body.indexOf('if', pos);
        if (ifIdx < 0) break;

        // หา condition ภายใน if (...)
        final open = body.indexOf('(', ifIdx);
        if (open < 0) break;
        final close = _matchParen(body, open);
        if (close < 0) break;

        final cond = body.substring(open + 1, close).trim();

        // หา return statement หลัง if
        final after = body.substring(close + 1);
        final rm = RegExp("return\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\1\\s*;")
            .firstMatch(after);

        if (rm != null) {
          final msg = (rm.group(2) ?? '').trim();
          if (cond.isNotEmpty && msg.isNotEmpty) {
            rules.add({'condition': cond, 'message': msg});
          }
          pos = close + 1 + rm.end; // ข้ามไปหลัง return
        } else {
          pos = close + 1;
        }
      }

      // ----- Ternary Validator Pattern -----
      // Pattern: (condition) ? 'Message' : null
      for (final m in RegExp(
              "\\((.*?)\\)\\s*\\?\\s*(['\"])((?:\\\\.|[^\\\\])*?)\\2\\s*:\\s*null",
              dotAll: true)
          .allMatches(body)) {
        final cond = (m.group(1) ?? '').trim();
        final msg = (m.group(3) ?? '').trim();
        if (cond.isNotEmpty && msg.isNotEmpty) {
          rules.add({'condition': cond, 'message': msg});
        }
      }

      // ----- Fallback: Synthesize Rule from RegExp -----
      // ถ้าไม่เจอ rules แต่เจอ RegExp pattern และ message
      // สร้าง rule อัตโนมัติ
      if (rules.isEmpty) {
        final rxPat = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)")
            .firstMatch(body);
        final patternStr = rxPat?.group(2)?.trim();

        if (patternStr != null && patternStr.isNotEmpty) {
          // เลือก message ที่น่าจะเป็น user-facing
          // ไม่รวม 'Required' และ pattern string
          final candidates =
              msgs.where((m) => m != 'Required' && m != patternStr).toList();
          if (candidates.isNotEmpty) {
            rules.add({
              'condition': "!RegExp(r'$patternStr').hasMatch(value)",
              'message': candidates.first,
            });
          }
        }
      }

      if (rules.isNotEmpty) meta['validatorRules'] = rules;

      // ----- Secondary Synthesis -----
      // เพิ่ม rules สำหรับ messages ที่ยังไม่ได้ pair
      try {
        final rxPat2 = RegExp("RegExp\\(\\s*r?(['\\\"])((?:.|\\n)*?)\\1\\s*\\)")
            .firstMatch(body);
        final patternStr2 = rxPat2?.group(2)?.trim();

        if (patternStr2 != null && patternStr2.isNotEmpty) {
          // รวบรวม string literals อีกครั้ง
          final strMatches = <String>[];
          for (final m in RegExp("'([^']+)'", dotAll: true).allMatches(body)) {
            strMatches.add(m.group(1)!);
          }
          for (final m in RegExp('"([^"]+)"', dotAll: true).allMatches(body)) {
            strMatches.add(m.group(1)!);
          }

          // Filter เอา messages ที่น่าจะเป็น user-facing
          // ไม่รวม 'Required', pattern string, และ regex patterns
          final likelyMsgs = strMatches
              .where((s) =>
                      s != 'Required' &&
                      s != patternStr2 &&
                      !s.startsWith('^') && // ไม่ใช่ regex pattern
                      !s.startsWith('[') // ไม่ใช่ character class
                  )
              .toList();

          if (likelyMsgs.isNotEmpty) {
            // เพิ่ม messages ที่ยังไม่มีใน rules
            final messagesAlready = (meta['validatorRules'] as List?)
                    ?.map((e) => (e as Map)['message'] as String)
                    .toSet() ??
                <String>{};

            for (final lm in likelyMsgs) {
              if (!messagesAlready.contains(lm)) {
                (meta['validatorRules'] as List).add({
                  'condition': "!RegExp(r'$patternStr2').hasMatch(value)",
                  'message': lm
                });
                break;
              }
            }
          }
        }
      } catch (_) {
        // Ignore errors in secondary synthesis
      }
    }
  }

  // ========== AUTOVALIDATE MODE ==========
  // Pattern: autovalidateMode: AutovalidateMode.onUserInteraction
  final av = RegExp(r'autovalidateMode\s*:\s*AutovalidateMode\.(\w+)')
      .firstMatch(args);
  if (av != null) meta['autovalidateMode'] = av.group(1);

  // ========== DROPDOWN OPTIONS ==========
  // Extract DropdownMenuItem options
  if (widgetType == 'DropdownButton' ||
      widgetType == 'DropdownButtonFormField') {
    final optionEntries = <Map<String, String>>[];
    final itemRegex = RegExp(r'DropdownMenuItem\s*\(([^)]*)\)', dotAll: true);

    for (final match in itemRegex.allMatches(args)) {
      final inside = match.group(1) ?? '';

      // Extract value parameter
      String? value = RegExp(r"value\s*:\s*'([^']+)'\s*")
              .firstMatch(inside)
              ?.group(1) ??
          RegExp(r'value\s*:\s*"([^"]+)"\s*').firstMatch(inside)?.group(1) ??
          RegExp(r'value\s*:\s*([^,\)]+)').firstMatch(inside)?.group(1)?.trim();

      // Extract label จาก child: Text(...)
      String? label = RegExp(r"child\s*:\s*Text\(\s*'([^']+)'")
              .firstMatch(inside)
              ?.group(1) ??
          RegExp(r'child\s*:\s*Text\(\s*"([^"]+)"')
              .firstMatch(inside)
              ?.group(1);

      // สร้าง option entry
      final entry = <String, String>{};
      if (value != null && value.isNotEmpty) {
        entry['value'] = value.trim();
      }
      if (label != null && label.isNotEmpty) {
        entry['text'] = label.trim();
      } else if (value != null && value.isNotEmpty) {
        entry['text'] = value.trim(); // Fallback: ใช้ value เป็น text
      }

      if (entry.isNotEmpty) optionEntries.add(entry);
    }

    if (optionEntries.isNotEmpty) meta['options'] = optionEntries;
  }

  // ========== CHECKBOX/SWITCH VALUE BINDING ==========
  // Extract value binding expression
  if (widgetType == 'Checkbox' || widgetType == 'Switch') {
    final val = RegExp(r'\bvalue\s*:\s*([^,\)]+)').firstMatch(args);
    if (val != null) meta['valueBinding'] = val.group(1)!.trim();
  }

  // ========== FORMFIELD (RADIO GROUP) OPTIONS ==========
  // Extract Radio options จาก FormField builder
  if (widgetType == 'FormField') {
    final options = _collectRadioOptionMeta(args);
    if (options.isNotEmpty) meta['options'] = options;
  }

  // Note: Hints extraction disabled by request (do not emit meta.hints)
  return meta;
}

// Removed: _basename, _basenameWithoutExtension - now using utils.dart

/// ============================================================================
/// VARIABLE COLLECTION UTILITIES
/// ============================================================================

/// รวบรวม RegExp variable declarations จาก source code
///
/// ใช้สำหรับ resolve RegExp variables ที่ใช้ใน inputFormatters
/// เช่น: final emailPattern = RegExp(r'[a-zA-Z@.]');
///       FilteringTextInputFormatter.allow(emailPattern)
///
/// [src] - source code ทั้งหมด
///
/// Returns: Map {variableName: patternString}
///
/// ตัวอย่าง:
/// ```dart
/// final src = "final emailPattern = RegExp(r'[a-zA-Z@.]');";
/// final vars = _collectRegexVars(src);
/// // {'emailPattern': '[a-zA-Z@.]'}
/// ```
Map<String, String> _collectRegexVars(String src) {
  final out = <String, String>{};

  // Pattern 1: final/const/var name = RegExp(r'pattern');
  final rx1 = RegExp(
      r"(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?'([^']*)'\s*\)");
  for (final m in rx1.allMatches(src)) {
    out[m.group(1)!] = m.group(2)!;
  }

  // Pattern 2: final/const/var name = RegExp(r"pattern");
  final rx2 = RegExp(
      r'(?:final|const|var)\s+([A-Za-z_]\w*)\s*=\s*RegExp\(\s*r?"([^"]*)"\s*\)');
  for (final m in rx2.allMatches(src)) {
    out[m.group(1)!] = m.group(2)!;
  }

  return out;
}

/// รวบรวม const string declarations จาก source code
///
/// ใช้สำหรับ resolve string interpolation ใน widget keys
/// เช่น: const prefix = 'customer';
///       Key('${prefix}_name') → Key('customer_name')
///
/// [src] - source code ทั้งหมด
///
/// Returns: Map {constName: stringValue}
///
/// ตัวอย่าง:
/// ```dart
/// final src = "const prefix = 'customer';";
/// final consts = _collectStringConsts(src);
/// // {'prefix': 'customer'}
/// ```
Map<String, String> _collectStringConsts(String src) {
  final out = <String, String>{};

  // Pattern: const name = 'value';
  final rx = RegExp(r"const\s+(\w+)\s*=\s*'([^']*)'\s*;");
  for (final m in rx.allMatches(src)) {
    out[m.group(1)!] = m.group(2)!;
  }

  return out;
}

// Removed: _listFiles - now using utils.listFiles

/// ============================================================================
/// BLOC/CUBIT DETECTION
/// ============================================================================

/// หา Cubit class type จาก source code
///
/// Scan หา patterns ที่ใช้ Cubit:
/// - BlocBuilder<CustomerCubit, CustomerState>
/// - BlocListener<CustomerCubit, CustomerState>
/// - context.read<CustomerCubit>()
/// - BlocProvider.of<CustomerCubit>(context)
///
/// [src] - source code ของ page
///
/// Returns: ชื่อ Cubit class หรือ null
///
/// ตัวอย่าง:
/// ```dart
/// final src = "BlocBuilder<CustomerCubit, CustomerState>(...)";
/// final cubit = _findCubitType(src);  // 'CustomerCubit'
/// ```
String? _findCubitType(String src) {
  // ลอง patterns ทีละตัว คืนค่าแรกที่เจอ
  for (final rx in [
    RegExp(r'BlocBuilder<\s*(\w+Cubit)\s*,'), // BlocBuilder<XxxCubit,
    RegExp(r'BlocListener<\s*(\w+Cubit)\s*,'), // BlocListener<XxxCubit,
    RegExp(r'context\.(?:read|of)<\s*(\w+Cubit)\s*>'), // context.read<XxxCubit>
    RegExp(r'BlocProvider\.of<\s*(\w+Cubit)\s*>'), // BlocProvider.of<XxxCubit>
  ]) {
    final m = rx.firstMatch(src);
    if (m != null) return m.group(1);
  }
  return null;
}

/// หา State class type จาก source code
///
/// Scan หา State class จาก generic parameter ตัวที่สอง:
/// - BlocBuilder<CustomerCubit, CustomerState>
/// - BlocListener<CustomerCubit, CustomerState>
/// - BlocConsumer<CustomerCubit, CustomerState>
///
/// [src] - source code ของ page
///
/// Returns: ชื่อ State class หรือ null
///
/// ตัวอย่าง:
/// ```dart
/// final src = "BlocBuilder<CustomerCubit, CustomerState>(...)";
/// final state = _findStateType(src);  // 'CustomerState'
/// ```
String? _findStateType(String src) {
  // ลอง patterns ทีละตัว คืนค่าแรกที่เจอ
  for (final rx in [
    RegExp(
        r'BlocBuilder<\s*\w+Cubit\s*,\s*(\w+State)\s*>'), // BlocBuilder<, XxxState>
    RegExp(
        r'BlocListener<\s*\w+Cubit\s*,\s*(\w+State)\s*>'), // BlocListener<, XxxState>
    RegExp(
        r'BlocConsumer<\s*\w+Cubit\s*,\s*(\w+State)\s*>'), // BlocConsumer<, XxxState>
  ]) {
    final m = rx.firstMatch(src);
    if (m != null) return m.group(1);
  }
  return null;
}

/// หา page route constant (ยังไม่ได้ใช้งาน)
///
/// Pattern: static const route = '/path';
///
/// [src] - source code ของ page
///
/// Returns: route path หรือ null
///
/// @deprecated Reserved for future use
// ignore: unused_element
String? _findPageRoute(String src) {
  // Pattern: static const route = '/path';
  final m =
      RegExp(r"static\s+const\s+route\s*=\s*'([^']+)'\s*;").firstMatch(src);
  return m?.group(1);
}

/// ============================================================================
/// RADIO BUTTON EXTRACTION
/// ============================================================================

/// Extract metadata สำหรับ Radio widget
///
/// [args] - argument string ของ Radio widget
///
/// Returns: Map ที่อาจมี:
/// - valueExpr: expression สำหรับ value parameter
/// - groupValueBinding: expression สำหรับ groupValue parameter
///
/// ตัวอย่าง:
/// ```dart
/// final args = "value: Gender.male, groupValue: state.gender, onChanged: ...";
/// final meta = _extractRadioMeta(args);
/// // {'valueExpr': 'Gender.male', 'groupValueBinding': 'state.gender'}
/// ```
Map<String, dynamic> _extractRadioMeta(String args) {
  final meta = <String, dynamic>{};

  // Extract value parameter
  final v =
      RegExp(r'\bvalue\s*:\s*([^,\)]+)').firstMatch(args)?.group(1)?.trim();
  if (v != null) meta['valueExpr'] = v;

  // Extract groupValue parameter (binding กับ state)
  final gv = RegExp(r'\bgroupValue\s*:\s*([^,\)]+)')
      .firstMatch(args)
      ?.group(1)
      ?.trim();
  if (gv != null) meta['groupValueBinding'] = gv;

  return meta;
}

/// รวบรวม Radio options จาก FormField builder
///
/// Scan หา Radio widgets และ extract value/label pairs
/// ใช้สำหรับ FormField ที่มี Radio buttons หลายตัว
///
/// [args] - argument string ของ FormField
///
/// Returns: List ของ {value, text} pairs
///
/// ตัวอย่าง:
/// ```dart
/// // FormField ที่มี Radio options
/// final args = '''
///   Radio<Gender>(value: Gender.male, ...), Text('Male'),
///   Radio<Gender>(value: Gender.female, ...), Text('Female'),
/// ''';
/// final options = _collectRadioOptionMeta(args);
/// // [{'value': 'Gender.male', 'text': 'Male'}, {'value': 'Gender.female', 'text': 'Female'}]
/// ```
List<Map<String, String>> _collectRadioOptionMeta(String args) {
  final radios = <Map<String, String>>[];
  int index = 0;

  // Scan หา Radio widgets ทั้งหมด
  while (true) {
    // หา Radio<...> constructor
    final start = args.indexOf('Radio<', index);
    if (start == -1) break;

    // หา opening parenthesis
    final open = args.indexOf('(', start);
    if (open == -1) break;

    // หา matching closing parenthesis
    final close = _matchParen(args, open);
    if (close == -1) break;

    // Extract Radio arguments
    final segment = args.substring(open + 1, close);

    // Helper function สำหรับ extract pattern
    String? extract(String pattern) {
      final m = RegExp(pattern, dotAll: true).firstMatch(segment);
      return m?.group(1)?.trim();
    }

    // Extract value parameter จาก Radio
    final value = extract(r'value\s*:\s*([^,\)]+)');

    // หา Text widget ที่ตามหลัง Radio (เป็น label)
    final following = args.substring(close);
    final labelMatch =
        RegExp(r"Text\(\s*'([^']+)'\s*\)").firstMatch(following) ??
            RegExp(r'Text\(\s*"([^"]+)"\s*\)').firstMatch(following);
    final label = labelMatch?.group(1)?.trim();

    // Only add entry if we have both value and text (same structure as Dropdown)
    if (value != null &&
        value.trim().isNotEmpty &&
        label != null &&
        label.isNotEmpty) {
      final entry = <String, String>{};
      entry['value'] = value.replaceAll(',', '').trim();
      entry['text'] =
          label; // Use 'text' instead of 'label' to match Dropdown structure
      radios.add(entry);
    }

    index = close + 1;
  }

  return radios;
}

/// ============================================================================
/// WIDGET ORDERING
/// ============================================================================

/// Extract SEQUENCE number จาก key name
///
/// Key naming convention: {SEQUENCE}_{ENTITY}_{FIELD}_{WIDGET}
/// SEQUENCE เป็นตัวเลขที่อยู่หน้าสุด ใช้สำหรับเรียงลำดับ widgets
///
/// [key] - widget key string
///
/// Returns: SEQUENCE number หรือ null ถ้าไม่มี
///
/// ตัวอย่าง:
/// ```dart
/// _extractSequence("1_customer_firstname_textfield")  // 1
/// _extractSequence("10_customer_title_dropdown")      // 10
/// _extractSequence("customer_age_radio")              // null (ไม่มี sequence)
/// ```
int? _extractSequence(String key) {
  // Pattern: ตัวเลข followed by underscore ที่ต้นของ key
  final match = RegExp(r'^(\d+)_').firstMatch(key);
  if (match != null) {
    return int.tryParse(match.group(1)!);
  }
  return null;
}

/// ============================================================================
/// FILE PATH RESOLUTION
/// ============================================================================

/// หา file path ของ Cubit class จาก import statements
///
/// วิธีการ:
/// 1. แปลง CubitClass → snake_case filename (CustomerCubit → customer_cubit)
/// 2. หา import statement ที่ match
/// 3. ถ้าไม่เจอ ใช้ default structure: lib/cubit/{filename}.dart
///
/// [src] - source code ของ page
/// [cubitType] - ชื่อ Cubit class
///
/// Returns: relative path เช่น 'lib/cubit/customer_cubit.dart'
///
/// ตัวอย่าง:
/// ```dart
/// // source มี: import 'package:myapp/cubit/customer_cubit.dart';
/// _findCubitFilePath(src, 'CustomerCubit');
/// // → 'lib/cubit/customer_cubit.dart'
/// ```
String? _findCubitFilePath(String src, String? cubitType) {
  if (cubitType == null) return null;

  // แปลง CamelCase → snake_case
  // CustomerCubit → customer_cubit
  final fileName = utils.camelToSnake(cubitType);

  // หา import statement ที่ match
  // Pattern: import 'package:PROJECT_NAME/path/to/cubit_file.dart';
  final importPattern =
      RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
  final match = importPattern.firstMatch(src);
  if (match != null) {
    return 'lib/${match.group(1)}';
  }

  // Fallback: ใช้ default structure
  return 'lib/cubit/$fileName.dart';
}

/// หา file path ของ State class จาก import statements
///
/// วิธีการ:
/// 1. แปลง StateClass → snake_case filename (CustomerState → customer_state)
/// 2. หา import statement ที่ match
/// 3. ถ้าไม่เจอ ใช้ default structure: lib/cubit/{filename}.dart
///
/// [src] - source code ของ page
/// [stateType] - ชื่อ State class
///
/// Returns: relative path เช่น 'lib/cubit/customer_state.dart'
///
/// ตัวอย่าง:
/// ```dart
/// // source มี: import 'package:myapp/cubit/customer_state.dart';
/// _findStateFilePath(src, 'CustomerState');
/// // → 'lib/cubit/customer_state.dart'
/// ```
String? _findStateFilePath(String src, String? stateType) {
  if (stateType == null) return null;

  // แปลง CamelCase → snake_case
  // CustomerState → customer_state
  final fileName = utils.camelToSnake(stateType);

  // หา import statement ที่ match
  final importPattern =
      RegExp("import\\s+['\"]package:[^/]+/(.+?/$fileName\\.dart)['\"]");
  final match = importPattern.firstMatch(src);
  if (match != null) {
    return 'lib/${match.group(1)}';
  }

  // Fallback: ใช้ default structure
  return 'lib/cubit/$fileName.dart';
}

// Removed: _camelToSnake - now using utils.camelToSnake

/// ============================================================================
/// DATE/TIME PICKER SCANNING
/// ============================================================================

/// Scan หา showDatePicker และ showTimePicker calls ใน source code
///
/// เชื่อม picker calls กับ method names เพื่อ link กลับไปที่ TextField.onTap
///
/// [src] - source code ทั้งหมด (รวม comments ด้วยเพราะต้องหา method bodies)
///
/// Returns: Map {methodName: pickerMetadata}
///
/// ตัวอย่าง output:
/// ```dart
/// {
///   '_selectBirthDate': {
///     'type': 'DatePicker',
///     'firstDate': 'DateTime(1900)',
///     'lastDate': 'DateTime.now()',
///     'initialDate': 'DateTime.now()'
///   }
/// }
/// ```
Map<String, Map<String, dynamic>> _scanDateTimePickers(String src) {
  final pickers = <String, Map<String, dynamic>>{};

  // ===== SCAN FOR showDatePicker =====
  // ใช้ proper parenthesis matching เพื่อ extract full argument list
  int i = 0;
  while (i < src.length) {
    // หา showDatePicker(
    final match = RegExp(r'showDatePicker\s*\(').matchAsPrefix(src, i);
    if (match != null) {
      final openParen = match.end - 1; // ตำแหน่งของ '('
      final closeParen = _matchParen(src, openParen); // หา matching ')'

      if (closeParen > openParen) {
        // Extract arguments
        final args = src.substring(openParen + 1, closeParen);

        // Parse parameters
        final params = _extractDatePickerParams(args);

        // หา method ที่ครอบ showDatePicker call
        final methodName = _findContainingMethod(src, match.start);

        // เก็บ metadata ถ้ามี params
        if (methodName != null && params.isNotEmpty) {
          pickers[methodName] = {
            'type': 'DatePicker',
            ...params, // spread firstDate, lastDate, initialDate
          };
        }
      }
      i = match.end;
    } else {
      i++;
    }
  }

  // ===== SCAN FOR showTimePicker =====
  // เหมือน showDatePicker
  i = 0;
  while (i < src.length) {
    // หา showTimePicker(
    final match = RegExp(r'showTimePicker\s*\(').matchAsPrefix(src, i);
    if (match != null) {
      final openParen = match.end - 1;
      final closeParen = _matchParen(src, openParen);

      if (closeParen > openParen) {
        final args = src.substring(openParen + 1, closeParen);
        final params = _extractTimePickerParams(args);
        final methodName = _findContainingMethod(src, match.start);

        if (methodName != null && params.isNotEmpty) {
          pickers[methodName] = {
            'type': 'TimePicker',
            ...params, // spread initialTime
          };
        }
      }
      i = match.end;
    } else {
      i++;
    }
  }

  return pickers;
}

/// หาชื่อ method ที่ครอบตำแหน่งที่กำหนดใน source code
///
/// ใช้สำหรับ link showDatePicker/showTimePicker calls กลับไปที่ method ที่เรียก
///
/// [src] - source code ทั้งหมด
/// [pos] - ตำแหน่งที่ต้องการหา containing method
///
/// Returns: ชื่อ method หรือ null
///
/// ตัวอย่าง:
/// ```dart
/// // source:
/// Future<void> _selectBirthDate(BuildContext context) async {
///   final date = await showDatePicker(...);  // ← pos อยู่ตรงนี้
/// }
///
/// _findContainingMethod(src, posOfShowDatePicker);  // '_selectBirthDate'
/// ```
String? _findContainingMethod(String src, int pos) {
  // ดูย้อนหลังจาก pos เพื่อหา method declaration
  final beforePos = src.substring(0, pos);

  // Pattern: Future<void> methodName(...) async { ... }
  // หรือ: void methodName(...) { ... }
  // Capture: methodName
  final methodPattern = RegExp(
      r'(?:Future<[^>]+>|void|[A-Z]\w*)\s+([A-Za-z_]\w*)\s*\([^)]*\)\s*(?:async\s*)?\{[^}]*$');
  final match = methodPattern.firstMatch(beforePos);
  if (match != null) {
    return match.group(1);
  }

  return null;
}

/// ============================================================================
/// DATE PICKER PARAMETER EXTRACTION
/// ============================================================================

/// Extract parameters จาก showDatePicker arguments
///
/// รองรับ patterns หลายแบบ:
/// - firstDate: DateTime(1900) หรือ DateTime.now()
/// - lastDate: DateTime(2100), DateTime.now(), DateTime.now().add(Duration(...))
/// - initialDate: expression ใดๆ
///
/// [args] - argument string ของ showDatePicker
///
/// Returns: Map ของ parameters
///
/// ตัวอย่าง output:
/// ```dart
/// {
///   'firstDate': 'DateTime(1900)',
///   'lastDate': 'DateTime.now()',
///   'initialDate': 'DateTime.now()'
/// }
/// ```
Map<String, dynamic> _extractDatePickerParams(String args) {
  final params = <String, dynamic>{};

  // ----- Extract firstDate -----
  // รองรับ: DateTime.now() หรือ DateTime(year, month, day)
  final firstDateNow =
      RegExp(r'firstDate\s*:\s*DateTime\.now\(\)').firstMatch(args);
  if (firstDateNow != null) {
    params['firstDate'] = 'DateTime.now()';
  } else {
    final firstDateMatch =
        RegExp(r'firstDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
    if (firstDateMatch != null) {
      final dateArgs = firstDateMatch.group(1)!.trim();
      params['firstDate'] = _parseDateTimeArgs(dateArgs);
    }
  }

  // ----- Extract lastDate -----
  // รองรับ: DateTime.now(), DateTime.now().add(...), DateTime(...)
  final lastDateNow =
      RegExp(r'lastDate\s*:\s*DateTime\.now\(\)(?!\.)').firstMatch(args);
  if (lastDateNow != null) {
    params['lastDate'] = 'DateTime.now()';
  } else {
    // Pattern: DateTime.now().add(const Duration(days: N))
    final lastDateExpr = RegExp(
            r'lastDate\s*:\s*DateTime\.now\(\)\.add\(const Duration\(days:\s*(\d+)\)\)')
        .firstMatch(args);
    if (lastDateExpr != null) {
      params['lastDate'] =
          'DateTime.now().add(Duration(days: ${lastDateExpr.group(1)}))';
    } else {
      // Pattern: DateTime(year, month, day)
      final lastDateLiteral =
          RegExp(r'lastDate\s*:\s*DateTime\(([^)]+)\)').firstMatch(args);
      if (lastDateLiteral != null) {
        final dateArgs = lastDateLiteral.group(1)!.trim();
        params['lastDate'] = _parseDateTimeArgs(dateArgs);
      }
    }
  }

  // ----- Extract initialDate -----
  // ใช้ parenthesis matching เพื่อ handle expressions ที่ซับซ้อน
  final initialDateStart = RegExp(r'initialDate\s*:\s*').firstMatch(args);
  if (initialDateStart != null) {
    final startPos = initialDateStart.end;

    // หา end ของ expression (comma หรือ end of args)
    int endPos = startPos;
    int parenDepth = 0;
    bool inString = false;

    while (endPos < args.length) {
      final char = args[endPos];

      if (char == "'" || char == '"') {
        inString = !inString;
      } else if (!inString) {
        if (char == '(') {
          parenDepth++;
        } else if (char == ')') {
          parenDepth--;
        } else if (char == ',' && parenDepth == 0) {
          break;
        }
      }

      endPos++;
    }

    params['initialDate'] = args.substring(startPos, endPos).trim();
  }

  return params;
}

/// ============================================================================
/// TIME PICKER PARAMETER EXTRACTION
/// ============================================================================

/// Extract parameters จาก showTimePicker arguments
///
/// รองรับ initialTime parameter
///
/// [args] - argument string ของ showTimePicker
///
/// Returns: Map ของ parameters
///
/// ตัวอย่าง output:
/// ```dart
/// {
///   'initialTime': 'TimeOfDay.now()'
/// }
/// ```
Map<String, dynamic> _extractTimePickerParams(String args) {
  final params = <String, dynamic>{};

  // ----- Extract initialTime -----
  // ใช้ parenthesis matching เพื่อ handle expressions ที่ซับซ้อน
  final initialTimeStart = RegExp(r'initialTime\s*:\s*').firstMatch(args);
  if (initialTimeStart != null) {
    final startPos = initialTimeStart.end;
    int endPos = startPos;
    int parenDepth = 0;
    bool inString = false;

    while (endPos < args.length) {
      final char = args[endPos];

      if (char == "'" || char == '"') {
        inString = !inString;
      } else if (!inString) {
        if (char == '(') {
          parenDepth++;
        } else if (char == ')') {
          parenDepth--;
        } else if (char == ',' && parenDepth == 0) {
          break;
        }
      }

      endPos++;
    }

    params['initialTime'] = args.substring(startPos, endPos).trim();
  }

  return params;
}

/// ============================================================================
/// DATETIME PARSING
/// ============================================================================

/// Parse DateTime constructor arguments เป็น readable format
///
/// แปลง arguments ของ DateTime constructor เป็น string ที่อ่านง่าย
///
/// [args] - comma-separated arguments
///
/// Returns: formatted DateTime string
///
/// ตัวอย่าง:
/// ```dart
/// _parseDateTimeArgs("1900");           // 'DateTime(1900)'
/// _parseDateTimeArgs("2024, 1");        // 'DateTime(2024, 1)'
/// _parseDateTimeArgs("2024, 1, 15");    // 'DateTime(2024, 1, 15)'
/// ```
String _parseDateTimeArgs(String args) {
  // แยก arguments ด้วย comma
  final parts = args.split(',').map((e) => e.trim()).toList();

  if (parts.length == 1) {
    // DateTime(year) - year only
    return 'DateTime(${parts[0]})';
  } else if (parts.length == 2) {
    // DateTime(year, month)
    return 'DateTime(${parts[0]}, ${parts[1]})';
  } else if (parts.length >= 3) {
    // DateTime(year, month, day)
    return 'DateTime(${parts[0]}, ${parts[1]}, ${parts[2]})';
  }

  // Fallback: คืน original
  return 'DateTime($args)';
}
