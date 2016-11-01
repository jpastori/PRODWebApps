<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommservicecheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: LibQual - Check LibQual Service Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommservicecheck.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>LibQual - Check LibQual Service Comment Criteria</TITLE>
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

<CFQUERY name="GetLibqual_SRVComments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.COMMENTS, LQC.SRV_CIRCUIT, LQC.SRV_CIRCDESK, LQC.SRV_COPYSRVCS, LQC.SRV_ECR,
			LQC.SRV_ELECTRONICREF, LQC.SRV_GOVTPUBS, LQC.SRV_HOURS, LQC.SRV_INSTREDOR, LQC.SRV_ILL, LQC.SRV_LIBRINTERACT, LQC.SRV_LINKPLUS,
			LQC.SRV_MEDIACNTR, LQC.SRV_CPMC, LQC.SRV_REFDESK, LQC.SRV_RBR, LQC.SRV_SCC, LQC.SRV_SPCOLL, LQC.SRV_STAFFINTERACT, LQC.SRV_STUDNTINTERACT,
			LQC.SRV_TELEPHONE, LQC.SRV_WEBOPACSRVC
	FROM		LIBQUAL_COMMENTS LQC
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#URL.COMMENTID#" cfsqltype="CF_SQL_NUMERIC">
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - Check LibQual Service Comment Criteria</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_SRVComments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_SRVComments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_SRVComments.DATEENTERED, "MM/DD/YYYY")#
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
			<TEXTAREA rows="15" cols="118" name="COMMENT" tabindex="1">#GetLibqual_SRVComments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2">Check all appropriate boxes</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_CIRCUIT" value="YES" tabindex="2">
			&nbsp;&nbsp;Circuit.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_CIRCDESK" value="YES" tabindex="3">
			&nbsp;&nbsp;Circulation Desk.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_COPYSRVCS" value="YES" tabindex="4">
			&nbsp;&nbsp;Copy Service. 
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_ECR" value="YES" tabindex="5">
			&nbsp;&nbsp;ECR.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_ELECTRONICREF" value="YES" tabindex="6">
			&nbsp;&nbsp;Electronic Reference.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_GOVTPUBS" value="YES" tabindex="7">
			&nbsp;&nbsp;Government Publications.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_HOURS" value="YES" tabindex="8">
			&nbsp;&nbsp;Hours.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_INSTREDOR" value="YES" tabindex="9">
			&nbsp;&nbsp;Instruction/Education/Outreach. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_ILL" value="YES" tabindex="10">
			&nbsp;&nbsp;Interlibrary Loan.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_LIBRINTERACT" value="YES" tabindex="11">
			&nbsp;&nbsp;Librarian:&nbsp;&nbsp;Interaction with professional staff. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_LINKPLUS" value="YES" tabindex="12">
			&nbsp;&nbsp;Link +.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_MEDIACNTR" value="YES" tabindex="13">
			&nbsp;&nbsp;Media Center.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_CPMC" value="YES" tabindex="14">
			&nbsp;&nbsp;Periodicals Desk (CPMC).
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_REFDESK" value="YES" tabindex="15">
			&nbsp;&nbsp;Reference Desk.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_RBR" value="YES" tabindex="16">
			&nbsp;&nbsp;Reserve Book Room. 
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_SCC" value="YES" tabindex="17">
			&nbsp;&nbsp;Student Computing Center.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_SPCOLL" value="YES" tabindex="18">
			&nbsp;&nbsp;Special Collections.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_STAFFINTERACT" value="YES" tabindex="19">
			&nbsp;&nbsp;Staff:&nbsp;&nbsp;Interaction with support/technical staff.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_STUDNTINTERACT" value="YES" tabindex="20">
			&nbsp;&nbsp;Student:&nbsp;&nbsp;Interaction with student worker.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_TELEPHONE" value="YES" tabindex="21">
			&nbsp;&nbsp;Telephone.
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="SRV_WEBOPACSRVC" value="YES" tabindex="22">
			&nbsp;&nbsp;Website & OPAC Service.
		</TD>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="SERVICE" tabindex="23" /></TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>