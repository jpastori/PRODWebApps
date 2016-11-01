<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unmatchedswassgnrecs.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: Print UnMatched Software Assignment Records --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/unmatchedswassgnrecs.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Print UnMatched Software Assignment Records</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFSET unassignedcount = 0>
<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	DISTINCT SA.SOFTWINVENTID
	FROM		SOFTWAREASSIGNMENTS SA
	ORDER BY	SA.SOFTWINVENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TH align="center">
			<H1>Print UnMatched Software Assignment Records</H1>
		</TH>
	</TR>
</TABLE>
<BR />
<BR />

<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
</CFFORM>

<CFLOOP query = "LookupSoftwareAssignments">

	<CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE">
		SELECT	SOFTWINVENTID, TITLE
		FROM		SOFTWAREINVENTORY
		WHERE	SOFTWINVENTID = <CFQUERYPARAM value="#LookupSoftwareAssignments.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	TITLE
	</CFQUERY>

	<CFIF ListSoftwareInventory.RecordCount EQ 0>
		SOFTWARE INVENTORY ID = #LookupSoftwareAssignments.SOFTWINVENTID#
		<CFSET unassignedcount =  unassignedcount + 1>
	</CFIF>

</CFLOOP>
	<CFIF #unassignedcount# GT 0>
		<HR size="5" noshade />
		<DIV align="center"><H1>There were #unassignedcount# unmatched software assignment records found.</H1></DIV>
	<CFELSE>
		<DIV align="center"><H1>THERE WERE NO UNMATCHED SOFTWARE ASSIGNMENT RECORDS FOUND!</H1></DIV>
	</CFIF>
	
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
</CFFORM>

<CFINCLUDE template="/include/coldfusion/footer.cfm">

</CFOUTPUT>

</BODY>
</HTML>