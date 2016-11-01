<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processworkrequestsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/13/2012 --->
<!--- Date in Production: 02/13/2012 --->
<!--- Module: Process Information to Facilities - Work Requests --->
<!-- Last modified by John R. Pastori on 02/13/2012 using ColdFusion Studio. -->

<HTML>
<HEAD>
	<TITLE>Process Information to Facilities - Work Requests </TITLE>
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSWORKREQUESTS EQ "Request Next Record">
	<CFIF session.ArrayCounter EQ ARRAYLEN(session.WORKREQUESTIDArray)>
		<H1>All Selected Records Processed!</H1>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	<CFELSE>
		<H1>Process Next Record</H1>
		<CFSET session.ArrayCounter = session.ArrayCounter +1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequestapproval.cfm?PROCESS=APPROVAL&LOOKUPWORKREQUEST=FOUND&APPROVAL=#session.APPROVAL#&INITREQ=NO" />
	</CFIF>
	<CFEXIT>
</CFIF>

<CFIF FORM.PROCESSWORKREQUESTS NEQ "CANCELADD">
	<CFSET FORMATSTARTDATE = #DateFormat(FORM.STARTDATE, 'dd-mmm-yyyy')#>
	<CFSET FORMATSTARTDATETIME = '00:00:00'>
</CFIF>

<CFIF (FIND('MODIFY', FORM.PROCESSWORKREQUESTS, 1) NEQ 0) OR FORM.PROCESSWORKREQUESTS EQ "Approve/Cancel Request">
	<CFSET FORMATCOMPLETIONDATE = #DateFormat(FORM.COMPLETIONDATE, 'dd-mmm-yyyy')#>
	<CFSET FORMATCOMPLETIONDATETIME = '00:00:00'>
</CFIF>

<CFIF NOT FORM.PROCESSWORKREQUESTS EQ "DELETE" AND NOT FORM.PROCESSWORKREQUESTS EQ "CANCELADD">

	<CFQUERY name="ListRequestTypes" datasource="#application.type#FACILITIES">
		SELECT	REQUESTTYPEID, REQUESTTYPENAME
		FROM		REQUESTTYPES
		WHERE	REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	REQUESTTYPENAME
	</CFQUERY>

	<CFSET FORM.REQUESTTYPENAME = #ListRequestTypes.REQUESTTYPENAME#>
</CFIF>

<CFIF IsDefined('FORM.REQUESTERID')>

	<CFQUERY name="ListRequesters" datasource="#application.type#LIBSHAREDDATA">
		SELECT	CUSTOMERID, FULLNAME, UNITID, LOCATIONID, EMAIL
		FROM		CUSTOMERS
		WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.REQUESTERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	CUSTOMERID
	</CFQUERY>

	<CFCOOKIE name="CUSTID" secure="NO" value="#ListRequesters.CUSTOMERID#">
</CFIF>
</CFOUTPUT>

