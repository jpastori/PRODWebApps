<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workrequestreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Look Up Process for Facilities - Work Request Reports --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/workrequestreports.cfm">
<CFSET CONTENT_UPDATED = "February 10, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Work Request Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPWORKREQUEST")>
	<CFSET CURSORFIELD = "document.LOOKUP.WORKREQUESTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">


<!--- 
************************************************************************************
* The following code is the Look Up Process for Facilities - Work Request Reports. *
************************************************************************************
 --->

<CFINCLUDE template = "lookupworkrequestinfo.cfm">

<!--- 
*********************************************************
* The following code displays the Work Request Reports. *
*********************************************************
 --->
<CFIF NOT IsDefined('URL.LOOKUPWORKREQUEST')> 
	<CFEXIT>
<CFELSE>
	<CFSWITCH expression = #FORM.REPORTCHOICE#> 
		<CFCASE value = 1> 
			<CFINCLUDE template="workrequestsdbreport.cfm">
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
			<CFINCLUDE template="workrequestsdbreport.cfm">
		</CFDEFAULTCASE>
	</CFSWITCH>  
</CFIF> 


</BODY>
</CFOUTPUT>
</HTML>