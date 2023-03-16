#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;
use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;
use JSON;

my $port = 5555;
my $json = JSON->new;

# Create a new HTTP::Daemon object to listen for HTTP requests
my $server = HTTP::Daemon->new(
    LocalPort => $port,
    ReuseAddr => 1,
) or die "Error creating server: $!\n";

print "Server listening on port $port\n";

while (1) {
    # Accept a new client connection
    my $client = $server->accept() or die "Error accepting client: $!\n";

    while (my $request = $client->get_request) {
        if ($request->method eq 'POST') {
            # Read data from the POST request
            my $data = $request->content;

            # Echo back the received data as JSON
            if ($data) {
                my $response = { request => $data };
                my $encoded_response = $json->encode($response);

                my $http_response = HTTP::Response->new(RC_OK);
                $http_response->header('Content-Type' => 'application/json');
                $http_response->content($encoded_response);

                $client->send_response($http_response);
                print "Sent response: $encoded_response\n";
            } else {
                $client->send_error(RC_BAD_REQUEST);
            }
        } else {
            $client->send_error(RC_METHOD_NOT_ALLOWED);
        }
    }

    # Close the client connection
    $client->close();
}

# Close the server socket
$server->close();

