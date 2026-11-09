// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode';

let g_log = vscode.window.createOutputChannel('Openplanetarium', 'log');

export function activate(context: vscode.ExtensionContext) {
    log('Openplanetarium is active');

    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    let disposable = vscode.commands.registerCommand('openplanetarium.helloWorld', () => {
        // vscode.window.showInformationMessage('Hello World from Openplanetarium!');

        log('Hello World from Openplanetarium!');
    });

    context.subscriptions.push(disposable);
}

export function deactivate() {}

function log(msg: string, type: string = 'info') {
    const now = new Date();
    const ts = `${
        now.getFullYear()
    }-${
        zeroPad(now.getMonth() + 1)
    }-${
        zeroPad(now.getDate())
    } ${
        zeroPad(now.getHours())
    }:${
        zeroPad(now.getMinutes())
    }:${
        zeroPad(now.getSeconds())
    }.${
        zeroPad(now.getMilliseconds(), 3)
    }`;

    msg = `${ts} [${type}] ${msg}`
    console.log(msg)
    g_log.appendLine(msg);
}

function zeroPad(i: number, count: number = 2) {
    return i.toString().padStart(count, '0');
}
