<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqlineinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 09/17/2012 --->
<!--- Date in Production: 09/17/2012 --->
<!--- Module: Add, Modify and Delete IDT Purchase Requisition Lines--->
<!-- Last modified by John R. Pastori on 05/14/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchreqlineinfo.cfm">
<CFSET CONTENT_UPDATED = "May 14, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'MODIFYLOOP' or IsDefined('FORM.PURCHREQID') AND FORM.PURCHREQID GT 0>
     	<CFSET SESSION.PRLModLoop = "YES">
	<CFELSEIF IsDefined('FORM.PURCHREQLINEID') AND FORM.PURCHREQLINEID GT 0>>
		<CFSET SESSION.PRLModLoop = "NO">
	</CFIF>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add IDT Purchase Requisition Lines</TITLE>
	<CFELSEIF URL.PROCESS EQ 'MODIFYLOOP' or (isDefined('SESSION.PRLModLoop') and SESSION.PRLModLoop EQ "YES")>
		<TITLE>Modify IDT Purchase Requisition Lines</TITLE>
     <CFELSE>
     	<TITLE>Modify/Delete IDT Purchase Requisition Lines</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PURCHASEREQUISITIONLINES.LINEQTY.value == "" || document.PURCHASEREQUISITIONLINES.LINEQTY.value == " ") {
			alertuser (document.PURCHASEREQUISITIONLINES.LINEQTY.name +  ",  You must enter a Line Quantity.");
			document.PURCHASEREQUISITIONLINES.LINEQTY.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONLINES.UNITOFMEASUREID.selectedIndex == "0") {
			alertuser (document.PURCHASEREQUISITIONLINES.UNITOFMEASUREID.name +  ",  A Unit of Measure must be selected from the dropdown box.");
			document.PURCHASEREQUISITIONLINES.UNITOFMEASUREID.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONLINES.PARTNUMBER.value == "" || document.PURCHASEREQUISITIONLINES.PARTNUMBER.value == " ") {
			alertuser (document.PURCHASEREQUISITIONLINES.PARTNUMBER.name +  ",  You must enter a Part Number.");
			document.PURCHASEREQUISITIONLINES.PARTNUMBER.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONLINES.LINEDESCRIPTION.value == "" || document.PURCHASEREQUISITIONLINES.LINEDESCRIPTION.value == " ") {
			alertuser (document.PURCHASEREQUISITIONLINES.LINEDESCRIPTION.name +  ",  You must enter a Line Description.");
			document.PURCHASEREQUISITIONLINES.LINEDESCRIPTION.focus();
			return false;
		}

		if (document.PURCHASEREQUISITIONLINES.UNITPRICE.value == "" || document.PURCHASEREQUISITIONLINES.UNITPRICE.value == " ") {
			alertuser (document.PURCHASEREQUISITIONLINES.UNITPRICE.name +  ",  You must enter a Unit Price.");
			document.PURCHASEREQUISITIONLINES.UNITPRICE.focus();
			return false;
		}

		if (!document.PURCHASEREQUISITIONLINES.RECVDDATE.value == "" && !document.PURCHASEREQUISITIONLINES.RECVDDATE.value == " " 
		 && !document.PURCHASEREQUISITIONLINES.RECVDDATE.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.PURCHASEREQUISITIONLINES.RECVDDATE.name +  ", The desired Received Date MUST be entered in the format MM/DD/YYYY!");
			document.PURCHASEREQUISITIONLINES.RECVDDATE.focus();
			return false;
		}

	}

	function validateLookupFields() {
		if (document.LOOKUP.PURCHREQID.selectedIndex == "0" && document.LOOKUP.PURCHREQLINEID.selectedIndex == "0") {
			alertuser ("At least one dropdown field must be selected!");
			document.LOOKUP.PURCHREQID.focus();
			return false;
		}

		if (document.LOOKUP.PURCHREQID.selectedIndex > "0" && document.LOOKUP.PURCHREQLINEID.selectedIndex > "0") {
			alertuser ("Only one dropdown field can be selected! Choose one or the other.");
			document.LOOKUP.PURCHREQID.focus();
			return false;
		}
	}
		
	
	function setNextRecord() {
		document.PURCHASEREQUISITIONLINES.PROCESSPURCHREQLINES.value = "NEXTRECORD";
		return true;
	}
		
	
	function setDelete() {
		document.PURCHASEREQUISITIONLINES.PROCESSPURCHREQLINES.value = "DELETE";
		return true;
	}

	
