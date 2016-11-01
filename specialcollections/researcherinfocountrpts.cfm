<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researcherinfocountrpts.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/23/2009 --->
<!--- Date in Production: 01/23/2009 --->
<!--- Module: Special Collections - Researcher Information Count Reports --->
<!-- Last modified by John R. Pastori on 01/23/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/researcherinfocountrpts.cfm">
<CFSET CONTENT_UPDATED = "January 23, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<HTML>
<HEAD>
	<TITLE>Special Collections - Researcher Information Count Reports </TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFIF NOT IsDefined('URL.LOOKUPRESEARCHERINFO')>
	<CFSET CURSORFIELD = "document.LOOKUP.HONORIFIC.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Researcher Information Count Reports. *
***************************************************************************************
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
			<TH align="center"><H1>Special Collections - Researcher Information Count Reports Selection Lookup</H1></TH>
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
<CFFORM name="LOOKUP" action="/#application.type#apps/specialcollections/researcherinfocountrpts.cfm?LOOKUPRESEARCHERINFO=FOUND" method="POST" ENABLECAB="Yes">

		<CFINCLUDE template = "researcherinfolookup.cfm">

		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="40">
				<LABEL for="REPORTCHOICE1">Status Count Report</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="41">
				<LABEL for="REPORTCHOICE2">Dept/Major Count Report</LABEL><BR />
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
*************************************************************************
* The following code displays the Researcher Information Count Reports. *
*************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'S.STATUSNAME~ CHARREGYEAR~ CHARREGMONTH'>
	<CFSET SORTORDER[2] = 'INSTDEPTMAJR~ CHARREGYEAR~ CHARREGMONTH'>

	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>

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
		SELECT	RI.RESEARCHERID, RI.HONORIFIC, RI.DATEREGISTERED, TO_CHAR(RI.DATEREGISTERED, 'MM/DD/YYYY') AS CHARREGDATE,
				TO_CHAR(RI.DATEREGISTERED, 'YYYY') AS CHARREGYEAR, TO_CHAR(RI.DATEREGISTERED, 'MM') AS CHARREGMONTH, RI.FIRSTNAME,
				RI.LASTNAME, RI.FULLNAME, RI.INSTITUTION, RI.DEPTMAJOR, RI.INSTITUTION || ' - ' || RI.DEPTMAJOR AS INSTDEPTMAJR,
				RI.ADDRESS, RI.CITY, RI.STATEID, RI.ZIPCODE, RI.PHONE, RI.FAX, RI.EMAIL, RI.IDTYPEID, RI.IDNUMBER, RI.STATUSID, S.STATUSID,
				S.STATUSNAME, RI.INITIALTOPIC, RI.MODIFIEDBYID, RI.MODIFIEDDATE, TO_CHAR(RI.MODIFIEDDATE, 'MM/DD/YYYY') AS MODDATE
		FROM		RESEARCHERINFO RI, STATUS S
		WHERE	(RI.RESEARCHERID > 0 AND
				RI.STATUSID = S.STATUSID) AND (

		<CFIF #FORM.HONORIFIC# GT 0>
			<CFIF IsDefined("FORM.NEGATEHONORIFIC")>
				NOT RI.HONORIFIC LIKE '%#FORM.HONORIFIC#%' #LOGICANDOR#
			<CFELSE>
				RI.HONORIFIC LIKE '%#FORM.HONORIFIC#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.DATEREGISTERED#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEDATEREGISTERED")>
				<CFIF DATEREGISTEREDLIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(DATEREGISTEREDARRAY)#>
						<CFSET FORMATDATEREGISTERED =  DateFormat(#DATEREGISTEREDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT RI.DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF DATEREGISTEREDRANGE EQ "YES">
					NOT (RI.DATEREGISTERED BETWEEN TO_DATE('#BEGINDATEREGISTERED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATEREGISTERED#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT RI.DATEREGISTERED LIKE TO_DATE('#FORM.DATEREGISTERED#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF DATEREGISTEREDLIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(DATEREGISTEREDARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						RI.DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATDATEREGISTERED = DateFormat(#DATEREGISTEREDARRAY[ArrayLen(DATEREGISTEREDARRAY)]#, 'DD-MMM-YYYY')>
					RI.DATEREGISTERED = TO_DATE('#FORMATDATEREGISTERED#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF DATEREGISTEREDRANGE EQ "YES">
						(RI.DATEREGISTERED BETWEEN TO_DATE('#BEGINDATEREGISTERED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATEREGISTERED#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					RI.DATEREGISTERED LIKE TO_DATE('#FORM.DATEREGISTERED#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

		<CFIF #FORM.FIRSTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATEFIRSTNAME")>
				NOT RI.FIRSTNAME LIKE '%#FORM.FIRSTNAME#%' #LOGICANDOR#
			<CFELSE>
				RI.FIRSTNAME LIKE '%#FORM.FIRSTNAME#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.LASTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATELASTNAME")>
				NOT RI.LASTNAME LIKE '%#FORM.LASTNAME#%' #LOGICANDOR#
			<CFELSE>
				RI.LASTNAME LIKE '%#FORM.LASTNAME#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INSTITUTION# NEQ "">
			<CFIF IsDefined("FORM.NEGATEINSTITUTION")>
				NOT RI.INSTITUTION LIKE '%#FORM.INSTITUTION#%' #LOGICANDOR#
			<CFELSE>
				RI.INSTITUTION LIKE '%#FORM.INSTITUTION#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DEPTMAJOR# NEQ "">
			<CFIF IsDefined("FORM.NEGATEDEPTMAJOR")>
				NOT RI.DEPTMAJOR LIKE '%#FORM.DEPTMAJOR#%' #LOGICANDOR#
			<CFELSE>
				RI.DEPTMAJOR LIKE '%#FORM.DEPTMAJOR#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ADDRESS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEADDRESS")>
				NOT RI.ADDRESS LIKE '%#FORM.ADDRESS#%' #LOGICANDOR#
			<CFELSE>
				RI.ADDRESS LIKE '%#FORM.ADDRESS#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CITY# NEQ "">
			<CFIF IsDefined("FORM.NEGATECITY")>
				NOT RI.CITY LIKE '%#FORM.CITY#%' #LOGICANDOR#
			<CFELSE>
				RI.CITY LIKE '%#FORM.CITY#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATEID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTATEID")>
				NOT (RI.STATEID = #val(FORM.STATEID)#) #LOGICANDOR#
			<CFELSE>
				RI.STATEID = #val(FORM.STATEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ZIPCODE# NEQ "">
			<CFIF IsDefined("FORM.NEGATEZIPCODE")>
				NOT RI.ZIPCODE LIKE '%#FORM.ZIPCODE#%' #LOGICANDOR#
			<CFELSE>
				RI.ZIPCODE LIKE '%#FORM.ZIPCODE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PHONE# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPHONE")>
				NOT RI.PHONE LIKE '%#FORM.PHONE#%' #LOGICANDOR#
			<CFELSE>
				RI.PHONE LIKE '%#FORM.PHONE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>
		<CFIF #FORM.FAX# NEQ "">
			<CFIF IsDefined("FORM.NEGATEFAX")>
				NOT RI.FAX LIKE '%#FORM.FAX#%' #LOGICANDOR#
			<CFELSE>
				RI.FAX LIKE '%#FORM.FAX#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.EMAIL# NEQ "">
			<CFIF IsDefined("FORM.NEGATEEMAIL")>
				NOT RI.EMAIL LIKE '%#FORM.EMAIL#%' #LOGICANDOR#
			<CFELSE>
				RI.EMAIL LIKE '%#FORM.EMAIL#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.IDTYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEIDTYPEID")>
				NOT (RI.IDTYPEID = #val(FORM.IDTYPEID)#) #LOGICANDOR#
			<CFELSE>
				RI.IDTYPEID = #val(FORM.IDTYPEID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.IDNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEIDNUMBER")>
				NOT RI.IDNUMBER LIKE '%#FORM.IDNUMBER#%' #LOGICANDOR#
			<CFELSE>
				RI.IDNUMBER LIKE '%#FORM.IDNUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATUSID# GT 0>
			<CFIF IsDefined("FORM.NEGATESTATUSID")>
				NOT (RI.STATUSID = #val(FORM.STATUSID)#) #LOGICANDOR#
			<CFELSE>
				RI.STATUSID = #val(FORM.STATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.INITIALTOPIC# NEQ "">
			<CFIF IsDefined("FORM.NEGATEINITIALTOPIC")>
				NOT RI.INITIALTOPIC LIKE '%#FORM.INITIALTOPIC#%' #LOGICANDOR#
			<CFELSE>
				RI.INITIALTOPIC LIKE '%#FORM.INITIALTOPIC#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
				NOT (RI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)#) #LOGICANDOR#
			<CFELSE>
				RI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT RI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
					</CFLOOP>
					<CFSET FINALTEST = ">">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (RI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT RI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
					(
					<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						RI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
					<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
					RI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
					<CFSET FINALTEST = "=">
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(RI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					RI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

				RI.MODIFIEDBYID #FINALTEST# 0)

		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<BR><BR>REG YEAR = #LookupResearcherInfo.CHARREGYEAR# &nbsp;&nbsp;&nbsp;&nbsp;REG MONTH = #LookupResearcherInfo.CHARREGMONTH#<BR><BR>

	<CFIF #LookupResearcherInfo.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Researcher Information records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/specialcollections/researcherinfocountrpts.cfm" />
		<CFEXIT>

	<CFELSE>

		<CFSET COMPAREGROUPFIELDVALUE = "">
		<CFSET COMPAREMONTH = "">
		<CFSET COMPAREYEAR = "">
		<CFSET DBGROUPFIELDVALUE = "">
		<CFSET FIRSTPASS = "YES">
		<CFSET MONTHRESEARCHERCOUNT = 0>
		<CFSET REPORTTITLE = "">
		<CFSET COMPAREYEAR = "">
		<CFSET TOTALRESEARCHERCOUNT = 0>
		<CFSET YEARRESEARCHERCOUNT = 0>

		<CFSWITCH expression = #FORM.REPORTCHOICE#>

			<CFCASE value = 1>
				<CFSET DBGROUPFIELDVALUE = "LookupResearcherInfo.STATUSNAME">
				<CFSET REPORTTITLE ="Status Count Report">
			</CFCASE>

			<CFCASE value = 2>
				<CFSET DBGROUPFIELDVALUE = "LookupResearcherInfo.INSTDEPTMAJR">
				<CFSET REPORTTITLE ="Dept/Major Count Report">
			</CFCASE>

			<CFDEFAULTCASE>
				<CFSET DBGROUPFIELDVALUE = "LookupResearcherInfo.STATUSID">
				<CFSET REPORTTITLE ="Status Count Report">
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
<CFFORM action="/#application.type#apps/specialcollections/researcherinfocountrpts.cfm" method="POST">
				<TD align="left">
					<INPUT type="submit" value="Cancel" tabindex="1" />
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TH align="LEFT" valign="TOP">Year/Month</TH>
				<TH align="LEFT" valign="TOP">Researcher Count</TH>
			</TR>

<CFLOOP query="LookupResearcherInfo">
		<CFIF COMPAREMONTH EQ "" AND COMPAREYEAR EQ "">
			<CFSET COMPAREMONTH = #LookupResearcherInfo.CHARREGMONTH#>
			<CFSET COMPAREYEAR = #LookupResearcherInfo.CHARREGYEAR#>
		</CFIF>

		<CFIF COMPAREGROUPFIELDVALUE NEQ Evaluate('#DBGROUPFIELDVALUE#')>
			<CFIF FIRSTPASS EQ "YES">
				<CFSET FIRSTPASS = "NO">
			<CFELSE>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHRESEARCHERCOUNT, '999,999,999')#
				</TD>
			</TR>
			<TR>
				<TH align="CENTER" colspan="2">
					TOTAL #COMPAREGROUPFIELDVALUE#  RESEARCHER COUNT IS #YEARRESEARCHERCOUNT#
					<CFSET TOTALRESEARCHERCOUNT = TOTALRESEARCHERCOUNT + YEARRESEARCHERCOUNT>
				</TH>
			</TR>
			<TR>
				<TH align="LEFT" colspan="2">
					<HR size="5" noshade>
				</TH>
			</TR>
			<TR>
				<TH align="LEFT" valign="TOP">Year/Month</TH>
				<TH align="LEFT" valign="TOP">Researcher Count</TH>
			</TR>
			</CFIF>
			<TR>
				<CFSET COMPAREGROUPFIELDVALUE = Evaluate("#DBGROUPFIELDVALUE#")>
				<CFSET COMPAREMONTH = #LookupResearcherInfo.CHARREGMONTH#>
				<CFSET COMPAREYEAR = #LookupResearcherInfo.CHARREGYEAR#>
				<CFSET MONTHRESEARCHERCOUNT = 0>
				<CFSET YEARRESEARCHERCOUNT = 0>
				<TH align="LEFT" valign="TOP">#COMPAREGROUPFIELDVALUE#</TH>
			</TR>
		</CFIF>
<!--- 
			<TR>
				<TD ALIGN=LEFT COLSPAN="2">
					<BR>#COMPAREGROUPFIELDVALUE# RESEARCHER YEAR/MONTH = #LookupResearcherInfo.CHARREGYEAR#/#LookupResearcherInfo.CHARREGMONTH#<BR>
				</TD>
			</TR>
 --->
		<CFIF COMPAREYEAR EQ #LookupResearcherInfo.CHARREGYEAR# AND COMPAREMONTH EQ "#LookupResearcherInfo.CHARREGMONTH#">
			<CFSET MONTHRESEARCHERCOUNT = MONTHRESEARCHERCOUNT + 1>
			<CFSET YEARRESEARCHERCOUNT = YEARRESEARCHERCOUNT + 1>
		<CFELSE>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
					<CFSET COMPAREMONTH = #LookupResearcherInfo.CHARREGMONTH#>
					<CFSET COMPAREYEAR = #LookupResearcherInfo.CHARREGYEAR#>
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHRESEARCHERCOUNT, '999,999,999')#
					<CFSET MONTHRESEARCHERCOUNT = 1>
					<CFSET YEARRESEARCHERCOUNT = YEARRESEARCHERCOUNT + 1>
				</TD>
			</TR>
		</CFIF>
</CFLOOP>
			<TR>
				<TD align="LEFT" valign="TOP">
					#COMPAREYEAR#/#COMPAREMONTH#
				</TD>
				<TD align="LEFT" valign="TOP">
					#NUMBERFORMAT(MONTHRESEARCHERCOUNT, '999,999,999')#
					<CFSET MONTHRESEARCHERCOUNT = 1>
				</TD>
			</TR>
			<TR>
				<TH align="CENTER" colspan="2">
					TOTAL #COMPAREGROUPFIELDVALUE#  RESEARCHER COUNT IS #YEARRESEARCHERCOUNT#
					<CFSET TOTALRESEARCHERCOUNT = TOTALRESEARCHERCOUNT + YEARRESEARCHERCOUNT>
				</TH>
			</TR>
			<TR>
				<TD colspan="2"><HR size="5" noshade></TD>
			</TR>

			<TR>
				<TD align="CENTER" valign="TOP" colspan="2"><STRONG><u>Researchers Grand Total  = #NUMBERFORMAT(TOTALRESEARCHERCOUNT, '999,999,999')#</u></STRONG></TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfocountrpts.cfm" method="POST">
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

</BODY>
</HTML>
</CFOUTPUT>