// =============================================================================
// WebUI — Main controller class for Test Generation UI
// =============================================================================

class WebUI {
  // ----- Fields (Package Diagram) -----
  inputFile = '';
  outputDir = '';
  constraintsText = '';
  generatedTestScript = null;

  // ----- Static -----
  static API_BASE = 'http://localhost:8080';

  // ----- Private State -----
  #isGenerating = false;
  #hasValidWidgets = false;
  #testScriptGenerated = false;
  #dialogType = '';
  #dialogContext = '';  // 'scan' | 'constraints' — tracks which step triggered the dialog

  // ----- DOM References (cached) -----
  #el = {};

  constructor() {
    this.#initElements();
    this.#setupEventListeners();
    this.#checkFileSystemAccess();
  }

  // ===========================================================================
  // DOM Initialization
  // ===========================================================================

  #initElements() {
    this.#el = {
      inputFile: document.getElementById('inputFile'),
      outputDir: document.getElementById('outputDir'),
      outputFileName: document.getElementById('outputFileName'),
      testScriptFile: document.getElementById('testScriptFile'),
      browseInputBtn: document.getElementById('browseInputBtn'),
      browseOutputBtn: document.getElementById('browseOutputBtn'),
      widgetInfo: document.getElementById('widgetInfo'),
      widgetCount: document.getElementById('widgetCount'),
      generateBtn: document.getElementById('generateBtn'),
      runCoverageBtn: document.getElementById('runCoverageBtn'),
      progressSection: document.getElementById('progressSection'),
      outputSection: document.getElementById('outputSection'),
      outputLog: document.getElementById('outputLog'),
      clearLogBtn: document.getElementById('clearLogBtn'),
      resultsSection: document.getElementById('resultsSection'),
      coverageSection: document.getElementById('coverageSection'),
      testSummarySection: document.getElementById('testSummarySection'),
      summaryOverview: document.getElementById('summaryOverview'),
      summaryTableBody: document.getElementById('summaryTableBody'),
      viewCoverageBtn: document.getElementById('viewCoverageBtn'),
      openCoverageFolderBtn: document.getElementById('openCoverageFolderBtn'),
      useConstraints: document.getElementById('useConstraints'),
      constraintsPanel: document.getElementById('constraintsPanel'),
      constraintsTextArea: document.getElementById('constraintsText'),
      constraintsFile: document.getElementById('constraintsFile'),
      loadConstraintsBtn: document.getElementById('loadConstraintsBtn'),
      dialogOverlay: document.getElementById('dialogOverlay'),
      dialogIcon: document.getElementById('dialogIcon'),
      dialogTitle: document.getElementById('dialogTitle'),
      dialogMessage: document.getElementById('dialogMessage'),
      dialogCloseBtn: document.getElementById('dialogCloseBtn'),
    };
  }

  #setupEventListeners() {
    this.#el.browseInputBtn.addEventListener('click', () => this.browseInputFile());
    this.#el.browseOutputBtn.addEventListener('click', () => this.browseOutputDir());
    this.#el.generateBtn.addEventListener('click', () => this.generateTests());
    this.#el.runCoverageBtn.addEventListener('click', () => this.runCoverageTest());
    this.#el.outputDir.addEventListener('input', () => this.#updateOutputFileName());
    this.#el.clearLogBtn.addEventListener('click', () => this.#clearLog());
    this.#el.viewCoverageBtn.addEventListener('click', () => this.#viewCoverageReport());
    this.#el.openCoverageFolderBtn.addEventListener('click', () => this.#openCoverageFolder());
    this.#el.useConstraints.addEventListener('change', () => this.#toggleConstraintsPanel());
    this.#el.loadConstraintsBtn.addEventListener('click', () => this.#loadConstraintsFile());
    this.#el.dialogCloseBtn.addEventListener('click', () => this.#closeDialog());
    this.#el.dialogOverlay.addEventListener('click', (e) => {
      if (e.target === this.#el.dialogOverlay) this.#closeDialog();
    });
  }

  // ===========================================================================
  // Public Methods (Package Diagram)
  // ===========================================================================

  // Browse for input file using native file picker
  async browseInputFile() {
    // Reset state เมื่อเลือกไฟล์ใหม่
    this.#testScriptGenerated = false;
    this.generatedTestScript = null;

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
      this.#el.inputFile.dataset.fileHandle = 'set';
      this.#el.inputFile.value = fileName;

      // Ask server to find the file path
      const response = await fetch(`${WebUI.API_BASE}/find-file`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ fileName, content })
      });

      const data = await response.json();
      if (data.success && data.filePath) {
        this.#el.inputFile.value = data.filePath;

        // Auto-set default output directory
        if (!this.#el.outputDir.value.trim()) {
          this.#el.outputDir.value = 'integration_test/';
        }
        this.#updateOutputFileName();

        // Scan widgets
        this.#scanWidgets(data.filePath);
      } else {
        // If can't find, just use the filename
        this.#log(`File selected: ${fileName}`, 'info');
      }

      this.#validateForm();
    } catch (err) {
      if (err.name !== 'AbortError') {
        this.#log(`Error selecting file: ${err.message}`, 'error');
      }
    }
  }

  // Browse for output directory
  async browseOutputDir() {
    try {
      const dirHandle = await window.showDirectoryPicker();
      this.#el.outputDir.value = dirHandle.name + '/';
      this.#updateOutputFileName();
      this.#validateForm();
    } catch (err) {
      if (err.name !== 'AbortError') {
        this.#log(`Error selecting output directory: ${err.message}`, 'error');
      }
    }
  }

  // Generate tests
  async generateTests() {
    const filePath = this.#el.inputFile.value.trim();
    const outputPath = this.#getOutputFilePath();
    if (!filePath || !outputPath || this.#isGenerating) return;

    this.#isGenerating = true;
    this.#updateButtonStates();
    this.#el.progressSection.classList.remove('hidden');
    this.#el.outputSection.classList.remove('hidden');
    this.#el.resultsSection?.classList.add('hidden');
    this.#el.testSummarySection.classList.add('hidden');
    this.#resetProgress();
    this.#clearLog();

    this.#log('=== Starting Test Generation ===\n', 'info');

    try {
      // Step 1: Extract manifest
      this.#updateProgress(1, 'running', 'Extracting UI manifest...');
      const manifestResult = await this.#runStep('extract-manifest', { file: filePath });
      if (!manifestResult.success) throw new Error(manifestResult.error);
      this.#updateProgress(1, 'complete', manifestResult.manifestPath);
      this.#log(`Manifest: ${manifestResult.manifestPath}`, 'success');

      // Step 2: Generate datasets
      this.#updateProgress(2, 'running', 'Generating datasets (AI)...');
      const datasetResult = await this.#runStep('generate-datasets', { manifest: manifestResult.manifestPath });
      if (datasetResult.skipped) {
        this.#updateProgress(2, 'skipped', 'No text fields found');
        this.#log('Datasets: Skipped (no text fields)', 'info');
      } else if (!datasetResult.success) {
        throw new Error(datasetResult.error);
      } else {
        this.#updateProgress(2, 'complete', datasetResult.datasetsPath);
        this.#log(`Datasets: ${datasetResult.datasetsPath}`, 'success');
      }

      // Step 3: Generate test data (PICT)
      this.#updateProgress(3, 'running', 'Generating test plan (PICT)...');

      const testDataParams = { manifest: manifestResult.manifestPath };

      if (this.#el.useConstraints.checked && this.#el.constraintsTextArea.value.trim()) {
        testDataParams.constraints = this.#el.constraintsTextArea.value.trim();
        this.#log('Using custom PICT constraints', 'info');
      }

      const testDataResult = await this.#runStep('generate-test-data', testDataParams);
      if (!testDataResult.success) throw new Error(testDataResult.error);
      this.#updateProgress(3, 'complete', testDataResult.testDataPath);
      this.#log(`Test plan: ${testDataResult.testDataPath}`, 'success');

      // Step 4: Generate test script
      this.#updateProgress(4, 'running', 'Generating test script...');
      const scriptResult = await this.#runStep('generate-test-script', {
        testData: testDataResult.testDataPath,
        outputPath: outputPath
      });
      if (!scriptResult.success) throw new Error(scriptResult.error);
      this.#updateProgress(4, 'complete', scriptResult.testScriptPath);
      this.#log(`Test script: ${scriptResult.testScriptPath}`, 'success');

      // Show test case summary
      if (scriptResult.summary) {
        this.#showTestSummary(scriptResult.summary);
        this.#log(`Test cases: ${scriptResult.summary.totalCases} total`, 'info');
      }

      // Store generated test script path and set as default for coverage
      this.generatedTestScript = scriptResult.testScriptPath;
      this.#testScriptGenerated = true;
      this.#el.testScriptFile.textContent = scriptResult.testScriptPath;

      // Show results
      this.#showResults({
        manifest: manifestResult.manifestPath,
        datasets: datasetResult.skipped ? 'Skipped' : datasetResult.datasetsPath,
        testData: testDataResult.testDataPath,
        testScript: scriptResult.testScriptPath
      });

      this.#log('\n=== Generation complete! ===', 'success');
      this.#log('Click "Run Coverage Test" to execute tests.', 'info');

    } catch (error) {
      this.#log(`\nError: ${error.message}`, 'error');
    } finally {
      this.#isGenerating = false;
      this.#updateButtonStates();
    }
  }

  // Run coverage test
  async runCoverageTest() {
    const testScript = this.#el.testScriptFile.textContent.trim();
    if (!testScript || this.#isGenerating) return;

    this.#isGenerating = true;
    this.#updateButtonStates();
    this.#el.outputSection.classList.remove('hidden');
    this.#el.coverageSection.classList.add('hidden');
    this.#clearLog();

    this.#log('=== Running Coverage Test ===\n', 'info');
    this.#log('Running flutter test with --coverage...', 'info');

    // Set all summary rows to "Running..." state
    this.#setSummaryRunningState();

    try {
      const testResult = await this.#runStep('run-tests', {
        testScript: testScript,
        withCoverage: true,
        useDevice: true
      });

      if (testResult.success) {
        this.#log(`Tests: ${testResult.passed} passed, ${testResult.failed} failed`, 'success');

        if (testResult.testCases && testResult.testCases.length > 0) {
          this.#log(`\n--- Test Cases (${testResult.totalTests} cases) ---`, 'info');
          testResult.testCases.forEach((tc, index) => {
            const statusIcon = tc.status === 'passed' ? '\u2713' : '\u2717';
            const statusClass = tc.status === 'passed' ? 'success' : 'error';
            this.#log(`  ${statusIcon} ${index + 1}. ${tc.name}`, statusClass);
          });
        }

        if (testResult.coverageHtmlPath) {
          this.#log('\nStep 2: Generated HTML coverage report', 'success');
          this.#log(`Coverage HTML: ${testResult.coverageHtmlPath}`, 'success');
          this.#log('\n=== Coverage test completed! ===', 'success');

          this.#showCoverageSection(testResult.passed, testResult.failed, testResult.coverageHtmlPath, testResult.testCases);
        } else {
          this.#log('\nWarning: Could not generate HTML coverage report', 'error');
          this.#log('Make sure genhtml (lcov) is installed: brew install lcov', 'info');
        }
      } else {
        this.#log(`Tests failed: ${testResult.error}`, 'error');

        if (testResult.testCases && testResult.testCases.length > 0) {
          this.#log(`\n--- Test Cases (${testResult.totalTests} cases) ---`, 'info');
          testResult.testCases.forEach((tc, index) => {
            const statusIcon = tc.status === 'passed' ? '\u2713' : '\u2717';
            const statusClass = tc.status === 'passed' ? 'success' : 'error';
            this.#log(`  ${statusIcon} ${index + 1}. ${tc.name}`, statusClass);
          });
        }
      }

      // Update summary table with coverage results
      if (testResult.testCases && testResult.testCases.length > 0) {
        this.#updateSummaryFromCoverage(testResult.testCases);
      }

      if (testResult.output) {
        this.#log('\n--- Raw Test Output ---', 'info');
        this.#log(testResult.output, '');
      }
    } catch (error) {
      this.#log(`Error: ${error.message}`, 'error');
    } finally {
      this.#isGenerating = false;
      this.#updateButtonStates();
    }
  }

  // ===========================================================================
  // Private Methods
  // ===========================================================================

  #checkFileSystemAccess() {
    if (!('showOpenFilePicker' in window)) {
      this.#log('Warning: File System Access API not supported. Please use Chrome or Edge.', 'error');
    }
  }

  #validateForm() {
    const hasInput = this.#el.inputFile.value.trim().length > 0;
    const hasOutputDir = this.#el.outputDir.value.trim().length > 0;
    const testScriptText = this.#el.testScriptFile.textContent.trim();
    const hasTestScript = testScriptText.length > 0 && testScriptText !== '-';

    this.#el.generateBtn.disabled = !hasInput || !hasOutputDir || !this.#hasValidWidgets || this.#isGenerating;
    this.#el.runCoverageBtn.disabled = !hasTestScript || this.#isGenerating;
  }

  // Compute output file path from directory + input filename
  #getOutputFilePath() {
    const inputPath = this.#el.inputFile.value.trim();
    const dir = this.#el.outputDir.value.trim();
    if (!inputPath || !dir) return '';

    const inputName = inputPath.split('/').pop().replace('.dart', '');
    const dirPath = dir.endsWith('/') ? dir : dir + '/';
    return `${dirPath}${inputName}_flow_test.dart`;
  }

  // Update the output filename hint
  #updateOutputFileName() {
    const path = this.#getOutputFilePath();
    this.#el.outputFileName.textContent = path || '-';
    this.#validateForm();
  }

  #toggleConstraintsPanel() {
    if (this.#el.useConstraints.checked) {
      this.#el.constraintsPanel.classList.remove('hidden');
    } else {
      this.#el.constraintsPanel.classList.add('hidden');
    }
  }

  async #loadConstraintsFile() {
    try {
      const [fileHandle] = await window.showOpenFilePicker({
        types: [{
          description: 'Text Files',
          accept: { 'text/plain': ['.txt', '.pict'] }
        }],
        multiple: false
      });

      const file = await fileHandle.getFile();
      const content = await file.text();

      // Validate PICT constraint syntax
      const syntaxError = this.#validateConstraintsSyntax(content);
      if (syntaxError) {
        this.#showDialog('error', 'Invalid Constraint Syntax', '', 'constraints');
        return;
      }

      this.#el.constraintsTextArea.value = content;
      this.#el.constraintsFile.value = file.name;
      this.#log(`Loaded constraints from: ${file.name}`, 'info');

      this.#showDialog(
        'success',
        'Constraints Imported Successfully',
        '',
        'constraints'
      );
    } catch (err) {
      if (err.name !== 'AbortError') {
        this.#log(`Error loading constraints: ${err.message}`, 'error');
      }
    }
  }

  async #scanWidgets(filePath) {
    if (!filePath) return;

    this.#el.widgetInfo.classList.add('hidden');
    this.#hasValidWidgets = false;

    try {
      const response = await fetch(`${WebUI.API_BASE}/scan`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ file: filePath })
      });

      const data = await response.json();
      const iconEl = this.#el.widgetInfo.querySelector('.icon');

      // Case 3: File is not a valid Dart file
      if (data.resultType === 'not_dart') {
        this.#hasValidWidgets = false;
        this.#el.widgetCount.textContent = data.error || 'Not a valid Dart file';
        this.#el.widgetInfo.classList.remove('hidden');
        this.#el.widgetInfo.classList.add('error');
        if (iconEl) iconEl.textContent = '\u2717';

        this.#showDialog(
          'error',
          'Import Failed',
          data.error || 'The imported file is not a Dart file (.dart)',
          'scan'
        );
        this.#validateForm();
        return;
      }

      // Case 2: No supported widgets found
      if (data.resultType === 'no_widgets') {
        this.#hasValidWidgets = false;

        this.#showDialog(
          'warning',
          'No Widgets Found',
          data.warning || 'No supported widgets found in this file',
          'scan'
        );
        this.#validateForm();
        return;
      }

      // Case 1: Import successful
      if (data.resultType === 'success' && data.hasWidgets) {
        this.#hasValidWidgets = true;
        this.#el.widgetCount.textContent = `Found ${data.widgetCount} widgets in manifest`;
        this.#el.widgetInfo.classList.remove('hidden');
        this.#el.widgetInfo.classList.remove('error');
        if (iconEl) iconEl.textContent = '\u2713';

        this.#showDialog(
          'success',
          'File Imported Successfully',
          `Found ${data.widgetCount} widgets — ready to generate tests`,
          'scan'
        );
        this.#validateForm();
        return;
      }

      // Fallback: กรณีอื่นๆ
      if (data.success) {
        this.#hasValidWidgets = data.hasWidgets !== false && data.widgetCount > 0;
        if (this.#hasValidWidgets) {
          this.#el.widgetCount.textContent = `Found ${data.widgetCount} widgets in manifest`;
          this.#el.widgetInfo.classList.remove('hidden');
          this.#el.widgetInfo.classList.remove('error');
          if (iconEl) iconEl.textContent = '\u2713';
        } else {
          this.#el.widgetCount.textContent = data.warning || 'No widgets found in file';
          this.#el.widgetInfo.classList.remove('hidden');
          this.#el.widgetInfo.classList.add('error');
          if (iconEl) iconEl.textContent = '\u2717';
        }
      }

      this.#validateForm();
    } catch (error) {
      this.#hasValidWidgets = false;
    }
  }

  // ===========================================================================
  // Dialog Methods
  // ===========================================================================

  /**
   * Validate PICT constraint syntax line-by-line.
   * @param {string} content - raw file content
   * @returns {string|null} error message or null if valid
   */
  #validateConstraintsSyntax(content) {
    const lines = content.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i].trim();

      // Skip empty lines and comments
      if (!line || line.startsWith('#')) continue;

      const lineNum = i + 1;

      // Must contain IF and THEN
      if (!/\bIF\b/.test(line) || !/\bTHEN\b/.test(line)) {
        return `Line ${lineNum}: Missing IF or THEN keyword\n"${line}"`;
      }

      // Split into IF-part and THEN-part
      const thenIndex = line.indexOf('THEN');
      const ifPart = line.substring(0, thenIndex);
      const thenPart = line.substring(thenIndex);

      // IF-part must have parameter in [...]
      if (!/\[.+?\]/.test(ifPart)) {
        return `Line ${lineNum}: IF parameter must be in [brackets]\n"${line}"`;
      }

      // THEN-part must have parameter in [...]
      if (!/\[.+?\]/.test(thenPart)) {
        return `Line ${lineNum}: THEN parameter must be in [brackets]\n"${line}"`;
      }

      // IF-part must have value in "..."
      if (!/".+?"/.test(ifPart)) {
        return `Line ${lineNum}: IF value must be in "quotes"\n"${line}"`;
      }

      // THEN-part must have value in "..."
      if (!/".+?"/.test(thenPart)) {
        return `Line ${lineNum}: THEN value must be in "quotes"\n"${line}"`;
      }

      // Must end with ;
      if (!line.endsWith(';')) {
        return `Line ${lineNum}: Constraint must end with ;\n"${line}"`;
      }
    }

    return null;
  }

  /**
   * แสดง dialog แจ้งผลลัพธ์การนำเข้าไฟล์
   * @param {'success'|'warning'|'error'} type - ประเภท dialog
   * @param {string} title - หัวข้อ dialog
   * @param {string} message - ข้อความรายละเอียด
   */
  #showDialog(type, title, message, context = '') {
    const icons = {
      success: '\u2713',
      warning: '\u26A0',
      error: '\u2717',
    };

    this.#el.dialogIcon.textContent = icons[type] || '\u2139';
    this.#el.dialogIcon.className = `dialog-icon ${type}`;
    this.#el.dialogTitle.textContent = title;
    this.#el.dialogMessage.textContent = message;
    this.#el.dialogCloseBtn.className = `btn-primary dialog-close-btn ${type}`;
    this.#dialogType = type;
    this.#dialogContext = context;
    this.#el.dialogOverlay.classList.remove('hidden');
  }

  #closeDialog() {
    this.#el.dialogOverlay.classList.add('hidden');

    // Clear input fields only when closing scan (Step 1) error/warning dialogs
    if (this.#dialogContext === 'scan' &&
        (this.#dialogType === 'error' || this.#dialogType === 'warning')) {
      this.#el.inputFile.value = '';
      this.#el.outputDir.value = 'integration_test/';
      this.#el.outputFileName.textContent = '-';
      this.#el.widgetInfo.classList.add('hidden');
      this.#hasValidWidgets = false;
      this.#validateForm();
    }
  }

  #showCoverageSection(passed, failed, htmlPath, testCases) {
    this.#el.coverageSection.classList.remove('hidden');
    const summary = document.getElementById('coverageSummary');

    const totalCases = testCases ? testCases.length : (passed + failed);
    summary.textContent = `Coverage report generated! (${totalCases} test cases: ${passed} passed, ${failed} failed)`;

    const pathEl = document.querySelector('.coverage-path');
    if (pathEl && htmlPath) {
      pathEl.textContent = htmlPath;
    }
  }

  async #viewCoverageReport() {
    try {
      const response = await fetch(`${WebUI.API_BASE}/open-coverage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'view' })
      });

      const data = await response.json();
      if (data.success && data.url) {
        window.open(data.url, '_blank');
      } else {
        window.open(`${WebUI.API_BASE}/coverage/index.html`, '_blank');
      }
    } catch (error) {
      window.open(`${WebUI.API_BASE}/coverage/index.html`, '_blank');
    }
  }

  async #openCoverageFolder() {
    try {
      const response = await fetch(`${WebUI.API_BASE}/open-coverage`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action: 'folder' })
      });

      const data = await response.json();
      if (!data.success) {
        this.#log('Could not open coverage folder', 'error');
      }
    } catch (error) {
      this.#log(`Error: ${error.message}`, 'error');
    }
  }

  #updateButtonStates() {
    this.#validateForm();
    this.#el.generateBtn.querySelector('.btn-text').textContent =
      this.#isGenerating ? 'Generating...' : 'Generate Test Script';
  }

  async #runStep(step, params) {
    const response = await fetch(`${WebUI.API_BASE}/${step}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(params)
    });
    return await response.json();
  }

  #resetProgress() {
    document.querySelectorAll('.progress-item').forEach(item => {
      item.className = 'progress-item';
      item.querySelector('.progress-icon').textContent = '\u25CB';
      item.querySelector('.progress-status').textContent = '';
    });
  }

  #updateProgress(step, status, message) {
    const item = document.querySelector(`.progress-item[data-step="${step}"]`);
    if (!item) return;

    item.className = `progress-item ${status}`;
    const icon = item.querySelector('.progress-icon');
    const statusEl = item.querySelector('.progress-status');

    switch (status) {
      case 'running':
        icon.textContent = '\u25CF';
        break;
      case 'complete':
        icon.textContent = '\u2713';
        break;
      case 'error':
        icon.textContent = '\u2717';
        break;
      case 'skipped':
        icon.textContent = '\u2212';
        break;
    }

    statusEl.textContent = message || '';
  }

  #log(message, type = '') {
    const line = document.createElement('div');
    line.className = `log-line ${type}`;
    line.textContent = message;
    this.#el.outputLog.appendChild(line);
    this.#el.outputLog.scrollTop = this.#el.outputLog.scrollHeight;
  }

  #clearLog() {
    this.#el.outputLog.innerHTML = '';
  }

  #showTestSummary(summary) {
    if (!summary) {
      this.#el.testSummarySection.classList.add('hidden');
      return;
    }

    let badgesHtml = `<div class="summary-badge"><strong>${summary.totalCases}</strong> Total Cases</div>`;
    for (const g of summary.groups) {
      badgesHtml += `<div class="summary-badge"><strong>${g.count}</strong> ${g.name}</div>`;
    }
    this.#el.summaryOverview.innerHTML = badgesHtml;

    let rowsHtml = '';
    summary.cases.forEach((c, i) => {
      rowsHtml += `<tr>
            <td>${i + 1}</td>
            <td>${c.tc}</td>
            <td>${c.group}</td>
            <td class="result-cell" data-tc="${c.tc}"><span class="result-status">-</span></td>
        </tr>`;
    });
    this.#el.summaryTableBody.innerHTML = rowsHtml;

    this.#el.testSummarySection.classList.remove('hidden');
  }

  #setSummaryRunningState() {
    this.#el.summaryTableBody.querySelectorAll('.result-status').forEach(el => {
      el.textContent = 'Running...';
      el.className = 'result-status running';
    });
  }

  #updateSummaryFromCoverage(testCases) {
    this.#el.summaryTableBody.querySelectorAll('.result-cell').forEach(cell => {
      const tcName = cell.dataset.tc;
      if (!tcName) return;

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

  #showResults(results) {
    if (!this.#el.resultsSection) return;
    this.#el.resultsSection.classList.remove('hidden');

    document.querySelector('#manifestResult .result-path').textContent = results.manifest || '-';
    document.querySelector('#datasetsResult .result-path').textContent = results.datasets || '-';
    document.querySelector('#testDataResult .result-path').textContent = results.testData || '-';
    document.querySelector('#testScriptResult .result-path').textContent = results.testScript || '-';
  }
}

// Initialize — สร้าง WebUI instance เมื่อ DOM พร้อม
document.addEventListener('DOMContentLoaded', () => {
  new WebUI();
});
