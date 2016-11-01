<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: locationinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/06/2012 --->
<!--- Date in Production: 06/06/2012 --->
<!--- Module: Add/Modify/Delete Information in Facilities Location --->
<!-- Last modified by John R. Pastori on on 10/03/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/locationinfo.cfm">
<CFSET CONTENT_UPDATED = "October 03, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Facilities - Location</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Facilities - Location</TITLE>
	</CFIF>		 
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.LOCATION.ROOMNUMBER.value == "" || document.LOCATION.ROOMNUMBER.value == " ") {
			alertuser (document.LOCATION.ROOMNUMBER.name +  ",  A Room Number MUST be entered!");
			document.LOCATION.ROOMNUMBER.focus();
			return false;
		}

		if (document.LOCATION.BUILDINGNAMEID.selectedIndex == "0") {
			alertuser (document.LOCATION.BUILDINGNAMEID.name +  ",  A Building Name MUST be selected!");
			document.LOCATION.BUILDINGNAMEID.focus();
			return false;
		}

		if (!document.LOCATION.NPORTDATECHKED.value == "" && !document.LOCATION.NPORTDATECHKED.value == " "
		 && !document.LOCATION.NPORTDATECHKED.value.match(/^\d{2}\/\d{2}\/\d{4}/)) {
			alertuser (document.LOCATION.NPORTDATECHKED.name +  ",  A Network Port Date Last Checked MUST be entered in the format MM/DD/YYYY!");
			document.LOCATION.NPORTDATECHKED.focus();
			return false;
		}

	}

	function validateLookupField() {
		if (document.LOOKUP.LOCID.selectedIndex == "0") {
			alertuser ("A Room Number MUST be Selected!");
			document.LOOKUP.LOCID.focus();
			return false;
		}
	}

//

</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLOC') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.LOCID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LOCATION.ROOMNUMBER.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<CFIF IsDefined('URL.SRCALL') AND #URL.SRCALL# EQ "YES">
	<CFSET PROGRAMNAME = "processlocationinfo.cfm?SRCALL=YES">
     <CFSET client.SRCALL = "YES">
<CFELSE>
     <CFSET PROGRAMNAME = "processlocationinfo.cfm">
     <CFSET client.SRCALL = "NO">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListLocations" datasource="#application.type#FACILITIES" blockfactor="100">
	SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
			LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
			LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
	FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
	WHERE	LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
			LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
	ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
</CFQUERY>

<CFQUERY name="ListBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
	SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
	FROM		BUILDINGNAMES
	ORDER BY	BUILDINGNAME
</CFQUERY>

