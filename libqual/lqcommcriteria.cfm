<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqcommcriteria.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Modify Information to LibQual - LibQual Comments --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqcommcriteria.cfm">
<CFSET CONTENT_UPDATED = "February 01, 2008">

<HTML>
<HEAD>
	<TITLE>Modify Information to LibQual - LibQual Comments</TITLE>
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

	function validateLookupField() {
		if (document.LOOKUP.COMMENTID1.selectedIndex == "0" && document.LOOKUP.COMMENTID2.selectedIndex == "0") {
			alertuser ("A Comment Record MUST be selected!");
			document.LOOKUP.COMMENTID1.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPLQCOMMENTS')>
	<CFSET CURSORFIELD = "document.LOOKUP.COMMENTID1.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.LIBQUALCOMMENTS.BUDGET.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<!--- 
***************************************************************************************
* The following code is the Look Up Process for Modifying LibQual - LibQual Comments. *
***************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPLQCOMMENTS')>

	<CFQUERY name="ListLIBQUAL_Comments1" datasource="#application.type#LIBQUAL" blockfactor="100">
		SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME,
				LQC.LIBQUALDISCIPLINEID, LQC.DISCIPLINEID, D.DISCIPLINENAME, LQC.COMMENTS,
				LQC.LIBQUALRECID || ' - ' || P.POSITIONNAME || ' - ' || SUBSTR(LQC.COMMENTS,1,60) AS LOOKUPKEY
		FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P, WEBRPTSMGR.DISCIPLINES D
		WHERE	LQC.POSITIONID = P.POSITIONID AND
				LQC.DISCIPLINEID = D.DISCIPLINEID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
	
	<CFQUERY name="ListLIBQUAL_Comments2" datasource="#application.type#LIBQUAL" blockfactor="100">
		SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME,
				LQC.LIBQUALDISCIPLINEID, LQC.DISCIPLINEID, D.DISCIPLINENAME, LQC.COMMENTS, SUBSTR(LQC.COMMENTS,1,100) AS LOOKUPKEY
		FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P, WEBRPTSMGR.DISCIPLINES D
		WHERE	LQC.POSITIONID = P.POSITIONID AND
				LQC.DISCIPLINEID = D.DISCIPLINEID
		ORDER BY	LOOKUPKEY
	</CFQUERY>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify Information to LibQual - LibQual Comments</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/libqual/lqcommcriteria.cfm?LOOKUPLQCOMMENTS=FOUND" method="POST">
		<TR>
			<TH align="LEFT" width="30%"><H4>*LIBQUAL Record Key - Position - Partial Comment:</H4></TH>
			<TD align="LEFT" width="70%">
				<CFSELECT name="COMMENTID1" size="1" query="ListLIBQUAL_Comments1" value="COMMENTID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="LEFT" width="30%">OR <H4>*LIBQUAL Partial Comment:</H4></TH>
			<TD align="LEFT" width="70%">
				<CFSELECT name="COMMENTID2" size="1" query="ListLIBQUAL_Comments2" value="COMMENTID" display="LOOKUPKEY" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT"><INPUT type="submit" value="GO" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/index.cfm?logout=No" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
****************************************************************************
* The following code is the Modify Process for LibQual - LibQual Comments. *
****************************************************************************
 --->

	<CFIF NOT IsDefined('client.RecordCounter')>
		<CFIF IsDefined('FORM.COMMENTID1') AND #FORM.COMMENTID1# GT 0>
			<CFSET FORM.COMMENTID = #FORM.COMMENTID1#>
		<CFELSE>
			<CFSET FORM.COMMENTID = #FORM.COMMENTID2#>
		</CFIF>
		<CFSET client.LQCRecordCounter = 0>
		<CFSET client.LQCRecordCount = 0>
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
	
	</CFIF>
	
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
			<TD align="center"><H1>Modify Information to LibQual - LibQual Comments</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				Libqual Comment Key &nbsp; = &nbsp; #GetLibqual_Comments.COMMENTID#<BR />
				Libqual Record ID = &nbsp; = &nbsp; #GetLibqual_Comments.LIBQUALRECID#&nbsp;&nbsp;&nbsp;&nbsp;
				Date Record Entered= &nbsp; = &nbsp; #DateFormat(GetLibqual_Comments.DATEENTERED, "MM/DD/YYYY")#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	<TABLE width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libqual/lqcommcriteria.cfm" method="POST">
			<TD align="left"><INPUT type="submit" name="ProcessComments" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
<CFFORM name="LIBQUALCOMMENTS" action="processlqcomments.cfm" method="POST" ENABLECAB="Yes">
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
			<CFIF GetLibqual_Comments.BUDGET EQ 'YES'>
				<CFINPUT type="CHECKBOX" name="BUDGET" value="#GetLibqual_Comments.BUDGET#" checked tabindex="3">
			<CFELSE>
				<CFINPUT type="CHECKBOX" name="BUDGET" value="YES" tabindex="3">
			</CFIF>
				&nbsp;&nbsp;Budget
			</TD>
			<TD align="left">
			<CFIF GetLibqual_Comments.RPT_CONFUSION EQ 'YES'>
				<CFINPUT type="CHECKBOX" name="RPT_CONFUSION" value="#GetLibqual_Comments.RPT_CONFUSION#" checked tabindex="4">
			<CFELSE>
				<CFINPUT type="CHECKBOX" name="RPT_CONFUSION" value="YES" tabindex="4">
			</CFIF>
				&nbsp;&nbsp;Confusion: &nbsp;&nbsp; Inaccurate comment, such as a complaint about 
				the lack of something that is in fact available. 
			</TD>
		</TR>
		<TR>
			<TD align="left">
			<CFIF GetLibqual_Comments.RPT_NEGATIVE EQ 'YES'>
				<CFINPUT type="CHECKBOX" name="RPT_NEGATIVE" value="#GetLibqual_Comments.RPT_NEGATIVE#" checked tabindex="5">
			<CFELSE>
				<CFINPUT type="CHECKBOX" name="RPT_NEGATIVE" value="YES" tabindex="5">
			</CFIF>
				&nbsp;&nbsp;Negative: &nbsp;&nbsp;Report a complaint or negative experience.
			</TD>
			<TD align="left">
			<CFIF GetLibqual_Comments.RPT_POSITIVE EQ 'YES'>
				<CFINPUT type="CHECKBOX" name="RPT_POSITIVE" value="#GetLibqual_Comments.RPT_POSITIVE#" checked tabindex="6">
			<CFELSE>
				<CFINPUT type="CHECKBOX" name="RPT_POSITIVE" value="YES" tabindex="6">
			</CFIF>
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
				<CFSELECT name="CHECKEDBYID" size="1" query="GetCheckedInitials" value="CHECKEDINITID" display="INITIALS" selected="#GetLibqual_Comments.CHECKEDBYID#" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			
			<TD align="left" valign="TOP"><INPUT type="submit" name="ProcessComments" value="Modify" tabindex="8" /></TD>
			<TD align="left">
				<INPUT type="BUTTON" name="ProcessComments" value="Building" 
					onClick="window.open('/#application.type#apps/libqual/lqcommbuilding.cfm?PROCESS=BUILDING&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Building Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
					tabindex="9" /><BR />
				<INPUT type="BUTTON" name="ProcessComments" value="Collections" 
					onClick="window.open('/#application.type#apps/libqual/lqcommcollections.cfm?PROCESS=COLLECTIONS&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Collections Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
					tabindex="10" /><BR />
				<INPUT type="BUTTON" name="ProcessComments" value="Policies" 
					onClick="window.open('/#application.type#apps/libqual/lqcommpolicies.cfm?PROCESS=POLICIES&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Policies Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
					tabindex="11" /><BR />
				<INPUT type="BUTTON" name="ProcessComments" value="Service" 
					onClick="window.open('/#application.type#apps/libqual/lqcommservice.cfm?PROCESS=SERVICE&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Service Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
					tabindex="12" /><BR />
				<INPUT type="BUTTON" name="ProcessComments" value="Technology" 
					onClick="window.open('/#application.type#apps/libqual/lqcommtech.cfm?PROCESS=TECHNOLOGY&COMMENTID=#GetLibqual_Comments.COMMENTID#','Select Technology Criteria','alwaysRaised=yes,dependent=no,width=1000,height=800,toolbar=no,scrollbars=yes,userbar=no,location=no,status=no,menubar=yes,,screenX=25,screenY=25');" 
					tabindex="13" /><BR />
				</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/libqual/lqcommcriteria.cfm" method="POST">
			<TD align="left"><INPUT type="submit" name="ProcessComments" value="Cancel" tabindex="14" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>