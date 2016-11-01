<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommcriteriacheck.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Modify Information to LibQual - Check LibQual Comment Criteria --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommcriteriacheck.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>Modify Information to LibQual - Check LibQual Comment Criteria</TITLE>
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

<CFIF FIND('index.cfm', #CGI.HTTP_REFERER#, 1) NEQ 0>
	<CFSET session.CommentIDArray = ArrayNew(1)>
	<CFSET client.KeyList = 0>
	<CFSET client.LQCRecordCounter = 0>

	<CFQUERY name="GetLibqual_Comments" datasource="#application.type#LIBQUAL" blockfactor="100">
		SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME, LQC.LIBQUALDISCIPLINEID,
				LQC.DISCIPLINEID, LQC.AGERANGEID, LQC.GENDERID, LQC.COMMENTS, LQC.BUDGET, LQC.RPT_CONFUSION, LQC.RPT_NEGATIVE,
				LQC.RPT_POSITIVE, LQC.CHECKEDBYID, LQC.RECCHECKED
		FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P
		WHERE	LQC.COMMENTID > 0 AND
				(LQC.CHECKEDBYID = 0 OR
				LQC.RECCHECKED = 'No') AND
				LQC.POSITIONID = P.POSITIONID
		ORDER BY	LQC.COMMENTID
	</CFQUERY>

	<CFIF GetLibqual_Comments.RecordCount EQ 0>
		ALL RECORDS HAVE BEEN PROCESSED!
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/libqual/index.cfm" />
		<CFEXIT>
	<CFELSE>
		<CFSET client.KeyList = #ValueList(GetLibqual_Comments.COMMENTID)#>
		<CFSET temp = ArraySet(session.CommentIDArray, 1, LISTLEN(client.KeyList), 0)>
		<CFSET session.CommentIDArray = ListToArray(client.KeyList)>
	</CFIF>

</CFIF>

<CFSET client.LQCRecordCounter = #client.LQCRecordCounter# + 1>
<CFSET FORM.COMMENTID = session.CommentIDArray[client.LQCRecordCounter]>

<CFQUERY name="GetLibqual_Comments" datasource="#application.type#LIBQUAL">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME, LQC.LIBQUALDISCIPLINEID,
			LQC.DISCIPLINEID, D.DISCIPLINENAME, LQC.AGERANGEID, LQC.GENDERID, LQC.COMMENTS, LQC.BUDGET, LQC.RPT_CONFUSION,
			LQC.RPT_NEGATIVE, LQC.RPT_POSITIVE, LQC.CHECKEDBYID, LQC.RECCHECKED
	FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P, WEBRPTSMGR.DISCIPLINES D
	WHERE	LQC.COMMENTID = <CFQUERYPARAM value="#FORM.COMMENTID#" cfsqltype="CF_SQL_NUMERIC"> AND
			LQC.POSITIONID = P.POSITIONID AND
			LQC.DISCIPLINEID = D.DISCIPLINEID
	ORDER BY	LQC.COMMENTID
</CFQUERY>

<CFQUERY name="GetPositions" datasource="#application.type#LIBQUAL" blockfactor="6">
	SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME
	FROM		LQPOSITIONS
	ORDER BY	POSITIONNAME
</CFQUERY>

<CFQUERY name="GetCheckedInitials" datasource="#application.type#LIBQUAL" blockfactor="12">
	SELECT	CHECKEDINITID, INITIALS
	FROM		LQCHECKEDINITIALS
	ORDER BY	INITIALS
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD align="center"><H1>Modify Information to LibQual - Check LibQual Comment Criteria</H1></TD>
	</TR>
</TABLE>
<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center">
			Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_Comments.COMMENTID#<BR />
			Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_Comments.LIBQUALRECID# &nbsp;&nbsp;&nbsp;&nbsp;
			Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_Comments.DATEENTERED, "MM/DD/YYYY")#
		</TH>
	</TR>
