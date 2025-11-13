# Event Sequence Graph Visualization

คู่มือการสร้างภาพแสดง Event Sequence Graph จาก chain.json files

## Overview

Script `visualize_event_graph.dart` จะแปลง event chain JSON files ให้เป็นภาพกราฟที่แสดงลำดับการทำงานของ UI events โดยรองรับ 2 format:

1. **Graphviz DOT** (.dot) - สำหรับสร้างภาพ PNG/SVG ด้วย Graphviz
2. **Mermaid** (.mmd) - สำหรับแสดงใน GitHub/GitLab หรือ Mermaid Live Editor

## Installation

### ติดตั้ง Graphviz (สำหรับ DOT format)

**macOS:**
```bash
brew install graphviz
```

**Ubuntu/Debian:**
```bash
sudo apt-get install graphviz
```

**Windows:**
ดาวน์โหลดจาก https://graphviz.org/download/

## Usage

### 1. Generate Event Chains (ถ้ายังไม่มี)

```bash
# สร้าง manifest ก่อน
dart run tools/script_v2/extract_manifest.dart

# สร้าง event chains
dart run tools/script_v2/extract_event_sequence.dart
```

### 2. สร้างภาพกราฟ

#### สร้างทั้ง DOT และ Mermaid (default)
```bash
dart run tools/script_v2/visualize_event_graph.dart
```

#### สร้างเฉพาะ DOT format
```bash
dart run tools/script_v2/visualize_event_graph.dart --format=dot
```

#### สร้างเฉพาะ Mermaid format
```bash
dart run tools/script_v2/visualize_event_graph.dart --format=mermaid
```

#### สร้างจาก chain file เฉพาะเจาะจง
```bash
dart run tools/script_v2/visualize_event_graph.dart output/event_chains/register/register_page.chain.json
```

### 3. แปลง DOT เป็นภาพ

#### สร้าง PNG
```bash
dot -Tpng output/graphs/register_page.dot -o output/graphs/register_page.png
```

#### สร้าง SVG (แนะนำสำหรับความคมชัด)
```bash
dot -Tsvg output/graphs/register_page.dot -o output/graphs/register_page.svg
```

#### สร้าง PDF
```bash
dot -Tpdf output/graphs/register_page.dot -o output/graphs/register_page.pdf
```

#### แปลงทุกไฟล์ในครั้งเดียว (macOS/Linux)
```bash
for f in output/graphs/**/*.dot; do
  dot -Tpng "$f" -o "${f%.dot}.png"
  dot -Tsvg "$f" -o "${f%.dot}.svg"
done
```

## Output Format

### Directory Structure

```
output/
├── graphs/
│   ├── register/
│   │   ├── register_page.dot      # Graphviz DOT format
│   │   ├── register_page.mmd      # Mermaid diagram
│   │   ├── register_page.png      # Generated image (after dot command)
│   │   └── register_page.svg      # Generated SVG (after dot command)
│   ├── submit/
│   │   ├── submit_page.dot
│   │   └── submit_page.mmd
│   └── dashboard/
│       ├── dashboard_page.dot
│       └── dashboard_page.mmd
```

## Graph Elements

### Node Types และสี

| Event Type | สี | รูปแบบ | ความหมาย |
|-----------|-----|--------|---------|
| `enterText` | 🟢 เขียวอ่อน | กล่องมุมมน | กรอกข้อความ |
| `selectRadioGroup` | 🟠 ส้มอ่อน | กล่องมุมมน | เลือก Radio Button |
| `selectDropdown` | 🟠 ส้มอ่อน | กล่องมุมมน | เลือก Dropdown |
| `tap` (ปกติ) | 🟣 ม่วงอ่อน | กล่องมุมมน | กดปุ่มทั่วไป |
| `tap` (endpoint) | 🔴 แดงอ่อน | กล่องมุมมน (หนา) | กดปุ่ม Submit/API |
| `verify` (200) | 🟢 เขียว | วงกลม (หนา) | ผลลัพธ์สำเร็จ |
| `verify` (400) | 🟡 เหลือง | วงกลม | Client Error |
| `verify` (500) | 🔴 แดง | วงกลม | Server Error |

