<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdcontactsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Web Reports - Public Desk Contacts Report --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdcontactsdbreport.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Public Desk Contacts Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<!--- 
**********************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Public Desk Contacts Report. *
**********************************************************************************************************
 --->

<cfquery name="ListPDContacts" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="30">
	SELECT	CONTACTID, CONTACTNAME, DEPARTMENT, PHONE, EMAIL
	FROM		PDCONTACTS
	WHERE	CONTACTID > 0
	ORDER BY	CONTACTID
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Web Reports - Public Desk Contacts Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="center">
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListPDContacts.RecordCount# Public Desk Contact records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="center">Contact Name</TH>
		<TH ALIGN="center">Department</TH>
		<TH ALIGN="center">Phone</TH>
		<TH ALIGN="center">E-Mail</TH>
	</TR>

<CFLOOP QUERY="ListPDContacts">
	<TR>
		<TD ALIGN="LEFT">#ListPDContacts.CONTACTNAME#</TD>
		<TD ALIGN="LEFT">#ListPDContacts.DEPARTMENT#</TD>
		<TD ALIGN="center">#ListPDContacts.PHONE#</TD>
		<TD ALIGN="LEFT">#ListPDContacts.EMAIL#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListPDContacts.RecordCount# Public Desk Contact records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/webreports/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD COLSPAN="4">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>