sub add_user_to_group {
    my ($username, $groupname) = @_;
    my $group_file = '/etc/group';
    my @messages;

    # Check if the group exists
    my $group_exists = 0;
    open(my $fh, '<', $group_file) or push @messages, "Cannot open file $group_file: $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($name, undef, $gid, $members) = split(/:/, $line);
        if ($name eq $groupname) {
            $group_exists = 1;
            last;
        }
    }
    close($fh);
    push @messages, "Group '$groupname' does not exist." unless $group_exists;

    # Check if the user exists
    my $user_exists = 0;
    open($fh, '<', '/etc/passwd') or push @messages, "Cannot open file /etc/passwd: $!";
    while (my $line = <$fh>) {
        chomp $line;
        my ($name, undef, $uid, $gid) = split(/:/, $line);
        if ($name eq $username) {
            $user_exists = 1;
            last;
        }
    }
    close($fh);
    push @messages, "User '$username' does not exist." unless $user_exists;

    # Check if the user is already in the group
    my $user_in_group = 0;
    open($fh, '<', $group_file) or push @messages, "Cannot open file $group_file: $!";
    my @lines;
    while (my $line = <$fh>) {
        chomp $line;
        my ($name, undef, undef, $members) = split(/:/, $line);
        if ($name eq $groupname) {
            my @group_members = split(/,/, $members);
            foreach my $member (@group_members) {
                if ($member eq $username) {
                    $user_in_group = 1;
                    last;
                }
            }
            $members .= ",$username";
            $line =~ s/$members/$members/;
        }
        push @lines, "$line\n";
    }
    close($fh);
    if ($user_in_group) {
        push @messages, "User '$username' is already a member of group '$groupname'.";
        return @messages;
    }

    # Add the user to the group
    open($fh, '>', $group_file) or push @messages, "Cannot open file $group_file: $!";
    print $fh join("", @lines);
    close($fh);

    push @messages, "User '$username' added to group '$groupname'.";
    return \@messages;
}

1;
