<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: srnonpublichwreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/19/2012 --->
<!--- Date in Production: 11/19/2012 --->
<!--- Module: IDT Service Requests - Non-Public Hardware / SR Report --->
<!-- Last modified by John R. Pastori on 11/19/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/srnonpublichwreport.cfm">
<CFSET CONTENT_UPDATED = "November 19, 2012">


<CFIF (FIND('wiki', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "WIKI")>
	<CFSET SESSION.ORIGINSERVER = "WIKI">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSEIF (FIND('#application.type#apps/forms', #CGI.HTTP_REFERER#, 1) NEQ 0) OR (IsDefined('SESSION.ORIGINSERVER') AND #SESSION.ORIGINSERVER# EQ "FORMS")>
	<CFSET SESSION.ORIGINSERVER = "FORMS">
	<CFSET SESSION.RETURNPGM = "returnindex.cfm">
<CFELSE>
	<CFINCLUDE template = "../programsecuritycheck.cfm">
	<CFSET SESSION.ORIGINSERVER = "">
	<CFSET SESSION.RETURNPGM = "srnonpublichwreport.cfm">
</CFIF>

<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Non-Public Hardware / SR Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		
		if (document.LOOKUP.BARCODENUMBER.value.length == 14) {
			var barcode = LOOKUP.BARCODENUMBER.value;
			LOOKUP.BARCODENUMBER.value = (barcode.substr(0,1) + " " + barcode.substr(1,4) + " " + barcode.substr(5,5) + " " + barcode.substr(10,4));
		}
		
		if (document.LOOKUP.LOCATIONID.selectedIndex > "0" && document.LOOKUP.ROOMNUMBER.value != "") {
			alertuser ("You CAN NOT both select a Room Number from the Drop Down and enter a Room Number in the text box!");
			document.LOOKUP.LOCATIONID.focus();
			return false;
		}
		
		if (document.LOOKUP.CATID.selectedIndex > "0" && document.LOOKUP.CUSTOMERCATEGORY.value != "") {
			alertuser ("You CAN NOT both select a Customer Category from the Drop Down and enter a Customer Category in the text box!");
			document.LOOKUP.CATID.focus();
			return false;
		}
		
		if (document.LOOKUP.UNITID.selectedIndex > "0" && document.LOOKUP.UNITNUMBER.value != "") {
			alertuser ("You CAN NOT both select a Unit Name from the Drop Down and enter a Unit Number in the text box!");
			document.LOOKUP.UNITID.focus();
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
<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFSET CURSORFIELD = "document.LOOKUP.BARCODENUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************************************************
* The following code is the Look Up Process for IDT Service Requests - Non-Public Hardware / SR Report. *
*********************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>

	<CFQUERY name="ListEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="14">
          SELECT	EQUIPTYPEID, EQUIPMENTTYPE, MODIFIEDBYID, MODIFIEDDATE
          FROM		EQUIPMENTTYPE
          ORDER BY	EQUIPMENTTYPE
     </CFQUERY>

	<CFQUERY name="ListBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME
		FROM		BUILDINGNAMES
          WHERE	BUILDINGNAMEID IN (0,5,10,11)
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER, BUILDINGNAMEID
		FROM		LOCATIONS
          WHERE	BUILDINGNAMEID IN (0,5,10,11)
		ORDER BY	ROOMNUMBER
	</CFQUERY>
     
     <CFQUERY name="ListCustomerCategory" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
          SELECT	CATEGORYID, CATEGORYNAME
          FROM		CATEGORIES
          WHERE	CATEGORYID IN (0,1,4,5,6,8,16)
          ORDER BY	CATEGORYNAME
     </CFQUERY>

	<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUST.CUSTOMERID, CUST.LASTNAME, CUST.FULLNAME, U.UNITNAME, U.DEPARTMENTID, G.GROUPNAME, CUST.CAMPUSPHONE,
				LOC.ROOMNUMBER, CUST.EMAIL, CUST.ACTIVE
		FROM		CUSTOMERS CUST, UNITS U, GROUPS G, FACILITIESMGR.LOCATIONS LOC
		WHERE	(CUST.UNITID = U.UNITID AND
				U.GROUPID = G.GROUPID AND
				CUST.LOCATIONID = LOC.LOCATIONID AND
				CUST.ACTIVE = 'YES') AND
				(CUST.CUSTOMERID = 0 OR
				U.DEPARTMENTID = 8)
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
		SELECT	UNITID, UNITNAME, DEPARTMENTID, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
          WHERE	DEPARTMENTID = 8 OR
          		UNITID = 0
		ORDER BY	UNITNAME
	</CFQUERY>

	 <CFQUERY name="ListFiscalYears" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<CFQUERY name="ListCurrentFiscalYear" datasource="#application.type#LIBSHAREDDATA">
          SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
          FROM		FISCALYEARS
          WHERE	(CURRENTFISCALYEAR = 'YES')
          ORDER BY	FISCALYEARID
     </CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Non-Public Hardware / SR Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
     <BR /><BR />
     <FIELDSET>
	<LEGEND>Equipment</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/servicerequests/srnonpublichwreport.cfm?LOOKUPBARCODE=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBARCODENUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BARCODENUMBER">Bar Code Number </LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEEQUIPMENTTYPEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="EQUIPMENTTYPEID">Equipment Type</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEBARCODENUMBER" id="NEGATEBARCODENUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="BARCODENUMBER" id="BARCODENUMBER" value="3065000" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEEQUIPMENTTYPEID" id="NEGATEEQUIPMENTTYPEID" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				&nbsp;<CFSELECT name="EQUIPMENTTYPEID" id="EQUIPMENTTYPEID" size="1" query="ListEquipmentTypes" value="EQUIPTYPEID" display="EQUIPMENTTYPE" selected="0" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDING">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="BUILDINGNAMEID">Building</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">(1) Select a Room Number or </LABEL>
				<LABEL for="ROOMNUMBER">(2) enter a Room Number <BR />
				&nbsp;or (3) enter a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEBUILDING" id="NEGATEBUILDING" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				&nbsp;<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUILDINGNAME" selected="0" required="No" tabindex="5"></CFSELECT>
			</TD>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="7"></CFSELECT>	
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="8">
			</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>Customer and Unit</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERCATEGORY">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="CATID">Select a Category from the dropdown</LABEL> Or
				<LABEL for="CUSTOMERCATEGORY">Enter (1) a single Customer Category or (2) a series of Customer Categories<BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERID">Customer</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERCATEGORY" id="NEGATECUSTOMERCATEGORY" value="" align="LEFT" required="No" tabindex="9">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="CATID" id="CATID" size="1" query="ListCustomerCategory" value="CATEGORYID" display="CATEGORYNAME" required="No" selected="0" tabindex="10"></CFSELECT>
				<CFINPUT type="Text" name="CUSTOMERCATEGORY" id="CUSTOMERCATEGORY" value="" required="No" size="50" tabindex="11">
			</TD>
               <TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERID" id="NEGATECUSTOMERID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="13"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERFIRSTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERFIRSTNAME">Or Enter a Customer's First Name</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECUSTOMERLASTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERLASTNAME">Or Enter a Customer's Last Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERFIRSTNAME" id="NEGATECUSTOMERFIRSTNAME" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="CUSTOMERFIRSTNAME" id="CUSTOMERFIRSTNAME" value="" align="LEFT" required="No" size="17" tabindex="15">
			</TD>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECUSTOMERLASTNAME" id="NEGATECUSTOMERLASTNAME" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="CUSTOMERLASTNAME" id="CUSTOMERLASTNAME" value="" align="LEFT" required="No" size="17" tabindex="17">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEUNITID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UNITID">(1) Select a Unit Name </LABEL><LABEL for="UNITNUMBER">or (2) enter a series of Unit Numbers <BR />
				&nbsp;separated by commas,NO spaces.</LABEL>
			</TH>
			<TH align="LEFT" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEUNITID" id="NEGATEUNITID" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="19"></CFSELECT>
				<CFINPUT type="Text" name="UNITNUMBER" id="UNITNUMBER" value="" required="No" size="20" maxlength="30" tabindex="20">
			</TD>
			<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
	<LEGEND>SR</LEGEND>
	<TABLE width="100%" border="0">
     	<TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Select a Fiscal Year </LABEL>
			</TH>
          	<TH align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SRCOMPLETED">SR Completed?</LABEL>
			</TH>
          </TR>
		<TR>
               <TD align="LEFT" valign="TOP" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID"id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="21">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
               	<CFSELECT name="FISCALYEARID" id="FISCALYEARID" size="1" query="ListFiscalYears" value="FISCALYEARID" selected="#ListCurrentFiscalYear.FISCALYEARID#" display="FISCALYEAR_4DIGIT" required="No" tabindex="22"></CFSELECT>
               </TD>
               <TD align="LEFT" width="5%">&nbsp;&nbsp;</TD>				
               <TD align="left" width="33%" valign="top">
                    <CFSELECT name="SRCOMPLETED" id="SRCOMPLETED" size="1" tabindex="23">
                    	<OPTION value="Select an Option"> Select an Option</OPTION>
                         <OPTION value="NO">NO</OPTION>
                         <OPTION value="YES">YES</OPTION>
                         <OPTION value="VOIDED">VOIDED</OPTION>
                    </CFSELECT>
               </TD>
 		</TR> 
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
     </TABLE>
	</FIELDSET>
	<BR />
	<FIELDSET>
     <LEGEND>Record Selection</LEGEND>
	<TABLE width="100%" border="0">
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="4"><H2>Clicking on the "Match All" button without selecting any fields <BR> will display all records for the current Fiscal Year.</H2></TH>
		</TR>
     	<TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="24" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="25" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
	</FIELDSET>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="26" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

	<CFEXIT>
     
<CFELSE>

<!--- 
********************************************************************************************************
* The following code is the IDT Service Requests - Non-Public Hardware / SR Report Generation Process. *
********************************************************************************************************
 --->
 
	<CFSET REPORTTITLE2 = "">
     
     <CFIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ "">
     	<CFSET REPORTTITLE2 = "BARCODE NUMBER - #FORM.BARCODENUMBER#">
     </CFIF>
     
     <CFIF #FORM.EQUIPMENTTYPEID# GT 0>
     	<CFQUERY name="LookupEquipmentTypes" datasource="#application.type#HARDWARE" blockfactor="14">
               SELECT	EQUIPTYPEID, EQUIPMENTTYPE, MODIFIEDBYID, MODIFIEDDATE
               FROM		EQUIPMENTTYPE
               WHERE	EQUIPTYPEID = <CFQUERYPARAM value="#FORM.EQUIPMENTTYPEID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	EQUIPMENTTYPE
          </CFQUERY>

     	<CFIF REPORTTITLE2 EQ "">
			<CFSET REPORTTITLE2 = "EQUIPMENT TYPE - #LookupEquipmentTypes.EQUIPMENTTYPE#">
          <CFELSE>
          	<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and EQUIPMENT TYPE - #LookupEquipmentTypes.EQUIPMENTTYPE#">
          </CFIF>
     </CFIF>
     
     <CFIF #FORM.BUILDINGNAMEID# GT 0>
          <CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
               SELECT	BUILDINGNAMEID, BUILDINGNAME
               FROM		BUILDINGNAMES
               WHERE	BUILDINGNAMEID = <CFQUERYPARAM value="#FORM.BUILDINGNAMEID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	BUILDINGNAME
          </CFQUERY>

     	<CFIF REPORTTITLE2 EQ "">
			<CFSET REPORTTITLE2 = "BUILDING NAME - #LookupBuildings.BUILDINGNAME#">
          <CFELSE>
          	<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and BUILDING NAME - #LookupBuildings.BUILDINGNAME#">
          </CFIF>
     </CFIF>
    
	<CFIF #FORM.LOCATIONID# GT 0 OR #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			<!--- ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<BR><BR> --->
		</CFIF>
		<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
          <CFIF #FORM.LOCATIONID# GT 0>
          	WHERE	LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		<CFELSEIF ROOMLIST EQ "YES">
			WHERE	ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE> 
			WHERE	ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>

		<CFIF #ListRoomNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnonpublichwreport.cfm?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
          
          <CFIF REPORTTITLE2 EQ "">    
			<CFIF NOT #FORM.ROOMNUMBER# EQ '' AND FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
                    <CFSET REPORTTITLE2 = "ROOM NUMBER - #ValueList(ListRoomNumbers.ROOMNUMBER)#">
               <CFELSE>
                    <CFSET REPORTTITLE2 = "ROOM NUMBER - #ListRoomNumbers.ROOMNUMBER#">
               </CFIF>
          <CFELSE>
          	<CFIF NOT #FORM.ROOMNUMBER# EQ '' AND FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
                    <CFSET REPORTTITLE2 = #REPORTTITLE2# & " and ROOM NUMBER - #ValueList(ListRoomNumbers.ROOMNUMBER)#">
               <CFELSE>
                    <CFSET REPORTTITLE2 = #REPORTTITLE2# & " and ROOM NUMBER - #ListRoomNumbers.ROOMNUMBER#">
               </CFIF>
          </CFIF>	
          
	<CFELSE>
		<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>
     
     <CFIF #FORM.CATID# GT 0 OR #FORM.CUSTOMERCATEGORY# NEQ "">
		<CFSET CUSTOMERCATEGORYLIST = "NO">
		<CFIF FIND(',', #FORM.CUSTOMERCATEGORY#, 1) NEQ 0>
			<CFSET CUSTOMERCATEGORYLIST = "YES">
			<CFSET FORM.CUSTOMERCATEGORY = UCASE(#FORM.CUSTOMERCATEGORY#)>
			<CFSET FORM.CUSTOMERCATEGORY = ListQualify(FORM.CUSTOMERCATEGORY,"'",",","CHAR")>
               <CFIF REPORTTITLE2 EQ "">
				<CFSET REPORTTITLE2 = "CATEGORY - " & REPLACE(#FORM.CUSTOMERCATEGORY#, "'", "","All")>
               <CFELSE>
               	<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and CATEGORY - " & REPLACE(#FORM.CUSTOMERCATEGORY#, "'", "","All")>
               </CFIF>
          </CFIF>
 
		<CFQUERY name="LookupCustomerCategory" datasource="#application.type#LIBSHAREDDATA" blockfactor="15">
			SELECT	CATEGORYID, CATEGORYNAME
			FROM		CATEGORIES      
		<CFIF #FORM.CATID# GT 0>
          	WHERE	CATEGORYID = <CFQUERYPARAM value="#FORM.CATID#" cfsqltype="CF_SQL_NUMERIC"> 
		<CFELSEIF #CUSTOMERCATEGORYLIST# EQ "YES">
			WHERE	CATEGORYNAME IN (#PreserveSingleQuotes(FORM.CUSTOMERCATEGORY)#)
		<CFELSE>
			WHERE	CATEGORYNAME LIKE (UPPER('%#FORM.CUSTOMERCATEGORY#%'))
		</CFIF>
			ORDER BY	CATEGORYNAME
		</CFQUERY>
          
		<CFIF #LookupCustomerCategory.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Entered Customer Categories were NOT found.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnonpublichwreport.cfm?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
          
          <CFIF #CUSTOMERCATEGORYLIST# EQ "NO">
          	<CFIF REPORTTITLE2 EQ "">
          		<CFSET REPORTTITLE2 = "CATEGORY - #LookupCustomerCategory.CATEGORYNAME#">
               <CFELSE>
               	<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and CATEGORY - " & #LookupCustomerCategory.CATEGORYNAME#>
               </CFIF>
          </CFIF>
          
		<CFQUERY name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX,
					FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE,
					CONTACTBY, SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE
			FROM		CUSTOMERS
			WHERE	CATEGORYID IN (#ValueList(LookupCustomerCategory.CATEGORYID)#)
			ORDER BY	FULLNAME
		</CFQUERY>
          
		<CFIF #ListCustomers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Customers were NOT found in the selected Customer Categories.");
				--> 
			</SCRIPT>
			<CFSET session.ENDPGM = "YES">
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnonpublichwreport.cfm?PROCESS=#PROCESS#" />
			<CFEXIT>
		</CFIF>
	</CFIF>
     
     <CFIF #FORM.CUSTOMERID# GT 0>
     
     	<CFQUERY name="LookupCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	CUSTOMERID, LASTNAME, FIRSTNAME, INITIALS, CATEGORYID, EMAIL, CAMPUSPHONE, SECONDCAMPUSPHONE, CELLPHONE, FAX,
					FULLNAME, DIALINGCAPABILITY, LONGDISTAUTHCODE, NUMBERLISTED, UNITID, LOCATIONID, UNITHEAD, DEPTCHAIR, ALLOWEDTOAPPROVE,
					CONTACTBY, SECURITYLEVELID, PASSWORD, BIBLIOGRAPHER, COMMENTS, AA_COMMENTS, MODIFIEDBYID, MODIFIEDDATE, ACTIVE
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#FORM.CUSTOMERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>
          
          <CFIF REPORTTITLE2 EQ "">
          	<CFSET REPORTTITLE2 = "CUSTOMER NAME - #LookupCustomers.FULLNAME#">
          <CFELSE>
			<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and CUSTOMER NAME - #LookupCustomers.FULLNAME#">
          </CFIF>
     
     <CFELSEIF #FORM.CUSTOMERFIRSTNAME# NEQ "">
     	<CFIF REPORTTITLE2 EQ "">
     		<CFSET REPORTTITLE2 = "CUSTOMER FIRST NAME - #FORM.CUSTOMERFIRSTNAME#">
     	<CFELSE>
			<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and CUSTOMER FIRST NAME - #FORM.CUSTOMERFIRSTNAME#">
          </CFIF>
     <CFELSEIF #FORM.CUSTOMERLASTNAME# NEQ "">
     	<CFIF REPORTTITLE2 EQ "">
     		<CFSET REPORTTITLE2 = "CUSTOMER LAST NAME - #FORM.CUSTOMERLASTNAME#">
          <CFELSE>
			<CFSET REPORTTITLE2 = #REPORTTITLE2# & " and CUSTOMER LAST NAME - #FORM.CUSTOMERLASTNAME#">
          </CFIF>
     </CFIF>
     
     <CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>

		<CFQUERY name="ListCustUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
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
          
          <CFSET SESSION.UNITNAME = #ValueList(ListCustUnits.UNITNAME)#>
		<CFSET SESSION.QUOTEDUNITNAME = REPLACE("#SESSION.UNITNAME#",",","','","All")>
          <CFSET SESSION.QUOTEDUNITNAME = #INSERT("'", #SESSION.QUOTEDUNITNAME#, 0)#>
          <CFSET SESSION.QUOTEDUNITNAME = #INSERT("'", #SESSION.QUOTEDUNITNAME#, #LEN(SESSION.QUOTEDUNITNAME)#)#>
          
          <CFQUERY name="ListUnitNames" datasource="#application.type#LIBSHAREDDATA" blockfactor="59">
               SELECT	UNIQUE UNITNAME
               FROM		UNITS
               WHERE	UNITNAME IN (#PreserveSingleQuotes(SESSION.QUOTEDUNITNAME)#)
               ORDER BY	UNITNAME
          </CFQUERY>
      
      	<CFIF REPORTTITLE2 EQ "">
			<CFIF NOT #FORM.UNITNUMBER# EQ '' AND FIND(',', #FORM.UNITNUMBER#, 1) NEQ 0>
                    <CFSET REPORTTITLE2 = "UNIT - " & #ValueList(ListUnitNames.UNITNAME)#>
               <CFELSE>
                    <CFSET REPORTTITLE2 = "UNIT - #ListCustUnits.UNITNAME#">
               </CFIF>
          <CFELSE>
          	<CFIF NOT #FORM.UNITNUMBER# EQ '' AND FIND(',', #FORM.UNITNUMBER#, 1) NEQ 0>
                    <CFSET REPORTTITLE2 = #REPORTTITLE2# & " and UNIT - " & #ValueList(ListUnitNames.UNITNAME)#>
               <CFELSE>
                    <CFSET REPORTTITLE2 = #REPORTTITLE2# & " and UNIT - #ListCustUnits.UNITNAME#">
               </CFIF>
		</CFIF>
	</CFIF>
 
 	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

     <CFIF #FORM.FISCALYEARID# GT 0 OR #FORM.SRCOMPLETED# NEQ "Select an Option" >

          <CFQUERY name="LookupServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
               SELECT	SR.SRID, SR.SERVICEREQUESTNUMBER, SR.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SR.SRCOMPLETED, SRELU.EQUIPMENTBARCODE, 
               		HI.BARCODENUMBER, HI.HARDWAREID
               FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.FISCALYEARS FY, SREQUIPLOOKUP SRELU, HARDWMGR.HARDWAREINVENTORY HI
               WHERE	(SR.SRID > 0 AND
               		SR.FISCALYEARID = FY.FISCALYEARID AND
                         SR.SERVICEREQUESTNUMBER = SRELU.SERVICEREQUESTNUMBER AND
                         SRELU.EQUIPMENTBARCODE = HI.BARCODENUMBER) AND (
                         
                    <CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
                         NOT SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
                    <CFELSE>
                         SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
                    </CFIF>
                    
                    <CFIF IsDefined('FORM.SRCOMPLETED') AND NOT #FORM.SRCOMPLETED# EQ "Select an Option">
                         SR.SRCOMPLETED = <CFQUERYPARAM value="#FORM.SRCOMPLETED#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
                    </CFIF>
                                   
                         SR.SRID #FINALTEST# 0)
                         ORDER BY	SR.SERVICEREQUESTNUMBER DESC
          </CFQUERY>
          
          <CFIF #FORM.FISCALYEARID# GT 0>
          
          	<CFIF REPORTTITLE2 EQ "">
               	<CFSET REPORTTITLE2 = #REPORTTITLE2# & "  FISCAL YEAR - #LookupServiceRequests.FISCALYEAR_4DIGIT#">
          	<CFELSE>
          		<CFSET REPORTTITLE2 = #REPORTTITLE2# & "  and FISCAL YEAR - #LookupServiceRequests.FISCALYEAR_4DIGIT#">
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.SRCOMPLETED# NEQ "Select an Option">
          
          	<CFSET REPORTTITLE2 = #REPORTTITLE2# & "  and SR COMPLETED - #FORM.SRCOMPLETED#">
               
          </CFIF>
          
          

	</CFIF>
          
	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CREATIONDATE, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.DIVISIONNUMBER, HI.EQUIPMENTLOCATIONID,
          		LOC.ROOMNUMBER, LOC.BUILDINGNAMEID, LOC.LOCATIONNAME, HI.EQUIPMENTTYPEID, HI.CUSTOMERID, CUST.CUSTOMERID,
                    CUST.LASTNAME, CUST.FIRSTNAME, CUST.FULLNAME, CUST.CATEGORYID, CAT.CATEGORYNAME, CUST.UNITID, U.UNITNAME,
                    SRELU.SERVICEREQUESTNUMBER, SRELU.EQUIPMENTBARCODE 
		FROM		HARDWAREINVENTORY HI, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CATEGORIES CAT,
          		LIBSHAREDDATAMGR.UNITS U, SRMGR.SREQUIPLOOKUP SRELU
		WHERE	((HI.HARDWAREID > 0 AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
                    CUST.CATEGORYID = CAT.CATEGORYID AND
				CUST.UNITID = U.UNITID AND
                    HI.BARCODENUMBER = SRELU.EQUIPMENTBARCODE) AND (
		<CFIF #FORM.BARCODENUMBER# NEQ "3065000" AND #FORM.BARCODENUMBER# NEQ "">
               <CFIF IsDefined("FORM.NEGATEBARCODENUMBER")>
                    NOT HI.BARCODENUMBER LIKE '%#FORM.BARCODENUMBER#%' #LOGICANDOR#
               <CFELSE>
                    HI.BARCODENUMBER LIKE '%#FORM.BARCODENUMBER#%' #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.EQUIPMENTTYPEID# GT 0>
               <CFIF IsDefined("FORM.NEGATEEQUIPMENTTYPEID")>
                    NOT (HI.EQUIPMENTTYPEID = #val(FORM.EQUIPMENTTYPEID)#) #LOGICANDOR#
               <CFELSE>
                    HI.EQUIPMENTTYPEID = #val(FORM.EQUIPMENTTYPEID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.BUILDINGNAMEID# GT 0>
               <CFIF IsDefined("FORM.NEGATEBUILDING")>
                    NOT (LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)#) #LOGICANDOR#
               <CFELSE>
                    LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.LOCATIONID# GT 0>
               <CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
                    NOT HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
               <CFELSE>
                    HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.ROOMNUMBER# NEQ "">
               <CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
                    NOT HI.EQUIPMENTLOCATIONID IN (#ValueList(ListRoomNumbers.LOCATIONID)#) #LOGICANDOR#
               <CFELSE>
                    HI.EQUIPMENTLOCATIONID IN (#ValueList(ListRoomNumbers.LOCATIONID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.CATID# GT 0 OR #FORM.CUSTOMERCATEGORY# NEQ "">
               <CFIF IsDefined("FORM.NEGATECUSTOMERCATEGORY")>
                    NOT HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
               <CFELSE>
                    HI.CUSTOMERID IN (#ValueList(ListCustomers.CUSTOMERID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.CUSTOMERID# GT 0>
               <CFIF IsDefined("FORM.NEGATECUSTOMERID")>
                    NOT HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
               <CFELSE>
                    HI.CUSTOMERID = #val(FORM.CUSTOMERID)# #LOGICANDOR#
               </CFIF>
          <CFELSEIF #FORM.CUSTOMERFIRSTNAME# NEQ "">
               <CFIF IsDefined("FORM.NEGATECUSTOMERFIRSTNAME")>
                    NOT CUST.FIRSTNAME LIKE UPPER('%#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
               <CFELSE>
                    CUST.FIRSTNAME LIKE UPPER('%#FORM.CUSTOMERFIRSTNAME#%') #LOGICANDOR#
               </CFIF>
          <CFELSEIF #FORM.CUSTOMERLASTNAME# NEQ "">
               <CFIF IsDefined("FORM.NEGATECUSTOMERLASTNAME")>
                    NOT CUST.LASTNAME LIKE UPPER('%#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
               <CFELSE>
                    CUST.LASTNAME LIKE UPPER('%#FORM.CUSTOMERLASTNAME#%') #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>
               <CFIF IsDefined("FORM.NEGATEUNITID")>
                    NOT HI.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
               <CFELSE>
                    HI.CUSTOMERID IN (#ValueList(ListCustUnits.CUSTOMERID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.FISCALYEARID# GT 0 OR #FORM.SRCOMPLETED# NEQ "Select an Option" > 
          	<CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
                    NOT HI.HARDWAREID IN (#ValueList(LookupServiceRequests.HARDWAREID)#) #LOGICANDOR#
               <CFELSE>
                    HI.HARDWAREID IN (#ValueList(LookupServiceRequests.HARDWAREID)#) #LOGICANDOR#
               </CFIF>
          </CFIF>    
				HI.MODIFIEDBYID #FINALTEST# 0))
                    
     <CFIF #FORM.CATID# GT 0 OR #FORM.CUSTOMERCATEGORY# NEQ "">
     	ORDER BY	CAT.CATEGORYNAME, SRELU.SERVICEREQUESTNUMBER DESC
     <CFELSEIF #FORM.UNITID# GT 0 OR NOT #FORM.UNITNUMBER# EQ ''>
     	ORDER BY	U.UNITNAME, SRELU.SERVICEREQUESTNUMBER DESC
     <CFELSE>
		ORDER BY	SRELU.SERVICEREQUESTNUMBER DESC
     </CFIF>
	</CFQUERY>

	<CFIF #LookupHardware.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Hardware Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<CFSET session.ENDPGM = "YES">
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnonpublichwreport.cfm" />
		<CFEXIT>
	</CFIF>
     
     <CFIF #LookupHardware.RecordCount# GT 1000>
		<SCRIPT language="JavaScript">
               <!-- 
                    alert("More than 1000 Records meeting the selected criteria were found.  The created URL is too long for the server to run the report.");
               --> 
          </SCRIPT>
          <META http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/srnonpublichwreport.cfm" />
          <CFEXIT>
     </CFIF>	
     
     <CFSET SESSION.LOOKUPBARCODE = #ValueList(LookupHardware.BARCODENUMBER)#>
     <CFSET SESSION.QUOTEDLOOKUPBARCODE = REPLACE("#SESSION.LOOKUPBARCODE#",",","','","All")>
     <CFSET SESSION.QUOTEDLOOKUPBARCODE = #INSERT("'", #SESSION.QUOTEDLOOKUPBARCODE#, 0)#>
     <CFSET SESSION.QUOTEDLOOKUPBARCODE = #INSERT("'", #SESSION.QUOTEDLOOKUPBARCODE#, #LEN(SESSION.QUOTEDLOOKUPBARCODE)#)#>
      
     <CFQUERY name="LookupSREquipCount" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SRELU.SREQUIPID, SRELU.SERVICEREQUESTNUMBER, SRELU.EQUIPMENTBARCODE, SR.FISCALYEARID, SR.SRCOMPLETED
          FROM		SREQUIPLOOKUP SRELU, SERVICEREQUESTS SR
          WHERE	SRELU.SERVICEREQUESTNUMBER = SR.SERVICEREQUESTNUMBER AND
          		EQUIPMENTBARCODE IN (#PreserveSingleQuotes(SESSION.QUOTEDLOOKUPBARCODE)#) AND
          
			<CFIF IsDefined('FORM.NEGATEFISCALYEARID')>
                    NOT SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               <CFELSE>
                    SR.FISCALYEARID = <CFQUERYPARAM value="#FORM.FISCALYEARID#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               </CFIF>
               
               <CFIF IsDefined('FORM.SRCOMPLETED') AND NOT #FORM.SRCOMPLETED# EQ "Select an Option">
                    SR.SRCOMPLETED = <CFQUERYPARAM value="#FORM.SRCOMPLETED#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
               </CFIF>
          
          		SREQUIPID > 0
     </CFQUERY>
     
</CFIF>


<!--- 
**************************************************************************************
* The following code displays the IDT Service Requests - Non-Public Hardware Report. *
**************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPBARCODE')>
	<CFEXIT>
<CFELSE>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
               	<H1>Non-Public Hardware / SR Report</H1>
               <CFIF #REPORTTITLE2# NEQ "">
               	<H3><FONT color="BLACK">#REPORTTITLE2#</FONT></H3>
               </CFIF>
               </TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srnonpublichwreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4">#LookupSREquipCount.RecordCount# Service Request records were selected.<BR /><BR /></TH>
		</TR>
          <TR>
			<TD colspan="5"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>

<CFLOOP query="LookupHardware">
     
     <CFQUERY name="LookupSREquip" datasource="#application.type#SERVICEREQUESTS">
          SELECT	SREQUIPID, SERVICEREQUESTNUMBER, EQUIPMENTBARCODE
          FROM		SREQUIPLOOKUP
          WHERE	SERVICEREQUESTNUMBER = <CFQUERYPARAM value="#LookupHardware.SERVICEREQUESTNUMBER#" cfsqltype="CF_SQL_VARCHAR">
          ORDER BY	SERVICEREQUESTNUMBER DESC
     </CFQUERY>
     
     <CFSET SESSION.SRNUMBER = #ValueList(LookupSREquip.SERVICEREQUESTNUMBER)#>
     <CFSET SESSION.QUOTEDSRNUMBER = REPLACE("#SESSION.SRNUMBER#",",","','","All")>
     <CFSET SESSION.QUOTEDSRNUMBER = #INSERT("'", #SESSION.QUOTEDSRNUMBER#, 0)#>
     <CFSET SESSION.QUOTEDSRNUMBER = #INSERT("'", #SESSION.QUOTEDSRNUMBER#, #LEN(SESSION.QUOTEDSRNUMBER)#)#>
     
     <CFQUERY name="DisplayServiceRequests" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		SELECT	SR.SRID, SR.FISCALYEARID, SR.SERVICEREQUESTNUMBER, SR.CREATIONDATE, TO_CHAR(SR.CREATIONDATE, 'MM/DD/YYYY') AS CREATEDATE,
				SR.REQUESTERID, REQCUST.CUSTOMERID, REQCUST.FULLNAME, SR.PROBLEM_DESCRIPTION, SR.SRCOMPLETED
     	FROM		SERVICEREQUESTS SR, LIBSHAREDDATAMGR.CUSTOMERS REQCUST
		WHERE	(SR.SERVICEREQUESTNUMBER IN (#PreserveSingleQuotes(SESSION.QUOTEDSRNUMBER)#) AND
				SR.REQUESTERID = REQCUST.CUSTOMERID) AND
                    
                    <CFIF IsDefined('FORM.SRCOMPLETED') AND NOT #FORM.SRCOMPLETED# EQ "Select an Option">
                         SR.SRCOMPLETED = <CFQUERYPARAM value="#FORM.SRCOMPLETED#" cfsqltype="CF_SQL_VARCHAR"> #LOGICANDOR#
                    </CFIF>
 
                    SR.SRID > 0
          ORDER BY	SR.SERVICEREQUESTNUMBER DESC
     </CFQUERY>

	<CFLOOP query="DisplayServiceRequests">
     
          <CFQUERY name="DisplaySRStaffAssignments" datasource="#application.type#SERVICEREQUESTS">
               SELECT	SRSA.SRSTAFF_ASSIGNID, SRSA.SRID, SRSA.STAFF_ASSIGNEDID, WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, SRSA.NEXT_ASSIGNMENT,
                         SRSA.NEXT_ASSIGNMENT_GROUPID, GA.GROUPNAME, SRSA.NEXT_ASSIGNMENT_REASON, WGA.STAFFCUSTOMERID, CUST.FULLNAME, SRSA.STAFF_DATEASSIGNED,
                         TO_CHAR(SRSA.STAFF_DATEASSIGNED, 'MM/DD/YYYY') AS STAFF_DATE, SRSA.STAFF_TIME_WORKED,
                         SRSA.STAFF_COMMENTS, SRSA.STAFF_COMPLETEDSR, SRSA.STAFF_COMPLETEDDATE, TO_CHAR(SRSA.MODIFIEDDATE, 'MM/DD/YYYY') AS DATE_LAST_MODIFIED
               FROM		SRSTAFFASSIGNMENTS SRSA, WORKGROUPASSIGNS WGA, GROUPASSIGNED GA, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	SRSA.SRSTAFF_ASSIGNID > 0 AND
                         SRSA.SRID = <CFQUERYPARAM value="#DisplayServiceRequests.SRID#" cfsqltype="CF_SQL_NUMERIC"> AND
                         SRSA.STAFF_ASSIGNEDID = WGA.WORKGROUPASSIGNSID AND
                         SRSA.NEXT_ASSIGNMENT_GROUPID = GA.GROUPID AND
                         WGA.STAFFCUSTOMERID = CUST.CUSTOMERID
               ORDER BY	GA.GROUPNAME, CUST.FULLNAME
          </CFQUERY>
     
     

		<TR>
               <TH align="left" valign="BOTTOM"><B>SR</B></TH>
               <TH align="left" valign="BOTTOM">Creation Date</TH>
               <TH align="left" valign="BOTTOM">SR Completed</TH>
               <TH align="left" valign="BOTTOM">Requester</TH>
               <TH align="left" valign="BOTTOM">Staff Assigned</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">#DisplayServiceRequests.SERVICEREQUESTNUMBER#</TD>
               <TD align="left" valign="TOP">#DateFormat(DisplayServiceRequests.CREATIONDATE, "mm/dd/yyyy")#</TD>
               <TD align="left" valign="top"><FONT COLOR="Red"><STRONG>#DisplayServiceRequests.SRCOMPLETED#</STRONG></FONT></TD>
               <TD align="left" valign="TOP">#DisplayServiceRequests.FULLNAME#</TD>
               <TD align="left" valign="top">
               	<CFLOOP query="DisplaySRStaffAssignments">
                    	#DisplaySRStaffAssignments.FULLNAME#<BR>
                    </CFLOOP>
               </TD>
          </TR>
          <TR>
          	<TH align="left" valign="BOTTOM" colspan="5">Problem Description</TH>
          </TR>
          <TR>
          	<TD align="left" valign="TOP" colspan="5">#DisplayServiceRequests.PROBLEM_DESCRIPTION#</TD>
          </TR>
          <TR>
          	<TH align="left" valign="BOTTOM">Current Assignment</TH>
               <TH align="left" valign="BOTTOM">Division Number</TH>
               <TH align="left" valign="BOTTOM">Barcode</TH>
               <TH align="left" valign="BOTTOM">State Found Number</TH>              
               <TH align="left" valign="BOTTOM">Room</TH>
          </TR>
          <TR>
               <TD align="left" valign="TOP">#LookupHardware.FULLNAME#</TD>
               <TD align="left" valign="TOP">#LookupHardware.DIVISIONNUMBER#</TD>
               <TD align="left" valign="TOP">#LookupHardware.BARCODENUMBER#</TD>
               <TD align="left" valign="TOP">#LookupHardware.STATEFOUNDNUMBER#</TD>         
               <TD align="left" valign="TOP">#LookupHardware.ROOMNUMBER#</TD>         
          </TR>
          <TR>
          	<TD align="left" colspan="5"><HR></TD>
          </TR>
	</CFLOOP>
</CFLOOP>
     	<TR>
			<TD colspan="5"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4">#LookupSREquipCount.RecordCount# Service Request records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/srnonpublichwreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="5"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>