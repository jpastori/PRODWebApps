<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processwalljacksinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/06/2012 --->
<!--- Date in Production: 07/06/2012 --->
<!--- Module: Process Information to Facilities Wall Jack Database--->
<!-- Last modified by John R. Pastori on 07/08/2015 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Wall Jack</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF FORM.PROCESSWALLJACK EQ "ADD" OR FORM.PROCESSWALLJACK EQ "MODIFY" OR FORM.PROCESSWALLJACK EQ "MODIFYLOOP">
	<CFQUERY name="ModifyWallJack"  datasource="#application.type#FACILITIES">
		UPDATE	WALLJACKS
		SET
				LOCATIONID = #val(FORM.JACKROOM)#,
				WALLDIRID = #val(FORM.WALLDIRID)#,
				CLOSET = UPPER('#FORM.CLOSET#'),
				JACKNUMBER = #val(FORM.JACKNUMBER)#,
				PORTLETTER = '#FORM.PORTLETTER#',
				ACTIVE = UPPER('#FORM.ACTIVE#'),
				INSERTTYPE = UPPER('#FORM.INSERTTYPE#'),
				VLANID = #val(FORM.VLANID)#,
				HARDWAREID = #val(FORM.HARDWAREID)#,
				CUSTOMERID = #val(FORM.CUSTOMERID)#,
				COMMENTS = UPPER('#FORM.COMMENTS#'),
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	(WALLJACKID = #val(Cookie.JACKID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSWALLJACK EQ "ADD">
		<H1>Data ADDED!</H1>
          <CFIF IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES">
			<SCRIPT language="JavaScript">
                    <!-- 
					alert("Data Added!");
                         window.close();
                    -->
               </SCRIPT>
               <CFEXIT>
          </CFIF>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=ADD" />
          <CFEXIT>
	<CFELSEIF FORM.PROCESSWALLJACK EQ "MODIFY">
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=MODIFYDELETE" />
          <CFEXIT>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSWALLJACK EQ "MODIFYMULTIPLE">
	<CFTRANSACTION action="begin">
	<CFQUERY name="ModifyWallJack" datasource="#application.type#FACILITIES">
		UPDATE	WALLJACKS
		SET		
			<CFIF IsDefined("FORM.JACKROOMCHANGED")>
				LOCATIONID = #val(FORM.JACKROOM)#,
			</CFIF>
			<CFIF IsDefined("FORM.WALLDIRECTIONCHANGED")>
				WALLDIRID = #val(FORM.WALLDIRID)#,
			</CFIF>
			<CFIF IsDefined("FORM.CLOSETCHANGED")>
				CLOSET = UPPER('#FORM.CLOSET#'),
			</CFIF>
			<CFIF IsDefined("FORM.JACKNUMBERCHANGED")>
				JACKNUMBER = UPPER('#FORM.JACKNUMBER#'),
			</CFIF>
			<CFIF IsDefined("FORM.PORTLETTERCHANGED")>
				PORTLETTER = '#FORM.PORTLETTER#',
			</CFIF>
			<CFIF IsDefined("FORM.ACTIVECHANGED")>
				ACTIVE = UPPER('#FORM.ACTIVE#'),
			</CFIF>
			<CFIF IsDefined("FORM.INSERTTYPECHANGED")>
				INSERTTYPE = UPPER('#FORM.INSERTTYPE#'),
			</CFIF>
			<CFIF IsDefined("FORM.VLANIDCHANGED")>
				VLANID = #val(FORM.VLANID)#,
			</CFIF>
			<CFIF IsDefined("FORM.HARDWAREIDCHANGED")>
				HARDWAREID = #val(FORM.HARDWAREID)#,
			</CFIF>
			<CFIF IsDefined("FORM.CUSTOMERIDCHANGED")>
				CUSTOMERID = #val(FORM.CUSTOMERID)#,
			</CFIF>
			<CFIF IsDefined("FORM.COMMENTSCHANGED")>
				COMMENTS = UPPER('#FORM.COMMENTS#'),
			</CFIF>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#,
				MODIFIEDDATE = TO_DATE('#FORM.MODIFIEDDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS')
		WHERE	WALLJACKID IN (#URL.WALLJACKIDS#)
	</CFQUERY>
	<CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
	<H1>Data MODIFIED!</H1>
	<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL" />
     <CFEXIT>
</CFIF>

<CFIF FORM.PROCESSWALLJACK EQ "MODIFYLOOP">
	<H1>Data MODIFIED!</H1><BR />
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.WallJackIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP" />
          <CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP&LOOKUPWALLJACK=FOUND" />
          <CFEXIT>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSWALLJACK EQ "NEXTRECORD">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.WallJackIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP" />
          <CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP&LOOKUPWALLJACK=FOUND" />
          <CFEXIT>
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSWALLJACK EQ "DELETELOOP">
		<CFQUERY name="DeleteWallJack" datasource="#application.type#FACILITIES">
			DELETE FROM	WALLJACKS
			WHERE 		WALLJACKID = #val(Cookie.JACKID)#
		</CFQUERY>
	<H1>Data DELETED!</H1>
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.WallJackIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP" />
		<CFEXIT>
	<CFELSE>
		<H1>Process Next Record</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljackmultiplemodloop.cfm?PROCESS=MODIFYLOOP&LOOKUPWALLJACK=FOUND" />
		<CFEXIT>
	</CFIF>
</CFIF>

<CFIF FIND('DELETE', #FORM.PROCESSWALLJACK#, 1) NEQ 0 OR FORM.PROCESSWALLJACK EQ "CANCELADD">
	<CFIF FORM.PROCESSWALLJACK EQ "DELETE" OR FORM.PROCESSWALLJACK EQ "CANCELADD">
		<CFQUERY name="DeleteWallJack" datasource="#application.type#FACILITIES">
			DELETE FROM	WALLJACKS
			WHERE 		WALLJACKID = #val(Cookie.JACKID)#
		</CFQUERY>
	</CFIF>
	<CFIF FORM.PROCESSWALLJACK EQ "DELETEMULTIPLE">
		<CFQUERY name="DeleteWALLJACK" datasource="#application.type#FACILITIES">
			DELETE FROM	WALLJACKS
			WHERE 		WALLJACKID IN (#URL.WALLJACKIDS#)
		</CFQUERY>
	</CFIF>
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
	<CFIF FORM.PROCESSWALLJACK EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljacksinfo.cfm?PROCESS=MODIFYDELETE" />
	<CFELSEIF FORM.PROCESSWALLJACK EQ "DELETEMULTIPLE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#" />
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>