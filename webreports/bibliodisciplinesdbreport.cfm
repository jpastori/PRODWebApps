<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: bibliodisciplinesdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/02/2009 --->
<!--- Date in Production: 02/02/2009 --->
<!--- Module: Web Reports - Bibliography/Disciplines Report--->
<!-- Last modified by John R. Pastori on 02/02/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/bibliodisciplinesdbreport.cfm">
<CFSET CONTENT_UPDATED = "February 02, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">
<HTML>
<HEAD>
	<TITLE>Web Reports - Bibliography/Disciplines Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET CURSORFIELD = "document.LOOKUP.REPORTCHOICE[0].focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
****************************************************************************************************
* The following code is the Look Up Process for the Web Reports - Bibliography/Disciplines Report. *
****************************************************************************************************
 --->

<CFIF NOT IsDefined('URL.PROCESS')>

	<CFQUERY name="ListDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="92">
		SELECT	DISCIPLINEID, DISCIPLINENAME
		FROM		DISCIPLINES
		ORDER BY	DISCIPLINENAME
	</CFQUERY>

	<CFQUERY name="ListSubDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="94">
		SELECT	BD.BIBLIODISCIPLINEID, BD.DISCIPLINEID, BD.SUBDISCIPLINE, D.DISCIPLINENAME, BD.BIBLIOGRAPHERID,
				BD.ALTERNATEBIBLIOGRAPHERID, BD.BIBLIOACADEMICYEARID, D.DISCIPLINENAME || ' - ' || BD.SUBDISCIPLINE AS DISCIPLINE
		FROM 	BIBLIODISCIPLINES BD, DISCIPLINES D
		WHERE	(BD.BIBLIODISCIPLINEID = 0 AND
				D.DISCIPLINEID = 0) OR
				(BD.DISCIPLINEID = D.DISCIPLINEID AND
				NOT BD.SUBDISCIPLINE IS NULL)
		ORDER BY	DISCIPLINE
	</CFQUERY>

	<CFQUERY name="ListBibliographers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
		SELECT	CUSTOMERID, FULLNAME, LASTNAME, BIBLIOGRAPHER, ACTIVE
		FROM		CUSTOMERS
		WHERE	BIBLIOGRAPHER = 'YES' AND
				ACTIVE = 'YES'
		ORDER BY	FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Select Data for Web Reports - Bibliography/Disciplines Report</H1></TD>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/webreports/bibliodisciplinesdbreport.cfm?PROCESS=LOOKUP" method="POST">
		<TR>
			<TD align="LEFT" valign="TOP" colspan="3"><COM>Select one of the five (5) reports below, then click the Select Options button.</COM></TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="2" /></TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="3">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE1">REPORT 1: &nbsp;&nbsp;All Bibliography/Disciplines</LABEL></TH>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="4">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE2">REPORT 2:</LABEL> &nbsp;&nbsp;<LABEL for="DISCIPLINEID">Specific Discipline</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="DISCIPLINEID" id="DISCIPLINEID" size="1" query="ListDisciplines" value="DISCIPLINEID" selected ="0" display="DISCIPLINENAME" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE3" value="3" align="LEFT" required="No" tabindex="6">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE3">REPORT 3:</LABEL> &nbsp;&nbsp;<LABEL for="BIBLIODISCIPLINEID">Specific Sub-Discipline</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="BIBLIODISCIPLINEID" id="BIBLIODISCIPLINEID" size="1" query="ListSubDisciplines" value="BIBLIODISCIPLINEID" selected ="0" display="DISCIPLINE" required="No" tabindex="7"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE4" value="4" align="LEFT" required="No" tabindex="8">
			</TD>
			<TH align="left" valign="TOP"><LABEL for="REPORTCHOICE4">REPORT 4:</LABEL> &nbsp;&nbsp;<LABEL for="BIBLIOGRAPHERID">Specific Bibliographer</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="BIBLIOGRAPHERID" id="BIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" selected="0" display="FULLNAME" required="no" tabindex="9"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD colspan="3">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE5" value="5" align="LEFT" required="No" tabindex="10">
			</TD>
			<TH align="left" valign="TOP" nowrap><LABEL for="REPORTCHOICE5">REPORT 5:</LABEL> &nbsp;&nbsp;<LABEL for="ALTERNATEBIBLIOGRAPHERID">Specific Alternate Bibliographer</LABEL></TH>
			<TD align="LEFT" valign="TOP">
				<CFSELECT name="ALTERNATEBIBLIOGRAPHERID" id="ALTERNATEBIBLIOGRAPHERID" size="1" query="ListBibliographers" value="CUSTOMERID" selected="0" display="FULLNAME" required="no" tabindex="11"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" valign="TOP"><INPUT type="SUBMIT" value="Select Options" tabindex="12" /></TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="LEFT" valign="TOP">&nbsp;&nbsp;</TD>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="13" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="3">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
