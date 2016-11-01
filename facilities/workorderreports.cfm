<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workorderreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/06/2007 --->
<!--- Date in Production: 09/06/2007 --->
<!--- Module: Look Up Process for Facilities - Work Order Report --->
<!-- Last modified by John R. Pastori on 09/06/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workorderreports.cfm">
<CFSET CONTENT_UPDATED = "September 06, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Orders Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWORKORDER")>
	<CFSET CURSORFIELD = "document.LOOKUP.WORKORDERNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">
</CFOUTPUT>

<!--- 
**********************************************************************************
* The following code is the Look Up Process for Facilities - Work Order Reports. *
**********************************************************************************
 --->

<CFINCLUDE template = "lookupworkorderinfo.cfm">

<!--- 
*******************************************************
* The following code displays the Work Order Reports. *
*******************************************************
 --->
<CFIF NOT IsDefined("URL.LOOKUPWORKORDER")>
	<CFEXIT>
<CFELSE>
	<CFSWITCH expression = #FORM.REPORTCHOICE#>
		<CFCASE value = 1>
			<CFINCLUDE template="workorderdbreport.cfm">
		</CFCASE>
		<CFCASE value = 2>
			<CFINCLUDE template="wokeyrequestsreport.cfm">
		</CFCASE>
		<CFCASE value = 3>
			<CFINCLUDE template="womoverequestsreport.cfm">
		</CFCASE>
		<CFCASE value = 4>
			<CFINCLUDE template="wotnsrequestsreport.cfm">
		</CFCASE>
		<CFDEFAULTCASE>
			<CFINCLUDE template="workorderdbreport.cfm">
		</CFDEFAULTCASE>
	</CFSWITCH> 
</CFIF>

</BODY>
</HTML>