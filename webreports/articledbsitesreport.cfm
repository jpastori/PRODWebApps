<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: articledbsitesreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/19/2007 --->
<!--- Date in Production: 01/19/2007 --->
<!--- Module: Web Reports - Article DB Sites Report --->
<!-- Last modified by John R. Pastori on 01/19/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/articledbsitesreport.cfm">
<CFSET CONTENT_UPDATED = "January 19, 2007">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Web Reports - Article DB Sites Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDBSITEID')>
	<CFSET CURSORFIELD = "document.LOOKUP.DBSITEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
********************************************************************************************
* The following code is the Look Up Process for the Web Reports - Article DB Sites Report. *
********************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPDBSITEID')>

	<CFQUERY name="ListArticleDBSites" datasource="#application.type#WEBREPORTS" blockfactor="100">
		SELECT	DBSITEID, DBSITENAME, DBSITEURL, DBDESCRIPTION, DBACTIVE, DBPREFIXIMAGE, ARTICLESDBPAGE, USESLIBPROXY, DBSFXENABLED,
				DBSFXCOMMENTS, DBSUBJECTS, DBSTATSREPORT, ADDITIONALCOMMENTS, ALPHATITLEID, GOODGENERALDB, DBFULLTEXT,
				INITCAP(DBSITENAME) AS SORTTITLE
		FROM		ARTICLEDBSITES
		ORDER BY	SORTTITLE
	</CFQUERY>

	<CFQUERY name="ListSubjectCategories" datasource="#application.type#WEBREPORTS" blockfactor="51">
		SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL
		FROM		SUBJECTCATEGORIES
		ORDER BY	SUBJECTCATNAME
	</CFQUERY>

	<CFQUERY name="ListAlphaTitles" datasource="#application.type#LIBSHAREDDATA" blockfactor="31">
		SELECT	ALPHATITLEID, ALPHATITLE
		FROM		ALPHATITLES
		ORDER BY	ALPHATITLE
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Web Reports - Article DB Sites Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center"><H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>

	<TABLE width="100%" align="LEFT">
