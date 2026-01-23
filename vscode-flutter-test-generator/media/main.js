// @ts-check

(function () {
    // @ts-ignore
    const vscode = acquireVsCodeApi();

    // State
    let isGenerating = false;

    // DOM Elements
    const uiFileInput = /** @type {HTMLInputElement} */ (document.getElementById('uiFile'));
    const browseUiFileBtn = document.getElementById('browseUiFile');
    const widgetInfo = document.getElementById('widgetInfo');
    const widgetCount = document.getElementById('widgetCount');

    const skipDatasetsCheckbox = /** @type {HTMLInputElement} */ (document.getElementById('skipDatasets'));
    const useConstraintsCheckbox = /** @type {HTMLInputElement} */ (document.getElementById('useConstraints'));
    const constraintsSection = document.getElementById('constraintsSection');
    const constraintsFileInput = /** @type {HTMLInputElement} */ (document.getElementById('constraintsFile'));
    const browseConstraintsFileBtn = document.getElementById('browseConstraintsFile');
    const constraintsPreview = document.getElementById('constraintsPreview');
    const constraintsContent = document.getElementById('constraintsContent');

    const verboseCheckbox = /** @type {HTMLInputElement} */ (document.getElementById('verbose'));

    const generateBtn = document.getElementById('generateBtn');
    const progressSection = document.getElementById('progressSection');
    const outputSection = document.getElementById('outputSection');
    const outputLog = document.getElementById('outputLog');

    // Initialize
    function init() {
        // Event Listeners
        browseUiFileBtn?.addEventListener('click', () => {
            vscode.postMessage({ command: 'browseFile', field: 'uiFile' });
        });

        browseConstraintsFileBtn?.addEventListener('click', () => {
            vscode.postMessage({ command: 'browseFile', field: 'constraintsFile' });
        });

        uiFileInput?.addEventListener('change', onUiFileChange);
        uiFileInput?.addEventListener('blur', onUiFileChange);

        useConstraintsCheckbox?.addEventListener('change', onUseConstraintsChange);

        constraintsFileInput?.addEventListener('change', onConstraintsFileChange);
        constraintsFileInput?.addEventListener('blur', onConstraintsFileChange);

        generateBtn?.addEventListener('click', onGenerate);

        // Update button state
        updateGenerateButton();
    }

    function onUiFileChange() {
        const filePath = uiFileInput?.value?.trim();

        if (filePath && filePath.endsWith('.dart')) {
            // Auto-suggest constraints file path
            const baseName = filePath.split('/').pop()?.replace('.dart', '') || '';
            if (constraintsFileInput && !constraintsFileInput.value) {
                constraintsFileInput.value = `output/model_pairwise/${baseName}.constraints.txt`;
            }

            // Scan widgets
            vscode.postMessage({ command: 'scanWidgets', filePath });
        } else {
            hideWidgetInfo();
        }

        updateGenerateButton();
    }

    function onUseConstraintsChange() {
        if (constraintsSection) {
            constraintsSection.classList.toggle('hidden', !useConstraintsCheckbox?.checked);
        }
    }

    function onConstraintsFileChange() {
        const filePath = constraintsFileInput?.value?.trim();

        if (filePath) {
            vscode.postMessage({ command: 'loadConstraintsPreview', filePath });
        } else {
            hideConstraintsPreview();
        }
    }

    function onGenerate() {
        if (isGenerating) return;

        const config = {
            uiFile: uiFileInput?.value?.trim() || '',
            skipDatasets: skipDatasetsCheckbox?.checked || false,
            useConstraints: useConstraintsCheckbox?.checked || false,
            constraintsFile: useConstraintsCheckbox?.checked ? constraintsFileInput?.value?.trim() : undefined,
            verbose: verboseCheckbox?.checked || false
        };

        if (!config.uiFile) {
            showError('Please select a UI file');
            return;
        }

        vscode.postMessage({ command: 'generate', config });
    }

    function updateGenerateButton() {
        const hasFile = uiFileInput?.value?.trim()?.endsWith('.dart');
        if (generateBtn) {
            // @ts-ignore
            generateBtn.disabled = !hasFile || isGenerating;
        }
    }

    function showWidgetInfo(count, success = true) {
        if (widgetInfo && widgetCount) {
            widgetInfo.classList.remove('hidden');
            widgetInfo.classList.toggle('success', success);
            widgetInfo.classList.toggle('error', !success);

            if (success) {
                widgetCount.textContent = `✓ Found ${count} widget(s) with keys`;
            } else {
                widgetCount.textContent = `✗ ${count}`;
            }
        }
    }

    function hideWidgetInfo() {
        widgetInfo?.classList.add('hidden');
    }

    function showConstraintsPreview(content) {
        if (constraintsPreview && constraintsContent) {
            constraintsPreview.classList.remove('hidden');
            constraintsContent.textContent = content || '(empty)';
        }
    }

    function hideConstraintsPreview() {
        constraintsPreview?.classList.add('hidden');
    }

    function showProgress() {
        progressSection?.classList.remove('hidden');
        resetProgress();
    }

    function hideProgress() {
        progressSection?.classList.add('hidden');
    }

    function resetProgress() {
        document.querySelectorAll('.progress-item').forEach(item => {
            item.removeAttribute('data-status');
            const icon = item.querySelector('.progress-icon');
            const status = item.querySelector('.progress-status');
            if (icon) icon.textContent = '○';
            if (status) status.textContent = '';
        });
    }

    function updateProgress(step, status, message) {
        const item = document.querySelector(`.progress-item[data-step="${step}"]`);
        if (!item) return;

        item.setAttribute('data-status', status);
        const icon = item.querySelector('.progress-icon');
        const statusEl = item.querySelector('.progress-status');

        switch (status) {
            case 'running':
                if (icon) icon.textContent = '◐';
                break;
            case 'complete':
                if (icon) icon.textContent = '✓';
                break;
            case 'skipped':
                if (icon) icon.textContent = '○';
                break;
            case 'error':
                if (icon) icon.textContent = '✗';
                break;
        }

        if (statusEl && message) {
            statusEl.textContent = message;
        }
    }

    function showOutput() {
        outputSection?.classList.remove('hidden');
    }

    function appendOutput(text) {
        if (outputLog) {
            outputLog.textContent += text + '\n';
            outputLog.scrollTop = outputLog.scrollHeight;
        }
    }

    function clearOutput() {
        if (outputLog) {
            outputLog.textContent = '';
        }
    }

    function showError(message) {
        // @ts-ignore
        vscode.postMessage({ command: 'log', text: `Error: ${message}` });
    }

    function setGenerating(generating) {
        isGenerating = generating;

        if (generateBtn) {
            const btnText = generateBtn.querySelector('.btn-text');
            const btnIcon = generateBtn.querySelector('.btn-icon');

            if (generating) {
                // @ts-ignore
                generateBtn.disabled = true;
                if (btnText) btnText.textContent = 'Generating...';
                if (btnIcon) btnIcon.textContent = '◐';
            } else {
                // @ts-ignore
                generateBtn.disabled = false;
                if (btnText) btnText.textContent = 'Generate Tests';
                if (btnIcon) btnIcon.textContent = '▶';
            }
        }

        updateGenerateButton();
    }

    // Handle messages from extension
    window.addEventListener('message', event => {
        const message = event.data;

        switch (message.command) {
            case 'setInitialFile':
                if (uiFileInput && message.path) {
                    uiFileInput.value = message.path;
                    onUiFileChange();
                }
                break;

            case 'fileSelected':
                if (message.field === 'uiFile' && uiFileInput) {
                    uiFileInput.value = message.path;
                    onUiFileChange();
                } else if (message.field === 'constraintsFile' && constraintsFileInput) {
                    constraintsFileInput.value = message.path;
                    onConstraintsFileChange();
                }
                break;

            case 'scanStarted':
                showWidgetInfo('Scanning...', true);
                break;

            case 'scanComplete':
                if (message.success) {
                    showWidgetInfo(message.widgetCount);
                } else {
                    showWidgetInfo(message.error, false);
                }
                break;

            case 'constraintsLoaded':
                if (message.error) {
                    hideConstraintsPreview();
                } else {
                    showConstraintsPreview(message.content);
                }
                break;

            case 'generationStarted':
                setGenerating(true);
                showProgress();
                showOutput();
                clearOutput();
                appendOutput('Starting test generation...');
                break;

            case 'stepProgress':
                updateProgress(message.step, message.status, message.message);
                appendOutput(`[${message.step}/4] ${message.message}`);
                break;

            case 'generationComplete':
                setGenerating(false);
                if (message.success) {
                    appendOutput('\n✓ Test generation complete!');
                    appendOutput(`Test file: ${message.testScriptPath}`);
                } else {
                    appendOutput(`\n✗ Error: ${message.error}`);
                }
                break;
        }
    });

    // Initialize when DOM is ready
    init();

    // If initial file was set, trigger scan
    if (uiFileInput?.value) {
        onUiFileChange();
    }
})();
