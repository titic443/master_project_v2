// API Base URL
const API_BASE = 'http://localhost:8080';

// DOM Elements
const inputFileInput = document.getElementById('inputFile');
const outputFileInput = document.getElementById('outputFile');
const browseInputBtn = document.getElementById('browseInputBtn');
const browseOutputBtn = document.getElementById('browseOutputBtn');
const widgetInfo = document.getElementById('widgetInfo');
const widgetCount = document.getElementById('widgetCount');
const generateBtn = document.getElementById('generateBtn');
const runCoverageBtn = document.getElementById('runCoverageBtn');
const progressSection = document.getElementById('progressSection');
const outputSection = document.getElementById('outputSection');
const outputLog = document.getElementById('outputLog');
const clearLogBtn = document.getElementById('clearLogBtn');
const resultsSection = document.getElementById('resultsSection');
const coverageSection = document.getElementById('coverageSection');
const testSummarySection = document.getElementById('testSummarySection');
const summaryOverview = document.getElementById('summaryOverview');
const summaryTableBody = document.getElementById('summaryTableBody');
const viewCoverageBtn = document.getElementById('viewCoverageBtn');
const openCoverageFolderBtn = document.getElementById('openCoverageFolderBtn');

// Constraints elements
const useConstraintsCheckbox = document.getElementById('useConstraints');
const constraintsPanel = document.getElementById('constraintsPanel');
const constraintsText = document.getElementById('constraintsText');
const loadConstraintsBtn = document.getElementById('loadConstraintsBtn');

// State
let isGenerating = false;
let generatedTestScript = null;
let hasValidWidgets = false;  // Track ว่าไฟล์มี widgets หรือไม่
let testScriptGenerated = false;  // Track ว่า test script ถูก generate แล้วหรือไม่

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    checkFileSystemAccess();
});

function setupEventListeners() {
    browseInputBtn.addEventListener('click', browseInputFile);
    browseOutputBtn.addEventListener('click', browseOutputFile);
    generateBtn.addEventListener('click', generateTests);
    runCoverageBtn.addEventListener('click', runCoverageTest);
    clearLogBtn.addEventListener('click', clearLog);
    viewCoverageBtn.addEventListener('click', viewCoverageReport);
    openCoverageFolderBtn.addEventListener('click', openCoverageFolder);

    // -------------------------------------------------------------------------
    // Constraints event listeners
    // สำหรับจัดการ PICT constraints panel
    // -------------------------------------------------------------------------

    // เมื่อ checkbox เปลี่ยนสถานะ -> แสดง/ซ่อน constraints panel
    useConstraintsCheckbox.addEventListener('change', toggleConstraintsPanel);

    // เมื่อกดปุ่ม "Load from file" -> เปิด file picker เพื่อโหลด constraints
    loadConstraintsBtn.addEventListener('click', loadConstraintsFile);
}

// =============================================================================
// PICT CONSTRAINTS FUNCTIONS
// =============================================================================

/**
 * toggleConstraintsPanel - แสดง/ซ่อน constraints panel
 *
 * เมื่อ user เลือก "Use custom constraints" checkbox:
 * - checked: แสดง panel ให้โหลด constraints จากไฟล์
 * - unchecked: ซ่อน panel
 */
function toggleConstraintsPanel() {
    if (useConstraintsCheckbox.checked) {
        // แสดง constraints panel โดยลบ class 'hidden'
        constraintsPanel.classList.remove('hidden');
    } else {
        // ซ่อน constraints panel โดยเพิ่ม class 'hidden'
        constraintsPanel.classList.add('hidden');
    }
}

/**
 * loadConstraintsFile - โหลด PICT constraints จากไฟล์
 *
 * เปิด native file picker ให้ user เลือกไฟล์ .txt หรือ .pict
 * แล้วโหลด content มาใส่ใน textarea
 *
 * รองรับไฟล์:
 * - .txt  - text file ทั่วไป
 * - .pict - PICT constraints file
 *
 * ตัวอย่าง PICT Constraints:
 *   IF [dropdown] = "option1" THEN [checkbox] <> "unchecked";
 *   IF [textField] = "empty" THEN [submitButton] = "disabled";
 */
