<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: dbstatsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/05/2009 --->
<!--- Date in Production: 08/05/2009 --->
<!--- Module: Web Reports - Library Article Databases Usage Statistics Report --->
<!-- Last modified by John R. Pastori on 08/05/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/webreports/dbstatsreport.cfm">
<CFSET CONTENT_UPDATED = "August 05, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>

<HEAD>
	<TITLE>Web Reports - Library Article Databases Usage Statistics Report</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="STYLESHEET" href="/webapps.css" type="text/css" />
</HEAD>

<BODY>

<CFOUTPUT>

<!--- 
****************************************************************************************
* The following code is the Look Up Process for Report Begin and End Months and Years. *
****************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PRINT')>
	<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
		<TR>
			<TD align="left">
				<IMG src="/images/smheader.jpg" alt="LFOLKS Intranet Web Site" border="0" />
			</TD>
		</TR>
	</TABLE>

	<CFSET BEGINYEARMONTH = "">
	<CFSET ENDYEARMONTH = "">
	<CFSET CURRENTYEAR = "">
	<CFSET CURRENTMONTH = 0>
	<CFSET BYPASSDATELOOKUP = "NO">

	<CFIF FORM.PROCESSTYPE EQ "A">
		<CFIF FORM.BEGINYEAR EQ 0 AND FORM.ENDYEAR EQ 0>
			<CFSET CURRENTMONTH = MONTH(NOW())>
			<CFSET CURRENTYEAR = YEAR(NOW())>
			<CFIF CURRENTMONTH LT 7>
				<CFSET FORM.BEGINYEAR  = CURRENTYEAR - 1>
				<CFSET FORM.ENDYEAR  = CURRENTYEAR>
			<CFELSE>
				<CFSET FORM.BEGINYEAR  = CURRENTYEAR>
				<CFSET FORM.ENDYEAR  = CURRENTYEAR + 1>
			</CFIF>
			<!--- CURRENT YEAR = #CURRENTYEAR#<BR>
			FORM BEGIN YEAR = #FORM.BEGINYEAR#<BR>
			FORM END YEAR = #FORM.ENDYEAR#<BR> --->

			<CFQUERY name="LookupBeginYear" datasource="#application.type#LIBSHAREDDATA">
				SELECT	YEARID, YEAR
				FROM		YEARS
				WHERE	YEAR = <CFQUERYPARAM value="#FORM.BEGINYEAR#" cfsqltype="CF_SQL_VARCHAR">
				ORDER BY	YEAR
			</CFQUERY>
			<CFSET SESSION.BEGINYEAR = #LookupBeginYear.YEAR#>
			<CFSET BEGINYEARMONTH = "#LookupBeginYear.YEAR#-07">

			<CFQUERY name="LookupEndYear" datasource="#application.type#LIBSHAREDDATA">
				SELECT	YEARID, YEAR
				FROM		YEARS
				WHERE	YEAR = <CFQUERYPARAM value="#FORM.ENDYEAR#" cfsqltype="CF_SQL_VARCHAR">
				ORDER BY	YEAR
			</CFQUERY>
			<CFSET SESSION.ENDYEAR = #LookupEndYear.YEAR#>
			<CFSET ENDYEARMONTH = "#LookupEndYear.YEAR#-06">
			<CFSET BYPASSDATELOOKUP = "YES">
		<CFELSE>
			<CFSET FORM.BEGINMONTH = "7">
			<CFSET FORM.ENDMONTH = "6">
		</CFIF>
	</CFIF>

	<CFIF FORM.PROCESSTYPE EQ "M">
		<CFIF FORM.BEGINMONTH EQ 0 AND FORM.BEGINYEAR EQ 0>
			<CFSET FORM.BEGINYEAR = YEAR(NOW())>
			<CFSET FORM.BEGINMONTH = MONTH(NOW())-1>
			<CFIF FORM.BEGINMONTH EQ 0>
				<CFSET FORM.BEGINYEAR  = YEAR(NOW()) -1>
				<CFSET FORM.BEGINMONTH = 12>
			</CFIF>
			BEGIN YEAR = #FORM.BEGINYEAR# / BEGIN MONTH = #FORM.BEGINMONTH#

			<CFQUERY name="LookupBeginYear" datasource="#application.type#LIBSHAREDDATA">
				SELECT	YEARID, YEAR
				FROM		YEARS
				WHERE	YEAR = <CFQUERYPARAM value="#FORM.BEGINYEAR#" cfsqltype="CF_SQL_VARCHAR">
				ORDER BY	YEAR
			</CFQUERY>

			<CFSET SESSION.BEGINYEAR = #LookupBeginYear.YEAR#>
			SESSION.BEGINYEAR = #SESSION.BEGINYEAR#

			<CFQUERY name="LookupBeginMonth" datasource="#application.type#LIBSHAREDDATA">
				SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
				FROM		MONTHS
				WHERE	MONTHID = <CFQUERYPARAM value="#FORM.BEGINMONTH#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	MONTHID
			</CFQUERY>

			<CFSET SESSION.BEGINMONTHNAME = #LookupBeginMonth.MONTHNAME#>
			<CFSET BEGINYEARMONTH = "#FORM.BEGINYEAR#-#LookupBeginMonth.MONTHNUMBERASCHAR#">
			<CFSET BYPASSDATELOOKUP = "YES">
			DEFAULT BEGIN YEAR MONTH = #BEGINYEARMONTH#
		</CFIF>
	</CFIF>

	<CFIF BYPASSDATELOOKUP EQ "NO">

		<CFQUERY name="LookupBeginYear" datasource="#application.type#LIBSHAREDDATA">
			SELECT	YEARID, YEAR
			FROM		YEARS
			WHERE	YEARID = <CFQUERYPARAM value="#FORM.BEGINYEAR#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	YEARID
		</CFQUERY>
		<CFSET SESSION.BEGINYEAR = #LookupBeginYear.YEAR#>
		
		<CFQUERY name="LookupBeginMonth" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
			FROM		MONTHS
			WHERE	MONTHID = <CFQUERYPARAM value="#FORM.BEGINMONTH#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	MONTHID
		</CFQUERY>
		<CFSET SESSION.BEGINMONTHNAME = #LookupBeginMonth.MONTHNAME#>
		<CFSET BEGINYEARMONTH = "#LookupBeginYear.YEAR#-#LookupBeginMonth.MONTHNUMBERASCHAR#">

		<CFIF FORM.PROCESSTYPE EQ "A" OR FORM.PROCESSTYPE EQ "R">

			<CFQUERY name="LookupEndYear" datasource="#application.type#LIBSHAREDDATA">
				SELECT	YEARID, YEAR
				FROM		YEARS
				WHERE	YEARID = <CFQUERYPARAM value="#FORM.ENDYEAR#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	YEARID
			</CFQUERY>
			<CFSET SESSION.ENDYEAR = #LookupEndYear.YEAR#>

			<CFQUERY name="LookupEndMonth" datasource="#application.type#LIBSHAREDDATA">
				SELECT	MONTHID, MONTHNAME, MONTHNUMBERASCHAR
				FROM		MONTHS
				WHERE	MONTHID = <CFQUERYPARAM value="#FORM.ENDMONTH#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	MONTHID
			</CFQUERY>
			<CFSET SESSION.ENDMONTHNAME = #LookupEndMonth.MONTHNAME#>
			<CFSET ENDYEARMONTH = "#LookupEndYear.YEAR#-#LookupEndMonth.MONTHNUMBERASCHAR#">
		</CFIF>
	</CFIF>

	<CFQUERY name="ListArticleDBStats" datasource="#application.type#WEBREPORTS" blockfactor="100">
		SELECT	ADBS.YEARMONTHID, YM.YEARMONTHID, YM.YEARMONTHNAME, ADBS.DBSITENAMEID, ADBSI.DBSITEID, ADBSI.DBSITENAME,
				ADBS.LIBRARYHITS, ADBS.LABHITS, ADBS.ONCAMPUSHITS, ADBS.OFFCAMPUSHITS, ADBS.DBTOTALS, INITCAP(ADBSI.DBSITENAME) AS SORTTITLE
		FROM		ARTICLEDBSTATS ADBS, YEARMONTH YM, ARTICLEDBSITES ADBSI
		WHERE	ADBS.YEARMONTHID = YM.YEARMONTHID AND
				ADBS.DBSITENAMEID = ADBSI.DBSITEID AND
	<CFIF FORM.PROCESSTYPE EQ "A">
				YM.YEARMONTHNAME BETWEEN '#BEGINYEARMONTH#' AND '#ENDYEARMONTH#'
		ORDER BY	SORTTITLE, YM.YEARMONTHNAME
	<CFELSEIF FORM.PROCESSTYPE EQ "M">
				YM.YEARMONTHNAME = '#BEGINYEARMONTH#'
		ORDER BY	YM.YEARMONTHNAME, SORTTITLE
	<CFELSEIF FORM.PROCESSTYPE EQ "R">
				YM.YEARMONTHNAME BETWEEN '#BEGINYEARMONTH#' AND '#ENDYEARMONTH#'
		ORDER BY	SORTTITLE, YM.YEARMONTHNAME
	</CFIF>
	</CFQUERY>
