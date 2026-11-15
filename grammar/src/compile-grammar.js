import * as fs from 'fs'
import * as path from 'path'
import * as yaml from 'js-yaml'

(function main() {
    yamlToJson()
})()

function yamlToJson() {
    const start = performance.now()

    console.log('converting YAML syntax to JSON...')

    const yamlPath = path.join(import.meta.dirname, '..', 'angelscript.tmLanguage.yaml')
    if (!fs.existsSync(yamlPath)) {
        console.warn(`file not found: ${yamlPath}`)
        return
    }

    const outFolder = path.join(import.meta.dirname, '..', 'out')
    if (!fs.existsSync(outFolder)) {
        fs.mkdirSync(outFolder)
    }

    fs.writeFileSync(
        path.join(outFolder, 'angelscript.tmLanguage.json'),
        `${JSON.stringify(
            yaml.load(fs.readFileSync(yamlPath, 'utf-8')),
            undefined,
            '\t'
        )}\n`
    )

    const end = performance.now()
    console.log(`converted YAML syntax to JSON (${(end - start).toFixed(1)} ms)`)
}
