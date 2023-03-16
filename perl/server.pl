#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;
use JSON;

my $port = 5555;
my $json = JSON->new;

# Create a new TCP socket and bind it to the specified port
my $server = IO::Socket::INET->new(
    LocalPort => $port,
    Proto     => 'tcp',
    Listen    => 5,
    ReuseAddr => 1
) or die "Error creating server: $!\n";

print "Server listening on port $port\n";

while (1) {
    # Accept a new client connection
    my $client = $server->accept() or die "Error accepting client: $!\n";
    my $client_address = $client->peerhost();
    my $client_port    = $client->peerport();
    # print "Accepted connection from $client_address:$client_port\n";

    # Read data from the client
    my $data = '';
    $client->recv($data, 1024);

    # Echo back the received data as JSON
    if ($data) {
        my $response = { request => $data };
        my $encoded_response = $json->encode($response);

        print $client $encoded_response;
        # print "Sent response: $encoded_response\n";
    }

    # Close the client connection
    $client->close();
}

# Close the server socket
$server->close();

