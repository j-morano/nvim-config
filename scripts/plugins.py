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

HELP = """Usage: plugins.py <command>

Commands:
    list        List plugins
    paths       List plugin paths
    path        Print plugin path
    sync        Sync plugins with plugins file
    help        Show this help message
"""


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


if sys.argv[1] == 'help':
    print(HELP, flush=True)

elif sys.argv[1] == 'list':
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

elif sys.argv[1] == 'paths':
    for plugin_path in get_plugin_paths(True):
        print('  -', plugin_path, flush=True)

elif sys.argv[1] == 'path':
    print(base_plugin_path, flush=True)

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
        plugin_url = 'https://github.com/' + plugin
        plugin_name = plugin.split('/')[-1]
        plugin_names.append(plugin_name)
        if not os.path.exists(os.path.join(base_plugin_path, 'start', plugin_name)):
            # Install plugin
            print(f'Installing {plugin}', flush=True)
            result = run(
                command=['git', 'clone', plugin_url],
                cwd=os.path.join(base_plugin_path, 'start'),
            )
            operations += 1
        else:
            # Update plugin
            # Check if plugin is in a branch
            result = run(
                command=['git', 'branch', '--show-current'],
                cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                print_output=False
            )
            if result.stdout.decode('utf-8').strip() == '':
                print(f'Plugin {plugin} is not in a branch, skipping.\n', flush=True)
            else:
                print(f'Updating {plugin}', flush=True)
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
