import * as vscode from 'vscode';
import { DartRunner } from '../services/dartRunner';

export interface GenerateConfig {
    uiFile: string;
    skipDatasets: boolean;
    useConstraints: boolean;
    constraintsFile?: string;
    verbose: boolean;
    apiKey?: string;
}

export async function generateTests(config: GenerateConfig): Promise<void> {
    const dartRunner = new DartRunner();
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;

    if (!workspaceFolder) {
        vscode.window.showErrorMessage('No workspace folder found');
        return;
    }

    if (!config.uiFile) {
        vscode.window.showErrorMessage('Please select a UI file');
        return;
    }

    // Get API key from settings if not provided
    if (!config.apiKey) {
        const settings = vscode.workspace.getConfiguration('flutterTestGenerator');
        config.apiKey = settings.get('geminiApiKey') || undefined;
    }

    try {
        await vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: 'Generating Flutter Tests',
            cancellable: false
        }, async (progress) => {
            // Step 1: Extract manifest
            progress.report({ message: 'Extracting UI manifest...', increment: 0 });
            const manifestResult = await dartRunner.extractManifest(config.uiFile, workspaceFolder);

            if (!manifestResult.success) {
                throw new Error(`Manifest extraction failed: ${manifestResult.error}`);
            }

            // Step 2: Generate datasets
            if (!config.skipDatasets) {
                progress.report({ message: 'Generating datasets (AI)...', increment: 25 });
                const datasetResult = await dartRunner.generateDatasets(
                    manifestResult.manifestPath!,
                    workspaceFolder,
                    config.apiKey
                );

                if (!datasetResult.success && !datasetResult.skipped) {
                    throw new Error(`Dataset generation failed: ${datasetResult.error}`);
                }
            }

            // Step 3: Generate test data
            progress.report({ message: 'Generating test plan (PICT)...', increment: 50 });
            const testDataResult = await dartRunner.generateTestData(
                manifestResult.manifestPath!,
                workspaceFolder,
                config.useConstraints ? config.constraintsFile : undefined
            );

            if (!testDataResult.success) {
                throw new Error(`Test data generation failed: ${testDataResult.error}`);
            }

            // Step 4: Generate test script
            progress.report({ message: 'Generating test script...', increment: 75 });
            const scriptResult = await dartRunner.generateTestScript(
                testDataResult.testDataPath!,
                workspaceFolder
            );

            if (!scriptResult.success) {
                throw new Error(`Test script generation failed: ${scriptResult.error}`);
            }

            progress.report({ message: 'Complete!', increment: 100 });

            // Show success message
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
        });
    } catch (error: any) {
        vscode.window.showErrorMessage(`Test generation failed: ${error.message}`);
        dartRunner.showOutput();
    }
}
