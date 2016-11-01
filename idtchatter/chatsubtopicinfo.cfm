<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: chatsubtopicinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Chatter - Chat Sub-Topics --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/chatsubtopicinfo.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Chatter - Chat Sub-Topics</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Chatter - Chat Sub-Topics</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

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
		if (document.CHATSUBTOPIC.TOPICID.selectedIndex == "0") {
			alertuser (document.CHATSUBTOPIC.TOPICID.name +  ",  A Chat Topic MUST be selected!");
			document.CHATSUBTOPIC.TOPICID.focus();
			return false;
		}

		if (document.CHATSUBTOPIC.SUBTOPICINFO.value == "" || document.CHATSUBTOPIC.SUBTOPICINFO.value == " ") {
			alertuser (document.CHATSUBTOPIC.SUBTOPICINFO.name +  ",  A Chat Sub-Topic MUST be entered!");
			document.CHATSUBTOPIC.SUBTOPICINFO.focus();
			return false;
		}
	}

	function validateLookupField() {
		if (document.LOOKUP.SUBTOPICID.selectedIndex == "0") {
			alertuser ("A Chat Sub-Topic MUST be selected!");
			document.LOOKUP.SUBTOPICID.focus();
			return false;
		}
	}
		
	
	function setDelete() {
		document.CHATSUBTOPIC.PROCESSCHATSUBTOPICS.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCHATSUBTOPIC') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SUBTOPICID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CHATSUBTOPIC.TOPICID.focus()">
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

<CFQUERY name="ListChatSubTopics" datasource="#application.type#IDTCHATTER" blockfactor="100">
	SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICST.SUBTOPICINFO, ICT.TOPICID, ICT.TOPICINFO,
     		ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO AS KEYFINDER
	FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
	WHERE	ICST.TOPICID = ICT.TOPICID
	ORDER BY	KEYFINDER
</CFQUERY>

<CFQUERY name="ListChatTopics" datasource="#application.type#IDTCHATTER" blockfactor="10">
	SELECT	TOPICID, TOPICINFO
	FROM		IDTCHATTOPICS
	ORDER BY	TOPICINFO
</CFQUERY>

<!--- 
**************************************************************
* The following code is the ADD Process for Chat Sub-Topics. *
**************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Chatter - Chat Sub-Topics</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
		SELECT	MAX(SUBTOPICID) AS MAX_ID
		FROM		IDTCHATSUBTOPICS
	</CFQUERY>
	<CFSET FORM.SUBTOPICID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SUBTOPICID" secure="NO" value="#FORM.SUBTOPICID#">
	<CFQUERY name="AddChatSubTopicsID" datasource="#application.type#IDTCHATTER" blockfactor="100">
		INSERT INTO	IDTCHATSUBTOPICS (SUBTOPICID)
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
				Chat Sub-Topic Key &nbsp; = &nbsp; #FORM.SUBTOPICID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/processchatsubtopicinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCHATSUBTOPICS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CHATSUBTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/processchatsubtopicinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="TOPICID">*Chat Topic</LABEL></H4></TH>
			<TH align="left" nowrap><H4><LABEL for="SUBTOPICINFO">*Chat Sub-Topic</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
               	<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" selected="0" required="No" tabindex="2"></CFSELECT>
               </TD>
			<TD align="left">
               	<CFINPUT type="Text" name="SUBTOPICINFO" id="SUBTOPICINFO" value="" align="LEFT" required="No" size="50" maxlength="100" tabindex="3">
               </TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSCHATSUBTOPICS" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/processchatsubtopicinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSCHATSUBTOPICS" value="CANCELADD" />
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
*****************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Chat Sub-Topics. *
*****************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<CFIF NOT IsDefined('URL.LOOKUPCHATSUBTOPIC')>
               <TD align="center"><H1>Modify/Delete Lookup Information in IDT Chatter - Chat Sub-Topics </H1></TD>
          <CFELSE>
               <TD align="center"><H1>Modify/Delete Information in IDT Chatter - Chat Sub-Topics</H1></TD>
          </CFIF>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPCHATSUBTOPIC')>
		<TR>
			<TH align="center">Chat Sub-Topic Key &nbsp; = &nbsp; #FORM.SUBTOPICID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCHATSUBTOPIC')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPCHATSUBTOPIC=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="SUBTOPICID">*Chat Sub-Topic:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SUBTOPICID" id="SUBTOPICID" size="1" query="ListChatSubTopics" value="SUBTOPICID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
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
******************************************************************************
* The following code is the Modify and Delete Processes for Chat Sub-Topics. *
******************************************************************************
 --->

		<CFQUERY name="GetChatSubTopics" datasource="#application.type#IDTCHATTER">
			SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICST.SUBTOPICINFO, ICT.TOPICID, ICT.TOPICINFO,
     				ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO AS KEYFINDER
               FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
               WHERE	ICST.SUBTOPICID = <CFQUERYPARAM value="#FORM.SUBTOPICID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		ICST.TOPICID = ICT.TOPICID
               ORDER BY	KEYFINDER
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CHATSUBTOPIC" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/processchatsubtopicinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SUBTOPICID" secure="NO" value="#FORM.SUBTOPICID#">
				<TH align="left" nowrap><H4><LABEL for="TOPICID">*Chat Topic</LABEL></H4></TH>
				<TH align="left" nowrap><H4><LABEL for="SUBTOPICINFO">*Chat Sub-Topic</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
                    	<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" selected="#GetChatSubTopics.TOPICID#" required="No" tabindex="2"></CFSELECT>
                    </TD>
				<TD align="left">
                    	<CFINPUT type="Text" name="SUBTOPICINFO" id="SUBTOPICINFO" value="#GetChatSubTopics.SUBTOPICINFO#" align="LEFT" required="No" size="50" maxlength="100" tabindex="3">
                    </TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSCHATSUBTOPICS" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/idtchatter/chatsubtopicinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
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