<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpurchreqlineinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/10/2012 --->
<!--- Date in Production: 05/10/2012 --->
<!--- Module: Process Information to IDT Purchase Requisition Lines --->
<!-- Last modified by John R. Pastori on 05/10/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchase Requisition Lines</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF #FORM.PROCESSPURCHREQLINES# EQ 'RECEIVE ALL LINES'>
	<CFSET SESSION.LineCounter = 1>
	<CFSET ARRAYCOUNT = #ArrayLen(SESSION.PurchReqLinesArray)#>
	<CFLOOP index = "SESSION.LineCounter" FROM = "1" TO = "#ARRAYCOUNT#" STEP = "1">
		<CFSET FORM.PURCHREQLINEID = SESSION.PurchReqLinesArray[#SESSION.LineCounter#]>

		<CFQUERY name="UpdateAllRecvdDates" datasource="#application.type#PURCHASING">
			UPDATE	PURCHREQLINES
			SET		RECVDDATE = '#FORM.ALLLINESDATE#'
			WHERE	(PURCHREQLINEID = #val(FORM.PURCHREQLINEID)#)
		</CFQUERY>

	</CFLOOP>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("All Line Dates Updated!");
			window.close();
		-->
	</SCRIPT>
	<CFEXIT>
</CFIF>
<CFIF #FORM.PROCESSPURCHREQLINES# EQ 'RECEIVE SPECIFIC LINES'>
	<CFSET SESSION.LineCounter = 1>
	<CFLOOP index = "SESSION.LineCounter" FROM = "1" TO = "#ArrayLen(SESSION.PurchReqLinesArray)#">
		<CFSET FORMDATEFIELD = "FORM.RECVDDATE#SESSION.LineCounter#">
		<CFSET FORM.PURCHREQLINEID = SESSION.PurchReqLinesArray[#SESSION.LineCounter#]>

		<CFQUERY name="UpdateAllRecvdDates" datasource="#application.type#PURCHASING">
			UPDATE	PURCHREQLINES
			SET		RECVDDATE = '#EVALUATE(FORMDATEFIELD)#'
			WHERE	(PURCHREQLINEID = #val(FORM.PURCHREQLINEID)#)
		</CFQUERY>

	</CFLOOP>	
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Specific Line Dates Updated!");
			window.close();
		-->
	</SCRIPT>
	<CFEXIT>
</CFIF>
<CFIF #FORM.PROCESSPURCHREQLINES# EQ 'ADDLOOP' OR FIND('MODIFY', #FORM.PROCESSPURCHREQLINES#, 1) NEQ 0>

	<CFSET FORM.LINETOTAL = (#FORM.LINEQTY# * #FORM.UNITPRICE#)>

	<CFQUERY name="ModifyPurchReqLines" datasource="#application.type#PURCHASING">
		UPDATE	PURCHREQLINES
		SET		LINENUMBER = '#val(FORM.LINENUMBER)#',
				UNITOFMEASUREID = #val(FORM.UNITOFMEASUREID)#,
				LINEQTY = #val(FORM.LINEQTY)#,
				UNITPRICE = #val(FORM.UNITPRICE)#,
				LINETOTAL = #val(FORM.LINETOTAL)#,
				LINEDESCRIPTION = UPPER('#FORM.LINEDESCRIPTION#'),
				PARTNUMBER = UPPER('#FORM.PARTNUMBER#')
			<CFIF IsDefined('FORM.RECVDDATE')>
				,RECVDDATE = UPPER('#FORM.RECVDDATE#')
			</CFIF>
			<CFIF IsDefined('FORM.LICENSESTATUSID')>
				,LICENSESTATUSID = #val(FORM.LICENSESTATUSID)#
			</CFIF>
		WHERE	(PURCHREQLINEID = #val(Cookie.PURCHREQLINEID)#)
	</CFQUERY>
	<CFIF #FORM.PROCESSPURCHREQLINES# EQ 'ADDLOOP'>
		<H1>Data ADDED!</H1>
          <CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=ADD&PURCHREQID=#Cookie.PURCHREQID#" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<CFIF session.PRLModLoop EQ 'YES'>
			<CFIF session.PRLArrayCounter EQ ARRAYLEN(session.PurchReqLinesArray)>
				<H1>All PurcReq Line Records Processed!</H1>
				<CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">
				<CFIF IsDefined('SESSION.POPUP') AND #SESSION.POPUP# EQ "YES">
					<CFSET SESSION.POPUP ="NO">
					<SCRIPT language="JavaScript">
						<!-- 
							alert("Data MODIFIED!");
							window.close();
			 			-->
					</SCRIPT>
					<CFEXIT>
				<CFELSE>
					<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE" />
					<CFEXIT>
				</CFIF>
			<CFELSE>
				<H1>Process Next Record</H1>
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPPURCHREQLINE=FOUND" />
				<CFEXIT>
			</CFIF>
		<CFELSE>
			<CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		</CFIF>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPURCHREQLINES EQ "NEXTRECORD">
	<CFIF session.PRLArrayCounter EQ ARRAYLEN(session.PurchReqLinesArray)>
		<H1>All Selected Records Processed!</H1>
		<CFIF IsDefined('SESSION.POPUP') AND #SESSION.POPUP# EQ 'YES'>
			<CFSET SESSION.POPUP ='NO'>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Data Processing Completed!");
					window.close();
				-->
			</SCRIPT>
			<CFEXIT>
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPPURCHREQLINE=FOUND" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPURCHREQLINES EQ "DELETE" OR FORM.PROCESSPURCHREQLINES EQ "CANCELADD">
	<CFQUERY name="DeletePurchReqLines" datasource="#application.type#PURCHASING">
		DELETE FROM	PURCHREQLINES
		WHERE 		PURCHREQLINEID = #val(Cookie.PURCHREQLINEID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPURCHREQLINES EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">
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