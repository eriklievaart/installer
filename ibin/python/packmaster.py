
import os
import shutil
import subprocess

from pathlib import Path


def unpack(root, glob, args):
	for archive in Path(root).glob(glob):
		if os.path.isdir(archive):
			continue
		parent_dir = archive.parent.as_posix()
		os.chdir(parent_dir)
		unpack_dir = parent_dir + '/' + archive.stem
		if Path(unpack_dir).exists():
			shutil.rmtree(unpack_dir)
		os.mkdir(unpack_dir)
		print('unpacking ' + archive.name)
		subprocess.check_output(args(archive.name, unpack_dir))


root=os.getcwd()
print("running packmaster in: " + root)
unpack(root, '**/*.zip',    lambda archive, unpack: ['unzip', archive, '-d', unpack])
unpack(root, '**/*.rar',    lambda archive, unpack: ['unrar', 'x', '-ad', archive])
unpack(root, '**/*.tar',    lambda archive, unpack: ['tar', '-xf',  archive, '-C', unpack])
unpack(root, '**/*.tar.gz', lambda archive, unpack: ['tar', '-zxf', archive, '-C', unpack])
unpack(root, '**/*.7z',     lambda archive, unpack: ['7z', 'x', archive , '-o' + unpack])


