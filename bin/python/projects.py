
import settings

import csv
import os
import os.path
import subprocess

from pathlib import Path




class Ontologies:
    config = settings.read_settings()
    storage = os.path.join(config['alive_dir'], 'hg-index.csv')
    path = Path(config['alive_dir'])



def readIndex():
    tuples = []
    if not os.path.exists(Ontologies.storage):
        return None
    print('reading cache: ' + Ontologies.storage + '\n')
    tuples = []
    with open(Ontologies.storage, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=';', quotechar='|')
        for row in reader:
            tuples += [(row[0], row[1], row[2])]
    return tuples



def createIndex():
    tuples = []
    roots = [element for element in Ontologies.path.iterdir() if element.is_dir()]
    for root in roots:
        for workspace in root.iterdir():
            if workspace.name == "workspace":
                for project in workspace.iterdir():
                    var = sorted(project.glob('**/[.]hg'))
                    if len(var) > 0:
                        full = var[0].parent.as_posix()
                        if full.count(';') > 0:
                            raise Exception("';' not allowed in path:" + full)
                        tuples += [(root.name, project.name, full)]

    print('Available projects:')
    for t in tuples:
        print(t)
    print()

    with open(Ontologies.storage, 'w+') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=';', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for row in tuples:
            spamwriter.writerow(row)
    return tuples



def getChangesMarker(repo):
	if not os.path.exists(repo):
		return ' => directory does not exist!'
	output = subprocess.check_output(['hg', 'status', '--cwd', repo])
	if output.strip():
		return '*'
	else:
		return ''


def selectProject(projects):
    print("Select project:")
    index = 0
    while index < len(projects):
        row = projects[index]
        print(str(index) + ") " + row[0] + " | " + row[1] + getChangesMarker(row[2]))
        index += 1
    print("*) refresh")
    print("q) quit")

    selection = input()
    print()
    if selection == 'q':
        return selection
    if selection == '*':
        return selectProject(createIndex())
    if selection.isdigit() and int(selection) < len(projects):
        return projects[int(selection)]



def select():
    projects = readIndex()
    if projects == None:
        projects = createIndex()

    project = None
    while project == None:
        project = selectProject(projects)
    return project
        
        
        
        
        
    
