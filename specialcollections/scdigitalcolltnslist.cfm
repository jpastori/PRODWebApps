<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: scdigitalcolltnslist.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/19/2009 --->
<!--- Date in Production: 06/19/2009 --->
<!--- Module: Special Collections - Digital Collections Original File List --->
<!-- Last modified by John R. Pastori on 06/19/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/scdigitalcolltnslist.cfm">
<CFSET CONTENT_UPDATED = "June 19, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections - Digital Collections Original File List</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

</HEAD>

<BODY>
<CFOUTPUT>

<CFSET SESSION.FILEIMAGESIDS = "">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFQUERY name="ListSCDigitalColltns" datasource="#application.type#LUNACOLLECTIONS" blockfactor="100">
	SELECT	IRIF.IMAGEID, IRIF.FORMAT, IRLPS.LPS, IRIF.FILENAME, 
			'/home/luna/media/' || IRIF.FORMAT || '/' || IRLPS.LPS || '/' || IRIF.FILENAME AS FULLFILEPATHNAME
	FROM		COLLMGR.IRCOLLECTIONMEDIAMAP IRCMM, COLLMGR.IRIMAGEFILES IRIF, COLLMGR.IRLPS IRLPS
	WHERE	IRCMM.UNIQUECOLLECTIONID = 7 AND
			IRCMM.MEDIAID = IRIF.IMAGEID AND
			IRIF.FORMAT = 'SOURCE' AND
			IRIF.LPSID = IRLPS.LPSID
	ORDER BY	IRIF.FILENAME
</CFQUERY>

<CFSET SESSION.FILEIMAGESIDS = #ValueList(ListSCDigitalColltns.IMAGEID)#>
<CFSET FILECOUNTER = 0>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>Special Collections - Digital Collections Original File List</H1></TH>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TH align="LEFT" colspan="2">
			CLICK on a file name to start the Secure FTP Upload Process.
		</TH>
	</TR>
	<TR>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
	</TR>
	<CFLOOP query="ListSCDigitalColltns">
	<TR>
		<TD align="right" width ="5%">
			<CFSET FILECOUNTER = FILECOUNTER + 1>
			#FILECOUNTER#. &nbsp;&nbsp;
		</TD>
		<TD align="left" valign="TOP"width ="95%">
			<A href="ftp://digital.sdsu.edu/#ListSCDigitalColltns.FULLFILEPATHNAME#">#ListSCDigitalColltns.FILENAME#</A>
		</TD>
	</TR>
	</CFLOOP>
	<TR>
		<TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/specialcollections/index.cfm?logout=No" method="POST">
		<TD align="LEFT" valign="TOP" colspan="2">
			<INPUT type="SUBMIT" value="Cancel" tabindex="4" />&nbsp;&nbsp;
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>

</CFOUTPUT>
</BODY>
</HTML>