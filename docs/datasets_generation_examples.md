# Dataset Generation — Console Log Examples

Each example shows the **input** (field manifest with meta) and the resulting **output** (datasets entry).

---

## Example 1 — Field with 2 rules + maxLength

**Input**

```json
{
  "key": "firstname",
  "meta": {
    "inputFormatters": [
      { "type": "lengthLimit", "max": 100 }
    ],
    "validatorRules": [
      { "condition": "value.isEmpty", "message": "Required" },
      { "condition": "value.length < 2", "message": "Min 2 chars" }
    ]
  }
}
```

**Reasoning**

- Skip `isEmpty` rule (non-empty rule exists).
- Remaining rule: `value.length < 2` → invalid must have length < 2 → `"J"` (length 1).
- `message` = exact `"Min 2 chars"`.
- `atMax` = string near `maxLength` 100.

**Output**

```json
{
  "firstname": [
    {
      "valid": "Alice",
      "invalid": "J",
      "invalidRuleMessages": "Min 2 chars",
      "atMin": "A",
      "atMax": "Alice Johnson Wongsuwan Charoenpong Panyanart Srisomboon Boonmee Suk"
    }
  ]
}
```

---

## Example 2 — Numeric field with digitsOnly formatter

**Input**

```json
{
  "key": "price_textfield",
  "meta": {
    "inputFormatters": [
      { "type": "digitsOnly" }
    ],
    "validatorRules": [
      { "condition": "v == null || v.trim().isEmpty", "message": "Required" },
      { "condition": "n == null || n < 100000", "message": "Min 100,000 THB" }
    ]
  }
}
```

**Reasoning**

- Skip `isEmpty` rule (numeric rule exists).
- Remaining rule: `n < 100000` → invalid must be digits and value < 100000 → `"99999"`.
- `message` = exact `"Min 100,000 THB"`.
- No `maxLength` formatter → `atMax` = valid value itself.

**Output**

```json
{
  "price_textfield": [
    {
      "valid": "150000",
      "invalid": "99999",
      "invalidRuleMessages": "Min 100,000 THB",
      "atMin": "",
      "atMax": "150000"
    }
  ]
}
```

---

## Example 3 — Field with no rules and no maxLength

**Input**

```json
{
  "key": "nickname_textfield",
  "meta": {}
}
```

**Reasoning**

- No `validatorRules` → `invalidRuleMessages` = `""`.
- No constraints on length or format.
- `invalid` = any short string; `atMax` = valid value itself.

**Output**

```json
{
  "nickname_textfield": [
    {
      "valid": "Johnny",
      "invalid": "X",
      "invalidRuleMessages": "",
      "atMin": "",
      "atMax": "Johnny"
    }
  ]
}
```

---

## Example 4 — Field with ONLY an isEmpty/null rule

**Input**

```txt
    {
      "widgetType": "TextFormField",
      "key": "appt_01_patient_name_textfield",
      "meta": {
        "validatorRules": [
          {
            "condition": "v == null || v.trim().isEmpty",
            "message": "กรุณากรอกชื่อ-นามสกุล"
          },
          {
            "condition": "v.trim().length < 2",
            "message": "อย่างน้อย 2 ตัวอักษร"
          }
        ]
      }
    },
```

**Reasoning**

- Skip first rule `isEmpty/null` because a non-empty rule exists.
- Remaining rule: `v.trim().length < 2` → invalid must have length < 2 → `"ก"` (length 1).
- `message` = exact `"อย่างน้อย 2 ตัวอักษร"`.
- No `maxLength` formatter → `atMax` = long valid string near practical limit.

**Output**

```txt
{
  "file": "lib/demos/clinic_appointment_page.dart",
  "datasets": {
    "byKey": {
      "appt_01_patient_name_textfield": [
        {
          "valid": "สมชาย ใจดี",
          "invalid": "ก",
          "invalidRuleMessages": "อย่างน้อย 2 ตัวอักษร",
          "atMin": "ก",
          "atMax": "สมชาย มั่งมีศรีสุขเจริญพรชัยมงคลเกษมสันต์สุริโยทัย"
        }
      ],
      "appt_02_id_card_textfield": [
        {
          "valid": "1234567890123",
          "invalid": "123456789012",
          "invalidRuleMessages": "ต้องมี 13 หลัก",
          "atMin": "123456789012",
          "atMax": "1234567890123"
        }
      ]
    }
  }
}
```
