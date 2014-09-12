#!/usr/bin/perl -w
my $debug = 0;
#
# ical2rem.pl - 
# Reads iCal files and outputs remind-compatible files.   Tested ONLY with
#   calendar files created by Mozilla Calendar/Sunbird. Use at your own risk.
# Copyright (c) 2005, 2007, Justin B. Alcorn

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
#
# version 0.5.2 2007-03-23
# 	- BUG: leadtime for recurring events had a max of 4 instead of DEFAULT_LEAD_TIME
#	- remove project-lead-time, since Category was a non-standard attribute
#	- NOTE: There is a bug in iCal::Parser v1.14 that causes multiple calendars to
#		fail if a calendar with recurring events is followed by a calendar with no
#		recurring events.  This has been reported to the iCal::Parser author.
# version 0.5.1 2007-03-21
#	- BUG: Handle multiple calendars on STDIN
#	- add --heading option for priority on section headers
# version 0.5 2007-03-21
#	- Add more help options
#	- --project-lead-time option
#	- Supress printing of heading if there are no todos to print
# version 0.4
#	- Version 0.4 changes all written or inspired by, and thanks to Mark Stosberg
#	- Change to GetOptions
#	- Change to pipe
#	- Add --label, --help options
#	- Add Help Text
#	- Change to subroutines
#	- Efficiency and Cleanup
# version 0.3
#	- Convert to GPL (Thanks to Mark Stosberg)
#	- Add usage
# version 0.2
#	- add command line switches
#	- add debug code
#	- add SCHED _sfun keyword
#	- fix typos
# version 0.1 - ALPHA CODE.  

=head1 SYNOPSIS

 cat /path/to/file*.ics | ical2rem.pl > ~/.ical2rem

 All options have reasonable defaults:
 --label		       Calendar name (Default: Calendar)
 --lead-time	       Advance days to start reminders (Default: 3)
 --todos, --no-todos   Process Todos? (Default: Yes)
 --heading			   Define a priority for static entries
 --help				   Usage
 --man				   Complete man page

Expects an ICAL stream on STDIN. Converts it to the format
used by the C<remind> script and prints it to STDOUT. 

=head2 --label

  ical2rem.pl --label "Bob's Calendar"

The syntax generated includes a label for the calendar parsed.
By default this is "Calendar". You can customize this with 
the "--label" option.

=head2 --lead-time 

  ical2rem.pl --lead-time 3
 
How may days in advance to start getting reminders about the events. Defaults to 3. 

=head2 --no-todos

  ical2rem.pl --no-todos

If you don't care about the ToDos the calendar, this will surpress
printing of the ToDo heading, as well as skipping ToDo processing. 

=head2 --heading

  ical2rem.pl --heading "PRIORITY 9999"

Set an option on static messages output.  Using priorities can made the static messages look different from
the calendar entries.  See the file defs.rem from the remind distribution for more information.

=cut 

use strict;
use iCal::Parser;
use DateTime;
use Getopt::Long 2.24 qw':config auto_help';
use Pod::Usage;
use Data::Dumper;
use vars '$VERSION';
$VERSION = "0.5.2";

# Declare how many days in advance to remind
my $DEFAULT_LEAD_TIME = 3;
my $PROCESS_TODOS     = 1;
my $HEADING			  = "";
my $help;
my $man;

my $label = 'Calendar';
GetOptions (
	"label=s"     => \$label,
	"lead-time=i" => \$DEFAULT_LEAD_TIME,
	"todos!"	  => \$PROCESS_TODOS,
	"heading=s"	  => \$HEADING,
	"help|?" 	  => \$help, 
	"man" 	 	  => \$man
);
pod2usage(1) if $help;
pod2usage(-verbose => 2) if $man;

