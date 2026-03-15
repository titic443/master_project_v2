// =============================================================================
// generate_test_data.dart
// =============================================================================
// Script สำหรับสร้าง test plan (test data) จาก UI manifest
// ใช้ Pairwise Combinatorial Testing เพื่อสร้าง test cases ที่ครอบคลุม
// แต่ลดจำนวน test cases ให้น้อยลงด้วยเทคนิค pairwise
//
// วิธีใช้งาน:
//   1. ประมวลผลไฟล์ manifest เฉพาะ:
//      dart run tools/script_v2/generate_test_data.dart output/manifest/demos/login_page.manifest.json
//
//   2. ประมวลผลทุกไฟล์ manifest ใน output/manifest/:
//      dart run tools/script_v2/generate_test_data.dart
//
// Input:
//   - output/manifest/<subfolder>/<page>.manifest.json (จาก extract_ui_manifest.dart)
//   - output/test_data/<page>.datasets.json (optional, จาก generate_datasets.dart)
//
// Output:
//   - output/test_data/<page>.testdata.json (test plan สำหรับ generate_test_script.dart)
//   - output/model_pairwise/<page>.full.model.txt (PICT model file)
//   - output/model_pairwise/<page>.full.result.txt (PICT combinations result)
//   - output/model_pairwise/<page>.valid.model.txt (PICT model for valid-only)
//   - output/model_pairwise/<page>.valid.result.txt (PICT valid combinations)
//
// Features:
//   - สร้าง pairwise test combinations ด้วย PICT tool
//   - รองรับ TextFormField, Radio, Checkbox, Dropdown, Switch
//   - รองรับ DatePicker และ TimePicker widgets
//   - สร้าง edge cases (empty fields test)
//   - ตรวจจับ validation rules และ required fields
//   - รองรับ external datasets จาก AI generation
// =============================================================================

// -----------------------------------------------------------------------------
// Import Libraries
// -----------------------------------------------------------------------------

// dart:convert - สำหรับ JSON encoding/decoding
// - jsonDecode()      : แปลง JSON string เป็น Map/List
// - JsonEncoder       : แปลง Map/List เป็น JSON string (with formatting)
import 'dart:convert';

// dart:io - สำหรับ file I/O และ process operations
// - File             : อ่าน/เขียนไฟล์
// - Directory        : จัดการ folders และ scan files
// - stdout/stderr    : เขียน output/error messages
// - exit()           : จบ process พร้อม exit code
import 'dart:io';

// generator_pict.dart - module สำหรับ PICT (Pairwise Independent Combinatorial Testing)
// - GeneratorPict class     : class หลักสำหรับ PICT operations
// - executePict()           : รัน PICT binary เพื่อสร้าง combinations
// - generatePairwiseInternal(): สร้าง pairwise combinations แบบ internal (ไม่ใช้ PICT)
// - parsePictModel()        : parse PICT model file เพื่อดึง factors
// - parsePictResult()       : parse PICT result file เพื่อดึง combinations
// - extractFactorsFromManifest(): ดึง factors จาก manifest widgets
// - writePictModelFiles()   : เขียน PICT model และ result files
import 'generator_pict.dart' as pict;

// utils.dart - utility functions ที่ใช้ร่วมกับ scripts อื่น
// - basenameWithoutExtension() : ดึงชื่อไฟล์โดยไม่มี extension
// - basename()                 : ดึงชื่อไฟล์
import 'utils.dart' as utils;

// =============================================================================
// BACKWARD-COMPATIBLE TOP-LEVEL FUNCTION
// =============================================================================

/// Backward-compatible wrapper — delegates to [TestDataGenerator].
Future<String> generateTestDataFromManifest(
  String manifestPath, {
  String pictBin = './pict',
  String? constraints,
}) =>
    TestDataGenerator(pictBin: pictBin)
        .generateTestData(manifestPath, constraints: constraints);

// =============================================================================
// TestDataGenerator CLASS
// =============================================================================

class TestDataGenerator {
  final String pictBin;
  const TestDataGenerator({this.pictBin = './pict'});

  /// สร้าง test data (test plan) จาก manifest file โดยใช้ pairwise testing
  ///
  /// Returns: path ของ test data file ที่สร้าง
  Future<String> generateTestData(String manifestPath,
      {String? constraints}) async {
    stderr.writeln('[DEBUG] generateTestData - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}');
    final raw = File(manifestPath).readAsStringSync();
    final j = jsonDecode(raw) as Map<String, dynamic>;
    final source = (j['source'] as Map<String, dynamic>?) ?? const {};
    final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

    await _processOne(
      manifestPath,
      pairwiseUsePict: true,
      pictBin: pictBin,
      constraints: constraints,
    );

    return 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';
  }

  // =========================================================================
  // PROCESS ONE FILE - ฟังก์ชันหลักในการประมวลผล
  // =========================================================================

