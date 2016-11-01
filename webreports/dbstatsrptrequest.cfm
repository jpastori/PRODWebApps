<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: dbstatsrptrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/05/2009 --->
<!--- Date in Production: 08/05/2009 --->
<!--- Module: Web Reports - Library Article Databases Usage Statistics Report Request Form --->
<!-- Last modified by John R. Pastori on 08/05/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/dbstatsrptrequest.cfm">
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
	<CFINCLUDE template = "/include/coldfusion/dbstatsrequest.js">

</HEAD>

<BODY topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" onLoad="document.DBSTATSREQUEST.PROCESSTYPE.focus()">

<CFOUTPUT>

<!--- 
**********************************************************************************************************************
* The following code is the Look Up Process for the Web Reports - Library Article Databases Usage Statistics Report. *
**********************************************************************************************************************
 --->

<CFQUERY name="ListMonths" datasource="#application.type#LIBSHAREDDATA" blockfactor="13">
	SELECT	MONTHID, MONTHNAME
	FROM		MONTHS
	ORDER BY	MONTHID
</CFQUERY>

<CFQUERY name="ListYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="28">
	SELECT	YEARID, YEAR
	FROM		YEARS
	ORDER BY	YEARID
</CFQUERY>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
	<TR>
		<TD align="left">
			<IMG src="/images/bigheader.jpg" alt="LFOLKS Intranet Web Site" />
		</TD>
	</TR>
</TABLE>

<HR />

<DIV align="center"><H1>Web Reports - LIBRARY ARTICLE DATABASES USAGE STATISTICS REPORT</H1></DIV>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="CENTER">
	<TR>
		<TD align="center" colspan="4">
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
		</TD>
	</TR>
<CFFORM name="DBSTATSREQUEST" onsubmit="return validateReqFields();" method="POST" action="dbstatsreport.cfm">
	<TR align="left" valign="top">
		<TD colspan="4">
			<DIV align="CENTER"><H3>Please select the desired process code and report date(s)</H3></DIV>
			<DIV align="center">The default process is to run an Annual Report for the current fiscal year (ie. July 1 to June 30).<BR />
			If the Monthly Report is chosen, the default is to process the previous month's data.</DIV><BR /><BR />
			
		</TD>
	</TR>
	<TR>
		<TD valign="TOP" align="RIGHT">
			<LABEL for="PROCESSTYPE">Choose your process type:</LABEL>&nbsp;
		</TD>
		<TD valign="BOTTOM" align="LEFT">
			<CFSELECT name="PROCESSTYPE" id="PROCESSTYPE" tabindex="2">
				<OPTION selected value="A">Annual Report
				</OPTION><OPTION value="M">Monthly Report
				</OPTION><OPTION value="R">Range of Months Report.
			</CFSELECT>
		</TD>
		<TD colspan="2">
			&nbsp;&nbsp;
		</TD>
	</TR>
	<TR>
		<TD colspan="4">
			&nbsp;&nbsp;
		</TD>
	</TR>
	<TR>
		<TD valign="TOP" align="RIGHT">
			<LABEL for="BEGINMONTH">Choose your Begin Month <BR /> for a Monthly Report or &nbsp;&nbsp;<BR /> Range Of Months Report:</LABEL>
		</TD>
		<TD valign="BOTTOM" align="LEFT">
			<CFSELECT name="BEGINMONTH" id="BEGINMONTH" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" required="No" tabindex="3"></CFSELECT>
		</TD>
		<TD valign="TOP" align="RIGHT">
			<LABEL for="BEGINYEAR"><BR />Choose your Begin Year <BR /> for your chosen report:</LABEL>
		</TD>
		<TD valign="BOTTOM" align="LEFT">
			<CFSELECT name="BEGINYEAR" id="BEGINYEAR" size="1" query="ListYears" value="YEARID" display="YEAR" required="No" tabindex="4"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD colspan="4">
			&nbsp;&nbsp;
		</TD>
	</TR>
	<TR>
		<TD valign="TOP" align="RIGHT">
			<LABEL for="ENDMONTH">Choose your End Month for <BR /> a Range Of Months Report:</LABEL>
		</TD>
		<TD valign="BOTTOM" align="LEFT">
		<CFSELECT name="ENDMONTH" id="ENDMONTH" size="1" query="ListMonths" value="MONTHID" display="MONTHNAME" required="No" tabindex="5"></CFSELECT>
		</TD>
		<TD valign="TOP" align="RIGHT">
			<LABEL for="ENDYEAR">Choose your End Year<BR /> for your chosen report:</LABEL>
		</TD>
		<TD valign="BOTTOM" align="LEFT">
		<CFSELECT name="ENDYEAR" id="ENDYEAR" size="1" query="ListYears" value="YEARID" display="YEAR" required="No" tabindex="6"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TD colspan="2">
			&nbsp;&nbsp;
		</TD>
	</TR>
	<TR>
		<TD align="center" colspan="4">
			<INPUT type="SUBMIT" value="REQUEST REPORT" tabindex="7" /><BR />
			<INPUT type="RESET" value="CLEAR FORM" name="Reset button" tabindex="8" /><BR />
		</TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="center" colspan="4">
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<INPUT type="SUBMIT" value="Cancel" tabindex="9" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
		</TD>
	</TR>
	<TR>
		<TD align="left" colspan="42"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>