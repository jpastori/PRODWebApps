<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customercontactlist.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/06/2012 --->
<!--- Date in Production: 09/06/2012 --->
<!--- Module: Shared Data - Customer Contact List --->
<!-- Last modified by John R. Pastori on 07/18/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<th align="center">
               	<h1>
                    	Shared Data - Customer Contact List<br />
                     	<font COLOR="BLUE"><strong>#ListCustomers.DEPARTMENTNAME#</strong></font>
                    </h1>
               </th>
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
			<th align="CENTER" colspan="6"><h2>#ListCustomers.RecordCount# Customer records were selected.</h2></th>
		</tr>
		<tr>
			<th align="left" valign="BOTTOM">Customer</th>
			<th align="left" valign="BOTTOM">E-Mail Address</th>
			<th align="center" valign="BOTTOM">Campus Phone Number</th>
			<th align="center" valign="BOTTOM">2nd Campus Phone Number</th>
			<th align="center" valign="BOTTOM">Cell Phone Number</th>
			<th align="left" valign="BOTTOM">Office Location</th>
		</tr>

	<CFSET UNITHEADER = "">
	<CFLOOP query="ListCustomers">

		<CFQUERY name="LookupCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
			FROM		CAMPUSMAILCODES
			WHERE	CAMPUSMAILCODEID = <CFQUERYPARAM value="#ListCustomers.CAMPUSMAILCODEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CAMPUSMAILCODE
		</CFQUERY>

		<CFIF UNITHEADER NEQ #ListCustomers.UNITNAME#>
			<CFSET UNITHEADER = #ListCustomers.UNITNAME#>
		<tr>
			<td colspan="6"><hr width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th align="right" nowrap colspan="6"><h3>#ListCustomers.UNITNAME# </h3></th>
		</tr>
		</CFIF>

		<tr>
			<td align="left" valign="TOP"><div>#ListCustomers.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.EMAIL#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CAMPUSPHONE#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.SECONDCAMPUSPHONE#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CELLPHONE#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.ROOMNUMBER#</div></td>
		</tr>
	</CFLOOP>
		<tr>
			<td colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th align="CENTER" colspan="6"><h2>#ListCustomers.RecordCount# Customer records were selected.</h2></th>
		</tr>
		<tr>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<td align="left">
               	<br /><input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td colspan="6"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>