async function loadConstraintsFile() {
    try {
        // เปิด file picker dialog ให้ user เลือกไฟล์
        const [fileHandle] = await window.showOpenFilePicker({
            types: [{
                description: 'Text Files',
                accept: { 'text/plain': ['.txt', '.pict'] }
            }],
            multiple: false  // เลือกได้ไฟล์เดียว
        });

        // อ่านเนื้อหาไฟล์
        const file = await fileHandle.getFile();
        const content = await file.text();

        // ใส่เนื้อหาลง textarea
        constraintsText.value = content;

        // แสดง log ว่าโหลดสำเร็จ
        log(`Loaded constraints from: ${file.name}`, 'info');
    } catch (err) {
        // ไม่แสดง error ถ้า user กด Cancel (AbortError)
        if (err.name !== 'AbortError') {
            log(`Error loading constraints: ${err.message}`, 'error');
        }
    }
}

// Check if File System Access API is available
function checkFileSystemAccess() {
    if (!('showOpenFilePicker' in window)) {
        log('Warning: File System Access API not supported. Please use Chrome or Edge.', 'error');
    }
}

// Browse for input file using native file picker
async function browseInputFile() {
    // Reset state เมื่อเลือกไฟล์ใหม่
    testScriptGenerated = false;
    generatedTestScript = null;

    try {
        const [fileHandle] = await window.showOpenFilePicker({
            types: [{
                description: 'Dart Files',
                accept: { 'text/plain': ['.dart'] }
            }],
            multiple: false
        });

        // Get the file path (we need to send relative path to server)
        const file = await fileHandle.getFile();
        const fileName = file.name;

        // Try to get the full path by reading content and matching
        const content = await file.text();

        // Store file handle for later use
        inputFileInput.dataset.fileHandle = 'set';
        inputFileInput.value = fileName;

        // Ask server to find the file path
        const response = await fetch(`${API_BASE}/find-file`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ fileName, content })
        });

        const data = await response.json();
        if (data.success && data.filePath) {
            inputFileInput.value = data.filePath;

            // Auto-generate output path
            const baseName = fileName.replace('.dart', '');
            outputFileInput.value = `integration_test/${baseName}_flow_test.dart`;

            // Scan widgets
            scanWidgets(data.filePath);
        } else {
            // If can't find, just use the filename
            log(`File selected: ${fileName}`, 'info');
        }

        validateForm();
    } catch (err) {
        if (err.name !== 'AbortError') {
            log(`Error selecting file: ${err.message}`, 'error');
        }
    }
}

// Browse for output file location
async function browseOutputFile() {
    try {
        const fileHandle = await window.showSaveFilePicker({
            types: [{
                description: 'Dart Test Files',
                accept: { 'text/plain': ['.dart'] }
            }],
            suggestedName: 'test_flow_test.dart'
        });

        // Get the suggested file name
        const fileName = fileHandle.name;
        outputFileInput.value = `integration_test/${fileName}`;
        outputFileInput.dataset.fileHandle = 'set';

        validateForm();
    } catch (err) {
        if (err.name !== 'AbortError') {
            log(`Error selecting output location: ${err.message}`, 'error');
        }
    }
}

function validateForm() {
    const hasInput = inputFileInput.value.trim().length > 0;
    const hasOutput = outputFileInput.value.trim().length > 0;

    // Generate button: ต้องมี input, output, widgets, และไม่กำลัง generating
    // ถ้าไม่มี widgets → ปุ่มยัง disabled
    generateBtn.disabled = !hasInput || !hasOutput || !hasValidWidgets || isGenerating;

    // Run Coverage button: ต้อง generate test script เสร็จก่อน
    // จะ enable เฉพาะเมื่อ testScriptGenerated = true
    runCoverageBtn.disabled = !testScriptGenerated || isGenerating;
}

// Scan widgets
async function scanWidgets(filePath) {
    if (!filePath) return;

    widgetInfo.classList.add('hidden');
    hasValidWidgets = false;  // Reset state

    try {
        const response = await fetch(`${API_BASE}/scan`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ file: filePath })
        });

        const data = await response.json();

        if (data.success) {
            // ตรวจสอบว่าเจอ widgets หรือไม่
            hasValidWidgets = data.hasWidgets !== false && data.widgetCount > 0;

            // Get icon element
            const iconEl = widgetInfo.querySelector('.icon');

            if (hasValidWidgets) {
                // มี widgets → แสดงสีเขียว + checkmark
                widgetCount.textContent = `Found ${data.widgetCount} widgets in manifest`;
                widgetInfo.classList.remove('hidden');
                widgetInfo.classList.remove('error');
                if (iconEl) iconEl.textContent = '\u2713';  // ✓ checkmark
            } else {
                // ไม่มี widgets → แสดงสีแดง + X mark
                widgetCount.textContent = data.warning || `No widgets found in file`;
                widgetInfo.classList.remove('hidden');
                widgetInfo.classList.add('error');
                if (iconEl) iconEl.textContent = '\u2717';  // ✗ X mark
            }

            // Update button states หลังจาก scan
            validateForm();
        }
    } catch (error) {
        // Silent fail
        hasValidWidgets = false;
    }
}

