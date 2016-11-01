<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: archivelocationreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Hardware Inventory - Archive Location Report --->
<!-- Last modified by John R. Pastori on 07/12/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/archivelocationdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Hardware Inventory - Archive Location Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css">
</HEAD>
<BODY>

<CFQUERY name="ListArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.LOCATIONNAME, LOC.ARCHIVELOCATION, LOC.MODIFIEDBYID, CUST.CUSTOMERID, CUST.FULLNAME, LOC.MODIFIEDDATE
	FROM		LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	LOC.LOCATIONID > 0 AND
     		LOC.MODIFIEDBYID = CUST.CUSTOMERID AND
     		LOC.ARCHIVELOCATION = 'YES'
	ORDER BY	LOC.LOCATIONNAME
</CFQUERY>

<CFOUTPUT>
<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>IDT Hardware Inventory - Archive Location Report</H1></TD>
	</TR>
</TABLE>
<BR>
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1"><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#ListArchiveLocations.RecordCount# Archive Location records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Location Name</TH>
		<TH align="left">Location Key</TH>
          <TH align="left">Modified-By</TH>
		<TH align="left">Date Modified</TH>
	</TR>

<CFLOOP query="ListArchiveLocations">
	<TR>
		<TD align="left">#ListArchiveLocations.LOCATIONNAME#</TD>
		<TD align="left">#ListArchiveLocations.LOCATIONID#</TD>
          <TD align="left">#ListArchiveLocations.FULLNAME#</TD>
		<TD align="left">#DateFormat(ListArchiveLocations.MODIFIEDDATE, "MM/DD/YYYY")#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="4"><H2>#ListArchiveLocations.RecordCount# Archive Location records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2"><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="4">
<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR><BR>
</CFOUTPUT>
</BODY>
</HTML>