// API Base URL
const API_BASE = 'http://localhost:8080';

// DOM Elements
const uiFileInput = document.getElementById('uiFile');
const scanBtn = document.getElementById('scanBtn');
const widgetInfo = document.getElementById('widgetInfo');
const widgetCount = document.getElementById('widgetCount');
const showFilesBtn = document.getElementById('showFilesBtn');
const fileList = document.getElementById('fileList');
const skipDatasetsCheckbox = document.getElementById('skipDatasets');
const runTestsCheckbox = document.getElementById('runTests');
const withCoverageCheckbox = document.getElementById('withCoverage');
const generateBtn = document.getElementById('generateBtn');
const generateAllBtn = document.getElementById('generateAllBtn');
const progressSection = document.getElementById('progressSection');
const outputSection = document.getElementById('outputSection');
const outputLog = document.getElementById('outputLog');
const clearLogBtn = document.getElementById('clearLogBtn');
const resultsSection = document.getElementById('resultsSection');

// State
let availableFiles = [];
let isGenerating = false;

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadAvailableFiles();
    setupEventListeners();
});

function setupEventListeners() {
    uiFileInput.addEventListener('input', validateForm);
    scanBtn.addEventListener('click', scanWidgets);
    showFilesBtn.addEventListener('click', toggleFileList);
    generateBtn.addEventListener('click', generateTests);
    generateAllBtn.addEventListener('click', generateAllTests);
    clearLogBtn.addEventListener('click', clearLog);
}

// Load available Dart files
async function loadAvailableFiles() {
    try {
        const response = await fetch(`${API_BASE}/files`);
        if (response.ok) {
            const data = await response.json();
            availableFiles = data.files || [];
            renderFileList();
        }
    } catch (error) {
        log('Could not load file list. Make sure the server is running.', 'error');
        // Fallback: Show message
        fileList.innerHTML = '<div class="file-item">Server not running. Start with: dart run webview/server.dart</div>';
    }
}

function renderFileList() {
    fileList.innerHTML = availableFiles.map(file =>
        `<div class="file-item" onclick="selectFile('${file}')">${file}</div>`
    ).join('');
}

function selectFile(file) {
    uiFileInput.value = file;
    fileList.classList.add('hidden');
    validateForm();
    scanWidgets();
}

function toggleFileList() {
    fileList.classList.toggle('hidden');
    showFilesBtn.textContent = fileList.classList.contains('hidden')
        ? 'Show available files'
        : 'Hide files';
}

function validateForm() {
    const hasFile = uiFileInput.value.trim().length > 0;
    generateBtn.disabled = !hasFile || isGenerating;
}

// Scan widgets
async function scanWidgets() {
    const filePath = uiFileInput.value.trim();
    if (!filePath) return;

    scanBtn.disabled = true;
    scanBtn.textContent = 'Scanning...';
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
            validateForm();
        } else {
            log(`Scan failed: ${data.error}`, 'error');
        }
    } catch (error) {
        log(`Scan error: ${error.message}`, 'error');
    } finally {
        scanBtn.disabled = false;
        scanBtn.textContent = 'Scan Widgets';
    }
}

// Generate tests for single file
async function generateTests() {
    const filePath = uiFileInput.value.trim();
    if (!filePath || isGenerating) return;

    isGenerating = true;
    generateBtn.disabled = true;
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    resultsSection.classList.add('hidden');
    resetProgress();
    clearLog();

    const config = {
        file: filePath,
        skipDatasets: skipDatasetsCheckbox.checked,
        runTests: runTestsCheckbox.checked,
        withCoverage: withCoverageCheckbox.checked
    };

    try {
        // Step 1: Extract manifest
        updateProgress(1, 'running', 'Extracting UI manifest...');
        const manifestResult = await runStep('extract-manifest', { file: filePath });
        if (!manifestResult.success) throw new Error(manifestResult.error);
        updateProgress(1, 'complete', manifestResult.manifestPath);
        log(`Manifest: ${manifestResult.manifestPath}`, 'success');

        // Step 2: Generate datasets
        if (!config.skipDatasets) {
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
        } else {
            updateProgress(2, 'skipped', 'Skipped by user');
            log('Datasets: Skipped by user', 'info');
        }

        // Step 3: Generate test data
        updateProgress(3, 'running', 'Generating test plan (PICT)...');
        const testDataResult = await runStep('generate-test-data', { manifest: manifestResult.manifestPath });
        if (!testDataResult.success) throw new Error(testDataResult.error);
        updateProgress(3, 'complete', testDataResult.testDataPath);
        log(`Test plan: ${testDataResult.testDataPath}`, 'success');

        // Step 4: Generate test script
        updateProgress(4, 'running', 'Generating test script...');
        const scriptResult = await runStep('generate-test-script', { testData: testDataResult.testDataPath });
        if (!scriptResult.success) throw new Error(scriptResult.error);
        updateProgress(4, 'complete', scriptResult.testScriptPath);
        log(`Test script: ${scriptResult.testScriptPath}`, 'success');

        // Step 5: Run tests (optional)
        if (config.runTests) {
            updateProgress(5, 'running', 'Running tests...');
            const testResult = await runStep('run-tests', {
                testScript: scriptResult.testScriptPath,
                withCoverage: config.withCoverage
            });
            if (testResult.success) {
                updateProgress(5, 'complete', `${testResult.passed} passed`);
                log(`Tests: ${testResult.passed} passed, ${testResult.failed} failed`, 'success');
            } else {
                updateProgress(5, 'error', testResult.error);
                log(`Tests failed: ${testResult.error}`, 'error');
            }
        } else {
            updateProgress(5, 'skipped', 'Skipped');
        }

        // Show results
        showResults({
            manifest: manifestResult.manifestPath,
            datasets: config.skipDatasets ? 'Skipped' : 'Generated',
            testData: testDataResult.testDataPath,
            testScript: scriptResult.testScriptPath
        });

        log('\n=== Generation complete! ===', 'success');

    } catch (error) {
        log(`\nError: ${error.message}`, 'error');
    } finally {
        isGenerating = false;
        generateBtn.disabled = false;
    }
}

// Generate tests for all files
async function generateAllTests() {
    if (isGenerating) return;

    isGenerating = true;
    generateAllBtn.disabled = true;
    progressSection.classList.remove('hidden');
    outputSection.classList.remove('hidden');
    clearLog();

    log('=== Generating tests for all files ===\n', 'info');

    try {
        const response = await fetch(`${API_BASE}/generate-all`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                skipDatasets: skipDatasetsCheckbox.checked,
                runTests: runTestsCheckbox.checked,
                withCoverage: withCoverageCheckbox.checked
            })
        });

        const data = await response.json();

        if (data.success) {
            log(`\nProcessed ${data.filesProcessed} files`, 'success');
            log(`Generated ${data.testsGenerated} test files`, 'success');
        } else {
            log(`Error: ${data.error}`, 'error');
        }
    } catch (error) {
        log(`Error: ${error.message}`, 'error');
    } finally {
        isGenerating = false;
        generateAllBtn.disabled = false;
    }
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
        item.querySelector('.progress-icon').textContent = '\u25CB'; // ○
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
            icon.textContent = '\u25CF'; // ●
            break;
        case 'complete':
            icon.textContent = '\u2713'; // ✓
            break;
        case 'error':
            icon.textContent = '\u2717'; // ✗
            break;
        case 'skipped':
            icon.textContent = '\u2212'; // −
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

// Global function for file selection
window.selectFile = selectFile;
