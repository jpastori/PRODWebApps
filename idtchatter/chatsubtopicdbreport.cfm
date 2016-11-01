<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: chatsubtopicdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Chatter - Chat Sub-Topics Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/chatsubtopicdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Chatter - Chat Sub-Topics Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFQUERY name="ListChatSubTopics" datasource="#application.type#IDTCHATTER" blockfactor="40">
	SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICST.SUBTOPICINFO, ICT.TOPICID, ICT.TOPICINFO,
     		ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO AS KEYFINDER
	FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
	WHERE	ICST.SUBTOPICID > 0 AND
     		ICST.TOPICID = ICT.TOPICID
	ORDER BY	KEYFINDER
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR>
		<TD align="center"><H1>IDT Chatter - Chat Sub-Topics Report</H1></TD>
	</TR>
</TABLE>
<BR />
<TABLE width="100%" border="0" VALIGN="top" cellpadding="0" cellspacing="0">
	<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="center" colspan="3"><H2>#ListChatSubTopics.RecordCount# Chat Sub-Topic records were selected.</H2></TH>
	</TR>
	<TR>
		<TH align="left">Chat Topic</TH>
		<TH align="left">Chat Sub-Topic</TH>
          <TH align="center">Chat Sub-Topic Key</TH>
	</TR>

<CFLOOP query="ListChatSubTopics">
	<TR>
		<TD align="left">#ListChatSubTopics.TOPICINFO#</TD>
		<TD align="left">#ListChatSubTopics.SUBTOPICINFO#</TD>
          <TD align="center">#ListChatSubTopics.SUBTOPICID#</TD>
	</TR>
</CFLOOP>
	<TR>
		<TH align="center" colspan="3"><H2>#ListChatSubTopics.RecordCount# Chat Sub-Topic records were selected.</H2></TH>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
		<TD align="LEFT">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="LEFT" colspan="3">
			<CFINCLUDE template="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>