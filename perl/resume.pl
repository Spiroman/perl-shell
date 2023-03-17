sub resume {
    my ($pid) = @_;
    # Send a SIGCONT signal to the specified process ID
    my $result = kill('CONT', $pid);
    if ($result == 0) {
        print "Failed to resume process with PID $pid\n";
    } else {
        print "Process with PID $pid has been resumed\n";
    }
}

1;