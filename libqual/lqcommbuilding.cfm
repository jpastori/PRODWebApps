<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommbuilding.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Modify Information to LibQual - LibQual Building Comments --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommbuilding.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>Modify Information to LibQual - LibQual Building Comments</TITLE>
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
		<TD align="center"><H1>Modify Information to LibQual - LibQual Building Comments</H1></TD>
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
		<TH align="left" colspan="2"> all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_ACCESSIBILITY EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_ACCESSIBILITY" value="#GetLibqual_BLDGComments.BLD_ACCESSIBILITY#" checked tabindex="2">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_ACCESSIBILITY" value="YES" tabindex="2">
		</CFIF>
			&nbsp;&nbsp;Accessibility: &nbsp;&nbsp;Height of shelves, width of aisles, parking.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_CLEANMAINT EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_CLEANMAINT" value="#GetLibqual_BLDGComments.BLD_CLEANMAINT#" checked tabindex="3">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_CLEANMAINT" value="YES" tabindex="3">
		</CFIF>
			&nbsp;&nbsp;Cleaning/Maintenance. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_ELECTOUTLETS EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_ELECTOUTLETS" value="#GetLibqual_BLDGComments.BLD_ELECTOUTLETS#" checked tabindex="4">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_ELECTOUTLETS" value="YES" tabindex="4">
		</CFIF>
			&nbsp;&nbsp;Electrical Outlets.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_FURNITURE EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_FURNITURE" value="#GetLibqual_BLDGComments.BLD_FURNITURE#" checked tabindex="5">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_FURNITURE" value="YES" tabindex="5">
		</CFIF>
			&nbsp;&nbsp;Furniture.
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_GROUPSTUDY EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_GROUPSTUDY" value="#GetLibqual_BLDGComments.BLD_GROUPSTUDY#" checked tabindex="6">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_GROUPSTUDY" value="YES" tabindex="6">
		</CFIF>
			&nbsp;&nbsp;Group Study.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_HEATCOOL EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_HEATCOOL" value="#GetLibqual_BLDGComments.BLD_HEATCOOL#" checked tabindex="7">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_HEATCOOL" value="YES" tabindex="7">
		</CFIF>
			&nbsp;&nbsp;Heating/Cooling. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_HOURS EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_HOURS" value="#GetLibqual_BLDGComments.BLD_HOURS#" checked tabindex="8">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_HOURS" value="YES" tabindex="8">
		</CFIF>
			&nbsp;&nbsp;Hours.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_LIGHTING EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_LIGHTING" value="#GetLibqual_BLDGComments.BLD_LIGHTING#" checked tabindex="9">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_LIGHTING" value="YES" tabindex="9">
		</CFIF>
			&nbsp;&nbsp;Lighting.
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_QUIETSPACE EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_QUIETSPACE" value="#GetLibqual_BLDGComments.BLD_QUIETSPACE#" checked tabindex="10">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_QUIETSPACE" value="YES" tabindex="10">
		</CFIF>
			&nbsp;&nbsp;Quiet Space.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_RESTROOMS EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_RESTROOMS" value="#GetLibqual_BLDGComments.BLD_RESTROOMS#" checked tabindex="11">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_RESTROOMS" value="YES" tabindex="11">
		</CFIF>
			&nbsp;&nbsp;Restrooms. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_SAFETY EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_SAFETY" value="#GetLibqual_BLDGComments.BLD_SAFETY#" checked tabindex="12">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_SAFETY" value="YES" tabindex="12">
		</CFIF>
			&nbsp;&nbsp;Safety.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_SIGNAGE EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_SIGNAGE" value="#GetLibqual_BLDGComments.BLD_SIGNAGE#" checked tabindex="13">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_SIGNAGE" value="YES" tabindex="13">
		</CFIF>
			&nbsp;&nbsp;Signage.
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_BLDGComments.BLD_STUDYSPACE EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="BLD_STUDYSPACE" value="#GetLibqual_BLDGComments.BLD_STUDYSPACE#" checked tabindex="14">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="BLD_STUDYSPACE" value="YES" tabindex="14">
		</CFIF>
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