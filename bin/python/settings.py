
import os


def read_settings():
	home = os.getenv("HOME")
	path = home + '/Public/settings.cfg'
	print('reading: ' + path)

	settings = {}
	file = open(path, 'r')
	for line in file:
		split = line.split('=');
		settings[split[0].strip()] = split[1].strip().strip('"')
		print('\t' + split[0] + ' = ' + split[1].strip())
	print()
	return settings