  /// ประมวลผล manifest file หนึ่งไฟล์และสร้าง test data
  ///
  /// Parameters:
  ///   [path]           - path ของไฟล์ .manifest.json
  ///   [pairwiseUsePict]- ใช้ PICT tool (default: false)
  ///   [pictBin]        - path ของ PICT binary
  ///   [constraints]    - PICT constraints string (optional)
  ///
  /// การทำงานหลัก:
  ///   1. อ่านและ parse manifest JSON
  ///   2. สร้าง PICT model จาก widgets
  ///   3. โหลด external datasets (ถ้ามี)
  ///   4. ระบุ widget types (textfield, radio, checkbox, etc.)
  ///   5. สร้าง pairwise test combinations
  ///   6. สร้าง edge cases (empty fields)
  ///   7. เขียน test data file
  Future<void> _processOne(String path,
      {bool pairwiseUsePict = false,
      String pictBin = './pict',
      String? constraints}) async {
    // ---------------------------------------------------------------------------
    // สร้าง GeneratorPict instance สำหรับใช้ตลอด function นี้
    // ---------------------------------------------------------------------------
    final pictGen = pict.GeneratorPict(pictBin: pictBin);

    // ---------------------------------------------------------------------------
    // STEP 1: อ่านและ parse manifest file
    // ---------------------------------------------------------------------------

    // อ่านเนื้อหา manifest ทั้งไฟล์เป็น string
    final raw = File(path).readAsStringSync();

    // แปลง JSON string เป็น Map
    final j = jsonDecode(raw) as Map<String, dynamic>;

    // ดึง source section จาก manifest
    final source = (j['source'] as Map<String, dynamic>?) ?? const {};

    // ดึง path ของ UI file
    final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

    // ---------------------------------------------------------------------------
    // STEP 2: สร้าง PICT model จาก manifest
    // ---------------------------------------------------------------------------

    // พยายามสร้าง PICT model files เพื่อใช้ในการ generate combinations
    stderr.writeln('[DEBUG] _processOne - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}');
    try {
      await _tryWritePictModelFromManifestForUi(uiFile,
          pictBin: pictBin, constraints: constraints);
    } catch (e) {
      stderr.writeln('! Failed to write PICT model from manifest: $e');
    }

    // ดึง list ของ widgets จาก manifest
    final widgets =
        (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    // ---------------------------------------------------------------------------
    // STEP 3: โหลด external datasets (ถ้ามี)
    // ---------------------------------------------------------------------------

    /// Helper function: รักษา format ของ datasets (ไม่ต้อง convert)
    /// Format ใหม่: {"key": [{"valid": "value1", "invalid": "value2", "invalidRuleMessages": "msg"}]}
    Map<String, dynamic> _convertDatasetsToOldFormat(
        Map<String, dynamic> byKey) {
      // Return as-is เพื่อรักษา array of objects format
      return Map<String, dynamic>.from(byKey);
    }

    // สร้างโครงสร้าง datasets พื้นฐาน
    final datasets = {
      'defaults': <String, dynamic>{}, // ค่า default ของแต่ละ field
      'byKey': <String, dynamic>{}, // ค่าตาม widget key
    };

    // พยายามโหลด external datasets จาก .datasets.json
    // ไฟล์นี้ถูกสร้างโดย generate_datasets.dart (AI-based)
    try {
      // สร้าง path ของ datasets file
      final extPath =
          'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
      final f = File(extPath);

      // ตรวจสอบว่าไฟล์มีอยู่หรือไม่
      if (f.existsSync()) {
        // อ่านและ parse JSON
        final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

        // ดึง datasets.byKey
        final extDatasets = (ext['datasets'] as Map?)?.cast<String, dynamic>();
        final extByKey =
            (extDatasets?['byKey'] as Map?)?.cast<String, dynamic>();

        // ถ้ามี byKey ให้ merge เข้า datasets
        if (extByKey != null) {
          final converted = _convertDatasetsToOldFormat(extByKey);
          (datasets['byKey'] as Map<String, dynamic>).addAll(converted);
        }
      }
    } catch (_) {
      // ignore errors - จะใช้ datasets เปล่าแทน
    }

    // ---------------------------------------------------------------------------
    // STEP 3b: Apply Format A dataset overrides from constraints file
    // ---------------------------------------------------------------------------
    // Format A lines: key = value         → override 'valid' slot
    //                 key.slot = value    → override specific slot (valid/invalid/atMin/atMax)
    // These lines are filtered OUT of the PICT model — they only affect datasets here.
    if (constraints != null && constraints.trim().isNotEmpty) {
      final byKey = datasets['byKey'] as Map<String, dynamic>;

      for (final rawLine in constraints.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty || line.startsWith('#')) continue;
        // Skip Format B lines (passed to PICT separately)
        if (line.toUpperCase().contains('IF') && line.toUpperCase().contains('THEN')) continue;

        // Parse: key[.slot] = value
        final eqIdx = line.indexOf('=');
        if (eqIdx <= 0) continue;

        final lhs = line.substring(0, eqIdx).trim();   // e.g. "key.invalid"
        final rhs = line.substring(eqIdx + 1).trim();  // e.g. "ส"

        final dotIdx = lhs.indexOf('.');
        final key  = dotIdx > 0 ? lhs.substring(0, dotIdx) : lhs;
        final slot = dotIdx > 0 ? lhs.substring(dotIdx + 1) : 'valid';

        // Ensure entry exists as List<Map>
        if (!byKey.containsKey(key)) {
          byKey[key] = [<String, dynamic>{}];
        }
        final entry = byKey[key] as List;
        if (entry.isEmpty) entry.add(<String, dynamic>{});
        final map = Map<String, dynamic>.from(entry[0] as Map? ?? {});
        map[slot] = rhs;
        entry[0] = map;
        byKey[key] = entry;

        stderr.writeln('[DEBUG] Format A override: $key.$slot = "$rhs"');
      }
    }

    // ---------------------------------------------------------------------------
    // STEP 4: Helper Functions สำหรับวิเคราะห์ widget keys
    // ---------------------------------------------------------------------------

    /// ดึง sequence number จาก widget key
    ///
    /// Pattern: <page_prefix>_<sequence>_<description>_<widget_type>
    /// Example: customer_07_end_button → 07
    ///
    /// Returns: sequence number หรือ -1 ถ้าไม่พบ
    int _extractSequence(String key) {
      // Return -1 ถ้า key ว่าง
      if (key.isEmpty) return -1;

      // แยก key เป็น parts ด้วย underscore
      final parts = key.split('_');
      if (parts.length < 2) return -1;

      // ลองดึง sequence จาก part ที่ 2 ก่อน (pattern ที่พบบ่อยที่สุด)
      // customer_07_end_button → ['customer', '07', 'end', 'button']
      final secondPart = parts[1];
      final seq = int.tryParse(secondPart);
      if (seq != null) return seq;

      // Fallback: scan ทุก parts หา number
      for (final part in parts) {
        final num = int.tryParse(part);
        if (num != null) return num;
      }

      return -1; // ไม่พบ sequence
    }

    /// หา Button widget ที่มี sequence number สูงสุด
    /// Button นี้จะถูกใช้เป็น end/submit button
    ///
    /// Returns: widget key ของ button หรือ null ถ้าไม่พบ
    String? _findHighestSequenceButton(List<Map<String, dynamic>> widgets) {
      String? highestKey; // key ของ button ที่มี sequence สูงสุด
      int highestSeq = -1; // sequence สูงสุดที่พบ

      // วนลูปทุก widgets
      for (final w in widgets) {
        final t = (w['widgetType'] ?? '').toString(); // widget type
        final k = (w['key'] ?? '').toString(); // widget key

        // พิจารณาเฉพาะ Button types
        if ((t == 'ElevatedButton' ||
                t == 'TextButton' ||
                t == 'OutlinedButton') &&
            k.isNotEmpty) {
          final seq = _extractSequence(k);
          // อัพเดทถ้าพบ sequence ที่สูงกว่า
          if (seq > highestSeq) {
            highestSeq = seq;
            highestKey = k;
          }
        }
      }

      return highestKey;
    }

    // ---------------------------------------------------------------------------
    // STEP 5: หา End Button และ Expected Keys
    // ---------------------------------------------------------------------------

    // หา end key โดยหา button ที่มี sequence สูงสุด
    // End button คือปุ่มสุดท้ายที่ผู้ใช้กดเพื่อ submit form
    String? endKey = _findHighestSequenceButton(widgets);

    // รวบรวม expected keys สำหรับ success และ fail cases
    // ใช้ Set เพื่อป้องกัน duplicates (SnackBar อาจปรากฏหลายครั้งใน manifest)
    final expectedSuccessKeys =
        <String>{}; // keys สำหรับ success (เช่น snackbar success)
    final expectedFailKeys =
        <String>{}; // keys สำหรับ fail (เช่น error message)
    // Dialog keys ที่ต้อง dismiss หลัง assert
    final dialogKeys = <String>{};

    // Widget types ที่ถือว่าเป็น dialog
    const dialogWidgetTypes = {'AlertDialog', 'SimpleDialog'};

    // ---------------------------------------------------------------------------
    // STEP 6: ระบุและจัดหมวดหมู่ Widget Keys
    // ---------------------------------------------------------------------------

    // Lists เก็บ keys แยกตาม widget type
    final textKeys = <String>[]; // TextFormField, TextField keys
    final radioKeys = <String>[]; // Radio button keys
    final checkboxKeys = <String>[]; // Checkbox keys
    final switchKeys = <String>[]; // Switch, SwitchListTile keys
    final primaryButtons = <String>[]; // ปุ่มอื่นๆ ที่ไม่ใช่ end button
    final datePickerKeys = <String>[]; // DatePicker keys
    final timePickerKeys = <String>[]; // TimePicker keys

    // วนลูปครั้งแรก: หา expected keys
    for (final w in widgets) {
      final k = (w['key'] ?? '').toString();
      final t = (w['widgetType'] ?? '').toString();
      final isDialog = dialogWidgetTypes.contains(t);

      // เก็บ keys ที่มี _expected_success หรือ _dialog_success
      if (k.contains('_expected_success') || k.contains('_dialog_success')) {
        expectedSuccessKeys.add(k);
        if (isDialog) dialogKeys.add(k);
      }
      // เก็บ keys ที่มี _expected_fail หรือ _dialog_fail
      if (k.contains('_expected_fail') || k.contains('_dialog_fail')) {
        expectedFailKeys.add(k);
        if (isDialog) dialogKeys.add(k);
      }
    }

    // Helper: สร้าง assert map สำหรับ key หนึ่งๆ
    // ถ้า key อยู่ใน dialogKeys จะเพิ่ม dismiss: true เพื่อให้ test script
    // dismiss dialog หลัง assert
    Map<String, dynamic> buildAssert(String key, {bool exists = true}) {
      final base = <String, dynamic>{'byKey': key, 'exists': exists};
      if (dialogKeys.contains(key)) base['dismiss'] = true;
      return base;
    }

    // ตรวจสอบว่ามี end button หรือไม่
    // ถ้ามี = API flow (form submission)
    // ถ้าไม่มี = widget demo (ไม่มี form submission)
    final hasEndButton = endKey != null;

    // Fallback success key: ถ้า manifest ไม่มี _expected_success key เลย
    // → derive จาก page prefix ของ endKey เช่น "search_07_end_button" → "search_expected_success"
    // เพื่อ force ให้ success cases มี assert เสมอ (rule: all-valid + no-validation → assert success)
    final String? _fallbackSuccessKey = (expectedSuccessKeys.isEmpty && endKey != null)
        ? '${endKey.split('_').first}_expected_success'
        : null;

    // Helper: สร้าง asserts สำหรับ success case
    // ถ้า expectedSuccessKeys ว่าง → ใช้ fallback key แทน
    List<Map<String, dynamic>> buildSuccessAsserts() {
      if (expectedSuccessKeys.isNotEmpty) {
        return [for (final sk in expectedSuccessKeys) buildAssert(sk)];
      } else if (_fallbackSuccessKey != null) {
        return [{'byKey': _fallbackSuccessKey, 'exists': true}];
      }
      return [];
    }

    // วนลูปครั้งที่สอง: จัดหมวดหมู่ widgets ตาม type
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString(); // widget type
      final k = (w['key'] ?? '').toString(); // widget key
      final pickerMeta =
          w['pickerMetadata'] as Map?; // metadata สำหรับ picker widgets

      // ---------------------------------------------------------------------
      // TextFormField / TextField - input fields สำหรับกรอกข้อความ
      // ---------------------------------------------------------------------
      if ((t.startsWith('TextField') || t.startsWith('TextFormField')) &&
          k.isNotEmpty &&
          pickerMeta == null) {
        textKeys.add(k);
      }
      // ---------------------------------------------------------------------
      // Radio - radio button options
      // ---------------------------------------------------------------------
      else if (t.startsWith('Radio') && k.isNotEmpty) {
        radioKeys.add(k);
      }
      // ---------------------------------------------------------------------
      // Checkbox / CheckboxListTile - checkbox widgets
      // NOTE: Skip FormField<bool> เพราะเป็น wrapper ไม่ใช่ interactive element
      // ---------------------------------------------------------------------
      else if ((t.startsWith('Checkbox') || t == 'CheckboxListTile') &&
          k.isNotEmpty) {
        checkboxKeys.add(k);
      }
      // ---------------------------------------------------------------------
      // Switch / SwitchListTile
      // ---------------------------------------------------------------------
      else if ((t == 'Switch' || t == 'SwitchListTile') && k.isNotEmpty) {
        switchKeys.add(k);
      }
      // ---------------------------------------------------------------------
      // Buttons - ปุ่มต่างๆ (ยกเว้น end button)
      // ---------------------------------------------------------------------
      else if ((t == 'ElevatedButton' ||
              t == 'TextButton' ||
              t == 'OutlinedButton') &&
          k.isNotEmpty &&
          k != endKey) {
        // ไม่รวม end button (จะใช้แยกต่างหากตอน submit)
        primaryButtons.add(k);
      }
      // ---------------------------------------------------------------------
      // DatePicker / TimePicker - date และ time picker widgets
      // ตรวจจับจาก pickerMetadata
      // ---------------------------------------------------------------------
      else if (pickerMeta != null && k.isNotEmpty) {
        final pickerType = (pickerMeta['type'] ?? '').toString();
        if (pickerType == 'DatePicker') {
          datePickerKeys.add(k);
        } else if (pickerType == 'TimePicker') {
          timePickerKeys.add(k);
        }
      }
    }

    // ---------------------------------------------------------------------------
    // Fallback: หา radio options ที่อาจพลาดไป
    // รวมเฉพาะ concrete radio options, ไม่รวม FormField group keys
    // ---------------------------------------------------------------------------
    for (final w in widgets) {
      final k = (w['key'] ?? '').toString();
      // ตรวจสอบว่าเป็น radio option จากชื่อ key
      // Pattern: _radio, _yes_radio, _no_radio แต่ไม่ใช่ _radio_group
      final isOption = (k.endsWith('_radio') ||
              k.contains('_yes_radio') ||
              k.contains('_no_radio')) &&
          !k.contains('_radio_group');
      // เพิ่มถ้ายังไม่มีใน list
      if (isOption && !radioKeys.contains(k)) radioKeys.add(k);
    }

    // ── Helpers used by STEP 6b and later stages ──────────────────────────────

    bool isEmptyCheckCondition(String condition) {
      final normalized = condition.toLowerCase().replaceAll(' ', '');
      return normalized.contains('value==null') ||
          normalized.contains('value.isempty') ||
          normalized.contains('valuenull') ||
          normalized.contains('valueisempty');
    }

