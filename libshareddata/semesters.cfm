<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: semesters.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Add/Modify/Delete Information to Shared Data - Semesters --->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/semesters.cfm">
<CFSET CONTENT_UPDATED = "July 24, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Shared Data - Semesters</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Shared Data - Semesters</TITLE>
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
		if (document.SEMESTER.SEMESTERNAME.value == "" || document.SEMESTER.SEMESTERNAME.value == " ") {
			alertuser (document.SEMESTER.SEMESTERNAME.name +  ",  A Semester Name MUST be entered!");
			document.SEMESTER.SEMESTERNAME.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SEMESTERID.selectedIndex == "0") {
			alertuser ("A Semester Name MUST be selected!");
			document.LOOKUP.SEMESTERID.focus();
			return false;
		}
	}


	function setDelete() {
		document.SEMESTER.PROCESSSEMESTERS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSEM') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SEMESTERID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SEMESTER.SEMESTERNAME.focus()">
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

<CFQUERY name="ListSemesters" datasource="#application.type#LIBSHAREDDATA" blockfactor="4">
	SELECT	SEMESTERID, SEMESTERNAME
	FROM		SEMESTERS
	ORDER BY	SEMESTERID
</CFQUERY>

<BR clear = "left" />

<!--- 
********************************************************
* The following code is the ADD Process for Semesters. *
********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Add Information to Shared Data - Semesters</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#LIBSHAREDDATA">
			SELECT	MAX(SEMESTERID) AS MAX_ID
			FROM		SEMESTERS
		</CFQUERY>
		<CFSET FORM.SEMESTERID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="SEMID" secure="NO" value="#FORM.SEMESTERID#">
		<CFQUERY name="AddSemestersID" datasource="#application.type#LIBSHAREDDATA">
			INSERT INTO	SEMESTERS (SEMESTERID)
			VALUES		(#val(Cookie.SEMID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Semesters Key &nbsp; = &nbsp; #FORM.SEMESTERID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processsemesters.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSSEMESTERS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SEMESTER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processsemesters.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="SEMESTERNAME">*Semester Name:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="SEMESTERNAME" id="SEMESTERNAME"value="" align="left" required="No" size="50" tabindex="2"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSSEMESTERS" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/processsemesters.cfm" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="hidden" name="PROCESSSEMESTERS" value="CANCELADD" />
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
***********************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Semesters. *
***********************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Modify/Delete Information to Shared Data - Semesters</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPSEM')>
		<TR>
			<TH align="center">Semesters Key &nbsp; = &nbsp; #FORM.SEMESTERID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSEM')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libshareddata/semesters.cfm?PROCESS=#URL.PROCESS#&LOOKUPSEM=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="SEMESTERID">*Semester Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="SEMESTERID" id="SEMESTERID"size="1" query="ListSemesters" value="SEMESTERID" display="SEMESTERNAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="LEFT">
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
************************************************************************
* The following code is the Modify and Delete Processes for Semesters. *
************************************************************************
 --->

		<CFQUERY name="GetSemesters" datasource="#application.type#LIBSHAREDDATA">
			SELECT	SEMESTERID, SEMESTERNAME
			FROM		SEMESTERS
			WHERE	SEMESTERID = <CFQUERYPARAM value="#FORM.SEMESTERID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SEMESTERID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/libshareddata/semesters.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SEMESTER" onsubmit="return validateReqFields();" action="/#application.type#apps/libshareddata/processsemesters.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SEMID" secure="NO" value="#FORM.SEMESTERID#">
				<TH align="left"><H4><LABEL for="SEMESTERNAME">*Semester Name:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="SEMESTERNAME" id="SEMESTERNAME"value="#GetSemesters.SEMESTERNAME#" align="LEFT" required="No" size="50" tabindex="2"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSSEMESTERS" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/libshareddata/semesters.cfm?PROCESS=#URL.PROCESS#" method="POST">
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