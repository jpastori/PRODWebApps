<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unitliaisons.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Unit Liaisons --->
<!-- Last modified by John R. Pastori on 02/03/2014 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/unitliaisons.cfm">
<CFSET CONTENT_UPDATED = "February 03, 2014">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Unit Liaisons</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Unit Liaisons</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.UNITLIAISONS.UNITID.selectedIndex == "0") {
			alertuser (document.UNITLIAISONS.UNITID.name +  ",  A Unit Name MUST be chosen!");
			document.UNITLIAISONS.UNITID.focus();
			return false;
		}

		if (document.UNITLIAISONS.ALTERNATE_CONTACTID.selectedIndex == "0") {
			alertuser (document.UNITLIAISONS.ALTERNATE_CONTACTID.name +  ",  A Unit Liaison Name MUST be chosen!");
			document.UNITLIAISONS.ALTERNATE_CONTACTID.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.UNITLIAISONID.selectedIndex == "0") {
			alertuser ("An Unit Liaison MUST be selected!");
			document.LOOKUP.UNITLIAISONID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.UNITLIAISONS.PROCESSUNITLIAISONS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPUNITLIAISON') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.UNITLIAISONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.UNITLIAISONS.UNITID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListUnits" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	UNITID, UNITNAME
	FROM		UNITS
	WHERE	(UNITID = 0) OR
			(GROUPID IN (1,2,3,4,6) AND
               ACTIVEUNIT = 'YES')
	ORDER BY	UNITNAME
</CFQUERY>

<CFQUERY name="ListAltContacts" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUST.CUSTOMERID,CUST.EMAIL, CUST.FAX, CUST.FULLNAME, CUST.UNITID, U.GROUPID, CUST.ACTIVE
	FROM		CUSTOMERS CUST, UNITS U
	WHERE	(CUST.CUSTOMERID = 0 AND
			CUST.UNITID = U.UNITID) OR	
			(CUST.UNITID = U.UNITID AND
			U.GROUPID IN (1,2,3,4,6) AND
			CUST.ACTIVE = 'YES')	
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<CFQUERY name="ListUnitLiaisons" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	UL.UNITLIAISONID, UL.UNITID, U.UNITID, U.UNITNAME, UL.ALTERNATE_CONTACTID, CUST.CUSTOMERID, CUST.FULLNAME,
     		U.UNITNAME || ' - ' || CUST.FULLNAME AS KEYFINDER
	FROM		UNITLIAISON UL, LIBSHAREDDATAMGR.UNITS U, LIBSHAREDDATAMGR.CUSTOMERS CUST
     WHERE	UL.UNITID = U.UNITID AND
     		UL.ALTERNATE_CONTACTID = CUST.CUSTOMERID
     ORDER BY	U.UNITNAME, CUST.FULLNAME
</CFQUERY>


<!--- 
************************************************************
* The following code is the ADD Process for Unit Liaisons. *
************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Unit Liaisons</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(UNITLIAISONID) AS MAX_ID
		FROM		UNITLIAISON
	</CFQUERY>
	<CFSET FORM.UNITLIAISONID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="UNITLIAISONID" secure="NO" value="#FORM.UNITLIAISONID#">
	<CFQUERY name="AddUnitLiaisonID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	UNITLIAISON (UNITLIAISONID)
		VALUES		(#val(Cookie.UNITLIAISONID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Unit Liaison Key &nbsp; = &nbsp; #FORM.UNITLIAISONID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processunitliaisons.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSUNITLIAISONS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="UNITLIAISONS" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processunitliaisons.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="UNITID">*Unit Name</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="ALTERNATE_CONTACTID">*Alternate Contact</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
               	<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="0" required="No" tabindex="2"></CFSELECT>
               </TD>
			<TD align="left">
               	<CFSELECT name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListAltContacts" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="3"></CFSELECT>
               </TD>
		</TR>
		<TR>
		<TD align="left">
               	<INPUT type="hidden" name="PROCESSUNITLIAISONS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processunitliaisons.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSUNITLIAISONS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Unit Liaisons. *
***************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Unit Liaisons</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPUNITLIAISON')>
		<TR>
			<TH align="center">Unit Liaison Key &nbsp; = &nbsp; #FORM.UNITLIAISONID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPUNITLIAISON')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=#URL.PROCESS#&LOOKUPUNITLIAISON=FOUND" method="POST">
			<TR>
				<TH align="left"><H4><LABEL for="UNITLIAISONID">*Unit Name</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="UNITLIAISONID" id="UNITLIAISONID" size="1" query="ListUnitLiaisons" value="UNITLIAISONID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                     </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
****************************************************************************
* The following code is the Modify and Delete Processes for Unit Liaisons. *
****************************************************************************
 --->

		<CFQUERY name="GetUnitLiaisons" datasource="#application.type#SERVICEREQUESTS">
			SELECT	UNITLIAISONID, UNITID, ALTERNATE_CONTACTID
			FROM		UNITLIAISON
			WHERE	UNITLIAISONID = <CFQUERYPARAM value="#FORM.UNITLIAISONID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	UNITID, ALTERNATE_CONTACTID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processunitliaisons.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="UNITLIAISONID" secure="NO" value="#FORM.UNITLIAISONID#">
				<TH align="left"><H4><LABEL for="UNITID">*Unit Name</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="ALTERNATE_CONTACTID">*Alternate Contact:</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
                    	<CFSELECT name="UNITID" id="UNITID" size="1" query="ListUnits" value="UNITID" display="UNITNAME" selected="#GetUnitLiaisons.UNITID#" required="No" tabindex="2"></CFSELECT>
                    </TD>
				<TD align="left">
                    	<CFSELECT name="ALTERNATE_CONTACTID" id="ALTERNATE_CONTACTID" size="1" query="ListAltContacts" value="CUSTOMERID" display="FULLNAME" selected="#GetUnitLiaisons.ALTERNATE_CONTACTID#" required="No" tabindex="3"></CFSELECT>
                    </TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSUNITLIAISONS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
                    </TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="5" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/unitliaisons.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>