    /// สร้าง date values สำหรับ DatePicker ตาม firstDate/lastDate constraints
    ///
    /// Parameter:
    ///   [pickerMeta] - metadata ของ DatePicker widget
    ///
    /// Returns:
    ///   List<String> - list ของ date values ในรูปแบบ DD/MM/YYYY
    ///                  รวม 'null' สำหรับ cancel case
    ///
    /// Example output: ['null', '15/01/2001', '29/01/2026', '15/12/2029']
    List<String> _generateDateValues(Map<String, dynamic> pickerMeta) {
      final values = <String>[];

      // -------------------------------------------------------------------------
      // Parse firstDate และ lastDate จาก metadata
      // -------------------------------------------------------------------------
      final firstDateStr = (pickerMeta['firstDate'] ?? '').toString();
      final lastDateStr = (pickerMeta['lastDate'] ?? '').toString();

      DateTime? firstDate;
      DateTime? lastDate;
      final now = DateTime.now();

      // Parse firstDate
      if (firstDateStr.contains('DateTime(1900)')) {
        firstDate = DateTime(1900);
      } else if (firstDateStr.contains('DateTime.now()')) {
        firstDate = now;
      } else {
        final yearMatch =
            RegExp(r'DateTime\((\d{4})\)').firstMatch(firstDateStr);
        if (yearMatch != null) {
          firstDate = DateTime(int.parse(yearMatch.group(1)!));
        }
      }

      // Parse lastDate
      if (lastDateStr.contains('DateTime.now()')) {
        if (lastDateStr.contains('add') && lastDateStr.contains('365')) {
          lastDate = now.add(const Duration(days: 365));
        } else {
          lastDate = now;
        }
      } else {
        final yearMatch =
            RegExp(r'DateTime\((\d{4})\)').firstMatch(lastDateStr);
        if (yearMatch != null) {
          lastDate = DateTime(int.parse(yearMatch.group(1)!));
        }
      }

      // -------------------------------------------------------------------------
      // Default values ถ้า parse ไม่ได้
      // -------------------------------------------------------------------------
      firstDate ??= DateTime(2000);
      lastDate ??= DateTime(2030);

      // -------------------------------------------------------------------------
      // สร้าง test dates ภายใน constraints
      // -------------------------------------------------------------------------

      // 1. null (cancel) - เสมอ include เพื่อ test cancel behavior
      values.add('null');

      // 2. past_date - วันที่ใกล้ firstDate
      final pastDate = DateTime(
        firstDate.year + 1,
        firstDate.month,
        15.clamp(1, 28),
      );
      if (pastDate.isAfter(firstDate) && pastDate.isBefore(lastDate)) {
        values.add(
            '${pastDate.day.toString().padLeft(2, '0')}/${pastDate.month.toString().padLeft(2, '0')}/${pastDate.year}');
      }

      // 3. today - วันนี้ (ถ้าอยู่ใน range)
      if (now.isAfter(firstDate) && now.isBefore(lastDate)) {
        values.add(
            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}');
      }

      // 4. future_date - วันที่ใกล้ lastDate
      final futureDate = DateTime(
        lastDate.year - 1,
        lastDate.month,
        15.clamp(1, 28),
      );
      if (futureDate.isAfter(firstDate) &&
          futureDate.isBefore(lastDate) &&
          futureDate.isAfter(now)) {
        values.add(
            '${futureDate.day.toString().padLeft(2, '0')}/${futureDate.month.toString().padLeft(2, '0')}/${futureDate.year}');
      }

      // -------------------------------------------------------------------------
      // Fallback: ถ้ามีน้อยกว่า 3 values ให้เพิ่ม middle date
      // -------------------------------------------------------------------------
      if (values.length < 3) {
        final middleDate = DateTime(
          (firstDate.year + lastDate.year) ~/ 2,
          6,
          15,
        );
        values.add(
            '${middleDate.day.toString().padLeft(2, '0')}/${middleDate.month.toString().padLeft(2, '0')}/${middleDate.year}');
      }

      return values;
    }

    // ---------------------------------------------------------------------------
    // STEP 6b: Auto-populate datasets for DatePicker / TimePicker keys
    //   ค่าจาก external datasets.json อาจไม่สะท้อน firstDate/lastDate
    //   ดังนั้นจึง override ด้วยค่าที่ derive จาก _generateDateValues()
    // ---------------------------------------------------------------------------

    // Helper: parse DateTime from pickerMeta string (reused for atMin/atMax)
    String formatDate(DateTime d) =>
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

    DateTime parseDateStr(String s, DateTime fallback) {
      final now = DateTime.now();
      if (s.contains('DateTime.now()')) {
        if (s.contains('add') && s.contains('365'))
          return now.add(const Duration(days: 365));
        return now;
      }
      final m = RegExp(r'DateTime\((\d{4})\)').firstMatch(s);
      if (m != null) return DateTime(int.parse(m.group(1)!));
      return fallback;
    }

    for (final key in datePickerKeys) {
      final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
          orElse: () => <String, dynamic>{});
      final pickerMeta =
          (widget['pickerMetadata'] as Map?)?.cast<String, dynamic>() ?? {};
      final dateValues = _generateDateValues(pickerMeta);
      final nonNullDates = dateValues.where((v) => v != 'null').toList();
      if (nonNullDates.isEmpty) continue;

      // valid: วันที่ปีปัจจุบัน (navigate น้อยที่สุดในปฏิทิน)
      final currentYear = DateTime.now().year.toString();
      final validDate = nonNullDates.firstWhere(
        (v) => v.contains(currentYear),
        orElse: () => nonNullDates[nonNullDates.length ~/ 2],
      );

      // atMin/atMax: ใช้ exact firstDate/lastDate จาก pickerMetadata
      final firstDate = parseDateStr(
          (pickerMeta['firstDate'] ?? '').toString(), DateTime(2000));
      final lastDate = parseDateStr(
          (pickerMeta['lastDate'] ?? '').toString(), DateTime(2030));
      final atMinDate = formatDate(firstDate);
      final atMaxDate = formatDate(lastDate);

      // หา required validator message จาก widget meta
      final meta =
          (widget['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rules =
          (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
      String requiredMsg = '';
      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          if (isEmptyCheckCondition(condition)) {
            requiredMsg = rule['message']?.toString() ?? '';
            break;
          }
        }
      }

      (datasets['byKey'] as Map<String, dynamic>)[key] = [
        {
          'valid': validDate,
          'invalid': '',
          'invalidRuleMessages': requiredMsg,
          'atMin': atMinDate,
          'atMax': atMaxDate,
        }
      ];
    }