<!--- BYPASS DATE LOOKUP = #BYPASSDATELOOKUP#<BR>
BEGIN YEAR MONTH = #BEGINYEARMONTH#<BR>
END YEAR MONTH = #ENDYEARMONTH#<BR><BR> --->
	<CFIF #ListArticleDBStats.RecordCount# EQ 0>
		<H4>Records having the selected Month/Year(s) were Not Found
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records having the selected Month/Year(s) were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/dbstatsrptrequest.cfm" />
		<CFEXIT>
	</CFIF>

<!--- 
***************************************************************************
* Add record count field values to an array for range and annual reports. *
***************************************************************************
 --->

	<CFSET NEXTSITENAME = "">
	<CFSET SITEARRAYCOUNT = 0>
	<CFSET SESSION.SITEARRAY=ArrayNew(2)>

	<CFLOOP query="ListArticleDBStats">
		<CFIF #NEXTSITENAME# NEQ #ListArticleDBStats.DBSITENAME#>
			<CFSET SITEARRAYCOUNT = SITEARRAYCOUNT + 1>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][1]= #Replace(ListArticleDBStats.DBSITENAME[CurrentRow], "`", "'")#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][2]= #val(ListArticleDBStats.LIBRARYHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][3]= #val(ListArticleDBStats.LABHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][4]= #val(ListArticleDBStats.ONCAMPUSHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][5]= #val(ListArticleDBStats.OFFCAMPUSHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][6]= #val(ListArticleDBStats.DBTOTALS[CurrentRow])#>
			<CFSET NEXTSITENAME = #ListArticleDBStats.DBSITENAME#>
		<CFELSE>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][2]= #SESSION.SITEARRAY[SITEARRAYCOUNT][2]# + #val(ListArticleDBStats.LIBRARYHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][3]= #SESSION.SITEARRAY[SITEARRAYCOUNT][3]# + #val(ListArticleDBStats.LABHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][4]= #SESSION.SITEARRAY[SITEARRAYCOUNT][4]# + #val(ListArticleDBStats.ONCAMPUSHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][5]= #SESSION.SITEARRAY[SITEARRAYCOUNT][5]# + #val(ListArticleDBStats.OFFCAMPUSHITS[CurrentRow])#>
			<CFSET SESSION.SITEARRAY[SITEARRAYCOUNT][6]= #SESSION.SITEARRAY[SITEARRAYCOUNT][6]# + #val(ListArticleDBStats.DBTOTALS[CurrentRow])#>
		</CFIF>
	</CFLOOP>
