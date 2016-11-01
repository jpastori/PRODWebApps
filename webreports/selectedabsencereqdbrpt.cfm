<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: selectedabsencereqdbrpt.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Process Information to Web Reports - Selected Absence Request Report --->
<!-- Last modified by John R. Pastori on 06/14/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm">
<CFSET CONTENT_UPDATED = "June 14, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Selected Absence Request Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Web Reports - Selected Absence Request Report";


	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPREQUESTER')>
	<CFSET CURSORFIELD = "document.LOOKUP.REQUESTERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************************
* The following code is the Look Up Process for Selected Absence Request Report *
*********************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPREQUESTER')>

	<CFQUERY name="LookupRequesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.EMAIL, CUST.UNITID, U.GROUPID, CUST.FULLNAME, CUST.REDID, CUST.FULLNAME || ' - ' || CUST.REDID AS LOOKUPKEY
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4,6)) AND 
				(ACTIVE = 'YES' AND
				NOT LASTNAME LIKE '/%' AND
				NOT LASTNAME LIKE 'COMPUTING%' AND
				NOT LASTNAME LIKE 'INVENTORY%' AND
				NOT FIRSTNAME LIKE 'AVAIL%' AND
				NOT FIRSTNAME LIKE 'CHECK%' AND
				NOT FIRSTNAME LIKE 'INFO%' AND
				NOT FIRSTNAME LIKE 'IST%' AND
				NOT FIRSTNAME LIKE 'SCC%' AND
				NOT FIRSTNAME LIKE 'SHARED%' AND
				NOT FIRSTNAME LIKE 'TECH%' AND
				NOT FIRSTNAME LIKE 'WORK%' AND
				NOT EMAIL = 'none' AND
				NOT EMAIL LIKE '@%')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupRequestStatus" datasource="#application.type#WEBREPORTS" blockfactor="5">
		SELECT	REQUESTSTATUSID, REQUESTSTATUSNAME
		FROM		REQUESTSTATUS
		ORDER BY	REQUESTSTATUSNAME
	</CFQUERY>

	<CFQUERY name="LookupRequestType" datasource="#application.type#WEBREPORTS" blockfactor="15">
		SELECT	REQUESTTYPEID, REQUESTTYPENAME, REQUESTTYPEFIELDNAME
		FROM		REQUESTTYPES
		ORDER BY	REQUESTTYPENAME
	</CFQUERY>

	<CFQUERY name="LookupSupervisors" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.EMAIL, CUST.FULLNAME || '-' || CUST.EMAIL AS SUPEMAIL, CUST.UNITID, U.GROUPID,
				CUST.CAMPUSPHONE, CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.UNITHEAD, CUST.ALLOWEDTOAPPROVE
		FROM		CUSTOMERS CUST, UNITS U
		WHERE	(CUST.CUSTOMERID = 0 AND 
				CUST.UNITID = U.UNITID) OR
				(CUST.UNITID = U.UNITID AND
				U.GROUPID IN (2,3,4,6) AND 
				CUST.UNITHEAD = 'YES' AND
				CUST.ALLOWEDTOAPPROVE = 'YES')
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	UNITID, UNITNAME, GROUPID, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		WHERE	UNITID = 0 OR
				GROUPID IN (2,3,4,6)
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="5">
		SELECT	GROUPID, GROUPNAME, MANAGEMENTID
		FROM		GROUPS
		WHERE	GROUPID = 0 OR
				GROUPID IN (2,3,4,6)
		ORDER BY	GROUPNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Selected Absence Request Report Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center"><H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     <FIELDSET>
	<LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm?LOOKUPREQUESTER=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTERID">Requester's Name - Red ID</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREDID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REDID">Red ID</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTERID" id="NEGATEREQUESTERID" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTERID" id="REQUESTERID" size="1" query="LookupRequesters" value="CUSTOMERID" display="LOOKUPKEY" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREDID" id="NEGATEREDID" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REDID" id="REDID" value="" align="LEFT" required="No" size="12" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTSTATUSID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTSTATUSID">Request Status</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTTYPEIDD">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTTYPEID">Request Type</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTSTATUSID" id="NEGATEREQUESTSTATUSID" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTSTATUSID" id="REQUESTSTATUSID" size="1" query="LookupRequestStatus" value="REQUESTSTATUSID" display="REQUESTSTATUSNAME" required="No" selected="0" tabindex="7"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTTYPEID" id="NEGATEREQUESTTYPEID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="REQUESTTYPEID" id="REQUESTTYPEID" size="1" query="LookupRequestType" value="REQUESTTYPEID" display="REQUESTTYPENAME" required="No" selected="0" tabindex="9"></CFSELECT>
			</TD>

		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESUPERVISOREMAILID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SUPERVISOREMAILID">Supervisor's Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">
				Select (1) Unit Name from the dropdown</LABEL> or <LABEL for="UNITNUMBER">enter (2) a series of Unit Numbers<BR>
				&nbsp;separated by commas,NO spaces in the text box.</LABEL>
			</TH>
			
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESUPERVISOREMAILID" id="NEGATESUPERVISOREMAILID" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SUPERVISOREMAILID" id="SUPERVISOREMAILID" query="LookupSupervisors" value="CUSTOMERID" display="FULLNAME" selected="0" tabindex="11"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="13"></CFSELECT>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="UNITNUMBER" id="UNITNUMBER" value="" required="No" size="20" maxlength="30" tabindex="14">
			</TD>
			
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEGROUPID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="GROUPID">Group</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEREQUESTDATES">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="REQUESTDATES">
				(1) a single Date Requested or (2) a series of dates <BR />
				&nbsp;separated by commas,NO spaces or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEGROUPID" id="NEGATEGROUPID" value="" align="LEFT" required="No" tabindex="15">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="GROUPID" id="GROUPID" size="1" query="LookupGroups" value="GROUPID" display="GROUPNAME" required="No" tabindex="16"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEREQUESTDATES" id="NEGATEREQUESTDATES" value="" align="LEFT" required="No" tabindex="17">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="REQUESTDATES" id="REQUESTDATES" value="" required="No" size="50" tabindex="18">
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="center" colspan="4"><H2>Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="19" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="20" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="21" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
********************************************************************************
* The following code is the Selected Absence Request Report Generation Process *
********************************************************************************
 --->

	<CFIF #FORM.REDID# NEQ ''>
		
		<CFQUERY name="LookupRedID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, FULLNAME, REDID
			FROM		CUSTOMERS
			WHERE	REDID = <CFQUERYPARAM value="#FORM.REDID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REQUESTTYPEID# GT 0 >

		<CFQUERY name="LookupRequestType" datasource="#application.type#WEBREPORTS">
			SELECT	REQUESTTYPEID, REQUESTTYPENAME, REQUESTTYPEFIELDNAME
			FROM		REQUESTTYPES
			WHERE	REQUESTTYPEID = <CFQUERYPARAM value="#FORM.REQUESTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	REQUESTTYPENAME
		</CFQUERY>

		<CFSET FORM.FIELDNAME = #LookupRequestType.REQUESTTYPEFIELDNAME#>

	</CFIF>

	<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>

		<CFQUERY name="ListCustUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, U.UNITID, U.UNITNAME
			FROM		CUSTOMERS CUST, UNITS U
		<CFIF #FORM.UNITID# GT 0>
			WHERE	CUST.UNITID = <CFQUERYPARAM value="#FORM.UNITID#" cfsqltype="CF_SQL_NUMERIC"> AND
		<CFELSE>
			WHERE	CUST.UNITID IN (#FORM.UNITNUMBER#) AND
		</CFIF>
					CUST.UNITID = U.UNITID
			ORDER BY	U.UNITNAME
		</CFQUERY>

		<CFIF #ListCustUnits.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Unit Records meeting the selected criteria were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<CFIF #FORM.GROUPID# GT 0>

		<CFQUERY name="LookupGroupUnits" datasource="#application.type#LIBSHAREDDATA">
			SELECT	U.UNITID, U.UNITNAME, G.GROUPID, G.GROUPNAME
			FROM		UNITS U, GROUPS G
			WHERE	U.GROUPID = <CFQUERYPARAM value="#FORM.GROUPID#" cfsqltype="CF_SQL_NUMERIC"> AND
					U.GROUPID = G.GROUPID
			ORDER BY	G.GROUPNAME, U.UNITNAME
		</CFQUERY>

		<CFQUERY name="ListCustGroups" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUST.CUSTOMERID, CUST.UNITID, U.UNITID, U.UNITNAME
			FROM		CUSTOMERS CUST, UNITS U
			WHERE	CUST.UNITID IN (#ValueList(LookupGroupUnits.UNITID)#) AND
					CUST.UNITID = U.UNITID
			ORDER BY	U.UNITNAME
		</CFQUERY>

	</CFIF>


	<CFIF "#FORM.REQUESTDATES#" NEQ ''>
		<CFSET REQUESTDATESLIST = "NO">
		<CFSET REQUESTDATESRANGE = "NO">
		<CFIF FIND(',', #FORM.REQUESTDATES#, 1) EQ 0 AND FIND(';', #FORM.REQUESTDATES#, 1) EQ 0>
			<CFSET FORM.REQUESTDATES = DateFormat(FORM.REQUESTDATES, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.REQUESTDATES#, 1) NEQ 0>
				<CFSET REQUESTDATESLIST = "YES">
			<CFELSEIF FIND(';', #FORM.REQUESTDATES#, 1) NEQ 0>
				<CFSET REQUESTDATESRANGE = "YES">
				<CFSET FORM.REQUESTDATES = #REPLACE(FORM.REQUESTDATES, ";", ",")#>
			</CFIF>
			<CFSET REQUESTDATESARRAY = ListToArray(FORM.REQUESTDATES)>
			<!--- <CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIEDDATE FIELD #Counter# = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF REQUESTDATESRANGE EQ "YES">
			<CFSET BEGINREQUESTDATES = DateFormat(#REQUESTDATESARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDREQUESTDATES = DateFormat(#REQUESTDATESARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		REQUESTDATESLIST = #REQUESTDATESLIST#<BR /><BR />
		REQUESTDATESDATERANGE = #REQUESTDATESRANGE#<BR /><BR />
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = "!=">
	</CFIF>

	<CFQUERY name="ListAbsenceRequests" datasource="#application.type#WEBREPORTS" blockfactor="100">
		SELECT	A.ABSENCEID, TO_CHAR(A.SUBMITDATE, 'YYYY-MM-DD') AS SUBMITDATE, A.REQUESTERID, CUST.FULLNAME AS CUSTNAME, CUST.ACTIVE, A.REQUESTEREMAIL,
				U.UNITNAME, G.GROUPNAME, A.SUPERVISOREMAILID, SUPVR.EMAIL AS SUPVREMAIL, SUPVR.FULLNAME AS SUPVRNAME, A.CC2, A.CARBON,
				A.BEGINDATE1, TO_CHAR(A.BEGINDATE1, 'YYYY-MM-DD') AS BEGINDATE , A.ENDDATE1, A.BEGINDATE2, A.ENDDATE2, A.BEGINDATE3, 
                    A.ENDDATE3, A.BEGINDATE4, A.ENDDATE4, A.BEGINTIME1, A.ENDTIME1, A.BEGINTIME2, A.ENDTIME2, A.BEGINTIME3, A.ENDTIME3, 
                    A.BEGINTIME4, A.ENDTIME4, A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION, A.PERSONALHOLIDAY, A.COMPTIME, 
                    A.FMLA, A.FUNERAL, A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER, A.SICKFAMILY, A.SICKSELF,A.WITNESS, 
                    A.RELATIONSHIP, A.REASON, A.REQUESTSTATUSID, A.APPROVEDBYSUPID, A.SUPAPPROVALDATE
		FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS SUPVR, LIBSHAREDDATAMGR.UNITS U,
				LIBSHAREDDATAMGR.GROUPS G
		WHERE	(A.ABSENCEID > 0 AND
				A.REQUESTERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				A.SUPERVISOREMAILID = SUPVR.CUSTOMERID AND
				CUST.UNITID = U.UNITID AND
				U.GROUPID = G.GROUPID) AND
				(
		<CFIF #FORM.REQUESTERID# GT 0>
			<CFIF IsDefined("FORM.NEGATEREQUESTERID")>
				NOT A.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			<CFELSE>
				A.REQUESTERID = #val(FORM.REQUESTERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REDID# NEQ ''>
			<CFIF IsDefined("FORM.NEGATEREDID")>
				NOT A.REQUESTERID = #val(LookupRedID.CUSTOMERID)# #LOGICANDOR#
			<CFELSE>
				A.REQUESTERID = #val(LookupRedID.CUSTOMERID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTSTATUSID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDREQUESTSTATUSID")>
				NOT A.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			<CFELSE>
				A.REQUESTSTATUSID = #val(FORM.REQUESTSTATUSID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.REQUESTTYPEID# GT 0>
			<CFIF IsDefined("FORM.NEGATEDREQUESTTYPEID")>
				A.#FORM.FIELDNAME# = 0 #LOGICANDOR#
			<CFELSE>
				A.#FORM.FIELDNAME# > 0 #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SUPERVISOREMAILID# GT 0>
			<CFIF IsDefined("FORM.NEGATESUPERVISOREMAILID")>
				NOT A.SUPERVISOREMAILID = #val(FORM.SUPERVISOREMAILID)# #LOGICANDOR#
			<CFELSE>
				A.SUPERVISOREMAILID = #val(FORM.SUPERVISOREMAILID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>
			<CFIF IsDefined("FORM.NEGATEUNITID")>
				NOT A.REQUESTERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				A.REQUESTERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.GROUPID# GT 0>
			<CFIF IsDefined("FORM.NEGATEGROUPID")>
				NOT A.REQUESTERID IN (#ValueList(ListCustGroups.CUSTOMERID)#) #LOGICANDOR#
			<CFELSE>
				A.REQUESTERID IN (#ValueList(ListCustGroups.CUSTOMERID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.REQUESTDATES#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEREQUESTDATES")>
				<CFLOOP index="Counter1" from=1 to=4>
					<CFIF REQUESTDATESLIST EQ "YES">
						<CFLOOP index="Counter2" from=1 to=#ArrayLen(REQUESTDATESARRAY)#>
							<CFSET FORMATREQUESTDATES =  DateFormat(#REQUESTDATESARRAY[Counter2]#, 'DD-MMM-YYYY')>
							NOT (A.BEGINDATE#Counter1# <= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY') AND
								A.ENDDATE#Counter1# >= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY')) AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF REQUESTDATESRANGE EQ "YES">
						NOT (A.BEGINDATE#Counter1# BETWEEN TO_DATE('#BEGINREQUESTDATES#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATES#', 'DD-MON-YYYY') AND
							A.ENDDATE#Counter1# BETWEEN TO_DATE('#BEGINREQUESTDATES#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATES#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT (A.BEGINDATE#Counter1# <= TO_DATE('#FORM.REQUESTDATES#', 'DD-MON-YYYY') AND
							A.ENDDATE#Counter1# >= TO_DATE('#FORM.REQUESTDATES#', 'DD-MON-YYYY')) AND
					</CFIF>
				</CFLOOP>
			<CFELSE>
				<CFLOOP index="Counter1" from=1 to=4>
					<CFIF REQUESTDATESLIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(REQUESTDATESARRAY) - 1)>
						<CFLOOP index="Counter2" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATREQUESTDATES = DateFormat(#REQUESTDATESARRAY[COUNTER2]#, 'DD-MMM-YYYY')>
							(A.BEGINDATE#Counter1# <= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY') AND
								A.ENDDATE#Counter1# >= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY')) OR
						</CFLOOP>
						<CFSET FORMATREQUESTDATES = DateFormat(#REQUESTDATESARRAY[ArrayLen(REQUESTDATESARRAY)]#, 'DD-MMM-YYYY')>
						(A.BEGINDATE#Counter1# <= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY') AND
						A.ENDDATE#Counter1# >= TO_DATE('#FORMATREQUESTDATES#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF REQUESTDATESRANGE EQ "YES">
						(A.BEGINDATE#Counter1# BETWEEN TO_DATE('#BEGINREQUESTDATES#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATES#', 'DD-MON-YYYY') AND
						A.ENDDATE#Counter1# BETWEEN TO_DATE('#BEGINREQUESTDATES#', 'DD-MON-YYYY') AND TO_DATE('#ENDREQUESTDATES#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						(A.BEGINDATE#Counter1# <= TO_DATE('#FORM.REQUESTDATES#', 'DD-MON-YYYY') AND
						A.ENDDATE#Counter1# >= TO_DATE('#FORM.REQUESTDATES#', 'DD-MON-YYYY')) #LOGICANDOR#
					</CFIF>
				</CFLOOP>
			</CFIF>
		</CFIF>

				A.REQUESTERID #FINALTEST# 0)
		ORDER BY	G.GROUPNAME, U.UNITNAME, SUPVRNAME, CUSTNAME, SUBMITDATE DESC, BEGINDATE DESC
	</CFQUERY>

	<CFIF #ListAbsenceRequests.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Absence Request Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm" />
		<CFEXIT>
	</CFIF>
	

<!--- 
*******************************************************************
* The following code displays the Selected Absence Request Report *
*******************************************************************
 --->
	<CFSET VARGROUPNAME = ''>
	<CFSET VARUNITNAME = ''>
	<CFSET VARSUPERVISORNAME = ''>
	<TABLE width="100%" align="center" border="3">
		<TR>
			<TD align="center"><H1>Web Reports - Selected Absence Request Report</H1></TD>
		</TR>
	</TABLE>
	<TABLE border="0" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm" method="POST">
			<TD align="LEFT" colspan="10">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="10"><H2>#ListAbsenceRequests.RecordCount# Absence Request records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="left">Employee Name</TH>
			<TH align="left">RedID</TH>
               <TH align="CENTER">Submit Date</TH>
			<TH align="left">Start Date</TH>
			<TH align="left">End Date</TH>
			<TH align="CENTER">Request Type</TH>
			<TH align="CENTER">Number of Hours</TH>
			<TH align="left">Start Time</TH>
			<TH align="left">End Time</TH>
			<TH align="CENTER">Request Status</TH>
		</TR>

<CFLOOP query="ListAbsenceRequests">
	<CFIF VARGROUPNAME NEQ #ListAbsenceRequests.GROUPNAME# OR VARUNITNAME NEQ #ListAbsenceRequests.UNITNAME# OR VARSUPERVISORNAME NEQ #ListAbsenceRequests.SUPVRNAME#>
		<CFSET VARGROUPNAME = #ListAbsenceRequests.GROUPNAME#>
		<CFSET VARUNITNAME = #ListAbsenceRequests.UNITNAME#>
		<CFSET VARSUPERVISORNAME = #ListAbsenceRequests.SUPVRNAME#>
		<TR>
			<TD align="LEFT" colspan="10"><HR /></TD>
		</TR>
		<TR>
			<TH align="left">Group Name</TH>
			<TH align="left">Unit Name</TH>
			<TH align="left">Supervisor Name</TH>
		</TR>
		<TR>
			<TD align="left"><STRONG>#ListAbsenceRequests.GROUPNAME#</STRONG></TD>
			<TD align="left"><STRONG>#ListAbsenceRequests.UNITNAME#</STRONG></TD>
			<TD align="left"><STRONG>#ListAbsenceRequests.SUPVRNAME#</STRONG></TD>
		</TR>
	</CFIF>

	<CFQUERY name="ListEmployees" datasource="#application.type#WEBREPORTS">
		SELECT	A.ABSENCEID, A.SUBMITDATE, A.REQUESTERID, CUST.FULLNAME, CUST.REDID, A.REQUESTEREMAIL, A.SUPERVISOREMAILID, 
				TO_CHAR(A.BEGINDATE1, 'MM/DD/YYYY') AS BEGINDATE1, TO_CHAR(A.ENDDATE1, 'MM/DD/YYYY') AS ENDDATE1,
				TO_CHAR(A.BEGINDATE2, 'MM/DD/YYYY') AS BEGINDATE2, TO_CHAR(A.ENDDATE2, 'MM/DD/YYYY') AS ENDDATE2,
				TO_CHAR(A.BEGINDATE3, 'MM/DD/YYYY') AS BEGINDATE3, TO_CHAR(A.ENDDATE3, 'MM/DD/YYYY') AS ENDDATE3,
				TO_CHAR(A.BEGINDATE4, 'MM/DD/YYYY') AS BEGINDATE4, TO_CHAR(A.ENDDATE4, 'MM/DD/YYYY') AS ENDDATE4,
				A.HOURS1, A.HOURS2, A.HOURS3, A.HOURS4, TO_CHAR(A.BEGINTIME1, 'HH24:MI') AS BEGINTIME1, 
				TO_CHAR(A.ENDTIME1, 'HH24:MI') AS ENDTIME1, TO_CHAR(A.BEGINTIME2, 'HH24:MI') AS BEGINTIME2,
				TO_CHAR(A.ENDTIME2, 'HH24:MI') AS ENDTIME2, TO_CHAR(A.BEGINTIME3, 'HH24:MI') AS BEGINTIME3,
				TO_CHAR(A.ENDTIME3, 'HH24:MI') AS ENDTIME3, TO_CHAR(A.BEGINTIME4, 'HH24:MI') AS BEGINTIME4,
				TO_CHAR(A.ENDTIME4, 'HH24:MI') AS ENDTIME4, A.DAYS1ID, A.DAYS2ID, A.DAYS3ID, A.DAYS4ID, A.VACATION,
				A.PERSONALHOLIDAY, A.COMPTIME, A.FMLA, A.FUNERAL, A.GTO, A.JURYDUTY, A.LWOP, A.MATPAT, A.MILITARY, A.OTHER,
				A.SICKFAMILY, A.SICKSELF,A.WITNESS, A.RELATIONSHIP, A.REASON, A.REQUESTSTATUSID, RS.REQUESTSTATUSNAME,
				A.APPROVEDBYSUPID, A.SUPAPPROVALDATE
		FROM		ABSENCEREQUESTS A, LIBSHAREDDATAMGR.CUSTOMERS CUST, REQUESTSTATUS RS
		WHERE	A.ABSENCEID = <CFQUERYPARAM value="#ListAbsenceRequests.ABSENCEID#" cfsqltype="CF_SQL_NUMERIC"> AND
				A.REQUESTERID = CUST.CUSTOMERID AND
				A.REQUESTSTATUSID = RS.REQUESTSTATUSID
	</CFQUERY>

		<TR>
			<TD align="LEFT" valign="TOP"><DIV>#ListAbsenceRequests.CUSTNAME#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#ListEmployees.REDID#</DIV></TD>
               <TD align="CENTER" valign="TOP"><DIV>#DateFormat(ListEmployees.SUBMITDATE, 'MM/DD/YYYY')#</DIV></TD>
			<TD align="LEFT" valign="TOP">
				<DIV>#ListEmployees.BEGINDATE1#</DIV><BR>
			<CFIF #ListEmployees.BEGINDATE2# GT '31-DEC-1899'>
				<DIV>#ListEmployees.BEGINDATE2#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINDATE3# GT '31-DEC-1899'>
				<DIV>#ListEmployees.BEGINDATE3#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINDATE4# GT '31-DEC-1899'>
				<DIV>#ListEmployees.BEGINDATE4#</DIV><BR>
			</CFIF>
			</TD>
			<TD align="left" valign="TOP">
			<CFIF #ListEmployees.ENDDATE1# GT '31-DEC-1899'>
				<DIV>#ListEmployees.ENDDATE1#</DIV><BR>
			<CFELSE>
				<DIV>&nbsp;&nbsp;</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINDATE2# GT '31-DEC-1899'>
				<CFIF #ListEmployees.ENDDATE2# GT '31-DEC-1899'>
					<DIV>#ListEmployees.ENDDATE2#</DIV><BR>
				<CFELSE>
					<DIV>&nbsp;&nbsp;</DIV><BR>
				</CFIF>
			</CFIF>
			<CFIF #ListEmployees.BEGINDATE3# GT '31-DEC-1899'>
				<CFIF #ListEmployees.ENDDATE3# GT '31-DEC-1899'>
					<DIV>#ListEmployees.ENDDATE3#</DIV><BR>
				<CFELSE>
					<DIV>&nbsp;&nbsp;</DIV><BR>
				</CFIF>
			</CFIF>
			<CFIF #ListEmployees.BEGINDATE4# GT '31-DEC-1899'>
				<CFIF #ListEmployees.ENDDATE4# GT '31-DEC-1899'>
					<DIV>#ListEmployees.ENDDATE4#</DIV><BR>
				<CFELSE>
					<DIV>&nbsp;&nbsp;</DIV><BR>
				</CFIF>
			</CFIF>
			</TD>
			<TD align="LEFT" valign="TOP">
			<CFIF #ListEmployees.VACATION# GT 0>
				<DIV>Vacation</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.PERSONALHOLIDAY# GT 0>
				<DIV>Personal Holiday</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.COMPTIME# GT 0>
				<DIV>Compensatory Time Off</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.FMLA# GT 0>
				<DIV>Family Medical Leave Act</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.FUNERAL# GT 0>
				<DIV>Funeral Leave</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.OTHER# GT 0>
				<DIV>Other</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.GTO# GT 0>
				<DIV>Holiday Informal Time - GTO</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.JURYDUTY# GT 0>
				<DIV>Jury Duty</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.LWOP# GT 0>
				<DIV>LWOP</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.MATPAT# GT 0>
				<DIV>Maternity/Paternity Leaver</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.MILITARY# GT 0>
				<DIV>Military Leave</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.SICKFAMILY# GT 0>
				<DIV>Sick Leave Family</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.SICKSELF# GT 0>
				<DIV>Sick Leave Self</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.WITNESS# GT 0>
				<DIV>Subpoena Witness</DIV><BR>
			</CFIF>
			</TD>
			<TD align="RIGHT" valign="TOP">
			<CFIF #ListEmployees.VACATION# GT 0>
				<DIV>#ListEmployees.VACATION#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.PERSONALHOLIDAY# GT 0>
				<DIV>#ListEmployees.PERSONALHOLIDAY#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.COMPTIME# GT 0>
				<DIV>#ListEmployees.COMPTIME#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.FMLA# GT 0>
				<DIV>#ListEmployees.FMLA#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.FUNERAL# GT 0>
				<DIV>#ListEmployees.FUNERAL#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.OTHER# GT 0>
				<DIV>#ListEmployees.OTHER#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.GTO# GT 0>
				<DIV>#ListEmployees.GTO#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.JURYDUTY# GT 0>
				<DIV>#ListEmployees.JURYDUTY#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.LWOP# GT 0>
				<DIV>#ListEmployees.LWOP#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.MATPAT# GT 0>
				<DIV>#ListEmployees.MATPAT#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.MILITARY# GT 0>
				<DIV>#ListEmployees.MILITARY#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.SICKFAMILY# GT 0>
				<DIV>#ListEmployees.SICKFAMILY#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.SICKSELF# GT 0>
				<DIV>#ListEmployees.SICKSELF#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.WITNESS# GT 0>
				<DIV>#ListEmployees.WITNESS#</DIV><BR>
			</CFIF>
			</TD>
			<TD align="LEFT" valign="TOP">
			<CFIF #ListEmployees.BEGINTIME1# NEQ "">
				<DIV>#ListEmployees.BEGINTIME1#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINTIME2# NEQ "">
				<DIV>#ListEmployees.BEGINTIME2#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINTIME3# NEQ "">
				<DIV>#ListEmployees.BEGINTIME3#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.BEGINTIME4# NEQ "">
				<DIV>#ListEmployees.BEGINTIME4#</DIV><BR>
			</CFIF>
			</TD>
			<TD align="LEFT" valign="TOP">
			<CFIF #ListEmployees.ENDTIME1# NEQ "">
				<DIV>#ListEmployees.ENDTIME1#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.ENDTIME2# NEQ "">
				<DIV>#ListEmployees.ENDTIME2#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.ENDTIME3# NEQ "">
				<DIV>#ListEmployees.ENDTIME3#</DIV><BR>
			</CFIF>
			<CFIF #ListEmployees.ENDTIME4# NEQ "">
				<DIV>#ListEmployees.ENDTIME4#</DIV><BR>
			</CFIF>
			</TD>
			<TD align="CENTER" valign="TOP">
				<DIV>
					<A name="Update Absence Status" onClick="window.open('/#application.type#apps/webreports/absencerequestapproval.cfm?ABSENCEID=#ListAbsenceRequests.ABSENCEID#','Update Absence Status','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');">#ListEmployees.REQUESTSTATUSNAME#</A>
				</DIV>
			</TD>
		</TR>
</CFLOOP>
		<TR>
			<TD align="LEFT" colspan="10"><HR /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="10"><H2>#ListAbsenceRequests.RecordCount# Absence Request records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/selectedabsencereqdbrpt.cfm" method="POST">
			<TD align="LEFT" colspan="10">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="10">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>