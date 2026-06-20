# Widget Manifest Example

## Block 1 — Flutter Code

```dart
TextFormField(
  key: const Key('appt_01_patient_name_textfield'),
  controller: _patientNameCtrl,
  decoration: _dec(
    label: 'Full Name',
    hint: 'e.g. John Doe',
    icon: Icons.badge_outlined,
  ),
  textCapitalization: TextCapitalization.words,
  onChanged: cubit.onPatientNameChanged,
  validator: (v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your full name';
    if (v.trim().length < 2) return 'At least 2 characters';
    return null;
  },
),
```

---

## Block 2 — JSON Manifest

```txt
{
  "widgetType": "TextFormField",
  "key": "appt_01_patient_name_textfield",
  "meta": {
    "validatorRules": [
      {
        "condition": "v == null || v.trim().isEmpty",
        "message": "Please enter your full name"
      },
      {
        "condition": "v.trim().length < 2",
        "message": "At least 2 characters"
      }
    ]
  }
}
```
