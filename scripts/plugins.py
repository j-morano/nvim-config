#!/usr/bin/env python3

import os
import sys
import glob
import subprocess
from subprocess import PIPE


home = os.environ['HOME']    
base_plugin_path = f'{home}/.local/share/nvim/site/pack/plugins'


def get_plugin_paths():
    plugin_paths = glob.glob(os.path.join(base_plugin_path, 'start', '*'))
    plugin_paths += glob.glob(os.path.join(base_plugin_path, 'opt', '*'))
    print(f'Found {len(plugin_paths)} plugins')
    return plugin_paths


if sys.argv[1] == 'list':
    for plugin_path in get_plugin_paths():
        # Get url of plugin
        result = subprocess.run(
            ['git', 'config', '--get', 'remote.origin.url'],
            cwd=plugin_path,
            check=True,
            stdout=PIPE,
            stderr=PIPE
        )
        plugin_url = result.stdout.decode('utf-8').strip().replace('.git', '')
        plugin_url_split = plugin_url.split('/')
        plugin_url = plugin_url_split[-2] + '/' + plugin_url_split[-1]
        print('  -', plugin_url, flush=True)

elif sys.argv[1] == 'update':
    for plugin_path in get_plugin_paths():
        print(f'Trying to update {os.path.basename(plugin_path)}:')
        result = subprocess.run(
            ['git', 'pull'],
            cwd=plugin_path,
            check=True,
            stdout=PIPE,
            stderr=PIPE
        )
        print(result.stdout.decode('utf-8'), flush=True)

elif sys.argv[1] == 'install':
    # Example: https://github.com/j-morano/buffer_manager.nvim
    plugin_url = sys.argv[2]
    plugin_url = 'https://github.com/' + plugin_url
    plugin_name = plugin_url.split('/')[-1]
    if os.path.exists(os.path.join(base_plugin_path, 'start', plugin_name)):
        print(f'Plugin {plugin_name} already installed')
        exit(1)
    result = subprocess.run(
        ['git', 'clone', plugin_url],
        cwd=os.path.join(base_plugin_path, 'start'),
        check=True,
        stdout=PIPE,
        stderr=PIPE
    )
    print(result.stdout.decode('utf-8'), flush=True)

elif sys.argv[1] == 'sync':
    # Read plugins from file and install them if they are not installed
    with open(os.path.join(home, '.config', 'nvim', 'plugins'), 'r') as f:
        plugins = f.readlines()
    for plugin in plugins:
        plugin = plugin.strip()
        plugin_url = 'https://github.com/' + plugin
        plugin_name = plugin_url.split('/')[-1]
        if not os.path.exists(os.path.join(base_plugin_path, 'start', plugin_name)):
            print(f'Installing {plugin_name}')
            result = subprocess.run(
                ['git', 'clone', plugin_url],
                cwd=os.path.join(base_plugin_path, 'start'),
                check=True,
                stdout=PIPE,
                stderr=PIPE
            )
            print(result.stdout.decode('utf-8'), flush=True)

else:
    print('Unknown command')
    exit(1)