    for (final key in timePickerKeys) {
      final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
          orElse: () => <String, dynamic>{});
      final meta =
          (widget['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rules =
          (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
      String requiredMsg = '';
      for (final rule in rules) {
        if (rule is Map) {
          final condition = rule['condition']?.toString() ?? '';
          if (isEmptyCheckCondition(condition)) {
            requiredMsg = rule['message']?.toString() ?? '';
            break;
          }
        }
      }

      (datasets['byKey'] as Map<String, dynamic>)[key] = [
        {
          'valid': '09:00',
          'invalid': '',
          'invalidRuleMessages': requiredMsg,
          'atMin': '00:00',
          'atMax': '23:59',
        }
      ];
    }

    // Write back corrected picker datasets to datasets.json so the file stays
    // in sync with what generate_test_data.dart actually uses.
    if (datePickerKeys.isNotEmpty || timePickerKeys.isNotEmpty) {
      try {
        final extPath =
            'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
        final f = File(extPath);
        if (f.existsSync()) {
          final existing =
              jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
          final extDatasets =
              (existing['datasets'] as Map?)?.cast<String, dynamic>() ?? {};
          final extByKey =
              (extDatasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};

          // Override picker keys with corrected values from in-memory datasets
          final inMemByKey =
              (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};
          for (final key in [...datePickerKeys, ...timePickerKeys]) {
            if (inMemByKey.containsKey(key)) {
              extByKey[key] = inMemByKey[key];
            }
          }

          extDatasets['byKey'] = extByKey;
          existing['datasets'] = extDatasets;
          f.writeAsStringSync(
              const JsonEncoder.withIndent('  ').convert(existing));
        }
      } catch (_) {
        // ignore write errors
      }
    }

    // ---------------------------------------------------------------------------
    // STEP 7: ตรวจจับ Required Checkboxes
    // ---------------------------------------------------------------------------

    // ตรวจจับ required checkboxes จาก FormField<bool> validators
    // Checkbox ถือว่า required ถ้า FormField wrapper มี validator ที่ต้องการค่า true
    // Map: checkbox key -> validation message
    final requiredCheckboxValidation = <String, String>{};

    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      final k = (w['key'] ?? '').toString();

      // ตรวจสอบเฉพาะ FormField<bool> (wrapper ของ Checkbox)
      if (t.startsWith('FormField<bool>') && k.isNotEmpty) {
        // ดึง metadata ของ widget
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        // ดึง validator rules
        final rules =
            (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

        // วิเคราะห์แต่ละ rule
        for (final rule in rules) {
          if (rule is Map) {
            final condition = rule['condition']?.toString() ?? '';
            final message = rule['message']?.toString() ?? '';

            // ตรวจสอบว่า condition ต้องการให้ checkbox เป็น true
            // Pattern ที่พบบ่อย: "value == null || !value"
            // แปลว่า: ถ้า value เป็น null หรือ false ให้แสดง error
            final normalized = condition.toLowerCase().replaceAll(' ', '');
            if (normalized.contains('!value') || // !value
                normalized.contains('value==false') || // value == false
                (normalized.contains('value==null') &&
                    normalized.contains('||!value'))) {
              // หา key ของ Checkbox ที่เกี่ยวข้อง
              // โดยเปลี่ยน _formfield เป็น _checkbox
              final checkboxKey = k.replaceAll('_formfield', '_checkbox');
              requiredCheckboxValidation[checkboxKey] = message;
              break; // หยุดหลังพบ rule แรก
            }
          }
        }
      }
    }

    // ---------------------------------------------------------------------------
    // STEP 8: ตรวจจับ Dropdowns และ options
    // ---------------------------------------------------------------------------

    // รองรับหลาย dropdowns ใน form เดียว
    String? dropdownKey; // key ของ dropdown แรก (backward compatibility)
    final dropdownValues = <String>[]; // items ของ dropdown แรก
    final dropdownKeys = <String>[]; // keys ของทุก dropdowns
    final dropdownValuesList = <List<String>>[]; // items ของแต่ละ dropdown
    final dropdownValueToTextMaps =
        <Map<String, String>>[]; // Map value -> text สำหรับแต่ละ dropdown

    // วนลูปหา DropdownButton widgets
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();

      // ตรวจสอบว่าเป็น DropdownButton หรือไม่
      if (t.contains('DropdownButton')) {
        final k = (w['key'] ?? '').toString();
        if (k.isNotEmpty) {
          dropdownKeys.add(k);
          // เก็บ key แรกสำหรับ backward compatibility
          if (dropdownKey == null) dropdownKey = k;
        }

        try {
          // ดึง options จาก metadata
          final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
          final list = _optionsFromMeta(meta['options']);
          dropdownValuesList.add(list);

          // เก็บ values ของ dropdown แรก
          if (dropdownValues.isEmpty) {
            dropdownValues.addAll(list);
          }

          // สร้าง value -> text mapping สำหรับ dropdown นี้
          // ใช้ตอน tap เพื่อแปลง value เป็น text ที่แสดงใน UI
          final valueToText = <String, String>{};
          final options = meta['options'];
          if (options is List) {
            for (final opt in options) {
              if (opt is Map) {
                final value = opt['value']?.toString(); // internal value
                final text = opt['text']?.toString(); // display text
                if (value != null &&
                    value.isNotEmpty &&
                    text != null &&
                    text.isNotEmpty) {
                  valueToText[value] = text;
                }
              }
            }
          }
          dropdownValueToTextMaps.add(valueToText);
        } catch (_) {
          // ถ้า parse ไม่ได้ ให้เพิ่ม empty map
          dropdownValueToTextMaps.add(<String, String>{});
        }
      }
    }

    // ---------------------------------------------------------------------------
    // STEP 9: เตรียม Test Cases และ Helper Functions
    // ---------------------------------------------------------------------------

    // List เก็บ test cases ที่จะสร้าง
    final cases = <Map<String, dynamic>>[];

    // ---------------------------------------------------------------------------
    // Helper Functions สำหรับ Test Case Generation
    // ---------------------------------------------------------------------------

    /// ย่อชื่อ field key ให้สั้นลง
    String _shortFieldName(String key) {
      if (key.startsWith('state.')) return key.substring(6);
      return key
          .replaceAll(RegExp(r'^[a-z]+_\d+_'), '')
          .replaceAll('_textfield', '')
          .replaceAll('_dropdown', '')
          .replaceAll('_checkbox', '')
          .replaceAll('_radio', '')
          .replaceAll('_button', '');
    }

    /// ย่อ value ให้อ่านง่าย
    /// เช่น "education_bachelor_radio" → "bachelor"
    String _shortValue(String value) {
      var v = value
          .replaceAll(RegExp(r'_radio$'), '')
          .replaceAll(RegExp(r'_dropdown$'), '');
      final lastUnderscore = v.lastIndexOf('_');
      if (lastUnderscore > 0 && lastUnderscore < v.length - 1) {
        v = v.substring(lastUnderscore + 1);
      }
      return v;
    }

    /// สร้าง description สำหรับ test case
    /// แสดงทุก field พร้อมค่าที่ใช้ test จริงๆ เช่น
    ///   "fullname: Alice, email: bad@email, education: master, ..."
    String _buildDescription(
        Map<String, String> combo,
        String kind,
        List<String> invalidFields,
        List<String> uncheckedRequired,
        List<Map<String, dynamic>> asserts) {
      final parts = <String>[];
      final byKey =
          (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};

      for (final e in combo.entries) {
        final field = _shortFieldName(e.key);
        final raw = e.value;

        String value;
        if (raw == 'checked' || raw == 'unchecked') {
          // checkbox: ใช้ label ตรงๆ เพื่อ color coding ใน UI
          value = raw;
        } else if (raw == 'valid' ||
            raw == 'invalid' ||
            raw == 'atMax' ||
            raw == 'atMin' ||
            raw == 'empty') {
          // resolve ค่าจริงจาก datasets[byKey][key][0]
          // format: "label§actualValue" เพื่อให้ UI รู้จักสี
          final arr = (byKey[e.key] as List?) ?? const [];
          final actual = raw == 'empty'
              ? ''
              : (arr.isNotEmpty && arr[0] is Map
                  ? (arr[0] as Map)[raw]?.toString() ?? ''
                  : '');
          final display = raw == 'empty'
              ? '""'
              : (actual.isNotEmpty
                  ? (actual.length > 28
                      ? '${actual.substring(0, 28)}…'
                      : actual)
                  : '""'); // actual ว่าง → แสดง "" เพื่อสื่อว่าค่าเป็น empty string
          value = '$raw§$display';
        } else {
          // radio/dropdown: ใช้ _shortValue (ไม่มี label prefix)
          value = _shortValue(raw);
        }
        parts.add('$field: $value');
      }
      if (parts.isEmpty)
        return kind == 'failed' ? 'expect failure' : 'all valid';
      return parts.join(', ');
    }

    /// ดึง metadata ของ widget จาก key
    /// ค้นหา widget ที่มี key ตรงกันและ return metadata
    Map<String, dynamic> _widgetMetaByKey(String key) {
      for (final w in widgets) {
        if ((w['key'] ?? '') == key) {
          return (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        }
      }
      return const {}; // return empty map ถ้าไม่พบ
    }

    /// ดึง maxLength จาก widget metadata
    ///
    /// ตรวจสอบจาก 2 sources:
    ///   1. inputFormatters - LengthLimitingTextInputFormatter
    ///   2. maxLength property
    ///
    /// Parameter:
    ///   [meta] - metadata ของ widget
    ///
    /// Returns:
    ///   int? - maxLength หรือ null ถ้าไม่พบ
    int? _maxLenFromMeta(Map<String, dynamic> meta) {
      // ตรวจสอบ inputFormatter ก่อน (LengthLimitingTextInputFormatter มี priority สูงกว่า)
      final fmts = (meta['inputFormatters'] as List? ?? const []).cast<Map>();
      // หา formatter ที่เป็น type 'lengthLimit'
      final lenFmt = fmts.firstWhere((f) => (f['type'] ?? '') == 'lengthLimit',
          orElse: () => {});
      // ถ้าพบและมี max ให้ return
      if (lenFmt is Map && lenFmt['max'] is int) return lenFmt['max'] as int;

      // Fallback: ใช้ maxLength property โดยตรง
      if (meta['maxLength'] is int) return meta['maxLength'] as int;

      return null; // ไม่พบ maxLength
    }

    // ---------------------------------------------------------------------------
    // NOTE: ส่วนที่ถูกลบออก
    // - Validation test cases - ไม่สร้าง individual field validation tests แยก
    // - API Response cases - ไม่ต้องการแล้วกับ naming convention ใหม่
    // - Full flow mode - รองรับเฉพาะ pairwise testing
    // ---------------------------------------------------------------------------

    // ---------------------------------------------------------------------------
    // STEP 11: Pairwise Test Generation
    // ---------------------------------------------------------------------------

    // ตรวจสอบว่ามี PICT model files หรือไม่
    // รองรับทั้ง API forms และ widget demos
    final pageBase = utils.basenameWithoutExtension(uiFile);

    // Paths ของ PICT files
    final pageResultPath =
        'output/model_pairwise/$pageBase.full.result.txt'; // Full pairwise result
    final pageValidResultPath =
        'output/model_pairwise/$pageBase.valid.result.txt'; // Valid-only result
    final pageModelPath =
        'output/model_pairwise/$pageBase.full.model.txt'; // PICT model definition

    // ตรวจสอบว่า PICT model มีอยู่หรือไม่
    final hasPictModel = File(pageModelPath).existsSync();

    // ---------------------------------------------------------------------------
    // STEP 12: โหลดและวิเคราะห์ PICT Model (ถ้ามี)
    // ---------------------------------------------------------------------------

    if (hasPictModel) {
      // ── Shared State (closure variables) ─────────────────────────────────────
      List<Map<String, String>>? extCombos;
      List<Map<String, String>>? extValidCombos;
      Map<String, List<String>>? modelFactors;
      final factorTypes = <String, String>{};

      // ── Shared Helper ─────────────────────────────────────────────────────────
      String? radioKeyForSuffix(List<String> keys, String suffix) {
        if (suffix.isEmpty) return null;
        final hit = keys.firstWhere(
            (k) => k.endsWith('_$suffix') || k.endsWith(suffix),
            orElse: () => '');
        return hit.isEmpty ? null : hit;
      }

      // ── STEP 12: Load PICT Analysis ───────────────────────────────────────────
      void loadPictAnalysis() {
        if (File(pageModelPath).existsSync()) {
          modelFactors =
              pictGen.parsePictModel(File(pageModelPath).readAsStringSync());
        }
        if (modelFactors != null) {
          for (final entry in modelFactors!.entries) {
            final name = entry.key;
            final values = entry.value;
            if (values.contains('valid') && values.contains('invalid')) {
              factorTypes[name] = 'text';
            } else if (values.contains('checked') &&
                values.contains('unchecked')) {
              factorTypes[name] = 'checkbox';
            } else if (values.contains('on') && values.contains('off')) {
              factorTypes[name] = 'switch';
            } else if (values.any((v) => v.endsWith('_radio'))) {
              factorTypes[name] = 'radio';
            } else if (datePickerKeys.contains(name)) {
              factorTypes[name] = 'datepicker';
            } else if (timePickerKeys.contains(name)) {
              factorTypes[name] = 'timepicker';
            } else {
              factorTypes[name] = 'dropdown';
            }
          }
        }
        if (File(pageResultPath).existsSync()) {
          extCombos =
              pictGen.parsePictResult(File(pageResultPath).readAsStringSync());
        }
        if (File(pageValidResultPath).existsSync()) {
          extValidCombos = pictGen
              .parsePictResult(File(pageValidResultPath).readAsStringSync());
        }
      }

      // ── STEP 13: Build Pairwise Cases ─────────────────────────────────────────
      Future<void> _buildPairwiseCases() async {
        // Inner helpers
        String textForBucket(String tfKey, String bucket) {
          final maxLen = _maxLenFromMeta(_widgetMetaByKey(tfKey));
          if (bucket == 'min') return '';
          if (bucket == 'min+1') return 'A';
          if (bucket == 'nominal') {
            final n = (maxLen != null && maxLen > 2) ? (maxLen ~/ 2) : 5;
            return 'A' * n;
          }
          if (bucket == 'max-1') {
            if (maxLen != null && maxLen > 1) return 'A' * (maxLen - 1);
            return 'A';
          }
          if (bucket == 'max') return 'A' * (maxLen ?? 10);
          return 'A' * 5;
        }

        String? datasetPathForKeyBucket(String tfKey, String bucket) {
          final ds =
              (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};
          if (!ds.containsKey(tfKey)) return null;
          if (bucket != 'valid' && bucket != 'invalid') return null;
          final dataArray = ds[tfKey];
          if (dataArray is List && dataArray.isNotEmpty) {
            return 'byKey.$tfKey[0].$bucket';
          }
          final sub = (ds[tfKey] as Map?)?.cast<String, dynamic>() ?? const {};
          final list = (sub[bucket] as List?) ?? const [];
          if (list.isEmpty) return null;
          return 'byKey.$tfKey.$bucket[0]';
        }

        // Resolve combos
        List<Map<String, String>> combos;
        bool usingExternalCombos = false;

        if (extCombos != null && extCombos!.isNotEmpty) {
          combos = extCombos!;
          usingExternalCombos = true;
        } else {
          final factors = <String, List<String>>{};
          for (int i = 0; i < textKeys.length; i++) {
            factors[textKeys.length == 1 ? 'TEXT' : 'TEXT${i + 1}'] = [
              'valid',
              'invalid'
            ];
          }
          final radioGroups = <String, List<String>>{};
          for (final w in widgets) {
            final t = (w['widgetType'] ?? '').toString();
            final k = (w['key'] ?? '').toString();
            if (t.startsWith('Radio') &&
                k.isNotEmpty &&
                radioKeys.contains(k)) {
              try {
                final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
                final groupBinding =
                    (meta['groupValueBinding'] ?? '').toString();
                if (groupBinding.isNotEmpty) {
                  radioGroups.putIfAbsent(groupBinding, () => []).add(k);
                }
              } catch (_) {}
            }
          }
          if (radioGroups.isEmpty) {
            for (final w in widgets) {
              if ((w['widgetType'] ?? '').toString() == 'FormField<int>') {
                try {
                  final meta =
                      (w['meta'] as Map?)?.cast<String, dynamic>() ?? {};
                  final options = meta['options'];
                  if (options is List) {
                    final radioGroup = <String>[];
                    for (final opt in options) {
                      if (opt is Map) {
                        final optValue = opt['value']?.toString();
                        if (optValue != null) {
                          for (final rw in widgets) {
                            final rt = (rw['widgetType'] ?? '').toString();
                            final rk = (rw['key'] ?? '').toString();
                            if (rt.startsWith('Radio') && rk.isNotEmpty) {
                              final rmeta = (rw['meta'] as Map?)
                                      ?.cast<String, dynamic>() ??
                                  {};
                              if ((rmeta['valueExpr'] ?? '').toString() ==
                                  optValue) {
                                radioGroup.add(rk);
                              }
                            }
                          }
                        }
                      }
                    }
                    if (radioGroup.length > 1) {
                      radioGroups[(w['key'] ?? 'unknown').toString()] =
                          radioGroup;
                    }
                  }
                } catch (_) {}
              }
            }
          }
          int radioIndex = 1;
          for (final entry in radioGroups.entries) {
            if (entry.value.length > 1) {
              factors['Radio$radioIndex'] = entry.value;
              radioIndex++;
            }
          }
          if (dropdownValues.isNotEmpty) {
            factors['Dropdown'] = List<String>.from(dropdownValues);
          }
          for (int i = 0; i < checkboxKeys.length; i++) {
            factors[(checkboxKeys.length == 1 || i == 0)
                ? 'Checkbox'
                : 'Checkbox${i + 1}'] = ['checked', 'unchecked'];
          }
          for (final key in datePickerKeys) {
            final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
                orElse: () => <String, dynamic>{});
            final pickerMeta =
                (widget['pickerMetadata'] as Map?)?.cast<String, dynamic>() ??
                    {};
            factors[key] = _generateDateValues(pickerMeta);
          }
          for (final key in timePickerKeys) {
            factors[key] = ['09:00', '14:30', '18:00', 'null'];
          }
          if (pairwiseUsePict) {
            try {
              combos = await pictGen.executePict(factors);
            } catch (e) {
              stderr.writeln(
                  '! PICT failed ($e). Falling back to internal pairwise.');
              combos = pictGen.generatePairwiseInternal(factors);
            }
          } else {
            combos = pictGen.generatePairwiseInternal(factors);
          }
        }

        // Build cases
        for (int i = 0; i < combos.length; i++) {
          final c = combos[i];
          final st = <Map<String, dynamic>>[];
          bool hasInvalidData = false;
          final invalidFields = <String>[];
          final uncheckedRequiredCheckboxes = <String>[];

          if (usingExternalCombos) {
            final stepsByKey = <String, List<Map<String, dynamic>>>{};
            for (final factorName in c.keys) {
              final factorType = factorTypes[factorName];
              final pick = (c[factorName] ?? '').toString();
              if (pick.isEmpty) continue;
              if (factorType == 'text') {
                final bucket = pick == 'invalid' ? 'invalid' : 'valid';
                if (bucket == 'invalid') {
                  hasInvalidData = true;
                  invalidFields.add(factorName);
                }
                stepsByKey[factorName] = [
                  {
                    'enterText': {
                      'byKey': factorName,
                      'dataset': 'byKey.$factorName[0].$bucket'
                    }
                  },
                  {'pump': true}
                ];
              } else if (factorType == 'radio') {
                final mk = radioKeyForSuffix(radioKeys, pick);
                if (mk != null) {
                  stepsByKey[mk] = [
                    {
                      'tap': {'byKey': mk}
                    },
                    {'pump': true}
                  ];
                }
              } else if (factorType == 'dropdown') {
                String textToTap = pick;
                final idx = dropdownKeys.indexOf(factorName);
                if (idx >= 0 && idx < dropdownValueToTextMaps.length) {
                  final mapping = dropdownValueToTextMaps[idx];
                  final clean = pick.replaceAll('"', '');
                  textToTap = mapping[clean.replaceAll('_', ' ')] ??
                      mapping[clean] ??
                      pick;
                }
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pumpAndSettle': true},
                  {'scrollAndTapText': textToTap},
                  {'pumpAndSettle': true}
                ];
              } else if (factorType == 'checkbox') {
                if (pick == 'checked') {
                  stepsByKey[factorName] = [
                    {
                      'tap': {'byKey': factorName}
                    },
                    {'pump': true}
                  ];
                } else if (pick == 'unchecked' &&
                    requiredCheckboxValidation.containsKey(factorName)) {
                  hasInvalidData = true;
                  uncheckedRequiredCheckboxes.add(factorName);
                }
              } else if (factorType == 'switch') {
                if (pick == 'on') {
                  stepsByKey[factorName] = [
                    {
                      'tap': {'byKey': factorName}
                    },
                    {'pump': true}
                  ];
                }
              } else if (datePickerKeys.contains(factorName)) {
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pumpAndSettle': true},
                  {'selectDate': pick},
                  {'pumpAndSettle': true}
                ];
              } else if (timePickerKeys.contains(factorName)) {
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pumpAndSettle': true},
                  {'selectTime': pick},
                  {'pumpAndSettle': true}
                ];
              }
            }
            final sorted = List<Map<String, dynamic>>.from(widgets)
              ..sort((a, b) => (a['key'] ?? '')
                  .toString()
                  .compareTo((b['key'] ?? '').toString()));
            for (final w in sorted) {
              final k = (w['key'] ?? '').toString();
              if (stepsByKey.containsKey(k)) st.addAll(stepsByKey[k]!);
            }
          } else {
            final stepsByKey = <String, List<Map<String, dynamic>>>{};
            for (int j = 0; j < textKeys.length; j++) {
              final factorName = textKeys.length == 1 ? 'TEXT' : 'TEXT${j + 1}';
              final tfBucket = c[factorName];
              if (tfBucket != null) {
                if (tfBucket.toString() == 'invalid') {
                  hasInvalidData = true;
                  invalidFields.add(textKeys[j]);
                }
                final dsPath =
                    datasetPathForKeyBucket(textKeys[j], tfBucket.toString());
                stepsByKey[textKeys[j]] = dsPath != null
                    ? [
                        {
                          'enterText': {'byKey': textKeys[j], 'dataset': dsPath}
                        },
                        {'pump': true}
                      ]
                    : [
                        {
                          'enterText': {
                            'byKey': textKeys[j],
                            'text': textForBucket(textKeys[j], tfBucket)
                          }
                        },
                        {'pump': true}
                      ];
              }
            }
            if (dropdownKey != null && c['Dropdown'] != null) {
              final ddPick = (c['Dropdown'] ?? '').toString();
              if (ddPick.isNotEmpty) {
                stepsByKey[dropdownKey] = [
                  {
                    'tap': {'byKey': dropdownKey}
                  },
                  {'pump': true},
                  {'tapText': ddPick},
                  {'pump': true}
                ];
              }
            }
            for (final factorName in c.keys) {
              if (factorName.startsWith('Radio')) {
                final pick = (c[factorName] ?? '').toString();
                if (pick.isNotEmpty) {
                  final mk = radioKeyForSuffix(radioKeys, pick);
                  if (mk != null) {
                    stepsByKey[mk] = [
                      {
                        'tap': {'byKey': mk}
                      },
                      {'pump': true}
                    ];
                  }
                }
              }
            }
            for (int idx = 0; idx < checkboxKeys.length; idx++) {
              final factorName = (checkboxKeys.length == 1 || idx == 0)
                  ? 'Checkbox'
                  : 'Checkbox${idx + 1}';
              if ((c[factorName] ?? '').toString() == 'checked') {
                final key = checkboxKeys[idx];
                if (key.isNotEmpty) {
                  stepsByKey[key] = [
                    {
                      'tap': {'byKey': key}
                    },
                    {'pump': true}
                  ];
                }
              }
            }
            for (int idx = 0; idx < datePickerKeys.length; idx++) {
              final key = datePickerKeys[idx];
              final pick = (c[key] ?? '').toString();
              if (pick.isNotEmpty) {
                stepsByKey[key] = [
                  {
                    'tap': {'byKey': key}
                  },
                  {'pumpAndSettle': true},
                  {'selectDate': pick},
                  {'pumpAndSettle': true}
                ];
              }
            }
            for (int idx = 0; idx < timePickerKeys.length; idx++) {
              final key = timePickerKeys[idx];
              final pick = (c[key] ?? '').toString();
              if (pick.isNotEmpty) {
                stepsByKey[key] = [
                  {
                    'tap': {'byKey': key}
                  },
                  {'pumpAndSettle': true},
                  {'selectTime': pick},
                  {'pumpAndSettle': true}
                ];
              }
            }
            final sorted = List<Map<String, dynamic>>.from(widgets)
              ..sort((a, b) => (a['key'] ?? '')
                  .toString()
                  .compareTo((b['key'] ?? '').toString()));
            for (final w in sorted) {
              final k = (w['key'] ?? '').toString();
              if (stepsByKey.containsKey(k)) st.addAll(stepsByKey[k]!);
            }
          }

          if (hasEndButton && endKey != null) {
            st.add({
              'tap': {'byKey': endKey}
            });
            st.add({'pumpAndSettle': true});
          } else {
            st.add({'pump': true});
          }

          final caseKind = hasInvalidData ? 'failed' : 'success';
          final id = 'pairwise_valid_invalid_cases_${i + 1}';
          final asserts = <Map<String, dynamic>>[];

          if (hasInvalidData) {
            final ds = (datasets['byKey'] as Map?)?.cast<String, dynamic>() ??
                const {};
            for (final fieldKey in invalidFields) {
              final dataArray = ds[fieldKey];
              if (dataArray is List && dataArray.isNotEmpty) {
                final firstPair = dataArray[0];
                if (firstPair is Map) {
                  final msg = firstPair['invalidRuleMessages']?.toString();
                  if (msg != null &&
                      msg.isNotEmpty &&
                      msg.toLowerCase() != 'general' &&
                      !msg.toLowerCase().contains('required') &&
                      !msg.toLowerCase().contains('กรุณา')) {
                    asserts.add({'text': msg, 'exists': true});
                  }
                }
              }
            }
            for (final ck in uncheckedRequiredCheckboxes) {
              final msg = requiredCheckboxValidation[ck];
              if (msg != null && msg.isNotEmpty) {
                asserts.add({'text': msg, 'exists': true});
              }
            }
          } else {
            asserts.addAll(buildSuccessAsserts());
          }

          final comboStr = c.map((k, v) => MapEntry(k, v.toString()));
          cases.add({
            'tc': id,
            'kind': caseKind,
            'group': 'pairwise_valid_invalid_cases',
            'description': _buildDescription(comboStr, caseKind, invalidFields,
                uncheckedRequiredCheckboxes, asserts),
            'steps': st,
            'asserts': asserts,
          });
        }

