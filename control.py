#!/usr/bin/python

import mpd
import csv
import time

host = "localhost"
port = 6600
datetime_format = '%Y-%m-%dT%H:%M:%S'

# Returns the file of the first line of the CSV with timestamps
# that flank the current time.
def get_current_schedule_song():
  now = time.localtime()
  with open('schedule.csv', 'rb') as csv_file:
    row_reader = csv.reader(csv_file, delimiter=',', quotechar='"')
    for row in row_reader:
      start_time = time.strptime(row[0], datetime_format)
      end_time = time.strptime(row[1], datetime_format)
      if start_time <= now and now <= end_time:
        return row[2]

# Checks to see if the given song is playing and, if not, sets
# it to be playing.
def check_and_play_song(client, song_url):
  song = client.currentsong()
  if song['file'] != song_url:
    client.clear()
    client.add(song_url)
  status = client.status()
  if status['state'] != 'play':
    client.play()

if __name__ == "__main__":
  scheduled_song_url = get_current_schedule_song()
  client = mpd.MPDClient()
  client.connect("192.168.0.108",6600)
  if scheduled_song_url:
    check_and_play_song(client, scheduled_song_url)
  else:
    client.stop()

