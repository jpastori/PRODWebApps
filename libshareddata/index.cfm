<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/23/2011 --->
<!--- Date in Production: 06/23/2011 --->
<!--- Module: Shared Data Application Home Page--->
<!-- Last modified by John R. Pastori on 06/23/2011 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/libshareddata/index.cfm">
<CFSET CONTENT_UPDATED = "June 23, 2011">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Shared Data Application</TITLE>
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
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/libshareddata">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "NO">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "YES">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="AGERANGEID" secure="NO" expires="NOW">
<CFCOOKIE name="CAMPMAILCODEID" secure="NO" expires="NOW">
<CFCOOKIE name="CATID" secure="NO" expires="NOW">
<CFCOOKIE name="CUSTID" secure="NO" expires="NOW">
<CFCOOKIE name="DAYID" secure="NO" expires="NOW">
<CFCOOKIE name="DAYSOFWEEKID" secure="NO" expires="NOW">
<CFCOOKIE name="DEPTID" secure="NO" expires="NOW">
<CFCOOKIE name="FISCALYEARID" secure="NO" expires="NOW">
<CFCOOKIE name="GENDERID" secure="NO" expires="NOW">
<CFCOOKIE name="GROUPID" secure="NO" expires="NOW">
<CFCOOKIE name="HOURSID" secure="NO" expires="NOW">
<CFCOOKIE name="MONTHID" secure="NO" expires="NOW">
<CFCOOKIE name="SEMID" secure="NO" expires="NOW">
<CFCOOKIE name="STATEID" secure="NO" expires="NOW">
<CFCOOKIE name="UNITID" secure="NO" expires="NOW">
<CFCOOKIE name="YEAR" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center"><H1>Shared Data Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			CUSTOMER PROCESSING
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			CUSTOMER REPORTS
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Customer - <A href="/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/customerinfo.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
			Customer Categories - <A href="/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/customercategories.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A>
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libshareddata/shareddatadbreports.cfm">Customer Lookup Reports</A><BR /><BR />
			<A href="/#application.type#apps/libshareddata/custcatdbreport.cfm">Customer Categories</A>
		</TD>
	</TR>

	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">
			DEPARTMENT PROCESSING
		</TH>
		<TH align="LEFT" valign="top">
			DEPARTMENT REPORTS
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Age Ranges - <A href="/#application.type#apps/libshareddata/ageranges.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/ageranges.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Alpha Titles - <A href="/#application.type#apps/libshareddata/alphatitles.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/alphatitles.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Campus Mail Codes - <A href="/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=Add">Add</A> or 
			<A href="/#application.type#apps/libshareddata/campusmailcodes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Departments - <A href="/#application.type#apps/libshareddata/departments.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/departments.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Gender - <A href="/#application.type#apps/libshareddata/gender.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/gender.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Groups - <A href="/#application.type#apps/libshareddata/groups.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/groups.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Owning Org Codes - <A href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/orgcodes.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			States - <A href="/#application.type#apps/libshareddata/states.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/states.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Units - <A href="/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/unitsinfo.cfm?PROCESS=MODIFY">Modify</A>
		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libshareddata/agerangesdbreport.cfm">Age Ranges</A><BR />
			<A href="/#application.type#apps/libshareddata/alphatitlesdbreport.cfm">Alpha Titles</A><BR />
			<A href="/#application.type#apps/libshareddata/campusmailcodesdbreport.cfm">Campus Mail Codes</A><BR />
			<A href="/#application.type#apps/libshareddata/departmentsdbreport.cfm">Departments</A><BR />
			<A href="/#application.type#apps/libshareddata/genderdbreport.cfm">Gender</A><BR />
			<A href="/#application.type#apps/libshareddata/groupsdbreport.cfm">Groups</A><BR />
			<A href="/#application.type#apps/libshareddata/orgcodesdbreport.cfm">Owning Org Codes</A><BR />
			<A href="/#application.type#apps/libshareddata/statesdbreport.cfm">States</A><BR />
			<A href="/#application.type#apps/libshareddata/unitsdbreport.cfm">Units</A>
		</TD>
	</TR>

	<TR>
		<TH align="LEFT" valign="top">
			DATE and TIME PROCESSING
		</TH>
		<TH align="LEFT" valign="top">
			DATE and TIME REPORTS
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Hours - <A href="/#application.type#apps/libshareddata/hours.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/hours.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Days - <A href="/#application.type#apps/libshareddata/days.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/days.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Days Of The Week - <A href="/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/daysofweek.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Months - <A href="/#application.type#apps/libshareddata/months.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/months.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Semesters - <A href="/#application.type#apps/libshareddata/semesters.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/semesters.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			Years - <A href="/#application.type#apps/libshareddata/years.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/years.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR /><BR />
			Fiscal/Academic Years - <A href="/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/libshareddata/fiscalyears.cfm?PROCESS=MODIFYDELETE">Modify/Delete</A><BR />
			<A href="/#application.type#apps/libshareddata/setcurrentfiscalyear.cfm?YEARTYPE=ACADEMIC">Set Current </A>Academic Year<BR />
			<A href="/#application.type#apps/libshareddata/setcurrentfiscalyear.cfm?YEARTYPE=FISCAL">Set Current </A>Fiscal Year
		</TD>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/libshareddata/hoursdbreport.cfm">Hours</A><BR />
			<A href="/#application.type#apps/libshareddata/daysdbreport.cfm">Days</A><BR />
			<A href="/#application.type#apps/libshareddata/daysofweekdbreport.cfm">Days Of The Week</A><BR />
			<A href="/#application.type#apps/libshareddata/monthsdbreport.cfm">Months</A><BR />
			<A href="/#application.type#apps/libshareddata/semestersdbreport.cfm">Semesters</A><BR />
			<A href="/#application.type#apps/libshareddata/yearsdbreport.cfm">Years</A><BR /><BR />
			<A href="/#application.type#apps/libshareddata/fiscalyearsdbreport.cfm">Fiscal/Academic Years</A><BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>