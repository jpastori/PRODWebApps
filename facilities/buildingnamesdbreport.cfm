<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: buildingnamesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/25/2012 --->
<!--- Date in Production: 01/25/2012 --->
<!--- Module: Facilities Building Names Database Report --->
<!-- Last modified by John R. Pastori on 01/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/buildingnamesdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 25, 2012">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities Building Name Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>
<BODY>

<cfquery name="ListBuildingNames" DATASOURCE="#application.type#FACILITIES" BLOCKFACTOR="15">
	SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGABBREV
	FROM		BUILDINGNAMES
	WHERE	BUILDINGNAMEID > 0
	ORDER BY	BUILDINGNAME
</cfquery>

<cfoutput>
<TABLE width="100%" BORDER="3">
	<TR align="center">
		<TD align="center"><H1>Facilities - Building Names Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="4">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListBuildingNames.RecordCount# Building Name records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
		<TH ALIGN="left">Building Name</TH>
		<TH ALIGN="left">Building Code</TH>
          <TH align="left">Building Abbreviation</TH>
          <TH align="left">Building Name Record Keys</TH>
	</TR>

<CFLOOP QUERY="ListBuildingNames">
	<TR>
		<TD ALIGN="left">#ListBuildingNames.BUILDINGNAME#</TD>
		<TD ALIGN="left">#ListBuildingNames.BUILDINGCODE#</TD>
          <TD ALIGN="left">#ListBuildingNames.BUILDINGABBREV#</TD>
          <TD ALIGN="left">#ListBuildingNames.BUILDINGNAMEID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="4"><H2>#ListBuildingNames.RecordCount# Building Name records were selected.<H2></H2></H2></TH>
	</TR>
	<TR>
<cfform action="/#application.type#apps/facilities/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="4">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</cfform>
	</TR>
	<TR>
		<TD ALIGN="left" COLSPAN="4">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
<BR /><BR />
</cfoutput>
</BODY>
</HTML>