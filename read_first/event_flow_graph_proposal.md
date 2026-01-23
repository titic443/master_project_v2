# Event Flow Graph (EFG) for Flutter Integration Testing

## Overview

This document proposes extending the current test generation system with Event Flow Graph (EFG) support for comprehensive GUI testing coverage.

## Current State

Our system already has the foundation for EFG:
- **Events**: UI interactions (tap, enterText, select dropdown)
- **Sequences**: Ordered steps in test cases
- **States**: BLoC/Cubit states (Initial, Loading, Success, Error)

## Proposed EFG Implementation

### 1. Event Extraction from Manifest

```dart
// Event types extracted from manifest
class UIEvent {
  final String id;           // e.g., "E1", "E2"
  final String type;         // "enterText", "tap", "select"
  final String widgetKey;    // "username_textfield"
  final String? widgetType;  // "TextFormField", "ElevatedButton"
  List<UIEvent> successors;  // Events that can follow this one

  UIEvent({
    required this.id,
    required this.type,
    required this.widgetKey,
    this.widgetType,
    this.successors = const [],
  });
}
```

### 2. Build Event Flow Graph

```dart
// Example EFG for RegisterPage
Events:
- E1: enterText(username_textfield)
- E2: enterText(password_textfield)
- E3: enterText(email_textfield)
- E4: tap(dropdown_button)
- E5: select("approve")
- E6: tap(submit_button)
- E7: verify(status_200)
- E8: verify(status_400)

Flow Graph:
START → E1 → E2 → E3 → E4 → E5 → E6 → {E7, E8}

Valid Paths:
1. START → E1 → E2 → E3 → E4 → E5 → E6 → E7  (all valid → success)
2. START → E1 → E2 → E3 → E6 → E8            (skip dropdown → error)
3. START → E6 → E8                            (empty fields → validation error)
```

### 3. Test Coverage Metrics

#### Event Coverage
```
Event Coverage = (Events Executed / Total Events) × 100%

Example:
- Total Events: 8
- Executed: 7 (E1-E7)
- Coverage: 87.5%
```

#### Event Pair Coverage
```
Event Pair Coverage = (Pairs Executed / Total Valid Pairs) × 100%

Example pairs:
- (E1, E2): username → password
- (E2, E3): password → email
- (E5, E6): select option → submit
```

#### Event Sequence Coverage (k-length)
```
2-sequence: (E1, E2), (E2, E3), (E3, E6)
3-sequence: (E1, E2, E3), (E2, E3, E6)
```

### 4. Path Testing Strategies

#### All-Events Coverage
Generate test cases that cover all events at least once.

#### All-Pairs Coverage (Current: Pairwise)
Our PICT-based approach already does this for parameter combinations.
Extend to event sequences.

#### All-Paths Coverage (Exhaustive)
Generate all possible paths through the EFG.
⚠️ Warning: Exponential growth - use for small graphs only.

#### Prime Path Coverage
Test all paths that:
1. Start at an initial node
2. End at a final node
3. Are simple (no repeated nodes except possibly first/last)
4. Are maximal (not a subpath of another path)

### 5. Integration with Current System

#### Step 1: Extract EFG from Manifest
```bash
dart run tools/script_v2/extract_efg.dart output/manifest/register/register_page.manifest.json
# Output: output/efg/register/register_page.efg.json
```

#### Step 2: Generate Test Plans from EFG
```bash
dart run tools/script_v2/generate_test_from_efg.dart output/efg/register/register_page.efg.json --strategy=all-pairs
# Strategies: all-events, all-pairs, prime-paths, all-paths
```

#### Step 3: Analyze Coverage
```bash
dart run tools/script_v2/analyze_efg_coverage.dart output/test_data/register_page.testdata.json
# Output: Coverage report with metrics
```

### 6. Example EFG JSON Format

```json
{
  "file": "lib/register/register_page.dart",
  "pageClass": "RegisterPage",
  "events": [
    {
      "id": "E1",
      "type": "enterText",
      "widgetKey": "username_textfield",
      "widgetType": "TextFormField",
      "required": true
    },
    {
      "id": "E2",
      "type": "enterText",
      "widgetKey": "password_textfield",
      "widgetType": "TextFormField",
      "required": true
    },
    {
      "id": "E6",
      "type": "tap",
      "widgetKey": "submit_button",
      "widgetType": "ElevatedButton",
      "isEndpoint": true
    },
    {
      "id": "E7",
      "type": "verify",
      "widgetKey": "register_status_200",
      "expectedOutcome": "success"
    }
  ],
  "edges": [
    {"from": "START", "to": "E1"},
    {"from": "E1", "to": "E2"},
    {"from": "E2", "to": "E6"},
    {"from": "E6", "to": "E7"}
  ],
  "paths": [
    {
      "id": "P1",
      "type": "prime",
      "sequence": ["START", "E1", "E2", "E6", "E7"],
      "expectedOutcome": "success"
    }
  ]
}
```

### 7. Benefits of EFG Approach

#### Systematic Test Generation
- Automatically derive test cases from graph structure
- Ensure coverage of critical paths
- Identify unreachable code

#### Better Coverage Metrics
- Quantify test suite effectiveness
- Track coverage improvements over time
- Identify gaps in testing

#### Detect GUI-Specific Issues
- **Dead Events**: Events that can never be reached
- **Event Conflicts**: Events that interfere with each other
- **Missing Transitions**: Gaps in user flow

#### Visualization
```
Generate visual graphs using Graphviz/Mermaid:

graph TD
    START --> E1[Enter Username]
    E1 --> E2[Enter Password]
    E2 --> E3[Enter Email]
    E3 --> E6[Submit]
    E6 --> E7[Success 200]
    E6 --> E8[Error 400]
```

### 8. Implementation Roadmap

**Phase 1: Basic EFG** (1-2 weeks)
- ✅ Extract events from manifest
- ✅ Build basic flow graph
- ✅ Generate all-events coverage tests

**Phase 2: Advanced Coverage** (2-3 weeks)
- ✅ Implement event-pair coverage
- ✅ Implement prime-path coverage
- ✅ Add coverage analysis tools

**Phase 3: Visualization & Analysis** (1-2 weeks)
- ✅ Generate EFG visualizations
- ✅ Coverage reports with metrics
- ✅ Integration with existing tools

## Comparison with Current Approach

| Feature | Current (Pairwise) | EFG Approach |
|---------|-------------------|--------------|
| **Coverage** | Parameter combinations | Event sequences |
| **Metrics** | Pairwise coverage | Event/Path coverage |
| **Graph** | Implicit | Explicit EFG |
| **Visualization** | None | Graph diagrams |
| **Dead code detection** | No | Yes |
| **Sequence testing** | Limited | Comprehensive |

## Conclusion

Adding EFG support would significantly enhance our testing capabilities:
- ✅ More systematic test generation
- ✅ Better coverage metrics
- ✅ Visual representation of test flows
- ✅ Detection of unreachable code
- ✅ Complement existing pairwise testing

The current system already has 80% of the infrastructure needed - we just need to make the event flow explicit and add analysis tools.
