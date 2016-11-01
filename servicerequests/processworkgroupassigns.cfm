<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processworkgroupassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/03/2009 --->
<!--- Date in Production: 02/03/2009 --->
<!--- Module: Process Information to IDT Service Requests - Workgroup Assigments --->
<!-- Last modified by John R. Pastori on 10/08/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Service Requests - Workgroup Assigments</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSWGASSIGNS EQ "ADD">
	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FULLNAME, INITIALS
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.STAFFCUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFLOOP from="1" to="#ListLen(FORM.GROUPID)#" index="Counter">
		<CFIF Counter EQ 1>
			<CFQUERY name="ModifyAddedWorkGroupAssigns" datasource="#application.type#SERVICEREQUESTS">
				UPDATE	WORKGROUPASSIGNS
				SET		STAFFCUSTOMERID = #val(FORM.STAFFCUSTOMERID)#,
						GROUPID = #val(ListGetAt(FORM.GROUPID, Counter))#,
						GROUPORDER = '#FORM.GROUPORDER#',
                              ACTIVE = '#FORM.ACTIVE#'
				WHERE	(WORKGROUPASSIGNSID = #val(Cookie.WORKGROUPASSIGNSID)#)
			</CFQUERY>
		<CFELSEIF Counter GT 1>
			<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
				SELECT	MAX(WORKGROUPASSIGNSID) AS MAX_ID
				FROM		WORKGROUPASSIGNS
			</CFQUERY>
			<CFSET FORM.WORKGROUPASSIGNSID = #val(GetMaxUniqueID.MAX_ID+1)#>
			<CFQUERY name="AddWorkGroupAssigns" datasource="#application.type#SERVICEREQUESTS">
				INSERT INTO	WORKGROUPASSIGNS (WORKGROUPASSIGNSID, STAFFCUSTOMERID, GROUPID, GROUPORDER)
				VALUES		(#val(FORM.WORKGROUPASSIGNSID)#, #val(FORM.STAFFCUSTOMERID)#, #val(ListGetAt(FORM.GROUPID, Counter))#, '#FORM.GROUPORDER#')
			</CFQUERY>
		</CFIF>
	</CFLOOP>
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=ADD" />
</CFIF>

<CFIF FORM.PROCESSWGASSIGNS EQ "MODIFY">

	<CFQUERY name="ModifyWorkGroupAssigns" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	WORKGROUPASSIGNS
		SET		STAFFCUSTOMERID = #val(FORM.STAFFCUSTOMERID)#,
				GROUPID = #val(FORM.GROUPID)#,
				GROUPORDER = '#FORM.GROUPORDER#',
                    ACTIVE = '#FORM.ACTIVE#'
		WHERE	(WORKGROUPASSIGNSID = #val(Cookie.WORKGROUPASSIGNSID)#)
	</CFQUERY>

	<H1>Data MODIFIED!</H1>
	<CFIF FORM.PROCESSWGASSIGNS EQ "MODIFY">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSWGASSIGNS EQ "DELETE" OR FORM.PROCESSWGASSIGNS EQ "CANCELADD">
	<CFQUERY name="DeleteWorkGroupAssigns" datasource="#application.type#SERVICEREQUESTS">
		DELETE FROM	WORKGROUPASSIGNS 
		WHERE		WORKGROUPASSIGNSID = #val(Cookie.WORKGROUPASSIGNSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSWGASSIGNS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>