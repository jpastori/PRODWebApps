<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: articledbsites.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 02/02/2009 --->
<!--- Date in Production: 02/02/2009 --->
<!--- Module: Add/Modify Information to Web Reports - Article DB Sites --->
<!-- Last modified by John R. Pastori on 02/02/2009 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/articledbsites.cfm">
<CFSET CONTENT_UPDATED = "February 02, 2009">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Article DB Sites</TITLE>
	<CFELSE>
		<TITLE>Modify Information to Web Reports - Article DB Sites</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to the Library Web Reports Application";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {

		if (document.DBSITE.DBSITENAME.value == "" || document.DBSITE.DBSITENAME.value == " ") {
			alertuser (document.DBSITE.DBSITENAME.name +  ",  A DBSITE Name MUST be entered!");
			document.DBSITE.DBSITENAME.focus();
			return false;
		}

		if (document.DBSITE.DBSITEURL.value == "" || document.DBSITE.DBSITEURL.value == " ") {
			alertuser (document.DBSITE.DBSITEURL.name +  ",  A DBSITE URL MUST be entered!");
			document.DBSITE.DBSITEURL.focus();
			return false;
		}

		if (document.DBSITE.DBDESCRIPTION.value == "" || document.DBSITE.DBDESCRIPTION.value == " ") {
			alertuser (document.DBSITE.DBDESCRIPTION.name +  ",  A DB Description MUST be entered!");
			document.DBSITE.DBDESCRIPTION.focus();
			return false;
		}

		if (document.DBSITE.DBSUBJECTS.value == "" || document.DBSITE.DBSUBJECTS.value == " ") {
			alertuser (document.DBSITE.DBSUBJECTS.name +  ",  A DB Subject Category Name MUST be Selected!");
			document.DBSITE.DBSUBJECTS.focus();
			return false;
		}

		if (document.DBSITE.ALPHATITLEID.selectedIndex == "0") {
			alertuser (document.DBSITE.ALPHATITLEID.name +  ",  An Alpha Title  MUST be Selected!");
			document.DBSITE.ALPHATITLEID.focus();
			return false;
		}

	}


	function validateLookupField() {
		if (document.LOOKUP.DBSITEID.selectedIndex == "0") {
			alertuser ("A DBSITE Name MUST be selected!");
			document.LOOKUP.DBSITEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPDBSITEID') AND URL.PROCESS EQ "MODIFY">
	<CFSET CURSORFIELD = "document.LOOKUP.DBSITEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.DBSITE.DBSITENAME.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListArticleDBSites" datasource="#application.type#WEBREPORTS" blockfactor="100">
	SELECT	DBSITEID, DBSITENAME, DBSITEURL, DBDESCRIPTION, DBACTIVE, DBPREFIXIMAGE, ARTICLESDBPAGE, USESLIBPROXY, DBSFXENABLED,
			DBSFXCOMMENTS, DBSUBJECTS, DBSTATSREPORT, ADDITIONALCOMMENTS, ALPHATITLEID, GOODGENERALDB, DBFULLTEXT,
			INITCAP(DBSITENAME) AS SORTTITLE
	FROM		ARTICLEDBSITES
	ORDER BY	SORTTITLE
</CFQUERY>

<CFQUERY name="ListSubjectCategories" datasource="#application.type#WEBREPORTS" blockfactor="50">
	SELECT	SUBJECTCATID, SUBJECTCATNAME, SUBJECTCATURL
	FROM		SUBJECTCATEGORIES
	WHERE	SUBJECTCATID > 0
	ORDER BY	SUBJECTCATNAME
</CFQUERY>

<CFQUERY name="ListAlphaTitles" datasource="#application.type#LIBSHAREDDATA" blockfactor="31">
	SELECT	ALPHATITLEID, ALPHATITLE
	FROM		ALPHATITLES
	ORDER BY	ALPHATITLE
</CFQUERY>

<BR clear="left" />

<!--- 
***************************************************************
* The following code is the ADD Process for Article DB Sites. *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Article DB Sites</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
			SELECT	MAX(DBSITEID) AS MAX_ID
			FROM		ARTICLEDBSITES
		</CFQUERY>
		<CFSET FORM.DBSITEID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="DBSITEID" secure="NO" value="#FORM.DBSITEID#">
		<CFQUERY name="AddArticleDBSiteID" datasource="#application.type#WEBREPORTS">
			INSERT INTO	ARTICLEDBSITES (DBSITEID)
			VALUES		(#val(Cookie.DBSITEID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Article DB Site Key &nbsp; = &nbsp; #FORM.DBSITEID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processarticledbsites.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessArticleDBSite" value="CANCELADD" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="DBSITE" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processarticledbsites.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="DBSITENAME">*Article DB Site Name</LABEL></H4></TH>
			<TH align="left" valign ="bottom"><H4><LABEL for="DBSITEURL">*Article DB Site URL</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="DBSITENAME" id="DBSITENAME" value="" align="LEFT" required="No" size="75" maxlength="100" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="DBSITEURL" id="DBSITEURL" value="" align="LEFT" required="No" size="50" maxlength="255" tabindex="3"></TD>
		</TR>
		<TR>
			<TH align="left" valign ="bottom"><H4><LABEL for="DBDESCRIPTION">*Article DB Site Description</LABEL></H4></TH>
			<TH align="left" valign ="bottom"><H4><LABEL for="DBSUBJECTS">*Article DB Subject Category (Multiple Selections Allowed)</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<TEXTAREA name="DBDESCRIPTION" id="DBDESCRIPTION" wrap="PHYSICAL" REQUIRED="No" rows="11" cols="60" tabindex="4"> </TEXTAREA>
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="DBSUBJECTS" id="DBSUBJECTS" size="12" query="ListSubjectCategories" value="SUBJECTCATID" display="SUBJECTCATNAME" multiple="yes" selected ="" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
			<TD align="left">
				<COM>(Hold down the shift key when clicking for a range of subjects to be assigned.  
				Use control key and left mouse click (PC) or command key when clicking (Mac) on specific subjects to be assigned.</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="bottom"><H4><LABEL for="ALPHATITLEID">*Alpha Title</LABEL></H4></TH>
			<TH align="left"><LABEL for="GOODGENERALDB">Good General Database?</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
				<CFSELECT name="ALPHATITLEID" id="ALPHATITLEID" size="1" query="ListAlphaTitles" value="ALPHATITLEID" display="ALPHATITLE" required="No" tabindex="6"></CFSELECT>
			</TD>
			<TD align="left" valign="TOP">
				<CFSELECT name="GOODGENERALDB" id="GOODGENERALDB" size="1" tabindex="7">
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
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="DBSTATSREPORT" id="DBSTATSREPORT" size="1" tabindex="9">
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
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="USESLIBPROXY" id="USESLIBPROXY" size="1" tabindex="11">
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
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="DBSFXENABLED" id="DBSFXENABLED" size="1" tabindex="13">
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
					<OPTION value="NO">NO</OPTION>
					<OPTION value="YES">YES</OPTION>
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
				<TEXTAREA name="ADDITIONALCOMMENTS" id="ADDITIONALCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="15"> </TEXTAREA>
			</TD>
			<TD align="left">
				<TEXTAREA name="DBSFXCOMMENTS" id="DBSFXCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="16"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TD align="left"><INPUT type="submit" name="ProcessArticleDBSite" value="ADD" tabindex="17" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processarticledbsites.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="submit" name="ProcessArticleDBSite" value="CANCELADD" tabindex="18" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************
* The following code is the Look Up Process for Modifying Article DB Sites. *
*****************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify Information to Web Reports - Article DB Sites</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined('URL.LOOKUPDBSITEID')>
		<TR>
			<TH align="center">Article DB Site Key &nbsp; = &nbsp; #FORM.DBSITEID#</TH>
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPDBSITEID')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/webreports/articledbsites.cfm?PROCESS=#URL.PROCESS#&LOOKUPDBSITEID=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%"><H4><LABEL for="DBSITEID">*Article DB Site Name:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="DBSITEID" id="DBSITEID" size="1" query="ListArticleDBSites" value="DBSITEID" display="DBSITENAME" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" value="GO" tabindex="3" /></TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="submit" value="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
******************************************************************
* The following code is the Modify Process for Article DB Sites. *
******************************************************************
 --->

		<CFQUERY name="GetArticleDBSites" datasource="#application.type#WEBREPORTS">
			SELECT	DBSITEID, DBSITENAME, DBSITEURL, DBDESCRIPTION, DBACTIVE, DBPREFIXIMAGE, ARTICLESDBPAGE, USESLIBPROXY, DBSFXENABLED,
					DBSFXCOMMENTS, DBSUBJECTS, DBSTATSREPORT, ADDITIONALCOMMENTS, ALPHATITLEID, GOODGENERALDB, DBFULLTEXT
			FROM		ARTICLEDBSITES
			WHERE	DBSITEID = <CFQUERYPARAM value="#FORM.DBSITEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DBSITENAME
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/articledbsites.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessArticleDBSite" value="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="DBSITE" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processarticledbsites.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="DBSITEID" secure="NO" value="#FORM.DBSITEID#">
				<TH align="left"><H4<LABEL for="DBSITENAME">*Article DB Site Name</LABEL></H4></TH>
				<TH align="left" valign ="bottom"><H4><LABEL for="DBSITEURL">*Article DB Site URL</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="DBSITENAME" id="DBSITENAME" value="#GetArticleDBSites.DBSITENAME#" align="LEFT" required="No" size="75" maxlength="100" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="DBSITEURL" id="DBSITEURL" value="#GetArticleDBSites.DBSITEURL#" align="LEFT" required="No" size="50" maxlength="255" tabindex="3"></TD>
			</TR>
			<TR>
				<TH align="left" valign ="bottom"><H4><LABEL for="DBDESCRIPTION">*Article DB Site Description</LABEL></H4></TH>
				<TH align="left" valign ="bottom"><H4><LABEL for="DBSUBJECTS">*Article DB Subject Category (Multiple Selections Allowed)</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<TEXTAREA name="DBDESCRIPTION" id="DBDESCRIPTION" wrap="PHYSICAL" REQUIRED="No" rows="11" cols="60" tabindex="4">#GetArticleDBSites.DBDESCRIPTION#</TEXTAREA>
				</TD>
				<TD align="left" valign ="TOP">
					<CFSELECT name="DBSUBJECTS" id="DBSUBJECTS" size="12" multiple="yes" required="No" tabindex="5">
						<CFLOOP query="ListSubjectCategories">
							<CFIF #LISTFIND(GetArticleDBSites.DBSUBJECTS, '#ListSubjectCategories.SUBJECTCATID#')# NEQ 0>
								<OPTION selected value="#ListSubjectCategories.SUBJECTCATID#">#ListSubjectCategories.SUBJECTCATNAME#</OPTION>
							<CFELSE>
								<OPTION value="#ListSubjectCategories.SUBJECTCATID#">#ListSubjectCategories.SUBJECTCATNAME#</OPTION>
							</CFIF>
						</CFLOOP>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
				<TD align="left">
					<COM>(Hold down the shift key when clicking for a range of subjects to be assigned.  
					Use control key and left mouse click (PC) or command key when clicking (Mac) on specific subjects to be assigned.  
					If you click the mouse in the box WITHOUT holding down either the shift or control key, all the selections will be removed.  
					Click the cancel button and select the record again to start over.)</COM>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="bottom"><H4><LABEL for="ALPHATITLEID">*Alpha Title</LABEL></H4></TH>
				<TH align="left"><LABEL for="GOODGENERALDB">Good General Database?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="ALPHATITLEID" id="ALPHATITLEID" size="1" query="ListAlphaTitles" value="ALPHATITLEID" display="ALPHATITLE" selected="#GetArticleDBSites.ALPHATITLEID#" required="No" tabindex="6"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSELECT name="GOODGENERALDB" id="GOODGENERALDB" size="1" tabindex="7">
						<OPTION selected value="#GetArticleDBSites.GOODGENERALDB#">#GetArticleDBSites.GOODGENERALDB#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign ="bottom"><LABEL for="DBACTIVE">Article DB Active?</LABEL></TH>
				<TH align="left"><LABEL for="DBSTATSREPORT">Select for Article DB Stats Report?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign ="TOP">
					<CFSELECT name="DBACTIVE" id="DBACTIVE" size="1" tabindex="8">
						<OPTION selected value="#GetArticleDBSites.DBACTIVE#">#GetArticleDBSites.DBACTIVE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="DBSTATSREPORT" id="DBSTATSREPORT" size="1" tabindex="9">
						<OPTION selected value="#GetArticleDBSites.DBSTATSREPORT#">#GetArticleDBSites.DBSTATSREPORT#</OPTION>
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
						<OPTION selected value="#GetArticleDBSites.ARTICLESDBPAGE#">#GetArticleDBSites.ARTICLESDBPAGE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="USESLIBPROXY" id="USESLIBPROXY" size="1" tabindex="11">
						<OPTION selected value="#GetArticleDBSites.USESLIBPROXY#">#GetArticleDBSites.USESLIBPROXY#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="DBPREFIXIMAGE">Article DB Prefix Image Displayed?</LABEL></TH>
				<TH align="left" valign ="bottom"><LABEL for="DBSFXENABLED">Article DB SFX Enabled?</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="DBPREFIXIMAGE" id="DBPREFIXIMAGE" size="1" tabindex="12">
						<OPTION selected value="#GetArticleDBSites.DBPREFIXIMAGE#">#GetArticleDBSites.DBPREFIXIMAGE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="DBSFXENABLED" id="DBSFXENABLED" size="1" tabindex="13">
						<OPTION selected value="#GetArticleDBSites.DBSFXENABLED#">#GetArticleDBSites.DBSFXENABLED#</OPTION>
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
						<OPTION selected value="#GetArticleDBSites.DBFULLTEXT#">#GetArticleDBSites.DBFULLTEXT#</OPTION>
						<OPTION value="NO">NO</OPTION>
						<OPTION value="YES">YES</OPTION>
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
					<TEXTAREA name="ADDITIONALCOMMENTS" id="ADDITIONALCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="15">#GetArticleDBSites.ADDITIONALCOMMENTS#</TEXTAREA>
				</TD>
				<TD align="left">
					<TEXTAREA name="DBSFXCOMMENTS" id="DBSFXCOMMENTS" wrap="PHYSICAL" REQUIRED="No" rows="5" cols="60" tabindex="16">#GetArticleDBSites.DBSFXCOMMENTS#</TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TD align="left"><INPUT type="submit" name="ProcessArticleDBSite" value="MODIFY" tabindex="17" /></TD>
			</TR>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/articledbsites.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="submit" name="ProcessArticleDBSite" value="Cancel" tabindex="18" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>