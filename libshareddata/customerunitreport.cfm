<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customerunitreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Customer Unit Report --->
<!-- Last modified by John R. Pastori on 07/18/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Shared Data - Customer Unit Report</h1></td>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT" border="0">
		<tr>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<td align="left">
               	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br /><br />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="8"><h2>#ListCustomers.RecordCount# Customer records were selected.</h2></th>
		</tr>
		<tr>
			<th align="left" valign="BOTTOM">Customer</th>
			<th align="center" valign="BOTTOM">Customer Category</th>
			<th align="center" valign="BOTTOM">E-Mail Address</th>
			<th align="center" valign="BOTTOM">Campus Phone Number</th>
			<th align="center" valign="BOTTOM">Fax Number</th>
			<th align="left" valign="TOP">RED ID</th>
			<th align="left" valign="BOTTOM">Modified-By</th>
			<th align="left" valign="BOTTOM">Date Modified</th>
		</tr>

	<CFSET UNITHEADER = "">
	<CFLOOP query="ListCustomers">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListCustomers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="LookupCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
			FROM		CAMPUSMAILCODES
			WHERE	CAMPUSMAILCODEID = <CFQUERYPARAM value="#ListCustomers.CAMPUSMAILCODEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CAMPUSMAILCODE
		</CFQUERY>

		<CFIF UNITHEADER NEQ #ListCustomers.UNITNAME#>
			<CFSET UNITHEADER = #ListCustomers.UNITNAME#>
               
               <CFQUERY name="LookupUnitSupervisorName" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
                    SELECT	U.UNITID, U.UNITNAME, U.GROUPID, U.SUPERVISORID, CUST.FULLNAME AS SUPNAME
                    FROM		UNITS U, CUSTOMERS CUST
                    WHERE	U.SUPERVISORID = CUST.CUSTOMERID AND
                    		U.UNITID = #ListCustomers.UNITID#
                    ORDER BY	U.UNITNAME
               </CFQUERY>
          
               <CFQUERY name="LookupGroupMgrName" datasource="#application.type#LIBSHAREDDATA" blockfactor="7">
                    SELECT	G.GROUPID, G.GROUPNAME, G.MANAGEMENTID, CUST.FULLNAME AS MGRNAME
                    FROM		GROUPS G, CUSTOMERS CUST
                    WHERE	G.MANAGEMENTID = CUST.CUSTOMERID AND
                    		G.GROUPID = #LookupUnitSupervisorName.GROUPID#
                    ORDER BY	G.GROUPNAME
               </CFQUERY>
               
		<tr>
			<td colspan="8"><hr width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th align="left" nowrap><h3>#ListCustomers.UNITNAME# / #LookupUnitSupervisorName.SUPNAME#<br /> #ListCustomers.GROUPNAME# / #LookupGroupMgrName.MGRNAME#</h3></th>
		</tr>
		</CFIF>

		<tr>
			<td align="left" valign="TOP"><div>#ListCustomers.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.CATEGORYNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.EMAIL#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CAMPUSPHONE#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.FAX#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.REDID#</div></td>
			<td align="left" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#DateFormat(ListCustomers.MODIFIEDDATE, "MM/DD/YYYY")#</div></td>
		</tr>
	</CFLOOP>
		<tr>
			<td colspan="8"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th align="CENTER" colspan="8"><h2>#ListCustomers.RecordCount# Customer records were selected.</h2></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<td align="left">
               	<br /><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>