<CFFORM name="LOOKUP" action="/#application.type#apps/webreports/articledbsitesreport.cfm?LOOKUPDBSITEID=FOUND" method="POST">
		<TR>
			<TH align="LEFT"><LABEL for="DBSITENAME">Article DB Site Name</LABEL></TH>
			<TH align="left" valign ="bottom"><LABEL for="DBSITEURL">Article DB Site URL</LABEL></TH>
		</TR>
		<TR>
			<TD align="LEFT" width="70%">
				<CFSELECT name="DBSITEID" id="DBSITENAME" size="1" query="ListArticleDBSites" value="DBSITEID" display="DBSITENAME" selected ="0" required="No" tabindex="2"></CFSELECT>
			</TD><TD align="left">
				<CFINPUT type="Text" name="DBSITEURL" id="DBSITEURL" value="" align="LEFT" required="No" size="50" maxlength="255" tabindex="3">
			</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="DBDESCRIPTION">Article DB Site Description</LABEL></TH>
		<TH align="left" valign ="bottom"><LABEL for="DBSUBJECTS">Article DB Subject Category</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign="TOP">
			<CFINPUT type="Text" name="DBDESCRIPTION" id="DBDESCRIPTION" value="" align="LEFT" required="No" size="50" maxlength="600" tabindex="4">
		</TD>
		<TD align="left" valign ="TOP">
			<CFSELECT name="DBSUBJECTS" id="DBSUBJECTS" size="1" query="ListSubjectCategories" value="SUBJECTCATID" display="SUBJECTCATNAME" selected ="0" required="No" tabindex="5"></CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="ALPHATITLEID">Alpha Title</LABEL></TH>
		<TH align="left"><LABEL for="GOODGENERALDB">Good General Database?</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign ="TOP">
			<CFSELECT name="ALPHATITLEID" id="ALPHATITLEID" size="1" query="ListAlphaTitles" value="ALPHATITLEID" display="ALPHATITLE" selected ="0" required="No" tabindex="6"></CFSELECT>
		</TD>
		<TD align="left" valign="TOP">
			<CFSELECT name="GOODGENERALDB" id="GOODGENERALDB" size="1" tabindex="7">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="NO">NO</OPTION>
				<OPTION value="YES">YES</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="DBACTIVE">Article DB Active?</LABEL></TH>
		<TH align="left" valign ="bottom"><LABEL for="DBSTATSREPORT">Select for Article DB Stats Report?</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign ="TOP">
			<CFSELECT name="DBACTIVE" id="DBACTIVE" size="1" tabindex="8">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
		<TD align="left">
			<CFSELECT name="DBSTATSREPORT" id="DBSTATSREPORT" size="1" tabindex="9">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="ARTICLESDBPAGE">Used on Articles DB Page?</LABEL></TH>
		<TH align="left" valign ="bottom"><LABEL for="USESLIBPROXY">Uses LibProxy Call?</LABEL></TH>
	</TR>
	<TR>
		<TD align="left" valign ="TOP">
			<CFSELECT name="ARTICLESDBPAGE" id="ARTICLESDBPAGE" size="1" tabindex="10">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
		<TD align="left">
			<CFSELECT name="USESLIBPROXY" id="USESLIBPROXY" size="1" tabindex="11">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="DBPREFIXIMAGE">Article DB Prefix Image Displayed?</LABEL></TH>
		<TH align="left" valign ="bottom"><LABEL for="DBSFXENABLED">Article DB SFX Enabled?</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="DBPREFIXIMAGE" id="DBPREFIXIMAGE" size="1" tabindex="12">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
		<TD align="left">
			<CFSELECT name="DBSFXENABLED" id="DBSFXENABLED" size="1" tabindex="13">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="DBFULLTEXT">Article DB Full Text?</LABEL></TH>
		<TH align="left" valign ="bottom">&nbsp;&nbsp;</TH>
	</TR>
	<TR>
		<TD align="left">
			<CFSELECT name="DBFULLTEXT" id="DBFULLTEXT" size="1" tabindex="14">
				<OPTION value="Make a Selection">Make a Selection</OPTION>
				<OPTION value="YES">YES</OPTION>
				<OPTION value="NO">NO</OPTION>
			</CFSELECT>
		</TD>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
		<TH align="left" valign ="bottom"><LABEL for="ADDITIONALCOMMENTS">Additional Comments</LABEL></TH>
		<TH align="left" valign ="bottom"><LABEL for="DBSFXCOMMENTS">DB SFX Comments</LABEL></TH>
	</TR>
	<TR>
		<TD align="left">
			<CFINPUT type="Text" name="ADDITIONALCOMMENTS" id="ADDITIONALCOMMENTS" value="" align="LEFT" required="No" size="50" maxlength="600" tabindex="15">
		</TD>
		<TD align="left">
			<CFINPUT type="Text" name="DBSFXCOMMENTS" id="DBSFXCOMMENTS" value="" align="LEFT" required="No" size="50" maxlength="600" tabindex="16">
		</TD>
	</TR>
		<TR>
			<TD colspan="2"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
	<TH colspan="2"><H2>Clicking the "Match All" Button with no selections equals ALL records for the report.</H2></TH>
	</TR>
		<TR>
	<TD align="LEFT">
		<BR /><INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="17" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="18" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="2">
				<INPUT type="submit" value="Cancel" tabindex="19" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