### Edge (ลูกศร) Types

| Chain Type | สี | รูปแบบ | ความหมาย |
|-----------|-----|--------|---------|
| `happy_path` | 🟢 เขียว | เส้นหนา | กรณีปกติ (success) |
| `validation_error` | 🟠 ส้ม | เส้นประ | Validation Error |
| `client_error` | 🟡 เหลือง | เส้นประ | 400 Error |
| `server_error` | 🔴 แดง | เส้นประ | 500 Error |

## Example Workflow

```bash
# 1. สร้าง manifest จาก UI files
dart run tools/script_v2/extract_manifest.dart lib/register/register_page.dart

# 2. สร้าง event chains
dart run tools/script_v2/extract_event_sequence.dart output/manifest/register/register_page.manifest.json

# 3. สร้างภาพกราฟ
dart run tools/script_v2/visualize_event_graph.dart output/event_chains/register/register_page.chain.json

# 4. แปลงเป็น PNG
dot -Tpng output/graphs/register/register_page.dot -o output/graphs/register/register_page.png

# 5. เปิดดูภาพ (macOS)
open output/graphs/register/register_page.png
```

## Viewing Mermaid Diagrams

### GitHub/GitLab
ใส่ไฟล์ `.mmd` ใน README หรือ Markdown files:

```markdown
\`\`\`mermaid
[วางเนื้อหาจาก .mmd file ที่นี่]
\`\`\`
```

### Mermaid Live Editor
1. เปิด https://mermaid.live/
2. Copy เนื้อหาจาก `.mmd` file
3. Paste ในหน้า editor
4. Export เป็น PNG/SVG ได้ทันที

### VS Code
ติดตั้ง extension: **Mermaid Preview**
- ดู `.mmd` files ได้โดยตรงใน VS Code

## Advanced Options

### Custom Graphviz Layout

```bash
# Layout แนวนอน
dot -Tpng -Grankdir=LR output/graphs/register_page.dot -o output/graphs/register_page_horizontal.png

# ปรับความกว้างภาพ
dot -Tpng -Gsize="10,8\!" -Gdpi=300 output/graphs/register_page.dot -o output/graphs/register_page_hires.png
```

### Batch Processing

สร้าง script สำหรับ generate ภาพทั้งหมด:

```bash
#!/bin/bash
# generate_all_graphs.sh

# 1. Generate all event chains
dart run tools/script_v2/extract_event_sequence.dart

# 2. Generate all visualizations
dart run tools/script_v2/visualize_event_graph.dart

# 3. Convert all DOT to PNG and SVG
find output/graphs -name "*.dot" | while read dotfile; do
  base="${dotfile%.dot}"
  dot -Tpng "$dotfile" -o "$base.png"
  dot -Tsvg "$dotfile" -o "$base.svg"
  echo "✓ Generated: $base.png and $base.svg"
done

echo "✓ All graphs generated successfully!"
```

ใช้งาน:
```bash
chmod +x generate_all_graphs.sh
./generate_all_graphs.sh
```

## Troubleshooting

### ไม่พบ `dot` command
```
Error: dot: command not found
```
**แก้ไข:** ติดตั้ง Graphviz (ดูที่ Installation)

### ไม่พบ chain files
```
Error: No event_chains directory found
```
**แก้ไข:** รัน `extract_event_sequence.dart` ก่อน

### ภาพมี layout ผิดเพี้ยน
**แก้ไข:** ลอง layout อื่นของ Graphviz:
```bash
# ใช้ neato (force-directed)
neato -Tpng output/graphs/register_page.dot -o output/graphs/register_page.png

# ใช้ circo (circular)
circo -Tpng output/graphs/register_page.dot -o output/graphs/register_page.png

# ใช้ fdp (force-directed)
fdp -Tpng output/graphs/register_page.dot -o output/graphs/register_page.png
```

## References

- Graphviz Documentation: https://graphviz.org/documentation/
- Mermaid Documentation: https://mermaid.js.org/
- DOT Language Guide: https://graphviz.org/doc/info/lang.html
