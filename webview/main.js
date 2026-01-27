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
const runTestBtn = document.getElementById('runTestBtn');
const runCoverageBtn = document.getElementById('runCoverageBtn');
const progressSection = document.getElementById('progressSection');
const outputSection = document.getElementById('outputSection');
const outputLog = document.getElementById('outputLog');
const clearLogBtn = document.getElementById('clearLogBtn');
const resultsSection = document.getElementById('resultsSection');

// State
let isGenerating = false;
let generatedTestScript = null;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    checkFileSystemAccess();
});

function setupEventListeners() {
    browseInputBtn.addEventListener('click', browseInputFile);
    browseOutputBtn.addEventListener('click', browseOutputFile);
    generateBtn.addEventListener('click', generateTests);
    runTestBtn.addEventListener('click', runAutomateTest);
    runCoverageBtn.addEventListener('click', runCoverageTest);
    clearLogBtn.addEventListener('click', clearLog);
}

// Check if File System Access API is available
function checkFileSystemAccess() {
    if (!('showOpenFilePicker' in window)) {
        log('Warning: File System Access API not supported. Please use Chrome or Edge.', 'error');
    }
}

// Browse for input file using native file picker
async function browseInputFile() {
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

    generateBtn.disabled = !hasInput || !hasOutput || isGenerating;

    // Enable run buttons if we have a test script path
    const testScriptExists = outputFileInput.value.trim().length > 0;
    runTestBtn.disabled = !testScriptExists || isGenerating;
    runCoverageBtn.disabled = !testScriptExists || isGenerating;
}

// Scan widgets
async function scanWidgets(filePath) {
    if (!filePath) return;

    widgetInfo.classList.add('hidden');

    try {
        const response = await fetch(`${API_BASE}/scan`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ file: filePath })
        });

        const data = await response.json();

        if (data.success) {
            widgetCount.textContent = `Found ${data.widgetCount} widgets in manifest`;
            widgetInfo.classList.remove('hidden');
        }
    } catch (error) {
        // Silent fail
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

        // Step 3: Generate test data
        updateProgress(3, 'running', 'Generating test plan (PICT)...');
        const testDataResult = await runStep('generate-test-data', { manifest: manifestResult.manifestPath });
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

        // Step 5: Mark as skipped (user can run manually)
        updateProgress(5, 'skipped', 'Click "Run Automate Test" to run');

        // Store generated test script path
        generatedTestScript = scriptResult.testScriptPath;

        // Show results
        showResults({
            manifest: manifestResult.manifestPath,
            datasets: datasetResult.skipped ? 'Skipped' : datasetResult.datasetsPath,
            testData: testDataResult.testDataPath,
            testScript: scriptResult.testScriptPath
        });

        log('\n=== Generation complete! ===', 'success');
        log('Click "Run Automate Test" or "Run Coverage Test" to execute tests.', 'info');

    } catch (error) {
        log(`\nError: ${error.message}`, 'error');
    } finally {
        isGenerating = false;
        updateButtonStates();
    }
}

// Run automate test
async function runAutomateTest() {
    const testScript = outputFileInput.value.trim();
    if (!testScript || isGenerating) return;

    isGenerating = true;
    updateButtonStates();
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    clearLog();

    log('=== Running Automate Test ===\n', 'info');
    updateProgress(5, 'running', 'Running tests...');

    try {
        const testResult = await runStep('run-tests', {
            testScript: testScript,
            withCoverage: false
        });

        if (testResult.success) {
            updateProgress(5, 'complete', `${testResult.passed} passed`);
            log(`Tests: ${testResult.passed} passed, ${testResult.failed} failed`, 'success');
            log('\n=== Tests completed! ===', 'success');
        } else {
            updateProgress(5, 'error', testResult.error);
            log(`Tests failed: ${testResult.error}`, 'error');
        }

        if (testResult.output) {
            log('\n--- Test Output ---', 'info');
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

// Run coverage test
async function runCoverageTest() {
    const testScript = outputFileInput.value.trim();
    if (!testScript || isGenerating) return;

    isGenerating = true;
    updateButtonStates();
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    clearLog();

    log('=== Running Coverage Test ===\n', 'info');
    updateProgress(5, 'running', 'Running tests with coverage...');

    try {
        const testResult = await runStep('run-tests', {
            testScript: testScript,
            withCoverage: true
        });

        if (testResult.success) {
            updateProgress(5, 'complete', `${testResult.passed} passed + coverage`);
            log(`Tests: ${testResult.passed} passed, ${testResult.failed} failed`, 'success');
            log('Coverage report generated in coverage/ directory', 'success');
            log('\n=== Coverage test completed! ===', 'success');
        } else {
            updateProgress(5, 'error', testResult.error);
            log(`Tests failed: ${testResult.error}`, 'error');
        }

        if (testResult.output) {
            log('\n--- Test Output ---', 'info');
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

// Show results
function showResults(results) {
    resultsSection.classList.remove('hidden');

    document.querySelector('#manifestResult .result-path').textContent = results.manifest || '-';
    document.querySelector('#datasetsResult .result-path').textContent = results.datasets || '-';
    document.querySelector('#testDataResult .result-path').textContent = results.testData || '-';
    document.querySelector('#testScriptResult .result-path').textContent = results.testScript || '-';
}
