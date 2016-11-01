<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: unitofmeasure.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Purchasing - Unit Of Measure --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/unitofmeasure.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Purchasing - Unit Of Measure</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Purchasing - Unit Of Measure</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.UNITOFMEASURE.MEASURENAME.value == "" || document.UNITOFMEASURE.MEASURENAME.value == " ") {
			alertuser (document.UNITOFMEASURE.MEASURENAME.name +  ",  A Unit Of Measure Name MUST be entered!");
			document.UNITOFMEASURE.MEASURENAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.UNITOFMEASUREID.selectedIndex == "0") {
			alertuser ("A Unit Of Measure Name MUST be selected!");
			document.LOOKUP.UNITOFMEASUREID.focus();
			return false;
		}
	}
		
	
	function setDelete() {
		document.UNITOFMEASURE.PROCESSUNITOFMEASURE.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPUNITOFMEASURE') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.UNITOFMEASUREID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.UNITOFMEASURE.UNITOFMEASURENAME.focus()">
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

<CFQUERY name="ListUnitOfMeasure" datasource="#application.type#PURCHASING" blockfactor="4">
	SELECT	UNITOFMEASUREID, MEASURENAME
	FROM		UNITOFMEASURE
	ORDER BY	UNITOFMEASUREID
</CFQUERY>

<BR clear="left" />

<!--- 
**************************************************************
* The following code is the ADD Process for Unit Of Measure. *
**************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Purchasing - Unit Of Measure</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#PURCHASING">
		SELECT	MAX(UNITOFMEASUREID) AS MAX_ID
		FROM		UNITOFMEASURE
	</CFQUERY>
	<CFSET FORM.UNITOFMEASUREID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="UNITOFMEASUREID" secure="NO" value="#FORM.UNITOFMEASUREID#">
	<CFQUERY name="AddUnitOfMeasureID" datasource="#application.type#PURCHASING">
		INSERT INTO	UNITOFMEASURE (UNITOFMEASUREID)
		VALUES		(#val(Cookie.UNITOFMEASUREID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Unit Of Measure Key &nbsp; = &nbsp; #FORM.UNITOFMEASUREID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processunitofmeasure.cfm" method="POST">
			<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSUNITOFMEASURE" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="UNITOFMEASURE" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processunitofmeasure.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="MEASURENAME">*Measure Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="MEASURENAME" id="MEASURENAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSUNITOFMEASURE" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/processunitofmeasure.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSUNITOFMEASURE" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Unit Of Measure. *
*****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPUNITOFMEASURE')>
			<TD align="center"><H1>Modify/Delete Lookup Information to IDT Purchasing - Unit Of Measure</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to IDT Purchasing - Unit Of Measure</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPUNITOFMEASURE')>
		<TR>
			<TH align="center"> Unit Of Measure Key &nbsp; = &nbsp; #FORM.UNITOFMEASUREID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPUNITOFMEASURE')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=#URL.PROCESS#&LOOKUPUNITOFMEASURE=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="UNITOFMEASUREID">*Measure Name:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="UNITOFMEASUREID" id="UNITOFMEASUREID" size="1" query="ListUnitOfMeasure" value="UNITOFMEASUREID" display="MEASURENAME" selected="0" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left" colspan="2">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
*****************************************************************************
* The following code is the Modify and Delete Processes for Unit Of Measure.*
*****************************************************************************
 --->

		<CFQUERY name="GetUnitOfMeasure" datasource="#application.type#PURCHASING" blockfactor="100">
			SELECT	UNITOFMEASUREID, MEASURENAME
			FROM		UNITOFMEASURE
			WHERE	UNITOFMEASUREID = <CFQUERYPARAM value="#FORM.UNITOFMEASUREID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	UNITOFMEASUREID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="UNITOFMEASURE" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processunitofmeasure.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="UNITOFMEASUREID" secure="NO" value="#FORM.UNITOFMEASUREID#">
				<TH align="left"><H4><LABEL for="MEASURENAME">*Measure Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="MEASURENAME" id="MEASURENAME" value="#GetUnitOfMeasure.MEASURENAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSUNITOFMEASURE" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="3" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="4" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/purchasing/unitofmeasure.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>