// Generate tests
async function generateTests() {
    const filePath = inputFileInput.value.trim();
    const outputPath = outputFileInput.value.trim();
    if (!filePath || !outputPath || isGenerating) return;

    isGenerating = true;
    updateButtonStates();
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    resultsSection.classList.add('hidden');
    testSummarySection.classList.add('hidden');
    resetProgress();
    clearLog();

    log('=== Starting Test Generation ===\n', 'info');

    try {
        // Step 1: Extract manifest
        updateProgress(1, 'running', 'Extracting UI manifest...');
        const manifestResult = await runStep('extract-manifest', { file: filePath });
        if (!manifestResult.success) throw new Error(manifestResult.error);
        updateProgress(1, 'complete', manifestResult.manifestPath);
        log(`Manifest: ${manifestResult.manifestPath}`, 'success');

        // Step 2: Generate datasets
        updateProgress(2, 'running', 'Generating datasets (AI)...');
        const datasetResult = await runStep('generate-datasets', { manifest: manifestResult.manifestPath });
        if (datasetResult.skipped) {
            updateProgress(2, 'skipped', 'No text fields found');
            log('Datasets: Skipped (no text fields)', 'info');
        } else if (!datasetResult.success) {
            throw new Error(datasetResult.error);
        } else {
            updateProgress(2, 'complete', datasetResult.datasetsPath);
            log(`Datasets: ${datasetResult.datasetsPath}`, 'success');
        }

        // ---------------------------------------------------------------------
        // Step 3: Generate test data (PICT)
        // สร้าง pairwise test combinations จาก manifest
        // ---------------------------------------------------------------------

        updateProgress(3, 'running', 'Generating test plan (PICT)...');

        // เตรียม parameters สำหรับ API call
        // manifest: path ของ UI manifest file ที่สร้างจาก Step 1
        const testDataParams = { manifest: manifestResult.manifestPath };

        // ---------------------------------------------------------------------
        // เพิ่ม PICT constraints ถ้า user เปิดใช้งาน
        // Constraints ใช้สำหรับ:
        //   - กำหนด invalid combinations (เช่น IF [A]="x" THEN [B]<>"y")
        //   - กำหนด dependencies ระหว่าง parameters
        //   - ลด test cases ที่ไม่ต้องการ
        // ---------------------------------------------------------------------

        if (useConstraintsCheckbox.checked && constraintsText.value.trim()) {
            // เพิ่ม constraints string เข้าไปใน request body
            testDataParams.constraints = constraintsText.value.trim();
            log('Using custom PICT constraints', 'info');
        }

        // เรียก API เพื่อสร้าง test data
        const testDataResult = await runStep('generate-test-data', testDataParams);
        if (!testDataResult.success) throw new Error(testDataResult.error);
        updateProgress(3, 'complete', testDataResult.testDataPath);
        log(`Test plan: ${testDataResult.testDataPath}`, 'success');

        // Step 4: Generate test script
        updateProgress(4, 'running', 'Generating test script...');
        const scriptResult = await runStep('generate-test-script', {
            testData: testDataResult.testDataPath,
            outputPath: outputPath
        });
        if (!scriptResult.success) throw new Error(scriptResult.error);
        updateProgress(4, 'complete', scriptResult.testScriptPath);
        log(`Test script: ${scriptResult.testScriptPath}`, 'success');

        // Show test case summary
        if (scriptResult.summary) {
            showTestSummary(scriptResult.summary);
            log(`Test cases: ${scriptResult.summary.totalCases} total`, 'info');
        }

        // Step 5: Mark as skipped (user can run manually)
        updateProgress(5, 'skipped', 'Click "Run Coverage Test" to run');

        // Store generated test script path
        generatedTestScript = scriptResult.testScriptPath;
        testScriptGenerated = true;  // Enable "Run Coverage Test" button

        // Show results
        showResults({
            manifest: manifestResult.manifestPath,
            datasets: datasetResult.skipped ? 'Skipped' : datasetResult.datasetsPath,
            testData: testDataResult.testDataPath,
            testScript: scriptResult.testScriptPath
        });

        log('\n=== Generation complete! ===', 'success');
        log('Click "Run Coverage Test" to execute tests.', 'info');

    } catch (error) {
        log(`\nError: ${error.message}`, 'error');
    } finally {
        isGenerating = false;
        updateButtonStates();
    }
}

