<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: deleteconfirmedswassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/03/2012 --->
<!--- Date in Production: 12/03/2012 --->
<!--- Module: Delete Confirmed Software Assignments By Date --->
<!-- Last modified by John R. Pastori on 12/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL =" pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm">
<CFSET CONTENT_UPDATED = "December 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Delete Confirmed Software Assignments By Date</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Service Requests";
	
	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	
	function popUp(url) {
		sealWin=window.open(url,"win",'toolbar=0,location=0,directories=0,status=1,menubar=1,scrollbars=1,resizable=1,width=650,height=550');
		self.name = "mainWin"; 
	}


//
</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSWASSIGN')>
	<CFSET CURSORFIELD = "document.LOOKUP.DELETEDATE.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">     
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
******************************************************************************************
* The following code is the Look Up Process for Deleting Confirmed Software Assignments. *
******************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPSWASSIGN')>

	<CFQUERY name="LookupUnassignInventBarcodes" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
          SELECT	SRSA.SRSOFTWASSIGNID, SRSA.SRID, SR.SERVICEREQUESTNUMBER, SRSA.UNASSIGN_INVENTID, UIHI.BARCODENUMBER, 
          		UIHI.BARCODENUMBER || ' - ' || SR.SERVICEREQUESTNUMBER AS LOOKUPBARCODE
          FROM		SRSOFTWASSIGNS SRSA, SERVICEREQUESTS SR, HARDWMGR.HARDWAREINVENTORY UIHI					
          WHERE	SRSA.SRSOFTWASSIGNID > 0 AND
          		SRSA.SRID = SR.SRID AND
                    SRSA.UNASSIGN_INVENTID = UIHI.HARDWAREID AND
                    CONFIRMFLAG = 'YES' AND
                    NOT CONFIRMEDDATE IS NULL
          ORDER BY	UIHI.BARCODENUMBER, SR.SERVICEREQUESTNUMBER 
     </CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Delete Confirmed Software Assignments</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>
	<BR clear="left" />

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm?LOOKUPSWASSIGN=FOUND" method="POST">
		<TR>
               <TH align="left" valign="BOTTOM"><H4><LABEL for="DELETEDATE">*Delete by Confirmed Date</LABEL></H4></TH>
               <TH align="left" valign="BOTTOM"><H4><LABEL for="UNASSIGN_INVENTID">*Or Unassigned Inventory BarCode</LABEL></H4></TH>
          </TR>
          <TR>
               <TD align="left">
                    <CFSET FORM.DELETEDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
                    <CFINPUT type="Text" name="DELETEDATE" id="DELETEDATE" value="Delete Text and Select a Date" align="LEFT" required="No" size="26" maxlength="30" tabindex="2">
                    <SCRIPT language="JavaScript">
                         new tcal ({'formname': 'LOOKUP','controlname': 'DELETEDATE'});
     
                    </SCRIPT><BR>
				<COM>(The Date Format is MM/DD/YYYY) </COM>
               </TD>
               <TD>
				<CFSELECT name="UNASSIGN_INVENTID" id="UNASSIGN_INVENTID" size="1" required="No"  tabindex="3">
                    	 <OPTION value="*">Select an BarCode - SR</OPTION>
                              <CFLOOP query="LookupUnassignInventBarcodes">
                                   <OPTION value="#UNASSIGN_INVENTID#">#LOOKUPBARCODE#</OPTION>
                              </CFLOOP>  
                    </CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
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
*********************************************************************************
* The following code is the Delete Process for Software Assignment Information. *
*********************************************************************************
 --->

	<CFIF #FORM.DELETEDATE# NEQ "Delete Text and Select a Date">
		<CFSET FORM.DELETEDATE = #DateFormat(FORM.DELETEDATE, 'dd-mmm-yyyy')#>
          
          <CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	SRSOFTWASSIGNS
               WHERE		CONFIRMFLAG = 'YES' AND
                              NOT CONFIRMEDDATE IS NULL AND
                              CONFIRMEDDATE < TO_DATE('#FORM.DELETEDATE#', 'DD-MON-YYYY')
          </CFQUERY>
          
     <CFELSEIF #FORM.UNASSIGN_INVENTID# NEQ "*">
     
     	<CFQUERY name="DeleteSoftwareAssignments" datasource="#application.type#SERVICEREQUESTS" result="DeleteResult">
               DELETE FROM	SRSOFTWASSIGNS
               WHERE		CONFIRMFLAG = 'YES' AND
                              NOT CONFIRMEDDATE IS NULL AND
                              UNASSIGN_INVENTID = #FORM.UNASSIGN_INVENTID#
          </CFQUERY>
     
     <CFELSE>
 
		<script language="JavaScript1.1">
			<!-- 
				alert("No information was entered in the Delete by Confirmed Date Or Unassigned Inventory BarCode fields. Please use one of the fields to select the appropriate records");
			//
			--> 
			
		</script>

          <meta http-equiv="Refresh" content="0; URL=/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm" />
		<CFEXIT> 
     
     </CFIF>
      
     <TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Delete Confirmed Software Assignments <BR> By Date</H1></TD>
		</TR>
	</TABLE>
	<BR clear="left" />

	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm" method="POST">
			<TD align="left">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
          <TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="CENTER">
				<H2>
                    	#DeleteResult.RecordCount# Software Assignment records were Deleted.
				</H2>
               </TH>
		</TR>
          <TR>
          	<TD align="left">&nbsp;&nbsp;</TD>
          </TR>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/deleteconfirmedswassigns.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>