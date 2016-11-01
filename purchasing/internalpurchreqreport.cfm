<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: internalpurchreqreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/09/2012 --->
<!--- Date in Production: 07/09/2012 --->
<!--- Module: IDT Purchase Requisitions - Internal IDT Purchase Requisition Report--->
<!-- Last modified by John R. Pastori on 10/27/2016 using ColdFusion Studio. -->

<cfinclude template = "../programsecuritycheck.cfm">

<cfoutput>
<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Internal IDT Purchase Requisition</h1></td>
	</tr>
</table>
<br />
<table width="100%" border="0" align="left">
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="LEFT"><div><strong>IDT Unit: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>#ListPurchReqs.REVIEWERUNIT#</div></td>
		<td align="LEFT"><div><strong>Review Date: &nbsp;&nbsp;</strong>#DateFormat(ListPurchReqs.REVIEWDATE, "mm/dd/yyyy")#</div></td>
	</tr>
	<tr>
		<td align="LEFT"><div><strong>IDT Reviewer: &nbsp;&nbsp;</strong>#ListPurchReqs.REVIEWERNAME#</div></td>
		<td align="LEFT"><div><strong>SR Number: &nbsp;&nbsp;&nbsp; </strong>#ListPurchReqs.SERVICEREQUESTNUMBER#</div></td>
		</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="2"><div><strong>Provides the following specifications and comments for the items requested:</strong></div></th>
	</tr>
	<tr>
		<td align="LEFT" colspan="2"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<th align="left"><div>Item Description</div></th>
		<th align="left"><div>Specs Comments</div></th>
	</tr>

<cfquery name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
	FROM		PURCHREQLINES
	WHERE	PURCHREQID = <CFQUERYPARAM value="#ListPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	PURCHREQID, LINENUMBER
</cfquery>

	<tr>
		<td align="left" nowrap>
		<cfloop query="LookupPurchReqLines">
			<div>#LookupPurchReqLines.LINEDESCRIPTION#<br /></div>
		</cfloop>
		</td>
		<td align="left" valign="TOP"><div>#ListPurchReqs.SPECSCOMMENTS#</div></td>
	</tr>

	<tr>
		<td align="LEFT" colspan="2"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
<cfquery name="LookupPurchaseVendors" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	V.VENDORID, V.VENDORNAME, V.ADDRESSLINE1, V.ADDRESSLINE2, V.CITY, V.STATEID, S.STATECODE, V.ZIPCODE, V.WEBSITE
	FROM		VENDORS V, LIBSHAREDDATAMGR.STATES S
	WHERE 	V.VENDORID = <CFQUERYPARAM value="#ListPurchReqs.VENDORID#" cfsqltype="CF_SQL_NUMERIC"> AND
			V.STATEID = S.STATEID
	ORDER BY	V.VENDORNAME
</cfquery>

<cfquery name="LookupVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	VC.VENDORCONTACTID, VC.VENDORID, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, VC.EMAILADDRESS
	FROM		VENDORCONTACTS VC
	WHERE	VC.VENDORCONTACTID = <CFQUERYPARAM value="#ListPurchReqs.VENDORCONTACTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	VC.CONTACTNAME
</cfquery>

	<tr>
		<td align="left"><div><strong>Suggested Vendor: &nbsp;&nbsp;</strong>#LookupPurchaseVendors.VENDORNAME#</div></td>
		<td align="left"><div><strong>Quote Date: &nbsp;&nbsp;</strong>#DateFormat(ListPurchReqs.QUOTEDATE, 'MM/DD/YYYY')#</div></td>
	</tr>
	<tr>
		<td align="left"><div>#LookupPurchaseVendors.ADDRESSLINE1#</div></td>
		<td align="left"><div><strong>Quote: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>#ListPurchReqs.QUOTE#</div></td>
	</tr>
	<tr>
		<td align="left"><div>#LookupPurchaseVendors.ADDRESSLINE2#</div></td>
		<td align="left"><div>&nbsp;&nbsp;</div></td>
	</tr>
	<tr>
		<td align="left"><div>#LookupPurchaseVendors.CITY#, &nbsp;&nbsp;#LookupPurchaseVendors.STATECODE# &nbsp;&nbsp;&nbsp;&nbsp; #LookupPurchaseVendors.ZIPCODE#</div></td>
		<td align="left"><div><strong>Phone: &nbsp;&nbsp;</strong>#LookupVendorContacts.PHONENUMBER#</div></td>
	</tr>
	<tr>
		<td align="left"><div>#LookupPurchaseVendors.WEBSITE#</div></td>
		<td align="left"><div><strong>FAX: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong> #LookupVendorContacts.FAXNUMBER#</div></td>
	</tr>
	<tr>
		<td align="left"><div><strong>Vendor Contact: &nbsp;&nbsp;</strong>#LookupVendorContacts.CONTACTNAME#</div></td>
		<td align="left"><div><strong>E-Mail: &nbsp;</strong> #LookupVendorContacts.EMAILADDRESS#</div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="2"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="2"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
		<td align="left">
			<div>
				<strong>Shipping:</strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				#NumberFormat(ListPurchReqs.SHIPPINGCOST, '$___,___.__')#
			</div>
		</td>
	</tr>
	<tr>
		<td align="left"><div><strong>Suggested Funds: &nbsp;&nbsp;</strong>#ListPurchReqs.FUNDACCTNAME#</div></td>
		<td align="left">
			<div>
				<strong>Total Price:</strong> &nbsp;&nbsp; 
				#NumberFormat(ListPurchReqs.TOTAL, '$__,___,___.__')#
			</div>
		</td>
	</tr>
	<tr>
		<td align="left"><div><strong>Budget Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong>#LookupBudgetTypes.BUDGETTYPENAME#</div></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" nowrap><div><strong>Division Director's Approval: &nbsp;&nbsp;___________________________________</strong></div></th>
		<th align="LEFT"><div><strong>Date: &nbsp;&nbsp;_____________</strong></div></th>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="left" nowrap><div><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
			Disapproval: &nbsp;&nbsp;___________________________________</strong></div></th>
		<td align="LEFT"><div>&nbsp;&nbsp;</div></td>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="2" nowrap><div><strong>Management Group Approval Required: &nbsp;&nbsp;&nbsp;&nbsp;</strong> YES &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; NO </div></th>
	</tr>
	<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="left">
			&nbsp;&nbsp;
			<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
		</td>
	</tr>
	<tr>
<cfform action="/#application.type#apps/purchasing/purchreqforms.cfm" method="POST">
		<td align="LEFT">
			<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
		</td>
</cfform>
	</tr>
	<tr>
		<td align="left" colspan="2"><cfinclude template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>
</cfoutput>