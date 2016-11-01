<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustsradd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/16/2012 --->
<!--- Date in Production: 08/16/2012 --->
<!--- Module: Process Customer Add Request --->
<!-- Last modified by John R. Pastori on 03/30/2016 using ColdFusion Studio. -->

<cfif SESSION.ORIGINSERVER EQ "">
	<cfinclude template = "../programsecuritycheck.cfm">
	<cfset SESSION.RETURNPGM = "/#application.type#apps/servicerequests/custsradd.cfm">
<cfelse>
	<cfset SESSION.RETURNPGM = "returnindex.cfm">
</cfif>

<html>
<head>
	<title>Process Customer Add Request</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>


<cfinclude template="/include/coldfusion/formheader.cfm">

<cfif #FORM.PROCESSCUSTSRADD# EQ "ADD">
	<cfoutput>
	<cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(CUSTSRADDID) AS MAX_ID
		FROM		CUSTSRADD
     </cfquery>
     
     <cfset FORM.CUSTSRADDID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <cfcookie name="CUSTSRADDID" secure="NO" value="#FORM.CUSTSRADDID#">
     
	<cfif IsDefined('FORM.BARCODENUMBER1') AND #FORM.BARCODENUMBER1# NEQ " INVENTORY BARCODE">
		<cfset FORM.EQUIPMENTBARCODE = FORM.BARCODENUMBER1>
	<cfelseif IsDefined('FORM.BARCODENUMBER2') AND #LEN(FORM.BARCODENUMBER2)# GT 7>
		<cfset FORM.EQUIPMENTBARCODE = FORM.BARCODENUMBER2>
     <cfelse>
     	<cfset FORM.EQUIPMENTBARCODE = ''>
	</cfif>
      
     <cfquery name="ListCustomerHardware" datasource="#application.type#HARDWARE" blockfactor="100">
          SELECT	HI.BARCODENUMBER, HI.SERIALNUMBER, HI.STATEFOUNDNUMBER, HI.EQUIPMENTTYPEID, EQT.EQUIPMENTTYPE, HI.MODELNAMEID, MNAMEL.MODELNAME,
                    HI.MODELNUMBERID, MNUMBERL.MODELNUMBER, HI.CUSTOMERID, CUST.FULLNAME, LOC.LOCATIONNAME,
                    CUST.FULLNAME || '-' || HI.BARCODENUMBER || '-' || EQT.EQUIPMENTTYPE || '-' || MNAMEL.MODELNAME AS LOOKUPBARCODE
          FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE EQT, MODELNAMELIST MNAMEL, MODELNUMBERLIST MNUMBERL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
                    FACILITIESMGR.LOCATIONS LOC
          WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR"> AND
                    HI.EQUIPMENTTYPEID = EQT.EQUIPTYPEID AND 
                    HI.MODELNAMEID = MNAMEL.MODELNAMEID AND
                    HI.MODELNUMBERID = MNUMBERL.MODELNUMBERID AND
                    HI.CUSTOMERID = CUST.CUSTOMERID AND
                    CUST.LOCATIONID = LOC.LOCATIONID
          ORDER BY	LOOKUPBARCODE
     </cfquery>
     
     <cfif #ListCustomerHardware.RecordCount# EQ 0>
          <cfset FORM.EQUIPMENTBARCODE = #FORM.EQUIPMENTBARCODE# & "*">
     </cfif>
     
     <cfset FORM.DATEENTERED = #DateFormat(NOW(), 'mm/dd/yyyy')#>
     
     <cfquery name="AddCustSRInfo" datasource="#application.type#SERVICEREQUESTS">
          INSERT INTO	CUSTSRADD (CUSTSRADDID, REQUESTERID, ALTERNATE_CONTACTID, PROBLEM_DESCRIPTION, EQUIPMENTBARCODE, DIVISIONNUMBER, EQUIPMENTLOCATION, DATEENTERED)
          VALUES		(#val(Cookie.CUSTSRADDID)#, #val(FORM.REQUESTERID)#, #val(FORM.ALTERNATE_CONTACTID)#, UPPER('#FORM.PROBLEM_DESCRIPTION#'), 
                          '#FORM.EQUIPMENTBARCODE#', UPPER('#FORM.DIVISIONNUMBER#'), UPPER('#FORM.EQUIPMENTLOCATION#'), TO_DATE('#FORM.DATEENTERED#', 'MM/DD/YYYY'))
     </cfquery>
     
     <h1>Data ADDED!</h1>
     
     <cfquery name="LookupRequester" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, FULLNAME, EMAIL, ACTIVE
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = #val(FORM.REQUESTERID)# AND
                    ACTIVE = 'YES'
          ORDER BY	FULLNAME
     </cfquery>
     
     
     </cfoutput>
     
     <cfmail query = "LookupRequester" 
          to="libinfosys@mail.sdsu.edu"
          from="#LookupRequester.EMAIL#"
          subject="#LookupRequester.FULLNAME# has submitted a Service Request."
          
     >
     
          On #DateFormat(NOW(), 'mm/dd/yyyy')# #LookupRequester.FULLNAME# submitted a Service Request which can be viewed and modified at https://lfolks.sdsu.edu/PRODapps/servicerequests/custsrapproval.cfm?CUSTADDREQUEST=#val(Cookie.CUSTSRADDID)#.
     </cfmail>
     
     <cfoutput>
     <meta http-equiv="Refresh" content="5; URL=#SESSION.RETURNPGM#" />
     <cfexit>
     </cfoutput>
