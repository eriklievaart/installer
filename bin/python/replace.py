
import pathlib
import projects



project = projects.select()[2]
print("project: " + project)

query = input("search for:")

glob_input = input("search in (blank for 'java'):")
glob = '**/*.' + ('java' if glob_input == '' else glob_input)

root = pathlib.Path(project)
paths = sorted(root.glob(glob))
results = []
for path in paths:
	with open(str(path), "r") as opened:
		lines = opened.readlines()
		for index, line in enumerate(lines):
			if line.find(query) > -1:
				results.append((path.name + '(' + str(index) + '):', line.strip()))

max_name = 0;
for result in results:
	max_name = max(max_name, len(result[0])) 
str_format = '{prefix:<' + str(max_name) + '} {line}'

for result in results:
	print(str_format.format(prefix=result[0], line=result[1]))

print()
replacement = input("replace with:")

for path in paths:
	read_file = open(str(path), "r")
	original = read_file.read()
	read_file.close()
	modified = original.replace(query, replacement)
	if original == modified:
		continue
	with open(str(path), "w") as write_file:
		write_file.write(modified)
		print(path.name + ' modified')


# TODO
# create reiterable menu (project, search, ext, replace)
# + dump surrounding lines
# + regex replace

