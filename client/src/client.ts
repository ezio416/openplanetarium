import * as path from 'path'
import * as vscode from 'vscode'
import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions,
  TransportKind
} from 'vscode-languageclient/node'

const NAME = 'openplanetarium'

let g_client: LanguageClient
let g_log:    vscode.OutputChannel = vscode.window.createOutputChannel('Openplanetarium', 'log')

export function activate(context: vscode.ExtensionContext) {
    const start = performance.now()
    log('starting...')

    const serverModule = context.asAbsolutePath(path.join("server", "out", "server.js"))

    const serverOptions: ServerOptions = {
        run: {
            module: serverModule,
            transport: TransportKind.ipc
        },
        debug: {
            module: serverModule,
            transport: TransportKind.ipc
        }
    }

    const clientOptions: LanguageClientOptions = {
        documentSelector: [
            {
                scheme: "file",
                language: "angelscript"
            }
        ],
        synchronize: {
            fileEvents: vscode.workspace.createFileSystemWatcher("**/.clientrc"),
        }
    }

    g_client = new LanguageClient(
        NAME,
        "Openplanetarium",
        serverOptions,
        clientOptions
    )

    g_client.start()

    context.subscriptions.push(vscode.commands.registerCommand(`${NAME}.helloWorld`, () => {
        const msg = 'Hello World from Openplanetarium!'
        log(msg)
        vscode.window.showInformationMessage(msg)
    }))

    const end = performance.now()
    log(`ready (${(end - start).toFixed(1)} ms)`)
}

export function deactivate(): Thenable<void> | undefined {
    return g_client ? g_client.stop() : undefined
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
