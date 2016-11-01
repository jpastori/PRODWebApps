<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: lqrptslookup.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/24/2007 --->
<!--- Date in Production: 01/24/2007 --->
<!--- Module: LibQual Comments Reports Lookup --->
<!-- Last modified by John R. Pastori on 01/24/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libqual/lqrptslookup.cfm">
<CFSET CONTENT_UPDATED = "January 24, 2007">
<CFINCLUDE TEMPLATE = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>LibQual Comments Reports Lookup</TITLE>
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

<cfoutput>
<CFIF NOT IsDefined('URL.LOOKUPLIBQUAL')>
	<CFSET CURSORFIELD = "document.LOOKUP.POSITIONID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************
* The following code is the Look Up Process for LibQual Comments Reports Record Selection. *
********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPLIBQUAL')>

	<cfquery name="ListPositions" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="6">
		SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME, LIBQUALPOSITIONID || ' - ' || POSITIONNAME AS POSITIONCODENAME
		FROM		LQPOSITIONS
		ORDER BY	POSITIONNAME
	</cfquery>

	<cfquery name="ListDisciplines" DATASOURCE="#application.type#WEBREPORTS" BLOCKFACTOR="92">
		SELECT	DISCIPLINEID, DISCIPLINENAME
		FROM		DISCIPLINES
		ORDER BY	DISCIPLINENAME
	</cfquery>

	<cfquery name="ListAgeRanges" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="7">
		SELECT	AGERANGEID, LIBQUALAGEID, AGERANGENAME, LIBQUALAGEID || ' - ' || AGERANGENAME AS AGERANGECODENAME
		FROM		AGERANGES
		ORDER BY	LIBQUALAGEID
	</cfquery>

	<cfquery name="ListGender" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="3">
		SELECT	GENDERID, LIBQUALGENDERID, GENDERNAME, LIBQUALGENDERID || ' - ' || GENDERNAME AS GENDERCODENAME
		FROM		GENDER
		ORDER BY	GENDERNAME
	</cfquery>

	<cfquery name="ListLQGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="7">
		SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
		FROM		LQGROUPS
		ORDER BY	GROUPNAME
	</cfquery>

	<cfquery name="ListLQSubGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="58">
		SELECT	LQSG.LQSUBGROUPID, LQSG.LQGROUPNAMEID, LQG.GROUPNAME, LQSG.SUBGROUPFIELDNAME, LQSG.SUBGROUPNAME,
				LQG.GROUPNAME || ' - ' || LQSG.SUBGROUPNAME AS LOOKUPKEY
		FROM		LQSUBGROUPS LQSG, LQGROUPS LQG
		WHERE	LQSG.LQGROUPNAMEID = LQG.LQGROUPID
		ORDER BY	LOOKUPKEY
	</cfquery>


	<TABLE width="100%" align="center" BORDER="3">
		<TR align="center">
		<CFIF IsDefined('URL.TYPE') AND #URL.TYPE# EQ "CRITERIA">
			<TH align="center"><H1>LibQual Comments Specific Criteria Reports Lookup</H1></TH>
		<CFELSE>
			<TH align="center"><H1>LibQual Comments Count Reports Lookup</H1></TH>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" BORDER="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR />
				Checking an adjacent checkbox will Negate the selection or data entered.
			</H2></TH>
		</TR>
		<TR>
<cfform action="/#application.type#apps/libqual/index.cfm?logout=No" METHOD="POST">
			<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</cfform>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" ALIGN="LEFT">
