#!/usr/bin/env python3

import os
import sys
import glob
import subprocess
from subprocess import PIPE


plugin_paths = glob.glob(
    f'{os.environ["HOME"]}/.local/share/nvim/site/pack/plugins/start/*'
)
plugin_paths += glob.glob(
    f'{os.environ["HOME"]}/.local/share/nvim/site/pack/plugins/opt/*'
)

print(f'Found {len(plugin_paths)} plugins')

if sys.argv[1] == '--list':
    for plugin_path in plugin_paths:
        print('  -', os.path.basename(plugin_path))

elif sys.argv[1] == '--update':
    for plugin_path in plugin_paths:
        print(f'Trying to update {os.path.basename(plugin_path)}:')
        result = subprocess.run(
            ['git', 'pull'],
            cwd=plugin_path,
            check=True,
            stdout=PIPE,
            stderr=PIPE
        )
        print(result.stdout.decode('utf-8'), flush=True)
