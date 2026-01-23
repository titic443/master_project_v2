import * as vscode from 'vscode';
import { TestGeneratorPanel } from './webview/panel';
import { generateTests } from './commands/generateTests';

export function activate(context: vscode.ExtensionContext) {
    console.log('Flutter Test Generator extension is now active!');

    // Register command to open the panel
    const openPanelCommand = vscode.commands.registerCommand(
        'flutterTestGenerator.openPanel',
        () => {
            TestGeneratorPanel.createOrShow(context.extensionUri);
        }
    );

    // Register command to generate tests from current file
    const generateFromFileCommand = vscode.commands.registerCommand(
        'flutterTestGenerator.generateFromFile',
        async (uri?: vscode.Uri) => {
            let filePath: string | undefined;

            if (uri) {
                filePath = uri.fsPath;
            } else {
                // Get current active editor file
                const activeEditor = vscode.window.activeTextEditor;
                if (activeEditor) {
                    filePath = activeEditor.document.uri.fsPath;
                }
            }

            if (filePath && filePath.endsWith('.dart')) {
                TestGeneratorPanel.createOrShow(context.extensionUri, filePath);
            } else {
                vscode.window.showWarningMessage('Please select a Dart file to generate tests from.');
            }
        }
    );

    // Handle messages from webview
    if (TestGeneratorPanel.currentPanel) {
        TestGeneratorPanel.currentPanel.setMessageHandler(async (message) => {
            switch (message.command) {
                case 'generate':
                    await generateTests(message.config);
                    break;
                case 'browseFile':
                    const result = await vscode.window.showOpenDialog({
                        canSelectFiles: true,
                        canSelectFolders: false,
                        canSelectMany: false,
                        filters: {
                            'Dart files': ['dart'],
                            'Text files': ['txt']
                        }
                    });
                    if (result && result[0]) {
                        TestGeneratorPanel.currentPanel?.postMessage({
                            command: 'fileSelected',
                            field: message.field,
                            path: result[0].fsPath
                        });
                    }
                    break;
            }
        });
    }

    context.subscriptions.push(openPanelCommand, generateFromFileCommand);

    // Auto-dispose panel when extension is deactivated
    context.subscriptions.push({
        dispose: () => {
            TestGeneratorPanel.currentPanel?.dispose();
        }
    });
}

export function deactivate() {
    console.log('Flutter Test Generator extension is now deactivated.');
}
