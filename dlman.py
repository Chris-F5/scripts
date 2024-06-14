#!/bin/python3
import re, sys, os

archive_fname = "music.dlman"
archive_file = open(archive_fname, 'r')
archive = []
current = ""
line_no = 0

for line in archive_file:
  line_no += 1
  line = line.split(';', 1)[0]
  line = line.strip()
  if re.search(r"^\s*$", line): continue
  elif r := re.search(r"^\[(\S*)\]$", line):
    dir = os.path.normpath(r.group(1))+'/'
    if dir == './': dir = ''
    current = dir
  elif r := re.search(r"^ADD (.*)$", line):
    archive.append((current, r.group(1)))
  else:
    print(f"music_archive INVALID SYNTAX on line {line_no}", file=sys.stderr)
    exit(1)

extract = [os.path.normpath(a)+'/' for a in sys.argv[1:]]
extract = ['' if a == './' else a for a in extract]
if len(extract) == 0: extract = ['']
archive = [(d,u) for (d,u) in archive if any(d.startswith(a) for a in extract)]

for d,u in archive:
  print(f"""(mkdir -p "{d}" && cd "{d}" && yt-dlp --download-archive .ytdlp_archive -x --audio-format opus "{u}")""")
