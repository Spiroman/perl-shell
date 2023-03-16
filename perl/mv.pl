use File::Basename;

sub mv {
    my ($source, $destination) = @_;

    # Extract the filename from the source path
    my $filename = basename($source);

    # If the destination is a directory, append the filename to the path
    if (-d $destination) {
        $destination = $destination . '/' . $filename;
    }

    # Open the source file for reading
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

    # Delete the source file
    unlink($source) or die "Could not delete $source: $!";

    return 1;
}

1;