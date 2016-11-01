<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researcherinfodbreports.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/23/2009 --->
<!--- Date in Production: 01/23/2009 --->
<!--- Module: Special Collections - Researcher Information Detail Reports --->
<!-- Last modified by John R. Pastori on 01/23/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/researcherinfodbreports.cfm">
<CFSET CONTENT_UPDATED = "January 23, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<HTML>
<HEAD>
	<TITLE>Special Collections - Researcher Information Detail Reports </TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPRESEARCHERINFO')>
	<CFSET CURSORFIELD = "document.LOOKUP.HONORIFIC.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************************
* The following code is the Look Up Process for Researcher Information Detail Reports. *
****************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPRESEARCHERINFO')>

	<CFQUERY name="ListStates" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
		SELECT	STATEID, STATECODE, STATENAME, STATECODE || ' - ' || STATENAME AS STATECODENAME
		FROM		STATES
		ORDER BY	STATECODE
	</CFQUERY>

	<CFQUERY name="ListIDTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="12">
		SELECT	IDTYPEID, IDTYPENAME
		FROM		IDTYPES
		ORDER BY	IDTYPENAME
	</CFQUERY>

	<CFQUERY name="ListStatus" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
		SELECT	STATUSID, STATUSNAME
		FROM		STATUS
		ORDER BY	STATUSNAME
	</CFQUERY>

	<CFQUERY name="ListModifiedBy" datasource="#application.type#SPECIALCOLLECTIONS">
		SELECT	ASSISTANTID, ASSISTANTNAME
		FROM		ASSISTANTS
		ORDER BY	ASSISTANTNAME
	</CFQUERY>

	<TABLE width="100%" align="LEFT" border="3">
		<TR align="center">
			<TH align="center"><H1>Special Collections - Researcher Information Detail Reports Selection Lookup</H1></TH>
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
<CFFORM name="LOOKUP" action="/#application.type#apps/specialcollections/researcherinfodbreports.cfm?LOOKUPRESEARCHERINFO=FOUND" method="POST" ENABLECAB="Yes">

		<CFINCLUDE template = "researcherinfolookup.cfm">

		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="40">
				<LABEL for="REPORTCHOICE1">Researcher Full Report</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="41">
				<LABEL for="REPORTCHOICE2">Researcher Contact Report</LABEL><BR />
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
				<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="42" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="43" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="SUBMIT" value="Cancel" tabindex="44" />&nbsp;&nbsp;
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
**************************************************************************
* The following code displays the Researcher Information Detail Reports. *
**************************************************************************
 --->

	<CFIF "#FORM.DATEREGISTERED#" NEQ ''>
		<CFSET DATEREGISTEREDLIST = "NO">
		<CFSET DATEREGISTEREDRANGE = "NO">
		<CFIF FIND(',', #FORM.DATEREGISTERED#, 1) EQ 0 AND FIND(';', #FORM.DATEREGISTERED#, 1) EQ 0>
			<CFSET FORM.DATEREGISTERED = DateFormat(FORM.DATEREGISTERED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.DATEREGISTERED#, 1) NEQ 0>
				<CFSET DATEREGISTEREDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.DATEREGISTERED#, 1) NEQ 0>
				<CFSET DATEREGISTEREDRANGE = "YES">
				<CFSET FORM.DATEREGISTERED = #REPLACE(FORM.DATEREGISTERED, ";", ",")#>
			</CFIF>
			<CFSET DATEREGISTEREDARRAY = ListToArray(FORM.DATEREGISTERED)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(DATEREGISTEREDARRAY)# >
				DATE REGISTERED FIELD = #DATEREGISTEREDARRAY[COUNTER]#<BR><BR>
			</CFLOOP>
		</CFIF>
		<CFIF DATEREGISTEREDRANGE EQ "YES">
			<CFSET BEGINDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		SERVICE DATE LIST = #DATEREGISTEREDLIST#<BR><BR>
		SERVICE DATE RANGE = #DATEREGISTEREDRANGE#<BR><BR>
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

	<CFQUERY name="LookupResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
		SELECT	RESEARCHERID, HONORIFIC, DATEREGISTERED, TO_CHAR(DATEREGISTERED, 'MM/DD/YYYY') AS CHARREGDATE,
				FIRSTNAME, LASTNAME, FULLNAME, INSTITUTION, DEPTMAJOR, ADDRESS, CITY, STATEID, ZIPCODE,
				PHONE, FAX, EMAIL, IDTYPEID, IDNUMBER, STATUSID, INITIALTOPIC, MODIFIEDBYID, MODIFIEDDATE,
				TO_CHAR(MODIFIEDDATE, 'MM/DD/YYYY') AS MODDATE
		FROM		RESEARCHERINFO
		WHERE	(RESEARCHERID > 0) AND (

		<CFIF #FORM.HONORIFIC# GT 0>
			<CFIF IsDefined("FORM.NEGATEHONORIFIC")>
				NOT HONORIFIC LIKE '%#FORM.HONORIFIC#%' #LOGICANDOR#
			<CFELSE>
				HONORIFIC LIKE '%#FORM.HONORIFIC#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.DATEREGISTERED#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEDATEREGISTERED")>
				<CFIF DATEREGISTEREDLIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(DATEREGISTEREDARRAY)#>
						<CFSET FORMATDATEREGISTERED =  DateFormat(#DATEREGISTEREDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF DATEREGISTEREDRANGE EQ "YES">
					NOT (DATEREGISTERED BETWEEN TO_DATE('#BEGINDATEREGISTERED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATEREGISTERED#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT DATEREGISTERED LIKE TO_DATE('#FORM.DATEREGISTERED#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF DATEREGISTEREDLIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(DATEREGISTEREDARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[ArrayLen(DATEREGISTEREDARRAY)]#, 'DD-MMM-YYYY')>
					DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF DATEREGISTEREDRANGE EQ "YES">
						(DATEREGISTERED BETWEEN TO_DATE('#BEGINDATEREGISTERED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATEREGISTERED#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					DATEREGISTERED LIKE TO_DATE('#FORM.DATEREGISTERED#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

		<CFIF #FORM.FIRSTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATEFIRSTNAME")>
				NOT FIRSTNAME LIKE '%#FORM.FIRSTNAME#%' #LOGICANDOR#
			<CFELSE>
				FIRSTNAME LIKE '%#FORM.FIRSTNAME#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.LASTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATELASTNAME")>
				NOT LASTNAME LIKE '%#FORM.LASTNAME#%' #LOGICANDOR#
			<CFELSE>
				LASTNAME LIKE '%#FORM.LASTNAME#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INSTITUTION# NEQ "">
			<CFIF IsDefined("FORM.NEGATEINSTITUTION")>
				NOT INSTITUTION LIKE '%#FORM.INSTITUTION#%' #LOGICANDOR#
			<CFELSE>
				INSTITUTION LIKE '%#FORM.INSTITUTION#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DEPTMAJOR# NEQ "">
			<CFIF IsDefined("FORM.NEGATEDEPTMAJOR")>
				NOT DEPTMAJOR LIKE '%#FORM.DEPTMAJOR#%' #LOGICANDOR#
			<CFELSE>
				DEPTMAJOR LIKE '%#FORM.DEPTMAJOR#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ADDRESS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEADDRESS")>
				NOT ADDRESS LIKE '%#FORM.ADDRESS#%' #LOGICANDOR#
			<CFELSE>
				ADDRESS LIKE '%#FORM.ADDRESS#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CITY# NEQ "">
			<CFIF IsDefined("FORM.NEGATECITY")>
				NOT CITY LIKE '%#FORM.CITY#%' #LOGICANDOR#
			<CFELSE>
				CITY LIKE '%#FORM.CITY#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATEID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTATEID")>
				NOT (STATEID = #val(FORM.STATEID)#) #LOGICANDOR#
			<CFELSE>
				STATEID = #val(FORM.STATEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ZIPCODE# NEQ "">
			<CFIF IsDefined("FORM.NEGATEZIPCODE")>
				NOT ZIPCODE LIKE '%#FORM.ZIPCODE#%' #LOGICANDOR#
			<CFELSE>
				ZIPCODE LIKE '%#FORM.ZIPCODE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PHONE# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPHONE")>
				NOT PHONE LIKE '%#FORM.PHONE#%' #LOGICANDOR#
			<CFELSE>
				PHONE LIKE '%#FORM.PHONE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>
		<CFIF #FORM.FAX# NEQ "">
			<CFIF IsDefined("FORM.NEGATEFAX")>
				NOT FAX LIKE '%#FORM.FAX#%' #LOGICANDOR#
			<CFELSE>
				FAX LIKE '%#FORM.FAX#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.EMAIL# NEQ "">
			<CFIF IsDefined("FORM.NEGATEEMAIL")>
				NOT EMAIL LIKE '%#FORM.EMAIL#%' #LOGICANDOR#
			<CFELSE>
				EMAIL LIKE '%#FORM.EMAIL#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.IDTYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEIDTYPEID")>
				NOT (IDTYPEID = #val(FORM.IDTYPEID)#) #LOGICANDOR#
			<CFELSE>
				IDTYPEID = #val(FORM.IDTYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.IDNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEIDNUMBER")>
				NOT IDNUMBER LIKE '%#FORM.IDNUMBER#%' #LOGICANDOR#
			<CFELSE>
				IDNUMBER LIKE '%#FORM.IDNUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATUSID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTATUSID")>
				NOT (STATUSID = #val(FORM.STATUSID)#) #LOGICANDOR#
			<CFELSE>
				STATUSID = #val(FORM.STATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INITIALTOPIC# NEQ "">
			<CFIF IsDefined("FORM.NEGATEINITIALTOPIC")>
				NOT INITIALTOPIC LIKE '%#FORM.INITIALTOPIC#%' #LOGICANDOR#
			<CFELSE>
				INITIALTOPIC LIKE '%#FORM.INITIALTOPIC#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
				NOT (MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#) #LOGICANDOR#
			<CFELSE>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

				MODIFIEDBYID #FINALTEST# 0)

		ORDER BY	LASTNAME
	</CFQUERY>

	<CFIF #LookupResearcherInfo.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Researcher Information records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/specialcollections/researcherinfodbreports.cfm" />
		<CFEXIT>
	
	<CFELSE>

		<CFSWITCH expression = #FORM.REPORTCHOICE#>

			<CFCASE value = 1>
				<CFINCLUDE template="researcherfullreport.cfm">
			</CFCASE>

			<CFCASE value = 2>
				<CFINCLUDE template="researchercontactreport.cfm">
			</CFCASE>

			<CFDEFAULTCASE>
				<CFINCLUDE template="researcherfullreport.cfm">
			</CFDEFAULTCASE>

		</CFSWITCH>

	</CFIF>

</CFIF>

</BODY>
</HTML>
</CFOUTPUT>