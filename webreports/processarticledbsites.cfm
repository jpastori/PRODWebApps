<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processarticledbsites.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/01/2008 --->
<!--- Date in Production: 02/01/2008 --->
<!--- Module: Process Information to Web Reports - Article DB Sites --->
<!-- Last modified by John R. Pastori on 02/01/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to Library Web Reports - Article DB Sites</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF FORM.PROCESSARTICLEDBSITE EQ "ADD" OR FORM.PROCESSARTICLEDBSITE EQ "MODIFY">
	<CFQUERY name="ModifyArticleDBSite" datasource="#application.type#WEBREPORTS">
		UPDATE	ARTICLEDBSITES
		SET		DBSITENAME = '#FORM.DBSITENAME#',
				DBSITEURL = '#FORM.DBSITEURL#',
				DBDESCRIPTION = '#FORM.DBDESCRIPTION#',
				DBACTIVE = '#FORM.DBACTIVE#',
				DBPREFIXIMAGE = '#FORM.DBPREFIXIMAGE#',
				DBSFXENABLED = '#FORM.DBSFXENABLED#',
				DBSFXCOMMENTS = '#FORM.DBSFXCOMMENTS#',
				DBSUBJECTS = '#FORM.DBSUBJECTS#',
				DBSTATSREPORT = '#FORM.DBSTATSREPORT#',
				ARTICLESDBPAGE = '#FORM.ARTICLESDBPAGE#',
				USESLIBPROXY = '#FORM.USESLIBPROXY#',
				ADDITIONALCOMMENTS = '#FORM.ADDITIONALCOMMENTS#',
				ALPHATITLEID = #val(FORM.ALPHATITLEID)#,
				GOODGENERALDB = '#FORM.GOODGENERALDB#',
				DBFULLTEXT = '#FORM.DBFULLTEXT#'
		WHERE	(DBSITEID = #val(Cookie.DBSITEID)#)
	</CFQUERY>
	<CFIF FORM.PROCESSARTICLEDBSITE EQ "ADD">
		<H1>Data ADDED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/articledbsites.cfm?PROCESS=ADD" />
	<CFELSE>
		<H1>Data MODIFIED!</H1>
		<META http-equiv="Refresh" content="1; URL=/#application.type#apps/webreports/articledbsites.cfm?PROCESS=MODIFY" />
	</CFIF>
</CFIF>

<CFIF FORM.PROCESSARTICLEDBSITE EQ "CANCELADD">
	<CFQUERY name="DeleteArticleDBSite" datasource="#application.type#WEBREPORTS">
		DELETE FROM	ARTICLEDBSITES
		WHERE		DBSITEID = #val(Cookie.DBSITEID)#
	</CFQUERY>
	<H1>Data DELETED!</H1>
	<META http-equiv="Refresh" content="1; URL=#Cookie.INDEXDIR#/index.cfm?logout=No" />
</CFIF>
</CFOUTPUT>

</BODY>
</HTML>