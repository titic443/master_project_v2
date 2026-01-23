import * as vscode from 'vscode';
import * as path from 'path';
import { DartRunner } from '../services/dartRunner';

export class TestGeneratorPanel {
    public static currentPanel: TestGeneratorPanel | undefined;
    public static readonly viewType = 'flutterTestGenerator';

    private readonly _panel: vscode.WebviewPanel;
    private readonly _extensionUri: vscode.Uri;
    private _disposables: vscode.Disposable[] = [];
    private _messageHandler?: (message: any) => Promise<void>;
    private _dartRunner: DartRunner;

    public static createOrShow(extensionUri: vscode.Uri, initialFilePath?: string) {
        const column = vscode.window.activeTextEditor
            ? vscode.window.activeTextEditor.viewColumn
            : undefined;

        // If we already have a panel, show it
        if (TestGeneratorPanel.currentPanel) {
            TestGeneratorPanel.currentPanel._panel.reveal(column);
            if (initialFilePath) {
                TestGeneratorPanel.currentPanel.postMessage({
                    command: 'setInitialFile',
                    path: initialFilePath
                });
            }
            return;
        }

        // Otherwise, create a new panel
        const panel = vscode.window.createWebviewPanel(
            TestGeneratorPanel.viewType,
            'Flutter Test Generator',
            column || vscode.ViewColumn.One,
            {
                enableScripts: true,
                retainContextWhenHidden: true,
                localResourceRoots: [
                    vscode.Uri.joinPath(extensionUri, 'media')
                ]
            }
        );

        TestGeneratorPanel.currentPanel = new TestGeneratorPanel(panel, extensionUri, initialFilePath);
    }

    private constructor(panel: vscode.WebviewPanel, extensionUri: vscode.Uri, initialFilePath?: string) {
        this._panel = panel;
        this._extensionUri = extensionUri;
        this._dartRunner = new DartRunner();

        // Set the webview's initial html content
        this._update(initialFilePath);

        // Listen for when the panel is disposed
        this._panel.onDidDispose(() => this.dispose(), null, this._disposables);

        // Handle messages from the webview
        this._panel.webview.onDidReceiveMessage(
            async (message) => {
                await this._handleMessage(message);
            },
            null,
            this._disposables
        );
    }

    public setMessageHandler(handler: (message: any) => Promise<void>) {
        this._messageHandler = handler;
    }

    public postMessage(message: any) {
        this._panel.webview.postMessage(message);
    }

    public dispose() {
        TestGeneratorPanel.currentPanel = undefined;

        // Clean up resources
        this._panel.dispose();

        while (this._disposables.length) {
            const x = this._disposables.pop();
            if (x) {
                x.dispose();
            }
        }
    }

    private async _handleMessage(message: any) {
        switch (message.command) {
            case 'generate':
                await this._runGeneration(message.config);
                break;
            case 'browseFile':
                await this._browseFile(message.field, message.filters);
                break;
            case 'scanWidgets':
                await this._scanWidgets(message.filePath);
                break;
            case 'loadConstraintsPreview':
                await this._loadConstraintsPreview(message.filePath);
                break;
            case 'log':
                console.log('[Webview]', message.text);
                break;
        }

        if (this._messageHandler) {
            await this._messageHandler(message);
        }
    }

    private async _browseFile(field: string, filters?: { [name: string]: string[] }) {
        const defaultFilters: { [name: string]: string[] } = field === 'uiFile'
            ? { 'Dart files': ['dart'] }
            : { 'Text files': ['txt'], 'All files': ['*'] };

        const result = await vscode.window.showOpenDialog({
            canSelectFiles: true,
            canSelectFolders: false,
            canSelectMany: false,
            filters: filters || defaultFilters,
            defaultUri: vscode.workspace.workspaceFolders?.[0]?.uri
        });

        if (result && result[0]) {
            this.postMessage({
                command: 'fileSelected',
                field: field,
                path: result[0].fsPath
            });
        }
    }

    private async _scanWidgets(filePath: string) {
        this.postMessage({ command: 'scanStarted' });

        try {
            const workspaceFolder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath || '';
            const result = await this._dartRunner.extractManifest(filePath, workspaceFolder);

            this.postMessage({
                command: 'scanComplete',
                success: result.success,
                widgetCount: result.widgetCount,
                manifestPath: result.manifestPath,
                error: result.error
            });
        } catch (error: any) {
            this.postMessage({
                command: 'scanComplete',
                success: false,
                error: error.message
            });
        }
    }

