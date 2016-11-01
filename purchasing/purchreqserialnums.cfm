<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: purchreqserialnums.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Add, Modify and Delete IDT Purchase Requisition Line Serial Numbers--->
<!-- Last modified by John R. Pastori on 05/13/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/purchreqserialnums.cfm">
<CFSET CONTENT_UPDATED = "May 13, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add IDT Purchase Requisition Line Serial Numbers</TITLE>
	<CFELSE>
		<TITLE>Modify IDT Purchase Requisition Line Serial Numbers</TITLE>
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
		if (document.SOFTWARESERIALNUMBERS.REPLACESWSERIALNUM.value == "" || document.SOFTWARESERIALNUMBERS.REPLACESWSERIALNUM.value == " ") {
			alertuser (document.SOFTWARESERIALNUMBERS.REPLACESWSERIALNUM.name +  ",  You must enter a Replacement Serial Number.");
			document.SOFTWARESERIALNUMBERS.REPLACESWSERIALNUM.focus();
			return false;
		}

		if (document.SOFTWARESERIALNUMBERS.SOFTWINVENTID.selectedIndex == "0" ) {
			alertuser (document.SOFTWARESERIALNUMBERS.SOFTWINVENTID.name +  ",  You must select a Software Title.");
			document.SOFTWARESERIALNUMBERS.SOFTWINVENTID.focus();
			return false;
		}
	}

	function validateLookupFields() {
		if (document.LOOKUP.PURCHREQLINEID.selectedIndex == "0" && document.LOOKUP.PRLSWSERIALNUMID.selectedIndex == "0") {
			alertuser ("At least one dropdown field must be selected!");
			document.LOOKUP.PURCHREQLINEID.focus();
			return false;
		}

		if (document.LOOKUP.PURCHREQLINEID.selectedIndex > "0" && document.LOOKUP.PRLSWSERIALNUMID.selectedIndex > "0") {
			alertuser ("Only one dropdown field can be selected! Choose one or the other.");
			document.LOOKUP.PURCHREQLINEID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.SOFTWARESERIALNUMBERS.PROCESSPURCHREQSERNUMS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSWSERNUM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PURCHREQLINEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SOFWARESERIALNUMBERS.REPLACESWSERIALNUM.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*************************************************************************************
* The following code is for all Purchase Requisition  Line Serial Number Processes. *
*************************************************************************************
 --->

<CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
	SELECT	SOFTWINVENTID, CREATIONDATE, TITLE, VERSION, CATEGORYID, PRODPLATFORMID, PRODDESCRIPTION, PURCHREQLINEID,
			FISCALYEARID, TO_CHAR(RECVDDATE,'MM/DD/YYYY') AS RECVDDATE, PRODSTATUSID, PHONESUPPORT, WEBSUPPORT, FAXSUPPORT,
			SUPPORTCOMMENTS, QTYORDERED,LICENSETYPEID, QTYLICENSED, UPGRADESTATUSID, TOSSSTATUSID, CDKEY, PRODUCTID, 
			MANUFWARRVENDORID, MODIFIEDBYID, MODIFIEDDATE, TITLE || ' - ' || SOFTWINVENTID AS LOOKUPKEY
	FROM		SOFTWAREINVENTORY
	ORDER BY	LOOKUPKEY
</CFQUERY>

<!--- 
***************************************************************************************
* The following code is the ADD Process for Purchase Requisition Line Serial Numbers. *
***************************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>

	<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING">
		SELECT	PURCHREQLINEID, PURCHREQID, LINENUMBER, LINEQTY, LINEDESCRIPTION, PARTNUMBER, RECVDDATE, LICENSESTATUSID
		FROM		PURCHREQLINES
		WHERE	PURCHREQLINEID = <CFQUERYPARAM value="#URL.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	PURCHREQID, LINENUMBER
	</CFQUERY>

	<CFQUERY name="LookupPurchReqs" datasource="#application.type#PURCHASING">
		SELECT	PR.PURCHREQID, PR.SERVICEREQUESTNUMBER, PR.CREATIONDATE, PR.FISCALYEARID, PR.REQUESTERID, CUST.FULLNAME,
				PR.PURCHREQUNITID, PR.FUNDACCTID, PR.PURCHASEJUSTIFICATION, PR.RUSH, PR.RUSHJUSTIFICATION, PR.SUBTOTAL,
				PR.SALESTAXID, PR.TOTAL, PR.REQNUMBER, PR.SALESORDERNUMBER, PR.PONUMBER, PR.VENDORID, PR.VENDORCONTACTID,
				PR.QUOTEDATE, PR.QUOTE, PR.SPECSCOMMENTS, PR.IDTREVIEWERID, PR.REVIEWDATE, PR.RECVCOMMENTS, PR.REQFILEDDATE,
				PR.COMPLETEFLAG, PR.SWFLAG
		FROM		PURCHREQS PR, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	PR.PURCHREQID = <CFQUERYPARAM value="#LookupPurchReqLines.PURCHREQID#" cfsqltype="CF_SQL_NUMERIC"> AND
				PR.REQUESTERID = CUST.CUSTOMERID
		ORDER BY	PR.PURCHREQID
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add IDT Purchase Requisition Line Serial Numbers</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(PRLSWSERIALNUMID) AS MAX_ID
		FROM		SWSERIALNUMBERS
	</CFQUERY>
	<CFSET FORM.PRLSWSERIALNUMID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PRLSWSERIALNUMID" secure="NO" value="#FORM.PRLSWSERIALNUMID#">
	<CFQUERY name="AddPurchReqsLineID" datasource="#application.type#PURCHASING">
		INSERT INTO	SWSERIALNUMBERS (PRLSWSERIALNUMID, PURCHREQLINEID)
		VALUES		(#val(Cookie.PRLSWSERIALNUMID)#, #val(LookupPurchReqLines.PURCHREQLINEID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Purchase Requisition Key &nbsp; = &nbsp; #LookupPurchReqLines.PURCHREQID# &nbsp;&nbsp;Purchase Requisition Line Serial Numbers Key &nbsp; = &nbsp; #LookupPurchReqLines.PURCHREQLINEID#<BR />
				Software Serial Number Key  &nbsp; = &nbsp; #FORM.PRLSWSERIALNUMID#
			</TH>
		</TR>
	</TABLE>
	<BR clear="left" />

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqserialnums.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSPURCHREQSERNUMS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SOFTWARESERIALNUMBERS" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processpurchreqserialnums.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left">Req Number</TH>
			<TH align="left">Line Number</TH>
		</TR>
		<TR>
			<TD align="left">#LookupPurchReqs.REQNUMBER#</TD>
			<TD align="left">#LookupPurchReqLines.LINENUMBER#
			</TD>
		</TR>
		<TR>
			<TH align="left">SR</TH>
			<TH align="left">Line Description</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>#LookupPurchReqs.SERVICEREQUESTNUMBER#</TD>
			<TD align="left" nowrap>#LookupPurchReqLines.LINEDESCRIPTION#</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="SOFTWINVENTID">*Software Title - SW Key</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="REPLACESWSERIALNUM">*Replacement Serial Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="ListSoftwareInventory" value="SOFTWINVENTID" display="LOOKUPKEY" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFINPUT type="Text" name="REPLACESWSERIALNUM" id="REPLACESWSERIALNUM" value="" align="LEFT" required="No" size="16" maxlength="50" tabindex="3">
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPURCHREQSERNUMS" value="ADDLOOP" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADDLOOP" alt="ADDLOOP" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processpurchreqserialnums.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSPURCHREQSERNUMS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************************************
* The following code is the Look Up Process for Modifying Purchase Requisition Line Serial Numbers. *
*****************************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPSWSERNUM')>

		<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	DISTINCT PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PR.REQNUMBER, PR.SERVICEREQUESTNUMBER, SWSN.PURCHREQLINEID,
					PRL.LINEDESCRIPTION, PR.SERVICEREQUESTNUMBER || ' - ' || PR.REQNUMBER || ' - ' || PRL.LINENUMBER AS LOOKUPKEY
			FROM		PURCHREQLINES PRL, PURCHREQS PR, SWSERIALNUMBERS SWSN
			WHERE	PRL.PURCHREQID = PR.PURCHREQID AND
					PRL.PURCHREQLINEID = SWSN.PURCHREQLINEID
			ORDER BY	PR.SERVICEREQUESTNUMBER DESC
		</CFQUERY>

		<CFQUERY name="LookupPurchReqSerNums" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	SWSN.PRLSWSERIALNUMID, SWSN.PURCHREQLINEID, PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER,
					PR.REQNUMBER, PR.SERVICEREQUESTNUMBER, SWSN.REPLACESWSERIALNUM, SWSN.SOFTWINVENTID, SI.TITLE,
					PR.SERVICEREQUESTNUMBER || ' - ' || PR.REQNUMBER || ' - ' || PRL.LINENUMBER || ' - ' || SI.TITLE || ' - ' || SWSN.REPLACESWSERIALNUM AS LOOKUPKEY
			FROM		SWSERIALNUMBERS SWSN, PURCHREQLINES PRL, PURCHREQS PR, SOFTWMGR.SOFTWAREINVENTORY SI
			WHERE	SWSN.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID AND
					SWSN.SOFTWINVENTID = SI.SOFTWINVENTID
			ORDER BY	PR.SERVICEREQUESTNUMBER DESC
		</CFQUERY>

		<CFSET temp = ArraySet(session.PurchReqSerNumsArray, 1, 1, 0)>
		<CFSET session.SWSNArrayCounter = 0>
		<CFSET session.SWSNModLoop = 'NO'>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TD align="center"><H1>Modify/Delete IDT Purchase Requisition Line Serial Numbers Lookup</H1></TD>
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
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=#URL.PROCESS#&LOOKUPSWSERNUM=FOUND" method="POST">
			<TR>
				<TH width="30%" align="left" nowrap><LABEL for="PURCHREQLINEID">Select (Loop Thru Line Serial Numbers) SR - Requisition Number - Line Number</LABEL></TH>
			</TR>
			<TR>
				<TD width="70%" align="LEFT" valign="BOTTOM">
					<CFSELECT name="PURCHREQLINEID" id="PURCHREQLINEID" size="1" query="LookupPurchReqLines" value="PURCHREQLINEID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH width="30%" align="left" nowrap><LABEL for="PRLSWSERIALNUMID">OR (Single Line) SR - Req Number - Line Number - Title - Replacement SN</LABEL></TH>
			</TR>
			<TR>
				<TD width="70%" align="LEFT" valign="BOTTOM">
					<CFSELECT name="PRLSWSERIALNUMID" id="PRLSWSERIALNUMID" size="1" query="LookupPurchReqSerNums" value="PRLSWSERIALNUMID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>
<!--- 
*************************************************************************************************
* The following code is the Modify/Delete Process for Purchase Requisition Line Serial Numbers. *
*************************************************************************************************
 --->
		<CFIF IsDefined('FORM.PURCHREQLINEID') AND FORM.PURCHREQLINEID GT 0>
			<CFQUERY name="LookupPurchReqSerNums" datasource="#application.type#PURCHASING">
				SELECT	PRLSWSERIALNUMID, PURCHREQLINEID, REPLACESWSERIALNUM, SOFTWINVENTID
				FROM		SWSERIALNUMBERS
				WHERE	PURCHREQLINEID = <CFQUERYPARAM value="#FORM.PURCHREQLINEID#" cfsqltype="CF_SQL_NUMERIC">
				ORDER BY	PURCHREQLINEID
			</CFQUERY>

			<CFSET SWSERNUMS = #ValueList(LookupPurchReqSerNums.PRLSWSERIALNUMID)#>
			<CFSET temp = ArraySet(session.PurchReqSerNumsArray, 1, LISTLEN(SWSERNUMS), 0)>
			<CFSET session.PurchReqSerNumsArray = ListToArray(SWSERNUMS)>
			<CFSET session.SWSNModLoop = 'YES'>

		</CFIF>

		<CFIF session.SWSNModLoop EQ "YES">
			<CFSET session.SWSNArrayCounter = session.SWSNArrayCounter + 1>
			<CFSET FORM.PRLSWSERIALNUMID = session.PurchReqSerNumsArray[session.SWSNArrayCounter]>
		</CFIF>

		<CFQUERY name="GetPurchReqSerNums" datasource="#application.type#PURCHASING">
			SELECT	SWSN.PRLSWSERIALNUMID, SWSN.PURCHREQLINEID, PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER,
					PRL.LINEDESCRIPTION, PR.REQNUMBER, PR.SERVICEREQUESTNUMBER, SWSN.REPLACESWSERIALNUM, SWSN.SOFTWINVENTID, SI.TITLE,
					PR.REQNUMBER || ' - ' || PRL.LINENUMBER || ' - ' || SI.TITLE || ' - ' || SWSN.REPLACESWSERIALNUM AS LOOKUPKEY
			FROM		SWSERIALNUMBERS SWSN, PURCHREQLINES PRL, PURCHREQS PR, SOFTWMGR.SOFTWAREINVENTORY SI
			WHERE	SWSN.PRLSWSERIALNUMID = <CFQUERYPARAM value="#FORM.PRLSWSERIALNUMID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SWSN.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID AND
					SWSN.SOFTWINVENTID = SI.SOFTWINVENTID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<CFCOOKIE name="PRLSWSERIALNUMID" secure="NO" value="#GetPurchReqSerNums.PRLSWSERIALNUMID#">

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<CFIF session.SWSNModLoop EQ 'YES'>
					<TD align="center"><H1>Modify Loop IDT Purchase Requisition Line Serial Numbers</H1></TD>
				<CFELSE>
					<TD align="center"><H1>Modify/Delete IDT Purchase Requisition Line Serial Numbers</H1></TD>
				</CFIF>
			</TR>
		</TABLE>

		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Purchase Requisition Key &nbsp; = &nbsp; #GetPurchReqSerNums.PURCHREQID# &nbsp;&nbsp;Purchase Requisition Line Serial Numbers Key &nbsp; = &nbsp; #GetPurchReqSerNums.PURCHREQLINEID#<BR />
					Software Serial Number Key  &nbsp; = &nbsp; #GetPurchReqSerNums.PRLSWSERIALNUMID#
				</TH>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="left" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
<CFFORM name="SOFTWARESERIALNUMBERS" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processpurchreqserialnums.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left">Req Number</TH>
				<TH align="left">Line Number</TH>
			</TR>
			<TR>
				<TD align="left">#GetPurchReqSerNums.REQNUMBER#</TD>
				<TD align="left">
					#GetPurchReqSerNums.LINENUMBER#
				</TD>
			</TR>
			<TR>
				<TH align="left">SR</TH>
				<TH align="left">Line Description</TH>
			</TR>
			<TR>
				<TD align="left" nowrap>#GetPurchReqSerNums.SERVICEREQUESTNUMBER#</TD>
				<TD align="left" nowrap>#GetPurchReqSerNums.LINEDESCRIPTION#</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="SOFTWINVENTID">*Software Title - SW Key</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="REPLACESWSERIALNUM">*Replacement Serial Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="ListSoftwareInventory" value="SOFTWINVENTID" display="LOOKUPKEY" selected="#GetPurchReqSerNums.SOFTWINVENTID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left">
					<CFINPUT type="Text" name="REPLACESWSERIALNUM" id="REPLACESWSERIALNUM" value="#GetPurchReqSerNums.REPLACESWSERIALNUM#" align="LEFT" required="No" size="16" maxlength="50" tabindex="3">
				</TD>
			</TR>
			<TR>
		<CFIF session.SWSNModLoop EQ 'YES'>
          		<TD align="left" width="33%">
          			<INPUT type="hidden" name="PROCESSPURCHREQSERNUMS" value="MODIFYLOOP" />
               		<INPUT type="image" src="/images/buttonMODLoop.jpg" value="MODIFYLOOP" alt="Modify Loop" tabindex="4" />
          		</TD>
		<CFELSE>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPURCHREQSERNUMS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
                    </TD>
          </CFIF>
			</TR>
		<CFIF session.SWSNModLoop EQ 'YES'>
			<TR>
				<TD align="left" colspan="2">
                    	<INPUT type="image" src="/images/buttonNextRec.jpg" value="NEXTRECORD" alt="Next Record" OnClick="return setNextRecord();" tabindex="5" /><BR>
					<COM>(No change.)</COM>
				</TD>
			</TR>
		</CFIF>
		<CFIF #Client.DeleteFlag# EQ "YES" AND session.SWSNModLoop EQ "NO">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="6" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/purchreqserialnums.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="7" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="CENTER" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>