sub my_kill {
    my $pid = shift;
    my $signal = shift || "TERM";

    kill int($signal), $pid;
}

1;