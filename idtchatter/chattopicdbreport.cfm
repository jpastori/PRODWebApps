<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: chattopicdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module:  IDT Chatter - Chat Topics Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/chattopicdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Chatter - Chat Topics Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListChatTopics" datasource="#application.type#IDTCHATTER" blockfactor="6">
	SELECT	TOPICID, TOPICINFO
	FROM		IDTCHATTOPICS
     WHERE	TOPICID > 0
	ORDER BY	TOPICINFO
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Chatter - Chat Topics Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="center" colspan="2"><H2>#ListChatTopics.RecordCount# Chat Topic records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="LEFT">Chat Topic</TH>
          <TH align="center">Chat Topic Key</TH>
	</TR>

<CFLOOP query="ListChatTopics">
	<TR>
		<TD align="LEFT">#ListChatTopics.TOPICINFO#</TD>
          <TD align="center">#ListChatTopics.TOPICID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="center" colspan="2"><H2>#ListChatTopics.RecordCount# Chat Topic records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
		<TD align="LEFT" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
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
</CFOUTPUT>

</BODY>
</HTML>