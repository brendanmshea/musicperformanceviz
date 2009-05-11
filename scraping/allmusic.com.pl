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
    print "$_\tTrimmed Performer\tAllmusic Performer\tMoods\tAllmusic Genre\tAllmusic URL\n";
    next;
  }

  my @data = split "\t";
  my $performer = trim_performer($data[2]);

  my $fname = html_fname($datadir, "performer", $data[0]);
  my $url = $URLTemplate;
  $url =~ s{:::NAME:::}{$performer};

  my $html = fetch_through_cache($fname, $url);

  if ($html =~ /Name Search Results for:/) { # this would mean it couldn't even guess, or there are duplicates
    if ($html =~ m{<a href="(/cg/amg\.dll\?p=amg&amp;sql=11:\w+)">$performer</a>}i) { # check if there was an exact match, and take the first one
      my $newurl = $allmusic . $1;
      $newurl =~ s/&amp;/&/;
      $html = fetch_through_cache("$fname-redirect", $newurl);
    }
  }

  my %data;
  $data{artist} = get_html_artist($html);
  $data{moods} = get_html_moods($html);
  $data{genre} = get_html_genre($html);
  $data{url} = get_html_url($html);

  my @fieldorder = qw(artist moods genre url);
  print join "\t", $_, $performer, tab_collate(\%data, \@fieldorder);

#  print join "\t", $data[0], $data[2], $performer, $data{artist} ? $data{artist} : "?", $data{moods} ? $data{moods} : "?";
  print "\n";

#  printf "%s => %s => %s\n", $data[2], $performer, $data{artist} ? $data{artist} : "?????" ;
#  printstuff(\%data);
#  print STDERR ".\n";
}

sub trim_performer {
  my ($name) = @_;

  if ($name =~ /presents:?\s*(.*)/i) { # ignore who's doing the presenting
    return $1;
  }

  if ($name =~ /(.*)with special guest/i) { # ignore the special guests
    return $1;
  }
  if ($name =~ /(.*)feat(\.|uring)/i) { # ignore the special guests
    return $1;
  }
  if ($name =~ /(.*)(returns to|playing at)/i) { # add-on junk
    return $1;
  }

  if ($name =~ m{(.*?)[/,|:&]}i) { # take the first of a multiple
    return $1;
  }

  if ($name =~ /(.*)with/i) { # at this point, ignore anything that's "with"
    return $1; # note that this loses us some stuff, since sometimes it's "music with person"
  }

  # all else failed, just assume all of this is the name
  return $name;
}

sub get_html_artist {
  my ($blob) = @_;

  my ($artist) = $blob =~ m{<td class="titlebar"><span class="title">([^<]+)</span>};

  return $artist;
}

sub get_html_url {
  my ($blob) = @_;

  my ($url) = $blob =~ m{(/cg/amg\.dll\?p=amg(?:&searchlink=[^&]+)?&sql=\d+:\w+)~T0">Overview</a>};
  return "" unless $url;

  $url =~ s/&searchlink=[^&]+//;

  return $allmusic . $url;
}

sub get_html_genre {
  my ($blob) = @_;

  my @genres = $blob =~ m{<li><a href="/cg/amg\.dll\?p=amg&amp;sql=73:\d+">([^<]+)</a></li>}g;

  return join "|", @genres;
}

sub get_html_moods {
  my ($blob) = @_;

  my @moods = $blob =~ m{<li><a href="/cg/amg\.dll\?p=amg&amp;sql=77:\d+">([^<]+)</a></li>}g;

  return join "|", @moods;
}