        // ── Inject all-valid success case ──────────────────────────────────────
        // PICT ไม่สร้าง all-valid combo ใน full model → inject เองให้ครบ
        // rule: ถ้า group pairwise_valid_invalid_cases ไม่มี kind==success เลย
        //       และมี expectedSuccessKeys → เพิ่ม 1 case ที่ valid ทุก field
        final alreadyHasSuccess = cases.any((c) =>
            c['group'] == 'pairwise_valid_invalid_cases' &&
            c['kind'] == 'success');

        if (!alreadyHasSuccess && expectedSuccessKeys.isNotEmpty) {
          final st = <Map<String, dynamic>>[];
          final stepsByKey = <String, List<Map<String, dynamic>>>{};

          // Text fields — valid dataset
          for (final key in textKeys) {
            stepsByKey[key] = [
              {
                'enterText': {
                  'byKey': key,
                  'dataset': 'byKey.$key[0].valid'
                }
              },
              {'pump': true}
            ];
          }

          // Dropdowns — เลือก option แรกที่ไม่ใช่ null
          for (int idx = 0; idx < dropdownKeys.length; idx++) {
            final key = dropdownKeys[idx];
            final opts = idx < dropdownValuesList.length
                ? dropdownValuesList[idx]
                : <String>[];
            final firstOpt = opts.firstWhere(
              (v) => v != 'null' && v.isNotEmpty,
              orElse: () => '',
            );
            if (firstOpt.isNotEmpty) {
              String textToTap = firstOpt;
              if (idx < dropdownValueToTextMaps.length) {
                final mapping = dropdownValueToTextMaps[idx];
                final clean = firstOpt.replaceAll('"', '');
                textToTap = mapping[clean.replaceAll('_', ' ')] ??
                    mapping[clean] ??
                    firstOpt;
              }
              stepsByKey[key] = [
                {'tap': {'byKey': key}},
                {'pumpAndSettle': true},
                {'scrollAndTapText': textToTap},
                {'pumpAndSettle': true}
              ];
            }
          }

          // Required checkboxes — ต้อง checked
          for (final ck in requiredCheckboxValidation.keys) {
            stepsByKey[ck] = [
              {'tap': {'byKey': ck}},
              {'pump': true}
            ];
          }

          // เรียง steps ตาม widget order
          final sorted = List<Map<String, dynamic>>.from(widgets)
            ..sort((a, b) => (a['key'] ?? '')
                .toString()
                .compareTo((b['key'] ?? '').toString()));
          for (final w in sorted) {
            final k = (w['key'] ?? '').toString();
            if (stepsByKey.containsKey(k)) st.addAll(stepsByKey[k]!);
          }

          // End button
          if (hasEndButton && endKey != null) {
            st.add({'tap': {'byKey': endKey}});
            st.add({'pumpAndSettle': true});
          } else {
            st.add({'pump': true});
          }

          final successAsserts = buildSuccessAsserts();
          cases.add({
            'tc': 'pairwise_valid_invalid_cases_${combos.length + 1}',
            'kind': 'success',
            'group': 'pairwise_valid_invalid_cases',
            'description': 'All fields valid — expect success',
            'steps': st,
            'asserts': successAsserts,
          });
        }
      }

      // ── STEP 14: Build Valid-Only Cases ───────────────────────────────────────
      void _buildPairwiseValidCases() {
        if (extValidCombos == null || extValidCombos!.isEmpty) return;
        for (int i = 0; i < extValidCombos!.length; i++) {
          final c = extValidCombos![i];
          final st = <Map<String, dynamic>>[];

          List<String> headerOrder = [];
          if (File(pageValidResultPath).existsSync()) {
            final content = File(pageValidResultPath).readAsStringSync();
            final lines = content
                .trim()
                .split(RegExp(r'\r?\n'))
                .where((l) => l.trim().isNotEmpty)
                .toList();
            if (lines.isNotEmpty) {
              headerOrder =
                  lines.first.split('\t').map((s) => s.trim()).toList();
            }
          }
          if (headerOrder.isEmpty) {
            headerOrder = [
              'TEXT',
              'TEXT2',
              'TEXT3',
              'Radio2',
              'Radio3',
              'Radio4',
              'Dropdown'
            ];
          }

          final stepsByKey = <String, List<Map<String, dynamic>>>{};
          for (final factorName in headerOrder) {
            final pick = (c[factorName] ?? '').toString();
            if (pick.isEmpty) continue;
            final factorType = factorTypes[factorName];
            if (factorType == 'text') {
              stepsByKey[factorName] = [
                {
                  'enterText': {
                    'byKey': factorName,
                    'dataset': 'byKey.$factorName[0].valid'
                  }
                },
                {'pump': true}
              ];
            } else if (factorType == 'radio') {
              final mk = radioKeyForSuffix(radioKeys, pick);
              if (mk != null) {
                stepsByKey[mk] = [
                  {
                    'tap': {'byKey': mk}
                  },
                  {'pump': true}
                ];
              }
            } else if (factorType == 'dropdown') {
              String textToTap = pick;
              final idx = dropdownKeys.indexOf(factorName);
              if (idx >= 0 && idx < dropdownValueToTextMaps.length) {
                final mapping = dropdownValueToTextMaps[idx];
                final clean = pick.replaceAll('"', '');
                textToTap = mapping[clean.replaceAll('_', ' ')] ??
                    mapping[clean] ??
                    pick;
              }
              stepsByKey[factorName] = [
                {
                  'tap': {'byKey': factorName}
                },
                {'pumpAndSettle': true},
                {'scrollAndTapText': textToTap},
                {'pumpAndSettle': true}
              ];
            } else if (factorType == 'checkbox') {
              if (pick == 'checked') {
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pump': true}
                ];
              }
            } else if (factorType == 'switch') {
              if (pick == 'on') {
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pump': true}
                ];
              }
            } else if (datePickerKeys.contains(factorName)) {
              stepsByKey[factorName] = [
                {
                  'tap': {'byKey': factorName}
                },
                {'pumpAndSettle': true},
                {'selectDate': pick},
                {'pumpAndSettle': true}
              ];
            } else if (timePickerKeys.contains(factorName)) {
              stepsByKey[factorName] = [
                {
                  'tap': {'byKey': factorName}
                },
                {'pumpAndSettle': true},
                {'selectTime': pick},
                {'pumpAndSettle': true}
              ];
            }
          }

          final sorted = List<Map<String, dynamic>>.from(widgets)
            ..sort((a, b) => (a['key'] ?? '')
                .toString()
                .compareTo((b['key'] ?? '').toString()));
          for (final w in sorted) {
            final k = (w['key'] ?? '').toString();
            if (stepsByKey.containsKey(k)) st.addAll(stepsByKey[k]!);
          }

          if (hasEndButton && endKey != null) {
            st.add({
              'tap': {'byKey': endKey}
            });
            st.add({'pumpAndSettle': true});
          } else {
            st.add({'pump': true});
          }

          final id = 'pairwise_valid_cases_${i + 1}';
          final asserts = buildSuccessAsserts();
          final comboStr = c.map((k, v) => MapEntry(k, v.toString()));
          cases.add({
            'tc': id,
            'kind': 'success',
            'group': 'pairwise_valid_cases',
            'description': _buildDescription(
                comboStr, 'success', const [], const [], asserts),
            'steps': st,
            'asserts': asserts,
          });
        }
      }

      // ── Execute ───────────────────────────────────────────────────────────────
      loadPictAnalysis();
      await _buildPairwiseCases();
      _buildPairwiseValidCases();
    } // End of hasPictModel block

    // ---------------------------------------------------------------------------
    // NOTE: Radio-only state cases ถูกลบออกตาม requirement ล่าสุด
    // ---------------------------------------------------------------------------

    // ---------------------------------------------------------------------------
    // STEP 15 & 15b: สร้าง Edge Cases
    // ---------------------------------------------------------------------------

    bool datasetsHasField(String fieldKey, String field) {
      final ds =
          (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};
      if (!ds.containsKey(fieldKey)) return false;
      final arr = ds[fieldKey];
      if (arr is! List || arr.isEmpty) return false;
      final first = arr[0];
      return first is Map && first.containsKey(field);
    }

    List<String> boundaryFirstRadioKeys() {
      final result = <String>[];
      final seenSeqs = <int>{};
      for (final rk in radioKeys) {
        final seq = _extractSequence(rk);
        if (seq >= 0 && !seenSeqs.contains(seq)) {
          seenSeqs.add(seq);
          result.add(rk);
        } else if (seq < 0 && !result.contains(rk)) {
          result.add(rk);
        }
      }
      return result;
    }

    Map<String, String> buildNonTextDefaultCombo() {
      final combo = <String, String>{};
      for (final rk in boundaryFirstRadioKeys()) {
        combo[rk] = rk;
      }
      for (int i = 0; i < dropdownKeys.length; i++) {
        final dk = dropdownKeys[i];
        final mapping = i < dropdownValueToTextMaps.length
            ? dropdownValueToTextMaps[i]
            : <String, String>{};
        final firstText = mapping.values.isNotEmpty ? mapping.values.first : '';
        if (firstText.isNotEmpty) combo[dk] = firstText;
      }
      for (final ck in requiredCheckboxValidation.keys) {
        combo[ck] = 'checked';
      }
      // Switch: default off (ไม่ tap → ค่าเริ่มต้นของ Switch ใน Flutter คือ false)
      for (final sk in switchKeys) {
        combo[sk] = 'off';
      }
      return combo;
    }

    Map<String, List<Map<String, dynamic>>> buildNonTextDefaultSteps() {
      final stepsByKey = <String, List<Map<String, dynamic>>>{};
      for (final rk in boundaryFirstRadioKeys()) {
        stepsByKey[rk] = [
          {
            'tap': {'byKey': rk}
          },
          {'pump': true},
        ];
      }
      for (int i = 0; i < dropdownKeys.length; i++) {
        final dk = dropdownKeys[i];
        final mapping = i < dropdownValueToTextMaps.length
            ? dropdownValueToTextMaps[i]
            : <String, String>{};
        final firstText = mapping.values.isNotEmpty ? mapping.values.first : '';
        if (firstText.isNotEmpty) {
          stepsByKey[dk] = [
            {
              'tap': {'byKey': dk}
            },
            {'pumpAndSettle': true},
            {'scrollAndTapText': firstText},
            {'pumpAndSettle': true},
          ];
        }
      }
      for (final ck in requiredCheckboxValidation.keys) {
        stepsByKey[ck] = [
          {
            'tap': {'byKey': ck}
          },
          {'pump': true},
        ];
      }
      for (final key in datePickerKeys) {
        final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
            orElse: () => <String, dynamic>{});
        final pickerMeta =
            (widget['pickerMetadata'] as Map?)?.cast<String, dynamic>() ?? {};
        final dateValues = _generateDateValues(pickerMeta);
        // Prefer a date from the current year to minimise year-picker navigation
        final currentYear = DateTime.now().year.toString();
        final validDate = dateValues.firstWhere(
          (v) => v != 'null' && v.contains(currentYear),
          orElse: () =>
              dateValues.firstWhere((v) => v != 'null', orElse: () => ''),
        );
        if (validDate.isNotEmpty) {
          stepsByKey[key] = [
            {
              'tap': {'byKey': key}
            },
            {'pumpAndSettle': true},
            {'selectDate': validDate},
            {'pumpAndSettle': true},
          ];
        }
      }
      for (final key in timePickerKeys) {
        stepsByKey[key] = [
          {
            'tap': {'byKey': key}
          },
          {'pumpAndSettle': true},
          {'selectTime': '09:00'},
          {'pumpAndSettle': true},
        ];
      }
      return stepsByKey;
    }

    List<Map<String, dynamic>> buildOrderedSteps(
        Map<String, List<Map<String, dynamic>>> stepsByKey) {
      final sortedWidgets = List<Map<String, dynamic>>.from(widgets)
        ..sort((a, b) =>
            (a['key'] ?? '').toString().compareTo((b['key'] ?? '').toString()));
      final steps = <Map<String, dynamic>>[];
      for (final w in sortedWidgets) {
        final k = (w['key'] ?? '').toString();
        if (stepsByKey.containsKey(k)) steps.addAll(stepsByKey[k]!);
      }
      return steps;
    }

    // ── STEP 15: Empty All Fields ──────────────────────────────────────────────

    Map<String, dynamic> buildEdgeCaseEmptyFields() {
      final expectedMsgsCount = <String, int>{};
      for (final w in widgets) {
        try {
          final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
          final rules =
              (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
          for (final rule in rules) {
            if (rule is Map) {
              final condition = rule['condition']?.toString() ?? '';
              final msg = rule['message']?.toString() ?? '';
              if (msg.isNotEmpty && isEmptyCheckCondition(condition)) {
                expectedMsgsCount[msg] = (expectedMsgsCount[msg] ?? 0) + 1;
              }
            }
          }
          if (rules.isEmpty) {
            final v = (meta['validatorMessages'] as List?)?.cast<dynamic>() ??
                const [];
            for (final m in v) {
              final s = m?.toString() ?? '';
              if (s.isNotEmpty &&
                  (s.toLowerCase().contains('required') ||
                      s.contains('กรุณา') ||
                      s.contains('โปรด') ||
                      s.contains('ต้อง') ||
                      s.toLowerCase().contains('please') ||
                      s.toLowerCase().contains('cannot be empty') ||
                      s.toLowerCase().contains('is required'))) {
                expectedMsgsCount[s] = (expectedMsgsCount[s] ?? 0) + 1;
                break;
              }
            }
          }
        } catch (_) {}
      }
      if (expectedMsgsCount.isEmpty && textKeys.isNotEmpty) {
        for (final _ in textKeys) {
          expectedMsgsCount['Required'] =
              (expectedMsgsCount['Required'] ?? 0) + 1;
        }
      }
      final emptyAsserts = [
        for (final entry in expectedMsgsCount.entries)
          {'text': entry.key, 'exists': true, 'count': entry.value}
      ];
      final emptySteps = <Map<String, dynamic>>[];
      if (endKey != null) {
        emptySteps.add({
          'tap': {'byKey': endKey}
        });
        emptySteps.add({'pumpAndSettle': true});
      }
      final emptyCombo = <String, String>{
        ...buildNonTextDefaultCombo(),
        for (final k in textKeys) k: 'empty',
      };
      return {
        'tc': 'edge_cases_empty_all_fields',
        'kind': 'failed',
        'group': 'edge_cases',
        'description':
            _buildDescription(emptyCombo, 'failed', [], [], emptyAsserts),
        'steps': emptySteps,
        'asserts': emptyAsserts,
      };
    }

    // ── STEP 15b: Boundary at Max Length ───────────────────────────────────────

    Map<String, dynamic>? buildEdgeCaseBoundaryAtMax() {
      final hasAnyAtMax = textKeys.any((k) => datasetsHasField(k, 'atMax'));
      if (!hasAnyAtMax || endKey == null) return null;

      final maxStepsByKey = buildNonTextDefaultSteps();
      for (final key in textKeys) {
        final dsField = datasetsHasField(key, 'atMax') ? 'atMax' : 'valid';
        final hasDs = datasetsHasField(key, dsField);
        final enterStep = hasDs
            ? {
                'enterText': {'byKey': key, 'dataset': 'byKey.$key[0].$dsField'}
              }
            : {
                'enterText': {'byKey': key, 'text': 'Test'}
              };
        maxStepsByKey[key] = [
          enterStep,
          {'pump': true}
        ];
      }
      final maxSteps = buildOrderedSteps(maxStepsByKey)
        ..add({
          'tap': {'byKey': endKey}
        })
        ..add({'pumpAndSettle': true});
      final maxAsserts = buildSuccessAsserts();
      final maxCombo = <String, String>{
        ...buildNonTextDefaultCombo(),
        for (final k in textKeys)
          k: datasetsHasField(k, 'atMax') ? 'atMax' : 'valid',
      };
      return {
        'tc': 'edge_cases_boundary_at_max_length',
        'kind': 'success',
        'group': 'edge_cases',
        'description':
            _buildDescription(maxCombo, 'success', [], [], maxAsserts),
        'steps': maxSteps,
        'asserts': maxAsserts,
      };
    }

    // ── STEP 15b: Boundary at Min Length ───────────────────────────────────────

    Map<String, dynamic>? buildEdgeCaseBoundaryAtMin() {
      if (textKeys.isEmpty || endKey == null) return null;

      // Detect if any atMin value is actually invalid (fails form validation)
      bool minHasInvalidFields = false;
      for (final key in textKeys) {
        if (!datasetsHasField(key, 'atMin')) continue;
        final ds =
            (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};
        final arr = ds[key];
        if (arr is! List || arr.isEmpty) continue;
        final first = arr[0] as Map?;
        if (first == null) continue;
        final atMinVal = first['atMin']?.toString() ?? '';
        final invalidVal = first['invalid']?.toString() ?? '';
        // Case 1: atMin equals the invalid dataset value
        if (atMinVal == invalidVal && atMinVal.isNotEmpty) {
          minHasInvalidFields = true;
          break;
        }
        // Case 2: atMin is empty → check if field has a required validator
        if (atMinVal.isEmpty) {
          final widget = widgets.firstWhere((w) => (w['key'] ?? '') == key,
              orElse: () => <String, dynamic>{});
          final meta =
              (widget['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
          final rules =
              (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
          for (final rule in rules) {
            if (rule is Map) {
              final condition = rule['condition']?.toString() ?? '';
              if (isEmptyCheckCondition(condition)) {
                minHasInvalidFields = true;
                break;
              }
            }
          }
          if (minHasInvalidFields) break;
        }
      }

      final minStepsByKey = buildNonTextDefaultSteps();
      for (final key in textKeys) {
        final enterStep = datasetsHasField(key, 'atMin')
            ? {
                'enterText': {'byKey': key, 'dataset': 'byKey.$key[0].atMin'}
              }
            : {
                'enterText': {'byKey': key, 'text': ''}
              };
        minStepsByKey[key] = [
          enterStep,
          {'pump': true}
        ];
      }
      final minSteps = buildOrderedSteps(minStepsByKey)
        ..add({
          'tap': {'byKey': endKey}
        })
        ..add({'pumpAndSettle': true});
      final minKind = minHasInvalidFields ? 'failed' : 'success';
      final minAsserts = <Map<String, dynamic>>[
        if (minHasInvalidFields)
          for (final fk in expectedFailKeys) buildAssert(fk)
        else
          ...buildSuccessAsserts()
      ];
      final minCombo = <String, String>{
        ...buildNonTextDefaultCombo(),
        for (final k in textKeys)
          k: datasetsHasField(k, 'atMin') ? 'atMin' : 'empty',
      };
      return {
        'tc': 'edge_cases_boundary_at_min_length',
        'kind': minKind,
        'group': 'edge_cases',
        'description':
            _buildDescription(minCombo, minKind, [], [], minAsserts),
        'steps': minSteps,
        'asserts': minAsserts,
      };
    }

    // ── STEP 15c: Group all edge case builders ────────────────────────────────────

    void _buildAllEdgeCases() {
      cases.add(buildEdgeCaseEmptyFields());

      final maxCase = buildEdgeCaseBoundaryAtMax();
      if (maxCase != null) cases.add(maxCase);

      final minCase = buildEdgeCaseBoundaryAtMin();
      if (minCase != null) cases.add(minCase);
    }

    _buildAllEdgeCases();

    // ---------------------------------------------------------------------------
    // STEP 16: เขียน Output File
    // ---------------------------------------------------------------------------

    _writeTestDataFile(uiFile, source, datasets, cases);
  }

  void _writeTestDataFile(
    String uiFile,
    Map<String, dynamic> source,
    Map<String, dynamic> datasets,
    List<Map<String, dynamic>> cases,
  ) {
    final plan = <String, dynamic>{
      'source': source,
      'datasets': datasets,
      'cases': cases,
    };

    final outPath =
        'output/test_data/${utils.basenameWithoutExtension(uiFile)}.testdata.json';

    File(outPath).createSync(recursive: true);
    File(outPath).writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(plan) + '\n');
    stdout.writeln('✓ fullpage plan: $outPath');
  }

  // =========================================================================
  // NOTE: _basename, _basenameWithoutExtension ถูกย้ายไปใช้จาก utils.dart
  // =========================================================================

  // =========================================================================
  // PICT MODEL GENERATION
  // =========================================================================

  /// พยายามสร้าง PICT model จาก manifest file
  ///
  /// อ่าน manifest file และสร้าง PICT model files สำหรับ pairwise testing
  ///
  /// Parameters:
  ///   [uiFile]      - path ของ UI file (เช่น lib/demos/register_page.dart)
  ///   [pictBin]     - path ของ PICT binary
  ///   [constraints] - PICT constraints string (optional)
  ///
  /// Output files:
  ///   - output/model_pairwise/<page>.full.model.txt
  ///   - output/model_pairwise/<page>.full.result.txt
  ///   - output/model_pairwise/<page>.valid.model.txt
  ///   - output/model_pairwise/<page>.valid.result.txt
  Future<void> _tryWritePictModelFromManifestForUi(String uiFile,
      {String pictBin = './pict', String? constraints}) async {
    // ดึงชื่อไฟล์โดยไม่มี extension
    final base = utils.basenameWithoutExtension(uiFile);

    // ---------------------------------------------------------------------------
    // คำนวณ subfolder path จาก uiFile
    // ตัวอย่าง: lib/demos/register_page.dart → demos
    // ---------------------------------------------------------------------------

    final normalizedPath =
        uiFile.replaceAll('\\', '/'); // normalize path separators
    String subfolderPath = '';

    if (normalizedPath.startsWith('lib/')) {
      // ดึง path หลัง 'lib/'
      final pathAfterLib = normalizedPath.substring(4);
      // หา last slash เพื่อแยก folder และ filename
      final lastSlash = pathAfterLib.lastIndexOf('/');
      if (lastSlash > 0) {
        subfolderPath = pathAfterLib.substring(0, lastSlash);
      }
    }

    // ---------------------------------------------------------------------------
    // กำหนด manifest path
    // ---------------------------------------------------------------------------

    final manifestPath = subfolderPath.isNotEmpty
        ? 'output/manifest/$subfolderPath/$base.manifest.json' // มี subfolder
        : 'output/manifest/$base.manifest.json'; // ไม่มี subfolder

    final f = File(manifestPath);

    // ถ้าไม่มี manifest ให้ข้ามไป (silently)
    if (!f.existsSync()) return;

    // ---------------------------------------------------------------------------
    // อ่านและ parse manifest
    // ---------------------------------------------------------------------------

    final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    final widgets =
        (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    // ---------------------------------------------------------------------------
    // ดึง factors และ required checkboxes จาก manifest
    // ใช้ pict_generator module
    // ---------------------------------------------------------------------------

    final pictGen = pict.GeneratorPict(pictBin: pictBin);

    final extractionResult = pictGen.extractFactorsFromManifest(widgets);
    final factors = extractionResult.factors;
    final requiredCheckboxes = extractionResult.requiredCheckboxes;

    // ถ้าไม่มี factors ให้ข้ามไป
    if (factors.isEmpty) return;

    // ---------------------------------------------------------------------------
    // สร้างและเขียน PICT model files
    // ---------------------------------------------------------------------------

    stderr.writeln('[DEBUG] _tryWritePictModelFromManifestForUi - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}, '
        'factors: ${factors.length}');

    await pictGen.writePictModelFiles(
      factors: factors,
      pageBaseName: base,
      requiredCheckboxes: requiredCheckboxes,
      constraints: constraints,
    );
  }

  // =========================================================================
  // HELPER FUNCTIONS - Dropdown Options
  // =========================================================================

  /// ดึง options จาก dropdown metadata
  ///
  /// รองรับหลาย formats:
  ///   - List ของ Maps: [{value: "v1", text: "Text 1"}, ...]
  ///   - List ของ strings: ["opt1", "opt2", ...]
  ///
  /// Parameter:
  ///   [raw] - raw options data จาก metadata
  ///
  /// Returns:
  ///   List<String> - list ของ option values (cleaned for PICT compatibility)
  List<String> _optionsFromMeta(dynamic raw) {
    final out = <String>[];

    if (raw is List) {
      // วนลูปแต่ละ entry
      for (final entry in raw) {
        if (entry is Map) {
          // Format: {value: "...", text: "...", label: "..."}
          // ใช้ value field ก่อน (PICT compatible - ASCII only)
          final value = entry['value']?.toString();
          final text = entry['text']?.toString();
          final label = entry['label']?.toString();

          // เลือก field ที่มีค่า
          final chosen = (value != null && value.isNotEmpty)
              ? value
              : (text != null && text.isNotEmpty)
                  ? text
                  : label;

          if (chosen != null && chosen.isNotEmpty) {
            // แทนที่ spaces ด้วย underscores สำหรับ PICT compatibility
            final cleaned = chosen.replaceAll(' ', '_');
            out.add(cleaned);
          }
        } else if (entry != null) {
          // Format: string โดยตรง
          final s = entry.toString();
          if (s.isNotEmpty) {
            final cleaned = s.replaceAll(' ', '_');
            out.add(cleaned);
          }
        }
      }
    }

    return out;
  }
}

// =============================================================================
// MAIN FUNCTION - Entry Point
// =============================================================================

/// Entry point ของ script เมื่อรันจาก command line
///
/// ต้องระบุ manifest file path เป็น argument
///
/// Parameter:
///   [args] - List ของ command line arguments
///            ต้องมี path ที่ลงท้ายด้วย .manifest.json อย่างน้อย 1 ไฟล์
void main(List<String> args) async {
  // ---------------------------------------------------------------------------
  // Default Settings - ค่าคงที่สำหรับการประมวลผล
  // ---------------------------------------------------------------------------

  const String pictBin =
      './pict'; // path ของ PICT binary (relative to project root)

  // List เก็บ paths ของไฟล์ที่จะประมวลผล
  final inputs = <String>[];

  // ---------------------------------------------------------------------------
  // PICT Constraints File (Optional)
  // ---------------------------------------------------------------------------
  // ไฟล์ constraints ใช้สำหรับกำหนดเงื่อนไขเพิ่มเติมให้ PICT
  // เช่น:
  //   IF [dropdown] = "option1" THEN [checkbox] <> "unchecked";
  //   IF [textField] = "empty" THEN [submitButton] = "disabled";
  //
  // ส่งผ่าน command line: --constraints-file <path>
  // ---------------------------------------------------------------------------
  String? constraintsFile;

  // ---------------------------------------------------------------------------
  // Parse Command Line Arguments
  // ---------------------------------------------------------------------------
  // รองรับ arguments:
  //   <manifest.json>              - ไฟล์ manifest ที่ต้องการประมวลผล
  //   --constraints-file <path>    - ไฟล์ PICT constraints (optional)
  //   --verbose                    - แสดง stack trace เมื่อเกิด error
  // ---------------------------------------------------------------------------

  // วนลูปตรวจสอบแต่ละ argument (ใช้ index-based loop เพราะต้อง skip argument)
  for (var i = 0; i < args.length; i++) {
    final arg = args[i];

    // ตรวจสอบ --constraints-file argument
    // Format: --constraints-file <path>
    if (arg == '--constraints-file' && i + 1 < args.length) {
      constraintsFile = args[i + 1]; // เก็บ path ของ constraints file
      i++; // ข้าม argument ถัดไป (เพราะเป็น file path)
    }
    // รับเฉพาะไฟล์ .manifest.json
    else if (arg.endsWith('.manifest.json')) {
      inputs.add(arg);
    } else if (!arg.startsWith('--')) {
      // แจ้งเตือนถ้า argument ไม่ใช่ manifest file (และไม่ใช่ flag)
      stderr.writeln('Warning: Ignoring unrecognized argument: $arg');
    }
  }

  // ---------------------------------------------------------------------------
  // Load Constraints from File
  // ---------------------------------------------------------------------------
  // อ่าน constraints จากไฟล์ถ้ามีการระบุ --constraints-file
  // Constraints จะถูกส่งต่อไปให้ PICT tool เพื่อ:
  //   - กำหนด invalid combinations
  //   - กำหนด dependencies ระหว่าง parameters
  //   - ลด test cases ที่ไม่ต้องการ
  // ---------------------------------------------------------------------------
  String? constraints;
  if (constraintsFile != null) {
    final file = File(constraintsFile);
    if (file.existsSync()) {
      // อ่านเนื้อหาทั้งหมดจากไฟล์
      constraints = file.readAsStringSync();
      stdout.writeln('Loaded constraints from: $constraintsFile');
    } else {
      // แจ้งเตือนถ้าไฟล์ไม่พบ (ไม่ใช่ error เพราะ constraints เป็น optional)
      stderr.writeln('Warning: Constraints file not found: $constraintsFile');
    }
  }

  // ---------------------------------------------------------------------------
  // Validate: ต้องมี manifest file อย่างน้อย 1 ไฟล์
  // ---------------------------------------------------------------------------

  if (inputs.isEmpty) {
    stderr.writeln('Error: No manifest file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_test_data.dart <manifest.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_test_data.dart output/manifest/demos/buttons_page.manifest.json');
    exit(1);
  }

  // ---------------------------------------------------------------------------
  // Process Each Manifest File
  // ---------------------------------------------------------------------------

  // ตัวนับสำหรับ summary
  int successCount = 0; // จำนวนที่สำเร็จ
  int errorCount = 0; // จำนวนที่ล้มเหลว

  final generator = TestDataGenerator(pictBin: pictBin);

  // วนลูปประมวลผลแต่ละไฟล์
  for (final path in inputs) {
    try {
      // เรียก generateTestData เพื่อประมวลผล manifest
      await generator.generateTestData(
        path,
        constraints: constraints,
      );
      successCount++; // เพิ่มตัวนับถ้าสำเร็จ
    } catch (e, st) {
      // จับ error และแสดง message
      stderr.writeln('✗ Failed to process $path: $e');
      // แสดง stack trace ถ้ามี --verbose flag
      if (args.contains('--verbose')) {
        stderr.writeln(st);
      }
      errorCount++; // เพิ่มตัวนับ error
    }
  }

  // ---------------------------------------------------------------------------
  // Print Summary (ถ้าประมวลผลหลายไฟล์)
  // ---------------------------------------------------------------------------

  if (inputs.length > 1) {
    stdout.writeln('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    stdout.writeln('Summary: $successCount succeeded, $errorCount failed');
    stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // Exit with error code ถ้ามี error
  if (errorCount > 0) {
    exit(1);
  }
}
