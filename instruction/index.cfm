<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: index.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date in Production: 07/05/2012 --->
<!--- Module: Instruction Application Home Page--->
<!-- Last modified by John R. Pastori on 07/05/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/index.cfm">
<CFSET CONTENT_UPDATED = "July 05, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Instruction Application</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

	<SCRIPT language="JavaScript">
		if (window.history.forward(1) != null) {
			window.history.forward(1); 
		}

		//
	</SCRIPT>

</HEAD>

<BODY>
<CFOUTPUT>
<CFCOOKIE name="INDEXDIR" secure="NO" value="/#application.type#apps/instruction">

<!--- APPLICATION ACCESS VARIABLES --->
<CFSET URL.ACCESSINGAPPFIRSTTIME = "NO">
<CFSET Client.ACCESSINGCONFIGMGMT = "NO">
<CFSET Client.ACCESSINGFACILITIES = "NO">
<CFSET Client.ACCESSINGHARDWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGIDTCHATTER = "NO">
<CFSET Client.ACCESSINGINSTRUCTION = "YES">
<CFSET Client.ACCESSINGLIBQUAL = "NO">
<CFSET Client.ACCESSINGLIBSECURITY = "NO">
<CFSET Client.ACCESSINGLIBSHAREDDATA = "NO">
<CFSET Client.ACCESSINGLIBSTATS = "NO">
<CFSET Client.ACCESSINGPURCHASING = "NO">
<CFSET Client.ACCESSINGSERVICEREQUESTS = "NO">
<CFSET Client.ACCESSINGSOFTWAREINVENTORY = "NO">
<CFSET Client.ACCESSINGSPECIALCOLLECTIONS = "NO">
<CFSET Client.ACCESSINGWEBREPORTS = "NO">

<CFSET SESSION.ORIGINSERVER = "">
<CFSET SESSION.RETURNPGM = "">

<CFINCLUDE template="/include/coldfusion/header.cfm">

<!--- SET COOKIE VARIABLES --->
<CFCOOKIE name="CATEGORYID" secure="NO" expires="NOW">
<CFCOOKIE name="DEPARTMENTID" secure="NO" expires="NOW">
<CFCOOKIE name="ORIENTSTATUSID" secure="NO" expires="NOW">
<CFCOOKIE name="PRESENTLENGTHID" secure="NO" expires="NOW">
<CFCOOKIE name="ROOMID" secure="NO" expires="NOW">
<CFCOOKIE name="STATUSID" secure="NO" expires="NOW">

<TABLE width="100%" border="5" cellspacing="0" cellpadding="0" align="center">
	<TR>
		<TD align="center" valign="middle"><H1>Instruction Application</H1></TD>
	</TR>
