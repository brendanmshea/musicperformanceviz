#!perl -w

use strict;

use LWP::Simple qw( get );

require './lib.pl';
require './boscom.pl';

my $incrementsize = 10;
my $numchunks = 100;
my $rssURLTemplate = 'http://calendar.boston.com/search?cat=7&rss=1&sort=1&srss=:::HOWMANY:::&ssi=:::STARTPOSITION:::';

my $datadir = "fetched";

print `cat headers.tsv`;

foreach my $chunk ( 0...$numchunks ) {
  my $startposition = $chunk * $incrementsize;

  my $url = $rssURLTemplate;
  $url =~ s{:::HOWMANY:::}{$incrementsize};
  $url =~ s{:::STARTPOSITION:::}{$startposition};

  my $fname = html_fname($datadir, "rss", $chunk);

  my $rss = fetch_through_cache($fname, $url);

  my @items = $rss =~ m{<item>(.*?)</item>}sg;

  foreach my $item (@items) {
    my %data;
    $data{id} = get_rss_generic("id", $item);
    $data{starttime} = get_rss_generic("xCal:dtstart", $item);
    $data{endtime} = get_rss_generic("xCal:dtend", $item);
    $data{latitude} = get_rss_generic("geo:lat", $item);
    $data{longitude} = get_rss_generic("geo:long", $item);
    $data{venuename} = get_rss_generic("xCal:x-calconnect-venue-name", $item);
    $data{street} = get_rss_generic("xCal:x-calconnect-street", $item);
    $data{city} = get_rss_generic("xCal:x-calconnect-city", $item);
    $data{region} = get_rss_generic("xCal:x-calconnect-region", $item);
    $data{postalcode} = get_rss_generic("xCal:x-calconnect-postalcode", $item);
    $data{country} = get_rss_generic("xCal:x-calconnect-country", $item);
    $data{imageurl} = get_rss_generic("url", $item);
    $data{url} = get_rss_generic("xCal:url", $item);

    foreach my $code (qw(id longid eventname starttime endtime latitude longitude venuename street city region postalcode country price rawprice url type)) {
      undef $data{$code} unless $data{$code};
    }

    my $title = get_rss_generic("title", $item);
    my ($eventname) = $title =~ m{^Event:\s*(.*?) at $data{venuename},};
    if ($eventname) {
      $data{eventname} = $eventname;
    }

    my $link = get_rss_generic("link", $item);
    my ($eventid) = $link =~ m{([^/]+$)};
    my $eventfname = sprintf "%s/%s-%s.html", $datadir, "event", $eventid;
    print STDERR "$eventid";

    my $html = fetch_through_cache($eventfname, $link);

    $data{longid} = $eventid;

    $data{price} = get_html_price($html);
    $data{rawprice} = get_html_raw_price($html);
    $data{type} = get_html_type($html);

    printstuff(\%data);
    print STDERR ".\n";
  }
}

sub printstuff {
  my ($datahash) = @_;

  my @fieldorder = qw(id longid eventname starttime endtime latitude longitude venuename street city region postalcode country price rawprice url type);

  print tab_collate($datahash, \@fieldorder);
  print "\n";
}
