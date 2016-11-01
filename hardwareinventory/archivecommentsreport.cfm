<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: archivecommentsreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: Archive Comments Report for IDT Hardware Inventory--->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/archivecommentsreport.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Archive Comments Report for IDT Hardware Inventory</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLOC')>
	<CFSET CURSORFIELD = "document.LOOKUP.LOCID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************
* The following code is the Look Up Process for Archive Comments  Report. *
***************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPLOC")>

<CFQUERY name="LookupArchiveLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.LOCATIONNAME, LOC.ARCHIVELOCATION
	FROM		LOCATIONS LOC
	WHERE	LOC.LOCATIONID = 0 OR
			LOC.ARCHIVELOCATION = 'YES'
	ORDER BY	LOC.LOCATIONNAME
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Archive Comments Report Selection Lookup</H1></TD>
	</TR>
</TABLE>


<TABLE width="100%" align="left" border="0">
	<TR>
		<TH colspan="4" align="center">
			<H2>Select from the drop down box or type in values to choose report criteria. <BR /> 
			Checking the adjacent checkbox will Negate the data entered.</H2>
		</TH>
	</TR>
	<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
	</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
		</TD>
</CFFORM>
	</TR>
</TABLE>
	
<FIELDSET>
<LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/hardwareinventory/archivecommentsreport.cfm?LOOKUPLOC=FOUND" method="POST">
<TABLE width="100%" align="LEFT">
	<TR>
		<TH class="TH_negate" align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
		<TH align="left" valign="bottom" width="45%"><LABEL for="LOCID">Location</LABEL></TH>
		<TH class="TH_negate" align="LEFT" width="5%">
			<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR /> 
			&nbsp;Value
		<TH align="LEFT" width="45%">
			<LABEL for="COMMENTS">Comments</LABEL>
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
		<TD align="LEFT" width="45%">
			<CFSELECT name="LOCID" id="LOCID" size="1" query="LookupArchiveLocations" value="LOCATIONID" display="LOCATIONNAME" required="No" tabindex="2"></CFSELECT>
		</TD>
		<TD align="LEFT" width="5%">
			<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</TD>
		<TD align="LEFT" width="45%">
			<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="4">
		</TD>
	</TR>
	<TR>
		<TD>&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
			<LABEL for="NEGATEDATECHECKED">Negate</LABEL><BR>
			&nbsp;Value 
		</TH>
		<TH align="left" valign="BOTTOM" width="45%">
			<LABEL for="DATECHECKED">Enter (1) a single Date Checked or <BR />
			&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
			&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
		</TH>
		<TH class="TH_negate" align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
		<TH align="LEFT" width="45%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="LEFT" width="5%">
			<CFINPUT type="CheckBox" name="NEGATEDATECHECKED" id="NEGATEDATECHECKED"value="" align="LEFT" required="No" tabindex="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</TD>
		<TD align="LEFT" width="45%">
			<CFINPUT type="Text" name="DATECHECKED" id="DATECHECKED" value="" required="No" size="50" tabindex="6">
		</TD>
		<TD align="LEFT" width="5%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
		<TD align="LEFT" width="45%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD colspan="4">&nbsp;&nbsp;</TD>
	</TR>
</TABLE>
</FIELDSET>
<BR />
<FIELDSET>
<LEGEND>Report Selection</LEGEND>
<TABLE width="100%" border="0">
	<TR>
		<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
	</TR>
	<TR>
          <TD align="LEFT" colspan="4">
               <INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
               <BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="7" />
          </TD>
     </TR>
     <TR>
          <TD align="LEFT" colspan="4">
               <INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="8" />
          </TD>
	</TR>
</TABLE>
</CFFORM>

</FIELDSET>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="9" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
</TABLE>

