<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: equipdescrinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Add/Modify/Delete Information to Library IDT Hardware Inventory - Equipment Description --->
<!-- Last modified by John R. Pastori on v using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/hardwareinventory/equipdescrinfo.cfm">
<CFSET CONTENT_UPDATED = "July 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Hardware Inventory - Equipment Description</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Hardware Inventory - Equipment Description</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Hardware Inventory";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.EQUIPDESCRIPTION.EQUIPMENTDESCRIPTION.value == "") {
			alertuser (document.EQUIPDESCRIPTION.EQUIPMENTDESCRIPTION.name +  ",  An Equipment Description MUST be entered!");
			document.EQUIPDESCRIPTION.EQUIPMENTDESCRIPTION.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.EQUIPDESCRID.selectedIndex == "0") {
			alertuser ("An Equipment Description MUST be selected!");
			document.LOOKUP.EQUIPDESCRID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.EQUIPDESCRIPTION.PROCESSEQUIPDESCR.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPEQUIPDESCR') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.EQUIPDESCRID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.EQUIPDESCRIPTION.EQUIPMENTDESCRIPTION.focus()">
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

<CFQUERY name="ListEquipmentDescriptions" datasource="#application.type#HARDWARE" blockfactor="100">
	SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE
	FROM		EQUIPMENTDESCRIPTION
	ORDER BY	EQUIPMENTDESCRIPTION
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 300 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
********************************************************************
* The following code is the ADD Process for Equipment Description. *
********************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Hardware Inventory - Equipment Description</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#HARDWARE">
		SELECT	MAX(EQUIPDESCRID) AS MAX_ID
		FROM		EQUIPMENTDESCRIPTION
	</CFQUERY>
	<CFSET FORM.EQUIPDESCRID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="EQUIPDESCRID" secure="NO" value="#FORM.EQUIPDESCRID#">
	<CFQUERY name="AddEquipmentDescriptionsID" datasource="#application.type#HARDWARE">
		INSERT INTO	EQUIPMENTDESCRIPTION (EQUIPDESCRID)
		VALUES		(#val(Cookie.EQUIPDESCRID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Equipment Description Key &nbsp; = &nbsp; #FORM.EQUIPDESCRID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processequipdescrinfo.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSEQUIPDESCR" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="EQUIPDESCRIPTION" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processequipdescrinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap colspan="2"><H4><LABEL for="EQUIPMENTDESCRIPTION">*Equipment Description</LABEL></H4></TH>
          </TR>
		<TR>
			<TD align="left" colspan="2"><CFINPUT type="Text" name="EQUIPMENTDESCRIPTION" id="EQUIPMENTDESCRIPTION" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
          <TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="3"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
          <TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSEQUIPDESCR" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/processequipdescrinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSEQUIPDESCR" value="CANCELADD" />
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
***********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Equipment Description. *
***********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Information to IDT Hardware Inventory - Equipment Description</H1></TH>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPEQUIPDESCR')>
		<TR>
			<TH align="center"><B>Equipment Description Key &nbsp; = &nbsp; #FORM.EQUIPDESCRID#</B></TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPEQUIPDESCR')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPEQUIPDESCR=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap>
					<H4><LABEL for="EQUIPDESCRID">*Equipment Description:</LABEL></H4>
				</TH>
				<TD align="left" width="70%">
					<CFSELECT name="EQUIPDESCRID" id="EQUIPDESCRID" size="1" query="ListEquipmentDescriptions" value="EQUIPDESCRID" display="EQUIPMENTDESCRIPTION" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/hardwareinventory/index.cfm?logout=No" method="POST">
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
************************************************************************************
* The following code is the Modify and Delete Processes for Equipment Description. *
************************************************************************************
 --->

		<CFQUERY name="GetEquipmentDescriptions" datasource="#application.type#HARDWARE">
			SELECT	EQUIPDESCRID, EQUIPMENTDESCRIPTION, MODIFIEDBYID, MODIFIEDDATE
			FROM		EQUIPMENTDESCRIPTION
			WHERE	EQUIPDESCRID = <CFQUERYPARAM value="#FORM.EQUIPDESCRID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	EQUIPMENTDESCRIPTION
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
	<CFFORM action="/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
	</CFFORM>
			</TR>
	<CFFORM name="EQUIPDESCRIPTION" onsubmit="return validateReqFields();" action="/#application.type#apps/hardwareinventory/processequipdescrinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="EQUIPDESCRID" secure="NO" value="#FORM.EQUIPDESCRID#">
				<TH align="left" nowrap colspan="2"><H4><LABEL for="EQUIPMENTDESCRIPTION">*Equipment Description</LABEL></H4></TH>
               </TR>
			<TR>
				<TD align="left" colspan="2">
                    	<CFINPUT type="Text" name="EQUIPMENTDESCRIPTION" id="EQUIPMENTDESCRIPTION" value="#GetEquipmentDescriptions.EQUIPMENTDESCRIPTION#" align="LEFT" required="No" size="50" tabindex="2">
                    </TD>
			</TR>
               <TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="3"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
               <TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSEQUIPDESCR" value="MODIFY" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="5" />
                    </TD>
			</TR>
			</CFIF>
	</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
	<CFFORM action="/#application.type#apps/hardwareinventory/equipdescrinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
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