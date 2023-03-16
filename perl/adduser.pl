sub adduser {
    my @messages;
    my $username = shift || return ("Usage: adduser <username>\n");;
    my $uid;
    my $gid;
    my $home = "/home/$username";
    my $shell = "/bin/bash";

    # Ensure running as root
    if ($EFFECTIVE_USER_ID != 0) {
        push @messages, "You must run this script as root.\n";
        return @messages;
    }

    # Check if the user already exists
    open(my $passwd_fh, '<', '/etc/passwd') or die "Unable to open /etc/passwd: $!";
    while (my $line = <$passwd_fh>) {
        my ($user) = split(':', $line);
        if ($user eq $username) {
            push @messages, "User '$username' already exists.\n";
            return @messages;
        }
    }
    close($passwd_fh);

    # Find the next available UID and GID
    open($passwd_fh, '<', '/etc/passwd') or die "Unable to open /etc/passwd: $!";
    my @uids = map { (split(':', $_))[2] } <$passwd_fh>;
    close($passwd_fh);

    open(my $group_fh, '<', '/etc/group') or die "Unable to open /etc/group: $!";
    my @gids = map { (split(':', $_))[2] } <$group_fh>;
    close($group_fh);

    $uid = $gid = (sort { $b <=> $a } (@uids, @gids))[0] + 1;

    # Create the user's home directory
    mkdir $home, 0755 or push @messages, "Unable to create home directory $home: $!";
    chown $uid, $gid, $home;

    # Add the new user to /etc/passwd
    open($passwd_fh, '>>', '/etc/passwd') or push @messages, "Unable to open /etc/passwd: $!";
    print $passwd_fh "$username:x:$uid:$gid:$username:$home:$shell\n";
    close($passwd_fh);

    # Add the new user to /etc/shadow with a disabled password
    open(my $shadow_fh, '>>', '/etc/shadow') or push @messages, "Unable to open /etc/shadow: $!";
    print $shadow_fh "$username:*:0:0:99999:7:::\n";
    close($shadow_fh);

    # Add the new group to /etc/group
    open($group_fh, '>>', '/etc/group') or push @messages, "Unable to open /etc/group: $!";
    print $group_fh "$username:x:$gid:\n";
    close($group_fh);

    # Add the new group to /etc/gshadow
    open(my $gshadow_fh, '>>', '/etc/gshadow') or push @messages, "Unable to open /etc/gshadow: $!";
    print $gshadow_fh "$username:x::\n";
    close($gshadow_fh);

    push @messages, "User '$username' created with UID $uid and GID $gid.\n";
    return \@messages;
}

1;