<CFELSE>
	<CFSET FORM.PROCESSTYPE = #URL.PROCESSTYPE#>
</CFIF>

<!--- 
*****************************************
* Write report headers, body and totals.*
*****************************************
 --->

<TABLE border="3" width="100%" cellpadding="3" cellspacing="0">
	<TR>
		<TD>
			<A name="TOP"></A>
			<DIV align="center"><FONT color="BLACK" size="+2"><STRONG>Web Reports - LIBRARY ARTICLE DATABASES USAGE STATISTICS REPORT</STRONG></FONT></DIV>
		</TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellpadding="3" cellspacing="0">
	<TR>
		<TD colspan="6" align="center">
		<CFIF NOT IsDefined('URL.PRINT')>
			<DIV align="center">
				<A href="/#application.type#apps/webreports/dbstatsrptrequest.cfm">Return to Request Form</A>
					| <A href="/#application.type#apps/webreports/index.cfm?logout=No" >Return to Web Reports App</A>
					| <A href="#CGI.SCRIPT_NAME#?PRINT=YES&PROCESSTYPE=#FORM.PROCESSTYPE#">
						<IMG src="/images/printer.gif" alt="Printer Icon" align="absbottom" /> Display Printer-friendly version</A>
			</DIV>
		<CFELSE>
			<DIV align="center">
				<A href="/#application.type#apps/webreports/dbstatsrptrequest.cfm">Return to Request Form</A>
					| <A href="/#application.type#apps/webreports/index.cfm?logout=No" >Return to Web Reports App</A>
			</DIV>
		</CFIF>
		</TD>
	</TR>
	<TR>
		<TD colspan="6">
	<CFIF FORM.PROCESSTYPE EQ "A">
		<DIV align="CENTER"><FONT color="RED" size="+1"><STRONG>ANNUAL PROCESS:  JULY 1, #SESSION.BEGINYEAR# thru JUNE 30, #SESSION.ENDYEAR#</STRONG></FONT></DIV>
	<CFELSEIF FORM.PROCESSTYPE EQ "M">
		<DIV align="RIGHT"><FONT color="RED" size="+1"><STRONG>PROCESS MONTH/YEAR: #SESSION.BEGINMONTHNAME# #SESSION.BEGINYEAR#</STRONG></FONT></DIV>
	<CFELSEIF FORM.PROCESSTYPE EQ "R">
		<DIV align="CENTER"><FONT color="RED" size="+1"><STRONG>DATE RANGE PROCESS:  #SESSION.BEGINMONTHNAME#, #SESSION.BEGINYEAR# thru #SESSION.ENDMONTHNAME#, #SESSION.ENDYEAR#</STRONG></FONT></DIV>
	</CFIF>
			
		</TD>
	</TR>
