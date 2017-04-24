#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(strftime);

my $now_string = strftime ("%Y-%m-%dT%H:%M:%S", localtime);
my $is_playing = `pgrep mpg123`;
my $should_play;

my $filename = '/home/pi/public-stage/schedule.csv';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";

while (my $line = <$fh>) {
    my ($start, $end, $url) = split(/,/, $line);
    if ($start lt $now_string && $end gt $now_string) {
        $should_play = $url;
    }
}

if ($is_playing) {
    print "Currently playing. ";
    if ($should_play) {
        print "Nothing to do.\n";
    } else {
        print "Stopping playback.\n";
        system ("pkill mpg123");
    }
} else {
    print "Not currently playing. ";
    if ($should_play) {
        print "Starting.\n";
        exec ("mpg123 http://wgbh.streamguys.com:8000/wgbh");
    } else {
        print "Nothing to do.\n";
    }
}