// Run coverage test
async function runCoverageTest() {
    const testScript = outputFileInput.value.trim();
    if (!testScript || isGenerating) return;

    isGenerating = true;
    updateButtonStates();
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    coverageSection.classList.add('hidden');
    clearLog();

    log('=== Running Coverage Test ===\n', 'info');
    log('Step 1: Running flutter test with --coverage...', 'info');
    updateProgress(5, 'running', 'Running tests with coverage...');

    // Set all summary rows to "Running..." state
    setSummaryRunningState();

    try {
        const testResult = await runStep('run-tests', {
            testScript: testScript,
            withCoverage: true,
            useDevice: true  // Always run on device/emulator for integration test
        });

        if (testResult.success) {
            updateProgress(5, 'complete', `${testResult.passed} passed + coverage`);
            log(`Tests: ${testResult.passed} passed, ${testResult.failed} failed`, 'success');

            // แสดงจำนวน test cases และรายชื่อ
            if (testResult.testCases && testResult.testCases.length > 0) {
                log(`\n--- Test Cases (${testResult.totalTests} cases) ---`, 'info');
                testResult.testCases.forEach((tc, index) => {
                    const statusIcon = tc.status === 'passed' ? '✓' : '✗';
                    const statusClass = tc.status === 'passed' ? 'success' : 'error';
                    log(`  ${statusIcon} ${index + 1}. ${tc.name}`, statusClass);
                });
            }

            // Check if HTML coverage was generated
            if (testResult.coverageHtmlPath) {
                log('\nStep 2: Generated HTML coverage report', 'success');
                log(`Coverage HTML: ${testResult.coverageHtmlPath}`, 'success');
                log('\n=== Coverage test completed! ===', 'success');

                // Show coverage section
                showCoverageSection(testResult.passed, testResult.failed, testResult.coverageHtmlPath, testResult.testCases);
            } else {
                log('\nWarning: Could not generate HTML coverage report', 'error');
                log('Make sure genhtml (lcov) is installed: brew install lcov', 'info');
            }
        } else {
            updateProgress(5, 'error', testResult.error);
            log(`Tests failed: ${testResult.error}`, 'error');

            // แสดง test cases ที่ fail
            if (testResult.testCases && testResult.testCases.length > 0) {
                log(`\n--- Test Cases (${testResult.totalTests} cases) ---`, 'info');
                testResult.testCases.forEach((tc, index) => {
                    const statusIcon = tc.status === 'passed' ? '✓' : '✗';
                    const statusClass = tc.status === 'passed' ? 'success' : 'error';
                    log(`  ${statusIcon} ${index + 1}. ${tc.name}`, statusClass);
                });
            }
        }

        // Update summary table with coverage results
        if (testResult.testCases && testResult.testCases.length > 0) {
            updateSummaryFromCoverage(testResult.testCases);
        }

        if (testResult.output) {
            log('\n--- Raw Test Output ---', 'info');
            log(testResult.output, '');
        }
    } catch (error) {
        updateProgress(5, 'error', error.message);
        log(`Error: ${error.message}`, 'error');
    } finally {
        isGenerating = false;
        updateButtonStates();
    }
}

// Show coverage section with results
function showCoverageSection(passed, failed, htmlPath, testCases) {
    coverageSection.classList.remove('hidden');
    const summary = document.getElementById('coverageSummary');

    // แสดงจำนวน test cases
    const totalCases = testCases ? testCases.length : (passed + failed);
    summary.textContent = `Coverage report generated! (${totalCases} test cases: ${passed} passed, ${failed} failed)`;

    // Update coverage path display
    const pathEl = document.querySelector('.coverage-path');
    if (pathEl && htmlPath) {
        pathEl.textContent = htmlPath;
    }
}

// View coverage report in browser
async function viewCoverageReport() {
    try {
        // Open coverage report via server
        const response = await fetch(`${API_BASE}/open-coverage`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'view' })
        });

        const data = await response.json();
        if (data.success && data.url) {
            window.open(data.url, '_blank');
        } else {
            // Fallback: open local file
            window.open(`${API_BASE}/coverage/index.html`, '_blank');
        }
    } catch (error) {
        // Fallback: try to open via server
        window.open(`${API_BASE}/coverage/index.html`, '_blank');
    }
}

