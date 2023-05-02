#!/usr/bin/env python3

from pathlib import Path
import os
import sys
import glob
import subprocess
from subprocess import PIPE


home = os.environ['HOME']    
base_plugin_path = f'{home}/.local/share/nvim/site/pack/plugins'


def get_plugin_paths(verbose: bool=False):
    plugin_paths = glob.glob(os.path.join(base_plugin_path, 'start', '*'))
    plugin_paths += glob.glob(os.path.join(base_plugin_path, 'opt', '*'))
    if verbose:
        print(f'Found {len(plugin_paths)} plugins')
    return plugin_paths


if sys.argv[1] == 'list':
    for plugin_path in get_plugin_paths(True):
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
    for plugin_path in get_plugin_paths(True):
        print(f'Trying to update {os.path.basename(plugin_path)}:')
        result = subprocess.run(
            ['git', 'pull'],
            cwd=plugin_path,
            check=True,
            stdout=PIPE,
            stderr=PIPE
        )
        print(result.stdout.decode('utf-8'), flush=True)

elif sys.argv[1] == 'sync':
    operations = 0
    # Read plugins from file and install them if they are not installed
    with open(os.path.join(home, '.config', 'nvim', 'plugins'), 'r') as f:
        plugins = f.readlines()
    plugin_names = []
    for plugin in plugins:
        plugin = plugin.strip()
        plugin_url = 'https://github.com/' + plugin
        plugin_name = plugin_url.split('/')[-1]
        plugin_names.append(plugin_name)
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
            operations += 1
        else:
            # Update plugin
            print(f'Updating {plugin_name}')
            result = subprocess.run(
                ['git', 'pull'],
                cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                check=True,
                stdout=PIPE,
                stderr=PIPE
            )
            print(result.stdout.decode('utf-8'), flush=True)
            operations += 1
    plugin_paths = get_plugin_paths()
    # Remove plugins that are not in the plugins file
    for plugin_path in plugin_paths:
        if Path(plugin_path).name not in plugin_names:
            print(f'Removing {Path(plugin_path).stem}')
            result = subprocess.run(
                ['rm', '-rf', plugin_path],
                check=True,
                stdout=PIPE,
                stderr=PIPE
            )
            print(result.stdout.decode('utf-8'), flush=True)
            operations += 1
    if operations == 0:
        print('Nothing to do')

else:
    print('Unknown command')
    exit(1)
