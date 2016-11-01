<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: publicdeskdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Web Reports - Public Desk Reports --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/publicdeskdbreport.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">

<CFIF (NOT IsDefined('SESSION.ORIGINSERVER')) OR (SESSION.ORIGINSERVER NEQ "" AND FIND('#SESSION.ORIGINSERVER#', #CGI.HTTP_REFERER#, 1) EQ 0 AND FIND('publicdeskdbreport.cfm', #CGI.HTTP_REFERER#, 1) EQ 0)>
	<CFSET SESSION.ORIGINSERVER = "">
</CFIF>
<CFIF FIND('Files', #CGI.HTTP_REFERER#, 1) NEQ 0 OR SESSION.ORIGINSERVER EQ "Files">
	<CFSET SESSION.ORIGINSERVER = "Files">
	<CFSET RETURNPGM = "returnfilesindex.cfm">
<CFELSEIF FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0 OR SESSION.ORIGINSERVER EQ "wiki">
	<CFSET SESSION.ORIGINSERVER = "wiki">
	<CFSET RETURNPGM = "returnIDTindex.cfm">
<CFELSE>
	<CFSET SESSION.ORIGINSERVER = "">
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET RETURNPGM = "index.cfm?logout=No">
</CFIF>

<HTML>
<HEAD>
	<TITLE>Web Reports - Public Desk Reports</TITLE>
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
		if (document.LOOKUP.PUBLICDESKID.selectedIndex == "0") {
			alertuser (document.LOOKUP.PUBLICDESKID.name +  ",  A Public Desk Topic MUST be selected!");
			document.LOOKUP.PUBLICDESKID.focus();
			return false;
		}

	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPUBLICDESK')>
	<CFSET CURSORFIELD = "document.LOOKUP.PUBLICDESKID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF #URL.REPORT# EQ "PUBD">
	<CFSET #REPORTTILE# = "Public Desk Report">
<CFELSEIF #URL.REPORT# EQ "CIRCD">
	<CFSET #REPORTTILE# = "Circulation Desk Report">
<CFELSEIF #URL.REPORT# EQ "IDTD">
	<CFSET #REPORTTILE# = "InfoSys Service Desk/IDT Report">
<CFELSEIF #URL.REPORT# EQ "MGMT">
	<CFSET #REPORTTILE# = "Management Contact Report">
<CFELSE>
	<CFSET #REPORTTILE# = "Public Desk Report">
</CFIF>

<!--- 
**********************************************************************
* The following code is the Look Up Process for Public Desk Reports. *
**********************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPPUBLICDESK')>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Lookup For Web Reports - #REPORTTILE#</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>

		<CFQUERY name="LookupPublicDeskTopic" datasource="#application.type#WEBREPORTS" blockfactor="67">
		SELECT	PD.PUBLICDESKID, PD.TOPICID, T.TOPIC, PD.SUBTOPICID, ST.SUBTOPIC, PD.CONTACTTIMEID, CT.CONTACTTIME, PD.CIRCCALLORDER,
				PD.MGMTCALLORDER, T.TOPIC || ' - ' || ST.SUBTOPIC || ' - ' || CT.CONTACTTIME AS LOOKUPKEY
		FROM		PUBLICDESK PD, PDTOPIC T, PDSUBTOPIC ST, PDCONTACTTIME CT
		WHERE	(PD.TOPICID = T.TOPICID AND
				PD.SUBTOPICID = ST.SUBTOPICID AND
				PD.CONTACTTIMEID = CT.CONTACTTIMEID)
			<CFIF #URL.REPORT# EQ "CIRCD">
				AND (NOT PD.CIRCCALLORDER IS NULL OR
				 PD.PUBLICDESKID = 0)
			</CFIF>
			<CFIF #URL.REPORT# EQ "MGMT">
				AND (NOT PD.MGMTCALLORDER IS NULL OR
				 PD.PUBLICDESKID = 0)
			</CFIF>
				
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#RETURNPGM#" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=#URL.REPORT#&LOOKUPPUBLICDESK=FOUND" method="POST">
		<TR>
			<TH align="LEFT"><H4><LABEL for="PUBLICDESKID">*Select by Topic - SubTopic - Contact Time (When)</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<CFSELECT name="PUBLICDESKID" id="PUBLICDESKID" size="1" query="LookupPublicDeskTopic" value="PUBLICDESKID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
                    <INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#RETURNPGM#" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>
<!--- 
**************************************************************************************
* The following code is the Report Generation Processes for the Public Desk Reports. *
**************************************************************************************
 --->

	<CFQUERY name="GetPublicDesk" datasource="#application.type#WEBREPORTS">
		SELECT	PD.PUBLICDESKID, PD.TOPICID, T.TOPIC, PD.SUBTOPICID, ST.SUBTOPIC, PD.CONTACTTIMEID, CT.CONTACTTIME, PD.CONTACTID,
				C.CONTACTNAME, C.DEPARTMENT, C.PHONE, C.EMAIL, PD.IDTOPTIONS, PD.PUBDESKOPTIONS, PD.CIRCNOTIFY,
				PD.IDTNOTIFY, PD.CIRCCALLORDER, PD.IDTCALLORDER, PD.MGMTCALLORDER, PD.MODIFIEDBYID, CUST.FULLNAME, PD.MODIFIEDDATE,
				T.TOPIC || ' - ' || ST.SUBTOPIC AS LOOKUPKEY
		FROM		PUBLICDESK PD, PDTOPIC T, PDSUBTOPIC ST, PDCONTACTTIME CT, PDCONTACTS C, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	PD.PUBLICDESKID = <CFQUERYPARAM value="#FORM.PUBLICDESKID#" cfsqltype="CF_SQL_NUMERIC"> AND
				PD.TOPICID = T.TOPICID AND
				PD.SUBTOPICID = ST.SUBTOPICID AND
				PD.CONTACTTIMEID = CT.CONTACTTIMEID AND
				PD.CONTACTID = C. CONTACTID AND 
				PD.MODIFIEDBYID = CUST.CUSTOMERID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Web Reports - #REPORTTILE#</H1></TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=#URL.REPORT#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="left">Topic</TH>
			<TH align="left">SubTopic</TH>
		</TR>
		<TR>
			<TD align="left">#GetPublicDesk.TOPIC#</TD>
			<TD align="left">#GetPublicDesk.SUBTOPIC#</TD>
		</TR>
		<TR>
			<TH align="left">Contact Time (When)</TH>
			<TH align="left">Contact Name</TH>
		</TR>
		<TR>
			<TD align="left">#GetPublicDesk.CONTACTTIME#</TD>
			<TD align="left">#GetPublicDesk.CONTACTNAME#</TD>
		</TR>
		<TR>
			<TH align="left">Contact Department</TH>
			<TH align="left">Contact Phone</TH>
		</TR>
		<TR>
			<TD align="left">#GetPublicDesk.DEPARTMENT#</TD>
			<TD align="left">#GetPublicDesk.PHONE#</TD>
		</TR>
		<TR>
			<TH align="left">Contact E-Mail</TH>
			<TH align="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left">#GetPublicDesk.EMAIL#</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
	<CFIF #URL.REPORT# EQ "PUBD" OR #URL.REPORT# EQ "CIRCD">
		<TR>
			<TH align="left" colspan="2">Public Desk Options</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.PUBDESKOPTIONS#</TD>
		</TR>
	</CFIF>
	<CFIF #URL.REPORT# EQ "CIRCD">
		<TR>
			<TH align="left" valign="TOP" colspan="2">Circulation Notifications</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.CIRCNOTIFY#</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">Circulation Call Order</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.CIRCCALLORDER#</TD>
		</TR>
	</CFIF>
	<CFIF #URL.REPORT# EQ "IDTD">
		<TR>
			<TH align="left" colspan="2">IDT Options</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.IDTOPTIONS#</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">IDT Notifications</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.IDTNOTIFY#</TD>
		</TR>
			<TH align="left" colspan="2">IDT Call Order</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.IDTCALLORDER#</TD>
		</TR>
	</CFIF>
	<CFIF #URL.REPORT# EQ "MGMT">
		<TR>
			<TH align="left" valign="TOP" colspan="2">Management Call Order</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">#GetPublicDesk.MGMTCALLORDER#</TD>
		</TR>
	</CFIF>
		<TR>
			<TH align="left">Modified By</TH>
			<TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">#GetPublicDesk.FULLNAME#</TD>
			<TD align="left" valign="TOP">#DateFormat(GetPublicDesk.MODIFIEDDATE, "MM/DD/YYYY")#</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/publicdeskdbreport.cfm?REPORT=#URL.REPORT#" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>