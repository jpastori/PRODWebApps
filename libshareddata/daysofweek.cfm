<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: daysofweek.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Library Shared Data - Days Of The Week --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL="pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI="/#application.type#apps/libshareddata/daysofweek.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Library Shared Data - Days Of The Week</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Library Shared Data - Days Of The Week</TITLE>
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
		if (document.DAYSOFWEEK.DAYSOFWEEKNAME.value == "" || document.DAYSOFWEEK.DAYSOFWEEKNAME.value == " ") {
			alertuser (document.DAYSOFWEEK.DAYSOFWEEKNAME.name +  ",  A Day Of The Week Name MUST be entered!");
			document.DAYSOFWEEK.DAYSOFWEEKNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.DAYSOFWEEKID.selectedIndex == "0") {
			alertuser ("A Day Of The Week Name MUST be selected!");
			document.LOOKUP.DAYSOFWEEKID.focus();
			return false;
		}
	}


	function setDelete() {
		document.DAYSOFWEEK.PROCESSDAYSOFWEEK.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDAYSOFWEEK') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.DAYSOFWEEKID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.DAYSOFWEEK.DAYSOFWEEKNAME.focus()">
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

<CFQUERY name="ListDaysOfWeek" datasource="#application.type#LIBSHAREDDATA" blockfactor="24">
	SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
	FROM		DAYSOFWEEK
	ORDER BY	DAYSOFWEEKID
</CFQUERY>

<BR clear="left" />

<!--- 
***************************************************************
* The following code is the ADD Process for Days Of The Week. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Library Shared Data - Days Of The Week</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(DAYSOFWEEKID) AS MAX_ID
			FROM		DAYSOFWEEK
		</CFQUERY>
		<CFSET FORM.DAYSOFWEEKID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="DAYSOFWEEKID" secure="NO" value="#FORM.DAYSOFWEEKID#">
		<CFQUERY name="AddDaysOfWeekID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	DAYSOFWEEK (DAYSOFWEEKID)
			VALUES		(#val(Cookie.DAYSOFWEEKID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Days Of The Week Key &nbsp; = &nbsp; #FORM.DAYSOFWEEKID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processdaysofweek.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSDAYSOFWEEK" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="DAYSOFWEEK" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processdaysofweek.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4>*<LABEL for="DAYSOFWEEKNAME">Days Of The Week Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="DAYSOFWEEKNAME" id="DAYSOFWEEKNAME" value="" align="LEFT" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSDAYSOFWEEK" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processdaysofweek.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSDAYSOFWEEK" value="CANCELADD" />
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
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Days Of The Week. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to Library Shared Data - Days Of The Week</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPDAYSOFWEEK')>
		<TR>
			<TH align="center">Days Of The Week Key &nbsp; = &nbsp; #FORM.DAYSOFWEEKID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPDAYSOFWEEK')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=#URL.PROCESS#&LOOKUPDAYSOFWEEK=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="DAYSOFWEEKID">*Days Of The Week Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="DAYSOFWEEKID" id="DAYSOFWEEKID" size="1" query="ListDaysOfWeek" value="DAYSOFWEEKID" display="DAYSOFWEEKNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
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
*******************************************************************************
* The following code is the Modify and Delete Processes for Days Of The Week. *
*******************************************************************************
 --->

		<CFQUERY name="GetDaysOfWeek" datasource="#application.type#LIBSHAREDDATA">
			SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
			FROM		DAYSOFWEEK
			WHERE	DAYSOFWEEKID = <CFQUERYPARAM value="#FORM.DAYSOFWEEKID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DAYSOFWEEKID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="DAYSOFWEEK" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processdaysofweek.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="DAYSOFWEEKID" secure="NO" value="#FORM.DAYSOFWEEKID#">
				<TH align="left"><H4><LABEL for="DAYSOFWEEKNAME">*Days Of The Week Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="DAYSOFWEEKNAME" id="DAYSOFWEEKNAME" value="#GetDaysOfWeek.DAYSOFWEEKNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSDAYSOFWEEK" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
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