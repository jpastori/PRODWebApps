<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommentsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: LibQual - LIBQUAL Comments Report --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommentsdbreport.cfm">
<CFSET CONTENT_UPDATED = "January 13, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual - LIBQUAL Comments Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT LANGUAGE=JAVASCRIPT>
	window.defaultStatus = "Welcome to the LibQual Application";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<!--- 
***************************************************************************************
* The following code is the process for LibQual - LIBQUAL Comments Report generation. *
***************************************************************************************
 --->

<CFOUTPUT>

	<cfquery name="ListLIBQUAL_Comments" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
	SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME, LQC.LIBQUALDISCIPLINEID,
			LQC.DISCIPLINEID, D.DISCIPLINENAME, LQC.AGERANGEID, AR.AGERANGENAME, LQC.GENDERID, G.GENDERNAME, LQC.COMMENTS,
			LQC.BUILDINGGROUP, LQC.COLLECTIONSGROUP, LQC.POLICIESGROUP, LQC.REPORTGROUP, LQC.BUDGET, LQC.RPT_CONFUSION,
			LQC.RPT_NEGATIVE, LQC.RPT_POSITIVE, LQC.SERVICEGROUP, LQC.TECHNOLOGYGROUP, LQC.CHECKEDBYID, CI.INITIALS, LQC.RECCHECKED
	FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P, WEBRPTSMGR.DISCIPLINES D, LIBSHAREDDATAMGR.AGERANGES AR, LIBSHAREDDATAMGR.GENDER G, LQCHECKEDINITIALS CI
	WHERE	LQC.COMMENTID > 0 AND
			LQC.POSITIONID = P.POSITIONID AND
			LQC.DISCIPLINEID = D.DISCIPLINEID AND
			LQC.AGERANGEID = AR.AGERANGEID AND
			LQC.GENDERID = G.GENDERID AND
			LQC.CHECKEDBYID = CI.CHECKEDINITID
	ORDER BY	LQC.LIBQUALRECID
</cfquery>

<TABLE width="100%" align="center" BORDER="3">
	<TR align="center">
		<TD align="center">
			<H1>LibQual - LIBQUAL Comments Report
		</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" align="LEFT">
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="10">
			<INPUT type="submit" value="Cancel" tabindex="1" />
		</TD>
</cfform>
	</TR>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="12"><H2>#ListLIBQUAL_Comments.RecordCount# LIBQUAL Comment records were selected.</H2></TH>
	</TR>
	<TR>
		<TH ALIGN="CENTER">LIBQUAL Record ID</TH>
		<TH ALIGN="CENTER">Date Entered</TH>
		<TH ALIGN="LEFT" VALIGN="BOTTOM">Position</TH>
		<TH ALIGN="LEFT" VALIGN="BOTTOM">Discipline</TH>
		<TH ALIGN="LEFT">Age Range</TH>
		<TH ALIGN="LEFT">Gender</TH>
		<TH ALIGN="CENTER">Budget</TH>
		<TH ALIGN="CENTER">Report Confusion</TH>
		<TH ALIGN="CENTER">Report Negative</TH>
		<TH ALIGN="CENTER">Report Positive</TH>
		<TH ALIGN="CENTER" VALIGN="BOTTOM">Checked By</TH>
		<TH ALIGN="CENTER">Record Checked</TH>
	</TR>

<CFLOOP QUERY="ListLIBQUAL_Comments">
	<TR>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.LIBQUALRECID#</DIV></TD>
		<TD ALIGN="LEFT" VALIGN="TOP"><DIV>#DateFormat(ListLIBQUAL_Comments.DATEENTERED, "MM/DD/YYYY")#</DIV></TD>
		<TD ALIGN="LEFT" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.POSITIONNAME#</DIV></TD>
		<TD ALIGN="LEFT" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.DISCIPLINENAME#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.AGERANGENAME#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.GENDERNAME#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.BUDGET#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.RPT_CONFUSION#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.RPT_NEGATIVE#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.RPT_POSITIVE#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.INITIALS#</DIV></TD>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.RECCHECKED#</DIV></TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT" VALIGN="TOP">Building Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.BUILDINGGROUP#</DIV></TD>
		<TH ALIGN="LEFT">Collections Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.COLLECTIONSGROUP#</DIV></TD>
		<TH ALIGN="LEFT">Policies Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.POLICIESGROUP#</DIV></TD>
		<TH ALIGN="LEFT" VALIGN="TOP">Report Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.REPORTGROUP#</DIV></TD>
		<TH ALIGN="LEFT" VALIGN="TOP">Service Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.SERVICEGROUP#</DIV></TD>
		<TH ALIGN="LEFT" VALIGN="TOP">Technology Group Comments:</TH>
		<TD ALIGN="CENTER" VALIGN="TOP"><DIV>#ListLIBQUAL_Comments.TECHNOLOGYGROUP#</DIV></TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT" VALIGN="TOP">Comments:</TH>
		<TD ALIGN="LEFT" VALIGN="TOP" COLSPAN="11"><DIV>#ListLIBQUAL_Comments.COMMENTS#</DIV></TD>
	</TR>
	<TR>
		<TD ALIGN="CENTER" COLSPAN="12"><HR SIZE="5" NOSHADE /></TD>
	</TR>
</CFLOOP>
	<TR>
		<TH ALIGN="CENTER" COLSPAN="12"><H2>#ListLIBQUAL_Comments.RecordCount# LIBQUAL Comment records were selected.</H2></TH>
	</TR>
	<TR>
<cfform action="#Cookie.INDEXDIR#/index.cfm?logout=No" METHOD="POST">
		<TD align="LEFT" COLSPAN="12">
			<INPUT type="submit" value="Cancel" tabindex="2" />
		</TD>
</cfform>
	</TR>
	<TR>
		<TD align="LEFT" COLSPAN="12">
			<CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm">
		</TD>
	</TR>
</TABLE>
</cfoutput>

</BODY>
</HTML>