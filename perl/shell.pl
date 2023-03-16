#!/usr/bin/perl

use Term::ReadLine;
use File::HomeDir;
# Import basic commands
require './ls.pl';
require './wc.pl';
require './cp.pl';
require './mv.pl';
require './rm.pl';
require './cat.pl';
# Import admin commands
require './adduser.pl';
# Import system commands
require './kill.pl';
require './ps.pl';

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
  # All basic commands
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
  elsif ($command =~ /^cat/) {
    my $output = cat(@args);
    for my $line (@$output) {
      print $line;
    }
  }
  # All admin commands
  elsif ($command =~ /^adduser/) {
    my $output = adduser(@args);
    foreach my $message (@$output) {
      print "$message";
    }
  }
  # All system commands
  elsif ($command =~ /^ps/) {
    my $output = ps();
    foreach my $process (@$output) {
      print "$process->{pid}\t$process->{name}\t$process->{status}\n";
    }
  }
  elsif ($command =~ /^kill/) {
    # 9 is the signal number for SIGKILL
    my $output = my_kill(@args, 9);
    print $output;
  }
  # Exit the shell
  elsif ($command eq 'exit' or $command eq 'q') {
    last;
  }

  # If the input is not recognized, print an error message
  else {
    print "Unknown command: $command\n";
  }
}
