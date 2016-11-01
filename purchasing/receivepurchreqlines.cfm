<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: receivepurchreqlines.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Receive Items for IDT Purchase Requisition Lines--->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/receivepurchreqlines.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Receive Items for IDT Purchase Requisition Lines</TITLE>
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


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>
<CFOUTPUT>
<CFSET CURSORFIELD = "document.RECEIVEPURCREQLINES1.ALLLINESDATE.focus()">
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
***********************************************************************************
* The following code is the Receive Items Process for Purchase Requisition Lines. *
***********************************************************************************
 --->

<CFSET FORM.PURCHREQID = #URL.PURCHREQID#>

<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
	SELECT	PRL.PURCHREQLINEID, PRL.PURCHREQID, PRL.LINENUMBER, PRL.LINEQTY, PRL.LINEDESCRIPTION, PRL.RECVDDATE
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
<CFSET SESSION.LineCounter = 0>


<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Receive IDT Purchase Requisition Lines</H1></TD>
	</TR>
</TABLE>

<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center"><H4>*Either enter a single date in the All Lines Date Field or enter a Received Date for a specific line .</H4></TH>
	</TR>
	<TR>
		<TH align= "CENTER">
			Purchase Requisition Key &nbsp; = &nbsp; <H5>#LookupPurchReqLines.PURCHREQID#</H5> &nbsp;&nbsp;Purchase Requisition Lines Key &nbsp; = &nbsp; <H5>#LookupPurchReqLines.PURCHREQLINEID#</H5>
		</TH>
	</TR>
</TABLE>

<TABLE width="100%" align="left" border="0">
	<TR>
		<TD align="left" colspan="4">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel"
			onClick="window.close();" 
			tabindex="1" />
		</TD>
	</TR>
<CFFORM name="RECEIVEPURCREQLINES1" action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH align="CENTER" valign="TOP" NOWRAP><LABEL for="ALLLINESDATE">All Lines Date</LABEL></TH>
		<TD align="left" COLSPAN="3">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'RECEIVEPURCREQLINES1','controlname': 'ALLLINESDATE'});

			</SCRIPT>
			<CFINPUT type="Text" name="ALLLINESDATE" id="ALLLINESDATE" value="#DATEFORMAT(NOW(), 'mm/dd/yyyy')#" align="LEFT" required="No" size="10" tabindex="2">
			<BR>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<COM>MM/DD/YYYYY </COM><BR />
			<COM>(Please click the "RECEIVE ALL LINES" Button to assign the date in this field to all the Line records.)</COM>
		</TD>
	</TR>
	<TR>
		<TD align="left" colspan="4">
          	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="RECEIVE ALL LINES" />
               <INPUT type="image" src="/images/buttonRecvPurchReqLines.jpg" value="RECEIVE ALL LINES" alt="Receive All Lines" tabindex="3" />
		</TD>

	<TR>
		<TD align="LEFT" COLSPAN="4">
			<HR>
		</TD>
	</TR>
</CFFORM>
<CFFORM name="RECEIVEPURCREQLINES2" action="/#application.type#apps/purchasing/processpurchreqlineinfo.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH WIDTH="10%" align="CENTER" valign="bottom">Line Number</TH>
		<TH WIDTH="10%" align="CENTER" valign="bottom">Quantity</TH>
		<TH WIDTH="50%" align="LEFT" valign="bottom">Line Description</TH>
		<TH WIDTH="30%" align="CENTER" valign="bottom"><LABEL for="RECVDDATE">Received Date</LABEL></TH>
	</TR>
	<CFLOOP query="LookupPurchReqLines">
		<CFSET SESSION.LineCounter = SESSION.LineCounter + 1>
	<TR>
		<TD WIDTH="10%" align="CENTER" valign="TOP">
			#LookupPurchReqLines.LINENUMBER#
		</TD>
		<TD WIDTH="10%" align="CENTER" valign="TOP">
			#LookupPurchReqLines.LINEQTY#
		</TD>
		<TD WIDTH="50%" align="LEFT" valign="TOP">
			#LookupPurchReqLines.LINEDESCRIPTION#
		</TD>
		<TD WIDTH="30%" align="CENTER" valign="TOP">
			<SCRIPT language="JavaScript">
				new tcal ({'formname': 'RECEIVEPURCREQLINES2','controlname': 'RECVDDATE#SESSION.LineCounter#'});

			</SCRIPT>
			<CFSET TAB = #SESSION.LineCounter# + 3>
			<CFINPUT type="Text" name="RECVDDATE#SESSION.LineCounter#" id="RECVDDATE" value="#LookupPurchReqLines.RECVDDATE#" align="LEFT" required="No" size="10" tabindex="#val(TAB)#">
			<BR>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<COM>MM/DD/YYYYY </COM>
		</TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD align="LEFT" COLSPAN="4">
			<HR>
		</TD>
	</TR>
	<TR>
		<TD align="left" colspan="4">
			<CFSET TAB = #TAB# + 1>
          	<INPUT type="hidden" name="PROCESSPURCHREQLINES" value="RECEIVE SPECIFIC LINES" />
               <INPUT type="image" src="/images/buttonRecvPurchReqLines.jpg" value="RECEIVE SPECIFIC LINES" alt="Receive Specific Lines" tabindex="#val(TAB)#" /><BR><BR><BR>
		</TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="4">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left" colspan="3">
			<CFSET TAB = #TAB# + 1>
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel"
			onClick="window.close();" 
			tabindex="#val(TAB)#" />
		</TD>
	</TR>
	<TR>
		<TD align="CENTER" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</BODY>
</CFOUTPUT>
</HTML>