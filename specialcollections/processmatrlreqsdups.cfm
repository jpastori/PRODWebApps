<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processmatrlreqsdups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/05/2008 --->
<!--- Date in Production: 08/05/2008 --->
<!--- Module: Process Information to Special Collections - Material Requests & Duplications --->
<!-- Last modified by John R. Pastori on 08/05/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Special Collections - Material Requests & Duplications</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">


<CFIF FORM.PROCESSMATRLREQSDUPS EQ "ADD" OR FORM.PROCESSMATRLREQSDUPS EQ "MODIFY">

	<CFSET FORM.SERVICEDATE = DateFormat(FORM.SERVICEDATE, 'DD-MMM-YYYY')>

	<CFIF #FORM.COSTFORSERVICE# NEQ "" AND #FORM.COSTFORSERVICE# NEQ " ">
		<CFSET #FORM.COSTFORSERVICE# = #NUMBERFORMAT(FORM.COSTFORSERVICE, "999999.99")#>
	</CFIF>

	<CFQUERY name="ModifyMatrlReqsDups" datasource="#application.type#SPECIALCOLLECTIONS">
		UPDATE	MATRLREQSDUPS
		SET		RESEARCHERID = #val(FORM.RESEARCHERID)#,
				TOPIC = '#FORM.TOPIC#',
				COLLECTIONID = #val(FORM.COLLECTIONID)#,
				CALLNUMBER = '#FORM.CALLNUMBER#',
				BOXNUMBER = #val(FORM.BOXNUMBER)#,
				SERVICEDATE = TO_DATE('#FORM.SERVICEDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
				ASSISTANTNAMEID = #val(FORM.ASSISTANTNAMEID)#,
				SECONDASSISTANTNAMEID = #val(FORM.SECONDASSISTANTNAMEID)#,
				SERVICEID = #val(FORM.SERVICEID)#,
				APPROVEDBYID = #val(FORM.APPROVEDBYID)#,
				TOTALCOPIESMADE = '#FORM.TOTALCOPIESMADE#',
				COSTFORSERVICE = #val(FORM.COSTFORSERVICE)#,
				PAIDTYPEID = #val(FORM.PAIDTYPEID)#,
				COMMENTS = '#FORM.COMMENTS#',
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(MRDID = #val(Cookie.MRDID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSMATRLREQSDUPS EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSMATRLREQSDUPS EQ "DELETE" OR FORM.PROCESSMATRLREQSDUPS EQ "CANCELADD">
	<CFQUERY name="DeleteMatrlReqsDups" datasource="#application.type#SPECIALCOLLECTIONS">
		DELETE FROM	MATRLREQSDUPS
		WHERE 		MRDID = #val(Cookie.MRDID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSMATRLREQSDUPS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/specialcollections/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>