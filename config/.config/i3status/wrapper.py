#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import sys
import json
from subprocess import check_output

def get_current_window_name():
	return check_output(["/home/penguin/.xmonad/bin/active-window"]).strip()

def get_volume():
	c = check_output(["/home/penguin/.xmonad/bin/volume.sh"])
	return c.strip()

def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()

def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()

if __name__ == '__main__':
	# Skip the first line which contains the version header.
	print_line(read_line())

	# The second line contains the start of the infinite array.
	print_line(read_line())

	while True:
		line, prefix = read_line(), ''
		# ignore comma at start of lines
		if line.startswith(','):
			line, prefix = line[1:], ','

		j = json.loads(line)
		# insert information into the start of the json, but could be anywhere
		# CHANGE THIS LINE TO INSERT SOMETHING ELSE

		j.insert(0, {'full_text' : '%s' % get_current_window_name(), 'name' : 'active window'})
		vol = get_volume()
		# and echo back new encoded json
		print_line(prefix+json.dumps(j))

