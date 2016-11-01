<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: datacenteraccessreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/04/2013 --->
<!--- Date in Production: 10/04/2013 --->
<!--- Module: Shared Data - Data Center Access Report --->
<!-- Last modified by John R. Pastori on 10/04/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center">
               	<h1>	Shared Data - Data Center Access Report</h1>
				<h2>	As Of #DateFormat(NOW(), 'MMMM DD, YYYY')#</h2>
               </td>
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

	<CFSET DATACENTERACCESSTITLE = "">
	<CFLOOP query="ListCustomers">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListCustomers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFIF DATACENTERACCESSTITLE NEQ #ListCustomers.DATACENTERACCESS#>
			<CFSET DATACENTERACCESSTITLE = #ListCustomers.DATACENTERACCESS#>                          

		<tr>
			<td colspan="6"><hr width="100%" size="5" noshade /></td>
		</tr>
		<tr>
			<th align="left" nowrap><h2>DC Access:  &nbsp;&nbsp;#ListCustomers.DATACENTERACCESS#</h2></th>
		</tr>
          <tr>
			<th align="left" valign="BOTTOM">Customer</th>
			<th align="center" valign="BOTTOM">E-Mail Address</th>
			<th align="center" valign="BOTTOM">Campus Phone Number</th>
			<th align="center" valign="BOTTOM">Cell Number</th>
			<th align="left" valign="BOTTOM">Modified-By</th>
			<th align="left" valign="BOTTOM">Date Modified</th>
		</tr>

		</CFIF>

		<tr>
			<td align="left" valign="TOP"><div>#ListCustomers.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.EMAIL#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CAMPUSPHONE#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CELLPHONE#</div></td>
			<td align="left" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#DateFormat(ListCustomers.MODIFIEDDATE, "MM/DD/YYYY")#</div></td>
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