<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchrequistnrequest.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 04/21/2015 --->
<!--- Date in Production: 04/21/2015 --->
<!--- Module: IDT Purchase Requisitions - Purchase Request --->
<!-- Last modified by John R. Pastori on 10/27/2016 using ColdFusion Studio. -->

<cfinclude template = "../programsecuritycheck.cfm">

<cfoutput>

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>IDT Purchase Requisition Request</h1></td>
	</tr>
</table>
<br />
<table width="100%" border="0" align="left">
	<tr>
		<td align="LEFT" colspan="2"><div><strong>Date</strong></div></td>
		<td align="LEFT" colspan="2"><div><strong>Requester</strong></div></td>
		<td align="LEFT"><div><strong>Receiving Unit</strong></div></td>
		<td align="LEFT"><div><strong>SR Number</strong></div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="2"><div>#DateFormat(ListPurchReqs.CREATIONDATE, "mm/dd/yyyy")#</div></td>
		<td align="LEFT" colspan="2"><div>#ListPurchReqs.FULLNAME#</div></td>
		<td align="LEFT"><div>#ListPurchReqs.UNITNAME#</div></td>
		<td align="LEFT"><div>#ListPurchReqs.SERVICEREQUESTNUMBER#</div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="4">&nbsp;&nbsp;</td>
		<td align="LEFT"><div><strong><font color='RED'>Req Number:</font></strong></div></td>
		<td align="LEFT"><div><strong><font color='RED'>PO Number:</font></strong></div></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div><strong>Requests that the following items be purchased:</strong></div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="left"><div><strong>Part Number</strong></div></td>
		<td align="left"><div><strong>Qty</strong></div></td>
		<td align="left"><div><strong>UOM</strong></div></td>
		<td align="left"><div><strong>Item Description</strong></div></td>
		<td align="left"><div><strong>Unit Price</strong></div></td>
		<td align="left"><div><strong>Total Line Price</strong></div></td>
	</tr>
	<tr>
		<td align="left" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>

<cfquery name="LookupPurchReqLines" datasource="#application.type#PURCHASING">
	SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID, UNITOFMEASUREID, UNITPRICE, LINETOTAL
	FROM		PURCHREQLINES
	WHERE	PURCHREQID = <CFQUERYPARAM value="#ListPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	PURCHREQID, LINENUMBER
</cfquery>

<cfloop query="LookupPurchReqLines">

	<cfquery name="LookuptUnitOfMeasure" datasource="#application.type#PURCHASING" blockfactor="21">
		SELECT	UNITOFMEASUREID, MEASURENAME
		FROM		UNITOFMEASURE
		WHERE	UNITOFMEASUREID = <CFQUERYPARAM value="#LookupPurchReqLines.UNITOFMEASUREID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	UNITOFMEASUREID
	</cfquery>

	<tr>
		<td align="left" valign="TOP"><div>#LookupPurchReqLines.PARTNUMBER#</div></td>
		<td align="left"><div>&nbsp;#NumberFormat(LookupPurchReqLines.LINEQTY, '____')#</div></td>
		<td align="left"><div>#LookuptUnitOfMeasure.MEASURENAME#</div></td>
		<td align="left"><div>#LookupPurchReqLines.LINEDESCRIPTION#</div></td>
		<td align="left"><div>#NumberFormat(LookupPurchReqLines.UNITPRICE, '$___.__')#</div></td>
		<td align="left"><div>#NumberFormat(LookupPurchReqLines.LINETOTAL, '$__,___,___.__')#</div></td>
	</tr>
