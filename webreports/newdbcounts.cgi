#!/usr/local/bin/perl -s
#**************************************************************************************************************
#* Program and File Name	=	newdbcounts.cgi													*
#* Author				=	John R. Pastori													*
#* Program Description	=	Creates Monthly Article Databases Usage Statistics WEB page					*
#* Date Completed 		=	11/07/2002														*
#* Date Last Modified	=	02/02/2009														*
#* Program File Path Name=	/home/www/lfolks/cgi-bin/											*
#* Data File Path Name	=	/share/ezproxy/													*
#* Operating System		=	UNIX																*
#* Program Purpose		=	This program creates an HTML Web										*
#*						page file from the  Ezproxy Log File created by the new log process			*
#*						The default is to select the previous month's data from Log file.  The		*
#*						customer can include month and year on the command line to select			*
#*						a specific month's data from the Log file.								*
#**************************************************************************************************************
MAIN: {
#*******************************************************************
# Start Variable Declarations here. 	
#*******************************************************************
#	use lib '/usr/local/lib/perl5/site_perl/5.6.1/sun4-solaris';
	use Oraperl;

# Set up Oracle variables.
	$ENV{'ORACLE_HOME'} = '/home/oracle/OraHome1';
	$ENV{'ORACLE_SID'} = 'PRODAPPS';

	$database = $ENV{'ORACLE_SID'};
	$dbsiteid = 0;
	$dbsiteurl = "";
	$login = "";
	@oraclereturn = "";
	$sqlfieldnames = "";
	$tablename = "";
	$yearmonthid = 0;
	$yearmonth = "";

# Define Oracle tables and fieldnames.
	$sitetablename = "ARTICLEDBSITES";
	$statstablename = "ARTICLEDBSTATS";
	$yearmonthtablename = "YEARMONTH";
	$sitetablefieldnames = "DBSITEID, DBSITEURL, DBACTIVE, DBSTATSREPORT";
	$statstablefieldnames = "DBSTATSID, YEARMONTHID, DBSITENAMEID, LIBRARYHITS, LABHITS, ONCAMPUSHITS, OFFCAMPUSHITS, DBTOTALS";
	$yearmonthtablefieldnames = "YEARMONTHID, YEARMONTHNAME";

# Define Oracle login information.
	$userid = "webrptsmgr\@prodapps.library.sdsu.edu";
	$passwd = "PROD\$4app";
	$login = &ora_login("", $userid, $passwd) || die $ora_errstr;
#	print ("\n LOGIN = " . $login . "\n");

# Process Command Line Arguements.
# Define variables.
	$GZIP = "/usr/bin/gzip";
	$sendmail = ("|/usr/lib/sendmail -oi -t -odq");
	$x = ''; 			#Unused time/date values.
	$y = '';			#Unused Ezproxy Log record fields.
	$month = ''; 
	$year = ''; 
# Read in customer parameter info.
	$month = $ARGV[0];
	$year = $ARGV[1];
	
	$TIME = '';
	%montharray = 
		('01' => ['Jan', 'January'],
		 '02' => ['Feb', 'February'],
		 '03' => ['Mar', 'March'],
		 '04' => ['Apr', 'April'],
		 '05' => ['May', 'May'],
		 '06' => ['Jun', 'June'],
		 '07' => ['Jul', 'July'],
		 '08' => ['Aug', 'August'],
		 '09' => ['Sep', 'September'],
		 '10' => ['Oct', 'October'],
		 '11' => ['Nov', 'November'],
		 '12' => ['Dec', 'December']);
	$monthabbrevname = '';
	$monthfullname = '';
	$searchdate = '';

	$customerIP = '';
	$databaseurl = '';

	$url = '';
	$databasenameid = '';
	%dbcountdataarray = ();
	%printdbcounts = ();

	$ezproxyfilename = '/share/ezproxy/ezproxy.savelog';
	$currmonthreccnt = 0;
	$firstrecord = 'yes';

#*******************************************************************
# Start Processing Code here.
#*******************************************************************
# Process user date parameters.
# Check to see if the EZProxy File log is empty.
	print ("\n GREP File Name = " . $ezproxyfilename . "\n\n");
	if (!-z $ezproxyfilename) {
		print ("EZproxy file log has data. \n\n");
	}
	else {
		print ("EZproxy file log is empty!\n\n");
		exit(0);
	}
# If customer does NOT input year parameters, use current date year for record selection processing.
	if ($year eq '') {
		($x, $x, $x, $x, $year)  = split(' ',localtime);
	}
# If customer does NOT input month parameters, use current date month for record selection processing.
	if ($month eq '') {
		use Time::localtime;
		$TIME = localtime;
		if ($TIME->mon == "0 " or $TIME->mon == "1 " or $TIME->mon == "2 " or $TIME->mon =="3 "
		  or $TIME->mon == "4 " or $TIME->mon == "5 " or $TIME->mon == "6 " or $TIME->mon =="7 "
		  or $TIME->mon == "8 " or $TIME->mon == "9 ") {
			$month = ($TIME->mon);
			$month = sprintf("%02d",$month);
			print "\nMonth is 0 thru 9 = $month\n\n";
		}
		else {
			$month = ($TIME->mon);
			print "\nMonth is 10 thru 11 = $month\n\n";
		}
		if ($month eq "00") {
			$month = "12";
			$year = $year - 1;
			 print "\nMonth is 00 so it is changed to 12 = $month\n\n";
		}
	}

# YEARMONTH field is used to look YEARMONTH Key value in Oracle YEARMONTH Table.
	$yearmonth = $year . "-" . $month;
	print ("\n YEAR-MONTH = " . $yearmonth . "\n\n ");

	$tablename = $yearmonthtablename;
	$sqlfieldnames = $yearmonthtablefieldnames;
	$select = (" SELECT " . $sqlfieldnames . " FROM " . $tablename . " WHERE YEARMONTHNAME = \'" . $yearmonth . "\' ");
#	print ("\n The select statement is: " . $select );
	$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
	@yearmonthtabledata = &ora_fetch($oraclereturn);
	print ("\n YEAR-MONTH TABLE DATA = " . $yearmonthtabledata[0] . "  " . $yearmonthtabledata[1] . "\n\n");
	$yearmonthid = $yearmonthtabledata[0];
#	print ("\n YEAR-MONTH ID = " . $yearmonthid . "\n\n");

	$monthabbrevname = $montharray{$month}[0];
	$monthfullname = $montharray{$month}[1];
	$searchdate = ($monthabbrevname . "/" . $year);
	print ("\nProcessing data for Month (" . $monthabbrevname . ") = " . $month . " and Year = " . $year . "\n\n");
	print ("\n Search Date is = " . $searchdate . "\n\n");

# Retrieve database urls and keys from Oracle ARTICLEDBSITES Table.
	chdir ("/share/ezproxy/") || die "Cannot access /share/ezproxy/ directory";
	
	$tablename = $sitetablename;
	$sqlfieldnames = 'DBSITEID';
	$ora_errno = 1;
	$reccount = 0;
	$dbreccount = 0;

# Determine total number of Site Records.
	$select = (" SELECT COUNT(" . $sqlfieldnames . ")  DBRECCOUNT FROM " . $tablename );
#	print ("\n The select statement is: " . $select . "\n\n");
	$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
	@sitetabledata = &ora_fetch($oraclereturn);
	$dbsitereccount = $sitetabledata[0];
	print ("\n DB SITE STAT Total Record Count = " . $dbsitereccount . "\n\n");

# Determine number of Active Site Records on which statistics are to be reported.
	$select = (" SELECT COUNT(" . $sqlfieldnames . ")  DBRECCOUNT FROM " . $tablename . " WHERE DBACTIVE = 'YES' AND DBSTATSREPORT = 'YES' ");
#	print ("\n The select statement is: " . $select . "\n\n");
	$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
	@sitetabledata = &ora_fetch($oraclereturn);
	$dbsitestatreccount = $sitetabledata[0];
	print ("\n DB SITE STAT Active Record Count = " . $dbsitestatreccount . "\n\n");

# Select Specific Active Site Record keys on which statistics are to be reported.
	while ($reccount <= $dbsitereccount) {
		$reccount = $reccount +1;
		$sqlfieldnames = $sitetablefieldnames;
		$select = (" SELECT " . $sqlfieldnames . " FROM " . $tablename . " WHERE DBSITEID = " . $reccount );
#		print ("\n The select statement is: " . $select . "\n\n");
		$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
		@sitetabledata = &ora_fetch($oraclereturn);
		if (($sitetabledata[2] eq 'YES') and ($sitetabledata[3] eq 'YES')) {
			$dbreccount = $dbreccount +1;
#			print (" FLAG DATA = " . $sitetabledata[2] . $sitetabledata[3] . "\n\n");
			$dbsiteid[$dbreccount] = $sitetabledata[0];
#			print ("\n DBSITE Record = " . $dbsiteid[$dbreccount] . "\n\n");
		}
	}

	print ("\n Number of DBSITE Records Selected = " . @dbsiteid  . "\n\n");
	$sqlfieldnames = $sitetablefieldnames;
	$reccount = 0;

# Build associative array of DBSITEIDs and URLs in which statistics will be stored.
	while ($reccount < $dbsitestatreccount) {
		$reccount = $reccount +1;
		$dbsite = $dbsiteid[$reccount];
		$select = (" SELECT " . $sqlfieldnames . " FROM " . $tablename . " WHERE DBSITEID = " . $dbsite . " AND DBACTIVE = 'YES' AND DBSTATSREPORT = 'YES' " );
#		print ("\n The select statement is: " . $select . "\n\n");
		$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
		@sitetabledata = &ora_fetch($oraclereturn);
#		print ("\n SITE DB TABLE DATA = " . $sitetabledata[0] . "  " . $sitetabledata[1] . "\n\n");
		$databasenameid = $sitetabledata[0];
		$url = $sitetabledata[1];
#		print ("URL = " . $url . " DATABASE NAME ID = " . $databasenameid . "\n\n");
		$dbcountdataarray{$url} = [$databasenameid, 0, 0, 0, 0];
	}

# Retreive Ezproxy records for user selected date
	print "\nThe dbcountdata array is being created.  Please wait...\n\n";
	open(LOGFILE, "grep 'GET http\:\/\/libproxy\.sdsu\.edu\:' $ezproxyfilename | grep '\/login\?url\=' | grep -v 'login\?user' | grep -v '\.gif' | grep -v '\.jpg' |");

	while (<LOGFILE>) {
		$fileline = $_;
		chomp($fileline);
		if ($firstrecord eq 'yes') {
			if ($fileline =~ m/$monthabbrevname/) {
				$currmonthreccnt = 0;
				$firstrecord = 'no';
			}
			else {
				$currmonthreccnt = 1;
			}
			if ($currmonthreccnt == 0) {
				print ("\n Current Month Record Count = " . $currmonthreccnt . "\n\n");
				print ("Copy files from LFOLKSTEST web site to LFOLKS web site. \n\n");
			}
			else {
				print ("\n  Current Month Record Count = " . $currmonthreccnt . "\n\n");
				print ("Previous month records were NOT found!\n\n");
				exit(0);
			}
		}
#	print($monthabbrevname  $fileline . "\n");
		($customerIP, $y, $y, $datetimestamp, $y, $y, $databaseurl, $y, $y, $y) = split (" ", $fileline); 
		$datetimestamp =~ s/\[//ig;
		$databaseurl =~  s/^http\:\/\/libproxy\.sdsu\.edu\:80\/login\?url\=//ig;
		$databaseurl =~  s/^GET http/http/ig;
#	print ("CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
		if (exists($dbcountdataarray{$databaseurl})) {
			if ($customerIP =~ m/^130.191.17.|^130.191.104|^130.191.105|^130.191.106|^130.191.108|^130.191.109/) {
				$dbcountdataarray{$databaseurl}[1] += 1;
#	print ("***LIBARARY***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
			}
			elsif ($customerIP =~ m/^130.191.137|^130.191.138|^146.244.137.*|^146.244.138/) {
				$dbcountdataarray{$databaseurl}[2] += 1;
#	print ("***LABS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
			}
			elsif ($customerIP =~ m/^130.191|^146.244/ && $customerIP !~ m/^130.191.17.|^130.191.104|^130.191.105|^130.191.106|^130.191.108|^130.191.109|^130.191.137|^130.191.138|^146.244.137|^146.244.138/) {
				$dbcountdataarray{$databaseurl}[3] += 1;
#	print ("***ONCAMPUS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
			}
			elsif ($customerIP !~ m/^130.191|^146.244/) {
				$dbcountdataarray{$databaseurl}[4] += 1;
#	print ("***OFFCAMPUS***CUSTOMER IP = " . $customerIP . " DATETIMESTAMP = " . $datetimestamp . " DATABASEURL = " . $databaseurl . "\n");
			}
			else {
				print ("\n\n******BAD IP ADDRESS!!!!!!! = " . $customerIP . "******\n\n<br><br>");
			}
		}
	}
	close (LOGFILE);
# Write print associative array from database count data array..
	print "\n\nThe Database Statistics HTML Page is being created.  Please wait...\n\n";
	foreach $url (sort(keys(%dbcountdataarray))) {
#	print ("\n$url\t $dbcountdataarray{$url}[0]\t$dbcountdataarray{$url}[1]\t$dbcountdataarray{$url}[2]\t$dbcountdataarray{$url}[3]\t$dbcountdataarray{$url}[4]\n");
		$printdbcounts{$dbcountdataarray{$url}[0]} = [$dbcountdataarray{$url}[1], $dbcountdataarray{$url}[2], $dbcountdataarray{$url}[3], $dbcountdataarray{$url}[4]];
	}
	&WriteWebReport;
	print "The ORACLE ARTICLEDBSTATS Database record creation from the log file is complete!!!\n\n";
}
sub WriteWebReport {
# Write Database statistics to Oracle ARTICLEDBSTATS Table.
	$totalcount = 0;
	$tablename = $statstablename;
	$sqlfieldnames = 'DBSTATSID';
	$select = (" SELECT MAX(" . $sqlfieldnames . ") AS DBSTATSID FROM " . $tablename );
#	print ("\n The select statement is: " . $select . "\n\n");
	$oraclereturn = &ora_open($login, $select) || die "\nCannot Select DATA RECORD $sqlfieldnames \n\n";
	@dbstatstabledata = &ora_fetch($oraclereturn);
	$dbstatsid = $dbstatstabledata[0];
	print ("\n PREVIOUS FINAL DBSTATS ID = " . $dbstatsid . "\n\n");

# For testing, set $rundirname to "pastori".  For Production set $rundirname to "ezproxy".
	$rundirname = "ezproxy";
	$sqlfieldnames = $statstablefieldnames;
	foreach $databasenameid (sort(keys(%printdbcounts))) {
		$dbstatsid = $dbstatsid + 1;
		$totalcount = $printdbcounts{$databasenameid}[0] + $printdbcounts{$databasenameid}[1] + $printdbcounts{$databasenameid}[2] + $printdbcounts{$databasenameid}[3];
		$sqlfieldvalues = ( $dbstatsid . ", " . $yearmonthid . ", " . $databasenameid . ", " . $printdbcounts{$databasenameid}[0] . ", " . $printdbcounts{$databasenameid}[1] . ", " . $printdbcounts{$databasenameid}[2] . ", " . $printdbcounts{$databasenameid}[3] . ", " . $totalcount );
		$insert = ("INSERT INTO " . $tablename . "(" . $sqlfieldnames . ") VALUES(" . $sqlfieldvalues . ")\n");
#		print ("\n The insert statement is: " . $insert . "\n\n");
		$oraclereturn = &ora_open($login, $insert) || die "\nCannot insert DATA RECORD $sqlfieldvalues \n\n";
		&ora_commit($login);
	}
	print ("\n NEW FINAL DBSTATS ID = " . $dbstatsid . "\n\n");

# Sets up E-Mail data field values so the form data is sent to John Pastori's E-Mail account when the program is run monthly.
	$from = ("From: webmaster\@libweb.sdsu.edu");
	$send_to = ("To: John Robert Pastori <pastori\@rohan.sdsu.edu>");
	$subject = ("Subject: Monthly Library Article Database Statistics");
	$message_body = ("Proper execution of the Monthly Library Article Database Statistics Program can be verified at http://lfolks.sdsu.edu/PRODapps/.");

# Send E-Mail elements "FROM", "TO", "SUBJECT", and "MESSAGE" to the SDSU Rohan E-Mail server using SUN UNIX "sendmail" command.
	open(SENDWEBURL, "$sendmail") or die "Can't fork for sendmail: # $!\n";
	print (SENDWEBURL <<"EOF");
$from
$send_to 
$subject
$message_body
EOF
	close(SENDWEBURL);
	return();
}
