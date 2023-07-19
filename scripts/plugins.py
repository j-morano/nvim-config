#!/usr/bin/env python3

from pathlib import Path
import os
import sys
import glob
import subprocess
from subprocess import PIPE
from typing import Optional, List


home = os.environ['HOME']    
base_plugin_path = f'{home}/.local/share/nvim/site/pack/plugins'


def get_plugin_paths(verbose: bool=False):
    plugin_paths = glob.glob(os.path.join(base_plugin_path, 'start', '*'))
    plugin_paths += glob.glob(os.path.join(base_plugin_path, 'opt', '*'))
    if verbose:
        print(f'Found {len(plugin_paths)} plugins', flush=True)
    return plugin_paths


def run(
    command: List,
    cwd: Optional[str]=None,
    print_output: bool=True
) -> subprocess.CompletedProcess:
    result = subprocess.run(
        command,
        cwd=cwd,
        check=True,
        stdout=PIPE,
        stderr=PIPE
    )
    if print_output:
        print(result.stdout.decode('utf-8'), flush=True)
    return result


if sys.argv[1] == 'list':
    for plugin_path in get_plugin_paths(True):
        # Get url of plugin
        result = run(
            command=['git', 'config', '--get', 'remote.origin.url'],
            cwd=plugin_path,
            print_output=False
        )
        plugin_url = result.stdout.decode('utf-8').strip().replace('.git', '')
        plugin_url_split = plugin_url.split('/')
        plugin_url = plugin_url_split[-2] + '/' + plugin_url_split[-1]
        print('  -', plugin_url, flush=True)

elif sys.argv[1] == 'sync':
    operations = 0
    # Read plugins from file and install them if they are not installed
    with open(os.path.join(home, '.config', 'nvim', 'plugins'), 'r') as f:
        plugins = f.readlines()
    plugin_names = []
    for plugin in plugins:
        plugin = plugin.strip()
        if plugin.startswith('#'):
            continue
        if '@' in plugin:
            parts = plugin.split('@')
            plugin = parts[0]
            branch = parts[1]
        else:
            branch = None
        plugin_url = 'https://github.com/' + plugin
        plugin_name = plugin.split('/')[-1]
        plugin_names.append(plugin_name)
        if not os.path.exists(os.path.join(base_plugin_path, 'start', plugin_name)):
            print(f'Installing {plugin}', flush=True)
            if branch is not None:
                command = ['git', 'clone', '-b', branch, plugin_url]
            else:
                command = ['git', 'clone', plugin_url]
            result = run(
                command=command,
                cwd=os.path.join(base_plugin_path, 'start'),
            )
            operations += 1
        else:
            # Update plugin
            print(f'Updating {plugin}', flush=True)
            if branch is not None:
                try:
                    run(
                        ['git', 'checkout', branch],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                    )
                except subprocess.CalledProcessError:
                    run(
                        ['git', 'pull', 'origin', branch],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                    )
            else:
                run(
                    ['git', 'pull'],
                    cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                )
                operations += 1
    plugin_paths = get_plugin_paths()
    # Remove plugins that are not in the plugins file
    for plugin_path in plugin_paths:
        if Path(plugin_path).name not in plugin_names:
            print(f'Removing {Path(plugin_path).stem}', flush=True)
            run(['rm', '-rf', plugin_path])
            operations += 1
    if operations == 0:
        print('Nothing to do', flush=True)

else:
    print('Unknown command', flush=True)
    exit(1)
