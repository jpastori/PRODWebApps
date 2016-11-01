<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: groups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data Groups --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/groups.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Groups</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Groups</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.GROUPS.GROUPNAME.value == "" || document.GROUPS.GROUPNAME.value == " ") {
			alertuser (document.GROUPS.GROUPNAME.name +  ",  A Group Name MUST be entered!");
			document.GROUPS.GROUPNAME.focus();
			return false;
		}
	
		if (document.GROUPS.MANAGEMENTID.selectedIndex == "0") {
			alertuser (document.GROUPS.MANAGEMENTID.name +  ",  A Management Name MUST be selected!");
			document.GROUPS.MANAGEMENTID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.GROUPID.selectedIndex == "0") {
			alertuser ("A Group Name MUST be selected!");
			document.LOOKUP.GROUPID.focus();
			return false;
		}
	}


	function setDelete() {
		document.GROUPS.PROCESSGROUPS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPGROUP') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.GROUPID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.GROUPS.GROUPNAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code is use by ALL Processes in Groups. *
*********************************************************
 --->

<CFQUERY name="ListGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="7">
	SELECT	GROUPID, GROUPNAME, MANAGEMENTID
	FROM		GROUPS
	ORDER BY	GROUPID
</CFQUERY>

<CFQUERY name="ListManagement" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, DEPTCHAIR, ALLOWEDTOAPPROVE
	FROM		CUSTOMERS
	WHERE	DEPTCHAIR = 'YES' AND
			ALLOWEDTOAPPROVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
*****************************************************
* The following code is the ADD Process for Groups. *
*****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Groups</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(GROUPID) AS MAX_ID
			FROM		GROUPS
		</CFQUERY>
		<CFSET FORM.GROUPID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="GROUPID" secure="NO" value="#FORM.GROUPID#">
		<CFQUERY name="AddGroupsID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	GROUPS (GROUPID)
			VALUES		(#val(Cookie.GROUPID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Groups Key &nbsp; = &nbsp; #FORM.GROUPID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processgroupsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSGROUPS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="GROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processgroupsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="GROUPNAME">*Group Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="MANAGEMENTID">*Management Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="GROUPNAME" id="BGROUPNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left" nowrap>
				<SELECT name="MANAGEMENTID" id="MANAGEMENTID" tabindex="3">
					<OPTION value="0"> MANAGEMENT</OPTION>
					<CFLOOP query="ListManagement">
						<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSGROUPS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processgroupsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSGROUPS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
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
********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Groups. *
********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Shared Data - Groups</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPGROUP')>
		<TR>
			<TH align="center">Groups Key &nbsp; = &nbsp; #FORM.GROUPID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPGROUP')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/groups.cfm?PROCESS=#URL.PROCESS#&LOOKUPGROUP=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="GROUPID">*Group Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroups" value="GROUPID" display="GROUPNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD  align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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
******************************************************************
* The following code is the Modify and Delete Processes for Group*
******************************************************************
 --->

		<CFQUERY name="GetGroups" datasource="#application.type#LIBSHAREDDATA">
			SELECT	GROUPID, GROUPNAME, MANAGEMENTID
			FROM		GROUPS
			WHERE	GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	GROUPID
		</CFQUERY>

		<CFQUERY name="LookupManagement" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, FULLNAME, DEPTCHAIR, ALLOWEDTOAPPROVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetGroups.MANAGEMENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					DEPTCHAIR = 'YES' AND
					ALLOWEDTOAPPROVE = 'YES'
			ORDER BY	FULLNAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/groups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="GROUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processgroupsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="GROUPID" secure="NO" value="#FORM.GROUPID#">
				<TH align="left"><H4><LABEL for="GROUPNAME">*Group Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="MANAGEMENTID">*Management Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="GROUPNAME" id="GROUPNAME" value="#GetGroups.GROUPNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left" nowrap>
					<SELECT name="MANAGEMENTID" id="MANAGEMENTID" tabindex="3">
						<OPTION value="0"> MANAGEMENT</OPTION>
						<OPTION selected value="#LookupManagement.CUSTOMERID#"> #LookupManagement.FULLNAME#</OPTION>
						<CFLOOP query="ListManagement">
							<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
						</CFLOOP>
					</SELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSGROUPS" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
				</TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="5" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/groups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
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