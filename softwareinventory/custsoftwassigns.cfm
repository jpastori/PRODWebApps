<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custsoftwassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - Assignments By Customer  Process --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/custsoftwassigns.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Assignments By Customer  Process</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Inventory - Assignments By Customer";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}
	
	function validateLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0") {
			alertuser ("A Customer - Inventory Barcode Name MUST be selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.HARDWAREID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*******************************************************************************************************
* The following code is the Look Up Process for the IDT Software Inventory - Assignments By Customer. *
*******************************************************************************************************
 --->

<CFIF NOT IsDefined("URL.PROCESS")>

	<CFQUERY name="LookupSoftwAssignCusts" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	HI.HARDWAREID, HI.CUSTOMERID, HI.EQUIPMENTTYPEID, CUST.FULLNAME || ' - ' || HI.BARCODENUMBER AS LOOKUPKEY
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(HI.CUSTOMERID = CUST.CUSTOMERID) AND
          		((HI.HARDWAREID = 0 AND
           		 HI.CUSTOMERID = 0 AND
          		 HI.EQUIPMENTTYPEID = 0) OR
          		(HI.HARDWAREID > 0 AND
           		 HI.CUSTOMERID > 0  AND
          		 HI.EQUIPMENTTYPEID = 1))
		ORDER BY	LOOKUPKEY
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>
				Select Customer for IDT Software Inventory - <BR /> Assignments By Customer Process</H1>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/custsoftwassigns.cfm?PROCESS=REPORT" method="POST">
		<TR>
			<TH align="left" valign="TOP"><LABEL for="HARDWAREID">Lookup Customer & Hardware Barcode</LABEL></TH>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupSoftwAssignCusts" value="HARDWAREID" selected="0" display="LOOKUPKEY" required="no" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectCustomer.jpg" value="Select Customer" alt="Select Customer" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
<CFEXIT>

<CFELSE>

<!--- 
***************************************************************************************
* The following code is the IDT Software Inventory - Assignments By Customer Process. *
***************************************************************************************
 --->
  	
	<CFSET SARECORDCOUNT = 0>
     <CFSET TABCOUNT = 0>
     
     <CFIF IsDefined ('URL.ASSIGNEDCUSTID')>
     	<CFSET FORM.ASSIGNEDCUSTID = #URL.ASSIGNEDCUSTID#>
     </CFIF>
     <CFIF IsDefined ('URL.HARDWAREID')>
     	<CFSET FORM.HARDWAREID = #URL.HARDWAREID#>
     </CFIF>	
 
	<CFQUERY name="LookupCustSoftwAssignDetail" datasource="#application.type#SOFTWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTLOCATIONID, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER, CUST.CUSTOMERID, CUST.FULLNAME,  
				SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME,  
				SA.SERIALNUMBER, LOC.LOCATIONID, LOC.ROOMNUMBER, SA.ASSIGNEDHARDWAREID, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, 
				PR.PONUMBER, SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SA.SOFTWASSIGNID
		FROM		HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI,
				PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.FISCALYEARS FY,
				PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.HARDWAREID = SA.ASSIGNEDHARDWAREID AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
				SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.CATEGORYID = PC.PRODCATID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.FISCALYEARID = FY.FISCALYEARID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID
		ORDER BY	SI.TITLE, HI.BARCODENUMBER
	</CFQUERY>
     
     <TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Software Inventory - Assignments By Customer Process <BR /> For Customer #LookupCustSoftwAssignDetail.FULLNAME# (#LookupCustSoftwAssignDetail.CUSTOMERID# and Barcode #LookupCustSoftwAssignDetail.BARCODENUMBER#) </H1>
			</TD>
		</TR>
	</TABLE>
     
     <CFSET TABCOUNT = TABCOUNT + 1>

     <TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/softwareinventory/custsoftwassigns.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="#TABCOUNT#" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>

	<CFLOOP query="LookupCustSoftwAssignDetail">
		<CFSET SARECORDCOUNT = #SARECORDCOUNT# + 1>
          <CFSET TABCOUNT = TABCOUNT + 1>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processcustsoftwassigns.cfm?SOFTWASSIGNID=#LookupCustSoftwAssignDetail.SOFTWASSIGNID#&ASSIGNEDCUSTID=#LookupCustSoftwAssignDetail.CUSTOMERID#&HARDWAREID=#LookupCustSoftwAssignDetail.HARDWAREID#" method="POST">
			<TD align="LEFT" valign="TOP">
               	<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="DELETE/ADD" />
               	<INPUT type="image" src="/images/buttonDeleteAdd.jpg" value="DELETE/ADD" alt="Delete/Add" tabindex="#TABCOUNT#" />
			</TD>
</CFFORM>
			<TH align="LEFT">Title - #LookupCustSoftwAssignDetail.SOFTWINVENTID#(#LookupCustSoftwAssignDetail.SOFTWASSIGNID#)</TH>
			<TH align="center" valign="BOTTOM">Version</TH>
			<TH align="center" valign="BOTTOM">Category</TH>
			<TH align="center" valign="BOTTOM">Platform</TH>
			<TH align="center" valign="BOTTOM">Loc</TH>
			<TH align="center" valign="BOTTOM">Serial Number</TH>
		</TR>
		<TR>
     	<CFSET TABCOUNT = TABCOUNT + 1>
<CFFORM action="/#application.type#apps/softwareinventory/processcustsoftwassigns.cfm?SOFTWASSIGNID=#LookupCustSoftwAssignDetail.SOFTWASSIGNID#&ASSIGNEDCUSTID=#LookupCustSoftwAssignDetail.CUSTOMERID#&HARDWAREID=#LookupCustSoftwAssignDetail.HARDWAREID#" method="POST">
			<TD align="LEFT" valign="TOP">
               	<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="DELETE" />
               	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" tabindex="#TABCOUNT#" />
			</TD>
</CFFORM>
               <TD align="LEFT" valign="TOP" nowrap><DIV>#LookupCustSoftwAssignDetail.TITLE#</DIV></TD>
               <TD align="center" valign="TOP" nowrap><DIV>#LookupCustSoftwAssignDetail.VERSION#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.PRODCATNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.PRODUCTPLATFORMNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.ROOMNUMBER#</DIV></TD>
               <TD align="center" valign="TOP" nowrap><DIV>#LookupCustSoftwAssignDetail.SERIALNUMBER#</DIV></TD>
          </TR>
          <TR>
          	<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
               <TH align="LEFT" valign="BOTTOM">Requisition Number</TH>
               <TH align="center" valign="BOTTOM">Purchase Order Number</TH>
               <TH align="center" valign="BOTTOM">Fiscal Year</TH>
               <TH align="center" valign="BOTTOM">State Found Number</TH>
               <TH align="center" valign="BOTTOM">CPU Assigned</TH>
               <TH align="center" valign="BOTTOM">Division Number</TH>
          </TR>
          <TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
               <TD align="LEFT" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.REQNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.PONUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.FISCALYEAR_4DIGIT#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.STATEFOUNDNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.BARCODENUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustSoftwAssignDetail.DIVISIONNUMBER#</DIV></TD>
          </TR>
          <TR>
               <TD align="CENTER" colspan="7"><HR /></TD>
          </TR>
          </CFLOOP>
          <TR>
               <TD align="CENTER" colspan="7"><HR size="5" noshade /></TD>
          </TR>
		<TR>
			<TH align="CENTER" colspan="7">
				<H2>#SARECORDCOUNT# Software Inventory Assignment records were selected.</H2>
			</TH>
		</TR>
		<CFSET TABCOUNT = TABCOUNT + 1>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/custsoftwassigns.cfm" method="POST">
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="#TABCOUNT#" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)<BR /><BR /></COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="8">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>