</TABLE>

<CFIF NOT IsDefined('URL.PRINT')>
	<TABLE border="3" width="100%" cellpadding="3" cellspacing="0">
<CFELSE>
	<TABLE border="0" width="100%" cellpadding="3" cellspacing="0">
</CFIF>
	<TR>
		<TH><STRONG><u>Site Name</u></STRONG></TH>
		<TH><STRONG><u>Hits In Library</u></STRONG></TH>
		<TH><STRONG><u>Hits In Computing Labs</u></STRONG></TH>
		<TH><STRONG><u>Hits On Campus (Not In Library)</u></STRONG></TH>
		<TH><STRONG><u>Hits Off Campus</u></STRONG></TH>
		<TH><STRONG><u>DB Totals</u></STRONG></TH>
	</TR>

	<CFSET COUNTTOTALLIBRARYHITS = 0>
	<CFSET COUNTTOTALLABHITS = 0>
	<CFSET COUNTTOTALONCAMPUSHITS = 0>
	<CFSET COUNTTOTALOFFCAMPUSHITS = 0>
	<CFSET COUNTTOTALDBTOTALS = 0>
	<CFSET SITEARRAYCOUNT = 0>

<CFLOOP index="SITEARRAYCOUNT" from=1 to="#ArrayLen(SESSION.SITEARRAY)#">
	<TR> 
		<TD align="left">#SESSION.SITEARRAY[SITEARRAYCOUNT][1]#</TD>
		<TD align="right">#SESSION.SITEARRAY[SITEARRAYCOUNT][2]#</TD>
		<CFSET COUNTTOTALLIBRARYHITS = #COUNTTOTALLIBRARYHITS# + #SESSION.SITEARRAY[SITEARRAYCOUNT][2]#>
		<TD align="right">#SESSION.SITEARRAY[SITEARRAYCOUNT][3]#</TD>
		<CFSET COUNTTOTALLABHITS = #COUNTTOTALLABHITS# + #SESSION.SITEARRAY[SITEARRAYCOUNT][3]#>
		<TD align="right">#SESSION.SITEARRAY[SITEARRAYCOUNT][4]#</TD>
		<CFSET COUNTTOTALONCAMPUSHITS = #COUNTTOTALONCAMPUSHITS# + #SESSION.SITEARRAY[SITEARRAYCOUNT][4]#>
		<TD align="right">#SESSION.SITEARRAY[SITEARRAYCOUNT][5]#</TD>
		<CFSET COUNTTOTALOFFCAMPUSHITS = #COUNTTOTALOFFCAMPUSHITS# + #SESSION.SITEARRAY[SITEARRAYCOUNT][5]#>
		<TD align="right">#SESSION.SITEARRAY[SITEARRAYCOUNT][6]#</TD>
		<CFSET COUNTTOTALDBTOTALS = #COUNTTOTALDBTOTALS# + #SESSION.SITEARRAY[SITEARRAYCOUNT][6]#>
	</TR>
