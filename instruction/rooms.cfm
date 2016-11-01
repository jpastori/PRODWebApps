<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: rooms.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/28/2009 --->
<!--- Date in Production: 01/28/2009 --->
<!--- Module: Add/Modify/Delete Information to Instruction - Rooms --->
<!-- Last modified by John R. Pastori on 01/28/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/rooms.cfm">
<CFSET CONTENT_UPDATED = "January 28, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Instruction - Rooms</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Instruction - Rooms</TITLE>
	</CFIF>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Instruction - Orientation Statistics";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.ROOM.ROOMNAME.value == "" || document.ROOM.ROOMNAME.value == " ") {
			alertuser (document.ROOM.ROOMNAME.name +  ",  A Room Name MUST be entered!");
			document.ROOM.ROOMNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.ROOMID.selectedIndex == "0") {
			alertuser ("A Room Name MUST be selected!");
			document.LOOKUP.ROOMID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPROOMS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.ROOMID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ROOM.ROOMNAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListRooms" datasource="#application.type#INSTRUCTION" blockfactor="19">
	SELECT	ROOMID, ROOMNAME
	FROM		ROOMS
	ORDER BY	ROOMNAME
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************
* The following code is the ADD Process for Rooms. *
****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Instruction - Rooms</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#INSTRUCTION">
			SELECT	MAX(ROOMID) AS MAX_ID
			FROM		ROOMS
		</CFQUERY>
		<CFSET FORM.ROOMID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="ROOMID" secure="NO" value="#FORM.ROOMID#">
		<CFQUERY name="AddRoomsID" datasource="#application.type#INSTRUCTION">
			INSERT INTO	ROOMS (ROOMID)
			VALUES		(#val(Cookie.ROOMID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Rooms Key &nbsp; = &nbsp; #FORM.ROOMID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/instruction/processrooms.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRooms" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ROOM" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processrooms.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="ROOMNAME">*Room Name:</label></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="ROOMNAME" id="ROOMNAME" value="" align="LEFT" required="No" size="100" tabindex="2"></TD>
		</TR>
	
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessRooms" value="ADD" tabindex="3" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/instruction/processrooms.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessRooms" value="CANCELADD" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*******************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Rooms. *
*******************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Instruction - Rooms </H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPROOMS')>
		<TR>
			<TH align="center">Rooms Key &nbsp; = &nbsp; #FORM.ROOMID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPROOMS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/instruction/rooms.cfm?PROCESS=#URL.PROCESS#&LOOKUPROOMS=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="ROOMID">*Room Name:</label></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="ROOMID" id="ROOMID" size="1" query="ListRooms" value="ROOMID" display="ROOMNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/instruction/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*******************************************************************
* The following code is the Modify and Delete Processes for Rooms.*
*******************************************************************
 --->

		<CFQUERY name="GetRooms" datasource="#application.type#INSTRUCTION">
			SELECT	ROOMID, ROOMNAME
			FROM		ROOMS
			WHERE	ROOMID = <CFQUERYPARAM value="#FORM.ROOMID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ROOMNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/instruction/rooms.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRooms" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="ROOM" onsubmit="return validateReqFields();" action="/#application.type#apps/instruction/processrooms.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="ROOMID" secure="NO" value="#FORM.ROOMID#">
				<TH align="left"><H4><LABEL for="ROOMNAME">*Room Name:</label></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="ROOMNAME" id="ROOMNAME" value="#GetRooms.ROOMNAME#" align="LEFT" required="No" size="100" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRooms" value="MODIFY" tabindex="3" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessRooms" value="DELETE" tabindex="4" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/instruction/rooms.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessRooms" value="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>