**************************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Bibliography/Disciplines Report. *
**************************************************************************************************************
 --->

	<CFSET REPORTTITLE = ''>
	<CFIF #FORM.REPORTCHOICE# EQ 1>
		<CFSET REPORTTITLE = 'REPORT 1: &nbsp;&nbsp;All Bibliography/Disciplines'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<CFSET REPORTTITLE = 'REPORT 2: &nbsp;&nbsp;Specific Discipline'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 3>
		<CFSET REPORTTITLE = 'REPORT 3: &nbsp;&nbsp;Specific Sub-Discipline'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<CFSET REPORTTITLE = 'REPORT 4: &nbsp;&nbsp;Specific Bibliographer'>
	</CFIF>

	<CFIF #FORM.REPORTCHOICE# EQ 5>
		<CFSET REPORTTITLE = 'REPORT 5: &nbsp;&nbsp;Specific Alternate Bibliographer'>
	</CFIF>

	<CFQUERY name="LookupBiblioDisciplines" datasource="#application.type#WEBREPORTS" blockfactor="94">
		SELECT	BD.BIBLIODISCIPLINEID, BD.DISCIPLINEID, D.DISCIPLINENAME, BD.SUBDISCIPLINE, BD.BIBLIOGRAPHERID, BD.ALTERNATEBIBLIOGRAPHERID,
				BD.BIBLIOACADEMICYEARID, CUST1.FULLNAME AS BIBLIOGRAPHER, CUST2.FULLNAME AS ALTERNATEBIBLIOGRAPHER,
				FY.FISCALYEAR_4DIGIT AS FISCALYEAR
		FROM 	BIBLIODISCIPLINES BD, DISCIPLINES D, LIBSHAREDDATAMGR.CUSTOMERS CUST1, LIBSHAREDDATAMGR.CUSTOMERS CUST2, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	BD.BIBLIODISCIPLINEID > 0 AND
				BD.DISCIPLINEID = D.DISCIPLINEID AND
			<CFIF #FORM.REPORTCHOICE# EQ 2>
				BD.DISCIPLINEID = #val(FORM.DISCIPLINEID)# AND
			</CFIF>
			<CFIF #FORM.REPORTCHOICE# EQ 3>
				BD.BIBLIODISCIPLINEID = #val(FORM.BIBLIODISCIPLINEID)# AND
			</CFIF>
				CUST1.BIBLIOGRAPHER = 'YES' AND
				CUST2.BIBLIOGRAPHER = 'YES' AND
				BD.BIBLIOGRAPHERID = CUST1.CUSTOMERID AND 
			<CFIF #FORM.REPORTCHOICE# EQ 4>
				BD.BIBLIOGRAPHERID = #val(FORM.BIBLIOGRAPHERID)# AND
			</CFIF>
				BD.ALTERNATEBIBLIOGRAPHERID = CUST2.CUSTOMERID AND
			<CFIF #FORM.REPORTCHOICE# EQ 5>
				BD.ALTERNATEBIBLIOGRAPHERID = #val(FORM.ALTERNATEBIBLIOGRAPHERID)# AND
			</CFIF>
				BD.BIBLIOACADEMICYEARID = FY.FISCALYEARID
		ORDER BY	D.DISCIPLINENAME, BD.SUBDISCIPLINE
	</CFQUERY>

	<CFIF #LookupBiblioDisciplines.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Bibliography/Disciplines Record Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/webreports/bibliodisciplinesdbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR>
			<TD align="center">
				<H1>Web Reports - Bibliography/Disciplines Report
				<H2>#REPORTTITLE#
			</H2></H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/webreports/bibliodisciplinesdbreport.cfm" method="POST">
			<TD align="LEFT">
				<INPUT type="submit" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			</TR><CAPTION><H2> Academic Year:  #LookupBiblioDisciplines.FISCALYEAR#</H2></CAPTION>
			<TD colspan="5"><HR width="100%" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupBiblioDisciplines.RecordCount# Bibliography/Discipline records were selected.</H2></TH>
		</TR>
	<CFIF #FORM.REPORTCHOICE# EQ 2>
		<TR>
			<TH align="left" valign="bottom">Discipline</TH>
		</TR>
		<TR>
			<TD align="left"><DIV>#LookupBiblioDisciplines.DISCIPLINENAME#</DIV></TD>
		</TR>
	</CFIF>
	<CFIF #FORM.REPORTCHOICE# EQ 4>
		<TR>
			<TH align="left" valign="bottom">Bibliographer</TH>
		</TR>
		<TR>
			<TD align="left"><DIV>#LookupBiblioDisciplines.BIBLIOGRAPHER#</DIV></TD>
		</TR>
	</CFIF>
	<CFIF #FORM.REPORTCHOICE# EQ 5>
		<TR>
			<TH align="left" valign="bottom">Alternate<BR /> Bibliographer</TH>
		</TR>
		<TR>
			<TD align="left"><DIV>#LookupBiblioDisciplines.ALTERNATEBIBLIOGRAPHER#</DIV></TD>
		</TR>
	</CFIF>
		<TR>
		<CFIF #FORM.REPORTCHOICE# NEQ 2>
			<TH align="left" valign="bottom">Discipline</TH>
		</CFIF>
			<TH align="left" valign="bottom">Sub-Discipline</TH>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<TH align="left" valign="bottom">Bibliographer</TH>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 5>
			<TH align="left">Alternate<BR /> Bibliographer</TH>
		</CFIF>
		</TR>

	<CFLOOP query="LookupBiblioDisciplines">
		<TR>
		<CFIF #FORM.REPORTCHOICE# NEQ 2>
			<TD align="left"><DIV>#LookupBiblioDisciplines.DISCIPLINENAME#</DIV></TD>
		</CFIF>
			<TD align="left"><DIV>#LookupBiblioDisciplines.SUBDISCIPLINE#</DIV></TD>
		<CFIF #FORM.REPORTCHOICE# NEQ 4>
			<CFIF BIBLIOGRAPHERID GT 0>
				<TD align="left"><DIV>#LookupBiblioDisciplines.BIBLIOGRAPHER#</DIV></TD>
			<CFELSE>
				<TD align="left">&nbsp;&nbsp;</TD>
			</CFIF>
		</CFIF>
		<CFIF #FORM.REPORTCHOICE# NEQ 5>
			<CFIF ALTERNATEBIBLIOGRAPHERID GT 0>
				<TD align="left"><DIV>#LookupBiblioDisciplines.ALTERNATEBIBLIOGRAPHER#</DIV></TD>
			<CFELSE>
				<TD align="left">&nbsp;&nbsp;</TD>
			</CFIF>
		</CFIF>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupBiblioDisciplines.RecordCount# Bibliography/Discipline records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/bibliodisciplinesdbreport.cfm" method="POST">
			<TD align="LEFT">
				<INPUT type="submit" value="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>