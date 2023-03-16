sub cp {
    my ($source, $destination) = @_;
    open(my $src_fh, '<', $source) or die "Could not open $source: $!";

    # Open the destination file for writing
    open(my $dest_fh, '>', $destination) or die "Could not open $destination: $!";

    # Copy the contents of the source file to the destination file
    while (my $line = <$src_fh>) {
        print $dest_fh $line;
    }

    # Close the source and destination files
    close($src_fh);
    close($dest_fh);

    # Check if the copy was successful by comparing file sizes
    my $src_size = -s $source;
    my $dest_size = -s $destination;

    if ($src_size != $dest_size) {
        die "Copy failed: $source and $destination have different sizes!";
    }

    return 1;
}

1;
