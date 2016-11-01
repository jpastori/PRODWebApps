<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: groupunitredidreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data - Customer Group/Unit/RED ID Report--->
<!-- Last modified by John R. Pastori on 06/14/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<table width="100%" align="center" border="3">
		<tr align="center">
			<td align="center"><h1>Shared Data - Customer Group/Unit/RED ID Report</h1></td>
		</tr>
	</table>
	<br />
	<table width="100%" align="LEFT" border="0">
		<tr>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<td align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
               </td>
</CFFORM>
		</tr>
		<tr>
			<th align="CENTER" colspan="8"><h2>#ListCustomers.RecordCount# Customer records were selected.</h2></th>
		</tr>
		<tr>
			<th align="center" valign="BOTTOM">RED ID</th>
			<th align="left" valign="BOTTOM">Customer</th>
			<th align="center" valign="BOTTOM">Customer Category</th>
			<th align="center" valign="BOTTOM">E-Mail Address</th>
			<th align="center" valign="BOTTOM">Campus Phone Number</th>
               <TH align="center" valign="BOTTOM">Accounts</TH>
			<th align="left" valign="BOTTOM">Modified-By</th>
			<th align="left" valign="BOTTOM">Date Modified</th>
		</tr>

	<CFSET GROUPUNITHEADER = "">
	<CFLOOP query="ListCustomers">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListCustomers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFIF GROUPUNITHEADER NEQ #ListCustomers.GROUPUNIT#>
			<CFSET GROUPUNITHEADER = #ListCustomers.GROUPUNIT#>
		<tr>
			<td  align="left" colspan="8">
				<hr width="100%" size="5" noshade />
			</td>
		</tr>
		<tr>
			<td align="left" colspan="2" nowrap>
				<h5>#ListCustomers.GROUPNAME#<br />#ListCustomers.UNITNAME#</h5>
			</td>
		</tr>
		</CFIF>

		<tr>
			<td align="left" valign="MIDDLE"><div>#ListCustomers.REDID#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.FULLNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.CATEGORYNAME#</div></td>
			<td align="left" valign="TOP"><div>#ListCustomers.EMAIL#</div></td>
			<td align="center" valign="TOP"><div>#ListCustomers.CAMPUSPHONE#</div></td>
               <td align="center" valign="TOP"><div>#ListCustomers.ACCOUNTS#</div></td>
			<td align="left" valign="TOP"><div>#LookupRecordModifier.FULLNAME#</div></td>
			<td align="left" valign="MIDDLE"><div>#DateFormat(ListCustomers.MODIFIEDDATE, "MM/DD/YYYY")#</div></td>
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
               	<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </td>
</CFFORM>
		</tr>
		<tr>
			<td colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
		</tr>
	</table>
</CFOUTPUT>