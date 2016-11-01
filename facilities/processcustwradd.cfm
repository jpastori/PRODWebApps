<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processcustwradd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/10/2012 --->
<!--- Date in Production: 02/10/2012 --->
<!--- Module: Process Customer Work Request Add --->
<!-- Last modified by John R. Pastori on 02/10/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Customer Work Request Add </TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>


<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF #FORM.PROCESSCUSTWRADD# EQ "ADD">
	<CFOUTPUT>
	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(CUSTWRADDID) AS MAX_ID
		FROM		CUSTWRADD
     </CFQUERY>
     
     <CFSET FORM.CUSTWRADDID = #val(GetMaxUniqueID.MAX_ID+1)#>
     <CFCOOKIE name="CUSTWRADDID" secure="NO" value="#FORM.CUSTWRADDID#">
     
     <CFSET FORM.PROBLEM_DATE = #DateFormat(FORM.PROBLEM_DATE, "dd-mmm-yyyy")#>
     
     <CFTRANSACTION action="begin">
     <CFQUERY name="AddCustWRInfo" datasource="#application.type#FACILITIES">
          INSERT INTO	CUSTWRADD (CUSTWRADDID, REQUESTERID, ALTERNATE_CONTACTID, PROBLEM_DESCRIPTION, PROBLEM_LOCATIONID, PROBLEM_DATE, URGENCY)
          VALUES		(#val(Cookie.CUSTWRADDID)#, #val(FORM.REQUESTERID)#, #val(FORM.ALTERNATE_CONTACTID)#, UPPER('#FORM.PROBLEM_DESCRIPTION#'), 
                          #val(FORM.PROBLEM_LOCATIONID)#, TO_DATE('#FORM.PROBLEM_DATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'), '#FORM.URGENCY#')
     </CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
     <H1>Data ADDED!</H1>
     
     <CFQUERY name="LookupRequester" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, FULLNAME, EMAIL, ACTIVE
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = #val(FORM.REQUESTERID)# AND
                    ACTIVE = 'YES'
          ORDER BY	FULLNAME
     </CFQUERY>
     
     <CFQUERY name="LookupLocation" datasource="#application.type#FACILITIES">
          SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
                    LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
                    LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
          FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
          WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.PROBLEM_LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
                    LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
                    LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
          ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
     </CFQUERY>
     
     <!--- facility@rohan.sdsu.edu, wcontrol@mail.sdsu.edu, --->
     </CFOUTPUT>
<CFIF FORM.URGENCY GT 0 > 
	<CFIF FORM.URGENCY EQ 1>
     	<CFSET FORM.SUBJECT = 'Power Out/No Lights'>
     <CFELSE>
     	<CFSET FORM.SUBJECT = 'Public Service Affected'>
     </CFIF>   
     <CFMAIL query = "LookupRequester" 
          to="Infosys@library.sdsu.edu, pastori@rohan.sdsu.edu"
          from="#LookupRequester.EMAIL#"
          subject="#FORM.SUBJECT#"
          
     >
     
          #LookupRequester.FULLNAME# submitted a Work Request for #FORM.SUBJECT# in #LookupLocation.LOCATIONNAME# on #DateFormat(NOW(), 'mm/dd/yyyy')# .
     </CFMAIL>  
     
 </CFIF>
 
     <CFMAIL query = "LookupRequester" 
          to="Infosys@library.sdsu.edu, pastori@rohan.sdsu.edu"
          from="#LookupRequester.EMAIL#"
          subject="#LookupRequester.FULLNAME# has submitted a Work Request."
          
     >

          On #DateFormat(NOW(), 'mm/dd/yyyy')# #LookupRequester.FULLNAME# submitted a Work Request for #LookupLocation.LOCATIONNAME# 
          which can be viewed and modified at https://lfolkstest.sdsu.edu/DEVapps/facilities/custwrapproval.cfm?CUSTADDREQUEST=#val(Cookie.CUSTWRADDID)#.
     </CFMAIL>
    
     <CFOUTPUT>
     <META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/custwradd.cfm" />
     </CFOUTPUT>
</CFIF>

<CFIF #FORM.PROCESSCUSTWRADD# EQ "APPROVE">
	<CFOUTPUT>
     
     <CFSET FORM.PROBLEM_DATE = #DateFormat(FORM.PROBLEM_DATE, "dd-mmm-yyyy")#>

	<CFTRANSACTION action="begin">
	<CFQUERY name="UpdateCustWRInfo" datasource="#application.type#FACILITIES">
		UPDATE	CUSTWRADD
		SET		REQUESTERID = #val(FORM.REQUESTERID)#, 
          		ALTERNATE_CONTACTID = #val(FORM.ALTERNATE_CONTACTID)#,
                    PROBLEM_DESCRIPTION = UPPER('#FORM.PROBLEM_DESCRIPTION#'), 
                    PROBLEM_LOCATIONID = #val(FORM.PROBLEM_LOCATIONID)#, 
                    PROBLEM_DATE = TO_DATE('#FORM.PROBLEM_DATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'),
                    URGENCY = '#FORM.URGENCY#'
          WHERE	CUSTWRADDID = #cookie.CUSTADDREQUEST#                  
     </CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
  
    <CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
		SELECT	MAX(WORKREQUESTID) AS MAX_ID
		FROM		WORKREQUESTS
	</CFQUERY>
	<CFSET FORM.WORKREQUESTID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="WORKREQUESTID" secure="NO" value="#FORM.WORKREQUESTID#">
     
     <CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="GetMaxFYSeqNum" datasource="#application.type#FACILITIES">
		SELECT	FISCALYEARID, FISCALYEARSEQNUMBER AS MAX_FYSEQNUM
		FROM		WORKREQUESTS
		WHERE 	WORKREQUESTID = #val(FORM.WORKREQUESTID)# - 1
	</CFQUERY>
	<CFIF GetMaxFYSeqNum.FISCALYEARID LT ListCurrentFiscalYear.FISCALYEARID>
		<CFSET FORM.FYSEQNUM = 1>
	<CFELSE>
		<CFSET FORM.FYSEQNUM =  #val(GetMaxFYSeqNum.MAX_FYSEQNUM+1)#>
	</CFIF>

	<CFSET FORM.WORKREQUESTNUMBER = #ListCurrentFiscalYear.FISCALYEAR_2DIGIT# & #NumberFormat(FORM.FYSEQNUM,  '0009')#>
	<CFSET FORM.FISCALYEARID = #ListCurrentFiscalYear.FISCALYEARID#>
	<CFSET FORM.REQUESTTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>

	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUSTOMERID, UNITID, FULLNAME
          FROM		CUSTOMERS
          WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.REQUESTERID#" cfsqltype="CF_SQL_VARCHAR">
          ORDER BY	FULLNAME
     </CFQUERY>
     
     <CFIF FORM.REQUESTTYPEID EQ 2>
		<CFSET FORM.KEYREQUEST = 'YES'>
	<CFELSE>
		<CFSET FORM.KEYREQUEST = 'NO'>
	</CFIF>

	<CFIF FORM.REQUESTTYPEID EQ 4>
		<CFSET FORM.MOVEREQUEST = 'YES'>
	<CFELSE>
		<CFSET FORM.MOVEREQUEST = 'NO'>
	</CFIF>

	<CFIF FORM.REQUESTTYPEID EQ 1 OR FORM.REQUESTTYPEID EQ 3 OR FORM.REQUESTTYPEID EQ 5 OR FORM.REQUESTTYPEID EQ 7 OR FORM.REQUESTTYPEID EQ 8 OR FORM.REQUESTTYPEID EQ 11 OR FORM.REQUESTTYPEID EQ 15>
		<CFSET FORM.TNSREQUEST = 'YES'>
	<CFELSE>
		<CFSET FORM.TNSREQUEST = 'NO'>
	</CFIF>
     
     <CFSET FORM.INITAPPROVALDATE = #DateFormat(Now(), "dd-mmm-yyyy")#>

	<CFTRANSACTION action="begin">
	<CFQUERY name="AddWorkOrdersID" datasource="#application.type#FACILITIES">
		INSERT INTO	WORKREQUESTS(WORKREQUESTID, REQUESTTYPEID, FISCALYEARID, FISCALYEARSEQNUMBER, WORKREQUESTNUMBER, REQUESTDATE, REQUESTSTATUSID, 
          					   REQUESTERID, UNITID, ALTERNATECONTACTID, PROBLEMDESCRIPTION, LOCATIONID, URGENCY, KEYREQUEST, MOVEREQUEST, TNSREQUEST, INITAPPROVALDATE)
		VALUES		(#val(Cookie.WORKREQUESTID)#, #val(FORM.REQUESTTYPEID)#, #val(FORM.FISCALYEARID)#, #val(FORM.FYSEQNUM)#, '#FORM.WORKREQUESTNUMBER#',
					TO_DATE('#FORM.PROBLEM_DATE# #FORM.REQUESTTIME#', 'DD-MON-YYYY HH24:MI:SS'), 7, #val(FORM.REQUESTERID)#, #val(ListRequesters.UNITID)#,
                         #val(FORM.ALTERNATE_CONTACTID)#, UPPER('#FORM.PROBLEM_DESCRIPTION#'), #val(FORM.PROBLEM_LOCATIONID)#, '#FORM.URGENCY#', '#FORM.KEYREQUEST#',
                         '#FORM.MOVEREQUEST#', '#FORM.TNSREQUEST#', TO_DATE('#FORM.INITAPPROVALDATE# 00:00:00', 'DD-MON-YYYY HH24:MI:SS'))
	</CFQUERY>
     <CFTRANSACTION action = "commit"/>
	</CFTRANSACTION>
     
     <CFQUERY name="LookupWorkRequests" datasource="#application.type#FACILITIES" blockfactor="100">
          SELECT	WR.WORKREQUESTID, WR.REQUESTTYPEID, WR.FISCALYEARID, WR.FISCALYEARSEQNUMBER, WR.WORKREQUESTNUMBER, WR.REQUESTDATE,
                    WR.REQUESTSTATUSID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.EMAIL, RT.REQUESTTYPENAME, WR.REQUESTERID, WR.PROBLEMDESCRIPTION
          FROM		WORKREQUESTS WR, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTTYPES RT
          WHERE	WR.WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_VARCHAR"> AND
          		WR.REQUESTERID = CUST.CUSTOMERID AND
                    WR.REQUESTTYPEID = RT.REQUESTTYPEID
          ORDER BY	CUST.FULLNAME, RT.REQUESTTYPENAME
     </CFQUERY>
     
     <CFQUERY name="LookupAssigner" datasource="#application.type#LIBSHAREDDATA">
          SELECT	CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, EMAIL
          FROM		CUSTOMERS CUST
          WHERE	CUST.CUSTOMERID = <CFQUERYPARAM value="#Client.CUSTOMERID#" cfsqltype="CF_SQL_VARCHAR"> AND
                    CUST.ACTIVE = 'YES'
          ORDER BY	CUST.FULLNAME
     </CFQUERY>
<!---  #LookupWorkOrders.EMAIL#  --->
     </CFOUTPUT>

     <CFMAIL query = "LookupWorkRequests" 
               to="Infosys@library.sdsu.edu, pastori@rohan.sdsu.edu"
               from="#LookupAssigner.EMAIL#"
               subject="New Work Order Number Assigned"
               cc="#LookupAssigner.EMAIL#"
          >

On #DateFormat(NOW(), 'mm/dd/yyyy')# your Work Order has been entered in the queue as:

     Requester                  - #LookupWorkRequests.FULLNAME#
     WO Number                - #LookupWorkRequests.WORKREQUESTNUMBER#  
     Problem Description - #LookupWorkRequests.PROBLEMDESCRIPTION#
     
     Facilities will respond to Requester within one (1) week with updated status.

     </CFMAIL>

     <CFOUTPUT>          
     <META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFY&LOOKUPWORKREQUESTID=FOUND&WORKREQUESTID=#val(Cookie.WORKREQUESTID)#" />
     </CFOUTPUT>
</CFIF>

</BODY>
</HTML>