<CFQUERY name="ListLocationDescription" datasource="#application.type#FACILITIES" blockfactor="56">
	SELECT	LOCATIONDESCRIPTIONID, LOCATIONDESCRIPTION
	FROM		LOCATIONDESCRIPTION
	ORDER BY	LOCATIONDESCRIPTION
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="6">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 100 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 20
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************
* The following code is the ADD Process for Locations. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information in Facilities - Location</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#FACILITIES">
			SELECT	MAX(LOCATIONID) AS MAX_ID
			FROM		LOCATIONS
		</CFQUERY>
		<CFSET FORM.LOCID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="LOCID" secure="NO" value="#FORM.LOCID#">
		<CFQUERY name="AddLocationID" datasource="#application.type#FACILITIES">
			INSERT INTO	LOCATIONS (LOCATIONID)
			VALUES		(#val(Cookie.LOCID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Location Key &nbsp; = &nbsp; #FORM.LOCID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
			<TD align="left">
				<INPUT type="submit" name="ProcessLocation" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOCATION" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="ROOMNUMBER">*Room Number</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap><CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" align="LEFT" required="No" size="20" tabindex="2"></TD>
		</TR>		
		<TR>
			<TH align="left"><H4><LABEL for="BUILDINGNAMEID">*Building Code -- Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUIDINGCODENAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NETWORKPORTCOUNT">Network Port Count</LABEL></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="NETWORKPORTCOUNT" id="NETWORKPORTCOUNT" value="0" align="LEFT" required="No" size="8" tabindex="4"></TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="NPORTDATECHKED">NPort Date Last Checked</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFINPUT type="Text" name="NPORTDATECHKED" id="NPORTDATECHKED" value="" align="LEFT" required="NO" size="10" maxlength="10" tabindex="5">
				<SCRIPT language="JavaScript">
					new tcal ({'formname': 'LOCATION','controlname': 'NPORTDATECHKED'});

				</SCRIPT>
				<BR><COM>MM/DD/YYYYY </COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="LOCATIONDESCRIPTIONID">Location Description</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="LOCATIONDESCRIPTIONID" id="LOCATIONDESCRIPTIONID" size="1" query="ListLocationDescription" value="LOCATIONDESCRIPTIONID" display="LOCATIONDESCRIPTION" selected="0" required="No" tabindex="6"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="7"></CFSELECT>
			</TD>
		<TR>
			<TH align="left">Date Created</TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessLocation" value="ADD" tabindex="8" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/facilities/#PROGRAMNAME#" method="POST">
			<TD align="left">
				<INPUT type="submit" name="ProcessLocation" value="CANCELADD" tabindex="9" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
**********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Location. *
**********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPLOC')>
			<TD align="center"><H1>Modify/Delete Lookup Information in Facilities - Location</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information in Facilities - Location</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPLOC')>
		<TR>
			<TH align="center">Location Key &nbsp; = &nbsp; #FORM.LOCID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPLOC')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPLOC=FOUND" method="POST">
			<TR>
				<TH align="left" nowrap><LABEL for="LOCID">Select by <H4>*Building - Room Number</H4></label></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="LOCID" id="LOCID" size="1" query="ListLocations" value="LOCATIONID" display="LOCATIONNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD>&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			</TR><TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
**********************************************************************
* The following code is the Modify and Delete Processes for Location.*
**********************************************************************
 --->

		<CFQUERY name="GetLocation" datasource="#application.type#FACILITIES">
			SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, BN.BUILDINGNAMEID, BN.BUILDINGNAME, LOC.LOCATIONNAME,
					LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED, LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION,
					LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
			FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
			WHERE	LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCID#" cfsqltype="CF_SQL_NUMERIC"> AND
					LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
					LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID
			ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left">
					<INPUT type="submit" name="ProcessLocation" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOCATION" onsubmit="return validateReqFields();" action="/#application.type#apps/facilities/processlocationinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="LOCID" secure="NO" value="#FORM.LOCID#">
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="ROOMNUMBER">*Room Number</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
					<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="#GetLocation.ROOMNUMBER#" align="LEFT" required="No" size="20" tabindex="2">
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="BUILDINGNAMEID">*Building Code -- Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="ListBuildings" value="BUILDINGNAMEID" display="BUIDINGCODENAME" selected="#GetLocation.BUILDINGNAMEID#" required="No" tabindex="3"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left">Location</TH>
			</TR>
			<TR>
				<TD align="left">#GetLocation.LOCATIONNAME#</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="NETWORKPORTCOUNT">Network Port Count</LABEL></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="NETWORKPORTCOUNT" id="NETWORKPORTCOUNT" value="#GetLocation.NETWORKPORTCOUNT#" align="LEFT" required="No" size="8" tabindex="4"></TD>	
			</TR>
			<TR>			
				<TH align="left"><LABEL for="NPORTDATECHKED">NPort Date Last Checked</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFINPUT type="Text" name="NPORTDATECHKED" id="NPORTDATECHKED" value="#DateFormat(GetLocation.NPORTDATECHKED, "MM/DD/YYYY")#" align="LEFT" required="No" size="15" tabindex="5">
					<SCRIPT language="JavaScript">
						new tcal ({'formname': 'LOCATION','controlname': 'NPORTDATECHKED'});

					</SCRIPT>
					<BR><COM> MM/DD/YYYYY </COM>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="LOCATIONDESCRIPTIONID">Location Description</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="LOCATIONDESCRIPTIONID" id="LOCATIONDESCRIPTIONID" size="1" query="ListLocationDescription" value="LOCATIONDESCRIPTIONID" display="LOCATIONDESCRIPTION" selected="#GetLocation.LOCATIONDESCRIPTIONID#" required="No" tabindex="6"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified-By</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="7"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left">Date Modified</TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLocation" value="MODIFY" tabindex="8" /></TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessLocation" value="DELETE" tabindex="9" /></TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/facilities/locationinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left">
					<INPUT type="submit" name="ProcessLocation" value="Cancel" tabindex="10" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>