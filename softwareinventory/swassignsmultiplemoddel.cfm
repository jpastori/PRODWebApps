<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: swassignsmultiplemoddel.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Multiple Record Modify/Delete to IDT Software Inventory - Assignments--->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Modify/Delete to IDT Software Inventory - Assignments</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.SOFTWINVENTID.selectedIndex == "0"  && document.LOOKUP.PRODPLATFORMID.selectedIndex == "0"
		 && document.LOOKUP.ASSIGNEDCUSTID.selectedIndex == "0" 
		 && (document.LOOKUP.SERIALNUMBER.value == ""           || document.LOOKUP.SERIALNUMBER.value == " ")
		 && document.LOOKUP.ASSIGNEDHARDWAREID.selectedIndex == "0"
		 && (document.LOOKUP.DIVISIONNUMBER.value == ""         || document.LOOKUP.DIVISIONNUMBER.value == " ")
		 && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0"     
		 && (document.LOOKUP.MODIFIEDDATE.value == ""            || document.LOOKUP.MODIFIEDDATE.value == " ")) {
			alertuser ("You must select or enter information in one of the eight (8) fields!");
			document.LOOKUP.SOFTWINVENTID.focus();
			return false;
		}
	}


	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}	
	
	function setDeleteMultiple() {
		document.ASSIGNMENTS.PROCESSSOFTWAREASSIGNMENTS.value = "DELETEMULTIPLE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPTITLE')>
	<CFSET CURSORFIELD = "document.LOOKUP.SOFTWINVENTID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.ASSIGNMENTS.SERIALNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE,
			LOC.LOCATIONID, LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U, FACILITIESMGR.LOCATIONS LOC
	WHERE	(CUST.UNITID = U.UNITID AND
			CUST.LOCATIONID = LOC.LOCATIONID AND
			CUST.ACTIVE = 'YES') AND
			(U.DEPARTMENTID = 8 OR
			LOC.LOCATIONID = 118 OR
			CUST.CUSTOMERID = 0)
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER,
			HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, 
			HI.CUSTOMERID, CUST.FULLNAME, HI.BARCODENUMBER || ' - ' || HI.DIVISIONNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY
	FROM		HARDWAREINVENTORY HI, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST
	WHERE	(HI.HARDWAREID = 0 OR 
			HI.EQUIPMENTTYPEID = 1) AND
			HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
			HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
			HI.CUSTOMERID = CUST.CUSTOMERID
	ORDER BY	LOOKUPKEY
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || ' - ' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 900 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
**********************************************************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Multiple Records in IDT Software Inventory - Assignments. *
**********************************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPTITLE')>

	<CFQUERY name="ListSoftwareInventoryTitle" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
				SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID,
				SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE, 
				SI.TITLE || ' - ' || SI.SOFTWINVENTID AS LOOKUPKEY
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
	
	<CFQUERY name="ListVersionPlatform" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
				SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
				SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE,
				SI.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME AS LOOKUPKEY
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
		WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Multiple Records Lookup for IDT Software Inventory - Assignments.</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center"><H2>Select from the dropdown fields or type in partial values to lookup multiple records for Modify/Delete.<BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     <FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm?LOOKUPTITLE=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESOFTWINVENTID">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SOFTWINVENTID">Title</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPRODPLATFORMID">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				&nbsp;<LABEL for="PRODPLATFORMID">Version - Platform</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESOFTWINVENTID" id="NEGATESOFTWINVENTID" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="ListSoftwareInventoryTitle" value="SOFTWINVENTID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPRODPLATFORMID" id="NEGATEPRODPLATFORMID" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				&nbsp;<CFSELECT name="PRODPLATFORMID" id="PRODPLATFORMID" size="1" query="ListVersionPlatform" value="SOFTWINVENTID" display="LOOKUPKEY" selected="0" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
               <TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEASSIGNEDCUSTID">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ASSIGNEDCUSTID">Assigned SW Customer</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESERIALNUMBER">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SERIALNUMBER">Serial Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEASSIGNEDCUSTID" id="NEGATEASSIGNEDCUSTID" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESERIALNUMBER" id="NEGATESERIALNUMBER" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="50" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEASSIGNEDHARDWAREID">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ASSIGNEDHARDWAREID">CPU Assigned - Division Number - HW Customer</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDIVISIONNUMBER">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DIVISIONNUMBER">Division Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEASSIGNEDHARDWAREID" id="NEGATEASSIGNEDHARDWAREID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" selected="0" required="No" tabindex="13"></CFSELECT>
			</TD>
			<TH align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDIVISIONNUMBER" id="NEGATEDIVISIONNUMBER" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="DIVISIONNUMBER" id="DIVISIONNUMBER" value="" align="LEFT" required="No" size="50" tabindex="15">
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified-By</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">
				(1) a single Modified Date or <BR>
				&nbsp;(2) a series of dates separated by commas,NO spaces or <BR>
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="17">
					<OPTION value="0">SELECT A NAME</OPTION>
					<CFLOOP query="ListRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="19">
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="20" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="21" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

	</FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="22" /><BR />
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
*******************************************************************************************************************
* The following code is the Multiple Record Modify and Delete Processes for IDT Software Inventory - Assignments. *
*******************************************************************************************************************
 --->
	<CFIF #FORM.DIVISIONNUMBER# NEQ "">

		<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
			SELECT	HI.HARDWAREID, HI.DIVISIONNUMBER
			FROM		HARDWAREINVENTORY HI
			WHERE	HI.HARDWAREID > 0 AND
					HI.DIVISIONNUMBER LIKE UPPER('#FORM.DIVISIONNUMBER#%')
			ORDER BY	HI.DIVISIONNUMBER
		</CFQUERY>

	</CFIF>

	<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATELIST = "NO">
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
				MODIFIED DATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MODIFIED DATE LIST = #MODIFIEDDATELIST#<BR /><BR />
		MODIFIED DATE RANGE = #MODIFIEDDATERANGE#<BR /><BR />
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET NEGATEDATELOOP = "AND">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET NEGATEDATELOOP = "OR">
		<CFSET FINALTEST = ">">
	</CFIF>


	<CFQUERY name="GetSoftwareAssignmentIDs" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SOFTWASSIGNID, SOFTWINVENTID, ASSIGNDATE, ASSIGNEDHARDWAREID, SERIALNUMBER, ASSIGNEDCUSTID,
				MODIFIEDBYID, MODIFIEDDATE
		FROM		SOFTWAREASSIGNMENTS
		WHERE	SOFTWINVENTID > 0 AND
		<CFIF #FORM.SOFTWINVENTID# GT 0>
			<CFIF IsDefined("FORM.NEGATESOFTWINVENTID")>
				NOT (SOFTWINVENTID = #val(FORM.SOFTWINVENTID)#) #LOGICANDOR#
			<CFELSE>
				SOFTWINVENTID = #val(FORM.SOFTWINVENTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PRODPLATFORMID# GT 0>
			<CFIF IsDefined("FORM.NEGATEPRODPLATFORMID")>
				NOT (SOFTWINVENTID = #val(FORM.PRODPLATFORMID)#) #LOGICANDOR#
			<CFELSE>
				SOFTWINVENTID = #val(FORM.PRODPLATFORMID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.SERIALNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATESERIALNUMBER")>
				NOT SERIALNUMBER LIKE '#FORM.SERIALNUMBER#%' #LOGICANDOR#
			<CFELSE>
				SERIALNUMBER LIKE '#FORM.SERIALNUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ASSIGNEDCUSTID# GT 0>
			<CFIF IsDefined("FORM.NEGATEASSIGNEDCUSTID")>
				NOT (ASSIGNEDCUSTID = #val(FORM.ASSIGNEDCUSTID)#) #LOGICANDOR#
			<CFELSE>
				ASSIGNEDCUSTID = #val(FORM.ASSIGNEDCUSTID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.ASSIGNEDHARDWAREID# GT 0>
			<CFIF IsDefined("FORM.NEGATEASSIGNEDHARDWAREID")>
				NOT (ASSIGNEDHARDWAREID = #val(FORM.ASSIGNEDHARDWAREID)#) #LOGICANDOR#
			<CFELSE>
				ASSIGNEDHARDWAREID = #val(FORM.ASSIGNEDHARDWAREID)#  #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.DIVISIONNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEDIVISIONNUMBER")>
				NOT ASSIGNEDHARDWAREID IN (#ValueList(LookupHardware.HARDWAREID)#) #LOGICANDOR#
			<CFELSE>
				ASSIGNEDHARDWAREID IN (#ValueList(LookupHardware.HARDWAREID)#) #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
				NOT MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			<CFELSE>
				MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
			<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
						<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						NOT MODIFIEDDATE IN TO_DATE('#FORMATMODIFIEDDATE# ', 'DD-MON-YYYY') AND
						<CFSET FINALTEST = ">">
					</CFLOOP>
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
					NOT (MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					NOT MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE# 12:00:00 AM', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			<CFELSE>
				<CFIF MODIFIEDDATELIST EQ "YES">
					<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
						<CFSET FINALTEST = "=">
						MODIFIEDDATE IN TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
					</CFLOOP>
				<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						(MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
				<CFELSE>
					MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
				</CFIF>
			</CFIF>
		</CFIF>

				MODIFIEDBYID #FINALTEST# 0
		ORDER BY	SOFTWASSIGNID
	</CFQUERY>

	<CFIF #GetSoftwareAssignmentIDs.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>

		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm" />
		<CFEXIT>
	<CFELSE>
		<CFSET SOFTWASSIGNIDLIST = #ValueList(GetSoftwareAssignmentIDs.SOFTWASSIGNID)#>
		<!--- SOFTWARE ASSIGNMENT IDS = #SOFTWASSIGNIDLIST# --->
		<SCRIPT language="JavaScript">
			<!-- 
				window.open("/#application.type#apps/softwareinventory/swassignmultiplelookuprpt.cfm?SOFTWASSIGNIDS=#SOFTWASSIGNIDLIST#","Print_Software_IDs", "alwaysRaised=yes,dependent=no,width=1500,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
				-->
		</SCRIPT>
	</CFIF>

	<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT,
				SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
				SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP 
		WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareAssignmentIDs.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
		ORDER BY	TITLE, VERSION, PRODPLATFORMID
	</CFQUERY>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.DIVISIONNUMBER
		FROM		HARDWAREINVENTORY HI
		WHERE	HI.HARDWAREID > 0 AND
				HI.HARDWAREID = <CFQUERYPARAM value="#GetSoftwareAssignmentIDs.ASSIGNEDHARDWAREID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	HI.DIVISIONNUMBER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Multiple Records in IDT Software Inventory - Assignments</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align= "CENTER">
				<!--- Software Inventory Key &nbsp; = &nbsp; #GetSoftwareInventory.SOFTWINVENTID# &nbsp;&nbsp; --->
				Assignments Key &nbsp; = &nbsp; #GetSoftwareAssignmentIDs.SOFTWASSIGNID#<BR />
				Assigned: &nbsp;&nbsp;#DateFormat(GetSoftwareAssignmentIDs.ASSIGNDATE, "mm/dd/yyyy")#
				<!--- <cfcookie name="SOFTWINVENTID" secure="NO" value="#GetSoftwareInventory.SOFTWINVENTID#"> --->
				<CFCOOKIE name="SOFTWASSIGNID" secure="NO" value="#GetSoftwareAssignmentIDs.SOFTWASSIGNID#">
			</TH>
		</TR>
		<TR>
			<TH align="left"><H2>To modify a field on multiple records, a check in the adjacent checkbox is required.</H2></TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="ASSIGNMENTS" onsubmit="return validateReqFields();" action="/#application.type#apps/softwareinventory/processsoftwareassignments.cfm?MULTIPLERECORDS=YES&SOFTWASSIGNIDS=#SOFTWASSIGNIDLIST#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Title</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Version - Platform</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetSoftwareInventory.TITLE# - #GetSoftwareInventory.SOFTWINVENTID#</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">#GetSoftwareInventory.VERSION# - #GetSoftwareInventory.PRODUCTPLATFORMNAME# </TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="ASSIGNEDCUSTIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ASSIGNEDCUSTID">Assigned SW Customer</LABEL>
			</TH>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="SERIALNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SERIALNUMBER">Serial Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="ASSIGNEDCUSTIDCHANGED" id="ASSIGNEDCUSTIDCHANGED" value="" align="LEFT" required="No" tabindex="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetSoftwareAssignmentIDs.ASSIGNEDCUSTID#" required="No" tabindex="7"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="SERIALNUMBERCHANGED" id="SERIALNUMBERCHANGED" value="" align="LEFT" required="No" tabindex="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="#GetSoftwareAssignmentIDs.SERIALNUMBER#" align="LEFT" required="No" size="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="left" valign="BOTTOM" width="5%">
				<LABEL for="ASSIGNEDHARDWAREIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ASSIGNEDHARDWAREID">CPU Assigned - Division Number - HW Customer</LABEL>
			</TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Division Number</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="ASSIGNEDHARDWAREIDCHANGED" id="ASSIGNEDHARDWAREIDCHANGED" value="" align="LEFT" required="No" tabindex="8">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ASSIGNEDHARDWAREID" id="ASSIGNEDHARDWAREID" size="1" query="ListHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" selected="#GetSoftwareAssignmentIDs.ASSIGNEDHARDWAREID#" tabindex="9"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				#GetHardware.DIVISIONNUMBER#
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="10"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP" width="5%">&nbsp;&nbsp;</TD>
			<TD align="left" valign="TOP" width="45%">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" id="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#<BR /><BR />
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">
               	<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="MODIFYMULTIPLE" />
                    <INPUT type="image" src="/images/buttonModifyMultiple.jpg" value="MODIFYMULTIPLE" alt="Modify Multiple" tabindex="11" />
               </TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonDeleteMultiple.jpg" value="DELETEMULTIPLE" alt="Delete Multiple" OnClick="return setDeleteMultiple();" tabindex="12" />
               </TD>
		</TR>
		</CFIF>

</CFFORM>
		<TR>
			<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/swassignsmultiplemoddel.cfm" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="13" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>