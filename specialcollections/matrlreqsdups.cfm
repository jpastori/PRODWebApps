<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: matrlreqsdups.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/11/2009 --->
<!--- Date in Production: 12/11/2009 --->
<!--- Module: Add/Modify Information to Special Collections - Material Requests & Duplications --->
<!-- Last modified by John R. Pastori on 12/11/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/matrlreqsdups.cfm">
<CFSET CONTENT_UPDATED = "December 11, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Special Collections - Material Requests & Duplications </TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Special Collections - Material Requests & Duplications </TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Shared Data Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.MATRLREQSDUPS.RESEARCHERID.selectedIndex == "0") {
			alertuser (document.MATRLREQSDUPS.RESEARCHERID.name +  ",  A Researcher Name MUST be selected!");
			document.MATRLREQSDUPS.RESEARCHERID.focus();
			return false;
		}

		if (document.MATRLREQSDUPS.TOPIC.value == "" || document.MATRLREQSDUPS.TOPIC.value == " ") {
			alertuser (document.MATRLREQSDUPS.TOPIC.name +  ",  An Topic MUST be entered!");
			document.MATRLREQSDUPS.TOPIC.focus();
			return false;
		}

		if (document.MATRLREQSDUPS.COLLECTIONID.selectedIndex == "0") {
			alertuser (document.MATRLREQSDUPS.COLLECTIONID.name +  ",  A Collection Name MUST be selected!");
			document.MATRLREQSDUPS.COLLECTIONID.focus();
			return false;
		}

		if (document.MATRLREQSDUPS.MODIFIEDBYID.selectedIndex == "0") {
			alertuser ("A Modified By Name MUST be selected!");
			document.MATRLREQSDUPS.MODIFIEDBYID.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.MRDID.selectedIndex == "0") {
			alertuser ("A Researcher Name MUST be selected!");
			document.LOOKUP.MRDID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPMATRLREQSDUPS') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.MRDID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.MATRLREQSDUPS.RESEARCHERID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
****************************************************************************************************
* The following code is used for Special Collections - Material Requests & Duplications Processes. *
****************************************************************************************************
 --->

<CFQUERY name="ListMatrlReqsDups" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
	SELECT	MRD.MRDID, MRD.RESEARCHERID, R.FULLNAME, MRD.TOPIC, MRD.COLLECTIONID, MRD.CALLNUMBER, MRD.BOXNUMBER, MRD.SERVICEDATE,
			MRD.ASSISTANTNAMEID, MRD.SECONDASSISTANTNAMEID, MRD.SERVICEID, MRD.APPROVEDBYID, MRD.TOTALCOPIESMADE, MRD.COSTFORSERVICE,
			MRD.PAIDTYPEID, MRD.COMMENTS, MRD.MODIFIEDBYID, MRD.MODIFIEDDATE, R.FULLNAME || ' - ' || MRD.TOPIC AS RNAMETOPIC
	FROM		MATRLREQSDUPS MRD, RESEARCHERINFO R
	WHERE	MRD.RESEARCHERID = R.RESEARCHERID
	ORDER BY	RNAMETOPIC
</CFQUERY>

<CFQUERY name="ListResearchers" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
	SELECT	RESEARCHERID, DATEREGISTERED, HONORIFIC, FIRSTNAME, LASTNAME, FULLNAME, INSTITUTION, DEPTMAJOR, ADDRESS , CITY , STATEID, ZIPCODE, PHONE,
			FAX , EMAIL, IDTYPEID, IDNUMBER, STATUSID, INITIALTOPIC, MODIFIEDBYID, MODIFIEDDATE
	FROM		RESEARCHERINFO
	ORDER BY	FULLNAME
</CFQUERY>

<CFQUERY name="ListCollections" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="100">
	SELECT	COLLECTIONID, COLLECTIONNAME
	FROM		COLLECTIONS
	ORDER BY	COLLECTIONNAME
</CFQUERY>

<CFQUERY name="ListActiveAssistants" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="25">
	SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE
	FROM		ASSISTANTS
	WHERE 	ACTIVE = 'YES'
	ORDER BY	ASSISTANTNAME
</CFQUERY>

<CFQUERY name="ListServices" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
	SELECT	SERVICEID, SERVICENAME
	FROM		SERVICES
	ORDER BY	SERVICENAME
</CFQUERY>

<CFQUERY name="ListActiveApprovers" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="25">
	SELECT	ASSISTANTID, ASSISTANTNAME, ACTIVE
	FROM		ASSISTANTS
	WHERE 	ACTIVE = 'YES' AND
			APPROVAL = 'YES'
	ORDER BY	ASSISTANTNAME
</CFQUERY>

<CFQUERY name="ListPaidTypes" datasource="#application.type#SPECIALCOLLECTIONS" blockfactor="10">
	SELECT	PAIDTYPEID, PAIDTYPENAME
	FROM		PAIDTYPES
	ORDER BY	PAIDTYPENAME
</CFQUERY>

<!--- 
*****************************************************************************************************
* The following code is the ADD Process for Special Collections - Material Requests & Duplications. *
*****************************************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Add Information to Special Collections - Material Requests & Duplications</H1></TH>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MAX(MRDID) AS MAX_ID
			FROM		MATRLREQSDUPS
		</CFQUERY>
		<CFSET FORM.MRDID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="MRDID" secure="NO" value="#FORM.MRDID#">
		<CFSET FORM.ENTRYDATE = #DateFormat(NOW(), 'dd-mmm-yyyy')#>
		<CFQUERY name="AddResearchVisitID" datasource="#application.type#SPECIALCOLLECTIONS">
			INSERT INTO	MATRLREQSDUPS (MRDID, ENTRYDATE)
			VALUES		(#val(Cookie.MRDID)#, TO_DATE('#FORM.ENTRYDATE# 12:00:00 AM', 'DD-MON-YYYY HH:MI:SS AM'))
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				Material Requests & Duplications Key &nbsp; = &nbsp; #FORM.MRDID#
				&nbsp;&nbsp;&nbsp;&nbsp;Entry Date: #DateFormat(FORM.ENTRYDATE, "MM/DD/YYYY")#
			</TH>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processmatrlreqsdups.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMatrlReqsDups" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="MATRLREQSDUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processmatrlreqsdups.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign="bottom"><H4><LABEL for="RESEARCHERID">*Researcher Name</LABEL></H4></TH>
			<TH align="left" valign="bottom"><H4><LABEL for="TOPIC">*Topic</H4></LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="RESEARCHERID" id="RESEARCHERID" size="1" query="ListResearchers" value="RESEARCHERID" display="FULLNAME" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="TOPIC" id="TOPIC" value="" size="50" maxlength="100" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><H4><LABEL for="COLLECTIONID">*Collection Name</LABEL></H4></TH>
			<TH align="left" valign="bottom"><LABEL for="CALLNUMBER">Call Number</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="COLLECTIONID" id="COLLECTIONID" size="1" query="ListCollections" value="COLLECTIONID" display="COLLECTIONNAME" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP"><CFINPUT type="text" name="CALLNUMBER" id="CALLNUMBER" size="30" maxlength="30" value="" tabindex="5"></TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="BOXNUMBER">Box Number</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="SERVICEDATE">Service Date</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP"><CFINPUT type="Text" name="BOXNUMBER" id="BOXNUMBER" size="10" maxlength="6" value="" tabindex="6"></TD>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="SERVICEDATE" id="SERVICEDATE" size="10" maxlength="10" value="#DateFormat(NOW(), 'MM/DD/YYYY')#" tabindex="7"><BR>
				<COM>DATE FORMAT MUST BE ENTERED AS MM/DD/YYYY</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="ASSISTANTNAMEID">Assistant Name</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="SECONDASSISTANTNAMEID">2nd Assistant Name</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="ASSISTANTNAMEID" id="ASSISTANTNAMEID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="8"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="SECONDASSISTANTNAMEID" id="SECONDASSISTANTNAMEID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="SERVICEID">Service Name</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="APPROVEDBYID">Approved By</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="SERVICEID" id="SERVICEID" size="1" query="ListServices" value="SERVICEID" display="SERVICENAME" required="No" tabindex="10"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="APPROVEDBYID" id="APPROVEDBYID" query="ListActiveApprovers" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="11"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="TOTALCOPIESMADE">Total Copies Made</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="COSTFORSERVICE">Cost For Service</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="TOTALCOPIESMADE" id="TOTALCOPIESMADE" size="20" maxlength="20" value="" tabindex="12">
			</TD>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="COSTFORSERVICE" id="COSTFORSERVICE" size="20" maxlength="20" value="0.00" tabindex="13"><BR>
				<COM>Please enter dollar value without a dollar sign or commas.</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><LABEL for="PAIDTYPEID">Paid Types</LABEL></TH>
			<TH align="left" valign="bottom"><LABEL for="COMMENTS">Comments</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="PAIDTYPEID" id="PAIDTYPEID" query="ListPaidTypes" value="PAIDTYPEID" display="PAIDTYPENAME" selected="0" tabindex="14"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<TEXTAREA name="COMMENTS" id="COMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="50" tabindex="15"></TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="bottom"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left" valign="bottom"><LABEL for="MODIFIEDDATE">Date Modified</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="0" tabindex="16"></CFSELECT>
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
			<TD align="LEFT"><INPUT type="submit" name="ProcessMatrlReqsDups" value="ADD" tabindex="17" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/specialcollections/processmatrlreqsdups.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessMatrlReqsDups" value="CANCELADD" tabindex="18" /><BR />
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
***********************************************************************************************************************
* The following code is the Look Up Process for Modifying the Special Collections - Material Requests & Duplications. *
***********************************************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined("URL.LOOKUPMATRLREQSDUPS")>
			<TH align="center"><H1>Lookup for Modify/Delete Information to Special Collections - Material Requests & Duplications</H1></TH>
		<CFELSE>
			<TH align="center"><H1>Modify/Delete Information to Special Collections - Material Requests & Duplications</H1></TH>
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
	<CFIF NOT IsDefined('URL.LOOKUPMATRLREQSDUPS')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=#URL.PROCESS#&LOOKUPMATRLREQSDUPS=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="MRDID">*Researcher Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="MRDID" id="MRDID" size="1" query="ListMatrlReqsDups" value="MRDID" display="RNAMETOPIC" required="No" tabindex="2"></CFSELECT>
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
*********************************************************************************************************************
* The following code is the Modify and Delete Processes for Special Collections - Material Requests & Duplications. *
*********************************************************************************************************************
 --->

		<CFQUERY name="GetMatrlReqsDups" datasource="#application.type#SPECIALCOLLECTIONS">
			SELECT	MRD.MRDID, MRD.RESEARCHERID, R.FULLNAME, MRD.TOPIC, MRD.COLLECTIONID, MRD.CALLNUMBER, MRD.BOXNUMBER, MRD.SERVICEDATE,
					MRD.ASSISTANTNAMEID, MRD.SECONDASSISTANTNAMEID, MRD.SERVICEID, MRD.APPROVEDBYID, MRD.TOTALCOPIESMADE, MRD.COSTFORSERVICE,
					MRD.PAIDTYPEID, MRD.COMMENTS, MRD.MODIFIEDBYID, MRD.ENTRYDATE, MRD.MODIFIEDDATE, R.FULLNAME || ' - ' || MRD.TOPIC AS RNAMETOPIC
			FROM		MATRLREQSDUPS MRD, RESEARCHERINFO R
			WHERE	MRDID = <CFQUERYPARAM value="#FORM.MRDID#" cfsqltype="CF_SQL_NUMERIC"> AND 
					MRD.RESEARCHERID = R.RESEARCHERID
			ORDER BY	RNAMETOPIC
		</CFQUERY>

		<CFCOOKIE name="MRDID" secure="NO" value="#FORM.MRDID#">

		<TABLE align="left" width="100%" border="0">
			<TR>
				<TH align="center" colspan="2">
					Research Visit Key &nbsp; = &nbsp; #FORM.MRDID#
					&nbsp;&nbsp;&nbsp;&nbsp; Entry Date: #DateFormat(GetMatrlReqsDups.ENTRYDATE, "MM/DD/YYYY")#
				</TH>
			</TR>
			<TR>
				<TD>&nbsp;&nbsp;</TD>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessMatrlReqsDups" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="MATRLREQSDUPS" onsubmit="return validateReqFields();" action="/#application.type#apps/specialcollections/processmatrlreqsdups.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left" valign="bottom"><H4><LABEL for="RESEARCHERID">*Researcher Name</LABEL></H4></TH>
				<TH align="left" valign="bottom"><H4><LABEL for="TOPIC">*Topic</H4></LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="RESEARCHERID" id="RESEARCHERID" size="1" query="ListResearchers" value="RESEARCHERID" display="FULLNAME" selected="#GetMatrlReqsDups.RESEARCHERID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="TOPIC" id="TOPIC" value="#GetMatrlReqsDups.TOPIC#" size="50" maxlength="100" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><H4><LABEL for="COLLECTIONID">*Collection Name</LABEL></H4></TH>
				<TH align="left" valign="bottom"><LABEL for="CALLNUMBER">Call Number</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="COLLECTIONID" id="COLLECTIONID" size="1" query="ListCollections" value="COLLECTIONID" display="COLLECTIONNAME" selected="#GetMatrlReqsDups.COLLECTIONID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP"><CFINPUT type="text" name="CALLNUMBER" id="CALLNUMBER" size="30" maxlength="30" value="#GetMatrlReqsDups.CALLNUMBER#" tabindex="5"></TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="BOXNUMBER">Box Number</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="SERVICEDATE">Service Date</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP"><CFINPUT type="Text" name="BOXNUMBER" id="BOXNUMBER" size="10" maxlength="6" value="#GetMatrlReqsDups.BOXNUMBER#" tabindex="6"></TD>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="SERVICEDATE" id="SERVICEDATE" size="10" maxlength="10" value="#DateFormat(GetMatrlReqsDups.SERVICEDATE, "MM/DD/YYYY")#" tabindex="7"><BR>
					<COM>DATE FORMAT MUST BE ENTERED AS MM/DD/YYYY</COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="ASSISTANTNAMEID">Assistant Name</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="SECONDASSISTANTNAMEID">2nd Assistant Name</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="ASSISTANTNAMEID" id="ASSISTANTNAMEID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="#GetMatrlReqsDups.ASSISTANTNAMEID#" tabindex="8"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="SECONDASSISTANTNAMEID" id="SECONDASSISTANTNAMEID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="#GetMatrlReqsDups.SECONDASSISTANTNAMEID#" tabindex="9"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="SERVICEID">Service Name</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="APPROVEDBYID">Approved By</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="SERVICEID" id="SERVICEID" size="1" query="ListServices" value="SERVICEID" display="SERVICENAME" required="No" selected="#GetMatrlReqsDups.SERVICEID#" tabindex="10"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="APPROVEDBYID" id="APPROVEDBYID" query="ListActiveApprovers" value="ASSISTANTID" display="ASSISTANTNAME" selected="#GetMatrlReqsDups.APPROVEDBYID#" tabindex="11"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="TOTALCOPIESMADE">Total Copies Made</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="COSTFORSERVICE">Cost For Service</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="TOTALCOPIESMADE" id="TOTALCOPIESMADE" size="20" maxlength="20" value="#GetMatrlReqsDups.TOTALCOPIESMADE#" tabindex="12">
				</TD>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="COSTFORSERVICE" id="COSTFORSERVICE" size="20" maxlength="20" value="#DECIMALFORMAT(GetMatrlReqsDups.COSTFORSERVICE)#" tabindex="13"><BR>
					<COM>Please enter dollar value without a dollar sign or commas.</COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><LABEL for="PAIDTYPEID">Paid Types</LABEL></TH>
				<TH align="left" valign="bottom"><LABEL for="COMMENTS">Comments</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="PAIDTYPEID" id="PAIDTYPEID" query="ListPaidTypes" value="PAIDTYPEID" display="PAIDTYPENAME" selected="#GetMatrlReqsDups.PAIDTYPEID#" tabindex="14"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<TEXTAREA name="COMMENTS" id="COMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="50" tabindex="15">#GetMatrlReqsDups.COMMENTS#</TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="bottom"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
				<TH align="left" valign="bottom"><LABEL for="MODIFIEDDATE">Date Modified</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListActiveAssistants" value="ASSISTANTID" display="ASSISTANTNAME" selected="#GetMatrlReqsDups.MODIFIEDBYID#" tabindex="16"></CFSELECT>
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
				<TD align="left"><INPUT type="submit" name="ProcessMatrlReqsDups" value="MODIFY" tabindex="17" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT"><INPUT type="submit" name="ProcessMatrlReqsDups" value="DELETE" tabindex="18" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" name="ProcessMatrlReqsDups" value="Cancel" tabindex="19" /><BR />
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