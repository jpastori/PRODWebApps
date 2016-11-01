<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareinventoryarchivereport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/16/2012 --->
<!--- Date in Production: 07/16/2012 --->
<!--- Module: Archive Report for IDT Software Inventory--->
<!-- Last modified by John R. Pastori on 06/20/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm">
<CFSET CONTENT_UPDATED = "June 20, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Archive Report for IDT Software Inventory</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Software Inventory";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupField() {

		if (document.LOOKUP.SOFTWAREID.selectedIndex > "0" && document.LOOKUP.TITLE.value != "") {
			alertuser (document.LOOKUP.SOFTWAREID.name +  ",  BOTH a dropdown value AND a Title can NOT be entered! Choose one or the other.");
			document.LOOKUP.SOFTWAREID.focus();
			return false;
		}

		if (document.LOOKUP.PURCHREQID1.selectedIndex > "0" && document.LOOKUP.REQNUMBER1.value != "") {
			alertuser (document.LOOKUP.PURCHREQID1.name +  ",  BOTH a dropdown value AND a Requisition Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.PURCHREQID1.focus();
			return false;
		}

		if ((!document.LOOKUP.REQNUMBER2.value == "") && (document.LOOKUP.REQLINENUMBER.value == ""
		   || document.LOOKUP.REQLINENUMBER.value == "")) {
			alertuser (document.LOOKUP.REQLINENUMBER.name +  ",  You must enter a Requistion Line Number when you enter a Requisition number.");
			document.LOOKUP.REQLINENUMBER.focus();
			return false;
		}

		if (document.LOOKUP.PURCHREQID2.selectedIndex > "0" && document.LOOKUP.PONUMBER.value != "") {
			alertuser (document.LOOKUP.PURCHREQID2.name +  ",  BOTH a dropdown value AND a Purchase Order Number can NOT be entered! Choose one or the other.");
			document.LOOKUP.PURCHREQID2.focus();
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
<CFSET REPORTTITLE1 = ''>
<CFSET TABLENAME = ''>
<CFIF IsDefined('URL.REPORT')>
	<CFIF #URL.REPORT# EQ 'INVENTORY'>
		<CFSET TABLENAME ='SOFTWAREINVENTORY'>
		<CFSET REPORTTITLE1 = 'IDT Software Inventory To Be Archived Report'>
	<CFELSE>
		<CFSET TABLENAME ='SOFTWAREARCHIVE'>
		<CFSET REPORTTITLE1 = 'IDT Software Archived Report'>
	</CFIF>
<CFELSE>
	<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/index.cfm?logout=No" />
	<CFEXIT>
</CFIF>

<CFIF NOT IsDefined('URL.LOOKUPSOFTWAREID')>
	<CFSET CURSORFIELD = "document.LOOKUP.SOFTWAREID.focus();">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
***************************************************************************
* The following code is the Look Up Process for Inventory Salvage Report. *
***************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPSOFTWAREID')>

	<CFQUERY name="LookupSoftware" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.PURCHREQID, PR.REQNUMBER, PR.PONUMBER, SI.FISCALYEARID, SI.RECVDDATE, SI.PRODSTATUSID,
				SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED,
				SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE,
				SI.SOFTWINVENTID || ' - ' || SI.TITLE AS KEYTITLE, SI.SOFTWINVENTID || ' - ' || PR.REQNUMBER AS KEYREQ, 
				SI.SOFTWINVENTID || ' - ' || PR.PONUMBER AS KEYPO
		FROM		#TABLENAME# SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	KEYTITLE
	</CFQUERY>

	<CFQUERY name="LookupSoftwareInventoryPurchReqLines" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, PRL.PURCHREQLINEID, PR.PURCHREQID, PR.REQNUMBER, PRL.LINENUMBER, PR.PONUMBER, SI.FISCALYEARID,
				SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED,
				SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID, MANUFWARRVENDORID,
				SI.MODIFIEDBYID, SI.MODIFIEDDATE, PR.REQNUMBER || ' - ' || PRL.LINENUMBER || ' - ' || SUBSTR(SI.TITLE,1,25) AS LOOKUPKEY
		FROM		#TABLENAME# SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
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

	<CFQUERY name="ListUpgradeStatus" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = 0 OR
				STATUSTYPE = 'UPGR'
		ORDER BY	STATUSTYPE, STATUSNAME
	</CFQUERY>

	<CFQUERY name="ListTossStatus" datasource="#application.type#SOFTWARE" blockfactor="6">
		SELECT	STATUSID, STATUSTYPE, STATUSNAME
		FROM		STATUSES
		WHERE	STATUSID = 0 OR
				STATUSTYPE = 'TOSS'
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
				SL.SECURITYLEVELNUMBER >= 30
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
			<CFIF #URL.REPORT# EQ 'INVENTORY'>
				<H1>IDT Software Inventory To Be Archived Report Lookup Selection</H1>
			<CFELSE>
				<H1>IDT Software Archived Report Lookup Selection</H1>
			</CFIF>
			</TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H2>
					Select from the dropdown fields or type in complete values to choose selection criteria. <BR />
					More than one field can be selected except where text and dropdown represent the same field. <BR />
					Checking an adjacent checkbox will negate the selection or data entered.
				</H2>
			</TH>
		</TR>
	</TABLE>
		<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
<BR /><BR /><BR /><BR />	<BR />
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?LOOKUPSOFTWAREID=FOUND&REPORT=#URL.REPORT#" method="POST">
	<FIELDSET>
     <LEGEND>Criteria Selection</LEGEND>
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH align="LEFT" colspan="2"><LABEL for="SOFTWAREID">SW Key - Title</LABEL></TH>
			<TH align="left" colspan="2"><LABEL for="TITLE">Or Title</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<CFSELECT name="SOFTWAREID" id="SOFTWAREID" size="1" query="LookupSoftware" value="SOFTWINVENTID" display="KEYTITLE" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="LEFT" colspan="2">
				<CFINPUT type="Text" name="TITLE" id="TITLE" value="" align="LEFT" required="No" size="18" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
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
				<LABEL for="SOFTWINVENTID">(1) Select a Requisition Number - Requisition Line Number - Title </LABEL>or <BR /> 
				<LABEL for="REQNUMBER2">(2) Type Requisition Number</LABEL>-
				<LABEL for="REQLINENUMBER">Requisition Line Number.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHREQID1" id="NEGATEPURCHREQID1" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="PURCHREQID1" id="PURCHREQID1" size="1" query="LookupPurchReqs" value="PURCHREQID" selected="0" display="REQNUMBER" required="No" tabindex="5"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQNUMBER1" id="REQNUMBER1" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="6">
			</TD>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESOFTWINVENTID" id="NEGATESOFTWINVENTID" value="" align="LEFT" required="No" tabindex="7">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryPurchReqLines" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="8"></CFSELECT><BR />
				<CFINPUT type="Text" name="REQNUMBER2" id="REQNUMBER2" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="9">-
				<CFINPUT type="Text" name="REQLINENUMBER" id="REQLINENUMBER" value="" align="LEFT" required="No" size="2" maxlength="6" tabindex="10">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPURCHREQID2">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PURCHREQID2">(1) Select a PO Number</LABEL> or<BR /> 
				<LABEL for="PONUMBER">(2) Type PO Number.</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" width="5%">
				<LABEL for="NEGATEUPGRADESTATUSID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="UPGRADESTATUSID">Upgrade Status</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPURCHREQID2" id="NEGATEPURCHREQID2" value="" align="LEFT" required="No" tabindex="11">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="PURCHREQID2" id="PURCHREQID2" size="1" query="LookupPurchReqPOs" value="PURCHREQID" selected="0" display="PONUMBER" required="No" tabindex="12"></CFSELECT><BR />
				<CFINPUT type="Text" name="PONUMBER" id="PONUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="13">
			</TD>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEUPGRADESTATUSID" id="NEGATEUPGRADESTATUSID" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="UPGRADESTATUSID" id="UPGRADESTATUSID" size="1" query="ListUpgradeStatus" value="STATUSID" display="STATUSNAME" required="No" tabindex="15"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATETOSSSTATUSID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="TOSSSTATUSID">(1) Select a Toss Status</LABEL>or <BR /> 
				<LABEL for="TOSSSTATUSSERIES">(2) Type a series of Toss Status values separated by commas,NO spaces.</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECREATIONDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CREATIONDATE">(1) Type a single Creation Date or <BR />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<BR>
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATETOSSSTATUSID" id="NEGATETOSSSTATUSID" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="TOSSSTATUSID" id="TOSSSTATUSID" size="1" query="ListTossStatus" value="STATUSID" display="STATUSNAME" required="No" tabindex="17"></CFSELECT><BR>
                    <CFINPUT type="TEXT" name="TOSSSTATUSSERIES" id="TOSSSTATUSSERIES" value="" required="No" size="40" maxlength="50" tabindex="18">
			</TD>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECREATIONDATE" id="NEGATECREATIONDATE" value="" align="LEFT" required="No" tabindex="19">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFINPUT type="Text" name="CREATIONDATE" id="CREATIONDATE" value="" required="No" size="50" tabindex="20">
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
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
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">
				(1) Type a single Date Modified or <BR />
				&nbsp;(2) a series of dates separated by commas,NO spaces or<BR>
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="21">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="22">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT"  valign="top" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="23">
			</TD>
			<TD align="LEFT" valign="top" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="24">
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.<BR />
				Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2>
			</TH>
		</TR>

		<TR>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="25"><LABEL for="REPORTCHOICE1">Software #URL.REPORT# Report by SW Key</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="26"><LABEL for="REPORTCHOICE2">Software #URL.REPORT# Report by SW Title</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="27"><LABEL for="REPORTCHOICE3">Software #URL.REPORT# Report by Requisition Number</LABEL><BR />
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="28"><LABEL for="REPORTCHOICE4">Software #URL.REPORT# Report by Upgrade Status</LABEL><BR />
			</TD>
               <TD align="LEFT" valign="top">
               	<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="29"><LABEL for="REPORTCHOICE5">Software #URL.REPORT# Review by SW Title</LABEL><BR />
               </TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
          <TR>
			<TD align="LEFT" colspan="2">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="30" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" onClick="return setMatchAll();" tabindex="31" />
			</TD>
		</TR>
	</TABLE>
     </FIELDSET>
</CFFORM>
	
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="32" /><BR />
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
**************************************************************************************************
* The following code is the Record Selection Process for the Software Inventory Archive Process. *
**************************************************************************************************
 --->

	
	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'SI.SOFTWINVENTID'>
	<CFSET SORTORDER[2] = 'SI.TITLE~SI.VERSION'>
	<CFSET SORTORDER[3] = 'PR.REQNUMBER'>
	<CFSET SORTORDER[4] = 'UGSNAME~SI.TITLE'>
     <CFSET SORTORDER[5] = 'SI.TITLE~SI.VERSION'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>

	<CFIF FIND('~', #REPORTORDER#, 1) NEQ 0>
		<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
	<!--- REPORT ORDER = #REPORTORDER#<BR><BR>
	<CFELSE>
		REPORT ORDER = #REPORTORDER# --->
	</CFIF>

	<CFIF #URL.REPORT# EQ 'INVENTORY'>
		<CFSET #URL.REPORT# = 'Inventory'>
	<CFELSE>
		<CFSET #URL.REPORT# = 'Archive'>
	</CFIF>
     
     <CFIF #FORM.TOSSSTATUSSERIES# NEQ ''>
     
     	<CFSET FORM.TOSSSTATUSSERIES = UCASE(#FORM.TOSSSTATUSSERIES#)>
		<CFSET FORM.TOSSSTATUSSERIES = ListQualify(FORM.TOSSSTATUSSERIES,"'",",","CHAR")>
		TOSS STATUS SERIES FIELD = #FORM.TOSSSTATUSSERIES#<BR /><BR />

		<CFQUERY name="LookupTossStatus" datasource="#application.type#SOFTWARE" blockfactor="6">
               SELECT	STATUSID, STATUSTYPE, STATUSNAME
               FROM		STATUSES
               WHERE	STATUSTYPE = 'TOSS' AND
                         STATUSNAME IN (#PreserveSingleQuotes(FORM.TOSSSTATUSSERIES)#)
               ORDER BY	STATUSTYPE, STATUSNAME
          </CFQUERY>
          
          <CFIF LookupTossStatus.RecordCount EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert ("The entered Toss Statuses were not MAYBE, MOVED, TOSS, TOSS-CEA or TOSS-R.");
				-->
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?REPORT=#URL.REPORT#" />
			<CFEXIT>
		</CFIF>
	
     </CFIF>
     
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

	<CFQUERY name="GetSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,
				SI.PRODDESCRIPTION, PRL.PURCHREQLINEID, PR.PURCHREQID, PR.REQNUMBER, PR.PONUMBER, PRL.LINENUMBER, SI.FISCALYEARID,
				SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT, SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED,
				SI.LICENSETYPEID,SI.QTYLICENSED, SI.UPGRADESTATUSID, S.STATUSNAME AS UGSNAME, SI.TOSSSTATUSID, SI.CDKEY, SI.PRODUCTID,
				MANUFWARRVENDORID, SI.MODIFIEDBYID, SI.MODIFIEDDATE
		FROM		#TABLENAME# SI, PRODUCTPLATFORMS PP, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR, STATUSES S
		WHERE	(SI.SOFTWINVENTID > 0 AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID AND
				SI.UPGRADESTATUSID = S.STATUSID) AND (
			<CFIF #FORM.SOFTWAREID# GT 0>
				SI.SOFTWINVENTID = #val(FORM.SOFTWAREID)# #LOGICANDOR#
			<CFELSEIF #FORM.TITLE# NEQ ''>
				SI.TITLE LIKE UPPER('%#FORM.TITLE#%') #LOGICANDOR#
			</CFIF>

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

			<CFIF #FORM.UPGRADESTATUSID# GT 0>
				<CFIF IsDefined("FORM.NEGATEUPGRADESTATUSID")>
					 NOT SI.UPGRADESTATUSID = #val(FORM.UPGRADESTATUSID)# #LOGICANDOR#
				<CFELSE>
					 SI.UPGRADESTATUSID = #val(FORM.UPGRADESTATUSID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.TOSSSTATUSID# GT 0>
				<CFIF IsDefined("FORM.NEGATETOSSSTATUSID")>
					 NOT SI.TOSSSTATUSID = #val(FORM.TOSSSTATUSID)# #LOGICANDOR#
				<CFELSE>
					 SI.TOSSSTATUSID = #val(FORM.TOSSSTATUSID)#  #LOGICANDOR#
				</CFIF>
			</CFIF>
               
               <CFIF #FORM.TOSSSTATUSSERIES# NEQ ''>
               	<CFIF IsDefined("FORM.NEGATETOSSSTATUSID")>
                    	NOT SI.TOSSSTATUSID IN (#ValueList(LookupTossStatus.STATUSID)#) #LOGICANDOR#
				<CFELSE>
               	 	SI.TOSSSTATUSID IN (#ValueList(LookupTossStatus.STATUSID)#) #LOGICANDOR#
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
						SI.CREATIONDATE = TO_DATE('#FORMATCREATIONDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF CREATIONDATERANGE EQ "YES">
							(SI.CREATIONDATE BETWEEN TO_DATE('#BEGINCREATIONDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDCREATIONDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						SI.CREATIONDATE LIKE TO_DATE('#FORM.CREATIONDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
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
						SI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
							(SI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						SI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

				SI.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	#REPORTORDER#
	</CFQUERY>

<!--- 
*****************************************************************************
* The following code is the Inventory Salvage Report for Software Inventory *
*****************************************************************************
 --->
	<CFSET REPORTTITLE2 = ''>
	<CFSET PRINTRECORD = "YES">

	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET REPORTTITLE2 = 'REPORT 1:&nbsp;&nbsp;&nbsp;&nbsp;Software #URL.REPORT# Report by SW Keys'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE2 = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;Software #URL.REPORT# Report by SW Title'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET REPORTTITLE2 = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;Software #URL.REPORT# Report by Requisition Number'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET REPORTTITLE2 = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Software #URL.REPORT# Report by Upgrade Status'>
	</CFIF>
     
     <CFIF #FORM.REPORTCHOICE# EQ 5>
		<CFSET REPORTTITLE2 = 'REPORT 5:&nbsp;&nbsp;&nbsp;&nbsp;Software #URL.REPORT# Review by SW Title'>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>#REPORTTITLE1#
				<H2>#REPORTTITLE2#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?REPORT=#URL.REPORT#" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
	<TR>
			<TH align="CENTER" colspan="9"><H2>#GetSoftwareInventory.RecordCount# Software #URL.REPORT# records were selected.</H2></TH>
		</TR>
		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<TH align="center">Requisition Number</TH>
			<TH align="center">Purchase Order Number</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 4>
			<TH align="center">Upgrade Status</TH>
			<TH align="center">Toss Status</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 2 OR #FORM.REPORTCHOICE# NEQ 5>
			<TH align="center">SW Key</TH>
		</CFIF>
			<TH align="left">Title</TH>
			<TH align="center">Version</TH>
		<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 5>
			<TH align="center">SW Key</TH>
		</CFIF>
			<TH align="center">Platform</TH>
			<TH align="center">Quantity Licensed</TH>
		<CFIF #FORM.REPORTCHOICE# NEQ 3>
			<TH align="center">Requisition Number</TH>
			<TH align="center">Purchase Order Number</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<TH align="center">Upgrade Status</TH>
			<TH align="center">Toss Status</TH>
		</CFIF>
		</TR>
	<CFLOOP query="GetSoftwareInventory">

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SA.SOFTWASSIGNID, SA.SOFTWINVENTID
			FROM		SOFTWAREASSIGNMENTS SA
			WHERE	SA.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SA.SOFTWINVENTID
		</CFQUERY>

		<CFQUERY name="LookupManualRecords" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, MAN.SOFTWINVENTID
			FROM		SOFTWAREINVENTORY SI, MANUALS MAN
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.SOFTWINVENTID = MAN.SOFTWINVENTID
		</CFQUERY>

		<CFQUERY name="LookupMediaRecords" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, M.SOFTWINVENTID
			FROM		SOFTWAREINVENTORY SI, MEDIA M
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.SOFTWINVENTID = M.SOFTWINVENTID
		</CFQUERY>

		<CFQUERY name="LookupOtherItemsRecords" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	SI.SOFTWINVENTID, OI.SOFTWINVENTID
			FROM		SOFTWAREINVENTORY SI, OTHERITEMS OI
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#GetSoftwareInventory.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.SOFTWINVENTID = OI.SOFTWINVENTID
		</CFQUERY>

		<CFQUERY name="GetUpgradeStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#GetSoftwareInventory.UPGRADESTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<CFQUERY name="GetTossStatuses" datasource="#application.type#SOFTWARE">
			SELECT	STATUSID, STATUSTYPE, STATUSNAME
			FROM		STATUSES
			WHERE	STATUSID = <CFQUERYPARAM value="#GetSoftwareInventory.TOSSSTATUSID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATUSTYPE, STATUSNAME
		</CFQUERY>

		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<TD align="left" valign="TOP">
				<DIV>#GetSoftwareInventory.REQNUMBER#&nbsp;&nbsp;-&nbsp;&nbsp;#GetSoftwareInventory.LINENUMBER#</DIV>
			</TD>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.PONUMBER#</DIV></TD>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 4>
			<TD align="center" valign="TOP"><DIV>#GetUpgradeStatuses.STATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#GetTossStatuses.STATUSNAME#</DIV></TD>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 2 AND #FORM.REPORTCHOICE# NEQ 5>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.SOFTWINVENTID#</DIV></TD>
		</CFIF>
			<TD align="left" valign="TOP">
				<DIV>#GetSoftwareInventory.TITLE#</DIV>
			<CFIF #LookupSoftwareAssignments.RecordCount# GT 0 AND #FORM.REPORTCHOICE# NEQ 5>
				<H4>HAS SOFTWARE ASSIGNMENT CHILD RECORDS ATTACHED.</H4>
			</CFIF>
			<CFIF #LookupManualRecords.RecordCount# GT 0 AND #FORM.REPORTCHOICE# NEQ 5>
				<H4>HAS MANUAL CHILD RECORDS ATTACHED.</H4>
			</CFIF>
			<CFIF #LookupMediaRecords.RecordCount# GT 0 AND #FORM.REPORTCHOICE# NEQ 5>
				<H4>HAS MEDIA CHILD RECORDS ATTACHED.</H4>
			</CFIF>
			<CFIF #LookupOtherItemsRecords.RecordCount# GT 0 AND #FORM.REPORTCHOICE# NEQ 5>
				<H4>HAS OTHER ITEMS CHILD RECORDS ATTACHED.</H4>
			</CFIF>
			</TD>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.VERSION#</DIV></TD>
		<CFIF #FORM.REPORTCHOICE# EQ 2 OR #FORM.REPORTCHOICE# EQ 5>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.SOFTWINVENTID#</DIV></TD>
		</CFIF>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.QTYLICENSED#</DIV></TD>
		<CFIF #FORM.REPORTCHOICE# NEQ 3>
			<TD align="left" valign="TOP">
				<DIV>#GetSoftwareInventory.REQNUMBER#&nbsp;&nbsp;-&nbsp;&nbsp;#GetSoftwareInventory.LINENUMBER#</DIV>
			</TD>
			<TD align="center" valign="TOP"><DIV>#GetSoftwareInventory.PONUMBER#</DIV></TD>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<TD align="center" valign="TOP"><DIV>#GetUpgradeStatuses.STATUSNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#GetTossStatuses.STATUSNAME#</DIV></TD>
		</CFIF>
		</TR><TR>
			<TD align="CENTER" colspan="10"><HR noshade /></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="10"><H2>#GetSoftwareInventory.RecordCount# Software #URL.REPORT# records were selected.</H2></TH>
		</TR>
	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareinventoryarchivereport.cfm?REPORT=#URL.REPORT#" method="POST">
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
</BODY></CFOUTPUT>


</HTML>