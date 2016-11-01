#!/usr/bin/perl 
# * Last changed by John R. Pastori on 02/25/2013 using ColdFusion Studio. *
# ------------------------------------------------------------
# Based on Form-mail.pl, by Reuven M. Lerner (reuven@the-tech.mit.edu).
#
# Last updated: October 15, 2007
#
# Form-mail provides a mechanism by which users of a World-
# Wide Web browser may submit comments to the webmasters
# (or anyone else) at a site.  It should be compatible with
# any CGI-compatible HTTP server.
# 
# ------------------------------------------------------------

require 'htmltemplate.pl';
&GetTemplate("lfolks.sdsu.edu", 80, "/forms/cgitmplt.shtml");

# ------------------------------------------------------------
# REVISED FOR LIBRARY ONLINE FACULTY/STAFF ABSENCE REQUESTS
# By Stephen Treger (stephen@techie.com)
# Updated June 3, 1999
#
# Last changed July 23, 2001 by Brian Lenz
#	Second Carbon copy field added.
#
# This perl script takes input from a HTML form duplicating the
# SDSU Library's Absence Request Form and routes electronic copies
# to the Requester and the Supervisor via email.
# If the Request is approved, it can be forwarded to the person 
# doing Library payroll (Joan Shelby) by the Supervisor.
#
# Variables accepted:
# Date = date	Supervisor's email = supervisor
# Cc2 =Carbon Copy	
# CustomerName = CustomerName	Users' email = email
# Dates, Hours and Time Requested = field1, field2, field3, field4
# Vacation = vacation	Jury = jury		Other = Other
# Sick Self = SickSelf	  Sick Family = SickFamily	Sick Death = SickDeath
# Relationship = relate	 Personal Holiday = PersonalHoliday 	Military leave = Military
# Comp Time = CompTime	LWOP = LWOP
# Reason for time off = reason
# ------------------------------------------------------------
# This causes error messages to display with 
# standard output, as soon as they occur.
open(STDERR,'>&STDOUT'); 
$| = 1;


&TemplateTop;

# Print out a content-type for HTTP/1.0 compatibility
#  print ("\n");
#  print ("\n");


# Blank out variables
	$FORM{'CREATIONDATE'}="";
	$FORM{'CUSTOMERNAME'}="";
	$FORM{'EMAIL'}="";
	$FORM{'SUPERVISOR'}="";
	$FORM{'Cc2'}="";
	$FORM{'CARBON'}="";
	$FORM{'DATES1'}="";
	$FORM{'DATES2'}= "";
	$FORM{'DATES3'}="";
	$FORM{'DATES4'}="";
	$FORM{'HOURS1'}="";
	$FORM{'HOURS2'}="";
	$FORM{'HOURS3'}="";
	$FORM{'HOURS4'}="";
	$FORM{'DAYS1'}="";
	$FORM{'DAYS2'}="";
	$FORM{'DAYS3'}="";
	$FORM{'DAYS4'}="";
	$FORM{'VACATION'}="";
	$FORM{'JURY'}="";
	$FORM{'SICKSELF'}="";
	$FORM{'SICKFAMILY'}="";
	$FORM{'SICKDEATH'}="";
	$FORM{'FUNERAL'}="";
	$FORM{'PERSONALHOLIDAY'}="";
	$FORM{'MILITARY'}="";
	$FORM{'COMPTIME'}="";
	$FORM{'LWOP'}="";
	$FORM{'OTHER'}="";
	$FORM{'RELATIONSHIP'}="";
	$FORM{'REASON'}="";


# ------------------------------------------------------------

# Define fairly-constants

# This should be set to the username or alias that runs your
# WWW server.
# $recipient = 'webhttp@libint.sdsu.edu';

# Get the input
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});

# Split the name-value pairs
@pairs = split(/&/, $buffer);

