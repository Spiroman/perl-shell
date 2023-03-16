sub ls {
    # Get the list of path arguments
    my @paths = @_;

    # Set the default path to the current directory if no arguments are provided
    if (@paths == 0) {
    push(@paths, ".");
    }

    # Loop over each path argument
    my $output = "";
    foreach my $path (@paths) {
        # Expand the tilde character to the user's home directory, if present
        if ($path =~ /^~/) {
            $path =~ s/^~/$ENV{HOME}/;
        }

        # Open the directory and read the files
        opendir(my $dh, $path) or die "Could not open directory $path: $!";
        my @files = readdir($dh);
        closedir($dh);

        # Format the file names and add them to the output
        my $formatted = "";
        foreach my $file (sort @files) {
            next if ($file =~ /^\./);   # Skip hidden files
            $formatted .= "$file\n";
        }

        # Add the formatted output to the overall output
        $output .= $formatted;
    }

    # Return the output
    return $output;
}

1;