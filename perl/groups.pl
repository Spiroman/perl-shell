sub groups {
    my $group_file = '/etc/group';
    @messages;
    open(my $fh, '<', $group_file) or die "Cannot open file $group_file: $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($groupname, $passwd, $gid, $members) = split(/:/, $line);
        push @messages, "$groupname ($gid): $members\n";
    }
    close($fh);

    return \@messages;
}

1;