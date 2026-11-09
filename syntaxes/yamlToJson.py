import json

import yaml


def main() -> None:
    with open('syntaxes/angelscript.tmLanguage.yaml') as f:
        y = yaml.full_load(f)

    with open('syntaxes/angelscript.tmLanguage.json', 'w', newline='\n') as f:
        json.dump(y, f, indent='\t')
        f.write('\n')


if __name__ == '__main__':
    main()