<CFIF (FIND('ADD', FORM.PROCESSWORKREQUESTS, 1) NEQ 0 OR FIND('MODIFY', FORM.PROCESSWORKREQUESTS, 1) NEQ 0) AND (FORM.PROCESSWORKREQUESTS NEQ "CANCELADD")>

	<CFOUTPUT>
	THE VALUE PASSED FOR FORM.PROCESSWORKREQUESTS VARIABLE = #FORM.PROCESSWORKREQUESTS#<BR /><BR />

	<CFIF FIND('ADD', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>

		<CFIF #FORM.UNITID# EQ 0>
			<CFSET FORM.UNITID = #val(ListRequesters.UNITID)#>
		</CFIF>
		<CFIF #FORM.LOCATIONID# EQ 0>
			<CFSET FORM.LOCATIONID = #val(ListRequesters.LOCATIONID)#>
		</CFIF>
	
		<CFIF FORM.ALTERNATECONTACTID EQ 0>
			<CFSET FORM.ALTERNATECONTACTID = #val(ListRequesters.CUSTOMERID)#>
		</CFIF>
		<CFCOOKIE name="SUPERVID" secure="NO" value="#FORM.SUPEMAILID#">

	</CFIF>

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
     
     <CFIF IsDefined('FORM.INITAPPROVALDATE') AND NOT #FORM.INITAPPROVALDATE# EQ "">
		<CFSET FORMATINITAPPROVALDATE = #DateFormat(FORM.INITAPPROVALDATE, 'dd-mmm-yyyy')#>
		<CFSET FORMATINITAPPROVALTIME = '00:00:00'>
	</CFIF>
<!--- 
	<CFIF IsDefined('FORM.SUPAPPROVALDATE') AND NOT #FORM.SUPAPPROVALDATE# EQ "">
		<CFSET FORMATSUPAPPROVALDATE = #DateFormat(FORM.SUPAPPROVALDATE, 'dd-mmm-yyyy')#>
		<CFSET FORMATSUPAPPROVALTIME = '00:00:00'>
	</CFIF>
 --->
	</CFOUTPUT>

	<CFIF FIND('ADD', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0 OR FIND('MODIFY', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>
		<CFOUTPUT>
		<CFQUERY name="UpdateWorkRequests" datasource="#application.type#FACILITIES">
			UPDATE	WORKREQUESTS
			SET		REQUESTTYPEID = #val(FORM.REQUESTTYPEID)#,
					REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)#,
					REQUESTERID = #val(FORM.REQUESTERID)#,
					UNITID = #val(FORM.UNITID)#,
					LOCATIONID = #val(FORM.LOCATIONID)#,
					ALTERNATECONTACTID = #val(FORM.ALTERNATECONTACTID)#,
				<CFIF FIND('MODIFY', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0 AND #Client.ProcessFlag# EQ "Yes">
					ACCOUNTNUMBER2 = '#FORM.ACCOUNTNUMBER2#',
					ACCOUNTNUMBER3 = '#FORM.ACCOUNTNUMBER3#',
				</CFIF>
					PROBLEMDESCRIPTION = UPPER('#FORM.PROBLEMDESCRIPTION#'),
				<CFIF FIND('MODIFY', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>
					JUSTIFICATIONDESCRIPTION = UPPER('#FORM.JUSTIFICATIONDESCRIPTION#'),
				</CFIF>
				<CFIF IsDefined('FORMATINITAPPROVALDATE')>
					INITAPPROVALDATE = TO_DATE('#FORMATINITAPPROVALDATE# #FORMATINITAPPROVALTIME#', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
<!--- 				
					APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)#,
				<CFIF IsDefined('FORMATSUPAPPROVALDATE')>
					SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE# #FORMATSUPAPPROVALTIME#', 'DD-MON-YYYY HH24:MI:SS'),	
				</CFIF>
 --->
 				<CFIF IsDefined('FORM.SUPEMAILID')>
					SUPEMAILID = #val(FORM.SUPEMAILID)#,
                    </CFIF>
<!---
                    	APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)#,
                         MGMTEMAILID = #val(FORM.MGMTEMAILID)#,
 --->
					STARTDATE = TO_DATE('#FORMATSTARTDATE# #FORMATSTARTDATETIME#', 'DD-MON-YYYY HH24:MI:SS'),
				<CFIF FIND('MODIFY', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>
					COMPLETIONDATE = TO_DATE('#FORMATCOMPLETIONDATE# #FORMATCOMPLETIONDATETIME#', 'DD-MON-YYYY HH24:MI:SS'),
				</CFIF>
					URGENCY = '#FORM.URGENCY#',
                     <CFIF IsDefined('FORM.STATUS_COMMENTS')>
                         STATUS_COMMENTS = UPPER('#FORM.STATUS_COMMENTS#'),
                     </CFIF>
					KEYREQUEST = UPPER('#FORM.KEYREQUEST#'),
					MOVEREQUEST = UPPER('#FORM.MOVEREQUEST#'),
					TNSREQUEST = UPPER('#FORM.TNSREQUEST#')
			WHERE	WORKREQUESTID = #val(Cookie.WORKREQUESTID)#
		</CFQUERY>

		</CFOUTPUT>

		<CFIF FIND('ADD', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>
			<CFOUTPUT>

			<CFQUERY name="ListSupervisors" datasource="#application.type#LIBSHAREDDATA">
				SELECT	CUSTOMERID, UNITHEAD, DEPTCHAIR, EMAIL
				FROM		CUSTOMERS
				WHERE	CUSTOMERID = <CFQUERYPARAM value="#cookie.SUPERVID#" cfsqltype="CF_SQL_NUMERIC"> AND
						(UNITHEAD = 'YES' OR
						DEPTCHAIR = 'YES') AND
						ALLOWEDTOAPPROVE = 'YES'
				ORDER BY	CUSTOMERID
			</CFQUERY>

			<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES">
				SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
						LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
                              LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
				FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
				WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
						LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
						LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
				ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
			</CFQUERY>
			</CFOUTPUT>
			<!--- #ListSupervisors.EMAIL #--->
			<CFMAIL query = "ListSupervisors"
				to="mdotson@rohan.sdsu.edu" 
				from="facilities@libint.sdsu.edu"
				subject="Request for Unit Head Approval of #FORM.WORKREQUESTNUMBER# - #FORM.REQUESTTYPENAME# - #ListRequesters.FULLNAME#"
				cc="#ListRequesters.EMAIL#,mdotson@rohan.sdsu.edu"
			>

	#ListRequesters.FULLNAME# has requested #FORM.REQUESTTYPENAME# be done in Building #ListRoomNumbers.BUILDINGNAME# - Room #ListRoomNumbers.ROOMNUMBER#.
Please click on the https://lfolkstest.sdsu.edu/#application.type#apps/ link and login to the library's intranet.
Click on the Forms link then choose the Approve Facilities Work Request Link.  
The unapproved work requests associated with your e-mail address will display sequentially for your approval.
	Thank you for your input.
			</CFMAIL>
			<CFOUTPUT>
			THIS IS AN ADD REQUEST: #FORM.UNITID# &nbsp;&nbsp; #FORM.LOCATIONID# &nbsp;&nbsp; #FORM.REQUESTERID#<BR />
			<H1>Data ADDED!</H1>
			<CFIF FORM.PROCESSWORKREQUESTS EQ "ADD KEY/CARD REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keyrequestinfo.cfm?PROCESS=ADD" />
				<CFEXIT>
			</CFIF>
			<CFIF FORM.PROCESSWORKREQUESTS EQ "ADD MOVE REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/moverequestinfo.cfm?PROCESS=ADD" />
				<CFEXIT>
			</CFIF>
			<CFIF FORM.PROCESSWORKREQUESTS EQ "ADD TNS PHONE REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/tnsrequestinfo.cfm?PROCESS=ADD" />
				<CFEXIT>
			</CFIF>
			<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
			</CFOUTPUT>
		</CFIF>

		<CFIF FIND('MODIFY', #FORM.PROCESSWORKREQUESTS#, 1) NEQ 0>
<!--- 
			<CFIF IsDefined ('FORM.MGMTEMAILID') AND #FORM.MGMTEMAILID# GT 0 AND (NOT IsDefined ('APPROVEDBYMGMTID') OR #APPROVEDBYMGMTID# EQ 0)>
				<CFOUTPUT>
				<CFQUERY name="ListManagement" datasource="#application.type#LIBSHAREDDATA">
					SELECT	CUSTOMERID, UNITHEAD, DEPTCHAIR, EMAIL
					FROM		CUSTOMERS
					WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.MGMTEMAILID#" cfsqltype="CF_SQL_NUMERIC"> AND
							DEPTCHAIR = 'YES' AND
							ALLOWEDTOAPPROVE = 'YES'
					ORDER BY	CUSTOMERID
				</CFQUERY>
				<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES">
					SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
							LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
                                   LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
					FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
					WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
							LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
							LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
					ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
				</CFQUERY>
				</CFOUTPUT>
				<!--- #ListManagement.EMAIL #--->
				<CFMAIL query = "ListManagement"
					to="mdotson@rohan.sdsu.edu"
					from="facilities@libint.sdsu.edu"
					subject="Request for Management Approval of #FORM.WORKREQUESTNUMBER# - #FORM.REQUESTTYPENAME# - #ListRequesters.FULLNAME#"
					cc="mdotson@rohan.sdsu.edu"
				>

	#ListRequesters.FULLNAME# has requested #FORM.REQUESTTYPENAME# be done in Building #ListRoomNumbers.BUILDINGNAME# - Room #ListRoomNumbers.ROOMNUMBER#.
Please click on the https://lfolkstest.sdsu.edu/#application.type#apps/ link and login to the library's intranet.
Click on the Forms link then choose the Approve Facilities Work Request Link.  
The unapproved work requests associated with your e-mail address will display sequentially for your approval.
	Thank you for your input.
				</CFMAIL>
			</CFIF>
 --->
			<CFOUTPUT>
			<!--- THIS IS A MODIFY REQUEST: #FORM.UNITID# &nbsp;&nbsp; #FORM.LOCATIONID# &nbsp;&nbsp; #FORM.REQUESTERID#<BR /> --->
			<H1>Data MODIFIED!</H1>
			<CFIF FORM.PROCESSWORKREQUESTS EQ "MODIFY KEY/CARD REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/keyrequestinfo.cfm?PROCESS=MODIFYDELETE&INITREQ=WO" />
				<CFEXIT>
			</CFIF>
			<CFIF FORM.PROCESSWORKREQUESTS EQ "MODIFY MOVE REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/moverequestinfo.cfm?PROCESS=MODIFYDELETE&INITREQ=WO" />
				<CFEXIT>
			</CFIF>
			<CFIF  FORM.PROCESSWORKREQUESTS EQ "MODIFY TNS PHONE REQUEST">
				<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/tnsrequestinfo.cfm?PROCESS=MODIFYDELETE" />
				<CFEXIT>
			</CFIF>
			<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
			</CFOUTPUT>
		</CFIF>
	</CFIF>
</CFIF>

<!--- 
<CFIF FORM.PROCESSWORKREQUESTS EQ "Approve/Cancel Request">

	<CFIF IsDefined ('FORM.MGMTEMAILID') AND #FORM.MGMTEMAILID# GT 0 AND (NOT IsDefined ('APPROVEDBYMGMTID') OR #APPROVEDBYMGMTID# EQ 0)>
		<CFOUTPUT>

		<CFSET FORM.LOCATIONID = #val(ListRequesters.LOCATIONID)#>

		<CFQUERY name="ListManagement" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, UNITHEAD, DEPTCHAIR, EMAIL
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.MGMTEMAILID#" cfsqltype="CF_SQL_NUMERIC"> AND
					DEPTCHAIR = 'YES' AND
					ALLOWEDTOAPPROVE = 'YES'
			ORDER BY	CUSTOMERID
		</CFQUERY>

		<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES">
			SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
					LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
                         LOC.MODIFIEDBYID, LOC.MODIFIEDDATE, BN.BUILDINGNAME || ' - ' || LOC.ROOMNUMBER AS BUILDINGROOM
			FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
			WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> AND
					LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
					LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
			ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
		</CFQUERY>
		<!--- #ListManagement.EMAIL #--->
		</CFOUTPUT>
		<CFMAIL query = "ListManagement"
			to="mdotson@rohan.sdsu.edu" 
			from="facilities@libint.sdsu.edu"
			subject="Request for Management Approval of #FORM.WORKREQUESTNUMBER# - #FORM.REQUESTTYPENAME# - #ListRequesters.FULLNAME#"
			cc="<!--- mdotson@rohan.sdsu.edu --->"
		>

	#ListRequesters.FULLNAME# has requested #FORM.REQUESTTYPENAME# be done in Building #ListRoomNumbers.BUILDINGNAME# - Room #ListRoomNumbers.ROOMNUMBER#.
Please click on the https://lfolkstest.sdsu.edu/#application.type#apps/ link and login to the library's intranet.
Click on the Forms link then choose the Approve Facilities Work Request Link.  
The unapproved work requests associated with your e-mail address will display sequentially for your approval.
	Thank you for your input.
		</CFMAIL>
	</CFIF>

	<CFOUTPUT>


	<CFIF IsDefined ('FORM.SUPAPPROVALDATE')>
		<CFSET FORMATSUPAPPROVALDATE = #DateFormat(FORM.SUPAPPROVALDATE, 'dd-mmm-yyyy')#>
		<CFSET FORMATSUPAPPROVALTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>
	</CFIF>
	<CFIF IsDefined ('FORM.APPROVEDBYMGMTID') AND #FORM.APPROVEDBYMGMTID# GT 0 AND IsDefined('FORM.MGMTAPPROVALDATE')>
		<CFSET FORMATMGMTAPPROVALDATE = #DateFormat(FORM.MGMTAPPROVALDATE, 'dd-mmm-yyyy')#>
		<CFSET FORMATMGMTAPPROVALTIME = #TimeFormat(NOW(), 'HH:mm:ss')#>
	</CFIF>

	<CFQUERY name="UpdateWorkRequests" datasource="#application.type#FACILITIES">
		UPDATE	WORKREQUESTS
		SET		REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)#,
				ALTERNATECONTACTID = '#val(FORM.ALTERNATECONTACTID)#',
			<CFIF #session.APPROVAL# EQ "MGMT">
				ACCOUNTNUMBER2 = '#FORM.ACCOUNTNUMBER2#',
				ACCOUNTNUMBER3 = '#FORM.ACCOUNTNUMBER3#',
			</CFIF>
				PROBLEMDESCRIPTION = UPPER('#FORM.PROBLEMDESCRIPTION#'),
				JUSTIFICATIONDESCRIPTION = UPPER('#FORM.JUSTIFICATIONDESCRIPTION#'),
 
				APPROVEDBYSUPID = #val(FORM.APPROVEDBYSUPID)#,
				SUPEMAILID = #val(FORM.SUPEMAILID)#,
			<CFIF IsDefined ('FORM.SUPAPPROVALDATE')>
				SUPAPPROVALDATE = TO_DATE('#FORMATSUPAPPROVALDATE# #FORMATSUPAPPROVALTIME#', 'DD-MON-YYYY HH24:MI:SS'),
			</CFIF>
			<CFIF IsDefined ('FORM.MGMTEMAILID')>
				MGMTEMAILID = #val(FORM.MGMTEMAILID)#,
			</CFIF>
		<CFIF IsDefined ('FORM.APPROVEDBYMGMTID') AND #FORM.APPROVEDBYMGMTID# GT 0>
				APPROVEDBYMGMTID = #val(FORM.APPROVEDBYMGMTID)#
		</CFIF>

				STARTDATE = TO_DATE('#FORMATSTARTDATE# #FORMATSTARTDATETIME#', 'DD-MON-YYYY HH24:MI:SS'),
				COMPLETIONDATE = TO_DATE('#FORMATCOMPLETIONDATE# #FORMATCOMPLETIONDATETIME#', 'DD-MON-YYYY HH24:MI:SS'),
				URGENCY = UPPER('#FORM.URGENCY#')
		WHERE	WORKREQUESTID = #val(Cookie.WORKREQUESTID)#
	</CFQUERY>
	<H1>Work Request Approved!</H1>
	<CFIF #session.ArrayCounter# LT #session.WORKREQUESTSSELECTED#>
		<CFSET session.ArrayCounter = session.ArrayCounter +1>
		<CFIF session.PROCESS EQ 'APPROVAL'>
			<CFSET PROCESS = 'APPROVAL'>
		<CFELSE>
			<CFSET PROCESS = 'CUSTOMER'>
		</CFIF>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequestapproval.cfm?PROCESS=#PROCESS#&LOOKUPWORKREQUEST=FOUND&APPROVAL=#session.APPROVAL#&INITREQ=NO" />
	<CFELSE>
		<CFSET session.ArrayCounter = 0>
		<CFSET session.WORKREQUESTSSELECTED = 0>
		<CFSET session.PROCESS = ''>
		<H1>All Approvals Processed!</H1>
		<META http-equiv="Refresh" content="2; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
	</CFIF>
	</CFOUTPUT>
</CFIF>
 --->
 
<CFOUTPUT>

<CFIF FORM.PROCESSWORKREQUESTS EQ "DELETE" OR FORM.PROCESSWORKREQUESTS EQ "CANCELADD">
	<CFQUERY name="GetWorkRequests" datasource="#application.type#FACILITIES">
		SELECT	WORKREQUESTID, KEYREQUEST, MOVEREQUEST, TNSREQUEST
		FROM		WORKREQUESTS
		WHERE	WORKREQUESTID = <CFQUERYPARAM value="#Cookie.WORKREQUESTID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	WORKREQUESTID
	</CFQUERY>
	<CFSET DELETEID = #GetWorkRequests.WORKREQUESTID#>
	<CFIF FORM.PROCESSWORKREQUESTS EQ "DELETE">
		<CFIF GetWorkRequests.KEYREQUEST EQ 'YES'>
			<CFQUERY name="DeleteKeyRequests" datasource="#application.type#FACILITIES">
				DELETE FROM	KEYREQUESTS
				WHERE		KEYREQUESTWOID = <CFQUERYPARAM value="#DELETEID#" cfsqltype="CF_SQL_NUMERIC">
			</CFQUERY> 
			<H1>Key Request Data DELETED!</H1>
		</CFIF>
		<CFIF GetWorkRequests.MOVEREQUEST EQ 'YES'>
			<CFQUERY name="DeleteMoveRequests" datasource="#application.type#FACILITIES">
				DELETE FROM	MOVEREQUESTS 
				WHERE		MOVEREQUESTWOID = <CFQUERYPARAM value="#DELETEID#" cfsqltype="CF_SQL_NUMERIC">
			</CFQUERY>
			<H1>Move Request Data DELETED!</H1>
		</CFIF>
		<CFIF GetWorkRequests.TNSREQUEST EQ 'YES'>
			<CFQUERY name="DeleteTNSRequests" datasource="#application.type#FACILITIES">
				DELETE FROM	TNSREQUESTS
				WHERE		TNSREQUESTWOID = <CFQUERYPARAM value="#DELETEID#" cfsqltype="CF_SQL_NUMERIC">
			</CFQUERY>
			<H1>TNS Request Data DELETED!</H1>
		</CFIF>
	</CFIF>
	<CFQUERY name="DeleteWorkRequests" datasource="#application.type#FACILITIES">
		DELETE FROM	WORKREQUESTS
		WHERE		WORKREQUESTID = #val(DELETEID)#
	</CFQUERY> 
	<H1>Work Request Data DELETED!</H1>
	<CFIF FORM.PROCESSWORKREQUESTS EQ "DELETE">
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/facilities/workrequest.cfm?PROCESS=MODIFYDELETE" />
	<CFELSE>
		<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm" />
		<CFEXIT>
	</CFIF>
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>