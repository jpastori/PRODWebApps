<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unithwswpurchasereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Purchase Requisitions - Unit HW/SW Purchase  Request--->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Unit Hardware/Software Purchase Request</h1></td>
	</tr>
</table>
<br />
<table width="100%" border="0" align="left">
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="2"><div><strong>Date</strong></div></th>
		<th align="LEFT" colspan="2"><div><strong>Requester</strong></div></th>
		<th align="LEFT" colspan="2"><div><strong>Receiving Unit</strong></div></th>
	</tr>
	<tr>
		<td align="LEFT" colspan="2"><div>#DateFormat(ListPurchReqs.CREATIONDATE, "mm/dd/yyyy")#</div></td>
		<td align="LEFT" colspan="2"><div>#ListPurchReqs.FULLNAME#</div></td>
		<td align="LEFT" colspan="2"><div>#ListPurchReqs.UNITNAME#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="6"><div><strong>Requests that the following items be purchased:</strong></div></th>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<th align="left"><div><strong>Part Number</strong></div></th>
		<th align="left"><div><strong>Qty</strong></div></th>
		<th align="left"><div><strong>UOM</strong></div></th>
		<th align="left"><div><strong>Item Description</strong></div></th>
		<th align="left"><div><strong>Unit Price</strong></div></th>
		<th align="left"><div><strong>Total Line Price</strong></div></th>
	</tr>
	<tr>
		<td align="left" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>

<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING">
	SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID, UNITOFMEASUREID, UNITPRICE, LINETOTAL
	FROM		PURCHREQLINES
	WHERE	PURCHREQID = <CFQUERYPARAM value="#ListPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	PURCHREQID, LINENUMBER
</CFQUERY>

<CFLOOP query="LookupPurchReqLines">

	<CFQUERY name="LookuptUnitOfMeasure" datasource="#application.type#PURCHASING" blockfactor="21">
		SELECT	UNITOFMEASUREID, MEASURENAME
		FROM		UNITOFMEASURE
		WHERE	UNITOFMEASUREID = <CFQUERYPARAM value="#LookupPurchReqLines.UNITOFMEASUREID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	UNITOFMEASUREID
	</CFQUERY>

	<tr>
		<td align="left" valign="TOP"><div>#LookupPurchReqLines.PARTNUMBER#</div></td>
		<td align="left"><div>&nbsp;#NumberFormat(LookupPurchReqLines.LINEQTY, '____')#</div></td>
		<td align="left"><div>#LookuptUnitOfMeasure.MEASURENAME#</div></td>
		<td align="left"><div>#LookupPurchReqLines.LINEDESCRIPTION#</div></td>
		<td align="left"><div>#NumberFormat(LookupPurchReqLines.UNITPRICE, '$___.__')#</div></td>
		<td align="left"><div>#NumberFormat(LookupPurchReqLines.LINETOTAL, '$__,___,___.__')#</div></td>
	</tr>
</CFLOOP>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<th align="LEFT" colspan="6"><div><strong>Justification For Purchase:</strong></div></th>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div>#ListPurchReqs.PURCHASEJUSTIFICATION#</div></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="6"><div><strong>If item(s) requested is upgrading current Software, please provide the Software's matching Title and Serial Number:</strong></div></th>
	</tr>

<CFQUERY name="ListPurchReqLines" datasource="#application.type#PURCHASING">
	SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, LINENUMBER
	FROM		PURCHREQLINES PRL
	WHERE	PRL.PURCHREQID = <CFQUERYPARAM value="#ListPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	PURCHREQID, LINENUMBER
</CFQUERY>

<CFLOOP query="ListPurchReqLines">

	<CFQUERY name="LookupPurchReqSerNums" datasource="#application.type#PURCHASING">
		SELECT	SWSN.PRLSWSERIALNUMID, SWSN.PURCHREQLINEID, SWSN.REPLACESWSERIALNUM, SWSN.SOFTWINVENTID, SI.TITLE
		FROM		SWSERIALNUMBERS SWSN, SOFTWMGR.SOFTWAREINVENTORY SI
		WHERE	SWSN.PURCHREQLINEID = <CFQUERYPARAM value="#ListPurchReqLines.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SWSN.SOFTWINVENTID = SI.SOFTWINVENTID
		ORDER BY	SI.TITLE, SWSN.REPLACESWSERIALNUM
	</CFQUERY>

<CFIF LookupPurchReqSerNums.RecordCount GT 0>
	<CFLOOP query="LookupPurchReqSerNums">
	<tr>
		<td align="left" colspan="2"><div>#LookupPurchReqSerNums.TITLE#</div></td>
		<td align="left" colspan="2"><div>#LookupPurchReqSerNums.REPLACESWSERIALNUM#</div></td>
		<td align="left" colspan="2">&nbsp;&nbsp;</td>
	</tr>
	</CFLOOP>
</CFIF>
</CFLOOP>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="6"><div><strong>RUSH Required: &nbsp;&nbsp;&nbsp;&nbsp; </strong>#ListPurchReqs.RUSH#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Rush Justification:</strong></div></th>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><div>#ListPurchReqs.RUSHJUSTIFICATION#</div></td>
	</tr>
	<tr>
		<td align="LEFT" colspan="6"><hr align="left" width="100%" size="5" noshade /></td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr><tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="LEFT" colspan="5" nowrap><div><strong>Division/Unit Head Approval: &nbsp;&nbsp;___________________________________</strong></div></th>
		<th align="LEFT"><div><strong>Date: &nbsp;&nbsp;_____________</strong></div></th>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<th align="center" colspan="6"><div><strong>Note:  &nbsp;&nbsp;&nbsp;&nbsp;After approving the request, the Division Head will route the request to Technology Support, InfoSys (LL-453).</strong></div></th>
	</tr>
	<tr>
		<td align="left" colspan="6">&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td align="left" colspan="6">
			&nbsp;&nbsp;
			<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
		</td>
	</tr>
	<tr>
<CFFORM action="/#application.type#apps/purchasing/purchreqforms.cfm" method="POST">
		<td align="left" colspan="6">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
          </td>
</CFFORM>
	</tr>
	<tr>
		<td align="left" colspan="6"><CFINCLUDE template="/include/coldfusion/footer.cfm"></td>
	</tr>
</table>
</CFOUTPUT>