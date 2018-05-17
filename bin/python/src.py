
import os
import projects
import subprocess




def invoke(p):
    os.chdir(p[2])
    subprocess.call(["/usr/bin/hg", 'status'])
    print()

    print("Select action for " + p[2])
    print('c) commit')
    print('d) diff')
    print('m) merge')
    print('p) push')
    print('u) pull & update')
    print('revert) revert')
    print('/) index')
    print('q) quit')
    command = input()

    if command == 'c':
        subprocess.call(['/usr/bin/hg', 'addremove'])
        subprocess.call(['/usr/bin/hg', 'commit'])
    if command == 'd':
        subprocess.call(['/usr/bin/hg', 'diff', '-w'])
    if command == 'm':
        subprocess.call(['/usr/bin/hg', 'merge'])
        subprocess.call(['/usr/bin/hg', 'commit'])
    if command == 'p':
        subprocess.call(['/usr/bin/hg', 'push', 'https://Lievaart@bitbucket.org/Lievaart/' + project[1]])
    if command == 'u':
        subprocess.call(['/usr/bin/hg', 'pull', 'https://Lievaart@bitbucket.org/Lievaart/' + project[1]])
        subprocess.call(['/usr/bin/hg', 'update'])
    if command == 'revert':
        subprocess.call(['/usr/bin/hg', 'revert', '--all'])

    print()
    return command


command = None
project = None

while 'true':
    project = projects.select()
    if project == 'q':
        break
    while command != '/' and command != 'q':
        command = invoke(project)    
    if command == 'q':
        break
    project = None
    command = None