    private async _loadConstraintsPreview(filePath: string) {
        try {
            const document = await vscode.workspace.openTextDocument(filePath);
            const content = document.getText();
            this.postMessage({
                command: 'constraintsLoaded',
                content: content
            });
        } catch (error: any) {
            this.postMessage({
                command: 'constraintsLoaded',
                content: '',
                error: error.message
            });
        }
    }

    private async _runGeneration(config: any) {
        this.postMessage({ command: 'generationStarted' });

        try {
            const workspaceFolder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath || '';

            // Step 1: Extract manifest
            this.postMessage({ command: 'stepProgress', step: 1, status: 'running', message: 'Extracting UI manifest...' });
            const manifestResult = await this._dartRunner.extractManifest(config.uiFile, workspaceFolder);
            if (!manifestResult.success) {
                throw new Error(`Manifest extraction failed: ${manifestResult.error}`);
            }
            this.postMessage({ command: 'stepProgress', step: 1, status: 'complete', message: `Manifest: ${manifestResult.manifestPath}` });

            // Step 2: Generate datasets (if not skipped)
            if (!config.skipDatasets) {
                this.postMessage({ command: 'stepProgress', step: 2, status: 'running', message: 'Generating datasets (AI)...' });
                const datasetResult = await this._dartRunner.generateDatasets(manifestResult.manifestPath!, workspaceFolder, config.apiKey);
                if (datasetResult.success) {
                    this.postMessage({ command: 'stepProgress', step: 2, status: 'complete', message: `Datasets: ${datasetResult.datasetsPath}` });
                } else if (datasetResult.skipped) {
                    this.postMessage({ command: 'stepProgress', step: 2, status: 'skipped', message: 'No text fields found' });
                } else {
                    throw new Error(`Dataset generation failed: ${datasetResult.error}`);
                }
            } else {
                this.postMessage({ command: 'stepProgress', step: 2, status: 'skipped', message: 'Skipped (user choice)' });
            }

            // Step 3: Generate test data
            this.postMessage({ command: 'stepProgress', step: 3, status: 'running', message: 'Generating test plan (PICT)...' });
            const testDataResult = await this._dartRunner.generateTestData(
                manifestResult.manifestPath!,
                workspaceFolder,
                config.useConstraints ? config.constraintsFile : undefined
            );
            if (!testDataResult.success) {
                throw new Error(`Test data generation failed: ${testDataResult.error}`);
            }
            this.postMessage({ command: 'stepProgress', step: 3, status: 'complete', message: `Test plan: ${testDataResult.testDataPath}` });

            // Step 4: Generate test script
            this.postMessage({ command: 'stepProgress', step: 4, status: 'running', message: 'Generating test script...' });
            const scriptResult = await this._dartRunner.generateTestScript(testDataResult.testDataPath!, workspaceFolder);
            if (!scriptResult.success) {
                throw new Error(`Test script generation failed: ${scriptResult.error}`);
            }
            this.postMessage({ command: 'stepProgress', step: 4, status: 'complete', message: `Test file: ${scriptResult.testScriptPath}` });

            // Complete
            this.postMessage({
                command: 'generationComplete',
                success: true,
                testScriptPath: scriptResult.testScriptPath
            });

            // Show success message with option to open file
            const selection = await vscode.window.showInformationMessage(
                `Test file generated: ${scriptResult.testScriptPath}`,
                'Open File',
                'Run Tests'
            );

            if (selection === 'Open File' && scriptResult.testScriptPath) {
                const doc = await vscode.workspace.openTextDocument(scriptResult.testScriptPath);
                await vscode.window.showTextDocument(doc);
            } else if (selection === 'Run Tests' && scriptResult.testScriptPath) {
                const terminal = vscode.window.createTerminal('Flutter Tests');
                terminal.show();
                terminal.sendText(`flutter test ${scriptResult.testScriptPath}`);
            }

        } catch (error: any) {
            this.postMessage({
                command: 'generationComplete',
                success: false,
                error: error.message
            });
            vscode.window.showErrorMessage(`Test generation failed: ${error.message}`);
        }
    }

