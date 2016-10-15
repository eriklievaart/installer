
import os
import re
import shutil
import subprocess
import time

if os.geteuid() != 0:
    exit("*error* need to be root!")

class Drive:
	device = None
	label = None
	uuid = None
	def validate(self):
		if not self.device.startswith('/dev/'):
			raise Exception('Invalid device: ' + self.device)
		if len(self.uuid) != 16:
			raise Exception('Invalid uuid: ' + self.uuid)			
		if len(self.label) == 0:
			raise Exception('Missing label: ' + self.label)

print('')
print('/etc/fstab:')
ignore_uuid = []
with open("/etc/fstab", "r") as f:
	lines = f.readlines()
	for line in lines :
		if len(line.strip()) > 0 and line.strip()[0] != "#":
			print('\t' + line.strip())
			first_word = line.strip().split()[0]
			if first_word.find('=') > -1:
				ignore_uuid.append(first_word.split('=')[1])

print()
print('ntfs blkid:')
drives = []
uuid_regex = re.compile('UUID="(?P<uuid>.+)"')
label_regex = re.compile('LABEL="(?P<label>.+)"')

blkid = str(subprocess.check_output("blkid", shell=True), encoding='utf8')
for line in blkid.split('\n'):
	if(line.find('ntfs') > 0):
		print('\tline: ' + line)
		columns = line.split()
		drive = Drive()
		drive.device = columns[0].rstrip(':')
		parse = label_regex.match(columns[1])
		if not parse:
			print('\tinvalid label: ' + columns[1])
			continue;
		drive.label = parse.group('label')
		parse = uuid_regex.match(columns[2])
		drive.uuid = parse.group('uuid')
		drive.validate()
		if not drive.uuid in ignore_uuid:
			drives.append(drive)

lines = []
fstab_format = '\nUUID={d.uuid}\t/media/{d.label}\tntfs\tdefaults\t0 0'
for drive in drives:
	lines.append(fstab_format.format(d=drive))

print()
if(len(lines) > 0):
	# backup fstab and append drives
	timestamp = str(int(time.time()))
	backup = '/etc/fstab-' + timestamp + '-backup.txt'
	print('backup /etc/fstab to ' + backup)
	shutil.copyfile('/etc/fstab', backup)
	with open("/etc/fstab", "a") as file:
		for line in lines:
			print('appending: ' + line)
			file.write(line)
		file.write('\n')
else:
	print('no new entries for /etc/fstab')
	print('')

