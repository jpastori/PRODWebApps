<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: softwareassignmentsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/13/2012 --->
<!--- Date in Production: 07/13/2012 --->
<!--- Module: IDT Software Inventory - Assignments Report --->
<!-- Last modified by John R. Pastori on 07/13/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/softwareinventory/softwareassignmentsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 13, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Software Assignments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to IDT Software Inventory - Assignments Report";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**************************************************************************************************
* The following code is the Look Up Process for the IDT Software Inventory - Assignments Report. *
**************************************************************************************************
 --->

<CFIF NOT IsDefined("URL.PROCESS")>
	<CFQUERY name="LookupSoftwareInventoryTitles" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	DISTINCT SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME, SI.PURCHREQLINEID,
				SA.SOFTWINVENTID || ' - ' || SI.TITLE || ' - ' || SI.VERSION || ' - ' || PP.PRODUCTPLATFORMNAME AS LOOKUPKEY
		FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI, PRODUCTPLATFORMS PP
		WHERE	SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
				SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
		ORDER BY	SA.SOFTWINVENTID, SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME
	</CFQUERY>

	<CFQUERY name="LookupUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	UNITID, UNITNAME, DEPARTMENTID, UNITNAME || ' - ' || UNITID AS UNITLOOKUP
		FROM		UNITS
		WHERE	UNITID = 0 OR
				DEPARTMENTID = 8
		ORDER BY	UNITNAME
	</CFQUERY>

	<CFQUERY name="LookupSoftwareAssignmentCustomers" datasource="#application.type#HARDWARE" blockfactor="100">
		SELECT	DISTINCT HI.CUSTOMERID, CUST.FULLNAME AS LOOKUPKEY
		FROM		HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	HI.CUSTOMERID = CUST.CUSTOMERID 
		ORDER BY	LOOKUPKEY
	</CFQUERY>

	<CFQUERY name="LookupSoftwareAssignmentBarcode" datasource="#application.type#SOFTWARE" blockfactor="100">
		SELECT	DISTINCT HI.BARCODENUMBER || ' - ' || HI.DIVISIONNUMBER || ' - ' || CUST.FULLNAME AS LOOKUPKEY, HI.HARDWAREID, HI.CUSTOMERID
		FROM		SOFTWAREASSIGNMENTS SA, HARDWMGR.HARDWAREINVENTORY HI, LIBSHAREDDATAMGR.CUSTOMERS CUST
		WHERE	(SA.SOFTWASSIGNID = 0 AND
				HI.HARDWAREID = 0 AND
				CUST.CUSTOMERID = 0) OR 
				(SA.SOFTWASSIGNID > 0 AND
				SA.ASSIGNEDHARDWAREID = HI.HARDWAREID AND
				HI.CUSTOMERID = CUST.CUSTOMERID)
		ORDER BY	LOOKUPKEY
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>
				Select Data for IDT Software Inventory - Assignments Report Lookup</H1>
			</TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)<BR /><BR /></COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/softwareinventory/softwareassignmentsdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>Select one of the six (6) reports below, then click the Select Options button.</COM></TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="2" />
               </TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1:</LABEL> &nbsp;&nbsp;<LABEL for="SOFTWINVENTID">Specific Software Inventory Title</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="SOFTWINVENTID" id="SOFTWINVENTID" size="1" query="LookupSoftwareInventoryTitles" value="SOFTWINVENTID" selected="0" display="LOOKUPKEY" required="No" tabindex="4"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="5">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2: &nbsp;&nbsp;Customer Software Assignments</LABEL> <LABEL for="UNITID">By Unit</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="UNITID" id="UNITID" size="1" query="LookupUnits" value="UNITID" display="UNITLOOKUP" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="7">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;<LABEL for="ASSIGNEDCUSTID">Specific Customer Software Assignment</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ASSIGNEDCUSTID" id="ASSIGNEDCUSTID" size="1" query="LookupSoftwareAssignmentCustomers" value="CUSTOMERID" selected="0" display="LOOKUPKEY" required="no" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="9">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE4">REPORT 4: &nbsp;&nbsp;Software Assigned</LABEL> <LABEL for="HARDWAREID">to Specific Barcode</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="HARDWAREID" id="HARDWAREID" size="1" query="LookupSoftwareAssignmentBarcode" value="HARDWAREID" selected="0" display="LOOKUPKEY" required="no" tabindex="10"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="11">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE5">REPORT 5:</LABEL> &nbsp;&nbsp;<LABEL for="CURRASSIGNEDFLAG">Software Currently Assigned?</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="CURRASSIGNEDFLAG" id="CURRASSIGNEDFLAG" size="1" tabindex="12">
					<OPTION selected value="0">Select an Option</OPTION>
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE6" value="6" align="LEFT" required="No" tabindex="13">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE6">REPORT 6: &nbsp;&nbsp;Software Assignment </LABEL><LABEL for="SERIALNUMBER">By Serial Number</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="Text" name="SERIALNUMBER" id="SERIALNUMBER" value="" align="LEFT" required="No" size="50" tabindex="14"><BR />
				<COM>Enter a partial or full Serial Number.</COM>
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP">
               	<INPUT type="image" src="/images/buttonSelectOptions.jpg" value="Select Options" alt="Select Options" tabindex="15" />
               </TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="/#application.type#apps/softwareinventory/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
