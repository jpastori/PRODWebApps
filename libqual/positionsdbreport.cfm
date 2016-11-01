<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: positionsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: LibQual - Positions Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/positionsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual - Positions Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<cfoutput>

<cfquery name="ListPositions" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="5">
	SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME
	FROM		LQPOSITIONS
	WHERE	POSITIONID > 0
	ORDER BY	POSITIONNAME
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>LibQual - Positions Report</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="LEFT">
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListPositions.RecordCount# Position records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="CENTER">LIBQUAL Positions ID</TH>
		<TH ALIGN="LEFT">Positions Name</TH>
	</TR>

<CFLOOP QUERY="ListPositions">
	<TR>
		<TD ALIGN="CENTER">#ListPositions.LIBQUALPOSITIONID#</TD>
		<TD ALIGN="LEFT">#ListPositions.POSITIONNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="2"><H2>#ListPositions.RecordCount# Position records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="2">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD COLSPAN="2">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>