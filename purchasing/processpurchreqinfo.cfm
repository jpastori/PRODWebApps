<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processpurchreqinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/14/2012 --->
<!--- Date in Production: 06/14/2012 --->
<!--- Module: Process Information to IDT Purchase Requisitions --->
<!-- Last modified by John R. Pastori on 05/17/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchase Requisitions</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FIND('ADD', #FORM.PROCESSPURCHREQ#, 1) NEQ 0 AND #FORM.PROCESSPURCHREQ# NEQ "CANCELADD">

	<CFQUERY name="LookupPurchReqsSR" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER
		FROM		PURCHREQS PR
		WHERE	PR.SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#FORM.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	PR.SERVICEREQUESTNUMBER
	</CFQUERY>

     <CFIF LookupPurchReqsSR.RecordCount GT 0>
     
     	<CFQUERY name="DeletePurchReqs" datasource="#application.type#PURCHASING">
               DELETE FROM	PURCHREQS
               WHERE 		PURCHREQID = #val(Cookie.PURCHREQID)#
          </CFQUERY>
          
          <H1>Current Add Record DELETED!</H1>        
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPPURCHREQ=FOUND&PURCHREQID=#LookupPurchReqsSR.PURCHREQID#" />
          <CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('ADD', #FORM.PROCESSPURCHREQ#, 1) NEQ 0 AND #FORM.PROCESSPURCHREQ# NEQ "CANCELADD">

	<CFSET FORM.REQNUMBER = ListChangeDelims(FORM.SERVICEREQUESTNUMBER, "", "/")>
     <CFSET FORM.REQNUMBER = "/" & #FORM.REQNUMBER#>

	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyPurchReqs" datasource="#application.type#PURCHASING">
		UPDATE	PURCHREQS
		SET		SERVICEREQUESTNUMBER = '#FORM.SERVICEREQUESTNUMBER#',
				FISCALYEARID = #val(FORM.FISCALYEARID)#,
				REQUESTERID = #val(FORM.REQUESTERID)#,
				PURCHREQUNITID = #val(FORM.PURCHREQUNITID)#,
				FUNDACCTID = #val(FORM.FUNDACCTID)#,
				PURCHASEJUSTIFICATION = UPPER('#FORM.PURCHASEJUSTIFICATION#'),
				RUSH = '#FORM.RUSH#',
			<CFIF IsDefined('FORM.RUSHJUSTIFICATION')>
				RUSHJUSTIFICATION = UPPER('#FORM.RUSHJUSTIFICATION#'),
               </CFIF>
               	REQNUMBER = UPPER('#FORM.REQNUMBER#'),
               	SPECSCOMMENTS = UPPER('#FORM.SPECSCOMMENTS#'),
                    RECVCOMMENTS = UPPER('#FORM.RECVCOMMENTS#'),
                    BUDGETTYPEID = #val(FORM.BUDGETTYPEID)#,
				VENDORID = #val(FORM.VENDORID)#
		WHERE	PURCHREQID = #val(Cookie.PURCHREQID)#
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
	<CFIF FIND('ADD', #FORM.PROCESSPURCHREQ#, 1) NEQ 0>
		<CFIF IsDefined('URL.POPUP') AND #FORM.PROCESSPURCHREQ# EQ 'ADD'>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Data ADDED!");
					window.close();
				 -->	 
			</SCRIPT>
			<CFEXIT>
		</CFIF>
		<H1>Data ADDED!</H1>
          <CFIF #FORM.PROCESSPURCHREQ# EQ 'ADD/MODIFY'>
          	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LOOKUPPURCHREQ=FOUND&PURCHREQID=#Cookie.PURCHREQID#" />
          <CFELSE>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=ADD" />
          </CFIF>
          <CFEXIT>
	</CFIF>
</CFIF>

<CFIF  FIND('MODIFY', #FORM.PROCESSPURCHREQ#, 1) NEQ 0>

	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.VENDORID, PR.VENDORCONTACTID
		FROM		PURCHREQS PR
		WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#Cookie.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	PR.PURCHREQID
	</CFQUERY>

	<CFIF #FORM.VENDORID# NEQ #LookupPurchReqs.VENDORID#>
		<CFSET FORM.VENDORCONTACTID = 0>
	</CFIF>
	<CFIF IsDefined('FORM.QUOTEDATE') AND #FORM.QUOTEDATE# IS NOT "">
		<CFSET FORM.QUOTEDATE = #DateFormat(FORM.QUOTEDATE, 'DD-MMM-YYYY')#>
	</CFIF>
	<CFIF IsDefined('FORM.REVIEWDATE') AND #FORM.REVIEWDATE# IS NOT "">
		<CFSET FORM.REVIEWDATE = #DateFormat(FORM.REVIEWDATE, 'DD-MMM-YYYY')#>
	</CFIF>
	<CFIF IsDefined('FORM.REQFILEDDATE') AND #FORM.REQFILEDDATE# IS NOT "">
		<CFSET FORM.REQFILEDDATE = #DateFormat(FORM.REQFILEDDATE, 'DD-MMM-YYYY')#>
     <CFELSEIF #FORM.PROCESSPURCHREQ# EQ 'MODIFY TO PRINT' AND #FORM.REQFILEDDATE# EQ "">
     	<CFSET FORM.REQFILEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
	</CFIF>
	<CFIF IsDefined('FORM.COMPLETIONDATE') AND FORM.COMPLETIONDATE IS NOT "">
		<CFSET FORM.COMPLETIONDATE = #DateFormat(FORM.COMPLETIONDATE, 'DD-MMM-YYYY')#>
	</CFIF>

	<CFIF #FORM.SUBTOTAL# GT 0>
		<CFSET FORM.TOTAL = #FORM.SUBTOTAL# + #FORM.SHIPPINGCOST#>
	</CFIF>

	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyPurchReqs" datasource="#application.type#PURCHASING">
		UPDATE	PURCHREQS
		SET		FISCALYEARID = #val(FORM.FISCALYEARID)#,
				REQUESTERID = #val(FORM.REQUESTERID)#,
				PURCHREQUNITID = #val(FORM.PURCHREQUNITID)#,
				PURCHASEJUSTIFICATION = UPPER('#FORM.PURCHASEJUSTIFICATION#'),
				RUSH = '#FORM.RUSH#',
			<CFIF IsDefined('FORM.RUSHJUSTIFICATION')>
				RUSHJUSTIFICATION = UPPER('#FORM.RUSHJUSTIFICATION#'),
               </CFIF>
               	FUNDACCTID = #val(FORM.FUNDACCTID)#,
                    SHIPPINGCOST = #val(FORM.SHIPPINGCOST)#,
				TOTAL = #val(FORM.TOTAL)#,
				REQNUMBER = UPPER('#FORM.REQNUMBER#'),
				SALESORDERNUMBER = UPPER('#FORM.SALESORDERNUMBER#'),
                    BUDGETTYPEID = #val(FORM.BUDGETTYPEID)#,
				PONUMBER = UPPER('#FORM.PONUMBER#'),
				VENDORID = #val(FORM.VENDORID)#,
				VENDORCONTACTID = #val(FORM.VENDORCONTACTID)#,
			<CFIF #FORM.QUOTEDATE# IS NOT "">
				QUOTEDATE = TO_DATE('#FORM.QUOTEDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				QUOTE = UPPER('#FORM.QUOTE#'),
				SPECSCOMMENTS = UPPER('#FORM.SPECSCOMMENTS#'),
				IDTREVIEWERID = #val(FORM.IDTREVIEWERID)#,
			<CFIF #FORM.REVIEWDATE# IS NOT "">
				REVIEWDATE = TO_DATE('#FORM.REVIEWDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				RECVCOMMENTS = UPPER('#FORM.RECVCOMMENTS#'),
			<CFIF #FORM.REQFILEDDATE# IS NOT "">
				REQFILEDDATE = TO_DATE('#FORM.REQFILEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				COMPLETEFLAG = UPPER('#FORM.COMPLETEFLAG#'),
			<CFIF #FORM.COMPLETIONDATE# IS NOT "">
				COMPLETIONDATE = TO_DATE('#FORM.COMPLETIONDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				SWFLAG = UPPER('#FORM.SWFLAG#'),
                    CANCELLATION = '#FORM.CANCELLATION#'
		WHERE	PURCHREQID = #val(Cookie.PURCHREQID)#
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
     <CFSET SESSION.PurchReqID = #Cookie.PURCHREQID#>
     <CFINCLUDE template="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm">

	<CFIF IsDefined('URL.POPUP')>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Modified!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>

	<H1>Data MODIFIED!</H1>
     <CFIF #FORM.PROCESSPURCHREQ# EQ 'MODIFY TO PRINT'>
     	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqforms.cfm?PURCHREQID=#val(Cookie.PURCHREQID)#&FISCALYEAR=#FORM.FISCALYEARID#" />
     	<CFEXIT>
     </CFIF>
	<CFIF IsDefined('URL.LEGACY')>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LEGACY=YES" />
	<CFELSE>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSPURCHREQ EQ "DELETE" OR FORM.PROCESSPURCHREQ EQ "CANCELADD">

	<CFQUERY name="DeletePurchReqLines" datasource="#application.type#PURCHASING">
		DELETE FROM	PURCHREQLINES
		WHERE		PURCHREQID = #val(Cookie.PURCHREQID)#
	</CFQUERY> 

	<CFQUERY name="DeletePurchReqs" datasource="#application.type#PURCHASING">
		DELETE FROM	PURCHREQS
		WHERE 		PURCHREQID = #val(Cookie.PURCHREQID)#
	</CFQUERY>
	
	<CFIF IsDefined('URL.POPUP')>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>

	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSPURCHREQ EQ "DELETE">
		<CFIF IsDefined('URL.LEGACY')>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE&LEGACY=YES" />
		<CFELSE>
			<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/purchreqinfo.cfm?PROCESS=MODIFYDELETE" />
		</CFIF>
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>