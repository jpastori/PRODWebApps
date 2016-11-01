<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: matrlreqsdupscountrpts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/23/2009 --->
<!--- Date in Production: 01/23/2009 --->
<!--- Module: Special Collections - Material Requests & Duplications Count Reports --->
<!-- Last modified by John R. Pastori on 01/23/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm">
<CFSET CONTENT_UPDATED = "January 23, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Material Requests & Duplications Count Reports</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPMATRLREQSDUPSRECORD')>
	<CFSET CURSORFIELD = "document.LOOKUP.RESEARCHERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFOUTPUT>

<!--- 
*************************************************************************************************
* The following code is the Look Up Process for Material Requests & Duplications Count Reports. *
*************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPMATRLREQSDUPSRECORD')>

	<CFQUERY name="ListResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
		SELECT	RESEARCHERID, HONORIFIC, FIRSTNAME, LASTNAME, FULLNAME, INSTITUTION, DEPTMAJOR, ADDRESS, CITY, STATEID, ZIPCODE,
				PHONE, FAX, EMAIL, IDTYPEID, IDNUMBER, STATUSID, INITIALTOPIC, DATEREGISTERED, MODIFIEDBYID, MODIFIEDDATE
		FROM		RESEARCHERINFO
		ORDER BY	FULLNAME
	</CFQUERY>

	<CFQUERY name="ListCollections" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	COLLECTIONID, COLLECTIONNAME
		FROM		COLLECTIONS
		ORDER BY	COLLECTIONNAME
	</CFQUERY>

	<CFQUERY name="ListAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	ASSISTANTID, ASSISTANTNAME
		FROM		ASSISTANTS
		ORDER BY	ASSISTANTNAME
	</CFQUERY>

	<CFQUERY name="ListSecondAssistants" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	ASSISTANTID, ASSISTANTNAME
		FROM		ASSISTANTS
		ORDER BY	ASSISTANTNAME
	</CFQUERY>

	<CFQUERY name="ListServices" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	SERVICEID, SERVICENAME
		FROM		SERVICES
		ORDER BY	SERVICENAME
	</CFQUERY>

	<CFQUERY name="ListActiveApprovers" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="25">
		SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE
		FROM		ASSISTANTS
		WHERE	(ASSISTANTID = 0) OR
				(ACTIVE = 'YES' AND
				APPROVAL = 'YES')
				ORDER BY	ASSISTANTNAME
	</CFQUERY>

	<CFQUERY name="ListPaidTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
		SELECT	PAIDTYPEID, PAIDTYPENAME
		FROM		PAIDTYPES
		ORDER BY	PAIDTYPENAME
	</CFQUERY>

	<CFQUERY name="ListModifiedBy" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	ASSISTANTID, ASSISTANTNAME
		FROM		ASSISTANTS
		ORDER BY	ASSISTANTNAME
	</CFQUERY>

	<TABLE width="100%" align="LEFT" border="3">
		<TR align="center">
			<TH align="center"><H1>Special Collections - Material Requests & Duplications Count Reports Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<BR /><BR /><BR />

	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center" colspan="4">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm?LOOKUPMATRLREQSDUPSRECORD=FOUND" method="POST" ENABLECAB="Yes">

		<CFINCLUDE template = "matrlreqsdupslookup.cfm">

		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="34">
				<LABEL for="REPORTCHOICE1">Collection Name Count Report</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="35">
				<LABEL for="REPORTCHOICE2">Service Date Count Report</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="36">
				<LABEL for="REPORTCHOICE3">Service Name Count Report</LABEL><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="37" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="38" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="SUBMIT" value="Cancel" tabindex="39" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
	<CFEXIT>
	
<CFELSE>

