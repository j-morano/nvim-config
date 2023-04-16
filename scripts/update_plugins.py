#!/usr/bin/env python3

import os
import glob
import subprocess


plugin_paths = glob.glob(
    f'{os.environ["HOME"]}/.local/share/nvim/site/pack/plugins/start/*'
)
plugin_paths += glob.glob(
    f'{os.environ["HOME"]}/.local/share/nvim/site/pack/plugins/opt/*'
)

print(f'Found {len(plugin_paths)} plugins')

for plugin_path in plugin_paths:
    print(f'Trying to update {os.path.basename(plugin_path)}:')
    result = subprocess.run(
        ['git', 'pull'], cwd=plugin_path, check=True, capture_output=True
    )
    print(result.stdout.decode('utf-8'), flush=True)
