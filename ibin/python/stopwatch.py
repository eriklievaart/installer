
import os
import re
import select
import sys
import termios
import time
import tty

class Stopwatch:
	def __init__(self):
		self.start = None
		self.running = False
		self.alarm = 0
		self.totalElapsed = 0

	def isOdd(self):
		return round(time.time()) % 2 == 1

	def isRunning(self):
		return self.running

	def init(self, string):
		self.totalElapsed = self.seconds(string)

	def setAlarm(self, string):
		self.alarm = self.seconds(string)
		self.running = True

	def seconds(self, string):
		split = string.split(':')
		split.reverse();
		seconds = int(split[0]) if split[0] else 0
		if len(split) > 1 and split[1]:
			seconds += 60 * int(split[1])
		if len(split) > 2 and split[2]:
			seconds += 3600 * int(split[2])
		return seconds

	def startTimer(self):
		if not self.running:
			self.start = time.time()
			self.running = True

	def pauseTimer(self):
		if self.running:
			self.totalElapsed += time.time() - self.start
			self.running = False

	def toggleTimer(self):
		if self.running:
			self.pauseTimer()
		else:
			self.startTimer()

	def elapsed(self):
		if self.running:
			return int(self.totalElapsed + (time.time() - self.start))
		else:
			return int(self.totalElapsed)

	def isRinging(self):
		if self.alarm == 0:
			return False
		return self.alarm < self.elapsed()

	def timestamp(self):
		time = self.elapsed() if self.alarm == 0 else self.alarm - self.elapsed()
		if time < 0:
			return "00:00:00"

		h = time // 3600
		m = time % 3600 // 60
		s = time % 60
		return f"{h:02d}:{m:02d}:{s:02d}"

def clear_screen():
	os.system('cls' if os.name == 'nt' else 'clear')

def key_pressed():
	dr, dw, de = select.select([sys.stdin], [], [], 0)
	return dr

def load_ascii_numbers(file):
	numbers = {}

	with open(file, "r", encoding="utf-8") as f:
		index = 0
		lines = []

		for line in f:
			colon = index > 9
			if line.strip() == "" and not colon:
				if len(lines) > 0:
					numbers[str(index)] = lines
					lines = []
					index += 1
			else:
				pad = 3 if colon else 9
				lines.append(line.rstrip("\n").ljust(pad))

		numbers[":"] = lines

	return numbers

def center(lines):
	sw = os.get_terminal_size().columns
	result = [];

	maxlw = 0
	for line in lines:
		maxlw = max(maxlw, len(line))

	pad = int((sw - maxlw) / 2) + maxlw
	for line in lines:
		result.append(line.rjust(pad))
	return result



def print_clock(sw, numbers):
	height = len(next(iter(numbers.values())))
	clock_lines = [""] * height

	print("timestamp: " + sw.timestamp());
	for char in sw.timestamp():
		digit_block = numbers.get(char)
		for i in range(height):
			clock_lines[i] += digit_block[i] + " "

	clear_screen()
	centered = center(clock_lines)
	print("\nq to quit\np to pause/resume")
	if sw.isRinging():
		if sw.isOdd():
			print("\n\n\n\n\n")
			return
		print("\033[31m", end="");
	elif sw.isRunning():
		print("\033[32m", end="");
	for line in centered:
		print(line)
	print("\033[0m")

def main():

	numbers = load_ascii_numbers("numbers.txt")

	fd = sys.stdin.fileno()
	old_settings = termios.tcgetattr(fd)
	tty.setcbreak(fd)

	try:
		sw = Stopwatch()
		sw.startTimer()
		if len(sys.argv) > 1:
			if sys.argv[1] == "-a":
				sw.setAlarm(":".join(sys.argv[2:]));
			else:
				sw.init(":".join(sys.argv[1:]))
		last = None;

		while True:
			if key_pressed():
				c = sys.stdin.read(1)
				if c.lower() == 'p':
					sw.toggleTimer()
				if c.lower() == 'q':
					exit(0)

			stamp = sw.timestamp();
			if stamp != last:
				print_clock(sw, numbers)
			if sw.isRinging():
				os.system("paplay /usr/share/sounds/freedesktop/stereo/bell.oga")

			time.sleep(0.1)

	except KeyboardInterrupt:
		print("\nStopped.")

	finally: # restore terminal, else it will be dead
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


if __name__ == "__main__":
	main()

