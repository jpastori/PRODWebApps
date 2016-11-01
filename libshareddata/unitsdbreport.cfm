<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unitsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Units Report --->
<!-- Last modified by John R. Pastori on 08/21/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/unitsdbreport.cfm">
<CFSET CONTENT_UPDATED = "August 21, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data - Units Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Shared Data";
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPUNIT')>
	<CFSET CURSORFIELD = "document.LOOKUP.UNITID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**************************************************************
* The following code is the Look Up Process for Unit Reports *
**************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPUNIT")>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	UNITID, UNITNAME, ACTIVEUNIT, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="7">
		SELECT	GROUPID, GROUPNAME, MANAGEMENTID
		FROM		GROUPS
		ORDER BY	GROUPNAME
	</CFQUERY>
     
     <CFQUERY name="LookupDepartments" datasource="#application.type#LIBSHAREDDATA" blockfactor="12">
		SELECT	DEPARTMENTID, DEPARTMENTNAME
		FROM		DEPARTMENTS
		ORDER BY	DEPARTMENTID
	</CFQUERY>

	<CFQUERY name="ListSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, FULLNAME, UNITHEAD, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	(UNITHEAD = 'YES' OR
				DEPTCHAIR = 'YES') AND
				(ALLOWEDTOAPPROVE = 'YES' AND
				ACTIVE = 'YES') 
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="ListManagement" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, FULLNAME, DEPTCHAIR, ALLOWEDTOAPPROVE
		FROM		CUSTOMERS
		WHERE	DEPTCHAIR = 'YES' AND
				ALLOWEDTOAPPROVE = 'YES' AND
				ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Unit Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center"><H2>Select from the drop down boxes or type in Unit IDs to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     	
     <FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/libshareddata/unitsdbreport.cfm?LOOKUPUNIT=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">
				Select (1) Unit Name</LABEL> or <LABEL for="UNITNUMBER">enter (2) a 
				series of Unit Numbers separated <BR>&nbsp;by commas,NO spaces.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEGROUPID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="GROUPID">Group</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="3"></CFSELECT>
				<CFINPUT type="Text" name="UNITNUMBER" id="UNITNUMBER" value="" required="No" size="20" maxlength="30" tabindex="4">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEGROUPID" id="NEGATEGROUPID" value="" align="LEFT" required="No" tabindex="5">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="LookupGroups" value="GROUPID" display="GROUPNAME" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
			<TH align="LEFT" width="45%">
				<LABEL for="ACTIVEUNIT">Active Unit?</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDEPARTMENTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DEPARTMENTID">Department Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="ACTIVEUNIT" id="ACTIVEUNIT" size="1" tabindex="7">
					<OPTION value="Select an Option">Select an Option</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDEPARTMENTID" id="NEGATEDEPARTMENTID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="DEPARTMENTID" id="DEPARTMENTID" size="1" query="LookupDepartments" value="DEPARTMENTID" display="DEPARTMENTNAME" selected="0" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESUPERVISORID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SUPERVISORID">Supervisor</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMANAGEMENTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MANAGEMENTID">Management</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESUPERVISORID" id="NEGATESUPERVISORID" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<SELECT name="SUPERVISORID" id="SUPERVISORID" tabindex="11">
					<OPTION value="0"> SUPERVISOR</OPTION>
					<CFLOOP query="ListSupervisors">
						<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMANAGEMENTID" id="NEGATEMANAGEMENTID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
				<SELECT name="MANAGEMENTID" id="MANAGEMENTID" tabindex="13">
					<OPTION value="0"> MANAGEMENT</OPTION>
					<CFLOOP query="ListManagement">
						<OPTION value="#CUSTOMERID#"> #FULLNAME#</OPTION>
					</CFLOOP>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="left" colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="14" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="15" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************
