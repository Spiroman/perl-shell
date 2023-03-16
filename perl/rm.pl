sub rm {
    my ($file) = @_;

    # Delete the file
    unlink($file) or die "Could not delete $file: $!";

    return 1;   # return true value to indicate success
}

1;