<CFEXIT>

<CFELSE>

<!--- 
*********************************************************************************************
* The following code is the IDT Software Inventory - Assignments Report Generation Process. *
*********************************************************************************************
 --->

	<CFSET REPORTTITLE = ''>
	<CFSET SARECORDCOUNT = 0>

	<CFIF #FORM.REPORTCHOICE# EQ 1>

		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE">
			SELECT	SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME, 
					SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.PURCHREQLINEID,
					PR.REQNUMBER, PR.PONUMBER, SI.PRODDESCRIPTION, SI.RECVDDATE,  SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT,
					SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID,
					SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID
			FROM		SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP, LIBSHAREDDATAMGR.FISCALYEARS FY,
					PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SI.SOFTWINVENTID = <CFQUERYPARAM value="#FORM.SOFTWINVENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 1:&nbsp;&nbsp;&nbsp;&nbsp;Specific Software Inventory Title <BR>#LookupSoftwareInventory.TITLE# - #LookupSoftwareInventory.SOFTWINVENTID#'>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>

		<CFQUERY name="LookupUnitCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
			SELECT	U.UNITID, U.UNITNAME, CUST.UNITID, CUST.CUSTOMERID
			FROM		UNITS U, CUSTOMERS CUST
			WHERE	U.UNITID = #val(FORM.UNITID)# AND
					U.UNITID = CUST.UNITID 
			ORDER BY	U.UNITNAME, CUST.FULLNAME
		</CFQUERY>
		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	DISTINCT SI.TITLE, SI.SOFTWINVENTID AS SOFTWAREID, SI.VERSION, CUST.CUSTOMERID, CUST.FULLNAME, SI.CATEGORYID, SA.ASSIGNEDCUSTID,
					SA.ASSIGNEDHARDWAREID, PC.PRODCATID, PC.PRODCATNAME, SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME
			FROM		SOFTWAREASSIGNMENTS SA, LIBSHAREDDATAMGR.CUSTOMERS CUST, SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP
			WHERE	SA.ASSIGNEDCUSTID IN (#ValueList(LookupUnitCustomers.CUSTOMERID)#) AND
					SA.ASSIGNEDCUSTID = CUST.CUSTOMERID AND
					SA.SOFTWINVENTID = SI.SOFTWINVENTID AND
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID
			ORDER BY	SI.TITLE, SI.VERSION, CUST.FULLNAME
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 2:&nbsp;&nbsp;&nbsp;&nbsp;Customer Software Assignments By Unit - #LookupUnitCustomers.UNITNAME#'>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>

		<CFQUERY name="LookupSoftwareAssignments" datasource="#application.type#SOFTWARE">
			SELECT	DISTINCT SA.ASSIGNEDCUSTID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.CAMPUSPHONE, U.UNITNAME
			FROM		SOFTWAREASSIGNMENTS SA, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.UNITS U
			WHERE	SA.ASSIGNEDCUSTID = <CFQUERYPARAM value="#FORM.ASSIGNEDCUSTID#" cfsqltype="CF_SQL_NUMERIC"> AND
					SA.ASSIGNEDCUSTID = CUST.CUSTOMERID AND
					CUST.UNITID = U.UNITID
			ORDER BY	CUST.FULLNAME
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 3:&nbsp;&nbsp;&nbsp;&nbsp;Specific Customer Software Assignment - #LookupSoftwareAssignments.FULLNAME#'>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>

		<CFQUERY name="LookupAssignedBarcode" datasource="#application.type#HARDWARE">
			SELECT	DISTINCT HI.HARDWAREID, HI.BARCODENUMBER, HI.EQUIPMENTTYPEID, LOC.ROOMNUMBER, HI.DIVISIONNUMBER, HI.STATEFOUNDNUMBER,
					SA.ASSIGNEDHARDWAREID, HI.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, U.UNITNAME, CUST.CAMPUSPHONE
			FROM		HARDWAREINVENTORY HI, SOFTWMGR.SOFTWAREASSIGNMENTS SA, FACILITIESMGR.LOCATIONS LOC, LIBSHAREDDATAMGR.CUSTOMERS CUST,
					LIBSHAREDDATAMGR.UNITS U
			WHERE	HI.HARDWAREID = <CFQUERYPARAM value="#FORM.HARDWAREID#" cfsqltype="CF_SQL_NUMERIC"> AND
					HI.HARDWAREID = SA.ASSIGNEDHARDWAREID AND
					HI.EQUIPMENTLOCATIONID = LOC.LOCATIONID AND
					HI.CUSTOMERID = CUST.CUSTOMERID AND
					CUST.UNITID = U.UNITID AND
					HI.EQUIPMENTTYPEID = 1
				ORDER BY	HI.BARCODENUMBER, CUST.FULLNAME
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 4:&nbsp;&nbsp;&nbsp;&nbsp;Software Assigned to Specific Barcode - #LookupAssignedBarcode.BARCODENUMBER#'>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 5>

		<CFSET REPORTTITLE = 'REPORT 5:&nbsp;&nbsp;&nbsp;&nbsp;Software Currently Assigned?&nbsp;&nbsp; - &nbsp;&nbsp;#FORM.CURRASSIGNEDFLAG#'>
		<CFQUERY name="LookupSoftwareInventory" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	DISTINCT SI.SOFTWINVENTID, SI.CREATIONDATE, SI.TITLE, SI.VERSION, SI.CATEGORYID, PC.PRODCATID, PC.PRODCATNAME,
					SI.PRODPLATFORMID, PP.PRODUCTPLATFORMNAME, SI.FISCALYEARID, FY.FISCALYEARID, FY.FISCALYEAR_4DIGIT, SI.PURCHREQLINEID,
					PR.REQNUMBER, PR.PONUMBER, SI.PRODDESCRIPTION, SI.RECVDDATE, SI.PRODSTATUSID, SI.PHONESUPPORT, SI.WEBSUPPORT,
					SI.FAXSUPPORT, SI.SUPPORTCOMMENTS, SI.QTYORDERED, SI.LICENSETYPEID, SI.QTYLICENSED, SI.UPGRADESTATUSID, SI.TOSSSTATUSID,
					SI.CDKEY, SI.PRODUCTID, SI.MANUFWARRVENDORID
			FROM		SOFTWAREINVENTORY SI, PRODUCTCATEGORIES PC, PRODUCTPLATFORMS PP,
					LIBSHAREDDATAMGR.FISCALYEARS FY, PURCHASEMGR.PURCHREQLINES PRL, PURCHASEMGR.PURCHREQS PR
			WHERE	SI.SOFTWINVENTID > 0 AND
					SI.CATEGORYID = PC.PRODCATID AND
					SI.PRODPLATFORMID = PP.PRODUCTPLATFORMID AND
					SI.FISCALYEARID = FY.FISCALYEARID AND
					SI.PURCHREQLINEID = PRL.PURCHREQLINEID AND
					PRL.PURCHREQID = PR.PURCHREQID
			ORDER BY	SI.TITLE, SI.VERSION, PP.PRODUCTPLATFORMNAME
		</CFQUERY>

	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 6>

		<CFQUERY name="LookupSoftWAssignSerNums" datasource="#application.type#SOFTWARE" blockfactor="100">
			SELECT	DISTINCT SA.SOFTWINVENTID, SA.SERIALNUMBER
			FROM		SOFTWAREASSIGNMENTS SA, SOFTWAREINVENTORY SI
			WHERE	SA.SERIALNUMBER LIKE ('%#FORM.SERIALNUMBER#%')
			ORDER BY	SA.SOFTWINVENTID
		</CFQUERY>

		<CFSET REPORTTITLE = 'REPORT 6:&nbsp;&nbsp;Software Assignment By Serial Number - #FORM.SERIALNUMBER#'>

	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>IDT Software Inventory - Assignments Report</H1>
				<H2>#REPORTTITLE#</H2>
			</TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="center" border="0">
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareassignmentsdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<CFINCLUDE template="sadbreportformat1.cfm">
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFINCLUDE template="sadbreportformat2.cfm">
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<CFINCLUDE template="sadbreportformat3.cfm">
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 4>
			<CFINCLUDE template="sadbreportformat4.cfm">
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 5>
			<CFINCLUDE template="sadbreportformat5.cfm">
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# EQ 6>
			<CFINCLUDE template="sadbreportformat6.cfm">
		</CFIF>
		<TR>
			<TH align="CENTER" colspan="9">
				<H2>#SARECORDCOUNT# Software Inventory Assignment records were selected.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/softwareinventory/softwareassignmentsdbreport.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="9">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>