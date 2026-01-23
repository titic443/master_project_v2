# From Key Sequence to Event Flow Graph

## Concept Overview

Transform key-based UI sequences into Event Flow Graphs for systematic test generation.

## Phase 1: Key Sequence Analysis (Linear Flow) ✅ START HERE

### Input: Naming Convention
```dart
// Current key naming pattern:
<page>_<field>_<widget_type>
<page>_<action>_<widget_type>

Examples:
- register_username_textfield
- register_password_textfield
- register_email_textfield
- register_submit_button
- register_status_200  // expected outcome
- register_status_400  // error outcome
```

### Proposed: Add Sequence Information
```dart
// Enhanced key naming with sequence hints:
<page>_<sequence>_<field>_<widget_type>

Examples:
register_01_username_textfield
register_02_password_textfield
register_03_email_textfield
register_04_submit_button
register_end_status_200
```

**Benefits:**
- ✅ Explicit ordering from keys
- ✅ No need to guess sequence
- ✅ Easy to parse and generate linear flow

### Alternative: Sequence Metadata (Better!)
```json
{
  "key": "register_username_textfield",
  "widgetType": "TextFormField",
  "sequence": {
    "order": 1,
    "group": "input_fields",
    "nextKeys": ["register_password_textfield"],
    "requiredBefore": ["register_submit_button"]
  }
}
```

## Phase 2: Linear Event Chain (Simple EFG)

### Step 1: Extract Event Sequence from Keys

```dart
// New script: tools/script_v2/extract_event_sequence.dart

List<Event> extractEventSequence(List<Widget> widgets) {
  final events = <Event>[];

  // Group widgets by type
  final textFields = widgets.where((w) => w.type.contains('TextField'));
  final buttons = widgets.where((w) => w.type.contains('Button'));
  final outcomes = widgets.where((w) => w.key.contains('_status_'));

  // Phase 1: Simple linear sequence
  // Order: text fields → buttons → outcomes
  int sequence = 0;

  for (final tf in textFields) {
    events.add(Event(
      id: 'E${++sequence}',
      type: EventType.enterText,
      widgetKey: tf.key,
      order: sequence,
    ));
  }

  for (final btn in buttons) {
    if (btn.key.contains('_submit_') || btn.key.contains('_endapi_')) {
      events.add(Event(
        id: 'E${++sequence}',
        type: EventType.tap,
        widgetKey: btn.key,
        order: sequence,
        isEndpoint: true,
      ));
    }
  }

  for (final outcome in outcomes) {
    events.add(Event(
      id: 'E${++sequence}',
      type: EventType.verify,
      widgetKey: outcome.key,
      order: sequence,
      isAssertion: true,
    ));
  }

  return events;
}
```

### Step 2: Generate Linear Flow

```dart
class LinearEventChain {
  final List<Event> events;

  // Generate default "happy path"
  List<Event> getHappyPath() {
    return events
        .where((e) => !e.isAssertion || e.widgetKey.contains('_200'))
        .toList();
  }

  // Generate error path
  List<Event> getErrorPath() {
    return events
        .where((e) => !e.isAssertion || e.widgetKey.contains('_400'))
        .toList();
  }

  // Generate all linear paths
  List<List<Event>> getAllLinearPaths() {
    return [
      getHappyPath(),
      getErrorPath(),
      getValidationErrorPath(),
    ];
  }
}
```

### Output Format

```json
{
  "file": "lib/register/register_page.dart",
  "flowType": "linear",
  "events": [
    {
      "id": "E1",
      "order": 1,
      "type": "enterText",
      "widgetKey": "register_username_textfield",
      "required": true
    },
    {
      "id": "E2",
      "order": 2,
      "type": "enterText",
      "widgetKey": "register_password_textfield",
      "required": true
    },
    {
      "id": "E3",
      "order": 3,
      "type": "tap",
      "widgetKey": "register_submit_button",
      "isEndpoint": true
    },
    {
      "id": "E4",
      "order": 4,
      "type": "verify",
      "widgetKey": "register_status_200",
      "expectedOutcome": "success"
    }
  ],
  "chains": [
    {
      "name": "happy_path",
      "sequence": ["E1", "E2", "E3", "E4"],
      "description": "All valid inputs → success"
    },
    {
      "name": "validation_error",
      "sequence": ["E3", "E5"],
      "description": "Empty fields → validation error"
    }
  ]
}
```

## Phase 3: Enhanced with Branching (True EFG)

### Add Decision Points

```dart
class Event {
  final String id;
  final String type;
  final String widgetKey;

  // Enhanced with branches
  final List<EventTransition> transitions;
}

class EventTransition {
  final String toEventId;
  final String condition;  // "valid_input", "invalid_input", "api_success"
  final double probability; // optional: for test prioritization
}
```

### Example with Branches

```json
{
  "events": [
    {
      "id": "E3",
      "type": "tap",
      "widgetKey": "register_submit_button",
      "transitions": [
        {
          "to": "E4",
          "condition": "all_fields_valid",
          "probability": 0.7
        },
        {
          "to": "E5",
          "condition": "validation_error",
          "probability": 0.3
        }
      ]
    },
    {
      "id": "E4",
      "type": "apiCall",
      "transitions": [
        {
          "to": "E6",
          "condition": "api_success_200"
        },
        {
          "to": "E7",
          "condition": "api_error_400"
        },
        {
          "to": "E8",
          "condition": "api_error_500"
        }
      ]
    }
  ]
}
```

