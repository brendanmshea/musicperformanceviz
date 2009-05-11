
# build an HTML file name
sub html_fname {
  my ($dir, $type, $count) = @_;

  return sprintf "%s/%s-%02d.html", $dir, $type, $count;
}

# 
sub tab_collate {
  my ($datahash, $fieldorder) = @_;

  my $unknown = ""; # "" or "?"
  my $result = join "\t", map {defined($datahash->{$_}) ? $datahash->{$_} : $unknown} @$fieldorder;
#  my $result = join "\t", map {$datahash->{$_} ? $datahash->{$_} : $unknown} @$fieldorder;

  return $result;
}

# simple cacheing
sub fetch_through_cache {
  my ($fname, $url) = @_;

  my $content;

  if (!-f $fname) { # fetch if we don't already have it
    print STDERR "Fetching- $fname from $url ...";

    $content = get($url);
    spew_file($fname, $content);

    print STDERR " DONE\n";
  } else { # already had it, jsut return what's already there
    $content = slurp_file($fname);
  }

  return $content;
}


# return the contents of a given file as one single string
sub slurp_file {
    my $filename = shift;

    # slurp the file in
    my $prevdolslash = $/;	# keep previous state
    undef $/;			# whole file
    open (FILE, $filename)  or die "Couldn't read '$filename': $!";
    my $contents = <FILE>;	# SSSCHLURRRPPPP!
    close FILE;

    $/ = $prevdolslash;		# put things back where they came from

    return $contents;
}


# save the contents of a string into a file (to be used e.g. with slurp_file)
sub spew_file {
    my ($filename, $contents) = @_;

    open (FILE, ">$filename")  or die "Error: Couldn't open '$filename' for writing: $!\n";
    print FILE $contents;
    close FILE;
}


1;
