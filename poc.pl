#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(strftime);

my $now_string = strftime ("%Y-%m-%dT%H:%M:%S", localtime);
my $is_playing = `pgrep mpg123`;
my $should_play;
my $ending;

sub play {
  my ($url, $end_time) = @_;
  my $pid = fork();
  if ($pid == 0) {
    # we're the child
    exec("mpg123 $url");
  } else {
    my $now = strftime ("%Y-%m-%dT%H:%M:%S", localtime);
    while ($now lt $end_time) {
      sleep(3);
      $now = strftime ("%Y-%m-%dT%H:%M:%S", localtime);
      print "sleeping\n";
    }
    kill 1, $pid;
  }
}

my $filename = '/home/pi/public-stage/schedule.csv';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $line = <$fh>) {
    my ($start, $end, $url) = split(/,/, $line);
    if ($start lt $now_string && $end gt $now_string) {
        $should_play = $url;
        $ending = $end;
    }
}

if ($is_playing) {
    print "Currently playing. ";
    if ($should_play) {
        print "Nothing to do.\n";
        system("amixer set Master 70%");
    } else {
        print "Should stop playback.\n";
    }
} else {
    print "Not currently playing. ";
    if ($should_play) {
        print "Starting.\n";
        play($should_play, $ending);
    } else {
        print "Nothing to do.\n";
    }
}