<cfform name="LOOKUP" onSubmit="return validateLookupFields();" action="/#application.type#apps/libqual/lqrptslookup.cfm?TYPE=#URL.TYPE#&LOOKUPLIBQUAL=FOUND" METHOD="POST">
		<TR>
			<TH align="LEFT" VALIGN="BOTTOM">Positions</TH>
			<TH align="LEFT" VALIGN="BOTTOM">Discipline</TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<cfinput type="CheckBox" name="NEGATEPOSITIONID" value="" align="LEFT" required="No" tabindex="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="POSITIONID" size="1" query="ListPositions" value="POSITIONID" display="POSITIONNAME" required="No" tabindex="3"></CFSELECT><BR />
			</TD>
			<TD align="LEFT">
				<cfinput type="CheckBox" name="NEGATEDISCIPLINEID" value="" align="LEFT" required="No" tabindex="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="DISCIPLINEID" size="1" query="ListDisciplines" value="DISCIPLINEID" display="DISCIPLINENAME" required="No" tabindex="5"></CFSELECT><BR />
			</TD>
		</TR>
		<TR>
			<TH align="LEFT" VALIGN="BOTTOM">Age Range</TH>
			<TH align="LEFT" VALIGN="BOTTOM">Gender</TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<cfinput type="CheckBox" name="NEGATEAGERANGEID" value="" align="LEFT" required="No" tabindex="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="AGERANGEID" size="1" query="ListAgeRanges" value="AGERANGEID" display="AGERANGENAME" required="No" tabindex="7"></CFSELECT><BR />
			</TD>
			<TD align="LEFT">
				<cfinput type="CheckBox" name="NEGATEGENDERID" value="" align="LEFT" required="No" tabindex="8">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFSELECT name="GENDERID" size="1" query="ListGender" value="GENDERID" display="GENDERNAME" required="No" tabindex="9"></CFSELECT><BR />
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="CENTER" COLSPAN="2"><COM>Select from one of the following two dropdown boxes for Report Criteria titles when selecting a specific Group or SubGroup.</COM></TD>
		</TR>
		<TR>
			<TH ALIGN="LEFT" VALIGN ="bottom">Group Name</TH>
			<TH ALIGN="left" VALIGN ="bottom">SubGroup Name</TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<cfselect name="LQGROUPID" size="1" query="ListLQGroups" value="LQGROUPID" display="GROUPNAME" required="No" tabindex="10"></cfselect><BR />
			</TD>
			<TD align="LEFT">
				<cfselect name="LQSUBGROUPID" size="1" query="ListLQSubGroups" value="LQSUBGROUPID" display="LOOKUPKEY" required="No" tabindex="11"></cfselect><BR />
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD ALIGN="CENTER" COLSPAN="2"><HR /></TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="CENTER" COLSPAN="2">
			<CFIF #URL.TYPE# EQ "COUNT">
				<COM>The following choices are to be used ONLY for Reports 3 thru 6 below.</COM> <BR /> 
			</CFIF>
				Choose only the group or subgroup that matches the Report Criteria title you chose in one of the previous two dropdown boxes above.
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Report Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="REPORTGROUP" size="1" tabindex="12">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM">Budget</TH>
			<TH ALIGN="left">
				Confusion: &nbsp;&nbsp; Inaccurate comment, such as a complaint about <BR />
				the lack of something that is in fact available
			</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BUDGET" size="1" tabindex="13">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="RPT_CONFUSION" size="1" tabindex="14">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Negative: &nbsp;&nbsp;Report a complaint or negative experience</TH>
			<TH ALIGN="left" VALIGN="BOTTOM">Positive: &nbsp;&nbsp;Report a compliment or positive experience</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="RPT_NEGATIVE" size="1" tabindex="15">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="RPT_POSITIVE" size="1" tabindex="16">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Building Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BUILDINGGROUP" size="1" tabindex="17">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="TOP">Accessibility: &nbsp;&nbsp;Height of shelves, width of aisles, parking</TH>
			<TH ALIGN="left" VALIGN="BOTTOM">Cleaning/Maintenance</TH>
		</TR>
		<TR>
			
			<TD align="left" nowrap>
				<CFSELECT name="BLD_ACCESSIBILITY" size="1" tabindex="18">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_CLEANMAINT" size="1" tabindex="19">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left">Electrical Outlets</TH>
			<TH ALIGN="left">Furniture</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_ELECTOUTLETS" size="1" tabindex="20">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_FURNITURE" size="1" tabindex="21">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Group Study</TH>
			<TH ALIGN="left">Heating/Cooling</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_GROUPSTUDY" size="1" tabindex="22">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_HEATCOOL" size="1" tabindex="23">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Hours</TH>
			<TH ALIGN="left">Lighting</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_HOURS" size="1" tabindex="24">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_LIGHTING" size="1" tabindex="25">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Quiet Space</TH>
			<TH ALIGN="left">Restrooms</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_QUIETSPACE" size="1" tabindex="26">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_RESTROOMS" size="1" tabindex="27">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Safety</TH>
			<TH ALIGN="left">Signage</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_SAFETY" size="1" tabindex="28">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_SIGNAGE" size="1" tabindex="29">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM">Study Space</TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="BLD_STUDYSPACE" size="1" tabindex="30">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Collections Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="COLLECTIONSGROUP" size="1" tabindex="31">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Collections Maintenance</TH>
			<TH ALIGN="left">Online</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="COL_MAINT" size="1" tabindex="32">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="COL_ONLINE" size="1" tabindex="33">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Periodicals</TH>
			<TH ALIGN="left">Print</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="COL_PERIODICALS" size="1" tabindex="34">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="COL_PRINT" size="1" tabindex="35">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Policies Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="POLICIESGROUP" size="1" tabindex="36">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Cell Phones</TH>
			<TH ALIGN="left">Eating/Drinking</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="POL_CELLPHONES" size="1" tabindex="37">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="POL_EATDRINK" size="1" tabindex="38">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="TOP">Fines</TH>
			<TH ALIGN="left">General</TH>
		</TR>
		<TR>
			
			<TD align="left" nowrap>
				<CFSELECT name="POL_FINES" size="1" tabindex="39">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="POL_GENERAL" size="1" tabindex="40">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left">Noise</TH>
			<TH ALIGN="left">Sleeping</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="POL_NOISE" size="1" tabindex="41">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="POL_SLEEPING" size="1" tabindex="42">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Service Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SERVICEGROUP" size="1" tabindex="43">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Circuit</TH>
			<TH ALIGN="left">Category</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_CIRCUIT" size="1" tabindex="44">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_CIRCDESK" size="1" tabindex="45">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Circulation Desk</TH>
			<TH ALIGN="left">ECR</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_COPYSRVCS" size="1" tabindex="46">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_ECR" size="1" tabindex="47">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Electronic Reference</TH>
			<TH ALIGN="left">Government Publications</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_ELECTRONICREF" size="1" tabindex="48">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_GOVTPUBS" size="1" tabindex="49">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="TOP">Hours</TH>
			<TH ALIGN="left">Instruction/Education/Outreach</TH>
		</TR>
		<TR>
			
			<TD align="left" nowrap>
				<CFSELECT name="SRV_HOURS" size="1" tabindex="50">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_INSTREDOR" size="1" tabindex="51">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left">Interlibrary Loan</TH>
			<TH ALIGN="left">Librarian:&nbsp;&nbsp;Interaction with professional staff</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_ILL" size="1" tabindex="52">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_LIBRINTERACT" size="1" tabindex="53">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Link +</TH>
			<TH ALIGN="left">Media Center</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_LINKPLUS" size="1" tabindex="54">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_MEDIACNTR" size="1" tabindex="55">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Periodicals Desk (CPMC)</TH>
			<TH ALIGN="left">Reference Desk</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_CPMC" size="1" tabindex="56">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_REFDESK" size="1" tabindex="57">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Reserve Book Room</TH>
			<TH ALIGN="left">Student Computing Center</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_RBR" size="1" tabindex="58">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_SCC" size="1" tabindex="59">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Special Collections</TH>
			<TH ALIGN="left">Staff:&nbsp;&nbsp;Interaction with support/technical staff</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_SPCOLL" size="1" tabindex="60">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_STAFFINTERACT" size="1" tabindex="61">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Student:&nbsp;&nbsp;Interaction with student worker/TH>
			</TH><TH ALIGN="left">Telephone</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_STUDNTINTERACT" size="1" tabindex="62">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_TELEPHONE" size="1" tabindex="63">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Website & OPAC Service</TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="SRV_WEBOPACSRVC" size="1" tabindex="64">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH ALIGN="left" VALIGN="BOTTOM"><COM><I>Technology Group</I></COM></TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECHNOLOGYGROUP" size="1" tabindex="65">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left">Computer/Technology General</TH>
			<TH ALIGN="left">Other Hardware</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_COMPTECHGENRL" size="1" tabindex="66">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_OTHERHW" size="1" tabindex="67">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Other Library Computers</TH>
			<TH ALIGN="left">Periodicals Computer Lab</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_OTHERLIBCOMP" size="1" tabindex="68">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_PERCOMPLAB" size="1" tabindex="69">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Printing</TH>
			<TH ALIGN="left">Reference Computer Lab</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_PRINTING" size="1" tabindex="70">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_REFCOMPLAB" size="1" tabindex="71">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Remote Access</TH>
			<TH ALIGN="left">Reserve Book Room Lab</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_REMOTEACCESS" size="1" tabindex="72">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_RBRLAB" size="1" tabindex="73">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH ALIGN="left">Student Computing Center Lab</TH>
			<TH ALIGN="left">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
				<CFSELECT name="TECH_SCCLAB" size="1" tabindex="74">
					<OPTION selected value="No">No</OPTION>
					<OPTION value="YES">YES</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD COLSPAN="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="2"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	<CFIF #URL.TYPE# EQ "CRITERIA">
		<TR>
			<TH align="LEFT" valign="top">
				SPECIFIC CRITERIA REPORTS
			</TH>
			<TH align="LEFT" valign="top">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="1" checked align="LEFT" required="No" tabindex="75"> REPORT 1: &nbsp;&nbsp;Specific Group Comments Criteria Report
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="2" align="LEFT" required="No" tabindex="76"> REPORT 2: &nbsp;&nbsp;Specific Discipline Comments Criteria Report
			</TD>
		</TR>
	<CFELSE>
		<TR>
			<TH align="LEFT" valign="top" COLSPAN="2">
				COUNT REPORTS
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="1" checked align="LEFT" required="No" tabindex="75"> REPORT 1: &nbsp;&nbsp;Comments Criteria Count By Group Report for all Records
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="2" align="LEFT" required="No" tabindex="76"> REPORT 2: &nbsp;&nbsp;Comments Criteria Count By SubGroup Report for all Records
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="3" align="LEFT" required="No" tabindex="77"> REPORT 3: &nbsp;&nbsp;Comments Criteria Count By Position Report
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="4" align="LEFT" required="No" tabindex="78"> REPORT 4: &nbsp;&nbsp;Comments Criteria Count By Discipline Report
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="5" align="LEFT" required="No" tabindex="79"> REPORT 5: &nbsp;&nbsp;Comments Criteria Count By Age Range Report
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" COLSPAN="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" value="6" align="LEFT" required="No" tabindex="80"> REPORT 6: &nbsp;&nbsp;Comments Criteria Count By Gender Report
			</TD>
		</TR>
	</CFIF>
		<TR>
			<TD COLSPAN="2"><HR ALIGN="left" WIDTH="100%" SIZE="5" NOSHADE /></TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="81" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="82" />
			</TD>
		</TR>
		
