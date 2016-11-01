<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: appcoldfusionerror.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/29/2011 --->
<!--- Date in Production: 03/29/2011 --->
<!--- Module: Application ColdFusion Error Handler --->
<!-- Last modified by John R. Pastori on 08/12/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "appcoldfusionerror.cfm">
<CFSET CONTENT_UPDATED = "August 12, 2015">
<CFINCLUDE template = "programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Application ColdFusion Error Handler</TITLE>
	<LINK rel="stylesheet" type="text/css" href="webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFSET QUESTIONMARKCOUNT = FINDONEOF('?', '#CGI.HTTP_REFERER#', 1)>
<!--- QUESTION MARK COUNT = #QUESTIONMARKCOUNT#<BR><BR> --->
<CFIF QUESTIONMARKCOUNT GT 0>
	<CFSET RETURNPGM = (LEFT(#CGI.HTTP_REFERER#, QUESTIONMARKCOUNT))>
<CFELSE>
	<CFSET RETURNPGM = #CGI.HTTP_REFERER#>
</CFIF>
<!--- RETURN PROGRAM-PART 1 = #RETURNPGM#<BR><BR> --->
<CFIF FIND('NEWADD', #CGI.HTTP_REFERER#, 1) NEQ 0>
	<CFSET RETURNPGM = (#RETURNPGM# & 'PROCESS=NEWADD')>
<CFELSEIF FIND('MODLOOP', #CGI.HTTP_REFERER#, 1) NEQ 0>
	<CFSET RETURNPGM = (#RETURNPGM# & 'PROCESS=MODLOOP')>
<CFELSEIF FIND('MODIFYDELETE', #CGI.HTTP_REFERER#, 1) NEQ 0>
	<CFSET RETURNPGM = (#RETURNPGM# & 'PROCESS=MODIFYDELETE')>
<CFELSE>
	<CFSET RETURNPGM = (#RETURNPGM#)>
</CFIF>

<CFIF FIND('LEGACY', #CGI.HTTP_REFERER#, 1) NEQ 0>
	<CFSET RETURNPGM = (#RETURNPGM# & '&LEGACY=YES')>
</CFIF>
<!--- RETURN PROGRAM-PART 2 = #RETURNPGM#<BR><BR> --->

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Data Entry Error</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" border=1>
	<CFIF IsDefined('URL.MESSAGE')>
	<TR>
		<TD align ="LEFT">
			<B>Error Message:</B><BR />
			<P>#URL.MESSAGE#</P>
			<P>#CGI.HTTP_REFERER#</P>
		</TD>
	</TR>
	</CFIF>
	<TR>
		<TD align ="LEFT">
			<B>Error Information:</B><BR />
			<P>You failed to correctly complete all the fields
			in the form. The following problems occurred:</P>
		</TD>
	</TR>
	<TR>
		<TD align ="LEFT">
			#error.generatedContent#<BR />
			#error.diagnostics#<BR /><BR />
		</TD>
	</TR>
	<TR>
		<TD align ="LEFT">
			Date and time: #error.DateTime# <BR />
			Page: #error.template# <BR />
			Remote Address: #error.remoteAddress# <BR />
			HTTP Referer: #error.HTTPReferer#<BR />
		</TD>
	</TR>
	<TR>
		<TD align="CENTER"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

<META http-equiv="Refresh" content="15; URL=#RETURNPGM#" />

</CFOUTPUT>

</BODY>
</HTML>