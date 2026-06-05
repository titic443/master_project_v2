# Generate Datasets — Prompt Structure

Prompt ที่ส่งไป Gemini API ใน `tools/script_v2/generate_datasets.dart` (ฟังก์ชัน `_callGeminiForDatasets`)  
ประกอบด้วย 5 บล็อกหลัก + 4 ตัวอย่าง ต่อไปนี้

---

## Block 1 — CONTEXT

> บอก AI ว่าระบบนี้คืออะไร

```
=== (CONTEXT) ===
Test data generator for Flutter form validation.
```

---

## Block 2 — TARGET

> บอก AI ว่าผู้ใช้คือใครและต้องการอะไร

```
=== (TARGET) ===
QA engineers need REALISTIC test data for happy path and errors.
```

---

## Block 3 — OBJECTIVE

> กฎหลักที่ AI ต้องปฏิบัติตาม (รายการสั้น ๆ)

```
=== (OBJECTIVE) ===
1. Analyze field key name to understand field purpose (e.g., "firstname" → person name)
2. Analyze constraints (maxLength, inputFormatters, validatorRules)
3. Generate REALISTIC valid/invalid pairs for ALL fields
4. For fields WITH validatorRules: generate pairs based on rules
   (skip isEmpty/null rules UNLESS they are the ONLY rule)
5. For fields with ONLY isEmpty/null rule: invalid = "" (empty string),
   invalidRuleMessages = that rule's message
6. For fields WITHOUT validatorRules: generate 1 realistic valid + 1 common invalid,
   invalidRuleMessages = ""
7. CRITICAL: Invalid values MUST pass inputFormatters but represent bad data
8. Also generate boundary values: atMin and atMax for each field
9. Output valid JSON
```

---

## Block 4 — EXECUTION

> ขั้นตอนทำงานละเอียดแยกตาม 3 กรณีของ field + boundary values

### 4a — Fields WITH validatorRules

```
For fields WITH validatorRules:
  1. List all rules. SKIP rules whose condition contains "isEmpty" or "== null"
     (those are Required checks).
  2. For each remaining rule, generate exactly 1 pair:
     - Read the rule's "condition" carefully
       (e.g., "v.trim().length < 5", "n == null || n < 100000")
     - invalid: value that makes condition evaluate to TRUE → validator returns error message
     - valid:   value that makes condition evaluate to FALSE → validator returns null (passes)
     - invalidRuleMessages: copy the EXACT "message" string — never paraphrase
  3. All values MUST still pass inputFormatters
     (e.g., digitsOnly field → invalid must be digits)
```

### 4b — Fields with ONLY isEmpty/null rules

```
For fields with ONLY isEmpty/null rules (all non-empty rules are absent):
  1. invalid MUST be "" (empty string) — the only way to trigger the isEmpty rule
  2. invalidRuleMessages = EXACT message from that isEmpty/null rule
  3. Generate 1 realistic valid value
```

### 4c — Fields WITHOUT validatorRules

```
For fields WITHOUT validatorRules at all:
  1. Infer field type from key name (firstname→name, phone→phone number, email→email)
  2. Generate 1 pair with realistic valid value
  3. Generate common invalid value (e.g., too short, wrong format)
     that respects inputFormatters
  4. Set invalidRuleMessages to "" — no UI-visible error message for this field
```

### 4d — Boundary Values (เพิ่มใน pair แรกของแต่ละ field เท่านั้น)

```
For boundary values (add to FIRST pair only):

  atMin: value at the minimum boundary
    - Default: "" (empty string)
    - If field has min-length rule (e.g., length < 2): use value just below min
      (e.g., 1 char like "A")
    - MUST respect inputFormatters (e.g., digitsOnly → use "0" or "")

  atMax: value at the maximum length boundary
    - ALWAYS use meta.effectiveMaxLength as the max (explicit or default 50)
    - Generate a realistic value whose character length == effectiveMaxLength exactly
    - MUST respect inputFormatters and be a realistic value (not just repeated chars)
    - For Thai name fields: use a realistic long Thai full name padded to reach the length
    - For free-text note fields: use a realistic sentence padded to reach the length
    - For email fields: pad local-part with chars to reach effectiveMaxLength
    - For digit-only fields: use digits that reach effectiveMaxLength
```

### Output Format

```
job_search_page.constraints.txt

search_01_patient_name_textfield.valid   = สมชาย valid
search_01_patient_name_textfield.invalid = สมชาย invalid

IF [search_01_patient_name_textfield] = "invalid" THEN [search_02_department_dropdown] = "valid";
```

---

## Block 5 — EXAMPLES

> 4 ตัวอย่างครอบคลุมทุกกรณี

### Example 1 — Field with 2 rules (maxLength=100)

