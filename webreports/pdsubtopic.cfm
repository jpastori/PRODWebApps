<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: pdsubtopic.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Public Desk SubTopics --->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/pdsubtopic.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Public Desk SubTopics</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Public Desk SubTopics</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to Web Reports";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.SUBTOPIC.SUBTOPIC.value == "") {
			alertuser (document.SUBTOPIC.SUBTOPIC.name +  ",  A Public Desk SubTopic MUST be entered!");
			document.SUBTOPIC.SUBTOPIC.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SUBTOPICID.selectedIndex == "0") {
			alertuser ("A Public Desk SubTopic MUST be selected!");
			document.LOOKUP.SUBTOPICID.focus();
			return false;
		}
	}


	function setDelete() {
		document.SUBTOPIC.PROCESSPDSUBTOPIC.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPDSUBTOPIC') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SUBTOPICID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SUBTOPIC.SUBTOPIC.focus()">
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

<CFQUERY name="ListPDSubTopic" datasource="#application.type#WEBREPORTS" blockfactor="31">
	SELECT	SUBTOPICID, SUBTOPIC
	FROM		PDSUBTOPIC
	ORDER BY	SUBTOPIC
</CFQUERY>

<BR clear="left" />

<!--- 
********************************************************************
* The following code is the ADD Process for Public Desk SubTopics. *
********************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Public Desk SubTopics</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
			SELECT	MAX(SUBTOPICID) AS MAX_ID
			FROM		PDSUBTOPIC
		</CFQUERY>
		<CFSET FORM.SUBTOPICID =  #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="SUBTOPICID" secure="NO" value="#FORM.SUBTOPICID#">
		<CFQUERY name="AddPDSubTopicID" datasource="#application.type#WEBREPORTS">
			INSERT INTO	PDSUBTOPIC (SUBTOPICID)
			VALUES		(#val(Cookie.SUBTOPICID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Public Desk SubTopics Key &nbsp; = &nbsp; #FORM.SUBTOPICID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdsubtopic.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDSUBTOPIC" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SUBTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdsubtopic.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="SUBTOPIC">*Public Desk SubTopics:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="SUBTOPIC" id="SUBTOPIC" value="" align="LEFT" required="No" size="30" maxlength="30" tabindex="2"></TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSPDSUBTOPIC" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpdsubtopic.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPDSUBTOPIC" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
***********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Public Desk SubTopics. *
***********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPPDSUBTOPIC')>
			<TD align="center"><H1>Lookup for Modify/Delete Information to Web Reports - Public Desk SubTopics</H1></TD>
		<CFELSE>
			<TD align="center"><H1>Modify/Delete Information to Web Reports - Public Desk SubTopics</H1></TD>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPPDSUBTOPIC')>
		<TR>
			<TH align="center">Public Desk SubTopics Key &nbsp; = &nbsp; #FORM.SUBTOPICID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPPDSUBTOPIC')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=#URL.PROCESS#&LOOKUPPDSUBTOPIC=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%"><H4><LABEL for="SUBTOPICID">*Public Desk SubTopics</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SUBTOPICID" id="SUBTOPICID" size="1" query="ListPDSubTopic" value="SUBTOPICID" display="SUBTOPIC" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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
***********************************************************************************
* The following code is the Modify and Delete Processes for Public Desk SubTopics.*
***********************************************************************************
 --->

		<CFQUERY name="GetPDSubTopic" datasource="#application.type#WEBREPORTS">
			SELECT	SUBTOPICID, SUBTOPIC
			FROM		PDSUBTOPIC
			WHERE	SUBTOPICID = <CFQUERYPARAM value="#FORM.SUBTOPICID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SUBTOPIC
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SUBTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpdsubtopic.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SUBTOPICID" secure="NO" value="#FORM.SUBTOPICID#">
				<TH align="left"><H4><LABEL for="SUBTOPIC">*Public Desk SubTopics:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="SUBTOPIC" id="SUBTOPIC" value="#GetPDSubTopic.SUBTOPIC#" align="LEFT" required="No" size="30" maxlength="30" tabindex="2"></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPDSUBTOPIC" value="MODIFY" /><BR />
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
<CFFORM action="/#application.type#apps/webreports/pdsubtopic.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>