my $month = ['None','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

my @calendars;
my $in;

while (<>) {
	$in .= $_;
	if (/END:VCALENDAR/) {
		push(@calendars,$in);
		$in = "";
	}
}
print STDERR "Read all calendars\n" if $debug;
my $startdate = DateTime->new( year   => 2010,
                       month  => 4,
                       day    => 1,
                       time_zone => 'US/Eastern',
                     );
my $oneyear = DateTime::Duration->new( years   => 1);
my $oneweek = DateTime::Duration->new( weeks   => -1);
$startdate = DateTime->now + $oneweek;
my $enddate = DateTime->now + $oneyear;
print STDERR "About to parse calendars\n" if $debug;
my $parser = iCal::Parser->new('start' => $startdate,
							'debug' => 0,
								'end' => $enddate);
my $hash = $parser->parse_strings(@calendars);
print STDERR "Calendars parsed\n" if $debug;

##############################################################
#
# Subroutines 
#
#############################################################
#
# _process_todos()
# expects 'todos' hashref from iCal::Parser is input
# returns String to output
sub _process_todos {
	my $todos = shift; 
	
	my ($todo, @newtodos, $leadtime);
	my $output = "";

	$output .=  'REM '.$HEADING.' MSG '.$label.' ToDos:%"%"%'."\n";

# For sorting, make sure everything's got something
#   To sort on.  
	my $now = DateTime->now;
	for $todo (@{$todos}) {
		# remove completed items
		if ($todo->{'STATUS'} && $todo->{'STATUS'} eq 'COMPLETED') {
			next;
		} elsif ($todo->{'DUE'}) {
			# All we need is a due date, everything else is sugar
			$todo->{'SORT'} = $todo->{'DUE'}->clone;
		} elsif ($todo->{'DTSTART'}) {
			# for sorting, sort on start date if there's no due date
			$todo->{'SORT'} = $todo->{'DTSTART'}->clone;
		} else {
			# if there's no due or start date, just make it now.
			$todo->{'SORT'} = $now;
		}
		push(@newtodos,$todo);
	}
	if (! (scalar @newtodos)) {
		return "";
	}
# Now sort on the new Due dates and print them out.  
	for $todo (sort { DateTime->compare($a->{'SORT'}, $b->{'SORT'}) } @newtodos) {
		my $due = $todo->{'SORT'}->clone();
		my $priority = "";
		if (defined($todo->{'PRIORITY'})) {
			if ($todo->{'PRIORITY'} == 1) {
				$priority = "PRIORITY 1000";
			} elsif ($todo->{'PRIORITY'} == 3) {
				$priority = "PRIORITY 7500";
			}
		}
		if (defined($todo->{'DTSTART'}) && defined($todo->{'DUE'})) {
			# Lead time is duration of task + lead time
			my $diff = ($todo->{'DUE'}->delta_days($todo->{'DTSTART'})->days())+$DEFAULT_LEAD_TIME;
			$leadtime = "+".$diff;
		} else {
			$leadtime = "+".$DEFAULT_LEAD_TIME;
		}
		$output .=  "REM ".$due->month_abbr." ".$due->day." ".$due->year." $leadtime $priority MSG \%a $todo->{'SUMMARY'}\%\"\%\"\%\n";
	}
	$output .= 'REM '.$HEADING.' MSG %"%"%'."\n";
	return $output;
}


#######################################################################
#
#  Main Program
#
######################################################################

print _process_todos($hash->{'todos'}) if $PROCESS_TODOS;

my ($leadtime, $yearkey, $monkey, $daykey,$uid,%eventsbyuid);
print 'REM '.$HEADING.' MSG '.$label.' Events:%"%"%'."\n";
my $events = $hash->{'events'};
foreach $yearkey (sort keys %{$events} ) {
    my $yearevents = $events->{$yearkey};
    foreach $monkey (sort {$a <=> $b} keys %{$yearevents}){
        my $monevents = $yearevents->{$monkey};
        foreach $daykey (sort {$a <=> $b} keys %{$monevents} ) {
            my $dayevents = $monevents->{$daykey};
            foreach $uid (sort {
                            DateTime->compare($dayevents->{$a}->{'DTSTART'}, $dayevents->{$b}->{'DTSTART'})    
                            } keys %{$dayevents}) {
                my $event = $dayevents->{$uid};
               if ($eventsbyuid{$uid}) {
                    my $curreventday = $event->{'DTSTART'}->clone;
                    $curreventday->truncate( to => 'day' );
                    $eventsbyuid{$uid}{$curreventday->epoch()} =1;
                    for (my $i = 0;$i < $DEFAULT_LEAD_TIME && !defined($event->{'LEADTIME'});$i++) {
                        if ($eventsbyuid{$uid}{$curreventday->subtract( days => $i+1 )->epoch() }) {
                            $event->{'LEADTIME'} = $i;
                        }
                    }
                } else {
                    $eventsbyuid{$uid} = $event;
                    my $curreventday = $event->{'DTSTART'}->clone;
                    $curreventday->truncate( to => 'day' );
                    $eventsbyuid{$uid}{$curreventday->epoch()} =1;
                }

            }
        }
    }
}
foreach $yearkey (sort keys %{$events} ) {
    my $yearevents = $events->{$yearkey};
    foreach $monkey (sort {$a <=> $b} keys %{$yearevents}){
        my $monevents = $yearevents->{$monkey};
        foreach $daykey (sort {$a <=> $b} keys %{$monevents} ) {
            my $dayevents = $monevents->{$daykey};
            foreach $uid (sort {
                            DateTime->compare($dayevents->{$a}->{'DTSTART'}, $dayevents->{$b}->{'DTSTART'})
                            } keys %{$dayevents}) {
                my $event = $dayevents->{$uid};
                if (exists($event->{'LEADTIME'})) {
                    $leadtime = "+".$event->{'LEADTIME'};
                } else {
                    $leadtime = "+".$DEFAULT_LEAD_TIME;
                }
                my $start = $event->{'DTSTART'};
                print "REM ".$start->month_abbr." ".$start->day." ".$start->year." $leadtime ";
                if ($start->hour > 0) { 
                    print " AT ";
                    print $start->strftime("%H:%M");
                    print " SCHED _sfun MSG %a %2 ";
                } else {
                    print " MSG %a ";
                }
                print "%\"$event->{'SUMMARY'}";
                print " at $event->{'LOCATION'}" if $event->{'LOCATION'};
                print "\%\"%\n";
            }
        }
    }
}
exit 0;
#:vim set ft=perl ts=4 sts=4 expandtab :
