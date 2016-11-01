<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommbuildingcheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: LibQual - Check LibQual Building Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommbuildingcheck.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>LibQual - Check LibQual Building Comment Criteria</TITLE>
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

<CFQUERY name="GetLibqual_BLDGComments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.COMMENTS, LQC.BLD_ACCESSIBILITY, LQC.BLD_CLEANMAINT, LQC.BLD_ELECTOUTLETS,
			LQC.BLD_FURNITURE, LQC.BLD_GROUPSTUDY, LQC.BLD_HEATCOOL, LQC.BLD_HOURS, LQC.BLD_LIGHTING, LQC.BLD_QUIETSPACE, LQC.BLD_RESTROOMS,
			LQC.BLD_SAFETY, LQC.BLD_SIGNAGE, LQC.BLD_STUDYSPACE
	FROM		LIBQUAL_COMMENTS LQC
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#URL.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - Check LibQual Building Comment Criteria</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_BLDGComments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_BLDGComments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_BLDGComments.DATEENTERED, "MM/DD/YYYY")#
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
			<TEXTAREA rows="15" cols="118" name="COMMENT" tabindex="1">#GetLibqual_BLDGComments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2">Check all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_ACCESSIBILITY" value="YES" tabindex="2">
			&nbsp;&nbsp;Accessibility: &nbsp;&nbsp;Height of shelves, width of aisles, parking.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_CLEANMAINT" value="YES" tabindex="3">
			&nbsp;&nbsp;Cleaning/Maintenance. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_ELECTOUTLETS" value="YES" tabindex="4">
			&nbsp;&nbsp;Electrical Outlets.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_FURNITURE" value="YES" tabindex="5">
			&nbsp;&nbsp;Furniture.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_GROUPSTUDY" value="YES" tabindex="6">
			&nbsp;&nbsp;Group Study.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_HEATCOOL" value="YES" tabindex="7">
			&nbsp;&nbsp;Heating/Cooling. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_HOURS" value="YES" tabindex="8">
			&nbsp;&nbsp;Hours.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_LIGHTING" value="YES" tabindex="9">
			&nbsp;&nbsp;Lighting.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_QUIETSPACE" value="YES" tabindex="10">
			&nbsp;&nbsp;Quiet Space.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_RESTROOMS" value="YES" tabindex="11">
			&nbsp;&nbsp;Restrooms. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_SAFETY" value="YES" tabindex="12">
			&nbsp;&nbsp;Safety.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_SIGNAGE" value="YES" tabindex="13">
			&nbsp;&nbsp;Signage.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BLD_STUDYSPACE" value="YES" tabindex="14">
			&nbsp;&nbsp;Study Space.
		</TD>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="BUILDING" tabindex="15" /></TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>