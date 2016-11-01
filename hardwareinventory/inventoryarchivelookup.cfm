<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: inventoryarchivelookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: IDT Hardware Inventory - Archive Lookup --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Inventory Archive Lookup in IDT Hardware Inventory</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function validateLookupField() {
		if ((document.LOOKUP.HARDWAREID.selectedIndex == "0")   && (document.LOOKUP.LOCID.selectedIndex == "0")
		 && (document.LOOKUP.BARCODENUMBER.value == "3065000")
		 && (document.LOOKUP.COMMENTS.value == ""              || document.LOOKUP.COMMENTS.value == " ")
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""      || document.LOOKUP.STATEFOUNDNUMBER.value == " ")
		 && (document.LOOKUP.DATECHECKED.value == ""           || document.LOOKUP.DATECHECKED.value == "" )
		 && (document.LOOKUP.SERIALNUMBER.value == ""          || document.LOOKUP.SERIALNUMBER.value == " ")
		 && (document.LOOKUP.MODIFIEDBYID.selectedIndex == "0")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}

		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}

		if ((document.LOOKUP.BARCODENUMBER.value != "3065000" && LOOKUP.BARCODENUMBER.value != "") && document.LOOKUP.BARCODENUMBER.value.length != 17) {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  A 17 character Bar Code Number MUST be entered! Spaces are counted.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.HARDWAREID.selectedIndex > "0" && document.LOOKUP.BARCODENUMBER.value != "3065000") {
			alertuser (document.LOOKUP.BARCODENUMBER.name +  ",  BOTH a dropdown value AND a 17 character Bar Code Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}
	}


	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF IsDefined('URL.ARCHIVE')>
	<CFIF #URL.ARCHIVE# EQ 'FORWARD'>
		<CFSET PROGRAMNAME = 'archiveinventoryinfo.cfm'>
		<CFSET TABLENAME ='HARDWAREINVENTORY'>
	<CFELSE>
		<CFSET PROGRAMNAME = 'reverseinventoryarchive.cfm'>
		<CFSET TABLENAME ='INVENTORYARCHIVE'>
	</CFIF>
<CFELSE>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*****************************************************************************************
* The following code is the Look Up Process for the Hardware Inventory Archive Process. *
*****************************************************************************************
 --->

<CFQUERY name="LookupArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.LOCATIONNAME, LOC.ARCHIVELOCATION
	FROM		LOCATIONS LOC
	WHERE	LOC.LOCATIONID = 0 OR
			LOC.ARCHIVELOCATION = 'YES'
	ORDER BY	LOC.LOCATIONNAME
</CFQUERY>

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>


	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID, HI.EQUIPMENTLOCATIONID, HI.CUSTOMERID,
				CUST.FULLNAME || ' - ' || ET.EQUIPMENTTYPE ||' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		#TABLENAME# HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, EQUIPMENTTYPE ET
		WHERE	(HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID) AND
				(HI.EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#) OR
				HI.HARDWAREID = 0)
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 300 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
			<CFIF #URL.ARCHIVE# EQ 'FORWARD'>
				<H1>Inventory To <STRONG>ARCHIVE</STRONG> Selection
			<CFELSE>
				<H1>Archive To <STRONG>INVENTORY</STRONG> Selection
			</CFIF>
			</TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H2>
				Enter complete values to Lookup a specific record. <BR />
				More than one field can be selected except where text and dropdown represent the same field.</H2>
			</TH>
		</TR>
	</TABLE>
		<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	
	<FIELDSET>
	<LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?LOOKUPBARCODE=FOUND&ARCHIVE=#URL.ARCHIVE#" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2"><H2><u>Single Record Lookup</u></H2></TH>
			<TH align="left" valign="BOTTOM" colspan="2"><H2><u>Multiple Record Lookup</u></H2></TH>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2"><LABEL for="HARDWAREID">Customer, Type, and Bar Code Number</LABEL></TH>
			<TH align="left" valign="BOTTOM" colspan="2"><LABEL for="LOCID">Location</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupHardware" value="HARDWAREID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="LOCID" id="LOCID" size="1" query="LookupArchiveLocations" value="LOCATIONID" display="LOCATIONNAME" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2"><LABEL for="BARCODENUMBER">Or Bar Code Number</LABEL></TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="4">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="5">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="6">
			</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2">
				<LABEL for="STATEFOUNDNUMBER">Or State Found Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEDATECHECKED">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="DATECHECKED">
				(1) Enter a single Date Checked or (2) a series of dates separated <BR />&nbsp;by commas,NO spaces or<BR />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="18" tabindex="7">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEDATECHECKED" id="NEGATEDATECHECKED" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="DATECHECKED" id="DATECHECKED" value="" required="No" size="50" tabindex="9">
			</TD>

			
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2"><LABEL for="SERIALNUMBER">Or Serial Number</LABEL></TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="18" tabindex="10">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="11">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="12">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
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
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="12" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="13" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

	</FIELDSET>
     <BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="14" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
**************************************************************************************************
* The following code is the Record Selection Process for the Hardware Inventory Archive Process. *
**************************************************************************************************
 --->

	<CFIF "#FORM.DATECHECKED#" NEQ ''>
		<CFSET DATECHECKEDLIST = "NO">
		<CFSET DATECHECKEDRANGE = "NO">
		<CFIF FIND(',', #FORM.DATECHECKED#, 1) EQ 0 AND FIND(';', #FORM.DATECHECKED#, 1) EQ 0>
			<CFSET FORM.DATECHECKED = DateFormat(FORM.DATECHECKED, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDLIST = "YES">
			<CFELSEIF FIND(';', #FORM.DATECHECKED#, 1) NEQ 0>
				<CFSET DATECHECKEDRANGE = "YES">
				<CFSET FORM.DATECHECKED = #REPLACE(FORM.DATECHECKED, ";", ",")#>
			</CFIF>
			<CFSET DATECHECKEDARRAY = ListToArray(FORM.DATECHECKED)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)# >
				<!--- DATECHECKED FIELD = #DATECHECKEDARRAY[COUNTER]#<BR><BR> --->
			</CFLOOP>
		</CFIF>
		<CFIF DATECHECKEDRANGE EQ "YES">
			<CFSET BEGINDATECHECKED = DateFormat(#DATECHECKEDARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDDATECHECKED = DateFormat(#DATECHECKEDARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- DATECHECKEDLIST = #DATECHECKEDLIST#<BR><BR>
		DATECHECKEDRANGE = #DATECHECKEDRANGE#<BR><BR> --->
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="GetHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, 
				HI.COMMENTS, TO_CHAR(HI.DATECHECKED, 'DD-MON-YYYY HH24:MI:SS')AS DATECHECKED, HI.MODIFIEDBYID
		FROM		#TABLENAME# HI
		WHERE	(HARDWAREID > 0 AND
				HI.EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#)) AND
				(
			<CFIF #FORM.HARDWAREID# GT 0>
				HI.HARDWAREID = #val(FORM.HARDWAREID)# #LOGICANDOR#
			<CFELSEIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ "">
				HI.BARCODENUMBER = '#FORM.BARCODENUMBER#' #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">
				HI.STATEFOUNDNUMBER = UPPER('#FORM.STATEFOUNDNUMBER#') #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.SERIALNUMBER# NEQ "">
				HI.SERIALNUMBER = UPPER('#FORM.SERIALNUMBER#') #LOGICANDOR#
			</CFIF>

			<CFIF IsDefined('FORM.LOCID') AND FORM.LOCID GT 0>
				HI.EQUIPMENTLOCATIONID = #FORM.LOCID# #LOGICANDOR#
			</CFIF>
	
			<CFIF #FORM.COMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATECOMMENTS")>
					NOT HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				<CFELSE>
					HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.DATECHECKED#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEDATECHECKED")>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(DATECHECKEDARRAY)#>
							<CFSET FORMATDATECHECKED =  DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
						NOT (HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATECHECKED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF DATECHECKEDLIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(DATECHECKEDARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATDATECHECKED = DateFormat(#DATECHECKEDARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATDATECHECKED = DateFormat(#DATECHECKEDARRAY[ArrayLen(DATECHECKEDARRAY)]#, 'DD-MMM-YYYY')>
						HI.DATECHECKED = TO_DATE('#FORMATDATECHECKED#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF DATECHECKEDRANGE EQ "YES">
							(HI.DATECHECKED BETWEEN TO_DATE('#BEGINDATECHECKED#', 'DD-MON-YYYY') AND TO_DATE('#ENDDATECHECKED#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						HI.DATECHECKED LIKE TO_DATE('#FORM.DATECHECKED#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					HI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

				HI.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>

	<CFIF #GetHardware.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Inventory Record(s) Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?ARCHIVE=#URL.ARCHIVE#" />
		<CFEXIT>
	<CFELSE>
		<CFSET URL.HARDWAREIDS = #ValueList(GetHardware.HARDWAREID)#>
		HARDWARE IDS = #URL.HARDWAREIDS#
		<SCRIPT language="JavaScript">
			<!-- 
				window.open("/#application.type#apps/hardwareinventory/inventarchivelookupreport.cfm?ARCHIVE=#URL.ARCHIVE#&HARDWAREIDS=#URL.HARDWAREIDS#","Print_Archive Records", "alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25");
			 -->
		</SCRIPT>
		<CFSET temp = ArraySet(session.HardwareIDArray, 1, LISTLEN(URL.HARDWAREIDS), 0)> 
		<CFSET session.HardwareIDArray = ListToArray(URL.HARDWAREIDS)>
	</CFIF>

	<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.EQUIPMENTLOCATIONID,
				LOC.LOCATIONID, LOC.LOCATIONNAME, HI.EQUIPMENTTYPEID, ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.REQUISITIONNUMBER,
				HI.PURCHASEORDERNUMBER, HI.COMMENTS, HI.MODIFIEDBYID, MOD.CUSTOMERID, MOD.FULLNAME AS MODNAME, HI.DATECHECKED
		FROM		#TABLENAME# HI, EQUIPMENTTYPE ET, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS MOD
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#GetHardware.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.EQUIPMENTLOCATIONID IN (#ValueList(LookupArchiveLocations.LOCATIONID)#) AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.MODIFIEDBYID = MOD.CUSTOMERID
		ORDER BY	HI.BARCODENUMBER
	</CFQUERY>

<!--- 
*************************************************************************
* The following code is the Archive Confirmation for Hardware Inventory *
*************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
			<CFIF #URL.ARCHIVE# EQ 'FORWARD'>
				<H1>Inventory To <STRONG>ARCHIVE</STRONG> Confirmation
			<CFELSE>
				<H1>Archive To <STRONG>INVENTORY</STRONG> Confirmation
			</CFIF>
			</TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align= "CENTER" colspan="5">
				<H4>Hardware Inventory Key &nbsp; = &nbsp; #ListHardware.HARDWAREID# </H4>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?ARCHIVE=#URL.ARCHIVE#" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
<CFFORM name="CONFIRMARCHIVE" action="/#application.type#apps/hardwareinventory/#PROGRAMNAME#?HARDWAREIDS=#URL.HARDWAREIDS#&ARCHIVE=#URL.ARCHIVE#" method="POST">
		<TR>
			<TH align="LEFT">Bar Code Number</TH>
			<TH align="LEFT">State Found Number</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" nowrap><DIV>#ListHardware.BARCODENUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListHardware.STATEFOUNDNUMBER#</DIV></TD>
		</TR>
		<TR>
			<TH align="LEFT">Serial Number</TH>
			<TH align="LEFT">Equipment Type</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#ListHardware.SERIALNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListHardware.EQUIPMENTTYPE#</DIV></TD>
		</TR>
		<TR>
			<TH align="LEFT">Location Name</TH>
			<TH align="LEFT">Requisition Number</TH>
		</TR>
			<TD align="left" valign="TOP"><DIV>#ListHardware.LOCATIONNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListHardware.REQUISITIONNUMBER#</DIV></TD>
		
		<TR>
			<TH align="LEFT">Purchase Order Number</TH>
			<TH align="LEFT">Modified By</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#ListHardware.PURCHASEORDERNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListHardware.MODNAME#</DIV></TD>
		</TR>
		<TR>
			<TH align="LEFT">Date Checked</TH>
			<TH align="LEFT">Comments</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListHardware.COMMENTS#</DIV></TD>
		</TR>
		<TR>
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonConfirm.jpg" value="Confirm" alt="Confirm" tabindex="2">
			</TD>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
</CFFORM>
		<TR>
			<TD colspan="2"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/inventoryarchivelookup.cfm?ARCHIVE=#URL.ARCHIVE#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="3" />
			</TD>
			<TD>&nbsp;&nbsp;</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="2"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>