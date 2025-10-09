#!/usr/bin/env python3

from pathlib import Path
import os
import sys
import glob
import subprocess
from subprocess import PIPE
from typing import Optional, List
from functools import partial


home = os.environ['HOME']
base_plugin_path = f'{home}/.local/share/nvim/site/pack/plugins'
print = partial(print, flush=True)

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
        print(f'Found {len(plugin_paths)} plugins')
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
        print(result.stdout.decode('utf-8'))
    return result


if sys.argv[1] == 'help':
    print(HELP)

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
        print('  -', plugin_url)

elif sys.argv[1] == 'paths':
    for plugin_path in get_plugin_paths(True):
        print('  -', plugin_path)

elif sys.argv[1] == 'path':
    print(base_plugin_path)

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
        if '|' in plugin:
            parts = plugin.split('|')
            plugin = parts[0]
            branch = parts[1]
        else:
            branch = None
        plugin_url = 'https://github.com/' + plugin
        plugin_name = plugin.split('/')[-1]
        plugin_names.append(plugin_name)
        # Get default branch from server
        if branch is None:
            result = run(
                command=['git', 'ls-remote', '--symref', plugin_url, 'HEAD'],
                print_output=False
            )
            default_branch = result.stdout.decode('utf-8').strip().split('\n')[0]
            # Format: ref: refs/heads/master  HEAD
            branch = default_branch.split('refs/heads/')[1].split()[0]
        if not os.path.exists(os.path.join(base_plugin_path, 'start', plugin_name)):
            # Install plugin
            print(f'Installing {plugin}')
            if branch is not None:
                result = run(
                    command=['git', 'clone', '-b', branch, plugin_url],
                    cwd=os.path.join(base_plugin_path, 'start'),
                )
            else:
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
            prev_branch = result.stdout.decode('utf-8').strip()
            if prev_branch == '':
                print(f'Plugin {plugin} is not in a branch, skipping.\n')
            else:
                if prev_branch != branch:
                    print(f'Changing {plugin} from branch {prev_branch} to {branch}, and updating')
                    # Check if branch exists locally
                    result = run(
                        command=['git', 'branch', '--list', branch],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                        print_output=False
                    )
                    local_branch = result.stdout.decode('utf-8').strip()
                    if local_branch == '':
                        print(f' - Fetching branch {branch} for {plugin}')
                        run(
                            ['git', 'fetch', 'origin', branch],
                            cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                        )
                    print(f' - Switching to branch {branch} for {plugin} and pulling')
                    run(
                        ['git', 'switch', branch],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                    )
                    run(
                        ['git', 'pull'],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                    )
                elif branch is None or prev_branch == branch:
                    print(f'Updating {plugin}')
                    run(
                        ['git', 'pull'],
                        cwd=os.path.join(base_plugin_path, 'start', plugin_name),
                    )
            operations += 1
    plugin_paths = get_plugin_paths()
    # Remove plugins that are not in the plugins file
    for plugin_path in plugin_paths:
        if Path(plugin_path).name not in plugin_names:
            print(f'Removing {Path(plugin_path).stem}')
            run(['rm', '-rf', plugin_path])
            operations += 1
    if operations == 0:
        print('Nothing to do')

else:
    print('Unknown command')
    exit(1)