******************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Article DB Sites Report. *
******************************************************************************************************
 --->

	<CFSET REPORTHEADER2 = "Selection is:">
	<CFIF #FORM.DBSITEID# GT 0>

		<CFQUERY name="ListArticleDBSites" datasource="#application.type#WEBREPORTS">
			SELECT	DBSITEID, DBSITENAME, INITCAP(DBSITENAME) AS SORTTITLE
			FROM		ARTICLEDBSITES
			WHERE	DBSITEID = <CFQUERYPARAM value="#FORM.DBSITEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SORTTITLE
		</CFQUERY>

		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB SITE NAME  = #ListArticleDBSites.DBSITENAME# - #FORM.DBSITEID#">
	</CFIF>

	<CFIF #FORM.DBSITEURL# NEQ "">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB SITE URL = #FORM.DBSITEURL#">
	</CFIF>

	<CFIF #FORM.DBDESCRIPTION# NEQ "">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB DESCRIPTION = #FORM.DBDESCRIPTION#">
	</CFIF>

	<CFIF #FORM.DBSUBJECTS# GT 0>
		<CFSET SUBJECTDBSITEID = ''>

		<CFQUERY name="LookupArticleDBSiteSubjects" datasource="#application.type#WEBREPORTS" blockfactor="100">
			SELECT	DBSITEID, DBSITENAME, DBSITEURL, DBDESCRIPTION, DBACTIVE, DBPREFIXIMAGE, ARTICLESDBPAGE, USESLIBPROXY, DBSFXENABLED,
					DBSFXCOMMENTS, DBSUBJECTS, DBSTATSREPORT, ADDITIONALCOMMENTS, INITCAP(DBSITENAME) AS SORTTITLE
			FROM		ARTICLEDBSITES
			WHERE	DBACTIVE = 'YES'
			ORDER BY	SORTTITLE
		</CFQUERY>

		<CFLOOP query="LookupArticleDBSiteSubjects">

			<CFIF #LISTFIND(LookupArticleDBSiteSubjects.DBSUBJECTS, '#FORM.DBSUBJECTS#')# NEQ 0>
				<CFSET SUBJECTDBSITEID = SUBJECTDBSITEID & #LookupArticleDBSiteSubjects.DBSITEID# & "," >
			</CFIF>

		</CFLOOP>
		<CFSET SUBJECTDBSITEID = #REMOVECHARS(SUBJECTDBSITEID, LEN(SUBJECTDBSITEID), 1)#>
		SUBJECT DB SITE ID LIST = #SUBJECTDBSITEID#
		<CFQUERY name="ListSubjectCategories" datasource="#application.type#WEBREPORTS">
			SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL, SUBJECTCATCOMMENTS
			FROM		SUBJECTCATEGORIES
			WHERE	SUBJECTCATID = <CFQUERYPARAM value="#FORM.DBSUBJECTS#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	SUBJECTCATNAME
		</CFQUERY>
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB SUBJECT = #ListSubjectCategories.SUBJECTCATNAME#">
	</CFIF>

	<CFIF #FORM.ALPHATITLEID# GT 0>

		<CFQUERY name="ListAlphaTitles" datasource="#application.type#LIBSHAREDDATA">
			SELECT	ALPHATITLEID, ALPHATITLE
			FROM		ALPHATITLES
			WHERE	ALPHATITLEID = <CFQUERYPARAM value="#FORM.ALPHATITLEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	ALPHATITLE
		</CFQUERY>

		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;ALPHA TITLE = #ListAlphaTitles.ALPHATITLE# - #FORM.ALPHATITLEID#">
	</CFIF>

	<CFIF #FORM.GOODGENERALDB# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;GOOD GENERAL DB = #FORM.GOODGENERALDB#">
	</CFIF>

	<CFIF #FORM.DBACTIVE# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB ACTIVE = #FORM.DBACTIVE#">
	</CFIF>

	<CFIF #FORM.DBSTATSREPORT# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB STATS REPORT = #FORM.DBSTATSREPORT#">
	</CFIF>

	<CFIF #FORM.ARTICLESDBPAGE# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;ARTICLES DB PAGE = #FORM.ARTICLESDBPAGE#">
	</CFIF>

	<CFIF #FORM.USESLIBPROXY# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;USES LIBPROXY = #FORM.USESLIBPROXY#">
	</CFIF>

	<CFIF #FORM.DBPREFIXIMAGE# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB PREFIX IMAGE = #FORM.DBPREFIXIMAGE#">
	</CFIF>

	<CFIF #FORM.DBSFXENABLED# NEQ "Make a Selection">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB SFX ENABLED = #FORM.DBSFXENABLED#">
	</CFIF>

	<CFIF #FORM.ADDITIONALCOMMENTS# NEQ "">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;ADDITIONAL COMMENTS = #FORM.ADDITIONALCOMMENTS#">
	</CFIF>

	<CFIF #FORM.DBSFXCOMMENTS# NEQ "">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;DB SFX COMMENTS = #FORM.DBSFXCOMMENTS#">
	</CFIF>

	<CFIF REPORTHEADER2 EQ "Selection is:">
		<CFSET REPORTHEADER2 = REPORTHEADER2 & "&nbsp;&nbsp;&nbsp;&nbsp;All Records">
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = "!=">
	</CFIF>

	<CFQUERY name="ListArticleDBSites" datasource="#application.type#WEBREPORTS" blockfactor="100">
		SELECT	ADBS.DBSITEID, ADBS.DBSITENAME, ADBS.DBSITEURL, ADBS.DBDESCRIPTION, ADBS.DBSUBJECTS,
				ADBS.ALPHATITLEID, AT.ALPHATITLEID, AT.ALPHATITLE, ADBS.GOODGENERALDB, ADBS.DBACTIVE,
				ADBS.DBSTATSREPORT, ADBS.ARTICLESDBPAGE, ADBS.USESLIBPROXY, ADBS.DBPREFIXIMAGE, ADBS.DBSFXENABLED,
				ADBS.DBFULLTEXT, ADBS.ADDITIONALCOMMENTS, ADBS.DBSFXCOMMENTS, INITCAP(ADBS.DBSITENAME) AS SORTTITLE
		FROM		ARTICLEDBSITES ADBS, LIBSHAREDDATAMGR.ALPHATITLES AT
		WHERE	(ADBS.DBSITEID > 0 AND
				ADBS.ALPHATITLEID = AT.ALPHATITLEID) AND (
			<CFIF #FORM.DBSITEID# GT 0>
				ADBS.DBSITEID = #val(FORM.DBSITEID)# #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBSITEURL# NEQ "">
				ADBS.DBSITEURL LIKE ('%#FORM.DBSITEURL#%') #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBDESCRIPTION# NEQ "">
				ADBS.DBDESCRIPTION LIKE ('%#FORM.DBDESCRIPTION#%') #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBSUBJECTS# GT 0>
				ADBS.DBSITEID IN (#SUBJECTDBSITEID#) #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.ALPHATITLEID# GT 0>
				ADBS.ALPHATITLEID = #val(FORM.ALPHATITLEID)# #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.GOODGENERALDB# NEQ "Make a Selection">
				ADBS.GOODGENERALDB = '#FORM.GOODGENERALDB#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBACTIVE# NEQ "Make a Selection">
				ADBS.DBACTIVE = '#FORM.DBACTIVE#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBSTATSREPORT# NEQ "Make a Selection">
				ADBS.DBSTATSREPORT = '#FORM.DBSTATSREPORT#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.ARTICLESDBPAGE# NEQ "Make a Selection">
				ADBS.ARTICLESDBPAGE = '#FORM.ARTICLESDBPAGE#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.USESLIBPROXY# NEQ "Make a Selection">
				ADBS.USESLIBPROXY = '#FORM.USESLIBPROXY#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBPREFIXIMAGE# NEQ "Make a Selection">
				ADBS.DBPREFIXIMAGE = '#FORM.DBPREFIXIMAGE#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBSFXENABLED# NEQ "Make a Selection">
				ADBS.DBSFXENABLED = '#FORM.DBSFXENABLED#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBFULLTEXT# NEQ "Make a Selection">
				ADBS.DBFULLTEXT = '#FORM.DBFULLTEXT#' #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.ADDITIONALCOMMENTS# NEQ "">
				ADBS.ADDITIONALCOMMENTS LIKE ('%#FORM.ADDITIONALCOMMENTS#%') #LOGICANDOR#
			</CFIF>
			<CFIF #FORM.DBSFXCOMMENTS# NEQ "">
				ADBS.DBSFXCOMMENTS LIKE ('%#FORM.DBSFXCOMMENTS#%') #LOGICANDOR#
			</CFIF>
				ADBS.ALPHATITLEID #FINALTEST# 0)
		ORDER BY	SORTTITLE
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
				<H1>Web Reports - Article DB Sites Report</H1>
				<H2>#REPORTHEADER2#</H2>
			</TD>
		</TR>
	</TABLE>
	<TABLE border="0" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/webreports/articledbsitesreport.cfm" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" value="Cancel" tabindex="1" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="LEFT" colspan="4"><H2>#ListArticleDBSites.RecordCount# Article DB Site records were selected.</H2></TH>
		</TR>

<CFLOOP query="ListArticleDBSites">
		<TR>
			<TH align="LEFT" valign="bottom" colspan="2">Article DB Site Name</TH>
			<TH align="LEFT" valign="bottom" colspan="2">Article DB Description</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign ="TOP" colspan="2"><DIV><COM>#ListArticleDBSites.DBSITENAME#</COM></DIV></TD>
			<TD align="LEFT" valign ="TOP" colspan="2"><DIV>#ListArticleDBSites.DBDESCRIPTION#</DIV></TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="bottom" colspan="3">Article DB Site URL</TH>
			<TH align="LEFT" valign="bottom">Article DB Subject Category</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign ="TOP" colspan="3">
			<CFIF #ListArticleDBSites.USESLIBPROXY# EQ 'YES'>
				<CFSET libproxyurl = "http://libproxy.sdsu.edu/login?url=">
			<CFELSE>
				<CFSET libproxyurl = "">
			</CFIF>
			<CFFORM method="POST">
				<DIV><u>#ListArticleDBSites.DBSITEURL#</u></DIV>
				<DIV><INPUT type="BUTTON" value="Open Site Window" onClick="window.open('#libproxyurl##ListArticleDBSites.DBSITEURL#','#ListArticleDBSites.DBSITENAME#','alwaysRaised=yes,dependent=no,width=1000,height=600,toolbar=yes,scrollbars=yes,userbar=yes,location=yes,status=yes,menubar=yes,,screenX=25,screenY=25');" />
				&nbsp;&nbsp;&nbsp;&nbsp;<A href="#libproxyurl##ListArticleDBSites.DBSITEURL#">Alternate Site Access</A></DIV>
			</CFFORM>
			</TD>
			<TD align="LEFT" nowrap valign="TOP">
				<CFQUERY name="GetArticleDBSites" datasource="#application.type#WEBREPORTS" blockfactor="100">
					SELECT	ADBS.DBSITEID, ADBS.DBSITENAME, ADBS.DBSITEURL, ADBS.DBDESCRIPTION, ADBS.DBACTIVE, ADBS.DBPREFIXIMAGE,
							ADBS.ARTICLESDBPAGE, ADBS.USESLIBPROXY, ADBS.DBSFXENABLED, ADBS.DBSFXCOMMENTS, ADBS.DBSUBJECTS,
							ADBS.DBSTATSREPORT, ADBS.ADDITIONALCOMMENTS, ADBS.DBFULLTEXT
					FROM		ARTICLEDBSITES ADBS
					WHERE	ADBS.DBSITEID = #ListArticleDBSites.DBSITEID#
					ORDER BY	ADBS.DBSITENAME
				</CFQUERY>

				<CFIF NOT #GetArticleDBSites.DBSUBJECTS# EQ ''>

					<CFQUERY name="ListSubjectCategories" datasource="#application.type#WEBREPORTS" blockfactor="100">
						SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL
						FROM		SUBJECTCATEGORIES
						WHERE	SUBJECTCATID IN (#ValueList(GetArticleDBSites.DBSUBJECTS)#)
						ORDER BY	SUBJECTCATNAME
					</CFQUERY>

					<CFLOOP query="ListSubjectCategories">
						<DIV>#ListSubjectCategories.SUBJECTCATNAME#<BR /></DIV>
					</CFLOOP>
				<CFELSE>
					<DIV>&nbsp;&nbsp;</DIV>
			</CFIF>
			</TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="bottom">Alpha Title</TH>
			<TH align="CENTER" valign="bottom">Good General Database?</TH>
			<TH align="CENTER" valign="bottom">Article DB Active?</TH>
			<TH align="CENTER" valign="bottom">Article DB Prefix Image Displayed?</TH>
		</TR>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.ALPHATITLE#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.GOODGENERALDB#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.DBACTIVE#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.DBPREFIXIMAGE#</DIV></TD>
		</TR>
		<TR>
			<TH align="CENTER" valign="bottom">Used on Articles DB Page?</TH>
			<TH align="CENTER" valign="bottom">Uses LibProxy Call?</TH>
			<TH align="CENTER" valign="bottom">Article DB SFX Enabled?</TH>
			<TH align="CENTER" valign="bottom">Select for Article DB Stats Report?</TH>
		</TR>
		<TR>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.ARTICLESDBPAGE#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.USESLIBPROXY#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.DBSFXENABLED#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.DBSTATSREPORT#</DIV></TD>
		</TR><TR>
			<TH align="LEFT" valign ="bottom" colspan="2">Additional Comments</TH>
			<TH align="CENTER" valign ="bottom">DB SFX Comments</TH>
			<TH align="CENTER" valign ="bottom">DB Full Text?</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" colspan="2"><DIV>#ListArticleDBSites.ADDITIONALCOMMENTS#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#ListArticleDBSites.DBSFXCOMMENTS#</DIV></TD>
			<TD align="CENTER" valign="TOP"><DIV>#ListArticleDBSites.DBFULLTEXT#</DIV></TD>
		</TR>
		<TR>
			<TD align="CENTER" colspan="4"><HR /></TD>
		</TR>
</CFLOOP>
		<TR>
			<TD align="CENTER" colspan="4"><HR size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="LEFT" colspan="4"><H2>#ListArticleDBSites.RecordCount# Article DB Site records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/webreports/articledbsitesreport.cfm" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="submit" value="Cancel" tabindex="2" />
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="7">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>