<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: chattopicinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Chatter - Chat Topics --->
<!-- Last modified by John R. Pastori on 07/12/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/chattopicinfo.cfm">
<CFSET CONTENT_UPDATED = "July 12, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Chatter - Chat Topics</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Chatter - Chat Topics</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="../webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Chatter";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.CHATTOPIC.TOPICINFO.value == "" || document.CHATTOPIC.TOPICINFO.value == " ") {
			alertuser (document.CHATTOPIC.TOPICINFO.name +  ",  A Chat Topic MUST be entered!");
			document.CHATTOPIC.TOPICINFO.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.TOPICID.selectedIndex == "0") {
			alertuser ("A Chat Topic MUST be selected!");
			document.LOOKUP.TOPICID.focus();
			return false;
		}
	}
			
	
	function setDelete() {
		document.CHATTOPIC.PROCESSCHATTOPICS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCHATTOPIC') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.TOPICID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CHATTOPIC.TOPICINFO.focus()">
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

<CFQUERY name="ListChatTopics" datasource="#application.type#IDTCHATTER" blockfactor="6">
	SELECT	TOPICID, TOPICINFO
	FROM		IDTCHATTOPICS
	ORDER BY	TOPICINFO
</CFQUERY>

<!--- 
**********************************************************
* The following code is the ADD Process for Chat Topics. *
**********************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Chatter - Chat Topics</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
		SELECT	MAX(TOPICID) AS MAX_ID
		FROM		IDTCHATTOPICS
	</CFQUERY>
	<CFSET FORM.TOPICID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="TOPICID" secure="NO" value="#FORM.TOPICID#">
	<CFQUERY name="AddChatTopicsID" datasource="#application.type#IDTCHATTER">
		INSERT INTO	IDTCHATTOPICS (TOPICID)
		VALUES		(#val(Cookie.TOPICID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Chat Topic Key &nbsp; = &nbsp; #FORM.TOPICID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/processchattopicinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCHATTOPICS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CHATTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/processchattopicinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="TOPICINFO">*Chat Topic:</LABEL></H4></TH>
			<TD align="left"><CFINPUT type="Text" name="TOPICINFO" id="TOPICINFO" value="" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSCHATTOPICS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="3" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/processchattopicinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCHATTOPICS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="4" /><BR />
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
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Chat Topics. *
*************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCHATTOPIC')>
               <TD align="center"><H1>Modify/Delete Lookup Information in IDT Chatter - Chat Topics </H1></TD>
          <CFELSE>
               <TD align="center"><H1>Modify/Delete Information in IDT Chatter - Chat Topics</H1></TD>
          </CFIF>
          </TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPCHATTOPIC')>
		<TR>
			<TH align="center">Chat Topic Key &nbsp; = &nbsp; #FORM.TOPICID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCHATTOPIC')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPCHATTOPIC=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="TOPICID">*Chat Topic:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
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
**************************************************************************
* The following code is the Modify and Delete Processes for Chat Topics. *
**************************************************************************
 --->

		<CFQUERY name="GetChatTopics" datasource="#application.type#IDTCHATTER">
			SELECT	TOPICID, TOPICINFO
			FROM		IDTCHATTOPICS
			WHERE	TOPICID = <CFQUERYPARAM value="#FORM.TOPICID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	TOPICINFO
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CHATTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/processchattopicinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="TOPICID" secure="NO" value="#FORM.TOPICID#">
				<TH align="left" nowrap><H4><LABEL for="TOPICINFO">*Chat Topic:</LABEL></H4></TH>
				<TD align="left"><CFINPUT type="Text" name="TOPICINFO" id="TOPICINFO" value="#GetChatTopics.TOPICINFO#" align="LEFT" required="No" size="30" maxlength="25" tabindex="2"></TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCHATTOPICS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/idtchatter/chattopicinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
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