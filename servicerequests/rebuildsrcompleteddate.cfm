<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: rebuildsrcompleteddate.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/08/2013 --->
<!--- Date in Production: 11/08/2013 --->
<!--- Module: Service Request - Build New SR Completed Date Adding Century --->
<!-- Last modified by John R. Pastori on 11/08/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/rebuildsrcompleteddate.cfm">
<CFSET CONTENT_UPDATED = "November 08, 2013">

<HTML> 
<HEAD>
	<TITLE>Service Request - Build New SR Completed Date Adding Century</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Service Requests Application!";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


//
</SCRIPT>

</HEAD>

<BODY>

<CFOUTPUT>

<CFSET CENTURY2DIGIT = "20">
<CFSET BUILDSRCOMPLETEDDATE = "">

<CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, SR.SRCOMPLETED, SR.SRCOMPLETEDDATE,
          		TO_CHAR(SR.SRCOMPLETEDDATE, 'MM/DD/YY') AS SRCOMPLETEDDATE_YR2
		FROM		SERVICEREQUESTS SR
		WHERE	SR.SRID > 0 AND
				SR.SRCOMPLETED = 'YES'
		ORDER BY	SR.SERVICEREQUESTNUMBER DESC
</CFQUERY>

<CFLOOP query="LookupServiceRequests">

	<BR>SR CREATION DATE = #LookupServiceRequests.CREATIONDATE#<BR><BR>
	SR COMPLETED DATE = #LookupServiceRequests.SRCOMPLETEDDATE#<BR><BR>
     SR COMPLETED DATE with 2 Digit Year = #LookupServiceRequests.SRCOMPLETEDDATE_YR2#<BR><BR>
	<CFSET BUILDSRCOMPLETEDDATE = LEFT(LookupServiceRequests.SRCOMPLETEDDATE_YR2, 6) & CENTURY2DIGIT & RIGHT(LookupServiceRequests.SRCOMPLETEDDATE_YR2, 2)>
     BUILD NEW SR COMPLETED DATE = #BUILDSRCOMPLETEDDATE#<BR><BR>
 
     <CFQUERY name="UpdateCompletedAssignment" datasource="#application.type#SERVICEREQUESTS">
          UPDATE	SERVICEREQUESTS
          SET		SRCOMPLETEDDATE = TO_DATE('#BUILDSRCOMPLETEDDATE#', 'MM/DD/YYYY')
          WHERE	(SRID = #val(LookupServiceRequests.SRID)#)
     </CFQUERY>
    
</CFLOOP>

</CFOUTPUT>

</body>
</html>