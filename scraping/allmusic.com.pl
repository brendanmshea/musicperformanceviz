#!perl -w

use strict;

use LWP::Simple qw( get );

require './lib.pl';

my $allmusic = 'http://www.allmusic.com';
my $URLTemplate = $allmusic . '/cg/amg.dll?opt1=1&sql=:::NAME:::';

my $datadir = "fetched";

while (<>) {
  chomp;
  if (m/^ID\t/) { # header line, just add enrichment headers
    print "$_\tTrimmed Performer\tAllmusic Performer\tMoods\n";
    next;
  }

  my @data = split "\t";
  my $performer = trim_performer($data[2]);

  my $fname = html_fname($datadir, "performer", $data[0]);
  my $url = $URLTemplate;
  $url =~ s{:::NAME:::}{$performer};

  my $html = fetch_through_cache($fname, $url);

  if ($html =~ /Name Search Results for:/) { # this would mean it couldn't even guess, or there are duplicates, in both cases we lose
 #   print STDERR "PERF: $performer\n";
    if ($html =~ m{<a href="(/cg/amg\.dll\?p=amg&amp;sql=11:\w+)">$performer</a>}i) {
#      print STDERR "  PERF: $performer\n";
      my $newurl = $allmusic . $1;
      $newurl =~ s/&amp;/&/;
      $html = fetch_through_cache("$fname-redirect", $newurl);
    }
  }

  my %data;
  $data{artist} = get_html_artist($html);
  $data{moods} = get_html_moods($html);

  print join "\t", $_, $performer, $data{artist} ? $data{artist} : "?", $data{moods} ? $data{moods} : "?";
#  print join "\t", $data[0], $data[2], $performer, $data{artist} ? $data{artist} : "?", $data{moods} ? $data{moods} : "?";
  print "\n";

#  printf "%s => %s => %s\n", $data[2], $performer, $data{artist} ? $data{artist} : "?????" ;
#  printstuff(\%data);
#  print STDERR ".\n";
}

sub printstuff {
  my ($datahash) = @_;

  my @fieldorder = qw(id longid eventname starttime endtime latitude longitude venuename street city region postalcode country price rawprice url type);

  print join "\t", map {defined($datahash->{$_}) ? $datahash->{$_} : "?"} @fieldorder;
  print "\n";
}

sub trim_performer {
  my ($name) = @_;

  if ($name =~ /presents:?\s*(.*)/i) { # ignore who's doing the presenting
    return $1;
  }

  if ($name =~ /(.*)with special guest/i) { # ignore the special guests
    return $1;
  }
  if ($name =~ /(.*)(returns to|playing at)/i) { # add-on junk
    return $1;
  }

  if ($name =~ m{(.*?)[/,|:]}i) { # take the first of a multiple
    return $1;
  }

  # all else failed, just assume all of this is the name
  return $name;
}

sub get_html_artist {
  my ($blob) = @_;

  my ($artist) = $blob =~ m{<td class="titlebar"><span class="title">([^<]+)</span>};

  return $artist;
}

sub get_html_moods {
  my ($blob) = @_;

  my @moods = $blob =~ m{<li><a href="/cg/amg\.dll\?p=amg&amp;sql=77:\d+">([^<]+)</a></li>}g;

  return join "|", @moods;
}
