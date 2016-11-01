<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: dbsystemsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: Add/Modify/Delete Information to Library Security - Database Systems --->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libsecurity/dbsystemsinfo.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Library Security - Database Systems</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Library Security - Database Systems</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Library Security  - Database Systems";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.DBSYSTEMS.DBSYSTEMNUMBER.value == "" || document.DBSYSTEMS.DBSYSTEMNUMBER.value == " ") {
			alertuser (document.DBSYSTEMS.DBSYSTEMNUMBER.name +  ",  A Database System Number MUST be entered!");
			document.DBSYSTEMS.DBSYSTEMNUMBER.focus();
			return false;
		}

		if (document.DBSYSTEMS.DBSYSTEMNAME.value == "" || document.DBSYSTEMS.DBSYSTEMNAME.value == " ") {
			alertuser (document.DBSYSTEMS.DBSYSTEMNAME.name +  ",  A Database System Name MUST be entered!");
			document.DBSYSTEMS.DBSYSTEMNAME.focus();
			return false;
		}
		
		if (document.DBSYSTEMS.DBSYSTEMDIRECTORY.value == "" || document.DBSYSTEMS.DBSYSTEMDIRECTORY.value == " ") {
			alertuser (document.DBSYSTEMS.DBSYSTEMDIRECTORY.name +  ",  A Database System Directory MUST be entered!");
			document.DBSYSTEMS.DBSYSTEMDIRECTORY.focus();
			return false;
		}

		if (document.DBSYSTEMS.DBSYSTEMGROUP.selectedIndex == "0") {
			alertuser (document.DBSYSTEMS.DBSYSTEMGROUP.name +  ",  A Database System Group MUST be chosen!");
			document.DBSYSTEMS.DBSYSTEMGROUP.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.DBSYSTEMID.selectedIndex == "0") {
			alertuser ("A Database System Name MUST be selected!");
			document.LOOKUP.DBSYSTEMID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDBSYSTEM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.DBSYSTEMID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.DBSYSTEMS.DBSYSTEMNUMBER.focus()">
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

<CFQUERY name="ListDBSystems" datasource="#application.type#LIBSECURITY" blockfactor="13">
	SELECT	DBSYSTEMID, DBSYSTEMNAME
	FROM		DBSYSTEMS
	ORDER BY	DBSYSTEMNAME
</CFQUERY>

<!--- 
**************************************************************
* The following code is the ADD Process for Database Systems *
**************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Library Security - Database Systems</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSECURITY">
		SELECT	MAX(DBSYSTEMID) AS MAX_ID
		FROM		DBSYSTEMS
	</CFQUERY>
	<CFSET FORM.DBSYSTEMID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="DBSYSTEMID" secure="NO" value="#FORM.DBSYSTEMID#">
	<CFQUERY name="AddDBSystemsID" datasource="#application.type#LIBSECURITY">
		INSERT INTO	DBSYSTEMS (DBSYSTEMID)
		VALUES		(#val(Cookie.DBSYSTEMID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Database System Key &nbsp; = &nbsp; #FORM.DBSYSTEMID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
			
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processdbsystemsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessDBSystems" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="DBSYSTEMS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processdbsystemsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="DBSYSTEMNUMBER">*Database System Number</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DBSYSTEMNAME">*Database System</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="DBSYSTEMNUMBER" id="DBSYSTEMNUMBER" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="DBSYSTEMNAME" id="DBSYSTEMNAME" value="" align="LEFT" required="No" size="50" tabindex="3"></TD>
		</TR>
          <TR>
			<TH align="left"><H4><LABEL for="DBSYSTEMDIRECTORY">*Database System Directory</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DBSYSTEMGROUP">*Database System Group</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="DBSYSTEMDIRECTORY" id="DBSYSTEMDIRECTORY" value="" align="LEFT" required="No" size="50" maxlength="30" tabindex="4"></TD>
			<TD align="left" nowrap>
				<CFSELECT name="DBSYSTEMGROUP" id="DBSYSTEMGROUP" size="1" tabindex="5">
                    	<OPTION value=" Select A Group">Select A Group</OPTION>
					<OPTION value="IDT">IDT</OPTION>
					<OPTION value="LIB">LIB</OPTION>
                         <OPTION value="SEC">SEC</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessDBSystems" value="ADD" tabindex="6" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libsecurity/processdbsystemsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessDBSystems" value="CANCELADD" tabindex="7" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Database Systems *
*****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Library Security - Database Systems</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPDBSYSTEM')>
		<TR>
				<TH align="center">Database System Key &nbsp; = &nbsp; #FORM.DBSYSTEMID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPDBSYSTEM')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPDBSYSTEM=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="DBSYSTEMID">*Database System:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="DBSYSTEMID" id="DBSYSTEMID" size="1" query="ListDBSystems" value="DBSYSTEMID" display="DBSYSTEMNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD  align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
******************************************************************************
* The following code is the Modify and Delete Processes for Database Systems *
******************************************************************************
 --->

		<CFQUERY name="GetDBSystems" datasource="#application.type#LIBSECURITY">
			SELECT	DBSYSTEMID, DBSYSTEMNUMBER, DBSYSTEMNAME, DBSYSTEMDIRECTORY, DBSYSTEMGROUP
			FROM		DBSYSTEMS
			WHERE	DBSYSTEMID = <CFQUERYPARAM value="#FORM.DBSYSTEMID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DBSYSTEMNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessDBSystems" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="DBSYSTEMS" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processdbsystemsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="DBSYSTEMID" secure="NO" value="#FORM.DBSYSTEMID#">
				<TH align="left"><H4><LABEL for="DBSYSTEMNUMBER">*Database System Number</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="DBSYSTEMNAME">*Database System</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="DBSYSTEMNUMBER" id="DBSYSTEMNUMBER" value="#GetDBSystems.DBSYSTEMNUMBER#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="DBSYSTEMNAME" id="DBSYSTEMNAME" value="#GetDBSystems.DBSYSTEMNAME#" align="LEFT" required="No" size="50" tabindex="3"></TD>
			</TR>
               <TR>
			<TH align="left"><H4><LABEL for="DBSYSTEMDIRECTORY">*Database System Directory</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="DBSYSTEMGROUP">*Database System Group</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="DBSYSTEMDIRECTORY" id="DBSYSTEMDIRECTORY" value="#GetDBSystems.DBSYSTEMDIRECTORY#" align="LEFT" required="No" size="50" maxlength="30" tabindex="4"></TD>
			<TD align="left" nowrap>
				<CFSELECT name="DBSYSTEMGROUP" id="DBSYSTEMGROUP" size="1" tabindex="5">
                         <OPTION value=" Select A Group">Select A Group</OPTION>
                         <OPTION selected value="#GetDBSystems.DBSYSTEMGROUP#">#GetDBSystems.DBSYSTEMGROUP#</OPTION>
					<OPTION value="IDT">IDT</OPTION>
					<OPTION value="LIB">LIB</OPTION>
                         <OPTION value="SEC">SEC</OPTION>
				</CFSELECT>
			</TD>
		</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessDBSystems" value="MODIFY" tabindex="6" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessDBSystems" value="DELETE" tabindex="7" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libsecurity/dbsystemsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessDBSystems" value="Cancel" tabindex="8" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
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
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>