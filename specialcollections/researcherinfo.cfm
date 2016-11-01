<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: researcherinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/18/2012 --->
<!--- Date in Production: 05/18/2012 --->
<!--- Module: Add/Modify Information to Special Collections - Researcher Information --->
<!-- Last modified by John R. Pastori on 05/18/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/researcherinfo.cfm">
<CFSET CONTENT_UPDATED = "May 18, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Researcher Information </TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Researcher Information </TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT1.1>
	window.defaultStatus = "Welcome to Special Collections - Researcher Information";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateText(varName, textData)	{
		if (textData == null  || textData == "") {
			alertuser (varName +  ",  Field can not be BLANK");
			if (varName == "FIRSTNAME") {
				document.RESEARCHERINFO.FIRSTNAME.focus();
			}
			if (varName == "LASTNAME") {
				document.RESEARCHERINFO.LASTNAME.focus();
			}
			return false;
		}else {
			return true;
		} 
		document.write("varName = " +  varName + "&nbsp;&nbsp; textData =  " +  textData + "<br>");
	}

	function validateReqFields() {
		if (!validateText(document.RESEARCHERINFO.FIRSTNAME.name, document.RESEARCHERINFO.FIRSTNAME.value)) {
			return false;
		}
		if (!validateText(document.RESEARCHERINFOINFO.LASTNAME.name, document.RESEARCHERINFO.LASTNAME.value)) {
			return false;
		}
		if (document.RESEARCHERINFO.MODIFIEDBYID.selectedIndex == "0") {
			alertuser ("A Modified By Name MUST be selected!");
			document.RESEARCHERINFO.MODIFIEDBYID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.RESEARCHERID.selectedIndex == "0") {
			alertuser ("A Researcher Name MUST be selected!");
			document.LOOKUP.RESEARCHERID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPRESEARCHERINFO') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.RESEARCHERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.RESEARCHERINFO.HONORIFIC.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
******************************************************************************************
* The following code is used for Special Collections - Researcher Information Processes. *
******************************************************************************************
 --->

<CFQUERY name="ListResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
	SELECT	RESEARCHERID, HONORIFIC, FIRSTNAME, LASTNAME, LASTNAME || ' ' || FIRSTNAME AS FULLNAME, INSTITUTION, DEPTMAJOR, ADDRESS, CITY, STATEID, ZIPCODE,
			PHONE, FAX, EMAIL, IDTYPEID, IDNUMBER, STATUSID, INITIALTOPIC, TO_CHAR(DATEREGISTERED, 'MM/DD/YYYY') AS REGDATE,
			MODIFIEDBYID, MODIFIEDDATE
	FROM		RESEARCHERINFO
	ORDER BY	LASTNAME, FIRSTNAME
</CFQUERY>

<CFQUERY name="ListStates" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
	SELECT	STATEID, STATECODE, STATENAME, STATECODE || ' - ' || STATENAME AS STATECODENAME
	FROM		STATES
	ORDER BY	STATECODE
</CFQUERY>

<CFQUERY name="ListIDTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="12">
	SELECT	IDTYPEID, IDTYPENAME
	FROM		IDTYPES
	ORDER BY	IDTYPENAME
</CFQUERY>

<CFQUERY name="ListStatus" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
	SELECT	STATUSID, STATUSNAME
	FROM		STATUS
	ORDER BY	STATUSNAME
</CFQUERY>

<CFQUERY name="ListActiveAssistants" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="25">
	SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE
	FROM		ASSISTANTS
	WHERE 	ACTIVE = 'YES'
	ORDER BY	ASSISTANTNAME
</CFQUERY>

<!--- 
*******************************************************************************************
* The following code is the ADD Process for Special Collections - Researcher Information. *
*******************************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Add Information to Special Collections - Researcher Information</H1></TH>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(RESEARCHERID) AS MAX_ID
			FROM		RESEARCHERINFO
		</CFQUERY>
		<CFSET FORM.RESEARCHERID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="RESEARCHERID" secure="NO" value="#FORM.RESEARCHERID#">
		<CFSET FORM.REGDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFQUERY name="AddResearcherID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	RESEARCHERINFO (RESEARCHERID, DATEREGISTERED)
			VALUES		(#val(Cookie.RESEARCHERID)#, TO_DATE('#FORM.REGDATE# 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'))
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Researcher Information Key &nbsp; = &nbsp; #FORM.RESEARCHERID#
				&nbsp;&nbsp;&nbsp;&nbsp;Registration Date: #DateFormat(FORM.REGDATE, "MM/DD/YYYY")#
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processresearcherinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessResearcherInfo" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="RESEARCHERINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processresearcherinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign="bottom"><LABEL for="HONORIFIC">Honorific</LABEL></TH>
			<TH align="left" valign="bottom">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<SELECT size="1" name="HONORIFIC" id="HONORIFIC" tabindex="2">
					<OPTION selected value="none">none</OPTION>
					<OPTION value="Mr.">Mr.</OPTION>
					<OPTION value="Ms.">Ms.</OPTION>
					<OPTION value="Miss">Miss</OPTION>
					<OPTION value="Mrs.">Mrs.</OPTION>
					<OPTION value="Dr.">Dr.</OPTION>
				</SELECT>
			</TD>
			<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><H4><LABEL for="FIRSTNAME">*First Name</LABEL></H4></TH>
			<TH align="left" valign="bottom"><H4><LABEL for="LASTNAME">*Last Name</LABEL></H4></TH>
			
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="FIRSTNAME" id="FIRSTNAME" size="25" maxlength="50" value="" tabindex="3"></TD>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="LASTNAME" id="LASTNAME" size="25" maxlength="50" value="" tabindex="4"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="INSTITUTION">Institution</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="DEPTMAJOR">Dept/Major</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="INSTITUTION" id="INSTITUTION" size="50" maxlength="100" value="" tabindex="5"></TD>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="DEPTMAJOR" id="DEPTMAJOR" size="50" maxlength="100" value="" tabindex="6"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom" colspan="2"><LABEL for="ADDRESS">Address</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2"><CFINPUT type="Text" name="ADDRESS" id="ADDRESS" size="50" maxlength="100" value="" tabindex="7"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="CITY">City</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="STATEID">State/Province</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="CITY" id="CITY" size="50" maxlength="100" value="" tabindex="8"></TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" selected="#val(5)#" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="ZIPCODE">Zip/Postal Code</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="PHONE">Phone</LABEL></TH>
			
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="ZIPCODE" id="ZIPCODE" size="10" maxlength="15" value="" tabindex="10"></TD>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="PHONE" id="PHONE" size="15" maxlength="25" value="" tabindex="11"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="FAX">FAX</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="EMAIL">E-Mail</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="FAX" id="FAX" size="15" maxlength="25" value="" tabindex="12"></TD>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="EMAIL" id="EMAIL" size="50" maxlength="100" value="" tabindex="13"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="IDTYPEID">ID Type</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="IDNUMBER">ID Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="IDTYPEID" id="IDTYPEID" query="ListIDTypes" value="IDTYPEID" display="IDTYPENAME" selected="0" tabindex="14"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="IDNUMBER" id="IDNUMBER" size="50" maxlength="100" value="" tabindex="15"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="STATUSID">Status</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="INITIALTOPIC">Initial Topic</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" selected="0" required="No" tabindex="16"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="INITIALTOPIC" id="INITIALTOPIC" size="50" maxlength="100" value="" tabindex="17"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left" valign="bottom"><LABEL for="MODIFIEDDATE">Date Modified</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="18"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" id="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT"><INPUT type="submit" name="ProcessResearcherInfo" value="ADD" tabindex="19" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processresearcherinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessResearcherInfo" value="CANCELADD" tabindex="20" /><BR />
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
*************************************************************************************************************
* The following code is the Look Up Process for Modifying the Special Collections - Researcher Information. *
*************************************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined("URL.LOOKUPRESEARCHERINFO")>
			<TH align="center"><H1>Lookup for Modify/Delete Information to Special Collections - Researcher Information</H1></TH>
		<CFELSE>
			<TH align="center"><H1>Modify/Delete Information to Special Collections - Researcher Information</H1></TH>
		</CFIF>
		</TR>
	</TABLE>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
	</TABLE>
	<CFIF NOT IsDefined('URL.LOOKUPRESEARCHERINFO')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPRESEARCHERINFO=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="RESEARCHERID">*Researcher Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="RESEARCHERID" id="RESEARCHERID" size="1" query="ListResearcherInfo" value="RESEARCHERID" display="FULLNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
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
***********************************************************************************************************
* The following code is the Modify and Delete Processes for Special Collections - Researcher Information. *
***********************************************************************************************************
 --->

		<CFQUERY name="GetResearcherInfo" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	RESEARCHERID, HONORIFIC, FIRSTNAME, LASTNAME, FULLNAME, INSTITUTION, DEPTMAJOR, ADDRESS, CITY, STATEID, ZIPCODE,
					PHONE, FAX, EMAIL, IDTYPEID, IDNUMBER, STATUSID, INITIALTOPIC, TO_CHAR(DATEREGISTERED, 'MM/DD/YYYY') AS REGDATE, MODIFIEDBYID,
					TO_CHAR(MODIFIEDDATE, 'MM/DD/YYYY') AS MODIFIEDDATE
			FROM		RESEARCHERINFO
			WHERE	RESEARCHERID = <CFQUERYPARAM value="#FORM.RESEARCHERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFCOOKIE name="RESEARCHERID" secure="NO" value="#FORM.RESEARCHERID#">

		<TABLE align="LEFT" width="100%" border="0">
			<TR>
				<TH align="center" colspan="2">
					Researcher Information Key &nbsp; = &nbsp; #FORM.RESEARCHERID#
					&nbsp;&nbsp;&nbsp;&nbsp; Registration Date: #GetResearcherInfo.REGDATE#
				</TH>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessResearcherInfo" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="RESEARCHERINFO" action="/#application.type#apps/specialcollections/processresearcherinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left" valign="bottom"><LABEL for="HONORIFIC">Honorific</LABEL></TH>
				<TH align="left" valign="bottom">Full Name</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<INPUT type="hidden" name="RESEARCHERID" id="RESEARCHERID" value="#GetResearcherInfo.RESEARCHERID#" />
					<SELECT size="1" name="HONORIFIC" id="HONORIFIC" tabindex="2">
						<OPTION selected value="#GetResearcherInfo.HONORIFIC#">#GetResearcherInfo.HONORIFIC#</OPTION>
						<OPTION value="none">none</OPTION>
						<OPTION value="Mr.">Mr.</OPTION>
						<OPTION value="Ms.">Ms.</OPTION>
						<OPTION value="Miss">Miss</OPTION>
						<OPTION value="Mrs.">Mrs.</OPTION>
						<OPTION value="Dr.">Dr.</OPTION>
					</SELECT>
				</TD>
				<TD align="left" valign="TOP">#GetResearcherInfo.FULLNAME#</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><H4><LABEL for="FIRSTNAME">*First Name</LABEL></H4></TH>
				<TH align="left" valign="bottom"><H4><LABEL for="LASTNAME">*Last Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="FIRSTNAME" id="FIRSTNAME" size="25" maxlength="50" value="#GetResearcherInfo.FIRSTNAME#" tabindex="3"></TD>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="LASTNAME" id="LASTNAME" size="25" maxlength="50" value="#GetResearcherInfo.LASTNAME#" tabindex="4"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="INSTITUTION">Institution</TH>
				<TH align="left" valign="bottom"><LABEL for="DEPTMAJOR">Dept/Major</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="INSTITUTION" id="INSTITUTION" size="50" maxlength="100" value="#GetResearcherInfo.INSTITUTION#" tabindex="5"></TD>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="DEPTMAJOR" id="DEPTMAJOR" size="50" maxlength="100" value="#GetResearcherInfo.DEPTMAJOR#" tabindex="6"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom" colspan="2"><LABEL for="ADDRESS">Address</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP" colspan="2"><CFINPUT type="Text" name="ADDRESS" id="ADDRESS" size="50" maxlength="100" value="#GetResearcherInfo.ADDRESS#" tabindex="7"></TD>
			</TR>
				<TR>
				<TH align="left" valign="bottom"><LABEL for="CITY">City</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="STATEID">State/Province</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="CITY" id="CITY" size="50" maxlength="100" value="#GetResearcherInfo.CITY#" tabindex="8"></TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" selected="#GetResearcherInfo.STATEID#" tabindex="8"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="ZIPCODE">Zip/Postal Code</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="PHONE">Phone</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="ZIPCODE" id="ZIPCODE" size="10" maxlength="15" value="#GetResearcherInfo.ZIPCODE#" tabindex="10"></TD>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="PHONE" id="PHONE" size="15" maxlength="25" value="#GetResearcherInfo.PHONE#" tabindex="11"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="FAX">FAX</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="EMAIL">E-Mail</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="FAX" id="FAX" size="15" maxlength="25" value="#GetResearcherInfo.FAX#" tabindex="12"></TD>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="EMAIL" id="EMAIL" size="50" maxlength="100" value="#GetResearcherInfo.EMAIL#" tabindex="13"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="IDTYPEID">ID Type</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="IDNUMBER">ID Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="IDTYPEID" id="IDTYPEID" query="ListIDTypes" value="IDTYPEID" display="IDTYPENAME" selected="#GetResearcherInfo.IDTYPEID#" tabindex="14"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="IDNUMBER" id="IDNUMBER" size="50" maxlength="100" value="#GetResearcherInfo.IDNUMBER#" tabindex="15"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="STATUSID">Status</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="INITIALTOPIC">Initial Topic</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="STATUSID" id="STATUSID" size="1" query="ListStatus" value="STATUSID" display="STATUSNAME" selected="#GetResearcherInfo.STATUSID#" required="No" tabindex="16"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="INITIALTOPIC" id="INITIALTOPIC" size="50" maxlength="100" value="#GetResearcherInfo.INITIALTOPIC#" tabindex="17"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
				<TH align="left" valign="bottom"><LABEL for="MODIFIEDDATE">Date Modified</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="#GetResearcherInfo.MODIFIEDBYID#" tabindex="17"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" id="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessResearcherInfo" value="MODIFY" tabindex="18" /></TD>
			</TR>
			<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessResearcherInfo" value="DELETE" tabindex="19" /></TD>
			</TR>
			</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessResearcherInfo" value="Cancel" tabindex="20" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="LEFT" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>