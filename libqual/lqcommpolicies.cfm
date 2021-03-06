<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommpolicies.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: >Modify Information to LibQual - LibQual Policies Comments --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommpolicies.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>>Modify Information to LibQual - LibQual Policies Comments</TITLE>
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

<CFQUERY name="GetLibqual_POLComments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.COMMENTS, LQC.POL_CELLPHONES, LQC.POL_EATDRINK, LQC.POL_FINES,
			LQC.POL_GENERAL, LQC.POL_NOISE, LQC.POL_SLEEPING
	FROM		LIBQUAL_COMMENTS LQC
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#URL.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - LibQual Policies Comments</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_POLComments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_POLComments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_POLComments.DATEENTERED, "MM/DD/YYYY")#
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
			<TEXTAREA rows="15" cols="118" name="COMMENT" tabindex="1">#GetLibqual_POLComments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2"> all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_CELLPHONES EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_CELLPHONES" value="#GetLibqual_POLComments.POL_CELLPHONES#" checked tabindex="2">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_CELLPHONES" value="YES" tabindex="2">
		</CFIF>
			&nbsp;&nbsp;Cell Phones.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_EATDRINK EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_EATDRINK" value="#GetLibqual_POLComments.POL_EATDRINK#" checked tabindex="3">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_EATDRINK" value="YES" tabindex="3">
		</CFIF>
			&nbsp;&nbsp;Eating/Drinking. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_FINES EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_FINES" value="#GetLibqual_POLComments.POL_FINES#" checked tabindex="4">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_FINES" value="YES" tabindex="4">
		</CFIF>
			&nbsp;&nbsp;Fines.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_GENERAL EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_GENERAL" value="#GetLibqual_POLComments.POL_GENERAL#" checked tabindex="5">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_GENERAL" value="YES" tabindex="5">
		</CFIF>
			&nbsp;&nbsp;General.
		</TD>
	</TR>
	<TR>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_NOISE EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_NOISE" value="#GetLibqual_POLComments.POL_NOISE#" checked tabindex="6">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_NOISE" value="YES" tabindex="6">
		</CFIF>
			&nbsp;&nbsp;Noise.
		</TD>
		<TD align="left">
		<CFIF GetLibqual_POLComments.POL_SLEEPING EQ 'YES'>
			<CFINPUT type="CHECKBOX" name="POL_SLEEPING" value="#GetLibqual_POLComments.POL_SLEEPING#" checked tabindex="7">
		<CFELSE>
			<CFINPUT type="CHECKBOX" name="POL_SLEEPING" value="YES" tabindex="7">
		</CFIF>
			&nbsp;&nbsp;Sleeping. 
		</TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="POLICIES" tabindex="8" /></TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>