</CFLOOP>
	<TR> 
		<TD colspan="6"> 
			<HR noshade />
		</TD>
	</TR>
	<TR> 
		<TD align="left"> <STRONG><u>GRAND TOTALS:</u></STRONG> </TD>
		<TD align="right">#COUNTTOTALLIBRARYHITS#</TD>
		<TD align="right">#COUNTTOTALLABHITS#</TD>
		<TD align="right">#COUNTTOTALONCAMPUSHITS#</TD>
		<TD align="right">#COUNTTOTALOFFCAMPUSHITS#</TD>
		<TD align="right">#COUNTTOTALDBTOTALS#</TD>
	</TR>
</TABLE>

<BR /><BR />
<TABLE border="0" width="100%" cellpadding="3" cellspacing="0">
	<TR>
		<TD colspan="6" align="center">
<CFIF NOT IsDefined('URL.PRINT')>
	<DIV align="center">
		<A href="##TOP">Top of Document</A>
			| <A href="/#application.type#apps/webreports/dbstatsrptrequest.cfm">Return to Request Form</A>
			| <A href="/#application.type#apps/webreports/index.cfm?logout=No" >Return to Web Reports App</A>
			| <A href="#CGI.SCRIPT_NAME#?PRINT=YES&PROCESSTYPE=#FORM.PROCESSTYPE#">
				<IMG src="/images/printer.gif" alt="Printer Icon" align="absbottom" /> Display Printer-friendly version</A>
	</DIV>
	<CFINCLUDE template="/include/coldfusion/footer.cfm"> 
<CFELSE>
	<DIV align="center">
		<A href="##TOP">Top of Document</A> 
			| <A href="/#application.type#apps/webreports/dbstatsrptrequest.cfm">Return to Request Form</A>
			| <A href="/#application.type#apps/webreports/index.cfm?logout=No" >Return to Web Reports App</A>
	</DIV>
</CFIF>
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>