// Open coverage folder in file explorer
async function openCoverageFolder() {
    try {
        const response = await fetch(`${API_BASE}/open-coverage`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ action: 'folder' })
        });

        const data = await response.json();
        if (!data.success) {
            log('Could not open coverage folder', 'error');
        }
    } catch (error) {
        log(`Error: ${error.message}`, 'error');
    }
}

function updateButtonStates() {
    validateForm();
    generateBtn.querySelector('.btn-text').textContent = isGenerating ? 'Generating...' : 'Generate Test Script';
}

// Run a single step
async function runStep(step, params) {
    const response = await fetch(`${API_BASE}/${step}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(params)
    });
    return await response.json();
}

// Progress helpers
function resetProgress() {
    document.querySelectorAll('.progress-item').forEach(item => {
        item.className = 'progress-item';
        item.querySelector('.progress-icon').textContent = '\u25CB'; // empty circle
        item.querySelector('.progress-status').textContent = '';
    });
}

function updateProgress(step, status, message) {
    const item = document.querySelector(`.progress-item[data-step="${step}"]`);
    if (!item) return;

    item.className = `progress-item ${status}`;
    const icon = item.querySelector('.progress-icon');
    const statusEl = item.querySelector('.progress-status');

    switch (status) {
        case 'running':
            icon.textContent = '\u25CF'; // filled circle
            break;
        case 'complete':
            icon.textContent = '\u2713'; // check mark
            break;
        case 'error':
            icon.textContent = '\u2717'; // X mark
            break;
        case 'skipped':
            icon.textContent = '\u2212'; // minus
            break;
    }

    statusEl.textContent = message || '';
}

// Logging
function log(message, type = '') {
    const line = document.createElement('div');
    line.className = `log-line ${type}`;
    line.textContent = message;
    outputLog.appendChild(line);
    outputLog.scrollTop = outputLog.scrollHeight;
}

function clearLog() {
    outputLog.innerHTML = '';
}

// Show test case summary
function showTestSummary(summary) {
    if (!summary) {
        testSummarySection.classList.add('hidden');
        return;
    }

    // Overview badges: total + group breakdown
    let badgesHtml = `<div class="summary-badge"><strong>${summary.totalCases}</strong> Total Cases</div>`;
    for (const g of summary.groups) {
        badgesHtml += `<div class="summary-badge"><strong>${g.count}</strong> ${g.name}</div>`;
    }
    summaryOverview.innerHTML = badgesHtml;

    // Table rows
    let rowsHtml = '';
    summary.cases.forEach((c, i) => {
        rowsHtml += `<tr>
            <td>${i + 1}</td>
            <td>${c.tc}</td>
            <td>${c.group}</td>
            <td class="result-cell" data-tc="${c.tc}"><span class="result-status">-</span></td>
        </tr>`;
    });
    summaryTableBody.innerHTML = rowsHtml;

    testSummarySection.classList.remove('hidden');
}

// Set all summary rows to "Running..." state before coverage test
function setSummaryRunningState() {
    summaryTableBody.querySelectorAll('.result-status').forEach(el => {
        el.textContent = 'Running...';
        el.className = 'result-status running';
    });
}

// Update summary table Result column from coverage test results
function updateSummaryFromCoverage(testCases) {
    summaryTableBody.querySelectorAll('.result-cell').forEach(cell => {
        const tcName = cell.dataset.tc;
        if (!tcName) return;

        // Match: server ส่งชื่อเต็ม (รวม group prefix) แต่ตารางใช้ tc สั้น
        const matched = testCases.find(tc => tc.name === tcName || tc.name.endsWith(tcName));
        if (!matched) return;

        const statusEl = cell.querySelector('.result-status');
        if (matched.status === 'passed') {
            statusEl.textContent = 'Passed';
            statusEl.className = 'result-status passed';
        } else {
            statusEl.textContent = 'Failed';
            statusEl.className = 'result-status failed';
        }
    });
}

// Show results
function showResults(results) {
    resultsSection.classList.remove('hidden');

    document.querySelector('#manifestResult .result-path').textContent = results.manifest || '-';
    document.querySelector('#datasetsResult .result-path').textContent = results.datasets || '-';
    document.querySelector('#testDataResult .result-path').textContent = results.testData || '-';
    document.querySelector('#testScriptResult .result-path').textContent = results.testScript || '-';
}
