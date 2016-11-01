<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpurchreqserialnums.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Purchase Requisition Line Serial Numbers --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchase Requisition Line Serial Numbers</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF #FORM.PROCESSPURCHREQSERNUMS# EQ 'ADDLOOP' OR FIND('MODIFY', #FORM.PROCESSPURCHREQSERNUMS#, 1) NEQ 0>
	<CFQUERY name="ModifyPurchReqSerNums" datasource="#application.type#PURCHASING">
		UPDATE	SWSERIALNUMBERS
		SET		REPLACESWSERIALNUM = UPPER('#FORM.REPLACESWSERIALNUM#'),
				SOFTWINVENTID = #val(FORM.SOFTWINVENTID)#
		WHERE	(PRLSWSERIALNUMID = #val(Cookie.PRLSWSERIALNUMID)#)
	</CFQUERY>
	<CFIF #FORM.PROCESSPURCHREQSERNUMS# EQ 'ADDLOOP'>
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=ADD&PURCHREQLINEID=#Cookie.PURCHREQLINEID#" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<CFIF session.SWSNModLoop EQ 'YES'>
			<CFIF session.SWSNArrayCounter EQ ARRAYLEN(session.PurchReqSerNumsArray)>
				<H1>All Software Serial Numbers Processed!</H1>
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE" />
				<CFEXIT>
			<CFELSE>
				<H1>Process Next Record</H1>
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE&LOOKUPSWSERNUM=FOUND" />
				<CFEXIT>
			</CFIF>
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		</CFIF>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPURCHREQSERNUMS EQ "NEXTRECORD">
	<CFIF session.SWSNArrayCounter EQ ARRAYLEN(session.PurchReqSerNumsArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE&LOOKUPSWSERNUM=FOUND" />
		<CFEXIT>
	</CFIF>
</CFIF>


<CFIF FORM.PROCESSPURCHREQSERNUMS EQ "DELETE" OR FORM.PROCESSPURCHREQSERNUMS EQ "CANCELADD">
	<CFQUERY name="DeletePurchReqSerNums" datasource="#application.type#PURCHASING">
		DELETE FROM	SWSERIALNUMBERS
		WHERE 		PRLSWSERIALNUMID = #val(Cookie.PRLSWSERIALNUMID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPURCHREQSERNUMS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data DELETED!");
				window.close();
			 -->
		</SCRIPT>
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>