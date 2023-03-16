sub ps {
    my @processes;

    # Loop over the directories in /proc to find running processes
    opendir(my $dh, '/proc') or die "Could not open /proc directory: $!";
    while (my $dir = readdir($dh)) {
        # Check if the directory name is a process ID
        if ($dir =~ /^\d+$/) {
            # Open the process's status file to read its name and status
            open(my $fh, '<', "/proc/$dir/status") or next;
            my ($name, $status);
            while (my $line = <$fh>) {
                if ($line =~ /^Name:\s+(.+)$/) {
                    $name = $1;
                }
                elsif ($line =~ /^State:\s+(.+)$/) {
                    $status = $1;
                }
            }
            close($fh);

            # Add the process name and status to the list of processes
            push @processes, { pid => $dir, name => $name, status => $status };
        }
    }
    closedir($dh);

    return \@processes;   # return a reference to the list of processes
}

1;