//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>
<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPURCHREQLINE') AND (URL.PROCESS EQ 'MODIFYDELETE' OR URL.PROCESS EQ 'MODIFYLOOP')>
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PURCHASEREQUISITIONLINES.LINEQTY.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*****************************************************************
* The following code is for all Purchase Requisition Processes. *
*****************************************************************
 --->

<CFQUERY name="ListUnitOfMeasure" datasource="#application.type#PURCHASING" blockfactor="21">
	SELECT	UNITOFMEASUREID, MEASURENAME
	FROM		UNITOFMEASURE
	ORDER BY	UNITOFMEASUREID
</CFQUERY>

<!--- 
*************************************************************************
* The following code is the ADD Process for Purchase Requisition Lines. *
*************************************************************************
 --->

<CFIF URL.PROCESS EQ "ADD">
	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.CREATIONDATE
		FROM		PURCHREQS PR
		WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#URL.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	PR.PURCHREQID
	</CFQUERY>

	<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING">
		SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
		FROM		PURCHREQLINES
		WHERE	PURCHREQID = <CFQUERYPARAM value="#LookupPurchReqs.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	PURCHREQID, LINENUMBER
	</CFQUERY>

	<CFIF LookupPurchReqLines.RecordCount GT 0>
		<CFSET FORM.LINENUMBER = (LISTLAST(ValueList(LookupPurchReqLines.LINENUMBER)) + 1)>
	<CFELSE>
		<CFSET FORM.LINENUMBER = 1>
	</CFIF>
	LINE NUMER = #FORM.LINENUMBER#

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Loop IDT Purchase Requisition Lines</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(PURCHREQLINEID) AS MAX_ID
		FROM		PURCHREQLINES
	</CFQUERY>
	<CFSET FORM.PURCHREQLINEID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PURCHREQLINEID" secure="NO" value="#FORM.PURCHREQLINEID#">
	<CFQUERY name="AddPurchReqsLineID" datasource="#application.type#PURCHASING">
		INSERT INTO	PURCHREQLINES (PURCHREQLINEID, PURCHREQID, LINENUMBER)
		VALUES		(#val(Cookie.PURCHREQLINEID)#, #val(LookupPurchReqs.PURCHREQID)#, #val(FORM.LINENUMBER)#)
	</CFQUERY>
	<CFSET session.PurchReqID = #LookupPurchReqs.PURCHREQID#>


	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Purchase Requisition Key &nbsp; = &nbsp; #LookupPurchReqs.PURCHREQID# &nbsp;&nbsp;Purchase Requisition Lines Key &nbsp; = &nbsp; #FORM.PURCHREQLINEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear="left" />

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST">
			<TD align="LEFT" colspan="3">
				<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PURCHASEREQUISITIONLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><LABEL for="LINENUMBER">Line Number</LABEL></TH>
			<TH align="left"><H4><LABEL for="LINEQTY">*Quantity</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="UNITOFMEASUREID">*UOM</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<INPUT type="hidden" name="LINENUMBER" id="LINENUMBER" value="#FORM.LINENUMBER#" />
				#FORM.LINENUMBER#
			</TD>
			<TD align="left" nowrap>
				<CFINPUT type="Text" name="LINEQTY" id="LINEQTY" value="" align="LEFT" required="No" size="10" tabindex="2">
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="UNITOFMEASUREID" id="UNITOFMEASUREID" size="1" query="ListUnitOfMeasure" value="UNITOFMEASUREID" display="MEASURENAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
			<TH align="left" colspan="2"><H4><LABEL for="LINEDESCRIPTION">*Line Description</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="" align="LEFT" required="No" size="50" tabindex="4">
			</TD>
			<TD align="left" nowrap colspan="2">
				<CFTEXTAREA name="LINEDESCRIPTION" id="LINEDESCRIPTION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="5"></CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="UNITPRICE">*Unit Price</LABEL></H4></TH>
			<TH align="left" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNITPRICE" id="UNITPRICE" value="0.00" align="LEFT" required="No" size="50" tabindex="6">
			</TD>
			<TD align="left" nowrap colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="ADDLOOP" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADDLOOP" alt="ADDLOOP" tabindex="7" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST">
			<TD align="LEFT" colspan="3">
				<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="8" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
	<CFEXIT>

<CFELSE>

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Modifying Purchase Requisition Lines. *
***************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPPURCHREQLINE')>

		<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	DISTINCT PR.REQNUMBER, PRL.PURCHREQID, PR.REQNUMBER, PR.SERVICEREQUESTNUMBER, 
               		PR.SERVICEREQUESTNUMBER || ' - ' || PR.REQNUMBER AS LOOKUPKEY
			FROM		PURCHREQLINES PRL, PURCHREQS PR
			WHERE	(PRL.PURCHREQID = PR.PURCHREQID) AND
               		(PRL.PURCHREQID = 0 OR
               		SUBSTR(PR.SERVICEREQUESTNUMBER,0,2) < '95') 
			ORDER BY	PR.SERVICEREQUESTNUMBER DESC
		</CFQUERY>

		<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PR.REQNUMBER, PR.SERVICEREQUESTNUMBER,
					PR.SERVICEREQUESTNUMBER || ' - ' || PR.REQNUMBER || ' - ' || PRL.LINENUMBER AS LOOKUPKEY
			FROM		PURCHREQLINES PRL, PURCHREQS PR
			WHERE	(PRL.PURCHREQID = PR.PURCHREQID) AND
               		(PRL.PURCHREQID = 0 OR
               		SUBSTR(PR.SERVICEREQUESTNUMBER,0,2) < '95')
			ORDER BY	PR.SERVICEREQUESTNUMBER DESC, PR.REQNUMBER, PRL.LINENUMBER
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify/Delete IDT Purchase Requisition Lines Lookup</H1></TD>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Selection from one of the fields is required!</H4></TH>
			</TR>
		</TABLE>
		<BR clear="left" />
	
		<TABLE width="100%" align="LEFT" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm" method="POST">
				<TD align="left" colspan="2">
                    	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="Cancel" />
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPPURCHREQLINE=FOUND" method="POST">
			<TR>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQID">Select (Loop Thru Lines) SR - Requisition Number:</LABEL></TH>
				<TD width="70%" align="LEFT" valign="BOTTOM">
					<CFSELECT name="PURCHREQID" id="PURCHREQID" size="1" query="LookupPurchReqs" value="PURCHREQID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQLINEID">
					OR (Single Line) SR - Requisition Number - Line Number:</LABEL><BR />
					<COM>(NOTE: &nbsp;&nbsp;DELETE is only available for Single Line Processing.)</COM>
				</TH>
				<TD width="70%" align="LEFT" valign="BOTTOM">
					<CFSELECT name="PURCHREQLINEID" id="PURCHREQLINEID" size="1" query="LookupPurchReqLines" value="PURCHREQLINEID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT><BR />
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/calcpurchreqsubtotal.cfm" method="POST">
				<TD align="left" colspan="2">
                    	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="Cancel" />
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
		<CFEXIT>

	<CFELSE>

<!--- 
****************************************************************************************************
* The following code is the Modify/Delete and ModifyLoop Processes for Purchase Requisition Lines. *
****************************************************************************************************
 --->

		<CFIF IsDefined('URL.PURCHREQID') AND #URL.PURCHREQID# GT 0>
			<CFSET FORM.PURCHREQID = #URL.PURCHREQID#>
		</CFIF>

		<CFIF IsDefined('FORM.PURCHREQID') AND FORM.PURCHREQID GT 0>

			<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
				SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PR.PURCHREQID, PR.REQNUMBER
				FROM		PURCHREQLINES PRL, PURCHREQS PR
				WHERE	PRL.PURCHREQID = <CFQUERYPARAM value="#FORM.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
						PRL.PURCHREQID = PR.PURCHREQID
				ORDER BY	PR.REQNUMBER, PRL.LINENUMBER
			</CFQUERY>

			<CFIF LookupPurchReqLines.RecordCount EQ 0>
				<SCRIPT language="JavaScript">
					<!-- 
						alert("NO Line Records were Found for this Purchase Requisition!");
					--> 
				</SCRIPT>
				<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=ADD&PURCHREQID=#FORM.PURCHREQID#" />
				<CFEXIT>
			</CFIF>

			<CFSET PurchReqLines = #ValueList(LookupPurchReqLines.PURCHREQLINEID)#>
			<CFSET SESSION.PurchReqLinesArray = ArrayNew(1)>
			<CFSET temp = ArraySet(SESSION.PurchReqLinesArray, 1, LISTLEN(PurchReqLines), 0)>
			<CFSET SESSION.PurchReqLinesArray = ListToArray(PurchReqLines)>
			<CFSET SESSION.PRLArrayCounter = 0>
			<CFIF IsDefined('URL.POPUP')>
				<CFSET SESSION.POPUP = 'YES'>
			<CFELSE>
				<CFSET SESSION.POPUP = 'NO'>
			</CFIF>
		</CFIF>

		<CFIF SESSION.PRLModLoop EQ "YES">
			<CFSET SESSION.PRLArrayCounter = SESSION.PRLArrayCounter + 1>
			SESSION Purch Req Lines Array #SESSION.PRLArrayCounter# = #SESSION.PurchReqLinesArray[SESSION.PRLArrayCounter]#
			<CFSET FORM.PURCHREQLINEID = #SESSION.PurchReqLinesArray[SESSION.PRLArrayCounter]#>
		</CFIF>

		<CFQUERY name="GetPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PR.REQNUMBER, PR.SERVICEREQUESTNUMBER, PRL.LINEQTY, PRL.UNITOFMEASUREID,
					PRL.LINEDESCRIPTION, PRL.PARTNUMBER, PRL.RECVDDATE, PRL.LICENSESTATUSID, PRL.UNITPRICE, PRL.LINETOTAL
			FROM		PURCHREQLINES PRL, PURCHREQS PR
			WHERE	PRL.PURCHREQLINEID = <CFQUERYPARAM value="#FORM.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC"> AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	PR.REQNUMBER, PRL.LINENUMBER
		</CFQUERY>

		<CFCOOKIE name="PURCHREQLINEID" secure="NO" value="#GetPurchReqLines.PURCHREQLINEID#">
		<CFSET SESSION.PurchReqID = #GetPurchReqLines.PURCHREQID#>

		<CFQUERY name="ListLicenseStatus" datasource="#application.type#PURCHASING" blockfactor="4">
			SELECT	LICENSESTATUSID, LICENSESTATUSNAME
			FROM		LICENSESTATUS
			ORDER BY	LICENSESTATUSID
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<CFIF SESSION.PRLModLoop EQ 'YES'>
					<TD align="center"><H1>Modify Loop IDT Purchase Requisition Lines</H1></TD>
				<CFELSE>
					<TD align="center"><H1>Modify/Delete IDT Purchase Requisition Lines</H1></TD>
				</CFIF>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Purchase Requisition Key &nbsp; = &nbsp; #GetPurchReqLines.PURCHREQID# &nbsp;&nbsp;Purchase Requisition Lines Key &nbsp; = &nbsp; #GetPurchReqLines.PURCHREQLINEID#
				</TH>
			</TR>
		</TABLE>

		<TABLE width="100%" align="left" border="0">
		<CFIF IsDefined('SESSION.POPUP') AND #SESSION.POPUP# EQ 'YES'>
			<TR>
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel"
					onClick="window.close();" 
					tabindex="1" />
				</TD>
			</TR>
		<CFELSE>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
		</CFIF>
<CFFORM name="PURCHASEREQUISITIONLINES" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left">Req Number</TH>
				<TH align="left" colspan="2">Line Number</TH>
			</TR>
			<TR>
				<TD align="left">#GetPurchReqLines.REQNUMBER#</TD>
				<TD align="left" colspan="2">
					<INPUT type="hidden" name="LINENUMBER" value="#GetPurchReqLines.LINENUMBER#" />
					#GetPurchReqLines.LINENUMBER#
				</TD>
			</TR>
			<TR>
				</TR><TR>
				<TH align="left">SR</TH>
				<TH align="left"><H4><LABEL for="LINEQTY">*Quantity</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="UNITOFMEASUREID">*UOM</LABEL></H4></TH>
			</TR>
			
			<TR>
				<TD align="left" nowrap>
					#GetPurchReqLines.SERVICEREQUESTNUMBER#
				</TD>
				<TD align="left" nowrap>
					<CFINPUT type="Text" name="LINEQTY" id="LINEQTY" value="#GetPurchReqLines.LINEQTY#" align="LEFT" required="No" size="10" tabindex="2">
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="UNITOFMEASUREID" id="UNITOFMEASUREID" size="1" query="ListUnitOfMeasure" value="UNITOFMEASUREID" display="MEASURENAME" selected="#GetPurchReqLines.UNITOFMEASUREID#" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="PARTNUMBER">*Part Number</LABEL></H4></TH>
				<TH align="left" colspan="2"><H4><LABEL for="LINEDESCRIPTION">*Line Description</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="#GetPurchReqLines.PARTNUMBER#" align="LEFT" required="No" size="50" tabindex="4">
				</TD>
				<TD align="left" nowrap colspan="2">
					<CFTEXTAREA name="LINEDESCRIPTION" id="LINEDESCRIPTION" rows="4" cols="80" wrap="VIRTUAL" REQUIRED="No" tabindex="5">#GetPurchReqLines.LINEDESCRIPTION#</CFTEXTAREA>
				</TD>
			</TR>
			<TR>
			<TH align="left"><H4>*<LABEL for="UNITPRICE">Unit Price</LABEL></H4></TH>
			<TH align="left" colspan="2">Line Total</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="UNITPRICE" id="UNITPRICE" value="#NumberFormat(GetPurchReqLines.UNITPRICE, '________.__')#" align="LEFT" required="No" size="50" tabindex="6">
			</TD>
			<TD align="left" nowrap colspan="2">#NumberFormat(GetPurchReqLines.LINETOTAL, '________.__')#</TD>
		</TR>
			<TR>
				<TH align="left"><LABEL for="RECVDDATE">Received Date</LABEL></TH>
				<TH align="left" colspan="2"><LABEL for="LICENSESTATUSID">License Status</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFINPUT type="Text" name="RECVDDATE" id="RECVDDATE" value="#GetPurchReqLines.RECVDDATE#" align="LEFT" required="No" size="10" tabindex="7">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'PURCHASEREQUISITIONLINES','controlname': 'RECVDDATE'});

					</SCRIPT>
					<BR>
					<COM>MM/DD/YYYYY </COM>
				</TD>
				<TD align="left" colspan="2">
					<CFSELECT name="LICENSESTATUSID" id="LICENSESTATUSID" size="1" query="ListLicenseStatus" value="LICENSESTATUSID" display="LICENSESTATUSNAME" selected="#GetPurchReqLines.LICENSESTATUSID#" required="No" tabindex="8"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
		<CFIF session.PRLModLoop EQ 'YES'>
				<TD align="left" width="33%">
          			<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="MODIFYLOOP" />
               		<INPUT type="image" src="/images/buttonModifyLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" tabindex="9" />
          		</TD>
		<CFELSE>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="9" />
                    </TD>
		</CFIF>
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonAddSerialNums.jpg" value="Add Serial Numbers" alt="Add Serial Numbers"
					onClick="window.open('/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=ADD&PURCHREQLINEID=#Cookie.PURCHREQLINEID#','Add PurchReq Line Serial Numbers','alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25'); return false;"
					tabindex="10" />
				</TD>
			</TR>
		<CFIF session.PRLModLoop EQ 'YES'>
			<TR>
				<TD align="left" colspan="3">
					<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" OnClick="return setNextRecord();" tabindex="11" /><BR>
					<COM>(No change.)</COM>
				</TD>
			</TR>
		</CFIF>
		<CFIF #Client.DeleteFlag# EQ "YES" AND session.PRLModLoop EQ "NO">
			<TR>
				<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
               	<TD align="left" colspan="3">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="12" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left" colspan="3">&nbsp;&nbsp;</TD>
			</TR>
		<CFIF IsDefined('SESSION.POPUP') AND #SESSION.POPUP# EQ 'YES'>
			<TR>
				<TD align="left" colspan="3">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel"
					onClick="window.close();" 
					tabindex="13" />
				</TD>
			</TR>
		<CFELSE>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/purchreqlineinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="14" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
		</CFIF>
			<TR>
				<TD align="CENTER" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>