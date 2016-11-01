<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: hardwareinventorymmoreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: MMO Reports in IDT Hardware Inventory and Archive --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>MMO Reports in IDT Hardware Inventory and Archive</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if ((document.LOOKUP.REPORTCHOICE[0].checked == "0"      && document.LOOKUP.REPORTCHOICE[1].checked == "0"
		 && document.LOOKUP.REPORTCHOICE[2].checked == "0"       && document.LOOKUP.REPORTCHOICE[3].checked == "0")
		 && (document.LOOKUP.STATEFOUNDNUMBER.value == ""
		 && document.LOOKUP.OWNINGORGID.selectedIndex == "0"     && document.LOOKUP.OWNINGORGCODE.value == ""
		 && document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0"  && document.LOOKUP.BUILDINGNAME.value == ""
		 && document.LOOKUP.LOCATIONID.selectedIndex == "0"      && document.LOOKUP.ROOMNUMBER.value == "")) {
			alertuser ("You must enter information in one of the seven (7) fields!");
			document.LOOKUP.BARCODENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.OWNINGORGID.selectedIndex > "0" && document.LOOKUP.OWNINGORGCODE.value != "") {
			alertuser ("You CAN NOT both select a Owning Org ID from the Drop Down and enter a Owing Org Code in the text box!");
			document.LOOKUP.LOCATIONID.focus();
			return false;
		}

		if (document.LOOKUP.BUILDINGNAMEID.selectedIndex > "0" && document.LOOKUP.BUILDINGNAME.value != "") {
			alertuser ("You CAN NOT both select a Building Name ID from the Drop Down and enter a Building Name in the text box!");
			document.LOOKUP.LOCATIONID.focus();
			return false;
		}

		if (document.LOOKUP.LOCATIONID.selectedIndex > "0" && document.LOOKUP.ROOMNUMBER.value != "") {
			alertuser ("You CAN NOT both select a Room Number from the Drop Down and enter a Room Number in the text box!");
			document.LOOKUP.LOCATIONID.focus();
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
<CFIF NOT IsDefined('URL.LOOKUPMMOINFO')>
	<CFSET CURSORFIELD = "document.LOOKUP.STATEFOUNDNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***********************************************************************************************
* The following code is the Look Up Process for IDT Hardware Inventory / Archive MMO Reports. *
***********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPMMOINFO')>

	<CFQUERY name="ListOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFQUERY name="ListBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
		FROM		BUILDINGNAMES
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>MMO Reports Lookup in IDT Hardware Inventory and Archive</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
				Checking the adjacent checkbox will Negate the data entered.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	
     <FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm?LOOKUPMMOINFO=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATEFOUNDNUMBER">Negate</LABEL><BR />
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="STATEFOUNDNUMBER">State Found Number<BR>
                   	&nbsp;Enter (1) a State Found Number or 
                    <BR>&nbsp;(2) two State Found Numbers separated by a semicolon for range.</LABEL>
			</TH>
			</TH>
			<TH align="LEFT" width="50%" VALIGN="BOTTOM" COLSPAN="2">
               	<LABEL for="OWNINGORGCODESELECT">Select an Owning Org. Code or<BR>
                   	&nbsp;Enter a partial Owning Org. Code in the text box.</LABEL></LABEL>
               </TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" VALIGN="TOP">
				<CFINPUT type="CheckBox" name="NEGATESTATEFOUNDNUMBER" id="NEGATESTATEFOUNDNUMBER" value="" align="LEFT" required="No" tabindex="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%" VALIGN="TOP">
				<CFINPUT type="Text" name="STATEFOUNDNUMBER" id="STATEFOUNDNUMBER" value="" align="LEFT" required="No" size="50" tabindex="3">
			</TD>
			<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
				<CFSELECT name="OWNINGORGID" id="OWNINGORGCODESELECT" size="1" query="ListOrgCodes" value="ORGCODEID" display="ORGCODENAME" required="No" tabindex="4"></CFSELECT><BR />
				<LABEL for="OWNINGORGCODETEXT" class="LABEL_hidden">Enter Owning Org. Code Text</LABEL>
				<CFINPUT type="Text" name="OWNINGORGCODE" id="OWNINGORGCODETEXT" value="" required="No" size="20" maxlength="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2">
               	<LABEL for="BUILDINGCODESELECT">Select a Building Code -- Name from the dropdown</LABEL> or <BR>
                    &nbsp;<LABEL for="BUILDINGCODETEXT">Enter a partial Building Code in the text box.</LABEL>
               </TH>
			<TH align="LEFT" valign="BOTTOM" colspan="2">
               	<LABEL for="ROOMNUMBERSELECT">Select a Room Number from the dropdown</LABEL> or <BR>
                    &nbsp;<LABEL for="ROOMNUMBERTEXT">Enter a partial Room Number in the text box.</LABEL>
               </TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGCODESELECT" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUIDINGCODENAME" selected="0" required="No" tabindex="6"></CFSELECT><BR />
				<LABEL for="BUILDINGCODETEXT" class="LABEL_hidden">Enter Building Code -- Name Text</LABEL>
				<CFINPUT type="Text" name="BUILDINGCODE" id="BUILDINGCODETEXT" value="" required="No" size="7" maxlength="7" tabindex="7">
			</TD>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="LOCATIONID" id="ROOMNUMBERSELECT" size="1" query="ListRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="8"></CFSELECT><BR />
				<LABEL for="ROOMNUMBERTEXT" class="LABEL_hidden">Enter Room Number Text</LABEL>
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBERTEXT" value="" required="No" size="20" maxlength="50" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM" colspan="2"><LABEL for="TABLECHOICE">Select Reporting Table</LABEL></TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR />
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">COMMENTS</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="TABLECHOICE" id="TABLECHOICE" size="1" tabindex="10">
					<OPTION selected value="1">Inventory Table</OPTION>
					<OPTION value="2">Archive Table</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%" VALIGN="TOP">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="11">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%" VALIGN="TOP">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="12">
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH colspan="4"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="4">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="13"><LABEL for="REPORTCHOICE1">MMO Report by State Found Number</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="14"><LABEL for="REPORTCHOICE2">MMO Report by Building Code and Room Number</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="15"><LABEL for="REPORTCHOICE3">MMO Report by Room Number</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="16"><LABEL for="REPORTCHOICE4">MMO Report by Owning Org Code</LABEL><BR />
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="17" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="18" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
	</FIELDSET>

     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="19" /><BR>
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
**********************************************************************************************
* The following code is the IDT Hardware Inventory / Archive MMO Reports Generation Process. *
**********************************************************************************************
 --->

	<CFIF #FORM.TABLECHOICE# EQ 2 >
		<CFSET FORM.TABLENAME = "INVENTORYARCHIVE">
		<CFSET FORM.TABLETITLE = "ARCHIVE">
	<CFELSE>
		<CFSET FORM.TABLENAME = "HARDWAREINVENTORY">
		<CFSET FORM.TABLETITLE = "INVENTORY">
	</CFIF>

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'HI.STATEFOUNDNUMBER'>
	<CFSET SORTORDER[2] = 'BN.BUILDINGCODE~ LOC.ROOMNUMBER'>
	<CFSET SORTORDER[3] = 'LOC.ROOMNUMBER'>
	<CFSET SORTORDER[4] = 'OC.ORGCODE'>

	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	</CFIF>

	<CFSET STATEFOUNDNUMRANGE = "NO">
	<CFIF FIND(';', #FORM.STATEFOUNDNUMBER#, 1) NEQ 0>
          <CFSET STATEFOUNDNUMRANGE = "YES">
          <CFSET FORM.STATEFOUNDNUMBER = #REPLACE(FORM.STATEFOUNDNUMBER, ";", ",")#>
		<CFSET STATEFOUNDNUMBERARRAY = ListToArray(FORM.STATEFOUNDNUMBER)>
<!---           
          <CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(STATEFOUNDNUMBERARRAY)# >
               STATEFOUNDNUMBER FIELD #COUNTER# = #STATEFOUNDNUMBERARRAY[COUNTER]#<BR><BR>
          </CFLOOP>
 --->          
		<CFIF STATEFOUNDNUMRANGE EQ "YES">
			<CFSET BEGINSTATEFOUNDNUMBER = #STATEFOUNDNUMBERARRAY[1]#>
			<CFSET ENDSTATEFOUNDNUMBER = #STATEFOUNDNUMBERARRAY[2]#>
		</CFIF>
         <!---  STATE FOUND NUMBER FIELD = #FORM.STATEFOUNDNUMBER#<BR><BR> --->
     </CFIF>

	<CFIF IsDefined('FORM.OWNINGORGCODE') AND #FORM.OWNINGORGCODE# NEQ "">
		<CFQUERY name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
			SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
			FROM		ORGCODES
			WHERE	ORGCODE LIKE '%#FORM.OWNINGORGCODE#%'
			ORDER BY	ORGCODE
		</CFQUERY>
	</CFIF>

	<CFIF IsDefined('FORM.BUILDINGCODE') AND #FORM.BUILDINGCODE# NEQ "">
		<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
			SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
			FROM		BUILDINGNAMES
			WHERE	BUILDINGCODE LIKE UPPER('%#FORM.BUILDINGCODE#%')
			ORDER BY	BUILDINGNAME
		</CFQUERY>
	</CFIF>

	<CFIF IsDefined('FORM.ROOMNUMBER') AND #FORM.ROOMNUMBER# NEQ "">
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			WHERE	ROOMNUMBER LIKE UPPER('%#FORM.ROOMNUMBER#%')
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupHardware" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.STATEFOUNDNUMBER, HI.SERIALNUMBER, HI.EQUIPMENTLOCATIONID, LOC.ROOMNUMBER, LOC.BUILDINGNAMEID,
				LOC.LOCATIONNAME, BN.BUILDINGCODE, BN.BUILDINGCODE || ' -- ' || BN.BUILDINGNAME AS BUIDINGCODENAME, HI.EQUIPMENTTYPEID, ET.EQUIPMENTTYPE,
				HI.DESCRIPTIONID, ED.EQUIPMENTDESCRIPTION, HI.MANUFACTURERID, VEND.VENDORNAME, HI.PURCHASEORDERNUMBER, HI.DATERECEIVED, HI.COMMENTS,
				HI.OWNINGORGID, OC.ORGCODE, OC.ORGCODEDESCRIPTION
		FROM		#FORM.TABLENAME# HI, FACILITIESMGR.LOCATIONS LOC, FACILITIESMGR.BUILDINGNAMES BN, EQUIPMENTTYPE ET, EQUIPMENTDESCRIPTION ED, 
				PURCHASEMGR.VENDORS VEND, LIBSHAREDDATAMGR.ORGCODES OC
		WHERE	((HI.HARDWAREID > 0 AND
				(NOT HI.STATEFOUNDNUMBER IS NULL AND
				NOT HI.STATEFOUNDNUMBER = ' ') AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				HI.EQUIPMENTTYPEID = ET.EQUIPTYPEID AND
				HI.DESCRIPTIONID = ED.EQUIPDESCRID AND
				HI.MANUFACTURERID = VEND.VENDORID AND
				HI.OWNINGORGID = OC.ORGCODEID) AND (

			<CFIF #FORM.STATEFOUNDNUMBER# NEQ "">    
				<CFIF IsDefined("FORM.NEGATESTATEFOUNDNUMBER")>
                    	<CFIF STATEFOUNDNUMRANGE EQ "YES">
                         	NOT (HI.STATEFOUNDNUMBER BETWEEN '#BEGINSTATEFOUNDNUMBER#' AND '#ENDSTATEFOUNDNUMBER#') #LOGICANDOR#
                         <CFELSE>
						NOT HI.STATEFOUNDNUMBER LIKE UPPER('%#FORM.STATEFOUNDNUMBER#%') #LOGICANDOR#
                         </CFIF>
				<CFELSE>
                    	<CFIF STATEFOUNDNUMRANGE EQ "YES">
                         	HI.STATEFOUNDNUMBER BETWEEN '#BEGINSTATEFOUNDNUMBER#' AND '#ENDSTATEFOUNDNUMBER#' #LOGICANDOR#
                         <CFELSE>
						HI.STATEFOUNDNUMBER LIKE '%#FORM.STATEFOUNDNUMBER#%' #LOGICANDOR#
                         </CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.OWNINGORGID# GT 0>
				HI.OWNINGORGID = #val(FORM.OWNINGORGID)# #LOGICANDOR#
			</CFIF>

			<CFIF IsDefined('FORM.OWNINGORGCODE') AND #FORM.OWNINGORGCODE# NEQ "">
				HI.OWNINGORGID IN (#ValueList(LookupOrgCodes.ORGCODEID)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.BUILDINGNAMEID# GT 0>
				LOC.BUILDINGNAMEID = #val(FORM.BUILDINGNAMEID)# #LOGICANDOR#
			</CFIF>

			<CFIF IsDefined('FORM.BUILDINGCODE') AND #FORM.BUILDINGCODE# NEQ "">
				LOC.BUILDINGNAMEID IN (#ValueList(LookupBuildings.BUILDINGNAMEID)#) #LOGICANDOR#
			</CFIF>

			<CFIF #FORM.LOCATIONID# GT 0>
				HI.EQUIPMENTLOCATIONID = #val(FORM.LOCATIONID)# #LOGICANDOR#
			</CFIF>

			<CFIF IsDefined('FORM.ROOMNUMBER') AND #FORM.ROOMNUMBER# NEQ "">
				HI.EQUIPMENTLOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
			</CFIF>
               
               <CFIF #FORM.COMMENTS# NEQ "">
				<CFIF IsDefined("FORM.NEGATECOMMENTS")>
					NOT HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				<CFELSE>
					HI.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
				</CFIF>
			</CFIF>

				HI.MODIFIEDBYID #FINALTEST# 0))
		ORDER BY	#REPORTORDER#
	</CFQUERY>

	<CFIF #LookupHardware.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Hardware Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm" />
		<CFEXIT>
	<!--- <CFELSEIF #LookupHardware.RecordCount# GT 1000>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("More than 0ne Thousand Records have been selected meeting your criteria.  Please resubmit with more specific criteria.");
			--> 
		
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm" />
		<CFEXIT> --->
	</CFIF>

<!--- 
*********************************************************************************
* The following code displays the IDT Hardware Inventory / Archive MMO Reports. *
*********************************************************************************
 --->


	<CFSET CLIENT.REPORTTITLE = ''>
	<CFSET REPORTGROUPHEADER = "">
	<CFSET CLIENT.PURCHREQRECORDCOUNT = 0>

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;MMO Report by State Found Number'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;MMO Report by Building Code and Room Number'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;MMO Report by Room Number'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET CLIENT.REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;MMO Report by Owning Org Code'>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>#FORM.TABLETITLE# MMO Reports</H1>
				<H2>#CLIENT.REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="10">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>

		<TR>
	<CFIF #FORM.REPORTCHOICE# NEQ 2>
		<CFIF #FORM.REPORTCHOICE# EQ 4>
			<TH align="CENTER">Owning Org. Code</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<TH align="left">Room Number</TH>
		</CFIF>
			<TH align="CENTER">State Found Number</TH>
			<TH align="CENTER">Equipment Type - Description</TH>
			<TH align="left">Manufacturer</TH>
			<TH align="left">Serial Number</TH>
		<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 4>
			<TH align="CENTER">Room Number</TH>
		</CFIF>
			<TH align="CENTER">Receiving Date</TH>
			<TH align="left">Purchase Order</TH>
		<CFIF #FORM.REPORTCHOICE# LT 4>
			<TH align="left">Owning Org. Code</TH>
		</CFIF>
	</CFIF>
		</TR>

<CFLOOP query="LookupHardware">

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFIF REPORTGROUPHEADER NEQ #LookupHardware.BUIDINGCODENAME#>
			<CFSET REPORTGROUPHEADER = #LookupHardware.BUIDINGCODENAME#>
		<TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="left" nowrap><H2>#REPORTGROUPHEADER#</H2></TH>
		</TR>
		<TR>
			<TH align="left">Room Number</TH>
			<TH align="CENTER">State Found Number</TH>
			<TH align="CENTER">Equipment Type - Description</TH>
			<TH align="left">Manufacturer</TH>
			<TH align="left">Serial Number</TH>
			<TH align="CENTER">Receiving Date</TH>
			<TH align="left">Purchase Order</TH>
			<TH align="CENTER">Owning Org. Code</TH>
		</TR>
		<TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		</CFIF>
	</CFIF>

	<CFQUERY name="LookupOrgCodes" datasource="#application.type#LIBSHAREDDATA" blockfactor="17">
		SELECT	ORGCODEID, ORGCODE, ORGCODEDESCRIPTION, ORGCODE || ' - ' || ORGCODEDESCRIPTION AS ORGCODENAME
		FROM		ORGCODES
		WHERE	ORGCODEID = <CFQUERYPARAM value="#LookupHardware.OWNINGORGID#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	ORGCODE
	</CFQUERY>

	<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
		FROM		BUILDINGNAMES
		WHERE	BUILDINGCODE = <CFQUERYPARAM value="#LookupHardware.BUILDINGCODE#" cfsqltype="CF_SQL_VARCHAR">
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		WHERE	LOCATIONID = <CFQUERYPARAM value="#LookupHardware.EQUIPMENTLOCATIONID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="LookupManufacturers" datasource="#application.type#PURCHASING">
		SELECT	VENDORID, VENDORNAME
		FROM		VENDORS
		WHERE	VENDORID = <CFQUERYPARAM value="#LookupHardware.MANUFACTURERID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	VENDORNAME
	</CFQUERY>

		<TR>
	<CFIF #FORM.REPORTCHOICE# EQ 4>
			<TD align="left"><DIV>#LookupOrgCodes.ORGCODENAME#</DIV></TD>
	</CFIF>
	<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 3>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardware.ROOMNUMBER#</DIV></TD>
	</CFIF>
			<TD align="left" valign="TOP" ><DIV>#LookupHardware.STATEFOUNDNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardware.EQUIPMENTTYPE# - #LookupHardware.EQUIPMENTDESCRIPTION#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardware.VENDORNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupHardware.SERIALNUMBER#</DIV></TD>
	<CFIF #FORM.REPORTCHOICE# EQ 1 OR #FORM.REPORTCHOICE# EQ 4>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardware.ROOMNUMBER#</DIV></TD>
	</CFIF>
			<TD align="left" valign="TOP" nowrap><DIV>#DateFormat(LookupHardware.DATERECEIVED, "MM/DD/YYYY")#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#LookupHardware.PURCHASEORDERNUMBER#</DIV></TD>
	<CFIF #FORM.REPORTCHOICE# LT 4>
			<TD align="left"><DIV>#LookupOrgCodes.ORGCODENAME#</DIV></TD>
	</CFIF>
		</TR>
          <TR>
			<TH align="left">Comments: &nbsp;&nbsp;</TH>
               <TD  align="left" colspan="7">#LookupHardware.COMMENTS#</TD>
		</TR>
		<TR>
			<TD colspan="8"><HR /></TD>
		</TR>
</CFLOOP>
		<TR>
			<TD colspan="8"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="8">#LookupHardware.RecordCount# hardware records were selected.<BR /><BR /></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/hardwareinventorymmoreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="8"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>