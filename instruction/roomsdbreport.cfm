<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: roomsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/08/2007 --->
<!--- Date in Production: 10/08/2007 --->
<!--- Module: Instruction - Rooms Report --->
<!-- Last modified by John R. Pastori on 10/08/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/roomsdbreport.cfm">
<CFSET CONTENT_UPDATED = "October 08, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction - Rooms Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFQUERY name="ListRooms" datasource="#application.type#INSTRUCTION" blockfactor="18">
	SELECT	ROOMID, ROOMNAME
	FROM		ROOMS
	WHERE	ROOMID > 0
	ORDER BY	ROOMNAME
</CFQUERY>

<CFOUTPUT>
<TABLE width="100%" border="3">
	<TR align="center">
		<TD align="center"><H1>Instruction - Rooms Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER"><H2>#ListRooms.RecordCount# Room records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Room Name</TH>
	</TR>

<CFLOOP query="ListRooms">
	<TR>
		<TD align="left">#ListRooms.ROOMNAME#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER"><H2>#ListRooms.RecordCount# Room records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
		<TD align="left">
			<INPUT type="submit" value="Cancel" tabindex="2" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>