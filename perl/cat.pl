sub cat {
    my ($filename) = @_;
    my @messages;
    open(my $fh, '<', $filename) or push @messages, "Cannot open file $filename: $!";
    push @messages, $_ while <$fh>;
    close($fh);
    return \@messages;
}

1;