import * as fs from 'fs'
import * as path from 'path'

import * as vscode from 'vscode'

const NAME = 'openplanetarium'

let g_core: OpenplanetCore | undefined = undefined
let g_log:  vscode.OutputChannel       = vscode.window.createOutputChannel('Openplanetarium', 'log')

interface OpenplanetCore {
    op:        string
    functions: OpenplanetCoreFunction[]
    classes:   OpenplanetCoreClass[]
    enums:     OpenplanetCoreEnum[]
    funcdefs:  OpenplanetCoreFunction[]
    props:     OpenplanetCoreProp[]
}

interface OpenplanetCoreClass {
    ns:        string
    id:        number
    name:      string
    behaviors: OpenplanetCoreClassBehavior[]
    methods:   OpenplanetCoreFunction[]
    props:     OpenplanetCoreProp[]
}

interface OpenplanetCoreClassBehavior {
    type: number
    func: OpenplanetCoreFunction
}

interface OpenplanetCoreProp {
    typedecl:  string
    typeflags: number
    ns:        string
    name:      string
    group:     string
    desc:      string
    flags:     string[]
}

interface OpenplanetCoreEnum {
    ns:     string
    id:     number
    name:   string
    group:  string
    desc:   string
    flags:  string[]
    values: object
}

interface OpenplanetCoreFunction {
    id:              number
    ns:              string
    name:            string
    returntypedecl:  string
    returntypeflags: number
    args:            OpenplanetCoreFunctionArg[]
    decl:            string
    group:           string
    desc:            string
    flags:           string[]
}

interface OpenplanetCoreFunctionArg {
    typeid:    number
    typename:  string
    typedecl:  string
    typeflags: number
    name:      string
    default:   string
    desc:      string
}

export function activate(context: vscode.ExtensionContext) {
    log('Openplanetarium is active :)')

    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    context.subscriptions.push(vscode.commands.registerCommand(`${NAME}.helloWorld`, () => {
        const msg = 'Hello World from Openplanetarium!'
        log(msg)
        vscode.window.showInformationMessage(msg)
    }))

    context.subscriptions.push(vscode.workspace.onDidChangeConfiguration(e => {
        if (!e.affectsConfiguration(NAME)) {
            return
        }

        const cfg = getConfig()
        // log(JSON.stringify(cfg, undefined, '\t'))

        if (e.affectsConfiguration(`${NAME}.OpenplanetNextFolder`)) {
            // log(`${NAME}.OpenplanetNextFolder changed`)
            if (cfg.OpenplanetNextFolder.length > 0 && !fs.existsSync(cfg.OpenplanetNextFolder)) {
                const msg = `folder not found: ${cfg.OpenplanetNextFolder}`
                log(msg, 'warning')
                vscode.window.showWarningMessage(msg)
            }
        }

        if (e.affectsConfiguration(`${NAME}.TrackmaniaNextInstallFolder`)) {
            // log(`${NAME}.TrackmaniaNextInstallFolder changed`)
            if (cfg.TrackmaniaNextInstallFolder.length > 0 && !fs.existsSync(cfg.TrackmaniaNextInstallFolder)) {
                const msg = `folder not found: ${cfg.TrackmaniaNextInstallFolder}`
                log(msg, 'warning')
                vscode.window.showWarningMessage(msg)
            }
        }
    }))

    g_core = readCoreFile()
    // log(JSON.stringify(g_core))
    if (g_core) {
        log(g_core.op)
        // log(g_core.functions[0].name)
        // g_log.appendLine(JSON.stringify(g_core.props, undefined, '\t'))
    }
}

function getConfig(): vscode.WorkspaceConfiguration {
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

function readCoreFile(): OpenplanetCore | undefined {
    const cfg = getConfig()
    if (cfg.OpenplanetNextFolder.length == 0) {
        return
    }

    const fpath = path.join(cfg.OpenplanetNextFolder, 'OpenplanetCore.json')
    if (!fs.existsSync(fpath)) {
        log(`file not found: ${fpath}`)
        return
    }

    try {
        return JSON.parse(fs.readFileSync(fpath, 'utf-8')) ?? undefined
    } catch (e) {
        log(`error reading file: ${e}`, 'error')
        return
    }
}

function zPad(i: number, count: number = 2): string {
    return i.toString().padStart(count, '0')
}
