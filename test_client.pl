#!/usr/bin/env perl

use strict;
use warnings;

use IO::File;
use HTTP::Tiny;

my $tiny = HTTP::Tiny->new;
for my $i (1 .. 5) {
    print "times: $i\n";
    my $r = $tiny->get('http://testserver.spvm.info/chunk/images');
    my $fh = IO::File->new("> images_$i.tar.gz");
    if (defined $fh) {
        print $fh $r->{content};
    }
    $fh->close;
}