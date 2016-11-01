<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processssoftwareotheritems.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Software Inventory - Other Items --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Software Inventory - Other Items</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF (FIND('ADD', #FORM.PROCESSSOFTWAREOTHERITEMS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSSOFTWAREOTHERITEMS#, 1) NEQ 0) AND (FIND('CANCEL', #FORM.PROCESSSOFTWAREOTHERITEMS#, 1) EQ 0)>
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifySoftwareOtherItems" datasource="#application.type#SOFTWARE">
		UPDATE	OTHERITEMS
		SET		OTHERITEMS.OTHERITEMSQTY = #val(OTHERITEMSQTY)#,
				OTHERITEMS.LOCATIONID = #val(FORM.LOCATIONID)#,
				OTHERITEMS.PARTNUMBER = UPPER('#FORM.PARTNUMBER#'),
				OTHERITEMS.TITLE = UPPER('#FORM.TITLE#'),
				OTHERITEMS.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				OTHERITEMS.MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	OTHERITEMS.OTHERITEMSID = #val(Cookie.OTHERITEMSID)#
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "ADD">
	<H1>Data ADDED!</H1>
	<SCRIPT language="JavaScript">
		<!-- 
			alert("Data ADDED!");
			window.close();
		 -->
	</SCRIPT>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "ADDLOOP">
	<H1>Data ADDED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=ADD&SOFTWINVENTID=#val(Cookie.SOFTWINVENTID)#" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "MODIFY">
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYDELETE" />
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "MODIFYLOOP">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "DELETELOOP">
	<CFQUERY name="DeleteSoftwareOtherItems" datasource="#application.type#SOFTWARE">
		DELETE FROM	OTHERITEMS
		WHERE 		OTHERITEMS.OTHERITEMSID = #val(Cookie.OTHERITEMSID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.SoftwareIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYLOOP&LOOKUPTITLE=FOUND&LOOP=YES" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSSOFTWAREOTHERITEMS#, 1) NEQ 0 OR FORM.PROCESSSOFTWAREOTHERITEMS EQ "CANCELADD">
	<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "DELETE" OR FORM.PROCESSSOFTWAREOTHERITEMS EQ "CANCELADD">
		<CFQUERY name="DeleteSoftwareOtherItems" datasource="#application.type#SOFTWARE">
			DELETE FROM	OTHERITEMS
			WHERE 		OTHERITEMS.OTHERITEMSID = #val(Cookie.OTHERITEMSID)#
		</CFQUERY>
	</CFIF>
	<H1>Data DELETED!</H1>
	<CFIF FORM.PROCESSSOFTWAREOTHERITEMS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/softwareinventory/softwareotheritems.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data DELETED!");
				window.close();
		 	-->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>