</cfloop>

	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
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
		<td align="left" colspan="4"><div><strong>Suggested Vendor: &nbsp;&nbsp;</strong>#LookupPurchaseVendors.VENDORNAME#</div></td>
		<td align="left" colspan="2"><div><strong>Quote Date: &nbsp;&nbsp;</strong>#DateFormat(ListPurchReqs.QUOTEDATE, 'MM/DD/YYYY')#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div>#LookupPurchaseVendors.ADDRESSLINE1#</div></td>
		<td align="left" colspan="2"><div><strong>Quote: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong>#ListPurchReqs.QUOTE#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div>#LookupPurchaseVendors.ADDRESSLINE2#</div></td>
		<td align="left" colspan="2"><div>&nbsp;&nbsp;</div></td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div>#LookupPurchaseVendors.CITY#, &nbsp;&nbsp;#LookupPurchaseVendors.STATECODE# &nbsp;&nbsp;&nbsp;&nbsp; #LookupPurchaseVendors.ZIPCODE#</div></td>
		<td align="left" colspan="2"><div><strong>Phone: &nbsp;&nbsp;</strong>#LookupVendorContacts.PHONENUMBER#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div>#LookupPurchaseVendors.WEBSITE#</div></td>
		<td align="left" colspan="2"><div><strong>FAX: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong> #LookupVendorContacts.FAXNUMBER#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div><strong>Vendor Contact: &nbsp;&nbsp;</strong>#LookupVendorContacts.CONTACTNAME#</div></td>
		<td align="left" colspan="2"><div><strong>E-Mail: &nbsp;</strong> #LookupVendorContacts.EMAILADDRESS#</div></td>
	</tr>

	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div><strong>Justification For Purchase:</strong></div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div>#ListPurchReqs.PURCHASEJUSTIFICATION#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6">
			<div><strong>RUSH Required: &nbsp;&nbsp;&nbsp;&nbsp; </strong>#ListPurchReqs.RUSH#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Rush Justification:</strong></div>
		</td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div>#ListPurchReqs.RUSHJUSTIFICATION#</div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="left" colspan="6"><div><font color='RED'><strong>Specs Comments: </strong>&nbsp;&nbsp;#ListPurchReqs.SPECSCOMMENTS#</font></div></td>
	</tr>
	<tr>
		<td align="left" colspan="2"><div><strong>Suggested Funds: &nbsp;&nbsp;</strong>#ListPurchReqs.FUNDACCTNAME#</div></td>
		<td align="left" colspan="2"><div><font color='RED'><strong>Account##: </strong>&nbsp;&nbsp;________________________________________</font></div></td>
		<td align="left" colspan="2">
			<div>
				<strong>Shipping:</strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				#NumberFormat(ListPurchReqs.SHIPPINGCOST, '$___,___.__')#
			</div>
		</td>
	</tr>
	<tr>
		<td align="left" colspan="4"><div><strong>Budget Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong>#LookupBudgetTypes.BUDGETTYPENAME#</div></td>
		<td align="left" colspan="2">
			<div>
				<strong>Total Price:</strong> &nbsp;&nbsp; 
				#NumberFormat(ListPurchReqs.TOTAL, '$__,___,___.__')#
			</div>
		</td>
	</tr>
		<tr>
		<td align="left">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="LEFT" colspan="4" ><div><strong>IDT Reviewer: &nbsp;&nbsp;</strong>#ListPurchReqs.REVIEWERNAME#</div></td>
		<td align="LEFT" colspan="2" ><div><strong>IDT Unit: &nbsp;&nbsp;</strong>#ListPurchReqs.REVIEWERUNIT#</div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="LEFT" colspan="3" nowrap><div><strong>Division/Unit Head Approval: &nbsp;&nbsp;___________________________________</strong></div></td>
		<td align="LEFT"  colspan="3" nowrap><div><strong>Division Director's Approval: &nbsp;&nbsp;___________________________________</strong></div></td>
	</tr>
	<tr>
		<td align="left" colspan="6">
			<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
		</td>
	</tr>
	<tr>
<cfform action="/#application.type#apps/purchasing/purchreqforms.cfm" method="POST">
		<td align="left" colspan="6">
          	<input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
          </td>
</cfform>
	</tr>
	<tr>
		<td align="left" colspan="6"><cfinclude template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>
</cfoutput>