<CFELSE>
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

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="ListHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.DIVISIONNUMBER,
				HI.MACHINENAME, HI.EQUIPMENTLOCATIONID, LOC.LOCATIONID, LOC.LOCATIONNAME, HI.MACADDRESS, HI.EQUIPMENTTYPEID, 
				ET.EQUIPTYPEID, ET.EQUIPMENTTYPE, HI.DESCRIPTIONID, ED.EQUIPDESCRID, ED.EQUIPMENTDESCRIPTION, HI.MODELNAMEID,
                    MNL.MODELNAMEID, MNL.MODELNAME, HI.MODELNUMBERID, MUL.MODELNUMBERID, MUL.MODELNUMBER, HI.SPEEDNAMEID, SNL.SPEEDNAMEID,
                    SNL.SPEEDNAME, HI.MANUFACTURERID, HI.DELLEXPRESSSERVICE, HI.WARRANTYVENDORID, VEND.VENDORNAME, HI.REQUISITIONNUMBER,
                    HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.FISCALYEARID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.UNITID,
                    HI.COMMENTS, HI.OWNINGORGID, HI.MODIFIEDBYID, MOD.CUSTOMERID, MOD.FULLNAME AS MODNAME, HI.DATECHECKED
		FROM		INVENTORYARCHIVE HI, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, MODELNAMELIST MNL, LIBSHAREDDATAMGR.CUSTOMERS CUST,
				MODELNUMBERLIST MUL, SPEEDNAMELIST SNL, PURCHASEMGR.VENDORS VEND, FACILITIESMGR.LOCATIONS LOC,
				LIBSHAREDDATAMGR.CUSTOMERS MOD
		WHERE	((HI.HARDWAREID > 0 AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MODELNAMEID = MNL.MODELNAMEID AND
				HI.MODELNUMBERID = MUL.MODELNUMBERID AND
				HI.SPEEDNAMEID = SNL.SPEEDNAMEID AND
				HI.WARRANTYVENDORID = VEND.VENDORID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND 
				HI.MODIFIEDBYID = MOD.CUSTOMERID) AND (

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

				HI.MODIFIEDBYID #FINALTEST# 0))
		ORDER BY	HI.STATEFOUNDNUMBER, HI.BARCODENUMBER
	</CFQUERY>


<!--- 
****************************************************************************
* The following code is the Archive Comments Report for Hardware Inventory *
****************************************************************************
 --->
<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>Archive Comments Report</H1></TH>
	</TR>
	
</TABLE>
<BR />
<TABLE width="100%" align="LEFT">
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/archivecommentsreport.cfm" method="POST">
		<TD align="LEFT">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
          </TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="CENTER" colspan="10"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="CENTER" valign="BOTTOM">State Found Number</TH>
		<TH align="CENTER" valign="BOTTOM">Serial Number</TH>
		<TH align="CENTER" valign="BOTTOM">Bar Code Number</TH>
		<TH align="CENTER" valign="BOTTOM">Division Number</TH>
		<TH align="CENTER" valign="BOTTOM">Equipment Type</TH>
		<TH align="CENTER" valign="BOTTOM">Date Received</TH>
		<TH align="left" valign="BOTTOM">Customer</TH>
		<TH align="CENTER" valign="BOTTOM">Location Name</TH>
		<TH align="CENTER" valign="BOTTOM">Date Checked</TH>
		<TH align="left" valign="BOTTOM">Comments</TH>
	</TR>
<CFLOOP query="ListHardware">
	<TR>
		<TD align="left" valign="TOP"><DIV>#ListHardware.STATEFOUNDNUMBER#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.SERIALNUMBER#</DIV></TD>
		<TD align="left" valign="TOP" nowrap><DIV>#ListHardware.BARCODENUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.DIVISIONNUMBER#</DIV></TD>
		<TD align="CENTER" valign="TOP"><DIV>#ListHardware.EQUIPMENTTYPE#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListHardware.DATERECEIVED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.FULLNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.LOCATIONNAME#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#DateFormat(ListHardware.DATECHECKED, "MM/DD/YYYY")#</DIV></TD>
		<TD align="left" valign="TOP"><DIV>#ListHardware.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD colspan="11"><HR width="100%" size="5" noshade /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="CENTER" colspan="10"><H2>#ListHardware.RecordCount# hardware records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/archivecommentsreport.cfm" method="POST">
		<TD align="LEFT">
          	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
          </TD>
</CFFORM>
	</TR>
	<TR>
		<TD colspan="10">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>