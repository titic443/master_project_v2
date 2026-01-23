import * as vscode from 'vscode';
import { spawn, ChildProcess } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';

export interface ManifestResult {
    success: boolean;
    manifestPath?: string;
    widgetCount?: number;
    error?: string;
}

export interface DatasetResult {
    success: boolean;
    datasetsPath?: string;
    skipped?: boolean;
    error?: string;
}

export interface TestDataResult {
    success: boolean;
    testDataPath?: string;
    error?: string;
}

export interface TestScriptResult {
    success: boolean;
    testScriptPath?: string;
    error?: string;
}

export class DartRunner {
    private _outputChannel: vscode.OutputChannel;

    constructor() {
        this._outputChannel = vscode.window.createOutputChannel('Flutter Test Generator');
    }

    /**
     * Extract UI manifest from a Dart file
     */
    async extractManifest(uiFilePath: string, workspaceFolder: string): Promise<ManifestResult> {
        const scriptPath = path.join(workspaceFolder, 'tools/script_v2/extract_ui_manifest.dart');

        if (!fs.existsSync(scriptPath)) {
            return {
                success: false,
                error: `Script not found: ${scriptPath}`
            };
        }

        try {
            const result = await this._runDart(
                ['run', scriptPath, uiFilePath],
                workspaceFolder
            );

            if (result.exitCode !== 0) {
                return {
                    success: false,
                    error: result.stderr || 'Unknown error'
                };
            }

            // Parse output to get manifest path and widget count
            const manifestMatch = result.stdout.match(/Manifest written: (.+\.manifest\.json)/);
            const widgetMatch = result.stdout.match(/Found (\d+) widget/);

            const baseName = path.basename(uiFilePath, '.dart');
            const manifestPath = manifestMatch
                ? manifestMatch[1]
                : `output/manifest/${baseName}.manifest.json`;

            // Read manifest to get actual widget count
            let widgetCount = 0;
            const fullManifestPath = path.join(workspaceFolder, manifestPath);
            if (fs.existsSync(fullManifestPath)) {
                try {
                    const manifestContent = JSON.parse(fs.readFileSync(fullManifestPath, 'utf-8'));
                    widgetCount = manifestContent.widgets?.length || 0;
                } catch (e) {
                    // Ignore parse errors
                }
            }

            return {
                success: true,
                manifestPath: manifestPath,
                widgetCount: widgetMatch ? parseInt(widgetMatch[1]) : widgetCount
            };
        } catch (error: any) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    /**
     * Generate datasets using AI
     */
    async generateDatasets(manifestPath: string, workspaceFolder: string, apiKey?: string): Promise<DatasetResult> {
        const scriptPath = path.join(workspaceFolder, 'tools/script_v2/generate_datasets.dart');

        if (!fs.existsSync(scriptPath)) {
            return {
                success: false,
                error: `Script not found: ${scriptPath}`
            };
        }

        try {
            const args = ['run', scriptPath, manifestPath];
            if (apiKey) {
                args.push(`--api-key=${apiKey}`);
            }

            const result = await this._runDart(args, workspaceFolder);

            // Check if skipped due to no text fields
            if (result.stdout.includes('No TextField') || result.stderr.includes('No TextField')) {
                return {
                    success: true,
                    skipped: true
                };
            }

            if (result.exitCode !== 0) {
                return {
                    success: false,
                    error: result.stderr || 'Unknown error'
                };
            }

            // Parse output to get datasets path
            const datasetsMatch = result.stdout.match(/Generated: (.+\.datasets\.json)/);
            const baseName = path.basename(manifestPath).replace('.manifest.json', '');
            const datasetsPath = datasetsMatch
                ? datasetsMatch[1]
                : `output/test_data/${baseName}.datasets.json`;

            return {
                success: true,
                datasetsPath: datasetsPath
            };
        } catch (error: any) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    /**
     * Generate test data using PICT
     */
    async generateTestData(manifestPath: string, workspaceFolder: string, constraintsFile?: string): Promise<TestDataResult> {
        const scriptPath = path.join(workspaceFolder, 'tools/script_v2/generate_test_data.dart');

        if (!fs.existsSync(scriptPath)) {
            return {
                success: false,
                error: `Script not found: ${scriptPath}`
            };
        }

        try {
            const args = ['run', scriptPath, manifestPath];

            // Read constraints content if file is provided
            if (constraintsFile && fs.existsSync(constraintsFile)) {
                // For now, we need to pass constraints through a different mechanism
                // since the CLI doesn't support --constraints-file directly
                // We'll handle this by modifying the approach
                this._outputChannel.appendLine(`Using constraints from: ${constraintsFile}`);
            }

            const result = await this._runDart(args, workspaceFolder);

            if (result.exitCode !== 0) {
                return {
                    success: false,
                    error: result.stderr || 'Unknown error'
                };
            }

            // Parse output to get test data path
            const testDataMatch = result.stdout.match(/fullpage plan: (.+\.testdata\.json)/);
            const baseName = path.basename(manifestPath).replace('.manifest.json', '');
            const testDataPath = testDataMatch
                ? testDataMatch[1]
                : `output/test_data/${baseName}.testdata.json`;

            return {
                success: true,
                testDataPath: testDataPath
            };
        } catch (error: any) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    /**
     * Generate Flutter test script
     */
    async generateTestScript(testDataPath: string, workspaceFolder: string): Promise<TestScriptResult> {
        const scriptPath = path.join(workspaceFolder, 'tools/script_v2/generate_test_script.dart');

        if (!fs.existsSync(scriptPath)) {
            return {
                success: false,
                error: `Script not found: ${scriptPath}`
            };
        }

        try {
            const result = await this._runDart(
                ['run', scriptPath, testDataPath],
                workspaceFolder
            );

            if (result.exitCode !== 0) {
                return {
                    success: false,
                    error: result.stderr || 'Unknown error'
                };
            }

            // Parse output to get test script path
            const scriptMatch = result.stdout.match(/Generated: (.+_flow_test\.dart)/);
            const baseName = path.basename(testDataPath).replace('.testdata.json', '');
            const testScriptPath = scriptMatch
                ? scriptMatch[1]
                : `integration_test/${baseName}_flow_test.dart`;

            // Return full path
            return {
                success: true,
                testScriptPath: path.join(workspaceFolder, testScriptPath)
            };
        } catch (error: any) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    /**
     * Run Dart command and return result
     */
    private _runDart(args: string[], cwd: string): Promise<{ exitCode: number; stdout: string; stderr: string }> {
        return new Promise((resolve, reject) => {
            this._outputChannel.appendLine(`> dart ${args.join(' ')}`);

            const process = spawn('dart', args, {
                cwd: cwd,
                shell: true
            });

            let stdout = '';
            let stderr = '';

            process.stdout.on('data', (data) => {
                const text = data.toString();
                stdout += text;
                this._outputChannel.append(text);
            });

            process.stderr.on('data', (data) => {
                const text = data.toString();
                stderr += text;
                this._outputChannel.append(text);
            });

            process.on('close', (code) => {
                resolve({
                    exitCode: code || 0,
                    stdout,
                    stderr
                });
            });

            process.on('error', (error) => {
                reject(error);
            });
        });
    }

    /**
     * Show the output channel
     */
    showOutput() {
        this._outputChannel.show();
    }
}
