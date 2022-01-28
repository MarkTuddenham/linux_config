#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# ref: https://github.com/i3/i3status/blob/master/contrib/wrapper.py
#
# To use it, ensure your ~/.i3status.conf contains this line:
#     output_format = "i3bar"
# in the 'general' section.
# Then, in your ~/.i3/config, use:
#     status_command i3status | ~/i3status/contrib/wrapper.py
# In the 'bar' section.

import sys
import subprocess
import json


def gpu_info():
    info_str = subprocess.getoutput(
        'nvidia-smi --query-gpu=gpu_name,pstate,utilization.gpu,utilization.memory,temperature.gpu --format=csv,noheader').strip()
    gpu_name, pstate, util, mem, temp = [str.strip() for str in info_str.split(',')]
    util = util.replace(' ', '')
    mem = mem.replace(' ', '')
    return f'{gpu_name} {pstate} util: {util} mem: {mem} {temp}°C',


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
        j.insert(0, {
            'full_text': gpu_info(),
            'name': 'gpu',
            'color': '#3A85FF'
        })
        # and echo back new encoded json
        print_line(prefix + json.dumps(j))
