<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommtechcheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: LibQual - Check LibQual Technology Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommtechcheck.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>LibQual - Check LibQual Technology Comment Criteria</TITLE>
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

<CFQUERY name="GetLibqual_TECHComments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.COMMENTS, LQC.TECH_COMPTECHGENRL, LQC.TECH_OTHERHW,
			LQC.TECH_OTHERLIBCOMP, LQC.TECH_PERCOMPLAB, LQC.TECH_PRINTING, LQC.TECH_REFCOMPLAB, LQC.TECH_REMOTEACCESS,
			LQC.TECH_RBRLAB, LQC.TECH_SCCLAB
	FROM		LIBQUAL_COMMENTS LQC
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#URL.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - Check LibQual Technology Comment Criteria</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_TECHComments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_TECHComments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_TECHComments.DATEENTERED, "MM/DD/YYYY")#
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
			<TEXTAREA rows="15" cols="118" name="COMMENT" tabindex="1">#GetLibqual_TECHComments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2">Check all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_COMPTECHGENRL" value="YES" tabindex="2">
			&nbsp;&nbsp;Computer/Technology General.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_OTHERHW" value="YES" tabindex="3">
			&nbsp;&nbsp;Other Hardware. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_OTHERLIBCOMP" value="YES" tabindex="4">
			&nbsp;&nbsp;Other Library Computers.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_PERCOMPLAB" value="YES" tabindex="5">
			&nbsp;&nbsp;Periodicals Computer Lab.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_PRINTING" value="YES" tabindex="6">
			&nbsp;&nbsp;Printing.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_REFCOMPLAB" value="YES" tabindex="7">
			&nbsp;&nbsp;Reference Computer Lab. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_REMOTEACCESS" value="YES" tabindex="8">
			&nbsp;&nbsp;Remote Access.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_RBRLAB" value="YES" tabindex="9">
			&nbsp;&nbsp;Reserve Book Room Lab.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="TECH_SCCLAB" value="YES" tabindex="10">
			&nbsp;&nbsp;Student Computing Center Lab.
		</TD>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="Technology" tabindex="11" /></TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>