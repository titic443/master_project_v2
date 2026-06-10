import 'dart:convert';

import 'dart:io';

import 'generator_pict.dart' as pict;

import 'utils.dart' as utils;

Future<String> generateTestDataFromManifest(
  String manifestPath, {
  String? pictBin,
  String? constraints,
}) =>
    TestDataGenerator(pictBin: pictBin)
        .generateTestData(manifestPath, constraints: constraints);

class TestDataGenerator {
  final String pictBin;

  TestDataGenerator({String? pictBin})
      : pictBin = pictBin ??
            (File('/.dockerenv').existsSync()
                ? '/usr/local/bin/pict'
                : './pict');

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

    return 'output/test_data/${utils.basenameWithoutExtension(uiFile)}.test_data.json';
  }

  Future<void> _processOne(String path,
      {bool pairwiseUsePict = false,
      String pictBin = './pict',
      String? constraints}) async {
    final pictGen = pict.GeneratorPict(pictBin: pictBin);

    final raw = File(path).readAsStringSync();

    final j = jsonDecode(raw) as Map<String, dynamic>;

    final source = (j['source'] as Map<String, dynamic>?) ?? const {};

    final uiFile = (source['file'] as String?) ?? 'lib/unknown.dart';

    stderr.writeln('[DEBUG] _processOne - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}');
    try {
      await _tryWritePictModelFromManifestForUi(uiFile,
          pictBin: pictBin, constraints: constraints);
    } catch (e) {
      stderr.writeln('! Failed to write PICT model from manifest: $e');
    }

    final widgets =
        (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    Map<String, dynamic> _convertDatasetsToOldFormat(
        Map<String, dynamic> byKey) {
      return Map<String, dynamic>.from(byKey);
    }

    final datasets = {
      'defaults': <String, dynamic>{},
      'byKey': <String, dynamic>{},
    };

    try {
      final extPath =
          'output/test_data/${utils.basenameWithoutExtension(uiFile)}.datasets.json';
      final f = File(extPath);

      if (f.existsSync()) {
        final ext = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;

        final extDatasets = (ext['datasets'] as Map?)?.cast<String, dynamic>();
        final extByKey =
            (extDatasets?['byKey'] as Map?)?.cast<String, dynamic>();

        if (extByKey != null) {
          final converted = _convertDatasetsToOldFormat(extByKey);
          (datasets['byKey'] as Map<String, dynamic>).addAll(converted);
        }
      }
    } catch (_) {
      // ignore errors - จะใช้ datasets เปล่าแทน
    }

    int _extractSequence(String key) {
      if (key.isEmpty) return -1;

      final parts = key.split('_');
      if (parts.length < 2) return -1;

      final secondPart = parts[1];
      final seq = int.tryParse(secondPart);
      if (seq != null) return seq;

      for (final part in parts) {
        final num = int.tryParse(part);
        if (num != null) return num;
      }

      return -1;
    }

    String? _findHighestSequenceButton(List<Map<String, dynamic>> widgets) {
      String? highestKey;
      int highestSeq = -1;

      for (final w in widgets) {
        final t = (w['widgetType'] ?? '').toString();
        final k = (w['key'] ?? '').toString();

        if ((t == 'ElevatedButton' ||
                t == 'TextButton' ||
                t == 'OutlinedButton') &&
            k.isNotEmpty) {
          final seq = _extractSequence(k);
          if (seq > highestSeq) {
            highestSeq = seq;
            highestKey = k;
          }
        }
      }

      return highestKey;
    }

    String? endKey = _findHighestSequenceButton(widgets);

    final expectedSuccessKeys = <String>{};
    final expectedFailKeys = <String>{};
    final dialogKeys = <String>{};

    const dialogWidgetTypes = {'AlertDialog', 'SimpleDialog'};

    final textKeys = <String>[];
    final radioKeys = <String>[];
    final checkboxKeys = <String>[];
    final switchKeys = <String>[];
    final sliderKeys = <String>[];
    final primaryButtons = <String>[];
    final datePickerKeys = <String>[];
    final timePickerKeys = <String>[];

    for (final w in widgets) {
      final k = (w['key'] ?? '').toString();
      final t = (w['widgetType'] ?? '').toString();
      final isDialog = dialogWidgetTypes.contains(t);

      if (k.contains('_expected_success') || k.contains('_dialog_success')) {
        expectedSuccessKeys.add(k);
        if (isDialog) dialogKeys.add(k);
      }
      if (k.contains('_expected_fail') || k.contains('_dialog_fail')) {
        expectedFailKeys.add(k);
        if (isDialog) dialogKeys.add(k);
      }
    }

    Map<String, dynamic> buildAssert(String key, {bool exists = true}) {
      final base = <String, dynamic>{'byKey': key, 'exists': exists};
      if (dialogKeys.contains(key)) base['dismiss'] = true;
      return base;
    }

    final hasEndButton = endKey != null;

    // Fallback: derive success key from endKey prefix when manifest has no _expected_success key.
    final String? _fallbackSuccessKey =
        (expectedSuccessKeys.isEmpty && endKey != null)
            ? '${endKey.split('_').first}_expected_success'
            : null;

    List<Map<String, dynamic>> buildSuccessAsserts() {
      if (expectedSuccessKeys.isNotEmpty) {
        return [for (final sk in expectedSuccessKeys) buildAssert(sk)];
      } else if (_fallbackSuccessKey != null) {
        return [
          {'byKey': _fallbackSuccessKey, 'exists': true}
        ];
      }
      return [];
    }

    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      final k = (w['key'] ?? '').toString();
      final pickerMeta = w['pickerMetadata'] as Map?;

      if ((t.startsWith('TextField') || t.startsWith('TextFormField')) &&
          k.isNotEmpty &&
          pickerMeta == null) {
        textKeys.add(k);
      } else if (t.startsWith('Radio') && k.isNotEmpty) {
        radioKeys.add(k);
      } else if ((t.startsWith('Checkbox') || t == 'CheckboxListTile') &&
          k.isNotEmpty) {
        checkboxKeys.add(k);
      } else if ((t == 'Switch' || t == 'SwitchListTile') && k.isNotEmpty) {
        switchKeys.add(k);
      } else if (t == 'Slider' && k.isNotEmpty) {
        sliderKeys.add(k);
      } else if ((t == 'ElevatedButton' ||
              t == 'TextButton' ||
              t == 'OutlinedButton') &&
          k.isNotEmpty &&
          k != endKey) {
        primaryButtons.add(k);
      } else if (pickerMeta != null && k.isNotEmpty) {
        final pickerType = (pickerMeta['type'] ?? '').toString();
        if (pickerType == 'DatePicker') {
          datePickerKeys.add(k);
        } else if (pickerType == 'TimePicker') {
          timePickerKeys.add(k);
        }
      }
    }

    for (final w in widgets) {
      final k = (w['key'] ?? '').toString();
      final isOption = (k.endsWith('_radio') ||
              k.contains('_yes_radio') ||
              k.contains('_no_radio')) &&
          !k.contains('_radio_group');
      if (isOption && !radioKeys.contains(k)) radioKeys.add(k);
    }

    bool isEmptyCheckCondition(String condition) {
      final normalized = condition.toLowerCase().replaceAll(' ', '');
      // normalized patterns that indicate an isEmpty/null check
      return normalized.contains('value==null') ||
          normalized.contains('value.isempty') ||
          normalized.contains('valuenull') ||
          normalized.contains('valueisempty') ||
          normalized.contains('v==null') ||
          normalized.contains('v.isempty') ||
          normalized.contains('v.trim().isempty');
    }

    List<String> _generateDateValues(Map<String, dynamic> pickerMeta) {
      final values = <String>[];

      final firstDateStr = (pickerMeta['firstDate'] ?? '').toString();
      final lastDateStr = (pickerMeta['lastDate'] ?? '').toString();

      DateTime? firstDate;
      DateTime? lastDate;
      final now = DateTime.now();

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

      firstDate ??= DateTime(2000);
      lastDate ??= DateTime(2030);

      values.add('null');

      final pastDate = DateTime(
        firstDate.year + 1,
        firstDate.month,
        15.clamp(1, 28),
      );
      if (pastDate.isAfter(firstDate) && pastDate.isBefore(lastDate)) {
        values.add(
            '${pastDate.day.toString().padLeft(2, '0')}/${pastDate.month.toString().padLeft(2, '0')}/${pastDate.year}');
      }

      if (now.isAfter(firstDate) && now.isBefore(lastDate)) {
        values.add(
            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}');
      }

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

      final currentYear = DateTime.now().year.toString();
      final validDate = nonNullDates.firstWhere(
        (v) => v.contains(currentYear),
        orElse: () => nonNullDates[nonNullDates.length ~/ 2],
      );

      final firstDate = parseDateStr(
          (pickerMeta['firstDate'] ?? '').toString(), DateTime(2000));
      final lastDate = parseDateStr(
          (pickerMeta['lastDate'] ?? '').toString(), DateTime(2030));
      final atMinDate = formatDate(firstDate);
      final atMaxDate = formatDate(lastDate);

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

      (datasets['byKey'] as Map<String, dynamic>)[key] = <dynamic>[
        <String, dynamic>{
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

      // Preserve AI datasets for TimePicker valid value; only override invalidRuleMessages.
      final existingTime = (datasets['byKey'] as Map<String, dynamic>)[key];
      final existingTimeEntry =
          (existingTime is List && existingTime.isNotEmpty)
              ? (existingTime[0] as Map?)
              : null;
      final aiValidTime = existingTimeEntry?['valid']?.toString() ?? '';
      (datasets['byKey'] as Map<String, dynamic>)[key] = <dynamic>[
        <String, dynamic>{
          'valid': aiValidTime.isNotEmpty ? aiValidTime : '09:00',
          'invalid': '',
          'invalidRuleMessages': requiredMsg,
          'atMin': existingTimeEntry?['atMin']?.toString() ?? '00:00',
          'atMax': existingTimeEntry?['atMax']?.toString() ?? '23:59',
        }
      ];
    }

    // *** Format A override must run AFTER the DatePicker/TimePicker dataset block above ***
    // because that block overwrites picker datasets with invalid = '' — Format A overrides
    // must take highest priority and run last.
    if (constraints != null && constraints.trim().isNotEmpty) {
      final byKey = datasets['byKey'] as Map<String, dynamic>;

      for (final rawLine in constraints.split('\n')) {
        final line = rawLine.trim();
        if (line.isEmpty || line.startsWith('#')) continue;
        if (line.toUpperCase().contains('IF') &&
            line.toUpperCase().contains('THEN')) continue;

        final eqIdx = line.indexOf('=');
        if (eqIdx <= 0) continue;

        final lhs = line.substring(0, eqIdx).trim();
        final rhs = line.substring(eqIdx + 1).trim();

        final dotIdx = lhs.indexOf('.');
        final key = dotIdx > 0 ? lhs.substring(0, dotIdx) : lhs;
        final slot = dotIdx > 0 ? lhs.substring(dotIdx + 1) : 'valid';

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

    final numberFieldKeys = <String>[];
    for (final w in widgets) {
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      if (meta['keyboardType']?.toString() == 'number') {
        numberFieldKeys.add((w['key'] ?? '').toString());
      }
    }

    if (numberFieldKeys.isNotEmpty) {
      final byKey = (datasets['byKey'] as Map<String, dynamic>);
      for (final key in numberFieldKeys) {
        final arr = byKey[key];
        if (arr is List && arr.isNotEmpty && arr[0] is Map) {
          final entry = Map<String, dynamic>.from(arr[0] as Map);
          final invalidVal = entry['invalid']?.toString() ?? '';
          final invalidRuleMsg = entry['invalidRuleMessages']?.toString() ?? '';
          if (invalidVal.isNotEmpty &&
              int.tryParse(invalidVal) != null &&
              invalidRuleMsg.isEmpty) {
            entry['invalid'] = '';
            byKey[key] = [entry];
          }
        }
      }

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
          for (final key in numberFieldKeys) {
            if (byKey.containsKey(key)) {
              extByKey[key] = byKey[key];
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

    final requiredCheckboxValidation = <String, String>{};

    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      final k = (w['key'] ?? '').toString();

      if (t.startsWith('FormField<bool>') && k.isNotEmpty) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final rules =
            (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];

        for (final rule in rules) {
          if (rule is Map) {
            final condition = rule['condition']?.toString() ?? '';
            final message = rule['message']?.toString() ?? '';

            final normalized = condition.toLowerCase().replaceAll(' ', '');
            if (normalized.contains('!value') ||
                normalized.contains('value==false') ||
                (normalized.contains('value==null') &&
                    normalized.contains('||!value'))) {
              final checkboxKey = k.replaceAll('_formfield', '_checkbox');
              requiredCheckboxValidation[checkboxKey] = message;
              break;
            }
          }
        }
      }

      // Checkbox widget ที่มี validatorRules propagate มาจาก FormField<bool>
      // (key อยู่บน Checkbox โดยตรง ไม่ใช่บน FormField)
      // รองรับทั้ง "value" และ "v" เป็นชื่อ param ใน validator
      if ((t == 'Checkbox' || t == 'CheckboxListTile') && k.isNotEmpty &&
          !requiredCheckboxValidation.containsKey(k)) {
        final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        final rules =
            (meta['validatorRules'] as List?)?.cast<dynamic>() ?? const [];
        for (final rule in rules) {
          if (rule is Map) {
            final condition = rule['condition']?.toString() ?? '';
            final message = rule['message']?.toString() ?? '';
            final normalized = condition
                .toLowerCase()
                .replaceAll(' ', '')
                .replaceAll('\n', '');
            if (message.isNotEmpty &&
                (normalized.contains('!value') ||
                    normalized.contains('value==false') ||
                    normalized.contains('value==null') ||
                    normalized.contains('||!v') ||
                    normalized.contains('v==false') ||
                    normalized.contains('v==null'))) {
              requiredCheckboxValidation[k] = message;
              break;
            }
          }
        }
      }
    }

    final radioGroupValidation = <String, String>{};
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      if (!t.startsWith('Radio<')) continue;
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final groupBinding = meta['groupValueBinding']?.toString() ?? '';
      if (groupBinding.isEmpty ||
          radioGroupValidation.containsKey(groupBinding)) continue;
      final rules = (meta['validatorRules'] as List?) ?? const [];
      for (final rule in rules) {
        if (rule is Map) {
          final msg = rule['message']?.toString() ?? '';
          if (msg.isNotEmpty) {
            radioGroupValidation[groupBinding] = msg;
            break;
          }
        }
      }
    }

    final requiredSwitchValidation = <String, String>{};
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      if (t != 'Switch' && t != 'SwitchListTile') continue;
      final k = (w['key'] ?? '').toString();
      if (k.isEmpty) continue;
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rules = (meta['validatorRules'] as List?) ?? const [];
      for (final rule in rules) {
        if (rule is Map) {
          final msg = rule['message']?.toString() ?? '';
          final condition = rule['condition']?.toString() ?? '';
          final norm = condition.toLowerCase().replaceAll(' ', '');
          if (msg.isNotEmpty &&
              (norm.contains('!value') ||
                  norm.contains('value==false') ||
                  norm.contains('value==null') ||
                  norm.contains('value!=true'))) {
            requiredSwitchValidation[k] = msg;
            break;
          }
        }
      }
    }

    final requiredSliderValidation = <String, Map<String, dynamic>>{};
    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();
      if (t != 'Slider') continue;
      final k = (w['key'] ?? '').toString();
      if (k.isEmpty) continue;
      final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
      final rules = (meta['validatorRules'] as List?) ?? const [];
      if (rules.isEmpty) continue;
      final firstRule = rules.first;
      final msg =
          firstRule is Map ? (firstRule['message']?.toString() ?? '') : '';
      if (msg.isNotEmpty) {
        final minVal = (meta['min'] as num?)?.toDouble() ?? 0.0;
        requiredSliderValidation[k] = {
          'message': msg,
          'minValue': minVal.round().toString(),
        };
      }
    }

    String? dropdownKey;
    final dropdownValues = <String>[];
    final dropdownKeys = <String>[];
    final dropdownValuesList = <List<String>>[];
    final dropdownValueToTextMaps = <Map<String, String>>[];

    for (final w in widgets) {
      final t = (w['widgetType'] ?? '').toString();

      if (t.contains('DropdownButton')) {
        final k = (w['key'] ?? '').toString();
        if (k.isNotEmpty) {
          dropdownKeys.add(k);
          if (dropdownKey == null) dropdownKey = k;
        }

        try {
          final meta = (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
          final list = _optionsFromMeta(meta['options']);
          dropdownValuesList.add(list);

          if (dropdownValues.isEmpty) {
            dropdownValues.addAll(list);
          }

          final valueToText = <String, String>{};
          final options = meta['options'];
          if (options is List) {
            for (final opt in options) {
              if (opt is Map) {
                final value = opt['value']?.toString();
                final text = opt['text']?.toString();
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
          dropdownValueToTextMaps.add(<String, String>{});
        }
      }
    }

    final cases = <Map<String, dynamic>>[];

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
        if (raw == 'checked' || raw == 'unchecked' || raw == 'unselected') {
          value = raw;
        } else if (raw == 'valid' ||
            raw == 'invalid' ||
            raw == 'atMax' ||
            raw == 'atMin' ||
            raw == 'empty') {
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
                  : '""');
          // label§display — label กำหนดสี chip, display แสดงค่าจริง
          value = '$raw§$display';
        } else {
          value = _shortValue(raw);
        }
        parts.add('$field: $value');
      }
      if (parts.isEmpty)
        return kind == 'failed' ? 'expect failure' : 'all valid';
      return parts.join(', ');
    }

    Map<String, dynamic> _widgetMetaByKey(String key) {
      for (final w in widgets) {
        if ((w['key'] ?? '') == key) {
          return (w['meta'] as Map?)?.cast<String, dynamic>() ?? const {};
        }
      }
      return const {};
    }

    int? _maxLenFromMeta(Map<String, dynamic> meta) {
      final fmts = (meta['inputFormatters'] as List? ?? const []).cast<Map>();
      final lenFmt = fmts.firstWhere((f) => (f['type'] ?? '') == 'lengthLimit',
          orElse: () => {});
      if (lenFmt is Map && lenFmt['max'] is int) return lenFmt['max'] as int;

      if (meta['maxLength'] is int) return meta['maxLength'] as int;

      return null;
    }

    final pageBase = utils.basenameWithoutExtension(uiFile);

    final pageResultPath = 'output/model_pairwise/$pageBase.invalid.result.txt';
    final pageValidResultPath =
        'output/model_pairwise/$pageBase.valid.result.txt';
    final pageModelPath = 'output/model_pairwise/$pageBase.invalid.model.txt';

    final hasPictModel = File(pageModelPath).existsSync();

    if (hasPictModel) {
      List<Map<String, String>>? extCombos;
      List<Map<String, String>>? extValidCombos;
      Map<String, List<String>>? modelFactors;
      final factorTypes = <String, String>{};

      String? radioKeyForSuffix(List<String> keys, String suffix) {
        if (suffix.isEmpty) return null;
        final hit = keys.firstWhere(
            (k) => k.endsWith('_$suffix') || k.endsWith(suffix),
            orElse: () => '');
        return hit.isEmpty ? null : hit;
      }

      // อ่าน PICT model file แล้ว parse factors/types/constraints พร้อม load invalid+valid combinations
      void loadPictAnalysis() {
        if (File(pageModelPath).existsSync()) {
          modelFactors =
              pictGen.parsePictModel(File(pageModelPath).readAsStringSync());
        }
        if (modelFactors != null) {
          for (final entry in modelFactors!.entries) {
            final name = entry.key;
            final values = entry.value;
            // datepicker/timepicker must be checked before text because
            // they use ['valid','invalid'] tokens like TextFields
            if (datePickerKeys.contains(name)) {
              factorTypes[name] = 'datepicker';
            } else if (timePickerKeys.contains(name)) {
              factorTypes[name] = 'timepicker';
            } else if (values.contains('invalid') || values.contains('valid')) {
              factorTypes[name] = 'text';
            } else if (values.contains('checked') &&
                values.contains('unchecked')) {
              factorTypes[name] = 'checkbox';
            } else if (values.contains('on') && values.contains('off')) {
              factorTypes[name] = 'switch';
            } else if (values.any((v) => v.endsWith('_radio')) ||
                radioKeys.any(
                    (rk) => values.any((v) => rk.endsWith('_$v') || rk == v))) {
              factorTypes[name] = 'radio';
            } else if (sliderKeys.contains(name)) {
              factorTypes[name] = 'slider';
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

      // วนแต่ละ pairwise-invalid combination แล้วสร้าง test case พร้อม steps, asserts, และ description
      Future<void> _buildPairwiseCases() async {
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

        List<Map<String, String>> combos;
        bool usingExternalCombos = false;
        final radioGroupBindings = <String, String>{};

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
              radioGroupBindings['Radio$radioIndex'] = entry.key;
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
            factors[key] = ['valid', 'invalid'];
          }
          for (final key in timePickerKeys) {
            factors[key] = ['valid', 'invalid'];
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

        for (int i = 0; i < combos.length; i++) {
          final c = combos[i];
          final st = <Map<String, dynamic>>[];
          bool hasInvalidData = false;
          final invalidFields = <String>[];
          final uncheckedRequiredCheckboxes = <String>[];
          final unselectedRadioGroups = <String>[];
          final offRequiredSwitches = <String>[];
          final invalidSliders = <String>[];

          if (usingExternalCombos) {
            final stepsByKey = <String, List<Map<String, dynamic>>>{};
            for (final factorName in c.keys) {
              final factorType = factorTypes[factorName];
              final rawPick = (c[factorName] ?? '').toString();
              final pick = rawPick.startsWith('"') && rawPick.endsWith('"')
                  ? rawPick.substring(1, rawPick.length - 1)
                  : rawPick;
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
                if (pick == 'unselected') {
                  hasInvalidData = true;
                  unselectedRadioGroups.add(factorName);
                } else {
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
                } else if (pick == 'off' &&
                    requiredSwitchValidation.containsKey(factorName)) {
                  hasInvalidData = true;
                  offRequiredSwitches.add(factorName);
                }
              } else if (factorType == 'slider') {
                final sliderData = requiredSliderValidation[factorName];
                if (sliderData != null && pick == sliderData['minValue']) {
                  hasInvalidData = true;
                  invalidSliders.add(factorName);
                }
                stepsByKey[factorName] = [
                  {
                    'setSliderValue': {'byKey': factorName, 'value': pick}
                  },
                  {'pump': true}
                ];
              } else if (datePickerKeys.contains(factorName)) {
                // Resolve 'valid'/'invalid' tokens from datasets.
                // Format A override (e.g. key.invalid = 04/06/2026) is respected here.
                String resolvedDate = pick;
                if (pick == 'valid' || pick == 'invalid') {
                  final ds =
                      (datasets['byKey'] as Map?)?.cast<String, dynamic>() ??
                          {};
                  final entry = ds[factorName];
                  if (pick == 'invalid') {
                    hasInvalidData = true;
                    invalidFields.add(factorName);
                  }
                  final map0 = entry is List && entry.isNotEmpty
                      ? entry[0] as Map?
                      : null;
                  final val = map0?[pick]?.toString() ?? '';
                  resolvedDate = val.isNotEmpty ? val : 'null';
                }
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pumpAndSettle': true},
                  {'selectDate': resolvedDate},
                  {'pumpAndSettle': true}
                ];
              } else if (timePickerKeys.contains(factorName)) {
                // Resolve 'valid'/'invalid' tokens from datasets.
                // Format A override (e.g. key.invalid = 16:59) is respected here.
                String resolvedTime = pick;
                if (pick == 'valid' || pick == 'invalid') {
                  final ds =
                      (datasets['byKey'] as Map?)?.cast<String, dynamic>() ??
                          {};
                  final entry = ds[factorName];
                  if (pick == 'invalid') {
                    hasInvalidData = true;
                    invalidFields.add(factorName);
                  }
                  final map0 = entry is List && entry.isNotEmpty
                      ? entry[0] as Map?
                      : null;
                  final val = map0?[pick]?.toString() ?? '';
                  resolvedTime = val.isNotEmpty ? val : 'null';
                }
                stepsByKey[factorName] = [
                  {
                    'tap': {'byKey': factorName}
                  },
                  {'pumpAndSettle': true},
                  {'selectTime': resolvedTime},
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
                final rawPick = (c[factorName] ?? '').toString();
                final pick = rawPick.startsWith('"') && rawPick.endsWith('"')
                    ? rawPick.substring(1, rawPick.length - 1)
                    : rawPick;
                if (pick == 'unselected') {
                  hasInvalidData = true;
                  final groupBinding =
                      radioGroupBindings[factorName] ?? factorName;
                  unselectedRadioGroups.add(groupBinding);
                } else if (pick.isNotEmpty) {
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
              final raw = (c[key] ?? '').toString();
              if (raw.isEmpty) continue;
              String dateVal = raw;
              if (raw == 'valid' || raw == 'invalid') {
                final ds =
                    (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};
                final entry = ds[key];
                if (raw == 'invalid') {
                  hasInvalidData = true;
                  invalidFields.add(key);
                }
                final map0 =
                    entry is List && entry.isNotEmpty ? entry[0] as Map? : null;
                final v = map0?[raw]?.toString() ?? '';
                dateVal = v.isNotEmpty ? v : 'null';
              }
              stepsByKey[key] = [
                {
                  'tap': {'byKey': key}
                },
                {'pumpAndSettle': true},
                {'selectDate': dateVal},
                {'pumpAndSettle': true}
              ];
            }
            for (int idx = 0; idx < timePickerKeys.length; idx++) {
              final key = timePickerKeys[idx];
              final raw = (c[key] ?? '').toString();
              if (raw.isEmpty) continue;
              String timeVal = raw;
              if (raw == 'valid' || raw == 'invalid') {
                final ds =
                    (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};
                final entry = ds[key];
                if (raw == 'invalid') {
                  hasInvalidData = true;
                  invalidFields.add(key);
                }
                final map0 =
                    entry is List && entry.isNotEmpty ? entry[0] as Map? : null;
                final v = map0?[raw]?.toString() ?? '';
                timeVal = v.isNotEmpty ? v : 'null';
              }
              stepsByKey[key] = [
                {
                  'tap': {'byKey': key}
                },
                {'pumpAndSettle': true},
                {'selectTime': timeVal},
                {'pumpAndSettle': true}
              ];
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
              'tap': {'byKey': endKey, 'isSubmit': true}
            });
            st.add({'pumpAndSettle': true});
          } else {
            st.add({'pump': true});
          }

          if (!hasInvalidData) continue;

          final caseKind = 'failed';
          final id = 'pairwise_invalid_cases_${i + 1}';
          final asserts = <Map<String, dynamic>>[];

          final ds =
              (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? const {};
          for (final fieldKey in invalidFields) {
            final dataArray = ds[fieldKey];

            String msg = '';
            if (dataArray is List && dataArray.isNotEmpty) {
              final firstPair = dataArray[0];
              if (firstPair is Map) {
                msg = firstPair['invalidRuleMessages']?.toString() ?? '';
              }
            }

            if (msg.isEmpty || msg.toLowerCase() == 'general') {
              final widget = widgets.firstWhere(
                (w) => (w['key'] ?? '').toString() == fieldKey,
                orElse: () => <String, dynamic>{},
              );
              if (widget.isNotEmpty) {
                final meta =
                    (widget['meta'] as Map?)?.cast<String, dynamic>() ??
                        const {};
                final rules = (meta['validatorRules'] as List?) ?? const [];
                for (final rule in rules) {
                  if (rule is Map) {
                    final condition = (rule['condition']?.toString() ?? '')
                        .toLowerCase()
                        .replaceAll(' ', '');
                    if (condition.contains('null') ||
                        condition.contains('isempty')) {
                      final fallback = rule['message']?.toString() ?? '';
                      if (fallback.isNotEmpty) msg = fallback;
                      break;
                    }
                  }
                }
              }
            }

            if (msg.isNotEmpty && msg.toLowerCase() != 'general') {
              asserts.add({'text': msg, 'exists': true});
            }
          }
          for (final ck in uncheckedRequiredCheckboxes) {
            final msg = requiredCheckboxValidation[ck];
            if (msg != null && msg.isNotEmpty) {
              asserts.add({'text': msg, 'exists': true});
            }
          }
          for (final groupKey in unselectedRadioGroups) {
            final msg = radioGroupValidation[groupKey];
            if (msg != null && msg.isNotEmpty) {
              asserts.add({'text': msg, 'exists': true});
            }
          }
          for (final sk in offRequiredSwitches) {
            final msg = requiredSwitchValidation[sk];
            if (msg != null && msg.isNotEmpty) {
              asserts.add({'text': msg, 'exists': true});
            }
          }
          for (final slk in invalidSliders) {
            final msg = requiredSliderValidation[slk]?['message'];
            if (msg != null && msg.isNotEmpty) {
              asserts.add({'text': msg as String, 'exists': true});
            }
          }
          for (final fk in expectedFailKeys) {
            asserts.add(buildAssert(fk));
          }

          final comboStr = c.map((k, v) => MapEntry(k, v.toString()));
          cases.add({
            'tc': id,
            'kind': caseKind,
            'group': 'pairwise_invalid_cases',
            'description': _buildDescription(comboStr, caseKind, invalidFields,
                uncheckedRequiredCheckboxes, asserts),
            'steps': st,
            'asserts': asserts,
          });
        }

        // Inject all-valid success case only when no extValidCombos exist.
        // If extValidCombos is present, pairwise_valid_cases handles success.
        if (extValidCombos == null || extValidCombos!.isEmpty) {
          final st = <Map<String, dynamic>>[];
          final stepsByKey = <String, List<Map<String, dynamic>>>{};

          for (final key in textKeys) {
            stepsByKey[key] = [
              {
                'enterText': {'byKey': key, 'dataset': 'byKey.$key[0].valid'}
              },
              {'pump': true}
            ];
          }

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
                {
                  'tap': {'byKey': key}
                },
                {'pumpAndSettle': true},
                {'scrollAndTapText': textToTap},
                {'pumpAndSettle': true}
              ];
            }
          }

          for (final ck in requiredCheckboxValidation.keys) {
            stepsByKey[ck] = [
              {
                'tap': {'byKey': ck}
              },
              {'pump': true}
            ];
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
              'tap': {'byKey': endKey, 'isSubmit': true}
            });
            st.add({'pumpAndSettle': true});
          } else {
            st.add({'pump': true});
          }

          final successAsserts = buildSuccessAsserts();
          cases.add({
            'tc': 'pairwise_invalid_cases_${combos.length + 1}',
            'kind': 'success',
            'group': 'pairwise_invalid_cases',
            'description': 'All fields valid — expect success',
            'steps': st,
            'asserts': successAsserts,
          });
        }
      }

      // วนแต่ละ pairwise-valid combination แล้วสร้าง test case ที่คาดหวัง success
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
            final rawPick = (c[factorName] ?? '').toString();
            final pick = rawPick.startsWith('"') && rawPick.endsWith('"')
                ? rawPick.substring(1, rawPick.length - 1)
                : rawPick;
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
              // Resolve 'valid'/'invalid' tokens from datasets for valid-only combinations.
              String resolvedDate = pick;
              if (pick == 'valid' || pick == 'invalid') {
                final ds =
                    (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};
                final entry = ds[factorName];
                final map0 =
                    entry is List && entry.isNotEmpty ? entry[0] as Map? : null;
                final val = map0?[pick]?.toString() ?? '';
                resolvedDate = val.isNotEmpty ? val : 'null';
              }
              stepsByKey[factorName] = [
                {
                  'tap': {'byKey': factorName}
                },
                {'pumpAndSettle': true},
                {'selectDate': resolvedDate},
                {'pumpAndSettle': true}
              ];
            } else if (timePickerKeys.contains(factorName)) {
              // Resolve 'valid'/'invalid' tokens from datasets for valid-only combinations.
              String resolvedTime = pick;
              if (pick == 'valid' || pick == 'invalid') {
                final ds =
                    (datasets['byKey'] as Map?)?.cast<String, dynamic>() ?? {};
                final entry = ds[factorName];
                final map0 =
                    entry is List && entry.isNotEmpty ? entry[0] as Map? : null;
                final val = map0?[pick]?.toString() ?? '';
                resolvedTime = val.isNotEmpty ? val : 'null';
              }
              stepsByKey[factorName] = [
                {
                  'tap': {'byKey': factorName}
                },
                {'pumpAndSettle': true},
                {'selectTime': resolvedTime},
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
              'tap': {'byKey': endKey, 'isSubmit': true}
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

      loadPictAnalysis();
      await _buildPairwiseCases();
      _buildPairwiseValidCases();
    }

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
      // Switch default is false in Flutter — not tapping leaves it off.
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

    Map<String, dynamic>? buildEdgeCaseEmptyFields() {
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
      final emptyAsserts = <Map<String, dynamic>>[];
      if (expectedMsgsCount.isNotEmpty) {
        for (final entry in expectedMsgsCount.entries) {
          emptyAsserts
              .add({'text': entry.key, 'exists': true, 'count': entry.value});
        }
      } else {
        for (final fk in expectedFailKeys) {
          emptyAsserts.add(buildAssert(fk));
        }
      }
      if (emptyAsserts.isEmpty) return null;
      final emptySteps = <Map<String, dynamic>>[];
      if (endKey != null) {
        emptySteps.add({
          'tap': {'byKey': endKey, 'isSubmit': true}
        });
        emptySteps.add({'pumpAndSettle': true});
      }
      final emptyCombo = <String, String>{
        for (final k in textKeys) k: 'empty',
        for (final k in datePickerKeys) k: 'empty',
        for (final k in timePickerKeys) k: 'empty',
        for (final dk in dropdownKeys) dk: 'empty',
        for (final sk in switchKeys) sk: 'off',
        for (final ck in checkboxKeys) ck: 'unchecked',
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
          'tap': {'byKey': endKey, 'isSubmit': true}
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

    Map<String, dynamic>? buildEdgeCaseBoundaryAtMin() {
      if (textKeys.isEmpty || endKey == null) return null;

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
        } else if (invalidVal.isNotEmpty &&
            atMinVal.length == invalidVal.length) {
          minHasInvalidFields = true;
        }
        if (minHasInvalidFields) break;
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
          'tap': {'byKey': endKey, 'isSubmit': true}
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
        'description': _buildDescription(minCombo, minKind, [], [], minAsserts),
        'steps': minSteps,
        'asserts': minAsserts,
      };
    }

    // รวม edge cases ทั้งหมด (empty fields, boundary max, boundary min) แล้วเพิ่มเข้า cases list
    void _buildAllEdgeCases() {
      final emptyCase = buildEdgeCaseEmptyFields();
      if (emptyCase != null) cases.add(emptyCase);

      final maxCase = buildEdgeCaseBoundaryAtMax();
      if (maxCase != null) cases.add(maxCase);

      final minCase = buildEdgeCaseBoundaryAtMin();
      if (minCase != null) cases.add(minCase);
    }

    _buildAllEdgeCases();

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
        'output/test_data/${utils.basenameWithoutExtension(uiFile)}.test_data.json';

    File(outPath).createSync(recursive: true);
    File(outPath).writeAsStringSync(
        const JsonEncoder.withIndent('  ').convert(plan) + '\n');
    stdout.writeln('✓ fullpage plan: $outPath');
  }

  Future<void> _tryWritePictModelFromManifestForUi(String uiFile,
      {String pictBin = './pict', String? constraints}) async {
    final base = utils.basenameWithoutExtension(uiFile);

    final normalizedPath = uiFile.replaceAll('\\', '/');
    String subfolderPath = '';

    if (normalizedPath.startsWith('lib/')) {
      final pathAfterLib = normalizedPath.substring(4);
      final lastSlash = pathAfterLib.lastIndexOf('/');
      if (lastSlash > 0) {
        subfolderPath = pathAfterLib.substring(0, lastSlash);
      }
    }

    final manifestPath = subfolderPath.isNotEmpty
        ? 'output/manifest/$subfolderPath/$base.manifest.json'
        : 'output/manifest/$base.manifest.json';

    final f = File(manifestPath);

    if (!f.existsSync()) return;

    final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
    final widgets =
        (j['widgets'] as List? ?? const []).cast<Map<String, dynamic>>();

    final pictGen = pict.GeneratorPict(pictBin: pictBin);

    final extractionResult = pictGen.extractFactorsFromManifest(widgets);
    final factors = extractionResult.factors;
    final requiredCheckboxes = extractionResult.requiredCheckboxes;

    if (factors.isEmpty) return;

    stderr.writeln('[DEBUG] _tryWritePictModelFromManifestForUi - constraints: '
        '${constraints == null ? "NULL" : "present (${constraints.length} chars)"}, '
        'factors: ${factors.length}');

    await pictGen.writePictModelFiles(
      factors: factors,
      pageBaseName: base,
      requiredCheckboxes: requiredCheckboxes,
      invalidOnlyValues: extractionResult.invalidOnlyValues,
      constraints: constraints,
    );
  }

  List<String> _optionsFromMeta(dynamic raw) {
    final out = <String>[];

    if (raw is List) {
      for (final entry in raw) {
        if (entry is Map) {
          final value = entry['value']?.toString();
          final text = entry['text']?.toString();
          final label = entry['label']?.toString();

          final chosen = (value != null && value.isNotEmpty)
              ? value
              : (text != null && text.isNotEmpty)
                  ? text
                  : label;

          if (chosen != null && chosen.isNotEmpty) {
            final cleaned = chosen.replaceAll(' ', '_');
            out.add(cleaned);
          }
        } else if (entry != null) {
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

void main(List<String> args) async {
  const String pictBin = './pict';

  final inputs = <String>[];

  String? constraintsFile;

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];

    if (arg == '--constraints-file' && i + 1 < args.length) {
      constraintsFile = args[i + 1];
      i++;
    } else if (arg.endsWith('.manifest.json')) {
      inputs.add(arg);
    } else if (!arg.startsWith('--')) {
      stderr.writeln('Warning: Ignoring unrecognized argument: $arg');
    }
  }

  String? constraints;
  if (constraintsFile != null) {
    final file = File(constraintsFile);
    if (file.existsSync()) {
      constraints = file.readAsStringSync();
      stdout.writeln('Loaded constraints from: $constraintsFile');
    } else {
      stderr.writeln('Warning: Constraints file not found: $constraintsFile');
    }
  }

  if (inputs.isEmpty) {
    stderr.writeln('Error: No manifest file specified');
    stderr.writeln(
        'Usage: dart run tools/script_v2/generate_test_data.dart <manifest.json>');
    stderr.writeln(
        'Example: dart run tools/script_v2/generate_test_data.dart output/manifest/demos/buttons_page.manifest.json');
    exit(1);
  }

  int successCount = 0;
  int errorCount = 0;

  final generator = TestDataGenerator(pictBin: pictBin);

  for (final path in inputs) {
    try {
      await generator.generateTestData(
        path,
        constraints: constraints,
      );
      successCount++;
    } catch (e, st) {
      stderr.writeln('✗ Failed to process $path: $e');
      if (args.contains('--verbose')) {
        stderr.writeln(st);
      }
      errorCount++;
    }
  }

  if (inputs.length > 1) {
    stdout.writeln('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    stdout.writeln('Summary: $successCount succeeded, $errorCount failed');
    stdout.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  if (errorCount > 0) {
    exit(1);
  }
}