```
// === EXECUTION: ขั้นตอนการทำงาน ===

For fields WITH validatorRules:
  1. List all rules. SKIP rules whose condition contains "isEmpty" or "== null" (those are Required checks).
  2. For each remaining rule, generate exactly 1 pair:
     - Read the rule's "condition" carefully (e.g., "v.trim().length < 5", "n == null || n < 100000")
     - invalid: a value that makes that condition evaluate to TRUE → validator returns the error message
     - valid:   a value that makes that condition evaluate to FALSE → validator returns null (passes)
     - invalidRuleMessages: copy the EXACT "message" string from that rule — never paraphrase
  3. All values MUST still pass inputFormatters (e.g., digitsOnly field → invalid must be digits)

For fields with ONLY isEmpty/null rules (all non-empty rules are absent):
  1. invalid MUST be "" (empty string) — the only way to trigger the isEmpty rule
  2. invalidRuleMessages = EXACT message from that isEmpty/null rule
  3. Generate 1 realistic valid value

For fields WITHOUT validatorRules at all:
  1. Infer field type from key name (firstname→name, phone→phone number, email→email)
  2. Generate 1 pair with realistic valid value
  3. Generate common invalid value (e.g., too short, wrong format) that respects inputFormatters
  4. Set invalidRuleMessages to "" (empty string) — no UI-visible error message for this field

For boundary values (add to FIRST pair only):
  atMin: value at the minimum boundary
    - Default: "" (empty string)
    - If field has min-length rule (e.g., length < 2): use value just below min (e.g., 1 char like "A")
    - MUST respect inputFormatters (e.g., digitsOnly → use "0" or "")
  atMax: value at the maximum length boundary
    - ALWAYS use meta.effectiveMaxLength as the max — it is already computed (explicit or default 50)
    - Generate a realistic value whose character length == effectiveMaxLength exactly
    - MUST respect inputFormatters and be a realistic value (not just repeated chars)
    - For Thai name fields: use a realistic long Thai full name padded to reach the length
    - For free-text note fields: use a realistic sentence padded to reach the length
    - For email fields: pad local-part with chars to reach effectiveMaxLength
    - For digit-only fields: use digits that reach effectiveMaxLength

Output format: {"file":"<filename>","datasets":{"byKey":{"<key>":[...pairs...]}}}
Each pair: {"valid":"...","invalid":"...","invalidRuleMessages":"...","atMin":"...","atMax":"..."}
(atMin and atMax are ONLY in the FIRST pair of each field)''',

```

### Example 2 — Field with numeric rule + digitsOnly

```
Input:
  key: "price_textfield"
  inputFormatters: [digitsOnly]
  validatorRules:
    - condition: "v == null || v.trim().isEmpty"    message: "Required"
    - condition: "n == null || n < 100000"          message: "Min 100,000 THB"

Reasoning:
  Skip isEmpty rule.
  Rule left: condition "n < 100000"
    → invalid must be digits < 100000 → "99999"
    → message = exact "Min 100,000 THB"

Output:
  {"price_textfield":[{
    "valid":"150000",
    "invalid":"99999",
    "invalidRuleMessages":"Min 100,000 THB",
    "atMin":"",
    "atMax":"150000"
  }]}
```

### Example 3 — Field without validatorRules

```
Input:
  key: "nickname_textfield"
  meta: {}

Reasoning:
  No validatorRules → invalidRuleMessages = ""

Output:
  {"nickname_textfield":[{
    "valid":"Johnny",
    "invalid":"X",
    "invalidRuleMessages":"",
    "atMin":"",
    "atMax":"Johnny"
  }]}
```

### Example 4 — Field with ONLY isEmpty/null rule

```
Input:
  key: "prop_03_location_textfield"
  validatorRules:
    - condition: "v == null || v.trim().isEmpty"
      message: "กรุณากรอกจังหวัด / เมือง"

Reasoning:
  Only rule is isEmpty/null.
  Since it is the ONLY rule → invalid must be "" to trigger it.
  Message = exact "กรุณากรอกจังหวัด / เมือง"

Output:
  {"prop_03_location_textfield":[{
    "valid":"กรุงเทพมหานคร",
    "invalid":"",
    "invalidRuleMessages":"กรุณากรอกจังหวัด / เมือง",
    "atMin":"",
    "atMax":"กรุงเทพมหานคร"
  }]}
```

---

## Block 6 — STYLE

> รูปแบบ output ที่ต้องการ

```
=== (STYLE) ===
- JSON only (no markdown, no comments)
- REALISTIC values based on field purpose (Thai names for Thai app, etc.)
- Valid values should look like real user input
- Invalid values should be common mistakes users make
- String arrays only
- Remember: invalid data MUST be typeable (respect inputFormatters)
```

---

## Summary — Decision Tree

```
Field has validatorRules?
├── YES — any non-isEmpty/non-null rules?
│   ├── YES → generate 1 pair per non-empty rule
│   │           invalid triggers condition → TRUE
│   │           valid  makes condition → FALSE
│   └── NO  → ONLY isEmpty/null rule
│             invalid = "" (empty string)
│             invalidRuleMessages = exact message
└── NO  → infer type from key name
          generate 1 realistic pair
          invalidRuleMessages = ""

Always add atMin + atMax to FIRST pair only.
```