* The following code is the Shared Data - Units  Report Generation Process. *
*****************************************************************************
 --->

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = "!=">
	</CFIF>

	<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	U.UNITID, U.UNITNAME, CMC.CAMPUSMAILCODE, U.GROUPID, G.GROUPNAME, U.DEPARTMENTID, DEPTS.DEPARTMENTNAME, U.SUPERVISORID,
				U.ACTIVEUNIT, SUPVR.CUSTOMERID, SUPVR.FULLNAME AS SUPVRNAME, G.MANAGEMENTID, MGMT.CUSTOMERID, MGMT.FULLNAME AS MGMTNAME
		FROM		UNITS U, CAMPUSMAILCODES CMC, GROUPS G, DEPARTMENTS DEPTS, CUSTOMERS SUPVR, CUSTOMERS MGMT
		WHERE	(U.UNITID > 0 AND
				U.CAMPUSMAILCODEID = CMC.CAMPUSMAILCODEID AND
				U.GROUPID = G.GROUPID AND
				U.DEPARTMENTID = DEPTS.DEPARTMENTID AND
				U.SUPERVISORID = SUPVR.CUSTOMERID AND
				G.MANAGEMENTID = MGMT.CUSTOMERID) AND 
				(
		<CFIF #FORM.UNITID# GT 0>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT U.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			<CFELSE>
				U.UNITID = #val(FORM.UNITID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF NOT #FORM.UNITNUMBER# EQ ''>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT U.UNITID IN (#FORM.UNITNUMBER#) #LOGICANDOR#
			<CFELSE>
				U.UNITID IN (#FORM.UNITNUMBER#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.GROUPID# GT 0>
			<CFIF IsDefined("FORM.NEGATEGROUPID")>
				NOT U.GROUPID = #val(FORM.GROUPID)# #LOGICANDOR#
			<CFELSE>
				U.GROUPID = #val(FORM.GROUPID)# #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF #FORM.DEPARTMENTID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDEPARTMENTID")>
				NOT U.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			<CFELSE>
				U.DEPARTMENTID = #val(FORM.DEPARTMENTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SUPERVISORID# GT 0>
			<CFIF IsDefined("FORM.NEGATESUPERVISORID")>
				NOT U.SUPERVISORID = #val(FORM.SUPERVISORID)# #LOGICANDOR#
			<CFELSE>
				U.SUPERVISORID = #val(FORM.SUPERVISORID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MANAGEMENTID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMANAGEMENTID")>
				NOT G.MANAGEMENTID = #val(FORM.MANAGEMENTID)# #LOGICANDOR#
			<CFELSE>
				G.MANAGEMENTID = #val(FORM.MANAGEMENTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

			<CFIF #FORM.ACTIVEUNIT# NEQ "Select an Option">
				U.ACTIVEUNIT = '#FORM.ACTIVEUNIT#' #LOGICANDOR#
			</CFIF>

				U.UNITID #FINALTEST# 0)
		ORDER BY	U.UNITNAME
	</CFQUERY>

	

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Shared Data - Units Report</H1></TD>
		</TR>
	</TABLE>
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/unitsdbreport.cfm" method="POST">
		<TD align="left">
          	<BR><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR><BR>
          </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="6"><H2>#ListUnits.RecordCount# Unit records were selected.</H2></TH>
		</TR>
	<CFIF #FORM.ACTIVEUNIT# NEQ "Select an Option">
		<TR>
			<TH align="LEFT">
			<CFIF #FORM.ACTIVEUNIT# EQ "YES">
				<H3>ACTIVE UNITS</H3>
			<CFELSE>
				<H3>INACTIVE UNITS</H3>
			</CFIF>
			</TH>
			<TH colspan="5">&nbsp;&nbsp;</TH>
		</TR>
	</CFIF>
		<TR>
			<TH align="left" valign="BOTTOM">Unit</TH>
			<TH align="left" valign="BOTTOM">Supervisor</TH>
			<TH align="left" valign="BOTTOM">Group</TH>
			<TH align="left" valign="BOTTOM">Management</TH>
			<TH align="left" valign="BOTTOM">Department</TH>
			<TH align="center" valign="BOTTOM">Campus Mail Code</TH>
		</TR>

	<CFLOOP query="ListUnits">
		<TR>
			<TD align="left"><DIV>#ListUnits.UNITNAME#</DIV></TD>
		<CFIF #ListUnits.SUPERVISORID# GT 0>
				<TD align="left"><DIV>#ListUnits.SUPVRNAME#</DIV></TD>
		<CFELSE>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</CFIF>
			<TD align="left"><DIV>#ListUnits.GROUPNAME#</DIV></TD>
		<CFIF #ListUnits.MANAGEMENTID# GT 0>
			<TD align="left"><DIV>#ListUnits.MGMTNAME#</DIV></TD>
		<CFELSE>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</CFIF>
			<TD align="left"><DIV>#ListUnits.DEPARTMENTNAME#</DIV></TD>
			<TD align="center"><DIV>#ListUnits.CAMPUSMAILCODE#</DIV></TD>
		</TR>
	</CFLOOP>
		
		<TR>
			<TH align="CENTER" colspan="6"><H2>#ListUnits.RecordCount# Unit records were selected.</H2></TH>
		</TR>
		
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/unitsdbreport.cfm" method="POST">
			<TD align="left">
               	<BR><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="6">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>