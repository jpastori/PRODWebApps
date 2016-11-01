<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: publicdeskfullreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Web Reports - Public Desk Full Report --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/publicdeskfullreport.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">

<!--- <CFIF SESSION.ORIGINSERVER NEQ "" AND FIND('#SESSION.ORIGINSERVER#', #CGI.HTTP_REFERER#, 1) EQ 0 AND FIND('publicdeskdbreport.cfm', #CGI.HTTP_REFERER#, 1) EQ 0>
	<CFSET SESSION.ORIGINSERVER = "">
</CFIF>
<CFIF FIND('Files', #CGI.HTTP_REFERER#, 1) NEQ 0 OR SESSION.ORIGINSERVER EQ "Files">
	<CFSET SESSION.ORIGINSERVER = "Files">
	<CFSET RETURNPGM = "returnfilesindex.cfm">
<CFELSEIF FIND('IDT', #CGI.HTTP_REFERER#, 1) NEQ 0 OR SESSION.ORIGINSERVER EQ "IDT">
	<CFSET SESSION.ORIGINSERVER = "IDT">
	<CFSET RETURNPGM = "returnIDTindex.cfm">
<CFELSE>
	<CFSET SESSION.ORIGINSERVER = "">
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET RETURNPGM = "index.cfm?logout=No">
</CFIF> --->

<HTML>
<HEAD>
	<TITLE>Web Reports - Public Desk Full Report</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Web Reports - Public Desk";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	
	function validateLookupFields() {
		if (document.LOOKUP.REPORTCHOICE[0].checked == "0" && document.LOOKUP.REPORTCHOICE[1].checked == "0") {
			alertuser ("You must choose one of the two reports!");
			document.LOOKUP.REPORTCHOICE[0].focus();
			return false;
		}
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPUBLICDESK')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**************************************************************************
* The following code is the Look Up Process for Public Desk Full Report. *
**************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListPDTopic" datasource="#application.type#WEBREPORTS" blockfactor="29">
		SELECT	TOPICID, TOPIC
		FROM		PDTOPIC
		ORDER BY	TOPIC
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Select Data for Web Reports - Public Desk Full Report</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/webreports/publicdeskfullreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>SELECT ONE OF THE Two (2) REPORTS BELOW</COM></TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="2">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;Public Desk Full Report</LABEL></TH>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2:</LABEL> &nbsp;&nbsp;<LABEL for="TOPICID">Public Desk Full Report By Topic</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListPDTopic" value="TOPICID" display="TOPIC" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
               <TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="5" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
		<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>

<CFELSE>

<!--- 
******************************************************************************************
* The following code is the Report Generation Processes for the Public Desk Full Report. *
******************************************************************************************
 --->

	<CFQUERY name="ListPublicDesk" datasource="#application.type#WEBREPORTS" blockfactor="67">
		SELECT	PD.PUBLICDESKID, PD.TOPICID, T.TOPIC, PD.SUBTOPICID, ST.SUBTOPIC, PD.CONTACTTIMEID, CT.CONTACTTIME, PD.CONTACTID,
				C.CONTACTNAME, C.DEPARTMENT, C.PHONE, C.EMAIL, PD.IDTOPTIONS, PD.PUBDESKOPTIONS, PD.CIRCNOTIFY,
				PD.IDTNOTIFY, PD.CIRCCALLORDER, PD.IDTCALLORDER, PD.MGMTCALLORDER, PD.MODIFIEDBYID, CUST.FULLNAME, PD.MODIFIEDDATE,
				T.TOPIC || ' - ' || ST.SUBTOPIC AS LOOKUPKEY
		FROM		PUBLICDESK PD, PDTOPIC T, PDSUBTOPIC ST, PDCONTACTTIME CT, PDCONTACTS C, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	PD.PUBLICDESKID > 0 AND
			<CFIF #FORM.REPORTCHOICE# EQ 2>
				PD.TOPICID = <CFQUERYPARAM value="#FORM.TOPICID#" cfsqltype="CF_SQL_NUMERIC"> AND
			</CFIF>
				PD.TOPICID = T.TOPICID AND
				PD.SUBTOPICID = ST.SUBTOPICID AND
				PD.CONTACTTIMEID = CT.CONTACTTIMEID AND
				PD.CONTACTID = C. CONTACTID AND 
				PD.MODIFIEDBYID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Public Desk Full Report By Topic - #ListPublicDesk.TOPIC#'>
	</CFIF>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Web Reports - Public Desk Full Report
			<CFIF #FORM.REPORTCHOICE# EQ 2>
				<H2>#REPORTTITLE#
			</CFIF>
			</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/publicdeskfullreport.cfm" method="POST">
			<TD align="left" colspan="3">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="3"><H2>#ListPublicDesk.RecordCount# Public Desk records were selected.</H2></TH>
		</TR>
		<TR>
			<TD align="left" colspan="3"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
<CFLOOP query="ListPublicDesk">
		<TR>
	<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TH align="left" valign="BOTTOM">Topic</TH>
	</CFIF>
			<TH align="left" valign="BOTTOM">SubTopic</TH>
	<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TH align="left" valign="BOTTOM">Contact Time (When)</TH>
	<CFELSE>
			<TH align="left" valign="BOTTOM" colspan="2">Contact Time (When)</TH>
	</CFIF>
		</TR>
		<TR>
	<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TD align="left" valign="TOP">#ListPublicDesk.TOPIC#</TD>
	</CFIF>
			<TD align="left" valign="TOP">#ListPublicDesk.SUBTOPIC#</TD>
	<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TD align="left" valign="TOP">#ListPublicDesk.CONTACTTIME#</TD>
	<CFELSE>
			<TD align="left" valign="TOP" colspan="2">#ListPublicDesk.CONTACTTIME#</TD>
	</CFIF>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Contact Name</TH>
			<TH align="left" valign="BOTTOM">Contact Phone</TH>
			<TH align="left" valign="BOTTOM">Contact E-Mail</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#ListPublicDesk.CONTACTNAME#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.PHONE#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.EMAIL#</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Contact Department</TH>
			<TH align="left" valign="BOTTOM" colspan="2">Public Desk Options</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#ListPublicDesk.DEPARTMENT#</TD>
			<TD align="left" valign="TOP" colspan="2">#ListPublicDesk.PUBDESKOPTIONS#</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Circulation Notifications</TH>
			<TH align="left" valign="BOTTOM">Circulation Call Order</TH>
			<TH align="left" valign="BOTTOM">Management Call Order</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#ListPublicDesk.CIRCNOTIFY#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.CIRCCALLORDER#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.MGMTCALLORDER#</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">IDT Options</TH>
			<TH align="left" valign="BOTTOM">IDT Notifications</TH>
			<TH align="left" valign="BOTTOM">IDT Call Order</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#ListPublicDesk.IDTOPTIONS#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.IDTNOTIFY#</TD>
			<TD align="left" valign="TOP">#ListPublicDesk.IDTCALLORDER#</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Modified By</TH>
			<TH align="left" valign="BOTTOM" colspan="2">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#ListPublicDesk.FULLNAME#</TD>
			<TD align="left" valign="TOP" colspan="2">#DateFormat(ListPublicDesk.MODIFIEDDATE, "MM/DD/YYYY")#</TD>
		</TR>
		<TR>
			<TD align="left" colspan="3"><HR /></TD>
		</TR>
</CFLOOP>
		<TR>
			<TD align="left" colspan="3"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="3"><H2>#ListPublicDesk.RecordCount# Public Desk records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/publicdeskfullreport.cfm" method="POST">
			<TD align="left" colspan="3">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>