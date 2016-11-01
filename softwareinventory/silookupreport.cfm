<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: silookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: IDT Software Inventory - Inventory Lookup Report --->
<!-- Last modified by John R. Pastori on 07/16/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/silookupreport.cfm">
<CFSET CONTENT_UPDATED = "July 16, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Inventory Lookup Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateLookupFields() {
		if ((!document.LOOKUP.REQNUMBER2.value == "") && (document.LOOKUP.REQLINENUMBER.value == ""
		  || document.LOOKUP.REQLINENUMBER.value == "")) {
			alertuser (document.LOOKUP.REQLINENUMBER.name +  ",  You must enter a Requistion Line Number when you enter a Requisition number.");
			document.LOOKUP.REQLINENUMBER.focus();
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
<CFIF NOT IsDefined('URL.LOOKUPSOFTWAREINVENTORY')>
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************************************
* The following code is the Look Up Process for IDT Software Inventory - Inventory Lookup Report. *
***************************************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPSOFTWAREINVENTORY")>

	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	UNIQUE PR.REQNUMBER, PR.PURCHREQID
		FROM		PURCHREQS PR
		ORDER BY	PR.REQNUMBER
	</CFQUERY>

	<CFQUERY name="LookupSoftwareInventoryPurchReqLines" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, PRL.PURCHREQLINEID, PR.PURCHREQID, PR.REQNUMBER, PRL.LINENUMBER, SI.FISCALYEARID, SI.RECVDDATE,
				SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID,
				SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID, SI.MODIFIEDBYID,
				SI.MODIFIEDDATE, PR.REQNUMBER || '-' || PRL.LINENUMBER || ' - ' || SUBSTR(SI.TITLE,1,25) AS LOOKUPKEY
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.REQNUMBER
		FROM		PURCHREQS PR
		WHERE	(PR.PURCHREQID IN (#ValueList(LookupSoftwareInventoryPurchReqLines.PURCHREQID)#)) AND
				(PR.PURCHREQID = 0 OR
				NOT PR.REQNUMBER < '0')
		ORDER BY	PR.REQNUMBER
	</CFQUERY>

	<CFQUERY name="LookupPurchReqPOs" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PR.PURCHREQID, PR.PONUMBER
		FROM		PURCHREQS PR
		WHERE	(PR.PURCHREQID IN (#ValueList(LookupSoftwareInventoryPurchReqLines.PURCHREQID)#)) AND
				(PR.PURCHREQID = 0 OR
				NOT PR.PONUMBER < '0')
		ORDER BY	PR.PONUMBER
	</CFQUERY>

	<CFQUERY name="ListSoftwareFiscalYear" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
		SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
		FROM		FISCALYEARS
		ORDER BY	FISCALYEARID
	</CFQUERY>

	<CFQUERY name="ListStatuses" datasource="#application.type#SOFTWARE" blockfactor="15">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 900 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Software Inventory - Inventory Lookup Report</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center">
				<H2>Select from the dropdown fields or type in values to choose report criteria. <BR />
				Checking an adjacent checkbox will Negate the selection or data entered.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     <FIELDSET>
	<LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/softwareinventory/silookupreport.cfm?LOOKUPSOFTWAREINVENTORY=FOUND" method="POST">
	<TABLE width="100%" align="LEFT" >
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHREQID1">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHREQID1">(1) Select a Requisition Number</LABEL> or <BR />
				<LABEL for="REQNUMBER1">(2) Type Requisition Number.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESOFTWINVENTID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="SOFTWINVENTID">(1) Select a Requisition Number-Requisition Line Number - Title</LABEL> or <BR />
				<LABEL for="REQNUMBER2">(2) Type Requisition Number</LABEL>-
				<LABEL for="REQLINENUMBER">Requisition Line Number.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHREQID1" id="NEGATEPURCHREQID1" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" query="LookupPurchReqs" value="PURCHREQID" selected="0" display="REQNUMBER" required="No" tabindex="3"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQNUMBER1" id="REQNUMBER1" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="4">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESOFTWINVENTID" id="NEGATESOFTWINVENTID" value="" align="LEFT" required="No" tabindex="5">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryPurchReqLines" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="6"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQNUMBER2" id="REQNUMBER2" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="7">-
				<CFINPUT type="Text" name="REQLINENUMBER" id="REQLINENUMBER" value="" align="LEFT" required="No" size="2" maxlength="6" tabindex="8">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHREQID2">Negate </LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHREQID2">(1) Select a PO Number</LABEL> or<BR />
				<LABEL for="PONUMBER">(2) Type PO Number.</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATUSID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="STATUSID">Status</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHREQID2" id="NEGATEPURCHREQID2" value="" align="LEFT" required="No" tabindex="9">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" query="LookupPurchReqPOs" value="PURCHREQID" selected="0" display="PONUMBER" required="No" tabindex="10"></CFSELECT><BR />
				<CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="11">
			</TD>
			<TD align="left" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATUSID" id="NEGATESTATUSID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatuses" value="STATUSID" selected="0" display="STATUSNAME" required="No" tabindex="13"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECREATIONDATE">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CREATIONDATE">(1) Type a single Creation Date or (2) a series of dates separated by commas,NO spaces or<BR />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEFISCALYEARID">Negate</LABEL><BR />
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="FISCALYEARID">Fiscal Year</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECREATIONDATE" id="NEGATECREATIONDATE" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="left" width="45%">
				<CFINPUT type="Text" name="CREATIONDATE" id="CREATIONDATE" value="" required="No" size="50" tabindex="15">
			</TD>
			<TD align="left" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEFISCALYEARID" id="NEGATEFISCALYEARID" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="left" width="45%">
				<CFSELECT name="FISCALYEARID" id="FISCALYEARID" query="ListSoftwareFiscalYear" value="FISCALYEARID" display="FISCALYEAR_4DIGIT" selected="0" tabindex="17"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
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
				<LABEL for="MODIFIEDDATE">(1) Type a single Date Modified or (2) a series of dates separated by commas,NO spaces or<BR />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="19">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="20">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="21">
			</TD>
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
			<TH align="LEFT" colspan="4"><H2>Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="22" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="23" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="24" /><BR />
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
*************************************************************************
* The following code is the Inventory Lookup Report Generation Process. *
*************************************************************************
 --->

	<CFIF "#FORM.CREATIONDATE#" NEQ ''>
		<CFSET CREATIONDATELIST = "NO">
		<CFSET CREATIONDATERANGE = "NO">
		<CFIF FIND(',', #FORM.CREATIONDATE#, 1) EQ 0 AND FIND(';', #FORM.CREATIONDATE#, 1) EQ 0>
			<CFSET FORM.CREATIONDATE = DateFormat(FORM.CREATIONDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.CREATIONDATE#, 1) NEQ 0>
				<CFSET CREATIONDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.CREATIONDATE#, 1) NEQ 0>
				<CFSET CREATIONDATERANGE = "YES">
				<CFSET FORM.CREATIONDATE = #REPLACE(FORM.CREATIONDATE, ";", ",")#>
			</CFIF>
			<CFSET CREATIONDATEARRAY = ListToArray(FORM.CREATIONDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)# >
				<!--- CREATIONDATE FIELD #Counter# = #CREATIONDATEARRAY[COUNTER]#<BR><BR> --->
			</CFLOOP>
		</CFIF>
		<CFIF CREATIONDATERANGE EQ "YES">
			<CFSET BEGINCREATIONDATE = DateFormat(#CREATIONDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDCREATIONDATE = DateFormat(#CREATIONDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- CREATIONDATELIST = #CREATIONDATELIST#<BR><BR> --->
		<!--- CREATIONDATERANGE = #CREATIONDATERANGE#<BR><BR> --->
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
				<!--- MODIFIEDDATE FIELD #Counter# = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR> --->
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR><BR> --->
		<!--- MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, PR.PURCHREQID, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, PRL.LINENUMBER, SI.FISCALYEARID,
				SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED,
				SI.LICENSETYPEID,SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID,
				SI.MODIFIEDBYID, SI.MODIFIEDDATE
		FROM		SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	(SI.SOFTWINVENTID > 0 AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID) AND (
			<CFIF #FORM.PURCHREQID1# GT 0>
				<CFIF IsDefined('FORM.NEGATEPURCHREQID1')>
					NOT (PR.PURCHREQID = #val(FORM.PURCHREQID1)#) #LOGICANDOR#
				<CFELSE>
					PR.PURCHREQID = #val(FORM.PURCHREQID1)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.REQNUMBER1# NEQ "">
				<CFIF IsDefined("FORM.NEGATEPURCHREQID1")>
					NOT (PR.REQNUMBER LIKE '%#FORM.REQNUMBER1#%' #LOGICANDOR#
				<CFELSE>
					PR.REQNUMBER LIKE '%#FORM.REQNUMBER1#%' #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.SOFTWINVENTID# GT 0>
				<CFIF IsDefined('FORM.NEGATESOFTWINVENTID')>
					NOT SI.SOFTWINVENTID = #val(FORM.SOFTWINVENTID)# #LOGICANDOR#
				<CFELSE>
					SI.SOFTWINVENTID = #val(FORM.SOFTWINVENTID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.REQNUMBER2# NEQ "" AND #FORM.REQLINENUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATESOFTWINVENTID")>
					(NOT PR.REQNUMBER = '#FORM.REQNUMBER2#' AND
					NOT PRL.LINENUMBER = #val(FORM.REQLINENUMBER)#) #LOGICANDOR#
				<CFELSE>
					(PR.REQNUMBER = '#FORM.REQNUMBER2#' AND
					PRL.LINENUMBER = #val(FORM.REQLINENUMBER)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.PURCHREQID2# GT 0>
				<CFIF IsDefined("FORM.NEGATEPURCHREQID2")>
					NOT (PR.PURCHREQID = #val(FORM.PURCHREQID2)#) #LOGICANDOR#
				<CFELSE>
					PR.PURCHREQID = #val(FORM.PURCHREQID2)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.PONUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEPURCHREQID2")>
					NOT (PR.PONUMBER LIKE '%#FORM.PONUMBER#%' #LOGICANDOR#
				<CFELSE>
					PR.PONUMBER LIKE '%#FORM.PONUMBER#%' #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.STATUSID# GT 0>
				<CFIF IsDefined("FORM.NEGATESTATUSID")>
					(NOT SI.PRODSTATUSID = #val(FORM.STATUSID)# AND
					 NOT SI.UPGRADESTATUSID = #val(FORM.STATUSID)# AND 
					 NOT SI.TOSSSTATUSID = #val(FORM.STATUSID)# ) #LOGICANDOR#
				<CFELSE>
					(SI.PRODSTATUSID = #val(FORM.STATUSID)# OR
					 SI.UPGRADESTATUSID = #val(FORM.STATUSID)# OR 
					 SI.TOSSSTATUSID = #val(FORM.STATUSID)# ) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.CREATIONDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATECREATIONDATE")>
					<CFIF CREATIONDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(CREATIONDATEARRAY)#>
							<CFSET FORMATCREATIONDATE =  DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT SI.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF CREATIONDATERANGE EQ "YES">
						NOT (SI.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT SI.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF CREATIONDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(CREATIONDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							SI.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATCREATIONDATE = DateFormat(#CREATIONDATEARRAY[ArrayLen(CREATIONDATEARRAY)]#, 'DD-MMM-YYYY')>
						SI.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSEIF CREATIONDATERANGE EQ "YES">
							(SI.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						SI.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

			<CFIF #FORM.FISCALYEARID# GT 0>
				<CFIF IsDefined("FORM.NEGATEFISCALYEARID")>
					NOT (SI.FISCALYEARID = #val(FORM.FISCALYEARID)#) #LOGICANDOR#
				<CFELSE>
					SI.FISCALYEARID = #val(FORM.FISCALYEARID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT SI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				<CFELSE>
					SI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
							<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT SI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						NOT (SI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT SI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							SI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
						SI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
							(SI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						SI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

				SI.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	PR.REQNUMBER, PRL.LINENUMBER, SI.TITLE
	</CFQUERY>

	<CFIF #ListSoftwareInventory.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/silookupreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>IDT Software Inventory - Inventory Lookup Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/silookupreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="6"><H2>#ListSoftwareInventory.RecordCount# Software Inventory records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="left">Title</TH>
			<TH align="center">Software Record Number</TH>
			<TH align="center">Version</TH>
			<TH align="center">Platform</TH>
			<TH align="center">Modified By</TH>
			<TH align="center">Modified Date</TH>
		</TR>
	<CFLOOP query="ListSoftwareInventory">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListSoftwareInventory.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="ListUpgradeStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#ListSoftwareInventory.UPGRADESTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<CFQUERY name="ListTossStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#ListSoftwareInventory.TOSSSTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<CFQUERY name="GetSoftwareFiscalYear" datasource="#application.type#LIBSHAREDDATA" blockfactor="76">
			SELECT	FISCALYEARID, FISCALYEAR_2DIGIT, FISCALYEAR_4DIGIT, CURRENTFISCALYEAR
			FROM		FISCALYEARS
			WHERE	FISCALYEARID = <CFQUERYPARAM value="#ListSoftwareInventory.FISCALYEARID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FISCALYEARID
		</CFQUERY>

		<TR>
			<TD align="left" valign="TOP"><DIV>#ListSoftwareInventory.TITLE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.SOFTWINVENTID#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.VERSION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListSoftwareInventory.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
			
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#ListSoftwareInventory.REQNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.LINENUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PONUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.QTYLICENSED#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListUpgradeStatuses.STATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListTossStatuses.STATUSNAME#</DIV></TD>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListSoftwareInventory.CREATIONDATE, "MM/DD/YYYY")#&nbsp;&nbsp;&nbsp;&nbsp;#GetSoftwareFiscalYear.FISCALYEAR_4DIGIT#</DIV></TD>
		</TR>
		<TR>
			<TD align="CENTER" colspan="6"><HR noshade /></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="6"><H2>#ListSoftwareInventory.RecordCount# Software Inventory records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/silookupreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="6">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>