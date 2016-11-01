<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: calcpurchreqsubtotal.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/10/2012 --->
<!--- Date in Production: 05/10/2012 --->
<!--- Module: IDT Purchasing - Calculate Purchasing Requisition Subtotal--->
<!-- Last modified by John R. Pastori on 03/14/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

<CFIF IsDefined('URL.PURCHREQID')>
	<CFSET SESSION.POPUP = "NO">
     URL PURCHASE REQUISITION ID = #URL.PURCHREQID#
<CFELSEIF IsDefined('URL.POPUP')>
	<CFSET SESSION.POPUP = 'YES'>
</CFIF>

<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	PRL.PURCHREQLINEID, PRL.LINENUMBER, PR.PURCHREQID, PR.REQNUMBER, SHIPPINGCOST, LINETOTAL
	FROM		PURCHREQLINES PRL, PURCHREQS PR
	WHERE	PRL.PURCHREQID = <CFQUERYPARAM value="#SESSION.PurchReqID#" cfsqltype="CF_SQL_NUMERIC"> AND
			PRL.PURCHREQID = PR.PURCHREQID
	ORDER BY	PR.REQNUMBER, PRL.LINENUMBER
</CFQUERY>

<CFIF #LookupPurchReqLines.RecordCount# GT 0>

	<CFSET PurchReqSubTotal = 0>

	<CFLOOP query="LookupPurchReqLines">
		<CFSET PurchReqSubTotal = PurchReqSubTotal + #LookupPurchReqLines.LINETOTAL#>
	</CFLOOP>

	<CFSET PurchReqTotal = #PurchReqSubTotal# + #LookupPurchReqLines.SHIPPINGCOST#>

	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyPurchReqs" datasource="#application.type#PURCHASING">
		UPDATE	PURCHREQS
		SET		SUBTOTAL = #val(PurchReqSubTotal)#,
				TOTAL = #val(PurchReqTotal)#
		WHERE	PURCHREQID = <CFQUERYPARAM value="#LookupPurchReqLines.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
	</CFQUERY>
      <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>

</CFIF>

<CFIF IsDefined('FORM.PROCESSPURCHREQLINES') AND FORM.PROCESSPURCHREQLINES EQ "Cancel">
	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>
</CFOUTPUT>