sub suspend {
    my ($pid) = @_;
    # Send a SIGSTOP signal to the specified process ID
    my $result = kill('STOP', $pid);
    if ($result == 0) {
        print "Failed to suspend process with PID $pid\n";
    } else {
        print "Process with PID $pid has been suspended\n";
    }
}

1;