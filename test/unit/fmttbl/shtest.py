#!/bin/python3

import re
import subprocess
import sys


class Test:
	name = "";
	input = "";
	expect = "";

	def __init__(self, name):
		self.name = name;



def parseTest(lines):
	tst = Test(lines.pop(0));
	while lines[0].strip() == '':
		lines.pop(0);
	while lines[0].strip() != '':
		tst.input += lines.pop(0) + '\n';
	while lines[0].strip() == '':
		lines.pop(0);
	while lines[0].strip() != '':
		tst.expect += lines.pop(0) + '\n';
	tests.append(tst);




def readFile(path):
	lines = [];
	file = open(path, 'r')
	for line in file:

		if line.startswith("@test"):
			if lines:
				parseTest(lines)

			lines = [line.strip()]

		elif line.strip() != "" or lines:
			lines.append(line.strip());

	if lines:
		parseTest(lines)




tests = [];
failed = [];
readFile('fmtdata.txt');
for t in tests:
	p = subprocess.Popen('fmttbl', stdin=subprocess.PIPE, stdout=subprocess.PIPE);
	out, err = p.communicate(input=str.encode(t.input))
	result = out.decode("utf-8");
	if p.returncode != 0:
		sys.exit();
	if result.strip() != t.expect.strip():
		failed.append(t);
		print(t.name)
		print('\t' + result.replace('\n', '\n\t').strip())
		print('!=\n\t' + t.expect.replace('\n', '\n\t'))

for t in failed:
	print("test failed! " + t.name);

if len(failed) == 0:
	print("all tests passed!")
else:
	print(str(len(failed)) + " tests failed!")












