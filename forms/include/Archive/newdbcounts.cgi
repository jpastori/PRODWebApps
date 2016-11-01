#!/usr/bin/perl
#*****************************************************************************
#* Program and File Name	=	dbcounts								*
#* Author				=	John R. Pastori						*
#* Program Description	=	Scans Apache Log File and changes text.	*
#* Date Completed 		=	10/22/2002							*
#* Date Last Modified		=	xx/xx/xx								*
#* File Path Name		=	//sunwebdevel/opt/local/ezproxy/				*
#* Operating System		=	UNIX									*
#* Program Purpose		=	This program creates an MSACCESS importable	*
#*						text file from the selected Apache Log File. *
#*						The default is to select the previous month's*
#*						Log file.  The customer can include month and*
#*						year on the command line to select a specific*
#*						month's Log file.						*
#*****************************************************************************
MAIN: {
#*******************************************************************
# Start Variable Declarations here. 	
#*******************************************************************
	use File::Copy;
#*******************************************************************
# Start Processing Code here.
#*******************************************************************
# Process Command Line Arguements.
	$x = ''; 			#Unused time/date values.
	$y = '';			#Unused Ezproxy Log record fields.
	$month = $ARGV[0];
	$year = $ARGV[1];
	$TIME = '';
	%montharray = 
		('01' => 'Jan',
		 '02' => 'Feb',
		 '03' => 'Mar',
		 '04' => 'Apr',
		 '05' => 'May',
		 '06' => 'Jun',
		 '07' => 'Jul',
		 '08' => 'Aug',
		 '09' => 'Sep',
		 '10' => 'Oct',
		 '11' => 'Nov',
		 '12' => 'Dec');
	$monthname = '';
	
	$GZIP = "/usr/bin/gzip";
	$customerIP = '';
	$datetimestamp = '';
	$databaseurl = '';

	$url = '';
	$urlname = '';
	%dbcountdataarray = ();

	if ($year eq '') {
		($x, $x, $x, $x, $year)  = split(' ',localtime);
	}
	if ($month eq '') {
		use Time::localtime;
		$TIME = localtime;
		if ($TIME->mon == "0 " or $TIME->mon == "1 " or $TIME->mon == "2 " or $TIME->mon =="3 "
		  or $TIME->mon == "4 " or $TIME->mon == "5 " or $TIME->mon == "6 " or $TIME->mon =="7 "
		  or $TIME->mon == "8 " or $TIME->mon == "9 ") {
			$month = ($TIME->mon);
			$month = sprintf("%02d",$month);
			print "Month is 0 thru 9 = $month\n";
		}
		else {
			$month = ($TIME->mon);
			print "Month is 10 thru 11 = $month\n";
		}
		if ($month eq "00") {
			$month = "12";
			$year = $year - 1;
			 print "Month is 00 so it is changed to 12 = $month\n";
		}
	}
	$monthname = $montharray{$month};
	print ("\nProcessing data for Month (" . $monthname . ") = " . $month . " and Year = " . $year . "\n\n"); 
	chdir ("/share/ezproxy/") || die "Cannot access /share/ezproxy/ directory";
	print ("Reset /share/ezproxy/urlnames.txt file to size zero.\n"); 
	copy ("/dev/null", "/share/ezproxy/urlnames.txt");
	print ("The /share/ezproxy/urlnames.txt file is being created.\n\n");
	system("grep 'clover5fred\.gif' /home/www/dometest/htdocs/research/databases/databasestats.shtml > /share/ezproxy/urlnames.txt");

	open(URLFILE, "/share/ezproxy/urlnames.txt") || die "Cannot open /share/ezproxy/urlnames.txt\n";

	while (<URLFILE>) {
		$fileline = $_;
		($y, $url, $urlname) =  split (">", $fileline);
		$url = lc($url);
		$url =~ s/^\<a href\=\"http\:\/\/webgate\.sdsu\.edu\:88\/login\?url\=//g;
		$url =~ s/^\<a href\=\"//g;
		$url =~ s/"//g;
		$urlname =~ s/\<\/[aA]$//g;
		print ("URL = " . $url . " URL NAME = " . $urlname . "\n");
		$dbcountdataarray{$url} = [ $urlname, 0, 0, 0, 0 ];
	}
	close (URLFILE);

#	chdir ("/opt/local/ezproxy/$year") || die "Cannot access /opt/local/ezproxy/$year directory"; 
#	print ("The /opt/local/ezproxy/$year/" . $month . ".gz ezproxy log file is being copied to /share/ezproxy/ directory as ezproxy.log.gz. \n\n");
#	copy("/opt/local/ezproxy/$year/" . $month . ".gz", "/share/ezproxy/ezproxy.log.gz") 
#		|| die "Cannot copy /opt/local/ezproxy/$year/$month.gz\n";
#	copy("/opt/local/ezproxy/ezproxy.log", "/share/ezproxy/ezproxy.log");
#	print ("Remove old /share/ezproxy/ezproxy.log file.\n\n");
#	system("rm /share/ezproxy/ezproxy.log");
#	print ("UnGZipping ezproxy.log.gz as ezproxy.log.\n\n");
#	system("$GZIP -d  /share/ezproxy/ezproxy.log.gz");

	print ("\n\nReset /share/ezproxy/selecteddata.txt file to size zero.\n"); 
	copy ("/dev/null", "/share/ezproxy/selecteddata.txt");
	print ("The /share/ezproxy/selecteddata.txt file is being created.\n\n");
	system("grep 'GET http\:\/\/webgate\.sdsu\.edu\:2048\/login\?url\=' /share/ezproxy/ezproxy.log > /share/ezproxy/selecteddata.txt");
	system("grep 'GET http\:\/\/webgate\.sdsu\.edu\:88\/login\?url\=' /share/ezproxy/ezproxy.log >> /share/ezproxy/selecteddata.txt");
	system("grep 'GET http\:\/\/twig\.sdsu\.edu\:80\/w3launch\/' /share/ezproxy/ezproxy.log >> /share/ezproxy/selecteddata.txt");
	
	open(LOGFILE, "/share/ezproxy/selecteddata.txt") || die "Cannot open /share/ezproxy/selecteddata.txt\n";

	print "The dbcountdata array is being created.  Please wait...\n\n";

	while (<LOGFILE>) {
		$fileline = $_;
		chomp($fileline);
		if (grep (/$monthname/, $fileline)) {
			($customerIP, $y, $y, $datetimestamp, $y, $y, $databaseurl, $y, $y, $y) = split (" ", $fileline); 
			$datetimestamp =~ s/^\[//g;
			$databaseurl =~  s/^http\:\/\/webgate\.sdsu\.edu\:2048\/login\?url\=//g;
			$databaseurl =~  s/^http\:\/\/webgate\.sdsu\.edu\:88\/login\?url\=//g;
#			print ("CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
			if ($customerIP =~ m/^130.191.17.|^130.191.104|^130.191.105|^130.191.106|^130.191.108|^130.191.109/) {
				if (exists($dbcountdataarray{$databaseurl})) {
					$dbcountdataarray{$databaseurl}[1] += 1;
#					print ("***LIBARARY***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
				}
			}
			if ($customerIP =~ m/^130.191.137|^130.191.138|^146.244.137.*|^146.244.138/) {
				if (exists($dbcountdataarray{$databaseurl})) {
					$dbcountdataarray{$databaseurl}[2] += 1;
#					print ("***LABS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
				}
			}
			if ($customerIP =~ m/^130.191|^146.244/ && $customerIP !~ m/^130.191.17.|^130.191.104|^130.191.105|^130.191.106|^130.191.108|^130.191.109|^130.191.137|^130.191.138|^146.244.137|^146.244.138/) {
				if (exists($dbcountdataarray{$databaseurl})) {
					$dbcountdataarray{$databaseurl}[3] += 1;
#					print ("***ONCAMPUS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
				}
			}
			if ($customerIP !~ m/^130.191|^146.244/) {
				if (exists($dbcountdataarray{$databaseurl})) {
					$dbcountdataarray{$databaseurl}[4] += 1;
#					print ("***OFFCAMPUS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
				}
			}
		}
	}
	close (LOGFILE);

	foreach $url (sort(keys(%dbcountdataarray))) {
		print ("\n$url\t $dbcountdataarray{$url}[0]\t$dbcountdataarray{$url}[1]\t$dbcountdataarray{$url}[2]\t$dbcountdataarray{$url}[3]\t$dbcountdataarray{$url}[4]\n");
	}
# Write Database statistics to webpage on LFOLKS.
	open(STDOUT, ">/home/www/lfolks/htdocs/ist/dbstats.shtml") || die "Cannot open /home/www/lfolks/htdocs/ist/dbstats.shtml\n";
	$totalcount = 0;
	require 'htmltemplate.pl';
# Use GetTemplate subroutine from htmltemplate.pl to read in the server-side includes cgi program html output template.
	&GetTemplate("lfolks.sdsu.edu", 80, "/include/databasestatsheader.shtml");
#Use the TemplateTop subroutine from htmltemplate.pl to generate the server-side includes page header and navigation bar.
	&TemplateTop;
	print <<"ENDHTML1";
<div align="center"><h1>LIBRARY DATABASE HITS REPORT</h1></div>
<div align="right"><h2>PROCESS MONTH/YEAR: $monthname $year</h2></div>
<TABLE BORDER="3" WIDTH="100%" CELLPADDING="3" CELLSPACING="0">
<TR>
	<th><strong>Site Name</strong></th>
	<th><strong>Hits In Library</strong></th>
	<th><strong>Hits In Computing Labs</strong></th>
	<th><strong>Hits On Campus (Not In Library)</strong></th>
	<th><strong>Hits Off Campus</strong></th>
	<th><strong>DB Totals</strong></th>
</TR>
</TABLE>
<TABLE BORDER="0" WIDTH="100%" CELLPADDING="3" CELLSPACING="0">
<TR>
	<TD>
ENDHTML1

	foreach $url (sort(keys(%dbcountdataarray))) {
		print ($dbcountdataarray{$url}[0]);
		print ("</TD>");
		print ("<TD>");
		print ($dbcountdataarray{$url}[1]);
		print ("</TD>");
		print ("<TD>");
		print ($dbcountdataarray{$url}[2]);
		print ("</TD>");
		print ("<TD>");
		print ($dbcountdataarray{$url}[3]);
		print ("</TD>");
		print ("<TD>");
		print ($dbcountdataarray{$url}[4]);
		print ("</TD>");
		print ("<TD>");
		$totalcount = $dbcountdataarray{$url}[1] + $dbcountdataarray{$url}[2] + $dbcountdataarray{$url}[3] + $dbcountdataarray{$url}[4];
		print ($totalcount);
		$totalcount = 0;
		print ("<TD>");
		print ("</TR>\n");
	}
	print <<"ENDHTML2";

</TABLE>
ENDHTML2
#Use the TemplateBottom subroutine from htmltemplate.pl to generate the server-side includes page footer.
	&TemplateBottom;
	close (STDOUT);
	print "The text file creation from the log file is complete!!!\n\n";
}