</TABLE>
<TABLE border="0" width="100%" cellspacing="0" cellpadding="4">
	<CFINCLUDE template="../LibraryApplicationLinks.cfm">

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			ORIENTATION PROCESSING
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			ORIENTATION REPORTS
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Statistics - <A href="/#application.type#apps/instruction/orientstats.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/orientstats.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			Statistics <A href="/#application.type#apps/instruction/orientstatscountrpts.cfm"> Count </A> and 
			<A href="/#application.type#apps/instruction/orientstatsdbreport.cfm"> Instructor </A> Reports<BR />
			Statistics <A href="/#application.type#apps/instruction/instructiondeptrpts.cfm"> Departmental Lookup </A> Reports<BR /><BR />
			Departments with <A href="/#application.type#apps/instruction/nostatdeptsreport.cfm"> No Statistics </A> Report<BR />
			Departments with <A href="/#application.type#apps/instruction/hasstatdeptsreport.cfm"> Statistics </A> Report<BR />
		</TD>
	</TR>
	<TR>
		<TH align="LEFT" valign="top">
			TUTORIAL PROCESSES
		</TH>
		<TH align="LEFT" valign="top">
			MULTIMEDIA
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			<A href="http://infotutor.sdsu.edu/plagiarism/index.cfm?LINK=lfolks" target="_blank"> Plagiarism </A>Tutorial<BR />
			<!--- <A href="/#application.type#apps/instruction/plagiarism/index.cfm"> Plagiarism </A>Tutorial<BR /> --->
			Plagiarism Student Registration - <A href="/#application.type#apps/instruction/plagiarism/registration.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR /><BR />
			PreQuiz/Quiz Questions - <A href="/#application.type#apps/instruction/quizquestions.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/quizquestions.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Tutorial Names -  <A href="/#application.type#apps/instruction/tutorialnames.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/tutorialnames.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			<A href="/#application.type#apps/instruction/tutorialnamesdbreport.cfm"> Tutorial Names</A> Report<BR />
			Tutorial Pages -  <A href="/#application.type#apps/instruction/tutorialpages.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/tutorialpages.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>
		<TD align="LEFT" valign="top">
			New<A href="/#application.type#apps/instruction/multimedia/ipodprocesses/index.html"> Research </A>Tutor<BR />
			Where is<A href="/#application.type#apps/instruction/multimedia/lib3dmap/index.html"> 3D</A>?<BR />
			iPod<A href="/#application.type#apps/instruction/multimedia/ipodprocesses/iPod_Viewer.html"> Viewer</A><BR />
			IIR Tutorial<A href="http://thorin.sdsu.edu:85/IIRTutor/index.php"> Builder</A><BR />
			Old<A href="http://infotutor.sdsu.edu/icdev/htdocs/index.html"> Research </A>Tutorial<BR />
			Old Research Tutorial <A href="http://infotutor.sdsu.edu/icdev/htdocs/instructor.html">Instructor Review</A><BR />
		</TD>
	</TR>
	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TH align="LEFT" valign="top">
			WORKSHOP SCHEDULER PROCESSING
		</TH>
	</CFIF>
		<TH align="LEFT" valign="top">
			WORKSHOP SCHEDULER REPORTS
		</TH>
	</TR>

	<TR>
	<CFIF #Client.ProcessFlag# EQ "Yes">
		<TD align="LEFT" valign="top">
			Participant - <A href="/#application.type#apps/instruction/participants.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/participants.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR /><BR />
			Test Registration - <A href="/#application.type#apps/instruction/registration.cfm?PROCESS=ADD&TYPE=TEST"> Add</A><BR />
			Workshop Registration - <A href="/#application.type#apps/instruction/registration.cfm?PROCESS=ADD&TYPE=WORKSHOP"> Add</A><BR /><BR /><BR />
			Sessions Single Record - <A href="/#application.type#apps/instruction/sessions.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/sessions.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Sessions Multiple Record - <A href="/#application.type#apps/instruction/sessions.cfm?PROCESS=ADDLOOP"> Add Loop</A> or
			<A href="/#application.type#apps/instruction/sessions.cfm?PROCESS=MODIFYLOOP"> Modify Loop</A><BR /><BR /><BR />
			Workshops - <A href="/#application.type#apps/instruction/workshops.cfm?PROCESS=ADD"> Add</A> or
			<A href="/#application.type#apps/instruction/workshops.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>
	</CFIF>
		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/instruction/participantsdbreport.cfm"> Participants</A> Lookup Report<BR /><BR />
			Participant Registration <A href="/#application.type#apps/instruction/partregbydatereport.cfm"> By Date </A> Report<BR />
			Participant Registration <A href="/#application.type#apps/instruction/partregbytitlereport.cfm"> By Title </A> Report<BR />
			Registration<!--- <a href="/#application.type#apps/instruction/registrationdbreport.cfm"> ---> Lookup Report<BR /><BR />
			Sessions <A href="/#application.type#apps/instruction/sessionsbydatereport.cfm"> By Date </A> Report<BR />
			Sessions <A href="/#application.type#apps/instruction/sessionsbytitlereport.cfm"> By Title </A> Report<BR />
			<A href="/#application.type#apps/instruction/sessionsdbreport.cfm"> Sessions</A> Lookup Report<BR /><BR />
			<A href="/#application.type#apps/instruction/workshopsdbreport.cfm"> Workshops</A> Lookup Report<BR />
		</TD>
	</TR>
	<CFIF #Client.SecurityFlag# EQ "Yes" OR #Client.MaintFlag# EQ "Yes">
	<TR>
		<TH align="LEFT" valign="top">
			SUPPORT FILES PROCESSING
		</TH>
		<TH align="LEFT" valign="top">
			SUPPORT FILES REPORTS
		</TH>
	</TR>

	<TR>
		<TD align="LEFT" valign="top">
			Affiliation - <A href="/#application.type#apps/instruction/affiliation.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/affiliation.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Category - <A href="/#application.type#apps/instruction/category.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/category.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Department - <A href="/#application.type#apps/instruction/department.cfm?PROCESS=Add">Add</A> or
			<A href="/#application.type#apps/instruction/department.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Marketing - <A href="/#application.type#apps/instruction/marketing.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/marketing.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Presentation Length - <A href="/#application.type#apps/instruction/presentlength.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/presentlength.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Professor - <A href="/#application.type#apps/instruction/professor.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/professor.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Registration Acceptance Type - <A href="/#application.type#apps/instruction/regaccept.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/regaccept.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Rooms - <A href="/#application.type#apps/instruction/rooms.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/rooms.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			SDSU Courses -  <A href="/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/sdsucourses.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
			Status -  <A href="/#application.type#apps/instruction/status.cfm?PROCESS=Add"> Add</A> or
			<A href="/#application.type#apps/instruction/status.cfm?PROCESS=MODIFYDELETE"> Modify/Delete</A><BR />
		</TD>

		<TD align="LEFT" valign="top">
			<A href="/#application.type#apps/instruction/affiliationdbreport.cfm"> Affiliation</A><BR />
			<A href="/#application.type#apps/instruction/categorydbreport.cfm"> Category</A><BR />
			<A href="/#application.type#apps/instruction/departmentdbreport.cfm"> Department</A><BR />
			<A href="/#application.type#apps/instruction/marketingdbreport.cfm"> Marketing</A><BR />
			<A href="/#application.type#apps/instruction/presentlengthdbreport.cfm"> Presentation Length</A><BR />
			<A href="/#application.type#apps/instruction/professordbreport.cfm"> Professor</A><BR />
			<A href="/#application.type#apps/instruction/regacceptdbreport.cfm"> Registration Acceptance Type</A><BR />
			<A href="/#application.type#apps/instruction/roomsdbreport.cfm"> Rooms</A><BR />
			<A href="/#application.type#apps/instruction/sdsucoursesdbreport.cfm"> SDSU Courses</A><BR />
			<A href="/#application.type#apps/instruction/statusdbreport.cfm"> Status</A><BR />
		</TD>
	</TR>
	</CFIF>

	<CFINCLUDE template="../IDTApplicationLinks.cfm">

</TABLE>

<CFINCLUDE template="/include/coldfusion/footer.cfm">
</CFOUTPUT>

</BODY>
</HTML>