</cfform>
		<TR>
<cfform action="/#application.type#apps/libqual/index.cfm?logout=No" METHOD="POST">
			<TD align="LEFT" VALIGN="TOP" COLSPAN="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="83" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</cfform>
		</TR>
		<TR>
			<TD align="LEFT" COLSPAN="2"><CFINCLUDE TEMPLATE="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*********************************************************************************
* The following code is the LibQual Comments Reports Lookup Generation Process. *
*********************************************************************************
 --->

	<CFSET AGERANGECRITERIA = "">
	<CFSET DISCIPLINECRITERIA = "">
	<CFSET GENDERCRITERIA = "">
	<CFSET LQGROUPCRITERIA = "">
	<CFSET LQSUBGROUPCRITERIA = "">
	<CFSET POSITIONCRITERIA = "">
	<CFSET RECORDSSELECTED = 'NO'>
	<CFSET REPORTTITLE = ''>

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFIF #URL.TYPE# EQ "CRITERIA">
		<CFSET SORTORDER[1] = 'P.POSITIONNAME, LQC.LIBQUALRECID'>
		<CFSET SORTORDER[2] = 'D.DISCIPLINENAME, P.POSITIONNAME, LQC.LIBQUALRECID'>
	<CFELSE>
		<CFSET SORTORDER[1] = 'LQC.LIBQUALRECID'>
		<CFSET SORTORDER[2] = 'P.POSITIONNAME'>
		<CFSET SORTORDER[3] = 'P.POSITIONNAME, D.DISCIPLINENAME'>
		<CFSET SORTORDER[4] = 'D.DISCIPLINENAME, P.POSITIONNAME'>
		<CFSET SORTORDER[5] = 'AR.LIBQUALAGEID, G.GENDERNAME'>
		<CFSET SORTORDER[6] = 'G.GENDERNAME, AR.LIBQUALAGEID'>
	</CFIF>
	<cfset REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	REPORT ORDER = #REPORTORDER#<BR /><BR />

	<CFIF #FORM.AGERANGEID# GT 0>

		<cfquery name="LookupAgeRanges" DATASOURCE="#application.type#LIBSHAREDDATA">
			SELECT	AGERANGEID, LIBQUALAGEID, AGERANGENAME, LIBQUALAGEID || ' - ' || AGERANGENAME AS AGERANGECODENAME
			FROM		AGERANGES
			WHERE	AGERANGEID = <CFQUERYPARAM VALUE="#FORM.AGERANGEID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	LIBQUALAGEID
		</cfquery>

		<CFSET AGERANGECRITERIA = #LookupAgeRanges.AGERANGENAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>

	<CFIF #FORM.DISCIPLINEID# GT 0>

		<cfquery name="LookupDisciplines" DATASOURCE="#application.type#WEBREPORTS">
			SELECT	DISCIPLINEID, DISCIPLINENAME
			FROM		DISCIPLINES
			WHERE	DISCIPLINEID = <CFQUERYPARAM VALUE="#FORM.DISCIPLINEID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	DISCIPLINENAME
		</cfquery>

		<CFSET DISCIPLINECRITERIA = #LookupDisciplines.DISCIPLINENAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>


	<CFIF #FORM.GENDERID# GT 0>

		<cfquery name="LookupGender" DATASOURCE="#application.type#LIBSHAREDDATA" BLOCKFACTOR="100">
			SELECT	GENDERID, LIBQUALGENDERID, GENDERNAME, LIBQUALGENDERID || ' - ' || GENDERNAME AS GENDERCODENAME
			FROM		GENDER
			WHERE	GENDERID = <CFQUERYPARAM VALUE="#FORM.GENDERID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	GENDERNAME
		</cfquery>

		<CFSET GENDERCRITERIA = #LookupGender.GENDERNAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>

	<CFIF #FORM.POSITIONID# GT 0>

		<cfquery name="LookupPositions" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
			SELECT	POSITIONID, LIBQUALPOSITIONID, POSITIONNAME, LIBQUALPOSITIONID || ' - ' || POSITIONNAME AS POSITIONCODENAME
			FROM		LQPOSITIONS
			WHERE	POSITIONID = <CFQUERYPARAM VALUE="#FORM.POSITIONID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	POSITIONNAME
		</cfquery>

		<CFSET POSITIONCRITERIA = #LookupPositions.POSITIONNAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>

	<CFIF IsDefined('FORM.LQGROUPID') AND #FORM.LQGROUPID# GT 0>

		<cfquery name="LookupLQGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
			SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
			FROM		LQGROUPS
			WHERE	LQGROUPID = <CFQUERYPARAM VALUE="#FORM.LQGROUPID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	GROUPNAME
		</cfquery>

		<CFSET LQGROUPCRITERIA = #LookupLQGroups.GROUPNAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>

	<CFIF IsDefined('FORM.LQSUBGROUPID') AND #FORM.LQSUBGROUPID# GT 0>

		<cfquery name="LookupLQSubGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
			SELECT	LQSG.LQSUBGROUPID, LQSG.LQGROUPNAMEID, LQG.GROUPNAME, LQSG.SUBGROUPFIELDNAME, LQSG.SUBGROUPNAME,
					LQG.GROUPNAME || ' - ' || LQSG.SUBGROUPNAME AS LOOKUPKEY
			FROM		LQSUBGROUPS LQSG, LQGROUPS LQG
			WHERE	LQSG.LQSUBGROUPID = <CFQUERYPARAM VALUE="#FORM.LQSUBGROUPID#" CFSQLTYPE="CF_SQL_NUMERIC"> AND
					LQSG.LQGROUPNAMEID = LQG.LQGROUPID
			ORDER BY	LOOKUPKEY
		</cfquery>

		<CFSET LQSUBGROUPCRITERIA = #LookupLQSubGroups.SUBGROUPNAME#>
		<CFSET RECORDSSELECTED = 'YES'>
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFIF (#URL.TYPE# EQ "CRITERIA" AND #FORM.REPORTCHOICE# EQ 1) OR (#URL.TYPE# EQ "COUNT" AND #FORM.REPORTCHOICE# EQ 2)>

		<cfquery name="ListLQSubGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
			SELECT	LQSG.LQSUBGROUPID, LQSG.LQGROUPNAMEID, LQG.GROUPNAME, LQSG.SUBGROUPFIELDNAME, LQSG.SUBGROUPNAME
			FROM		LQSUBGROUPS LQSG, LQGROUPS LQG
			WHERE	LQSG.LQGROUPNAMEID = LQG.LQGROUPID AND
				<CFIF FORM.BUILDINGGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 1 AND
				</CFIF><CFIF FORM.COLLECTIONSGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 2 AND
				</CFIF>
				<CFIF FORM.POLICIESGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 3 AND
				</CFIF>
				<CFIF FORM.REPORTGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 4 AND
				</CFIF>
				<CFIF FORM.SERVICEGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 5 AND
				</CFIF>
				<CFIF FORM.TECHNOLOGYGROUP EQ 'YES'>
					LQSG.LQGROUPNAMEID = 6 AND
				</CFIF>
					LQSG.LQSUBGROUPID > 0
		<CFIF #URL.TYPE# EQ "COUNT" AND #FORM.REPORTCHOICE# EQ 2>
			ORDER BY	LQSG.SUBGROUPNAME
		<CFELSE>
			ORDER BY	LQG.GROUPNAME, LQSG.SUBGROUPNAME
		</CFIF>
		</cfquery>
	</CFIF>

	<CFIF (#URL.TYPE# EQ "CRITERIA" AND #FORM.REPORTCHOICE# EQ 2) OR (#URL.TYPE# EQ "COUNT" AND #FORM.REPORTCHOICE# GT 2)>

		<cfquery name="ListLIBQUAL_Comments" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
			SELECT	LQC.COMMENTID, LQC.LIBQUALRECID, LQC.DATEENTERED, LQC.POSITIONID, P.POSITIONNAME, LQC.LIBQUALDISCIPLINEID,
					LQC.DISCIPLINEID, D.DISCIPLINENAME, LQC.AGERANGEID, AR.LIBQUALAGEID, AR.AGERANGENAME, LQC.GENDERID, G.GENDERNAME, LQC.COMMENTS,
					LQC.BUILDINGGROUP, LQC.BLD_ACCESSIBILITY, LQC.BLD_CLEANMAINT, LQC.BLD_ELECTOUTLETS,LQC.BLD_FURNITURE, LQC.BLD_GROUPSTUDY,
					LQC.BLD_HEATCOOL, LQC.BLD_HOURS, LQC.BLD_LIGHTING, LQC.BLD_QUIETSPACE, LQC.BLD_RESTROOMS, LQC.BLD_SAFETY, LQC.BLD_SIGNAGE,
					LQC.BLD_STUDYSPACE, LQC.COLLECTIONSGROUP, LQC.COL_MAINT, LQC.COL_ONLINE, LQC.COL_PERIODICALS, LQC.COL_PRINT, 
					LQC.POLICIESGROUP, LQC.POL_CELLPHONES, LQC.POL_EATDRINK, LQC.POL_FINES, LQC.POL_GENERAL, LQC.POL_NOISE, LQC.POL_SLEEPING,
					LQC.REPORTGROUP, LQC.BUDGET, LQC.RPT_CONFUSION, LQC.RPT_NEGATIVE, LQC.RPT_POSITIVE, LQC.SERVICEGROUP, LQC.SRV_CIRCUIT,
					LQC.SRV_CIRCDESK, LQC.SRV_COPYSRVCS, LQC.SRV_ECR, LQC.SRV_ELECTRONICREF, LQC.SRV_GOVTPUBS, LQC.SRV_HOURS, LQC.SRV_INSTREDOR,
					LQC.SRV_ILL, LQC.SRV_LIBRINTERACT,LQC.SRV_LINKPLUS, LQC.SRV_MEDIACNTR, LQC.SRV_CPMC, LQC.SRV_REFDESK, LQC.SRV_RBR,
					LQC.SRV_SCC, LQC.SRV_SPCOLL, LQC.SRV_STAFFINTERACT, LQC.SRV_STUDNTINTERACT, LQC.SRV_TELEPHONE, LQC.SRV_WEBOPACSRVC,
					LQC.TECHNOLOGYGROUP, LQC.TECH_COMPTECHGENRL, LQC.TECH_OTHERHW, LQC.TECH_OTHERLIBCOMP, LQC.TECH_PERCOMPLAB,
					LQC.TECH_PRINTING, LQC.TECH_REFCOMPLAB, LQC.TECH_REMOTEACCESS, LQC.TECH_RBRLAB, LQC.TECH_SCCLAB, LQC.CHECKEDBYID,
					CI.INITIALS, LQC.RECCHECKED
			FROM		LIBQUAL_COMMENTS LQC, LQPOSITIONS P, WEBRPTSMGR.DISCIPLINES D, LIBSHAREDDATAMGR.AGERANGES AR, LIBSHAREDDATAMGR.GENDER G, LQCHECKEDINITIALS CI
			WHERE	(LQC.COMMENTID > 0 AND
					LQC.POSITIONID = P.POSITIONID AND
					LQC.DISCIPLINEID = D.DISCIPLINEID AND
					LQC.AGERANGEID = AR.AGERANGEID AND
					LQC.GENDERID = G.GENDERID AND
					LQC.CHECKEDBYID = CI.CHECKEDINITID) AND (

			<CFIF #FORM.POSITIONID# GT 0>
				<CFIF IsDefined("FORM.NEGATEPOSITIONID")>
					NOT LQC.POSITIONID = #val(FORM.POSITIONID)# #LOGICANDOR#
				<CFELSE>
					LQC.POSITIONID = #val(FORM.POSITIONID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.DISCIPLINEID# GT 0>
				<CFIF IsDefined("FORM.NEGATEDISCIPLINEID")>
					NOT LQC.DISCIPLINEID = #val(FORM.DISCIPLINEID)# #LOGICANDOR#
				<CFELSE>
					LQC.DISCIPLINEID = #val(FORM.DISCIPLINEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.AGERANGEID# GT 0>
				<CFIF IsDefined("FORM.NEGATEAGERANGEID")>
					NOT LQC.AGERANGEID = #val(FORM.AGERANGEID)# #LOGICANDOR#
				<CFELSE>
					LQC.AGERANGEID = #val(FORM.AGERANGEID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.GENDERID# GT 0>
				<CFIF IsDefined("FORM.NEGATEGENDERID")>
					NOT LQC.GENDERID = #val(FORM.GENDERID)# #LOGICANDOR#
				<CFELSE>
					LQC.GENDERID = #val(FORM.GENDERID)# #LOGICANDOR#
				</CFIF>
			</CFIF>

				<CFIF FORM.BUILDINGGROUP EQ 'YES'>
					LQC.BUILDINGGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_ACCESSIBILITY EQ 'YES'>
					LQC.BLD_ACCESSIBILITY = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_CLEANMAINT EQ 'YES'>
					LQC.BLD_CLEANMAINT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_ELECTOUTLETS EQ 'YES'>
					LQC.BLD_ELECTOUTLETS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_FURNITURE EQ 'YES'>
					LQC.BLD_FURNITURE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_GROUPSTUDY EQ 'YES'>
					LQC.BLD_GROUPSTUDY= 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_HEATCOOL EQ 'YES'>
					LQC.BLD_HEATCOOL = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_HOURS EQ 'YES'>
					LQC.BLD_HOURS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_LIGHTING EQ 'YES'>
					LQC.BLD_LIGHTING = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_QUIETSPACE EQ 'YES'>
					LQC.BLD_QUIETSPACE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_RESTROOMS EQ 'YES'>
					LQC.BLD_RESTROOMS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_SAFETY EQ 'YES'>
					LQC.BLD_SAFETY = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_SIGNAGE EQ 'YES'>
					LQC.BLD_SIGNAGE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BLD_STUDYSPACE EQ 'YES'>
					LQC.BLD_STUDYSPACE = 'YES' #LOGICANDOR#
				</CFIF>

				<CFIF FORM.COLLECTIONSGROUP EQ 'YES'>
					LQC.COLLECTIONSGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.COL_MAINT EQ 'YES'>
					LQC.COL_MAINT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.COL_ONLINE EQ 'YES'>
					LQC.COL_ONLINE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.COL_PERIODICALS EQ 'YES'>
					LQC.COL_PERIODICALS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.COL_PRINT EQ 'YES'>
					LQC.COL_PRINT = 'YES' #LOGICANDOR#
				</CFIF>

				<CFIF FORM.POLICIESGROUP EQ 'YES'>
					LQC.POLICIESGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_CELLPHONES EQ 'YES'>
					LQC.POL_CELLPHONES = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_EATDRINK EQ 'YES'>
					LQC.POL_EATDRINK = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_FINES EQ 'YES'>
					LQC.POL_FINES = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_GENERAL EQ 'YES'>
					LQC.POL_GENERAL = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_NOISE EQ 'YES'>
					LQC.POL_NOISE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.POL_SLEEPING EQ 'YES'>
					LQC.POL_SLEEPING = 'YES' #LOGICANDOR#
				</CFIF>

				<CFIF FORM.REPORTGROUP EQ 'YES'>
					LQC.REPORTGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.BUDGET EQ 'YES'>
					LQC.BUDGET = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.RPT_CONFUSION EQ 'YES'>
					LQC.RPT_CONFUSION = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.RPT_NEGATIVE EQ 'YES'>
					LQC.RPT_NEGATIVE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.RPT_POSITIVE EQ 'YES'>
					LQC.RPT_POSITIVE = 'YES' #LOGICANDOR#
				</CFIF>

				<CFIF FORM.SERVICEGROUP EQ 'YES'>
					LQC.SERVICEGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_CIRCUIT EQ 'YES'>
					LQC.SRV_CIRCUIT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_CIRCDESK EQ 'YES'>
					LQC.SRV_CIRCDESK = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_COPYSRVCS EQ 'YES'>
					LQC.SRV_COPYSRVCS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_ECR EQ 'YES'>
					LQC.SRV_ECR = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_ELECTRONICREF EQ 'YES'>
					LQC.SRV_ELECTRONICREF = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_GOVTPUBS EQ 'YES'>
					LQC.SRV_GOVTPUBS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_HOURS EQ 'YES'>
					LQC.SRV_HOURS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_INSTREDOR EQ 'YES'>
					LQC.SRV_INSTREDOR = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_ILL EQ 'YES'>
					LQC.SRV_ILL = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_LIBRINTERACT EQ 'YES'>
					LQC.SRV_LIBRINTERACT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_LINKPLUS EQ 'YES'>
					LQC.SRV_LINKPLUS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_MEDIACNTR EQ 'YES'>
					LQC.SRV_MEDIACNTR = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_CPMC EQ 'YES'>
					LQC.SRV_CPMC = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_REFDESK EQ 'YES'>
					LQC.SRV_REFDESK = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_RBR EQ 'YES'>
					LQC.SRV_RBR = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_SCC EQ 'YES'>
					LQC.SRV_SCC = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_SPCOLL EQ 'YES'>
					LQC.SRV_SPCOLL = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_STAFFINTERACT EQ 'YES'>
					LQC.SRV_STAFFINTERACT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_STUDNTINTERACT EQ 'YES'>
					LQC.SRV_STUDNTINTERACT = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_TELEPHONE EQ 'YES'>
					LQC.SRV_TELEPHONE = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.SRV_WEBOPACSRVC EQ 'YES'>
					LQC.SRV_WEBOPACSRVC = 'YES' #LOGICANDOR#
				</CFIF>

				<CFIF FORM.TECHNOLOGYGROUP EQ 'YES'>
					LQC.TECHNOLOGYGROUP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_COMPTECHGENRL EQ 'YES'>
					LQC.TECH_COMPTECHGENRL = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_OTHERHW EQ 'YES'>
					LQC.TECH_OTHERHW = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_OTHERLIBCOMP EQ 'YES'>
					LQC.TECH_OTHERLIBCOMP = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_PERCOMPLAB EQ 'YES'>
					LQC.TECH_PERCOMPLAB = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_PRINTING EQ 'YES'>
					LQC.TECH_PRINTING = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_REFCOMPLAB EQ 'YES'>
					LQC.TECH_REFCOMPLAB = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_REMOTEACCESS EQ 'YES'>
					LQC.TECH_REMOTEACCESS = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_RBRLAB EQ 'YES'>
					LQC.TECH_RBRLAB = 'YES' #LOGICANDOR#
				</CFIF>
				<CFIF FORM.TECH_SCCLAB EQ 'YES'>
					LQC.TECH_SCCLAB = 'YES' #LOGICANDOR#
				</CFIF>

					LQC.COMMENTID #FINALTEST# 0)
			ORDER BY	#REPORTORDER#
		</cfquery>

		<CFIF #ListLIBQUAL_Comments.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("LibQual Comment Records meeting the selected criteria were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/libqual/lqrptslookup.cfm?TYPE=#URL.TYPE#" />
			<CFEXIT>
		</CFIF>

	</CFIF>

	<CFIF #URL.TYPE# EQ "CRITERIA">
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<CFSET REPORTTITLE = "REPORT 1: &nbsp;&nbsp;Specific Group Comments Criteria Report">
			<CFSET FIELDNAME1 = "ListLQSubGroups.GROUPNAME">
			<CFSET FIELDNAME2 = "ListLQSubGroups.SUBGROUPNAME">
			<CFSET REPORTHEADER1 = "">
			<CFSET REPORTHEADER2 = "">
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFSET REPORTTITLE = "REPORT 2: &nbsp;&nbsp;Specific Discipline Comments Criteria Report">
			<CFSET FIELDNAME = "ListLIBQUAL_Comments.DISCIPLINENAME">
		</CFIF>

		<CFINCLUDE template="lqcriteriarpts.cfm">

	<CFELSE>

		<CFIF #FORM.REPORTCHOICE# EQ 1>

			<cfquery name="ListLQGroups" DATASOURCE="#application.type#LIBQUAL" BLOCKFACTOR="100">
				SELECT	LQGROUPID, GROUPFIELDNAME, GROUPNAME
				FROM		LQGROUPS
				WHERE	LQGROUPID > 0
				ORDER BY	GROUPNAME
			</cfquery>

			<CFSET REPORTTITLE = "REPORT 1: &nbsp;&nbsp;Comments Criteria Count By Group Report">
			<CFSET FIELDNAME = "ListLQGroups.GROUPNAME">
			<CFSET GROUPTITLE = "Group">
			<CFSET client.QUERYNAME = "ListLQGroups">
			<CFSET client.QUERYFIELDNAME = "ListLQGroups.GROUPFIELDNAME">
			<CFSET REPORTHEADER = '#ListLQGroups.GROUPNAME#'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 2>
			<CFSET REPORTTITLE = "REPORT 2: &nbsp;&nbsp;Comments Criteria Count By SubGroup Report">
			<CFSET FIELDNAME = "ListLQSubGroups.SUBGROUPNAME">
			<CFSET GROUPTITLE = "SubGroup">
			<CFSET client.QUERYNAME = "ListLQSubGroups">
			<CFSET client.QUERYFIELDNAME = "ListLQSubGroups.SUBGROUPFIELDNAME">
			<CFSET REPORTHEADER = '#ListLQSubGroups.SUBGROUPNAME#'>
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 3>
			<CFSET REPORTTITLE = "REPORT 3: &nbsp;&nbsp;Comments Criteria Count By Position Report">
			<CFSET FIELDNAME = "ListLIBQUAL_Comments.POSITIONNAME">
			<CFSET GROUPTITLE = "Position">
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 4>
			<CFSET REPORTTITLE = "REPORT 1: &nbsp;&nbsp;Comments Criteria Count By Discipline Report">
			<CFSET FIELDNAME = "ListLIBQUAL_Comments.DISCIPLINENAME">
			<CFSET GROUPTITLE = "Discipline">
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 5>
			<CFSET REPORTTITLE = "REPORT 2: &nbsp;&nbsp;Comments Criteria Count By Age Range Report">
			<CFSET FIELDNAME = "ListLIBQUAL_Comments.AGERANGENAME">
			<CFSET GROUPTITLE = "Age Range">
		</CFIF>

		<CFIF #FORM.REPORTCHOICE# EQ 6>
			<CFSET REPORTTITLE = "REPORT 3: &nbsp;&nbsp;Comments Criteria Count By Gender Report">
			<CFSET FIELDNAME = "ListLIBQUAL_Comments.GENDERNAME">
			<CFSET GROUPTITLE = "Gender">
		</CFIF>

		<CFINCLUDE template="lqcountrpts.cfm">
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>