</cfif>

<cfif #FORM.PROCESSCUSTSRADD# EQ "APPROVE">
	<cfoutput>
     
     <cfif (#FORM.EQUIPMENTBARCODE# NEQ '' AND #FORM.EQUIPMENTBARCODE# NEQ ' ')>

          <cfquery name="LookupHardware" datasource="#application.type#HARDWARE">
               SELECT	HI.HARDWAREID, HI.BARCODENUMBER
               FROM		HARDWAREINVENTORY HI
               WHERE	HI.BARCODENUMBER = <CFQUERYPARAM value="#FORM.EQUIPMENTBARCODE#" cfsqltype="CF_SQL_VARCHAR">
               ORDER BY	BARCODENUMBER
          </cfquery>
          
          <cfif (LookupHardware.RecordCount EQ 0)>
               <script language="JavaScript">
                    <!-- 
                         alert ("Barcode was Not Found in Hardware Inventory Records.");
                    -->
               </script>
               <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/custsrapproval.cfm?CUSTADDREQUEST=#cookie.CUSTADDREQUEST#" />
               <cfexit>
          </cfif>

     </cfif>

	<cfquery name="UpdateCustSRInfo" datasource="#application.type#SERVICEREQUESTS">
		UPDATE	CUSTSRADD
		SET		REQUESTERID = #val(FORM.REQUESTERID)#, 
          		ALTERNATE_CONTACTID = #val(FORM.ALTERNATE_CONTACTID)#,
                    PROBLEM_DESCRIPTION = UPPER('#FORM.PROBLEM_DESCRIPTION#'), 
                    EQUIPMENTBARCODE = '#FORM.EQUIPMENTBARCODE#', 
                    APPROVALFLAG = 'YES'
          WHERE	CUSTSRADDID = #cookie.CUSTADDREQUEST#                  
     </cfquery>
  
     <cfquery name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </cfquery>
     
     <cfquery name="ListServDeskInitials" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, LASTNAME, FULLNAME, INITIALS, ACTIVE
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = #Client.CUSTOMERID# AND
                    INITIALS IS NOT NULL AND
                    ACTIVE = 'YES'
          ORDER BY	FULLNAME
     </cfquery>
  
	<cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SRID) AS MAX_ID
		FROM		SERVICEREQUESTS
	</cfquery>
	<cfset FORM.SRID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<cfcookie name="SRID" secure="NO" value="#FORM.SRID#">

	<cfquery name="GetMaxFYSeqNum" datasource="#application.type#SERVICEREQUESTS">
		SELECT	FISCALYEARID, FISCALYEARSEQNUMBER AS MAX_FYSEQNUM
		FROM		SERVICEREQUESTS
		WHERE 	FISCALYEARID = <CFQUERYPARAM value="#ListCurrentFiscalYear.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
          ORDER BY	FISCALYEARID, MAX_FYSEQNUM DESC
	</cfquery>

	<cfif GetMaxFYSeqNum.RecordCount EQ 0>
		<cfset FORM.FYSEQNUM = 1>
	<cfelse>
		<cfset FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM + 1)#>
	</cfif>

	<cfset FORM.SERVICEREQUESTNUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & #NumberFormat(FORM.FYSEQNUM,  '0009')#>
	<cfset FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<cfset FORM.CREATIONDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
	<cfset FORM.CREATIONTIME = #TimeFormat(NOW(),'HH:mm:ss')#>
	<cfquery name="AddServiceRequestsIDInfo" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	SERVICEREQUESTS (SRID, FISCALYEARID, FISCALYEARSEQNUMBER, SERVICEREQUESTNUMBER, CREATIONDATE, CREATIONTIME, SERVICEDESKINITIALSID,
					REQUESTERID, ALTERNATE_CONTACTID, PROBLEM_CATEGORYID, PRIORITYID, PROBLEM_DESCRIPTION)
		VALUES		(#val(Cookie.SRID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.SERVICEREQUESTNUMBER#', 
          			 TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY'), TO_DATE('#FORM.CREATIONTIME#', 'HH24:MI:SS'), #val(ListServDeskInitials.CUSTOMERID)#,
					 #val(FORM.REQUESTERID)#, #val(FORM.ALTERNATE_CONTACTID)#, #val(FORM.PROBLEM_CATEGORYID)#, #val(FORM.PRIORITYID)#, UPPER('#FORM.PROBLEM_DESCRIPTION#'))
	</cfquery>
     
     <cfif IsDefined('FORM.EQUIPMENTBARCODE') AND #FORM.EQUIPMENTBARCODE# NEQ ''>
          <cfquery name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
               SELECT	MAX(SREQUIPID) AS MAX_ID
               FROM		SREQUIPLOOKUP
          </cfquery>
          <cfset FORM.SREQUIPID = #val(GetMaxUniqueID.MAX_ID+1)#>
          <cfquery name="AddSREquipLookup" datasource="#application.type#SERVICEREQUESTS">
               INSERT INTO	SREQUIPLOOKUP (SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE)
               VALUES		(#val(FORM.SREQUIPID)#, '#FORM.SERVICEREQUESTNUMBER#', '#FORM.EQUIPMENTBARCODE#')
          </cfquery>
	</cfif>
     
     <cfquery name="LookupServiceRequest" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.REQUESTERID, REQCUST.FULLNAME, REQCUST.EMAIL, P.PRIORITYNAME, SR.PROBLEM_DESCRIPTION
          FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST, PRIORITY P
          WHERE	SRID = <CFQUERYPARAM value="#Cookie.SRID#" cfsqltype="CF_SQL_VARCHAR"> AND
                    SR.REQUESTERID = REQCUST.CUSTOMERID AND
                    SR.PRIORITYID = P.PRIORITYID
          ORDER BY	SR.SRID
     </cfquery>
     
     <cfquery name="LookupAssigner" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, EMAIL
          FROM		CUSTOMERS CUST
          WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
                    CUST.ACTIVE = 'YES'
          ORDER BY	CUST.FULLNAME
     </cfquery>
   
     </cfoutput>

     <cfmail query = "LookupServiceRequest" 
               to="#LookupServiceRequest.EMAIL#"
               from="#LookupAssigner.EMAIL#"
               subject="New SR Number Assigned"
               cc="libinfosys@mail.sdsu.edu"
          >

On #DateFormat(NOW(), 'mm/dd/yyyy')# your SR has been entered in the queue as:

     Requester                  - #LookupServiceRequest.FULLNAME#
     SR Number                - #LookupServiceRequest.SERVICEREQUESTNUMBER#  
     Priority                      - #LookupServiceRequest.PRIORITYNAME#
     Problem Description - #LookupServiceRequest.PROBLEM_DESCRIPTION#

     </cfmail>
</cfif>

<cfif #FORM.PROCESSCUSTSRADD# EQ "APPROVE" OR #FORM.PROCESSCUSTSRADD# EQ "NOT APPROVED">
     <cfoutput> 
     
     <cftransaction action="begin">
     <cfquery name="DeleteCustSRInfo" datasource="#application.type#SERVICEREQUESTS">
          DELETE FROM	CUSTSRADD 
          WHERE		CUSTSRADDID = #cookie.CUSTADDREQUEST# 
     </cfquery>
     <cftransaction action = "commit"/>
     </cftransaction>
     <h1>Request Data DELETED!</h1>
     
     <cfif #FORM.PROCESSCUSTSRADD# EQ "APPROVE">              
     	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/servicerequestinfo.cfm?PROCESS=MODIFY&LOOKUPSR=FOUND&SRID=#val(LookupServiceRequest.SRID)#" />
     <cfelse>
     	<meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/index.cfm?logout=No" />
     </cfif>
     </cfoutput>
</cfif>

</body>
</html>