foreach $pair (@pairs)
{
    ($name, $value) = split(/=/, $pair);

    # Un-Webify plus signs and %-encoding
    $value =~ tr/+/ /;
    $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

    # Stop people from using subshells to execute commands
    # Not a big deal when using sendmail, but very important
    # when using UCB mail (aka mailx).
    # $value =~ s/~!/ ~!/g; 

    # Uncomment for debugging purposes
    # print "Setting $name to $value<P>";

    $FORM{$name} = $value;
}

     $recipient = $FORM{'Supervisor'};
     
     $Cc2 = $FORM{'Cc2'};

# If the comments are blank, then give a "blank form" response
# &blank_response unless $FORM{'comments'};

# IF lwop has a value then include the cc: header
# Removed
#if (!$FORM{LWOP} eq "") {
#	$CC = "Cc: jboyer\@mail.sdsu.edu";
# }

# IF 'Carbon' has a value then include the cc: header
if (!$FORM{Carbon} eq "") {
	$Cc = "Cc: jshelby\@mail.sdsu.edu, $FORM{'Email'}";
}
else {
	$Cc = "Cc: jshelby\@mail.sdsu.edu";
 }
# This should match the mail program on your system.
# Sets from to requesters name
   $mailprog = "/usr/lib/sendmail -n -t -F \"$FORM{'CustomerName'}\" ";
# Email header information is here
#
   print "<B>";
   print "To: $recipient <BR>\n";
   print "Reply-to: $FORM{'Email'} ($FORM{'CustomerName'})<BR>";
if (!$Cc2 eq "\@mail.sdsu.edu") {
	print "$Cc,$FORM{'Cc2'} <BR>\n";
}
else {
	print "$Cc <BR> \n";
}
   print "<BR>\n";
   print "Subject: ONLINE Library Absence Request For $FORM{'CustomerName'}</B><P>";

   
# Print a title and initial heading
   print "<Head><Title>Your Online Absence Request Form Has Been Processed</Title></Head>";
   print "<Body background='/images/back40.gif'>";
   print "Here is your receipt<p>";


# create a loop to cycle through and write out to various devices
@PROGRAMS = ("MAIL","STDOUT");

