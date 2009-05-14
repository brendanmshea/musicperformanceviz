#!perl -wn

use strict;

my @fieldorder = qw(id longid eventname starttime endtime latitude longitude venuename street city region postalcode country price rawprice url type trimartist allusicartist moods genre allmusicurl);

chomp;
my @fields = split "\t";

my %data = ();
foreach my $fieldnum (0..$#fieldorder) {
#  print $fieldnum, " - ", $fieldorder[$fieldnum], "\n";
  $data{$fieldorder[$fieldnum]} = $fields[$fieldnum];
}

# sanity checks
next unless $data{postalcode} =~ m/^\d{5}$/;
next unless $data{eventname};
next unless $data{region} eq "MA";

my $type = $data{type};
if ($type eq "Music" && $data{genre}) {
  $type = $data{genre};
}

if ($type =~ m{^(Cabaret & Review|Ballet|Film|Comedy|Painting|Swing|Theater|Talks & Lectures|Galleries|Clubs)$}) {
  $type = "Performing Arts";
}
if ($type =~ m{^(World|Celtic|Ethnic & Cultural)$}) {
  $type = "World Music";
}
if ($type =~ m{^(Marches|Orchestral Music)$}) {
  $type = "Classical";
}
if ($type =~ m{^(Electronica)$}) {
  $type = "Techno & Dance";
}
if ($type =~ m{^(R&B|Rhythm & Blues)$}) {
  $type = "Blues";
}
if ($type =~ m{^(Rap)$}) {
  $type = "Rap/Hip-Hop";
}
if ($type =~ m{^(Music)$}) {
  $type = "Unspecified";
}
if ($type =~ m{^(Rap/Hip-Hop|Techno & Dance|Reggae|New Age|Gospel|Nature|Easy Listening|Miscellaneous|Charity & Volunteer)$}) {
  $type = "Other";
}

printf "%s\t%s\n", $_, $type;

