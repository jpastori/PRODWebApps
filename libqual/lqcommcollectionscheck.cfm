<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommcollectionscheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: LibQual - Check LibQual Collections Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommcollectionscheck.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>LibQual - Check LibQual Collections Comment Criteria</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the LibQual Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFQUERY name="GetLibqual_COLLComments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.COMMENTS, LQC.COL_MAINT, LQC.COL_ONLINE, LQC.COL_PERIODICALS, LQC.COL_PRINT
	FROM		LIBQUAL_COMMENTS LQC
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#URL.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - Check LibQual Collections Comment Criteria</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_COLLComments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_COLLComments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_COLLComments.DATEENTERED, "MM/DD/YYYY")#
		</TH>
	</TR>
</TABLE>
<BR clear = "left" />
<TABLE width="100%" border="0">
<CFFORM name="LIBQUALCOMMENTS" onsubmit="return validateReqFields();" action="processlqcomments.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH align="left" colspan="2">Comments</TH>
	</TR>
	<TR>
		<TD valign="top" align="left" colspan="2">
			<INPUT type="hidden" name="COMMENTID" value="#URL.COMMENTID#" />
			<TEXTAREA rows="15" cols="118" name="COMMENT" tabindex="1">#GetLibqual_COLLComments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2">Check all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="COL_MAINT" value="YES" tabindex="2">
			&nbsp;&nbsp;Collections Maintenance.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="COL_ONLINE" value="YES" tabindex="3">
			&nbsp;&nbsp;Online. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="COL_PERIODICALS" value="YES" tabindex="4">
			&nbsp;&nbsp;Periodicals.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="COL_PRINT" value="YES" tabindex="5">
			&nbsp;&nbsp;Print.
		</TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="COLLECTIONS" tabindex="6" /></TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>