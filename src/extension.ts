import * as fs from 'fs'
import * as path from 'path'

import * as vscode from 'vscode'

const NAME = 'openplanetarium'

let g_coreNext: OpenplanetCore | undefined = undefined
let g_gameNext: OpenplanetGame | undefined = undefined
let g_log:      vscode.OutputChannel       = vscode.window.createOutputChannel('Openplanetarium', 'log')

interface OpenplanetCore {
    op:        string
    functions: OpenplanetCoreFunction[]
    classes:   OpenplanetCoreClass[]
    enums:     OpenplanetCoreEnum[]
    funcdefs:  OpenplanetCoreFunction[]
    props:     OpenplanetCoreProp[]
}

interface OpenplanetCoreClass {
    ns?:       string
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

interface OpenplanetGame {
    op: string
    mp: string
    ns: object
}

export function activate(context: vscode.ExtensionContext) {
    const start = performance.now()
    log('starting...')

    g_coreNext = readCoreFile('Next')
    g_gameNext = readGameFile('Next')
    ;

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
            if (cfg.OpenplanetNextFolder.length > 0) {
                if (fs.existsSync(cfg.OpenplanetNextFolder)) {
                    g_coreNext = readCoreFile('Next')
                    g_gameNext = readGameFile('Next')
                } else {
                    g_coreNext = undefined
                    g_gameNext = undefined
                    const msg = `folder not found: ${cfg.OpenplanetNextFolder}`
                    log(msg, 'warning')
                    vscode.window.showWarningMessage(msg)
                }
            }
        }

        if (e.affectsConfiguration(`${NAME}.TrackmaniaNextInstallFolder`)) {
            // log(`${NAME}.TrackmaniaNextInstallFolder changed`)
            if (cfg.TrackmaniaNextInstallFolder.length > 0) {
                if (fs.existsSync(cfg.TrackmaniaNextInstallFolder)) {
                    ;
                } else {
                    const msg = `folder not found: ${cfg.TrackmaniaNextInstallFolder}`
                    log(msg, 'warning')
                    vscode.window.showWarningMessage(msg)
                }
            }
        }
    }))

    const end = performance.now()
    log(`ready (${(end - start).toPrecision(2)} ms)`)
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

function readCoreFile(game: string): OpenplanetCore | undefined {
    const start = performance.now()

    const cfg = getConfig()
    const settingName = `Openplanet${game}Folder`
    const folder: string = cfg[settingName]
    if (!folder) {
        return
    }

    const fpath = path.join(folder, 'OpenplanetCore.json')
    if (!fs.existsSync(fpath)) {
        log(`file not found: ${fpath}`)
        return
    }

    try {
        return JSON.parse(fs.readFileSync(fpath, 'utf-8')) ?? undefined
    } catch (e) {
        log(`error reading file: ${e}`, 'error')
        return
    } finally {
        const end = performance.now()
        log(`read core file (${game}) (${(end - start).toPrecision(2)} ms)`)
    }
}

function readGameFile(game: string): OpenplanetGame | undefined {
    const start = performance.now()

    const cfg = getConfig()
    const settingName = `Openplanet${game}Folder`
    const folder: string = cfg[settingName]
    if (!folder) {
        return
    }

    const fpath = path.join(folder, `Openplanet${game}.json`)
    if (!fs.existsSync(fpath)) {
        log(`file not found: ${fpath}`)
        return
    }

    try {
        return JSON.parse(fs.readFileSync(fpath, 'utf-8')) ?? undefined
    } catch (e) {
        log(`error reading file: ${e}`, 'error')
        return
    } finally {
        const end = performance.now()
        log(`read game file (${game}) (${(end - start).toPrecision(2)} ms)`)
    }
}

function zPad(i: number, count: number = 2): string {
    return i.toString().padStart(count, '0')
}
