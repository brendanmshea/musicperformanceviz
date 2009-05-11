sub get_rss_generic {
  my ($tag, $blob) = @_;

  my ($data) = $blob =~ m{<$tag>(.*?)</$tag>};
  $data =~ s/\t/ /g if defined $data;

  return $data;
}

sub get_html_price {
  my $raw = get_html_raw_price(@_);

  return -1 unless defined $raw;

  if ($raw =~ m/^\s*(free|no cover|free of charge|free admission|none)\.?\s*$/i) {
    return 0;
  }
  if ($raw =~ m/^\s*\$?\s*(\d+)/) {
    return $1;
  }

  return -2;
}

sub get_html_raw_price {
  my ($blob) = @_;

  my ($price) = $blob =~ m{<div class="extra"><span class="title">Price:</span>([^<]+)</div>};
  $price =~ s/\t/ /g if defined $price;

  return $price;
}

sub get_html_typeX {
  my ($blob) = @_;

  my ($typecode, $typeword) = $blob =~ m{
<div\ class="extra">
\s*
<span\ class="title">Category:</span>
\s*
(?:<a\ href="/search\?cat=7&amp;st=event">Music</a>,
\s*)?
<a\ href="/search\?cat=(\d+)&amp;st=event">([^<]+)</a>
\s*
</div>
}x;

  return $typeword;
}

sub get_html_type {
  my ($blob) = @_;

  my ($typecode, $typeword) = $blob =~ m{
<a\ href="/search\?cat=(\d+)&amp;st=event">([^<]+)</a>
\s*
</div>
}x;

  $typeword =~ s/\t/ /g if defined $typeword;
  return $typeword;
}

1;
