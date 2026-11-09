// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
import * as vscode from 'vscode'

const NAME = 'openplanetarium'

let g_log = vscode.window.createOutputChannel('Openplanetarium', 'log')

export function activate(context: vscode.ExtensionContext) {
    log('Openplanetarium is active :)')

    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    context.subscriptions.push(vscode.commands.registerCommand(`${NAME}.helloWorld`, () => {
        const msg = 'Hello World from Openplanetarium!'
        log(msg)
        vscode.window.showInformationMessage(msg)
    }));

    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration(e => {
        if (!e.affectsConfiguration(NAME)) {
            return
        }

        log(JSON.stringify(getSettings(), undefined, '\t'))

        if (e.affectsConfiguration(`${NAME}.OpenplanetNextFolder`)) {
            log(`${NAME}.OpenplanetNextFolder changed`)
        }

        if (e.affectsConfiguration(`${NAME}.TrackmaniaNextInstallFolder`)) {
            log(`${NAME}.TrackmaniaNextInstallFolder changed`)
        }
    }))
}

export function deactivate() {
    log('Openplanetarium is no longer active :(')
}

function getSettings(): vscode.WorkspaceConfiguration {
    return vscode.workspace.getConfiguration(NAME)
}

function log(msg: string, type: string = 'info') {
    msg = `${now()} [${type}] ${msg}`
    console.log(msg)
    g_log.appendLine(msg)
}

function now(): string {
    const d = new Date()

    return `${
        d.getFullYear()}-${zPad(d.getMonth() + 1)}-${zPad(d.getDate())
    } ${
        zPad(d.getHours())}:${zPad(d.getMinutes())}:${zPad(d.getSeconds())}.${zPad(d.getMilliseconds(), 3)
    }`
}

function zPad(i: number, count: number = 2): string {
    return i.toString().padStart(count, '0')
}