foreach $EXT (@PROGRAMS) {

# Now send mail to $recipient , we are using mail and including type text/html
# Loop through and send to Mail, stdout, file
#

	if ($EXT eq "MAIL") {
	
		if ($Cc2 eq "\@mail.sdsu.edu") {
			$FORM{'Cc2'} = '';
			open ($EXT, "|$mailprog \" $recipient, $Cc \"") || die "Can't open $mailprog!\n";
		} else {
			open ($EXT, "|$mailprog \" $recipient, $Cc, $Cc2 \"") || die "Can't open $mailprog!\n";
		}
		print $EXT "Reply-to: $FORM{'Email'} \n";
		print $EXT "MIME-Version: 1.0\n";
		print $EXT "Content-Type: text/html\n";
		print $EXT "Subject: ONLINE Library Absence Request For $FORM{'CustomerName'}\n";
		print $EXT "\n";
		print $EXT "<HTML>\n";
		print $EXT "<H5>On $FORM{'Date'}, $FORM{'CustomerName'} submitted the following Absence Request </H5>\n"; 
		print $EXT "\n";
	}
#
# Email Message Body is here
	print $EXT "<PRE><center><h1>Online Absence Request Receipt</h1></center>\n\n";
	print $EXT "<b>Date Submitted:</b>      $FORM{'Date'}<BR>\n";

	print $EXT "<b>Name:</b>                $FORM{'CustomerName'}<BR>\n";

	print $EXT "<b>Email Address:</b>       $FORM{'Email'}<br>\n";

	print $EXT "<b>Supervisor's Email:</b>  $FORM{'Supervisor'}<br>\n";	

	print $EXT "<b>Cc:</b>  jshelby\@mail.sdsu.edu,$FORM{'Cc2'} \n";
	print $EXT "</PRE>\n";
	print $EXT "<BR><BR>";
	print $EXT "<TABLE BORDER='1' BORDERCOLOR='0000FF'>";
	print $EXT "<TR>";
	print $EXT "<TD COLSPAN='2'><b>Date(s) Requested</b></TD><TD COLSPAN='2'><b># Of Hours</b> </TD><TD COLSPAN='2'><b>From - To</TD>";
	print $EXT "</TR>";
	print $EXT "<TR>";
	print $EXT "<TD COLSPAN='2'>$FORM{'Dates1'}</TD><TD COLSPAN='2' ALIGN='CENTER'>$FORM{'Hours1'}</TD>           <TD COLSPAN='2'>$FORM{Days1}</TD>";
	print $EXT "</TR>";
	if ($FORM{Dates2} ne "") {
		print $EXT "<TR>";
		print $EXT "<TD COLSPAN='2'>$FORM{'Dates2'}</TD><TD COLSPAN='2' ALIGN='CENTER'>$FORM{'Hours2'}</TD> 
			      <TD COLSPAN='2'>$FORM{'Days2'}</TD>";
		print $EXT "</TR>";
	}
	if ($FORM{Dates3} ne "") {
		print $EXT "<TR>";
		print $EXT "<TD COLSPAN='2'>$FORM{'Dates3'}</TD><TD COLSPAN='2' ALIGN='CENTER'>$FORM{'Hours3'}</TD>  
			      <TD COLSPAN='2'>$FORM{'Days3'}</TD>";
		print $EXT "</TR>";
	}
	if ($FORM{Dates4} ne "") {
		print $EXT "<TR>";
		print $EXT "<TD COLSPAN='2'>$FORM{'Dates4'}</TD><TD COLSPAN='2' ALIGN='CENTER'>$FORM{'Hours4'}</TD>  
			      <TD COLSPAN='2'>$FORM{'Days4'}</TD>";
		print $EXT "</TR>";
	}
	print $EXT "</TABLE><BR><BR>";
# second table for hours use

	print $EXT "<PRE><b>REQUEST USE OF: (fill in # hours)</b><br>";

	if (!$FORM{Vacation} eq "") {
		print $EXT "<b>Vacation</b>               $FORM{'Vacation'}<br>\n";
 	};

	if (!$FORM{Jury} eq "") {
		print $EXT "<b>Jury Duty</b>              $FORM{'Jury'}<br>\n";
 	};

	if (!$FORM{SickSelf} eq "") {
		print $EXT "<b>Sick Leave Self</b>        $FORM{'SickSelf'} <br>\n";
 	};

	if (!$FORM{SickFamily} eq "") {
		print $EXT "<b>Sick Leave Family*</b>     $FORM{'SickFamily'}<br>\n";
 	};

	if (!$FORM{SickDeath} eq "") {
		print $EXT "<b>Sick Leave Death*</b>      $FORM{'SickDeath'} <br>\n";
 	};

	if (!$FORM{Funeral} eq "") {
		print $EXT "<b>Funeral Leave*</b>         $FORM{'Funeral'}<br>\n";
	 };

	if (!$FORM{PersonalHoliday} eq "") {
		print $EXT "<b>Personal Holiday</b>       $FORM{'PersonalHoliday'} <br>\n";
	 };

	if (!$FORM{Military} eq "") {
		print $EXT "<b>Military Leave</b>         $FORM{'Military'}<br>\n";
	 };

	if (!$FORM{CompTime} eq "") {
		print $EXT "<b>Compensatory Time Off</b>  $FORM{'CompTime'} <br>\n";
 	};

	if (!$FORM{LWOP} eq "") {
		print $EXT "<b>LWOP</b>                   $FORM{'LWOP'}<br>\n";
 	};

	if (!$FORM{Other} eq "") {
		print $EXT "<b>Other</b>                  $FORM{'Other'}<br>\n";
 	};

	print $EXT "*Give Relationship <br>";
	print $EXT "      $FORM{'Relate'} <br>\n";

	print $EXT "<p><b>REASON FOR ABSENCE (Sick Leave / LWOP )</b>\n";
	print $EXT "<br>$FORM{'Reason'}</P></PRE>\n";

	print $EXT "<HR>";
	print $EXT "<P>This electronic request has been submitted to your "; 
	print $EXT "Supervisor via email.</P>\n";

	print $EXT "<p>Supervisors are to forward their approval/denial of all requests for ";
	print $EXT "<B>vacation, personal holiday, CTO, or any other use of accruals ";
	print $EXT "requiring scheduling</B> to their division head/manager and the employee.</p>\n";

	print $EXT "<p><B>All approved requests for LWOP (Leave Without Pay)</b> need to be copied ";
	print $EXT "to Library Payroll (Joan Shelby) in order to avoid having a hold placed on your ";
	print $EXT "paycheck. </p>\n";

	print $EXT "<p>Please direct all questions about this form or any payroll issue to ";
	print $EXT "Joan Shelby (x41642 or <a href=\"mailto:jshelby\@mail.sdsu.edu\">jshelby\@mail.sdsu.edu</A>).</P>\n";


print $EXT "<P>Information regarding vacations and leaves can be found at ";
print $EXT "<A HREF=\"http://www.calstate.edu/LaborRel/Contracts_HTML/contracts.shtml\"> ";
print $EXT "Contract Information</A></P>\n";

# print $EXT "<!-- ";
# print $EXT "<P>Electronic forms provided by <A ";
# print $EXT "href=\"mailto:infosys\@library.sdsu.edu?subject=Electronic forms\">Library ";
# print $EXT "Information Systems and Technology.</A>";
# print $EXT " -->\n";

#	print $EXT "<br> ";

# 	print $EXT  "<hr>----D i a g n o s t i c  I n f o r m a t i o n -----<br>\n";
# 	print $EXT "CustomerName $FORM{'CustomerName'}\n<br>";
# 	print $EXT "Email    $FORM{'Email'}\n<br>";
#	print $EXT "Remote host: $ENV{'REMOTE_HOST'}\n<br>";
#	print $EXT "Remote IP address: $ENV{'REMOTE_ADDR'}\n<br>";
#	print $EXT "\n------------------------------------------------------\n<br>";

	if ($EXT eq 'MAIL')
	{ 
	  print $EXT "</body></html>"; 
	}else
	{
	  &TemplateBottom;
	}

	close ($EXT);
# close the for each loop
	}

