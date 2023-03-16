#!/usr/bin/perl

use Term::ReadLine;
use File::HomeDir;
require './ls.pl';
require './wc.pl';
require './cp.pl';
require './mv.pl';
require './rm.pl';

# Initialize modules
my $term = Term::ReadLine->new('Shell');

# Enable command history
$term->MinLine(0);
$term->stifle_history(100);
$term->ornaments(0);

# Greeting message
print("Enter a command, to exit: type q or exit\n");
# Loop indefinitely to read user input
while (1) {

  # Prompt the user for input
  my $input = $term->readline('> ');

  if ($input eq '') {
    next;
  }
  # Add the input to the command history
  $term->add_history($input);
  
  # Get the command and its arguments
  my ($command, @args) = split(/\s+/, $input);

  # Expand all tildas
  foreach my $element (@args) {
    if ($element =~ /^~/) {
        my $home_dir = File::HomeDir->my_home;
        $element =~ s/^~/$home_dir/;
    }
  }
  # If the input starts with 'ls', execute the ls.pl script
  if ($command =~ /^ls/) {
    my $output = ls(@args);
    print $output;
  }
  elsif ($command =~ /^wc/) {
    my $output = wc(@args);
    print $output;
  }
  elsif ($command =~ /^cp/) {
    my $output = cp(@args);
    print $output;
  }
  elsif ($command =~ /^mv/) {
    my $output = mv(@args);
    print $output;
  }
  elsif ($command =~ /^rm/) {
    my $output = rm(@args);
    print $output;
  }
  elsif ($command eq 'exit' or $command eq 'q') {
    last;
  }

  # If the input is not recognized, print an error message
  else {
    print "Unknown command: $command\n";
  }
}
