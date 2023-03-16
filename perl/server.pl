#!/usr/bin/env perl

use strict;
use warnings;
use IO::Socket::INET;
use JSON;

# Create the main server
my $server_port = 5555;
my $server = IO::Socket::INET->new(
    LocalPort => $server_port,
    Type      => SOCK_STREAM,
    Reuse     => 1,
    Listen    => 10
) or die "Could not create server socket: $!";

while (my $client = $server->accept()) {
    my $input = <$client>;
    chomp $input;

    my $response = { request => $input };

    # Check if input starts with 'ls' or 'wc'
    if ($input =~ m/^(ls|wc)\b(.*)/) {
        my $command = $1;
        my $arguments = $2;

        # Execute the command and capture its output
        my $output = `$command $arguments 2>&1`;
        chomp $output;
        $response->{result} = $output;
    } else {
        $response->{error} = "Invalid command. Only 'ls' and 'wc' are allowed.";
    }

    print $client to_json($response), "\n";
    close $client;
}
