<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: custsoftwimageassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: IDT Software Inventory - Image Assignments By Customer  Process --->
<!-- Last modified by John R. Pastori on 07/17/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm">
<CFSET CONTENT_UPDATED = "July 17, 2012">

<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>IDT Software Inventory - Image Assignments By Customer  Process</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Inventory - Image Assignments By Customer";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}
	
	function validateLookupField() {
		if (document.LOOKUP.HARDWAREID.selectedIndex == "0") {
			alertuser ("A Customer - Inventory Barcode Name MUST be selected!");
			document.LOOKUP.HARDWAREID.focus();
			return false;
		}
		
		if (document.LOOKUP.IMAGEID.selectedIndex == "0") {
			alertuser ("An Image Name MUST be selected!");
			document.LOOKUP.IMAGEID.focus();
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
*************************************************************************************************************
* The following code is the Look Up Process for the IDT Software Inventory - Image Assignments By Customer. *
*************************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

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
	
	<CFQUERY name="ListImages" datasource="#application.type#SOFTWARE" blockfactor="16">
		SELECT	IMAGEID, IMAGENAME
		FROM		IMAGES
		ORDER BY	IMAGENAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>
				Select Customer for IDT Software Inventory - <BR /> Image Assignments By Customer Process</H1>
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
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm?PROCESS=REPORT" method="POST">
		<TR>
			<TH align="left" valign="TOP"><LABEL for="HARDWAREID">Lookup Customer & Hardware Barcode</LABEL></TH>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupSoftwAssignCusts" value="HARDWAREID" selected="0" display="LOOKUPKEY" required="no" tabindex="2"></CFSELECT>
			</TD>
		</TR>
          <TR>
               <TD align="left">&nbsp;&nbsp;</TD>
          </TR>
          <TR>
			<TH align="left" nowrap><LABEL for="IMAGEID">Image</LABEL></TH>
		</TR>
		<TR>
               <TD align="left">
				<CFSELECT name="IMAGEID" id="IMAGEID" size="1" query="ListImages" value="IMAGEID" display="IMAGENAME" required="No" tabindex="3"></CFSELECT>
			</TD>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectCustomer.jpg" value="Select Customer" alt="Select Customer" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
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
*********************************************************************************************
* The following code is the IDT Software Inventory - Image Assignments By Customer Process. *
*********************************************************************************************
 --->
  	
	<CFSET SIRECORDCOUNT = 0>
     
     <CFIF IsDefined ('URL.ASSIGNEDCUSTID')>
     	<CFSET FORM.ASSIGNEDCUSTID = #URL.ASSIGNEDCUSTID#>
     </CFIF>
     <CFIF IsDefined ('URL.HARDWAREID')>
     	<CFSET FORM.HARDWAREID = #URL.HARDWAREID#>
     </CFIF>	
 
	<CFQUERY name="LookupCustHardware" datasource="#application.type#SOFTWARE">
		SELECT	HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTLOCATIONID, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER, CUST.CUSTOMERID, CUST.FULLNAME,
          		LOC.LOCATIONID, LOC.ROOMNUMBER
		FROM		HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST, FACILITIESMGR.LOCATIONS LOC
		WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
				HI.CUSTOMERID = CUST.CUSTOMERID AND
				HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID
	</CFQUERY>
     
     <CFQUERY name="ListSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.PRODPLATFORMID, SI.PRODDESCRIPTION, SI.PURCHREQLINEID,
				SI.SOFTWINVENTID, SI.TITLE, SI.VERSION, SI.CATEGORYID, SI.IMAGEKEYS, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID, 
				PP.PRODUCTPLATFORMNAME, SI.PRODDESCRIPTION, SI.PURCHREQLINEID, PR.REQNUMBER, PR.PONUMBER, SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT
		FROM		SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY,
				PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
          WHERE	SI.CATEGORYID = PC.PRODCATID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
				SI.FISCALYEARID = FY.FISCALYEARID AND
				SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
				PRL.PURCHREQID = PR.PURCHREQID 
		ORDER BY	SI.TITLE
	</CFQUERY>
     
     <CFQUERY name="LookupImages" datasource="#application.type#SOFTWARE" blockfactor="16">
		SELECT	IMAGEID, IMAGENAME
		FROM		IMAGES
          WHERE	IMAGEID = <CFQUERYPARAM value="#FORM.IMAGEID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	IMAGENAME
	</CFQUERY>
     
     <TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Software Inventory - Image Assignments By Customer Process <BR /> 
                        For Customer #LookupCustHardware.FULLNAME# (#LookupCustHardware.CUSTOMERID# and Barcode #LookupCustHardware.BARCODENUMBER#) </H1>
			</TD>
		</TR>
	</TABLE>

     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>

	<CFSET URL.SOFTWAREIDS = ''>
	<CFLOOP query="ListSoftwareInventory">
		
          <CFIF LISTFIND(ListSoftwareInventory.IMAGEKEYS, FORM.IMAGEID) NEQ 0>
          	<CFSET SIRECORDCOUNT = #SIRECORDCOUNT# + 1>
               <CFSET URL.SOFTWAREIDS = ListAppend(URL.SOFTWAREIDS,#ListSoftwareInventory.SOFTWINVENTID#)>
                         
		<TR>
			<TH align="LEFT">Title - #ListSoftwareInventory.SOFTWINVENTID#</TH>
			<TH align="center" valign="BOTTOM">Version</TH>
			<TH align="center" valign="BOTTOM">Category</TH>
			<TH align="center" valign="BOTTOM">Platform</TH>
			<TH align="center" valign="BOTTOM">Image</TH>
			<TH align="center" valign="BOTTOM">Loc</TH>
		</TR>
		<TR>
               <TD align="LEFT" valign="TOP" nowrap><DIV>#ListSoftwareInventory.TITLE#</DIV></TD>
               <TD align="center" valign="TOP" nowrap><DIV>#ListSoftwareInventory.VERSION#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PRODCATNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PRODUCTPLATFORMNAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupImages.IMAGENAME#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustHardware.ROOMNUMBER#</DIV></TD>
          </TR>
          <TR>
               <TH align="LEFT" valign="BOTTOM">Requisition Number</TH>
               <TH align="center" valign="BOTTOM">Purchase Order Number</TH>
               <TH align="center" valign="BOTTOM">Fiscal Year</TH>
               <TH align="center" valign="BOTTOM">State Found Number</TH>
               <TH align="center" valign="BOTTOM">CPU Assigned</TH>
               <TH align="center" valign="BOTTOM">Division Number</TH>
          </TR>
          <TR>
               <TD align="LEFT" valign="TOP"><DIV>#ListSoftwareInventory.REQNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.PONUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListSoftwareInventory.FISCALYEAR_4DIGIT#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustHardware.STATEFOUNDNUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustHardware.BARCODENUMBER#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#LookupCustHardware.DIVISIONNUMBER#</DIV></TD>
          </TR>
          <TR>
               <TD align="CENTER" colspan="6"><HR /></TD>
          </TR>
          </CFIF>
 	</CFLOOP>
     	<TR>
<CFFORM action="/#application.type#apps/softwareinventory/processcustsoftwassigns.cfm?SOFTWAREIDS=#URL.SOFTWAREIDS#&IMAGEID=#LookupImages.IMAGEID#&ASSIGNEDCUSTID=#LookupCustHardware.CUSTOMERID#&HARDWAREID=#LookupCustHardware.HARDWAREID#" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="hidden" name="PROCESSSOFTWAREASSIGNMENTS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
          <TR>
               <TD align="CENTER" colspan="6"><HR size="5" noshade /></TD>
          </TR>
          
		<TR>
			<TH align="CENTER" colspan="6">
				<H2>#SIRECORDCOUNT# Software Inventory Records were selected.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/custsoftwimageassigns.cfm" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="3" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)<BR /><BR /></COM>
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