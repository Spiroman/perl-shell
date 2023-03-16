#!/usr/bin/perl

use Term::ReadLine;
require './ls.pl';
require './wc.pl';

# Initialize the ReadLine module
my $term = Term::ReadLine->new('Shell');

# Enable command history
$term->MinLine(0);
$term->stifle_history(100);
$term->ornaments(0);

# Greeting message
print("Enter a command, or type exit to exit\n");
# Loop indefinitely to read user input
while (1) {

  # Prompt the user for input
  my $input = $term->readline('> ');

  if ($input eq '') {
    next;
  }
  # Add the input to the command history
  $term->add_history($input);
  
  my ($command, @args) = split(/\s+/, $input);
  # If the input starts with 'ls', execute the ls.pl script
  if ($command =~ /^ls/) {
    my $output = ls(@args);
    print $output;
  }
  elsif ($command =~ /^wc/) {
    my $output = wc(@args);
    print $output;
  }
  elsif ($command eq 'exit') {
    last;
  }

  # If the input is not recognized, print an error message
  else {
    print "Unknown command: $command\n";
  }
}