    private _update(initialFilePath?: string) {
        const webview = this._panel.webview;
        this._panel.title = 'Flutter Test Generator';
        this._panel.webview.html = this._getHtmlForWebview(webview, initialFilePath);
    }

    private _getHtmlForWebview(webview: vscode.Webview, initialFilePath?: string): string {
        // Get resource URIs
        const styleUri = webview.asWebviewUri(
            vscode.Uri.joinPath(this._extensionUri, 'media', 'styles.css')
        );
        const scriptUri = webview.asWebviewUri(
            vscode.Uri.joinPath(this._extensionUri, 'media', 'main.js')
        );

        const nonce = getNonce();

        return `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src ${webview.cspSource} 'unsafe-inline'; script-src 'nonce-${nonce}';">
    <link href="${styleUri}" rel="stylesheet">
    <title>Flutter Test Generator</title>
</head>
<body>
    <div class="container">
        <header>
            <h1>🧪 Flutter Test Generator</h1>
            <p class="subtitle">Generate widget tests using pairwise combinatorial testing</p>
        </header>

        <main>
            <!-- UI File Selection -->
            <section class="form-section">
                <label for="uiFile">UI File</label>
                <div class="input-group">
                    <input type="text" id="uiFile" placeholder="lib/demos/buttons_page.dart" value="${initialFilePath || ''}">
                    <button type="button" id="browseUiFile" class="btn-secondary">Browse</button>
                </div>
                <div id="widgetInfo" class="info-box hidden">
                    <span id="widgetCount"></span>
                </div>
            </section>

            <!-- Options -->
            <section class="form-section">
                <h2>Options</h2>

                <div class="checkbox-group">
                    <input type="checkbox" id="skipDatasets">
                    <label for="skipDatasets">Skip AI Dataset Generation</label>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="useConstraints">
                    <label for="useConstraints">Use PICT Constraints</label>
                </div>

                <div id="constraintsSection" class="sub-section hidden">
                    <label for="constraintsFile">Constraints File</label>
                    <div class="input-group">
                        <input type="text" id="constraintsFile" placeholder="output/model_pairwise/*.constraints.txt">
                        <button type="button" id="browseConstraintsFile" class="btn-secondary">Browse</button>
                    </div>
                    <div id="constraintsPreview" class="preview-box hidden">
                        <pre id="constraintsContent"></pre>
                    </div>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="verbose">
                    <label for="verbose">Verbose Logging</label>
                </div>
            </section>

            <!-- Generate Button -->
            <section class="form-section">
                <button type="button" id="generateBtn" class="btn-primary btn-large" disabled>
                    <span class="btn-icon">▶</span>
                    <span class="btn-text">Generate Tests</span>
                </button>
            </section>

            <!-- Progress -->
            <section id="progressSection" class="form-section hidden">
                <h2>Progress</h2>
                <div class="progress-list">
                    <div class="progress-item" data-step="1">
                        <span class="progress-icon">○</span>
                        <span class="progress-label">Extract UI manifest</span>
                        <span class="progress-status"></span>
                    </div>
                    <div class="progress-item" data-step="2">
                        <span class="progress-icon">○</span>
                        <span class="progress-label">Generate datasets (AI)</span>
                        <span class="progress-status"></span>
                    </div>
                    <div class="progress-item" data-step="3">
                        <span class="progress-icon">○</span>
                        <span class="progress-label">Generate test plan (PICT)</span>
                        <span class="progress-status"></span>
                    </div>
                    <div class="progress-item" data-step="4">
                        <span class="progress-icon">○</span>
                        <span class="progress-label">Generate test script</span>
                        <span class="progress-status"></span>
                    </div>
                </div>
            </section>

            <!-- Output -->
            <section id="outputSection" class="form-section hidden">
                <h2>Output</h2>
                <div id="outputLog" class="output-box"></div>
            </section>
        </main>

        <footer>
            <p>Powered by PICT (Pairwise Independent Combinatorial Testing)</p>
        </footer>
    </div>

    <script nonce="${nonce}" src="${scriptUri}"></script>
</body>
</html>`;
    }
}

function getNonce(): string {
    let text = '';
    const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    for (let i = 0; i < 32; i++) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }
    return text;
}
