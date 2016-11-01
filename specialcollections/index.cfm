<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/30/2012 --->
<!--- Date in Production: 07/30/2012 --->
<!--- Module: Special Collections Application Home Page--->
<!-- Last modified by John R. Pastori on 07/30/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/specialcollections/index.cfm">
<CFSET CONTENT_UPDATED = "July 30, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Special Collections Application</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<SCRIPT language="JavaScript">
		<!--
			if (window.history.forward(1) != null) {
				window.history.forward(1); 
			}

		//-->
	</SCRIPT>

</HEAD>

<BODY>

<CFOUTPUT>
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/specialcollections">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "YES">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="ASSISTANTID" secure="NO" expires="NOW">
<CFCOOKIE name="COLLECTIONID" secure="NO" expires="NOW">
<CFCOOKIE name="IDTYPEID" secure="NO" expires="NOW">
<CFCOOKIE name="RESEARCHERID" secure="NO" expires="NOW">
<CFCOOKIE name="RVID" secure="NO" expires="NOW">
<CFCOOKIE name="SERVICESID" secure="NO" expires="NOW">
<CFCOOKIE name="STATUSID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center" valign="middle"><H1>Special Collections Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			<H3>RESEARCHERS PROCESSING</H3>
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			<H3>RESEARCHERS REPORTS</H3>
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Researcher Information - <A href="/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/researcherinfo.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR /><BR><BR>
			Material Requests & Duplications - <A href="/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/matrlreqsdups.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			Researcher Information <A href="/#application.type#apps/specialcollections/researcherinfocountrpts.cfm"> Count</A> Reports<BR />
			Researcher Information <A href="/#application.type#apps/specialcollections/researcherinfodbreports.cfm"> Detail</A> Reports<BR /><BR>
			Material Requests & Duplications <A href="/#application.type#apps/specialcollections/matrlreqsdupscountrpts.cfm"> Count</A> Reports<BR />
			Material Requests & Duplications <A href="/#application.type#apps/specialcollections/matrlreqsdupsdbreports.cfm"> Detail</A> Reports<BR />
		</TD>
	</TR>
     
     <TR>
		<TH align="LEFT" valign="top">
			<H3>Web Presentation Process</H3>
		</TH>
		<TH align="LEFT" valign="top">&nbsp;&nbsp;</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Pachyderm2 - <A href="https://pachyderm.lib.sdsu.edu:8443/Pachyderm21/WebObjects/Pachyderm2.woa/-1">Production</A><BR /><BR />
		</TD>
		<TD align="LEFT" valign="top">&nbsp;&nbsp;</TD>
	</TR>

	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">
			<H3>SUPPORT FILES PROCESSING</H3>
		</TH>
		<TH align="LEFT" valign="top">
			<H3>SUPPORT FILES REPORTS</H3>
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Assistants - <A href="/#application.type#apps/specialcollections/assistants.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/assistants.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Collections - <A href="/#application.type#apps/specialcollections/collections.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/specialcollections/collections.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			ID Types - <A href="/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/idtypes.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Services - <A href="/#application.type#apps/specialcollections/services.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/services.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Status -  <A href="/#application.type#apps/specialcollections/status.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/specialcollections/status.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/specialcollections/assistantsdbreport.cfm"> Assistants</A><BR />
			<A href="/#application.type#apps/specialcollections/collectionsdbreport.cfm"> Collections</A><BR />
			<A href="/#application.type#apps/specialcollections/idtypesdbreport.cfm"> ID Types</A><BR />
			<A href="/#application.type#apps/specialcollections/servicesdbreport.cfm"> Services</A><BR />
			<A href="/#application.type#apps/specialcollections/statusdbreport.cfm"> Status</A><BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>