</TABLE>
<BR clear = "left" />
<TABLE width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm" method="POST">
		<TD align="left"><INPUT type="submit" name="ProcessComments" value="Cancel" tabindex="1" /></TD>
</CFFORM>
	</TR>
<CFFORM name="LIBQUALCOMMENTS" onsubmit="return validateReqFields();" action="processlqcomments.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<TH align="left" colspan="2">Comments</TH>
	</TR>
	<TR>
		<TD valign="top" align="left" colspan="2">
			<INPUT type="hidden" name="COMMENTID" value="#GetLibqual_Comments.COMMENTID#" />
			<TEXTAREA rows="15" cols="118" name="COMMENTS" tabindex="2">#GetLibqual_Comments.COMMENTS#</TEXTAREA>
		</TD>
	</TR>
	<TR>
		<TH align="left" colspan="2">Check all appropriate boxes.</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="BUDGET" value="YES" tabindex="3">
			&nbsp;&nbsp;Budget
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="RPT_CONFUSION" value="YES" tabindex="4">
			&nbsp;&nbsp;Confusion: &nbsp;&nbsp; Inaccurate comment, such as a complaint about 
			the lack of something that is in fact available. 
		</TD>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="RPT_NEGATIVE" value="YES" tabindex="5">
			&nbsp;&nbsp;Negative: &nbsp;&nbsp;Report a complaint or negative experience.
		</TD>
		<TD align="left">
			<CFINPUT type="CHECKBOX" name="RPT_POSITIVE" value="YES" tabindex="6">
			&nbsp;&nbsp;Positive: &nbsp;&nbsp;Report a compliment or positive experience.
		</TD>
	</TR>
	<TR>
		<TH align="left">Position/Discipline</TH>
		<TH align="left">Checked By</TH>
	</TR>
	<TR>
		<TD align="left">#GetLibqual_Comments.POSITIONNAME#&nbsp;&nbsp;/&nbsp;&nbsp;#GetLibqual_Comments.DISCIPLINENAME#</TD>
		<TD align="left">
			<CFSELECT name="CHECKEDBYID" size="1" query="GetCheckedInitials" value="CHECKEDINITID" display="INITIALS" selected="0" required="No" tabindex="7"></CFSELECT>
		</TD>
	</TR>
	<TR>
		
		<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="Modify" tabindex="8" /></TD>
		<TD align="left">
			<INPUT type="BUTTON" name="ProcessComments" value="Building" 
				onClick="window.open('/#application.type#apps/libqual/lqcommbuildingcheck.cfm?PROCESS=BUILDING&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Building Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
				tabindex="9" /><BR />
			<INPUT type="BUTTON" name="ProcessComments" value="Collections" 
				onClick="window.open('/#application.type#apps/libqual/lqcommcollectionscheck.cfm?PROCESS=COLLECTIONS&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Collections Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
				tabindex="10" /><BR />
			<INPUT type="BUTTON" name="ProcessComments" value="Policies" 
				onClick="window.open('/#application.type#apps/libqual/lqcommpoliciescheck.cfm?PROCESS=POLICIES&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Policies Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
				tabindex="11" /><BR />
			<INPUT type="BUTTON" name="ProcessComments" value="Service" 
				onClick="window.open('/#application.type#apps/libqual/lqcommservicecheck.cfm?PROCESS=SERVICE&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Service Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
				tabindex="12" /><BR />
			<INPUT type="BUTTON" name="ProcessComments" value="Technology" 
				onClick="window.open('/#application.type#apps/libqual/lqcommtechcheck.cfm?PROCESS=TECHNOLOGY&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Technology Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
				tabindex="13" /><BR />
			</TD>
	</TR>
</CFFORM>
	<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm" method="POST">
		<TD align="left"><INPUT type="submit" name="ProcessComments" value="Cancel" tabindex="14" /></TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>