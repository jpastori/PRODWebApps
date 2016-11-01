<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: rebuildsrassignmoddate.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/05/2013 --->
<!--- Date in Production: 12/05/2013 --->
<!--- Module: Service Request - Build New SR Assignment Modified Date Adding Century --->
<!-- Last modified by John R. Pastori on 12/05/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/rebuildsrassignmoddate.cfm">
<CFSET CONTENT_UPDATED = "December 05, 2013">

<HTML> 
<HEAD>
	<TITLE>Service Request - Build New SR Assignment Modified Date Adding Century</TITLE>
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
<CFSET BUILDSRASSIGNMODDATE = "">
<CFSET RECORDUPDATEDCOUNT = 0>

<CFQUERY name="LookupSRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
		SELECT	SRSTAFF_ASSIGNID, TO_CHAR(MODIFIEDDATE, 'MM/DD/YY') AS MODIFIEDDATE_YR2
		FROM		SRSTAFFASSIGNMENTS
		WHERE	SRSTAFF_ASSIGNID > 0 AND
          		NOT MODIFIEDDATE IS NULL
		ORDER BY	MODIFIEDDATE_YR2
</CFQUERY>

<CFLOOP query="LookupSRStaffAssignments">

	<BR>SR STAFF ASSIGNMENT MODIFIED DATE = #LookupSRStaffAssignments.MODIFIEDDATE_YR2#<BR><BR>
	<CFSET BUILDSRASSIGNMODDATE = LEFT(LookupSRStaffAssignments.MODIFIEDDATE_YR2, 6) & CENTURY2DIGIT & RIGHT(LookupSRStaffAssignments.MODIFIEDDATE_YR2, 2)>
     BUILD NEW SR COMPLETED DATE = #BUILDSRASSIGNMODDATE#<BR><BR>
 
     <CFQUERY name="UpdateCompletedAssignment" datasource="#application.type#SERVICEREQUESTS">
          UPDATE	SRSTAFFASSIGNMENTS
          SET		MODIFIEDDATE = TO_DATE('#BUILDSRASSIGNMODDATE#', 'MM/DD/YYYY')
          WHERE	(SRSTAFF_ASSIGNID = #val(LookupSRStaffAssignments.SRSTAFF_ASSIGNID)#)
     </CFQUERY>
	
	<CFSET RECORDUPDATEDCOUNT = RECORDUPDATEDCOUNT + 1>

</CFLOOP>
	<BR>
     <HR>
	<BR><BR>#RECORDUPDATEDCOUNT# RECORDS WERE UPDATED<BR><BR>


</CFOUTPUT>

</BODY>
</HTML>