### Visual Representation

```
    E1 (username)
         ↓
    E2 (password)
         ↓
    E3 (submit) ──→ [validation check]
         ↓                    ↓
    [API call]          E5 (validation error)
         ↓
    [response check]
       /   |   \
      /    |    \
    E6   E7    E8
   (200) (400) (500)
```

## Phase 4: Intelligent Sequence Detection

### Heuristics for Auto-Detection

```dart
// Detect sequence from key patterns
int? getSequenceFromKey(String key) {
  // Pattern 1: Explicit numbering
  final match1 = RegExp(r'_(\d{2})_').firstMatch(key);
  if (match1 != null) return int.parse(match1.group(1)!);

  // Pattern 2: Common ordering keywords
  if (key.contains('_first_')) return 10;
  if (key.contains('_second_')) return 20;
  if (key.contains('_third_')) return 30;
  if (key.contains('_last_')) return 90;

  // Pattern 3: Widget type ordering
  if (key.contains('_textfield')) return 10; // inputs first
  if (key.contains('_dropdown')) return 20;  // dropdowns second
  if (key.contains('_radio')) return 30;     // radios third
  if (key.contains('_button')) return 40;    // buttons fourth

  return null;
}

// Detect dependencies from validation rules
List<String> getDependencies(Widget widget) {
  final deps = <String>[];

  // Example: confirm_password depends on password
  if (widget.key.contains('confirm_password')) {
    deps.add('password_textfield');
  }

  // From validator rules
  final meta = widget.meta;
  if (meta['validatorRules'] != null) {
    for (final rule in meta['validatorRules']) {
      final condition = rule['condition'] ?? '';
      // Parse: "value != _cubit.state.password"
      final dependentField = extractFieldFromCondition(condition);
      if (dependentField != null) deps.add(dependentField);
    }
  }

  return deps;
}
```

## Implementation Roadmap

### Week 1: Basic Linear Sequence ⭐ START HERE

**Goal**: Extract linear event sequences from keys

**Tasks**:
1. Create `extract_event_sequence.dart`
2. Parse widgets and order by type
3. Generate simple linear chains
4. Output JSON format

**Test**: Generate linear flow for RegisterPage

```bash
dart run tools/script_v2/extract_event_sequence.dart lib/register/register_page.dart
# Output: output/event_chains/register/register_page.chain.json
```

### Week 2: Enhanced Test Generation

**Goal**: Use event chains to generate test cases

**Tasks**:
1. Modify `generate_test_data.dart` to read chains
2. Generate test cases following chain sequences
3. Support multiple chains (happy path, error paths)

**Output**: Test cases following explicit event order

### Week 3: Add Branching Support

**Goal**: Support decision points and multiple paths

**Tasks**:
1. Add transition/condition support
2. Implement branch detection
3. Generate tests for all paths

### Week 4: Full EFG with Visualization

**Goal**: Complete EFG implementation with visual graphs

**Tasks**:
1. Generate Graphviz/Mermaid diagrams
2. Coverage analysis (event coverage, path coverage)
3. Documentation and examples

## Practical Example: RegisterPage

### Current Approach (Implicit Sequence)
```dart
// Current: guess sequence from widget order
textKeys = ['username', 'password', 'email'];
// Test just uses this order blindly
```

### Phase 1: Explicit Key Sequence
```dart
// Option A: Enhanced keys
register_01_username_textfield
register_02_password_textfield
register_03_email_textfield
register_04_submit_button

// Option B: Metadata in manifest
{
  "key": "register_username_textfield",
  "sequence": 1,
  "nextKeys": ["register_password_textfield"]
}
```

### Phase 2: Event Chain
```json
{
  "chains": [
    {
      "name": "register_happy_path",
      "events": ["E1", "E2", "E3", "E4", "E5"],
      "description": "Complete registration with valid data"
    }
  ]
}
```

### Phase 3: Full EFG with Branches
```json
{
  "graph": {
    "nodes": ["E1", "E2", "E3", "E4", "E5", "E6"],
    "edges": [
      {"from": "E3", "to": "E4", "condition": "valid"},
      {"from": "E3", "to": "E6", "condition": "invalid"}
    ]
  }
}
```

## Decision: Which Approach?

### Recommended: Hybrid Approach

**Phase 1** (Implement Now): Linear chains from key analysis
- Quick to implement
- Use existing key conventions
- Good enough for 80% of cases

**Phase 2** (Future): Add branching
- When you need multiple paths
- For complex conditional flows
- Full EFG capabilities

### Why This Works

1. **Start Simple**: Linear chains are easier and cover most cases
2. **Evolve Naturally**: Add complexity as needed
3. **Backward Compatible**: Existing keys work, enhanced keys optional
4. **Practical**: Focus on real testing needs, not theoretical completeness

## Next Steps

Would you like me to:
1. ✅ Implement Phase 1: Linear event chain extraction
2. ✅ Create example with RegisterPage
3. ✅ Integrate with existing test generation
4. ✅ Show before/after comparison

Let me know and I'll start implementing! 🚀