<!--- 
***********************************************************************************
* The following code displays the Material Requests & Duplications Count Reports. *
***********************************************************************************
 --->
 
	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'C.COLLECTIONNAME~ CHARSERVICEYEAR~ CHARSERVICEMONTH'>
	<CFSET SORTORDER[2] = 'CHARSERVICEDATE~ CHARSERVICEYEAR~ CHARSERVICEMONTH'>
	<CFSET SORTORDER[3] = 'S.SERVICENAME~ CHARSERVICEYEAR~ CHARSERVICEMONTH'>

	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>

	<CFIF "#FORM.SERVICEDATE#" NEQ ''>
		<CFSET SERVICEDATELIST = "NO">
		<CFSET SERVICEDATERANGE = "NO">
		<CFIF FIND(',', #FORM.SERVICEDATE#, 1) EQ 0 AND FIND(';', #FORM.SERVICEDATE#, 1) EQ 0>
			<CFSET FORM.SERVICEDATE = DateFormat(FORM.SERVICEDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.SERVICEDATE#, 1) NEQ 0>
				<CFSET SERVICEDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.SERVICEDATE#, 1) NEQ 0>
				<CFSET SERVICEDATERANGE = "YES">
				<CFSET FORM.SERVICEDATE = #REPLACE(FORM.SERVICEDATE, ";", ",")#>
			</CFIF>
			<CFSET SERVICEDATEARRAY = ListToArray(FORM.SERVICEDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(SERVICEDATEARRAY)# >
				SERVICE DATE FIELD = #SERVICEDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP>
		</CFIF>
		<CFIF SERVICEDATERANGE EQ "YES">
			<CFSET BEGINSERVICEDATE = DateFormat(#SERVICEDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDSERVICEDATE = DateFormat(#SERVICEDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		SERVICE DATE LIST = #SERVICEDATELIST#<BR><BR>
		SERVICE DATE RANGE = #SERVICEDATERANGE#<BR><BR>
	</CFIF>

	<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATE = "NO">
		<CFSET MODIFIEDDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) EQ 0 AND FIND(';', #FORM.MODIFIEDDATE#, 1) EQ 0>
			<CFSET FORM.MODIFIEDDATE = DateFormat(FORM.MODIFIEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATERANGE = "YES">
				<CFSET FORM.MODIFIEDDATE = #REPLACE(FORM.MODIFIEDDATE, ";", ",")#>
			</CFIF>
			<CFSET MODIFIEDDATEARRAY = ListToArray(FORM.MODIFIEDDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIED DATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MODIFIED DATE LIST = #MODIFIEDDATELIST#<BR><BR>
		MODIFIED DATE RANGE = #MODIFIEDDATERANGE#<BR><BR>
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupMatrlReqsDups" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
		SELECT	MRD.MRDID, MRD.RESEARCHERID, R.FULLNAME, MRD.TOPIC, MRD.COLLECTIONID, C.COLLECTIONNAME, MRD.CALLNUMBER, MRD.BOXNUMBER,
				MRD.SERVICEDATE, TO_CHAR(MRD.SERVICEDATE, 'YYYY-MM-DD') AS CHARSERVICEDATE, TO_CHAR(MRD.SERVICEDATE, 'YYYY') AS CHARSERVICEYEAR,
				TO_CHAR(MRD.SERVICEDATE, 'MM') AS CHARSERVICEMONTH, MRD.ASSISTANTNAMEID, MRD.SECONDASSISTANTNAMEID, MRD.SERVICEID, S.SERVICENAME,
				MRD.APPROVEDBYID, MRD.TOTALCOPIESMADE, MRD.COSTFORSERVICE, MRD.PAIDTYPEID, MRD.COMMENTS, MRD.MODIFIEDBYID, MRD.MODIFIEDDATE,
				R.FULLNAME || ' - ' || MRD.TOPIC AS RNAMETOPIC
		FROM		MATRLREQSDUPS MRD, RESEARCHERINFO R, SERVICES S, COLLECTIONS C
		WHERE	(MRD.MRDID > 0 AND
				MRD.RESEARCHERID = R.RESEARCHERID AND
				MRD.SERVICEID = S.SERVICEID AND
				MRD.COLLECTIONID = C.COLLECTIONID) AND (

		<CFIF #FORM.RESEARCHERID# GT 0>
			<CFIF IsDefined("FORM.NEGATERESEARCHERID")>
				NOT (MRD.RESEARCHERID = #val(FORM.RESEARCHERID)#) #LOGICANDOR#
			<CFELSE>
				MRD.RESEARCHERID = #val(FORM.RESEARCHERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.TOPIC# NEQ "">
			<CFIF IsDefined("FORM.NEGATETOPIC")>
				NOT MRD.TOPIC LIKE '%#FORM.TOPIC#%' #LOGICANDOR#
			<CFELSE>
				MRD.TOPIC LIKE '%#FORM.TOPIC#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.COLLECTIONID# GT 0>
			<CFIF IsDefined("FORM.NEGATECOLLECTIONID")>
				NOT (MRD.COLLECTIONID = #val(FORM.COLLECTIONID)#) #LOGICANDOR#
			<CFELSE>
				MRD.COLLECTIONID = #val(FORM.COLLECTIONID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CALLNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATECALLNUMBER")>
				NOT MRD.CALLNUMBER LIKE '%#FORM.CALLNUMBER#%' #LOGICANDOR#
			<CFELSE>
				MRD.CALLNUMBER LIKE '%#FORM.CALLNUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.BOXNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEBOXNUMBER")>
				NOT MRD.BOXNUMBER LIKE '%#FORM.BOXNUMBER#%' #LOGICANDOR#
			<CFELSE>
				MRD.BOXNUMBER LIKE '%#FORM.BOXNUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.SERVICEDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATESERVICEDATE")>
				<CFIF SERVICEDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(SERVICEDATEARRAY)#>
						<CFSET FORMATSERVICEDATE =  DateFormat(#SERVICEDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT MRD.SERVICEDATE = TO_DATE('#FORMATSERVICEDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF SERVICEDATERANGE EQ "YES">
					NOT (MRD.SERVICEDATE BETWEEN TO_DATE('#BEGINSERVICEDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSERVICEDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT MRD.SERVICEDATE LIKE TO_DATE('#FORM.SERVICEDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF SERVICEDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(SERVICEDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATSERVICEDATE = DateFormat(#SERVICEDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						MRD.SERVICEDATE = TO_DATE('#FORMATSERVICEDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATSERVICEDATE = DateFormat(#SERVICEDATEARRAY[ArrayLen(SERVICEDATEARRAY)]#, 'DD-MMM-YYYY')>
					MRD.SERVICEDATE = TO_DATE('#FORMATSERVICEDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF SERVICEDATERANGE EQ "YES">
						(MRD.SERVICEDATE BETWEEN TO_DATE('#BEGINSERVICEDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDSERVICEDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					MRD.SERVICEDATE LIKE TO_DATE('#FORM.SERVICEDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

		<CFIF #FORM.ASSISTANTNAMEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEASSISTANTNAMEID")>
				NOT (MRD.ASSISTANTNAMEID = #val(FORM.ASSISTANTNAMEID)#) #LOGICANDOR#
			<CFELSE>
				MRD.ASSISTANTNAMEID = #val(FORM.ASSISTANTNAMEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SECONDASSISTANTNAMEID# GT 0>
			<CFIF IsDefined("FORM.NEGATESECONDASSISTANTNAMEID")>
				NOT (MRD.SECONDASSISTANTNAMEID = #val(FORM.SECONDASSISTANTNAMEID)#) #LOGICANDOR#
			<CFELSE>
				MRD.SECONDASSISTANTNAMEID = #val(FORM.SECONDASSISTANTNAMEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SERVICEID# GT 0>
			<CFIF IsDefined("FORM.NEGATESERVICEID")>
				NOT (MRD.SERVICEID = #val(FORM.SERVICEID)#) #LOGICANDOR#
			<CFELSE>
				MRD.SERVICEID = #val(FORM.SERVICEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.APPROVEDBYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEAPPROVEDBYID")>
				NOT (MRD.APPROVEDBYID = #val(FORM.APPROVEDBYID)#) #LOGICANDOR#
			<CFELSE>
				MRD.APPROVEDBYID = #val(FORM.APPROVEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.TOTALCOPIESMADE# NEQ "">
			<CFIF IsDefined("FORM.NEGATETOTALCOPIESMADE")>
				NOT MRD.TOTALCOPIESMADE = #val(FORM.TOTALCOPIESMADE)#' #LOGICANDOR#
			<CFELSE>
				MRD.TOTALCOPIESMADE = #val(FORM.TOTALCOPIESMADE)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.COSTFORSERVICE# NEQ "">
			<CFIF IsDefined("FORM.NEGATECOSTFORSERVICE")>
				NOT MRD.COSTFORSERVICE = #val(FORM.COSTFORSERVICE)#' #LOGICANDOR#
			<CFELSE>
				MRD.COSTFORSERVICE = #val(FORM.COSTFORSERVICE)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PAIDTYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEPAIDTYPEID")>
				NOT (MRD.PAIDTYPEID = #val(FORM.PAIDTYPEID)#) #LOGICANDOR#
			<CFELSE>
				MRD.PAIDTYPEID = #val(FORM.PAIDTYPEID)# #LOGICANDOR#
				</CFIF>
		</CFIF>

		<CFIF #FORM.COMMENTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATECOMMENTS")>
				NOT MRD.COMMENTS LIKE '%#FORM.COMMENTS#%' #LOGICANDOR#
			<CFELSE>
				MRD.COMMENTS LIKE '%#FORM.COMMENTS#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
				NOT (MRD.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#) #LOGICANDOR#
			<CFELSE>
				MRD.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT MRD.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (MRD.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT MRD.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						MRD.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					MRD.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(MRD.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					MRD.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

				MRD.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	#REPORTORDER#
	</CFQUERY>
<!--- 
	<BR><BR>SERVICE YEAR = #LookupMatrlReqsDups.CHARSERVICEYEAR# &nbsp;&nbsp;&nbsp;&nbsp;SERVICE MONTH = #LookupMatrlReqsDups.CHARSERVICEMONTH#<BR><BR>
 --->
	<CFIF #LookupMatrlReqsDups.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Material Requests & Duplications records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm" />
		<CFEXIT>

	<CFELSE>

		<CFSET COMPAREGROUPFIELDVALUE = "">
		<CFSET COMPAREMONTH = "">
		<CFSET COMPAREYEAR = "">
		<CFSET DBGROUPFIELDVALUE = "">
		<CFSET FIRSTPASS = "YES">
		<CFSET MONTHVISITCOUNT = 0>
		<CFSET REPORTTITLE = "">
		<CFSET COMPAREYEAR = "">
		<CFSET TOTALVISITCOUNT = 0>
		<CFSET YEARVISITCOUNT = 0>

		<CFSWITCH expression = #FORM.REPORTCHOICE#>

			<CFCASE value = 1>
				<CFSET DBGROUPFIELDVALUE = "LookupMatrlReqsDups.COLLECTIONNAME">
				<CFSET REPORTTITLE ="Collection Visit Count Report">
			</CFCASE>

			<CFCASE value = 2>
				<CFSET DBGROUPFIELDVALUE = "LookupMatrlReqsDups.CHARSERVICEDATE">
				<CFSET REPORTTITLE ="Service Date Visit Count Report">
			</CFCASE>

			<CFCASE value = 3>
				<CFSET DBGROUPFIELDVALUE = "LookupMatrlReqsDups.SERVICENAME">
				<CFSET REPORTTITLE ="Service Name Visit Count Report">
			</CFCASE>

			<CFDEFAULTCASE>
				<CFSET DBGROUPFIELDVALUE = "LookupMatrlReqsDups.COLLECTIONNAME">
				<CFSET REPORTTITLE ="Collection Visit Count Report">
			</CFDEFAULTCASE>

		</CFSWITCH>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center">
					<H1>#REPORTTITLE#</H1>
				</TH>
			</TR>
		</TABLE>
		<TABLE width="100%" align="left" border="0">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm" method="POST">
				<TD align="left">
					<INPUT type="submit" value="Cancel" tabindex="1" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TH align="LEFT" valign="TOP">Year/Month</TH>
				<TH align="LEFT" valign="TOP">Visit Count</TH>
			</TR>

<CFLOOP query="LookupMatrlReqsDups">
		<CFIF COMPAREMONTH EQ "" AND COMPAREYEAR EQ "">
			<CFSET COMPAREMONTH = #LookupMatrlReqsDups.CHARSERVICEMONTH#>
			<CFSET COMPAREYEAR = #LookupMatrlReqsDups.CHARSERVICEYEAR#>
		</CFIF>

		<CFIF COMPAREGROUPFIELDVALUE NEQ Evaluate("#DBGROUPFIELDVALUE#")>
			<CFIF FIRSTPASS EQ "YES">
				<CFSET FIRSTPASS = "NO">
			<CFELSE>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHVISITCOUNT, '999,999,999')#
				</TD>
			</TR>
			<TR>
				<TH align="CENTER" colspan="2">
					TOTAL #COMPAREGROUPFIELDVALUE#  VISIT COUNT IS #YEARVISITCOUNT#
					<CFSET TOTALVISITCOUNT = TOTALVISITCOUNT + YEARVISITCOUNT>
				</TH>
			</TR>
			<TR>
				<TH align="LEFT" colspan="2">
					<HR size="5" noshade>
				</TH>
			</TR>
			<TR>
				<TH align="LEFT" valign="TOP">Year/Month</TH>
				<TH align="LEFT" valign="TOP">Visit Count</TH>
			</TR>
			</CFIF>
			<TR>
				<CFSET COMPAREGROUPFIELDVALUE = Evaluate("#DBGROUPFIELDVALUE#")>
				<CFSET COMPAREMONTH = #LookupMatrlReqsDups.CHARSERVICEMONTH#>
				<CFSET COMPAREYEAR = #LookupMatrlReqsDups.CHARSERVICEYEAR#>
				<CFSET MONTHVISITCOUNT = 0>
				<CFSET YEARVISITCOUNT = 0>
				<TH align="LEFT" valign="TOP">#COMPAREGROUPFIELDVALUE#</TH>
			</TR>
		</CFIF>
<!--- 
			<TR>
				<TD ALIGN=LEFT COLSPAN="2">
					<BR>#COMPAREGROUPFIELDVALUE# VISIT YEAR/MONTH = #LookupMatrlReqsDups.CHARSERVICEYEAR#/#LookupMatrlReqsDups.CHARSERVICEMONTH#<BR>
				</TD>
			</TR>
 --->
		<CFIF COMPAREYEAR EQ #LookupMatrlReqsDups.CHARSERVICEYEAR# AND COMPAREMONTH EQ "#LookupMatrlReqsDups.CHARSERVICEMONTH#">
			<CFSET MONTHVISITCOUNT = MONTHVISITCOUNT + 1>
			<CFSET YEARVISITCOUNT = YEARVISITCOUNT + 1>
		<CFELSE>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
					<CFSET COMPAREMONTH = #LookupMatrlReqsDups.CHARSERVICEMONTH#>
					<CFSET COMPAREYEAR = #LookupMatrlReqsDups.CHARSERVICEYEAR#>
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHVISITCOUNT, '999,999,999')#
					<CFSET MONTHVISITCOUNT = 1>
					<CFSET YEARVISITCOUNT = YEARVISITCOUNT + 1>
				</TD>
			</TR>
		</CFIF>
</CFLOOP>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHVISITCOUNT, '999,999,999')#
					<CFSET MONTHVISITCOUNT = 1>
				</TD>
			</TR>
			<TR>
				<TH align="CENTER" colspan="2">
					TOTAL #COMPAREGROUPFIELDVALUE#  VISIT COUNT IS #YEARVISITCOUNT#
					<CFSET TOTALVISITCOUNT = TOTALVISITCOUNT + YEARVISITCOUNT>
				</TH>
			</TR>
			<TR>
				<TD colspan="2"><HR size="5" noshade></TD>
			</TR>

			<TR>
				<TD align="CENTER" valign="TOP" colspan="2"><STRONG><u>Visits Grand Total  = #NUMBERFORMAT(TOTALVISITCOUNT, '999,999,999')#</u></STRONG></TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm" method="POST">
				<TD align="left">
					<INPUT type="submit" value="Cancel" tabindex="2" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</CFOUTPUT>
</BODY>
</HTML>