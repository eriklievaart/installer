
import os
import shutil
import subprocess

from pathlib import Path




root = os.getcwd()
root_path = Path(root)
print("running packmaster in: " + root)


def unpack(glob, command, flag):
	z7 = root_path.glob(glob)
	for zip_file in z7:
		unpack_dir = zip_file.parent.as_posix() + '/' + zip_file.stem
		if Path(unpack_dir).exists():
			shutil.rmtree(unpack_dir)
		os.mkdir(unpack_dir)
		print('\tcopying ' + zip_file.stem + ' to ' + unpack_dir)
		shutil.copyfile(zip_file.as_posix(), unpack_dir + '/' + zip_file.name)
		os.chdir(unpack_dir)
		print('unpacking ' + zip_file.stem)
		subprocess.check_output([command, flag, zip_file.name])
	

unpack('**/*.7z', 'p7zip', '-d')


rar = root_path.glob('**/*.rar')
for rar_file in rar:
	parent_dir = rar_file.parent.as_posix()
	unpack_dir = parent_dir + '/' + rar_file.stem
	if Path(unpack_dir).exists():
		shutil.rmtree(unpack_dir)
	os.chdir(parent_dir)
	print('unpacking ' + rar_file.stem)
	subprocess.check_output(['unrar', 'x', '-ad', rar_file.name])

zip_glob = root_path.glob('**/*.zip')
for zip_file in zip_glob:
	parent_dir = zip_file.parent.as_posix()
	unpack_dir = parent_dir + '/' + zip_file.stem
	if Path(unpack_dir).exists():
		shutil.rmtree(unpack_dir)
	os.mkdir(unpack_dir)
	tmp_file = unpack_dir + '/' + zip_file.name
	shutil.copyfile(zip_file.as_posix(), tmp_file)
	os.chdir(unpack_dir)
	print('unpacking ' + zip_file.stem)
	subprocess.check_output(['unzip', zip_file.name])
	os.remove(tmp_file)




# find 7z, zip, rar
# create directory per file
# unpack 7z, zip, rar


