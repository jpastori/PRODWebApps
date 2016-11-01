<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unitsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify Information to Shared Data Units --->
<!-- Last modified by John R. Pastori on 02/22/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/unitsinfo.cfm">
<CFSET CONTENT_UPDATED = "February 22, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Units</TITLE>
	<CFELSE>
		<TITLE>Modify Information to Shared Data - Units</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Library Shared Data - Units Info";

	if(window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields1() {
		if (document.UNITS.UNITNAME.value == "" || document.UNITS.UNITNAME.value == " ") {
			alertuser (document.UNITS.UNITNAME.name +  ",  A Unit Name MUST be entered!");
			document.UNITS.UNITNAME.focus();
			return false;
		}

		if (document.UNITS.GROUPID.selectedIndex == "0" && (document.UNITS.GROUPNAME.value == ""
		 || document.UNITS.GROUPNAME.value == " ")) {
			alertuser (document.UNITS.GROUPID.name +  ",  A Group Name MUST be selected!");
			document.UNITS.GROUPID.focus();
			return false;
		}

		if (document.UNITS.GROUPID.selectedIndex > "0" && document.UNITS.GROUPNAME.value != "") {
			alertuser (document.UNITS.GROUPID.name +  ",  Only one Group Name can be entered!");
			document.UNITS.GROUPID.focus();
			return false;
		}

		if (document.UNITS.DEPARTMENTID.selectedIndex == "0" && (document.UNITS.DEPARTMENTNAME.value == ""
		 || document.UNITS.DEPARTMENTNAME.value == " ")) {
			alertuser (document.UNITS.DEPARTMENTID.name +  ",  A Department Name MUST be selected!");
			document.UNITS.DEPARTMENTID.focus();
			return false;
		}

		if (document.UNITS.DEPARTMENTID.selectedIndex > "0" && document.UNITS.DEPARTMENTNAME.value != "") {
			alertuser (document.UNITS.DEPARTMENTID.name +  ",  Only one Department Name can be entered!");
			document.UNITS.DEPARTMENTID.focus();
			return false;
		}

		if (document.UNITS.CAMPUSMAILCODEID.selectedIndex == "0" && (document.UNITS.CAMPUSMAILCODE.value == ""
		 || document.UNITS.CAMPUSMAILCODE.value == " ")) {
			alertuser (document.UNITS.CAMPUSMAILCODEID.name +  ",  A Campus Mail Code MUST be selected!");
			document.UNITS.CAMPUSMAILCODEID.focus();
			return false;
		}

		if (document.UNITS.CAMPUSMAILCODEID.selectedIndex > "0" && document.UNITS.CAMPUSMAILCODE.value != "") {
			alertuser (document.UNITS.CAMPUSMAILCODEID.name +  ",  Only one Campus Mail Code can be entered!");
			document.UNITS.CAMPUSMAILCODEID.focus();
			return false;
		}
	}

	function validateReqFields2() {
		if (document.UNITS.UNITNAME.value == "" || document.UNITS.UNITNAME.value == " ") {
			alertuser (document.UNITS.UNITNAME.name +  ",  A Unit Name MUST be entered!");
			document.UNITS.UNITNAME.focus();
			return false;
		}

		if (document.UNITS.GROUPID.selectedIndex == "0") {
			alertuser (document.UNITS.GROUPID.name +  ",  A Group Name MUST be selected!");
			document.UNITS.GROUPID.focus();
			return false;
		}

		if (document.UNITS.DEPARTMENTID.selectedIndex == "0") {
			alertuser (document.UNITS.DEPARTMENTID.name +  ",  A Department Name MUST be selected!");
			document.UNITS.DEPARTMENTID.focus();
			return false;
		}

		if (document.UNITS.CAMPUSMAILCODEID.selectedIndex == "0") {
			alertuser (document.UNITS.CAMPUSMAILCODEID.name +  ",  A Campus Mail Code MUST be selected!");
			document.UNITS.CAMPUSMAILCODEID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.UNITID.selectedIndex == "0") {
			alertuser ("A Unit Name MUST be selected!");
			document.LOOKUP.UNITID.focus();
			return false;
		}
	}


	function setDelete() {
		document.UNITS.PROCESSUNITS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPUNIT') AND URL.PROCESS EQ "MODIFY">
	<CFSET CURSORFIELD = "document.LOOKUP.UNITID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.UNITS.UNITNAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code is for ALL Processes in Unit Info. *
*********************************************************
 --->
 
<CFQUERY name="ListCampusMailCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
	SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
	FROM		CAMPUSMAILCODES
	ORDER BY	CAMPUSMAILCODEID
</CFQUERY>

<CFQUERY name="ListDepartments" datasource="#application.type#LIBSHAREDDATA" blockfactor="12">
	SELECT	DEPARTMENTID, DEPARTMENTNAME
	FROM		DEPARTMENTS
	ORDER BY	DEPARTMENTNAME
</CFQUERY>

<CFQUERY name="ListGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="7">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPS
	ORDER BY	GROUPNAME
</CFQUERY>

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID, ACTIVEUNIT
	FROM		UNITS
	ORDER BY	UNITNAME
</CFQUERY>

<CFQUERY name="ListSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, UNITHEAD, ALLOWEDTOAPPROVE, ACTIVE
	FROM		CUSTOMERS
	WHERE	((UNITHEAD = 'YES' OR
			DEPTCHAIR = 'YES') AND
			(ALLOWEDTOAPPROVE = 'YES' AND
               ACTIVE = 'YES'))
	ORDER BY	FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
****************************************************
* The following code is the ADD Process for Units. *
****************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Shared Data - Units</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(UNITID) AS MAX_ID
			FROM		UNITS
		</CFQUERY>
		<CFSET FORM.UNITID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="UNITID" secure="NO" value="#FORM.UNITID#">
		<CFQUERY name="AddUnitsID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	UNITS (UNITID)
			VALUES		(#val(Cookie.UNITID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<TR>
			<TH align="center">Units Key &nbsp; = &nbsp; #FORM.UNITID#</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processunitsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSUNITS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="UNITS" onsubmit="return validateReqFields1();" action="/#application.type#apps/libshareddata/processunitsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="UNITNAME">*Unit Name</LABEL></H4></TH>
			<TH align="left"><LABEL for="SUPERVISORID">Supervisor</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="UNITNAME" id="UNITNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
			<TD align="left" nowrap>
				<SELECT name="SUPERVISORID" id="SUPERVISORID" tabindex="3">
					<OPTION value="0"> SUPERVISOR</OPTION>
					<CFLOOP query="ListSupervisors">
						<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="ACTIVEUNIT">Active Unit?</LABEL></TH>
			<TH align="left"><H4><LABEL for="DEPARTMENTID">*Select Department Name</LABEL><LABEL for="DEPARTMENTNAME">or Type Department Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="ACTIVEUNIT" id="ACTIVEUNIT" size="1" tabindex="4">
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="0" required="No" tabindex="5"></CFSELECT><BR />
				<CFINPUT type="Text" name="DEPARTMENTNAME" id="DEPARTMENTNAME" value="" align="LEFT" required="No" size="30" tabindex="6">
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="GROUPID">*Select Group Name</LABEL><LABEL for="GROUPNAME">or Type Group Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="CAMPUSMAILCODEID">*Select Campus Mail Code</LABEL><LABEL for="CAMPUSMAILCODE">or Type Campus Mail Code</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroups" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="7"></CFSELECT><BR />
				<CFINPUT type="Text" name="GROUPNAME" id="GROUPNAME" value="" align="LEFT" required="No" size="30" tabindex="8">
			</TD>
			<TD>
				<CFSELECT name="CAMPUSMAILCODEID" id="CAMPUSMAILCODEID" size="1" query="ListCampusMailCodes" value="CAMPUSMAILCODEID" display="CAMPUSMAILCODE" selected="0" required="No" tabindex="9"></CFSELECT><BR />
				<CFINPUT type="Text" name="CAMPUSMAILCODE" id="CAMPUSMAILCODE" value="" align="LEFT" required="No" size="30" tabindex="10">
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSUNITS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="11" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processunitsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSUNITS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="12" /><BR />
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
* The following code is the Look Up Process for Modifying Units. *
******************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify Information to Shared Data - Units</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required! </H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPUNIT')>
		<TR>
			<TH align="center">Units Key &nbsp; = &nbsp; #FORM.UNITID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPUNIT')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPUNIT=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="UNITID">*Unit Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT">
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
*******************************************************
* The following code is the Modify Process for Units. *
*******************************************************
 --->

		<CFQUERY name="GetUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	UNITID, UNITNAME, CAMPUSMAILCODEID, GROUPID, DEPARTMENTID, SUPERVISORID, ACTIVEUNIT
			FROM		UNITS
			WHERE	UNITS.UNITID = <CFQUERYPARAM value="#FORM.UNITID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	UNITNAME
		</CFQUERY>

		<CFQUERY name="LookupSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, FULLNAME, UNITHEAD, ALLOWEDTOAPPROVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#GetUnits.SUPERVISORID#" cfsqltype="CF_SQL_NUMERIC"> AND
					(UNITHEAD = 'YES' OR
					DEPTCHAIR = 'YES') AND
					(ALLOWEDTOAPPROVE = 'YES') 
			ORDER BY	FULLNAME
</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="UNITS" onsubmit="return validateReqFields2();" action="/#application.type#apps/libshareddata/processunitsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="UNITID" secure="NO" value="#FORM.UNITID#">
				<TH align="left"><H4><LABEL for="UNITNAME">*Unit Name</LABEL></H4></TH>
				<TH align="left"><LABEL for="SUPERVISORID">Supervisor</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="UNITNAME" id="UNITNAME" value="#GetUnits.UNITNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
				<TD align="left" nowrap>
					<SELECT name="SUPERVISORID" id="SUPERVISORID" tabindex="3">
						<OPTION value="0"> SUPERVISOR</OPTION>
						<OPTION selected value="#LookupSupervisors.CUSTOMERID#"> #LookupSupervisors.FULLNAME#</OPTION>
						<CFLOOP query="ListSupervisors">
							<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
						</CFLOOP>
					</SELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="ACTIVEUNIT">Active Unit?</LABEL></TH>
				<TH align="left"><H4><LABEL for="DEPARTMENTID">*Department Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="ACTIVEUNIT" id="ACTIVEUNIT" size="1" tabindex="4">
						<OPTION selected value="#GetUnits.ACTIVEUNIT#">#GetUnits.ACTIVEUNIT#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT><BR />
                         <COM>Units are either active or inactive.  There is no Delete process because the unit exists in previous years' Purchasing information.</COM>
				</TD>
				<TD align="left" nowrap><CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="ListDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="#GetUnits.DEPARTMENTID#" required="No" tabindex="5"></CFSELECT></TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="GROUPID">*Group Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="CAMPUSMAILCODEID">*Campus Mail Code</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap><CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroups" value="GROUPID" display="GROUPNAME" selected="#GetUnits.GROUPID#" required="No" tabindex="6"></CFSELECT></TD>
				<TD align="left" nowrap><CFSELECT name="CAMPUSMAILCODEID" id="CAMPUSMAILCODEID" size="1" query="ListCampusMailCodes" value="CAMPUSMAILCODEID" display="CAMPUSMAILCODE" selected="#GetUnits.CAMPUSMAILCODEID#" required="No" tabindex="7"></CFSELECT></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSUNITS" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="8" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="9" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="10" /><BR />
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