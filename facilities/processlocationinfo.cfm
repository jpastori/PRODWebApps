<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processlocationinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/06/2012 --->
<!--- Date in Production: 06/06/2012 --->
<!--- Module: Process Information to Facilities Location --->
<!-- Last modified by John R. Pastori on 05/07/2013 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Location</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF IsDefined('FORM.PROCESSARCHIVELOCATION')>

	<CFQUERY name="ModifyLocation" datasource="#application.type#FACILITIES">
		UPDATE	LOCATIONS
	<CFIF FORM.PROCESSARCHIVELOCATION EQ "ADD">
		SET		ARCHIVELOCATION = 'YES',
	<CFELSE>
		SET		ARCHIVELOCATION = '#FORM.ARCHIVELOCATION#',
	</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(LOCATIONID = #val(FORM.LOCID)#)
	</CFQUERY>

	<CFIF FORM.PROCESSARCHIVELOCATION EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/archivelocation.cfm?PROCESS=ADD" />
		<CFEXIT>
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/hardwareinventory/archivelocation.cfm?PROCESS=MODIFY" />
		<CFEXIT>
	</CFIF>

</CFIF>

<CFIF FORM.PROCESSLOCATION NEQ "CANCELADD">
	<CFIF FORM.NPORTDATECHKED IS NOT "">
		<CFSET FORM.NPORTDATECHKED = DateFormat(FORM.NPORTDATECHKED, 'DD-MMM-YYYY')>
	</CFIF>
</CFIF>
<CFIF FORM.PROCESSLOCATION EQ "ADD" OR FORM.PROCESSLOCATION EQ "MODIFY">
	<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES">
		SELECT	BUILDINGNAMEID, BUILDINGNAME
		FROM		BUILDINGNAMES
		WHERE	BUILDINGNAMEID = <CFQUERYPARAM value="#FORM.BUILDINGNAMEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	BUILDINGNAME
	</CFQUERY>
	<CFSET FORM.BUILDINGNAME = #LookupBuildings.BUILDINGNAME#>
	<CFQUERY name="ModifyLocation" datasource="#application.type#FACILITIES">
		UPDATE	LOCATIONS
		SET		ROOMNUMBER = UPPER('#FORM.ROOMNUMBER#'),
				BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)#,
				LOCATIONNAME = UPPER('#FORM.BUILDINGNAME#' || ' - ' || '#FORM.ROOMNUMBER#'),
				LOCATIONDESCRIPTIONID = #val(FORM.LOCATIONDESCRIPTIONID)#,
				NETWORKPORTCOUNT = #val(FORM.NETWORKPORTCOUNT)#,
			<CFIF FORM.NPORTDATECHKED IS NOT "">
				LOCATIONS.NPORTDATECHKED = TO_DATE('#FORM.NPORTDATECHKED# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(LOCATIONID = #val(Cookie.LOCID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSLOCATION EQ "ADD">
     	 <CFIF IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES">
			<SCRIPT language="JavaScript">
                    <!-- 
					alert("Data Added!");
                         window.close();
                    -->
               </SCRIPT>
               <CFEXIT>
          </CFIF>
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationinfo.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationinfo.cfm?PROCESS=MODIFYDELETE" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSLOCATION EQ "DELETE" OR FORM.PROCESSLOCATION EQ "CANCELADD">
	<CFQUERY name="DeleteLocation" datasource="#application.type#FACILITIES">
		DELETE FROM	LOCATIONS 
		WHERE 		LOCATIONID = #val(Cookie.LOCID)#
	</CFQUERY> 
	<H1>Data DELETED!</H1>
     <CFIF IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES">
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Data Deleted!");
				window.close();
			 -->
		</SCRIPT>
		<CFEXIT>
	</CFIF>
	<CFIF FORM.PROCESSLOCATION EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/locationinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>