# Here is the rest of the HTML generated page
#
# Make the person feel good for writing to us
# print "Thank you for moving <I>paperless</I>. You may save or print this copy for yourself using your browser's PRINT function.";
# print "<BR>An identical copy of the form being emailed is below<HR>";



#
# Generate a log file
open(LOG,'>>/home/www/lfolks/htdocs/forms/absencedata.txt'); 
# (log preserved)

#  while (<LOG> {
print LOG "\"$FORM{'Date'}\",\"$FORM{'CustomerName'}\",\"$FORM{'Email'}\",";
print LOG "\"$FORM{'Supervisor'}\",";
print LOG "\"$FORM{'Dates1'}\",\"$FORM{'Hours1'}\",\"$FORM{'Days1'}\",";
print LOG "\"$FORM{'Dates2'}\",\"$FORM{'Hours2'}\",\"$FORM{'Days2'}\",";
print LOG "\"$FORM{'Dates3'}\",\"$FORM{'Hours3'}\",\"$FORM{'Days3'}\",";
print LOG "\"$FORM{'Dates4'}\",\"$FORM{'Hours4'}\",\"$FORM{'Days4'}\",";
print LOG "\"$FORM{'Vacation'}\",\"$FORM{'Jury'}\",\"$FORM{'SickSelf'}\",";
print LOG "\"$FORM{'SickFamily'}\",\"$FORM{'SickDeath'}\",\"$FORM{'Funeral'}\",\"$FORM{'PersonalHoliday'}\",";
print LOG "\"$FORM{'Military'}\",\"$FORM{'CompTime'}\",\"$FORM{'LWOP'}\",\"$FORM{'Other'}\",";
print LOG "\"$FORM{'Relate'}\",\"$FORM{'Reason'}\"\n";
# }
close (LOG);
# ------------------------------------------------------------
# subroutine blank_response
sub blank_response
{
    print "Your comments appear to be blank, and thus were not sent ";
    print "to our webmasters.  Please re-enter your comments, or ";
    print "return to our <A HREF=\"/\">home page</A>, if you want.<P>";
    exit;
}

