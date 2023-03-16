#!/usr/bin/perl

sub wc {    
    my $filename = shift || return "Usage: wc filename\n";

    open(my $fh, "<", $filename) || die "Can't open file $filename: $!\n";

    my ($lines, $words, $chars) = (0, 0, 0);

    while (my $line = <$fh>) {
        $lines++;
        $words += scalar(split(/\s+/, $line));
        $chars += length($line);
    }

    close($fh);

    return "$lines $words $chars $filename\n";
}

1;