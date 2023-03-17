sub add_user_to_group {
    my ($username, $groupname) = @_;

    # Open the group file and read the lines
    my $group_file = "/etc/group";
    open(my $group_handle, '<', $group_file) or die "Failed to open group file: $!";
    my @group_lines = <$group_handle>;
    close($group_handle);

    # Find the line for the group
    my ($group_line) = grep { /^$groupname:/ } @group_lines;
    unless ($group_line) {
        return "$groupname group not found";
    }

    # Extract the group ID and members
    my ($name, $passwd, $gid, $members) = split(':', $group_line);
    my @current_members = split(',', $members);

    # Check if the user is already a member of the group
    if (grep { $_ eq $username } @current_members) {
        return "$username is already a member of group $groupname";
    }

    # Append the username to the members list
    push @current_members, $username;

    # Write the updated group line to a temporary file
    my $temp_file = "$group_file.temp";
    open(my $temp_handle, '>', $temp_file) or die "Failed to create temp file: $!";
    foreach my $line (@group_lines) {
        if ($line =~ /^$groupname:/) {
            print $temp_handle "$name:$passwd:$gid:" . join(',', @current_members) . "\n";
        } else {
            print $temp_handle $line;
        }
    }
    close($temp_handle);

    # Replace the original group file with the temporary file
    rename($temp_file, $group_file) or die "Failed to rename temp file: $!";

    return "$username added to group $groupname";
}

1;