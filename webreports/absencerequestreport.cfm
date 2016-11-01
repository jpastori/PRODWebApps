<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: absencerequestreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/25/2012 --->
<!--- Date in Production: 07/25/2012 --->
<!--- Module: Process Information to Web Reports - Absence Request Form Report --->
<!--- Last modified by John R. Pastori on 08/29/2016 using ColdFusion Studio. --->

<html>
<head>
	<title>Process Information to Web Reports - Absence Request Report</title>
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
</head>

<body>

<cfoutput>

<!--- 
**********************************************************************************************************
* The following code is the Report Generation Process for the Web Reports - Absence Request Form Report. *
**********************************************************************************************************
 --->

<!--- 
<CFIF (IsDefined('FORM.PROCESSABSENCEREQUESTS')) AND (FORM.PROCESSABSENCEREQUESTS EQ "ADD" OR FORM.PROCESSABSENCEREQUESTS EQ "MODIFY")>
	<STRONG>Note to Supervisors</STRONG>: &nbsp;&nbsp;Go to the <A href="https://lfolks.sdsu.edu/PRODapps/index.cfm" title="Production Applications">Production Apps Login Page</A> to approve this request.<BR /><BR /><BR />
</CFIF>
 --->
 
<h3>On #DateFormat(LookupAbsenceRequests.SUBMITDATE, 'mmmm dd, yyyy')#, #LookupAbsenceRequests.FULLNAME# submitted the following Absence Request </h3><br><br>

<cfif ((IsDefined('FORM.PROCESSABSENCEREQUESTS') AND FORM.PROCESSABSENCEREQUESTS EQ "ADD") AND (#SESSION.ORIGINSERVER# NEQ "LFOLKSWIKI" AND #SESSION.ORIGINSERVER# NEQ "FORMS"))>
     <table border="0" width="100%">
          <tr>
               <td align="LEFT">&nbsp;&nbsp;</td>
          </tr>
          <tr>
     <cfform action="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=#FORM.PROCESSABSENCEREQUESTS#" method="POST">
               <td align="left">
                    <input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><br />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </td>
     </cfform>
          </tr>
          <tr>
               <td align="LEFT">&nbsp;&nbsp;</td>
          </tr>
     </table>
</cfif>

<cfif LookupAbsenceRequests.SUPAPPROVALDATE NEQ "">
	<div align="center"><h4>Your Request was #LookupAbsenceRequests.REQUESTSTATUSNAME# on #DateFormat(LookupAbsenceRequests.SUPAPPROVALDATE, 'mm/dd/yyyy')# by #LookupAbsenceRequests.SUPVRNAME#</h4></div>
</cfif>
<!---  Email Message Body is here --->
<center><h1>Online Absence Request Receipt</h1></center>
<br />
<fieldset>
<legend>Customer Info</legend>
Date Submitted:      #DateFormat(LookupAbsenceRequests.SUBMITDATE, 'mm/dd/yyyy')#<br />

<b>Name:</b>                #LookupAbsenceRequests.FULLNAME#<br />

<b>Email Address:</b>       #LookupAbsenceRequests.REQEMAIL#<br />

<b>Supervisor's Email:</b>  #LookupAbsenceRequests.SUPVREMAIL#<br />

<cfif #LookupAbsenceRequests.SUPERVISOREMAILID# EQ 57>
	<cfif #LookupAbsenceRequests.CARBON# NEQ "" AND #LookupAbsenceRequests.CC2# NEQ "">				
<b>CC:</b>  eescobar@rohan.sdsu.edu, #LookupAbsenceRequests.REQEMAIL#, #LookupAbsenceRequests.CC2#
	<cfelseif #LookupAbsenceRequests.CARBON# NEQ "" AND #LookupAbsenceRequests.CC2# EQ "">
<b>CC:</b>  eescobar@rohan.sdsu.edu, #LookupAbsenceRequests.REQEMAIL#
	<cfelseif #LookupAbsenceRequests.CARBON# EQ "" AND #LookupAbsenceRequests.CC2# NEQ "">
<b>CC:</b>  eescobar@rohan.sdsu.edu, #LookupAbsenceRequests.CC2#
	<cfelseif #LookupAbsenceRequests.CARBON# EQ "" AND #LookupAbsenceRequests.CC2# EQ "">
<b>CC:</b>  eescobar@rohan.sdsu.edu
	</cfif>
<cfelse>
	<cfif #LookupAbsenceRequests.CARBON# NEQ "" AND #LookupAbsenceRequests.CC2# NEQ "">				
<b>CC:</b>  #LookupAbsenceRequests.REQEMAIL#, #LookupAbsenceRequests.CC2#
	<cfelseif #LookupAbsenceRequests.CARBON# NEQ "" AND #LookupAbsenceRequests.CC2# EQ "">
<b>CC:</b>  #LookupAbsenceRequests.REQEMAIL#
	<cfelseif #LookupAbsenceRequests.CARBON# EQ "" AND #LookupAbsenceRequests.CC2# NEQ "">
<b>CC:</b>  #LookupAbsenceRequests.CC2#
	</cfif>
</cfif>

</fieldset>
<br /><br />
<fieldset>
<legend>Request Detail</legend>
<table border="1">
	<tr>
		<th align="CENTER"><b>Date(s) Requested</b>
		</th><th align="CENTER"><b>## Of Hours</b> 
		</th><th align="CENTER"><b>Begin Time - End Time Range</b></th>
		<th align="CENTER"><b>Day of Week From - Day of Week To</b></th>
	</tr>

	<cfquery name="ListDaysOfWeek1" datasource="#application.type#LIBSHAREDDATA">
		SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
		FROM		DAYSOFWEEK
		WHERE 	DAYSOFWEEKID = <CFQUERYPARAM value="#LookupAbsenceRequests.DAYS1ID#" cfsqltype="CF_SQL_NUMERIC">
		ORDER BY	DAYSOFWEEKID
	</cfquery>

	<tr>
		<td align="LEFT">
			#DateFormat(LookupAbsenceRequests.BEGINDATE1, "mm/dd/yyyy")# 
		<cfif #LookupAbsenceRequests.ENDDATE1# GT '31-DEC-1899'>
			- #DateFormat(LookupAbsenceRequests.ENDDATE1, "mm/dd/yyyy")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="CENTER">#LookupAbsenceRequests.HOURS1#</td>
		<td align="CENTER">
		<cfif #LookupAbsenceRequests.BEGINTIME1# NEQ "">
			#TimeFormat(LookupAbsenceRequests.BEGINTIME1, "HH:mm")# - #TimeFormat(LookupAbsenceRequests.ENDTIME1, "HH:mm")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="LEFT">
		<cfif #LookupAbsenceRequests.DAYS1ID# GT 0>
			#ListDaysOfWeek1.DAYSOFWEEKNAME#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
	</tr>
	<cfif #LookupAbsenceRequests.BEGINDATE2# GT '31-DEC-1899'>

		<cfquery name="ListDaysOfWeek2" datasource="#application.type#LIBSHAREDDATA">
			SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
			FROM		DAYSOFWEEK
			WHERE 	DAYSOFWEEKID = <CFQUERYPARAM value="#LookupAbsenceRequests.DAYS2ID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DAYSOFWEEKID
		</cfquery>

	<tr>
		<td align="LEFT">
			#DateFormat(LookupAbsenceRequests.BEGINDATE2, "mm/dd/yyyy")# 
		<cfif #LookupAbsenceRequests.ENDDATE2# GT '31-DEC-1899'>
			- #DateFormat(LookupAbsenceRequests.ENDDATE2, "mm/dd/yyyy")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="CENTER">#LookupAbsenceRequests.HOURS2#</td>
		<td align="CENTER">
		<cfif #LookupAbsenceRequests.BEGINTIME2# NEQ "">
			#TimeFormat(LookupAbsenceRequests.BEGINTIME2, "HH:mm")# - #TimeFormat(LookupAbsenceRequests.ENDTIME2, "HH:mm")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="LEFT">
		<cfif #LookupAbsenceRequests.DAYS2ID# GT 0>
			#ListDaysOfWeek2.DAYSOFWEEKNAME#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
	</tr>
	</cfif>
	<cfif #LookupAbsenceRequests.BEGINDATE3# GT '31-DEC-1899'>

		<cfquery name="ListDaysOfWeek3" datasource="#application.type#LIBSHAREDDATA">
			SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
			FROM		DAYSOFWEEK
			WHERE 	DAYSOFWEEKID = <CFQUERYPARAM value="#LookupAbsenceRequests.DAYS3ID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DAYSOFWEEKID
		</cfquery>

	<tr>
		<td align="LEFT">
			#DateFormat(LookupAbsenceRequests.BEGINDATE3, "mm/dd/yyyy")# 
		<cfif #LookupAbsenceRequests.ENDDATE3# GT '31-DEC-1899'>
			- #DateFormat(LookupAbsenceRequests.ENDDATE3, "mm/dd/yyyy")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="CENTER">#LookupAbsenceRequests.HOURS3#</td>
		<td align="CENTER">
		<cfif #LookupAbsenceRequests.BEGINTIME3# NEQ "">
			#TimeFormat(LookupAbsenceRequests.BEGINTIME3, "HH:mm")# - #TimeFormat(LookupAbsenceRequests.ENDTIME3, "HH:mm")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="LEFT">
		<cfif #LookupAbsenceRequests.DAYS3ID# GT 0>
			#ListDaysOfWeek3.DAYSOFWEEKNAME#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
	</tr>
	</cfif>
	<cfif #LookupAbsenceRequests.BEGINDATE4# GT '31-DEC-1899'>

		<cfquery name="ListDaysOfWeek4" datasource="#application.type#LIBSHAREDDATA">
			SELECT	DAYSOFWEEKID, DAYSOFWEEKNAME
			FROM		DAYSOFWEEK
			WHERE 	DAYSOFWEEKID = <CFQUERYPARAM value="#LookupAbsenceRequests.DAYS4ID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	DAYSOFWEEKID
		</cfquery>

	<tr>
		<td align="LEFT">
			#DateFormat(LookupAbsenceRequests.BEGINDATE4, "mm/dd/yyyy")# 
		<cfif #LookupAbsenceRequests.ENDDATE4# GT '31-DEC-1899'>
			- #DateFormat(LookupAbsenceRequests.ENDDATE4, "mm/dd/yyyy")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="CENTER">#LookupAbsenceRequests.HOURS4#</td>
		<td align="CENTER">
		<cfif #LookupAbsenceRequests.BEGINTIME4# NEQ "">
			#TimeFormat(LookupAbsenceRequests.BEGINTIME4, "HH:mm")# - #TimeFormat(LookupAbsenceRequests.ENDTIME4, "HH:mm")#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
		<td align="LEFT">
		<cfif #LookupAbsenceRequests.DAYS4ID# GT 0>
			#ListDaysOfWeek4.DAYSOFWEEKNAME#
		<cfelse>
			&nbsp;&nbsp;
		</cfif>
		</td>
	</tr>
	</cfif>
</table>
</fieldset>
<br /><br />
<fieldset>
<legend>Request Use Of Hours for Absence Type</legend>

<!---  Second table for hours use --->

<b>REQUEST USE OF: (fill in ## hours)</b><br />

	<cfif #LookupAbsenceRequests.VACATION# GT 0>
		<b>Vacation</b>                     #LookupAbsenceRequests.VACATION#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.PERSONALHOLIDAY# GT 0>
		<b>Personal Holiday</b>             #LookupAbsenceRequests.PERSONALHOLIDAY# <br />
	</cfif>

	<cfif #LookupAbsenceRequests.COMPTIME# GT 0>
		<b>Compensatory Time Off</b>        #LookupAbsenceRequests.COMPTIME# <br />
	</cfif>

	<cfif #LookupAbsenceRequests.FMLA# GT 0>
		<b>Family Medical Leave Act</b>     #LookupAbsenceRequests.FMLA#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.FUNERAL# GT 0>
		<b>Funeral Leave*</b>               #LookupAbsenceRequests.FUNERAL#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.OTHER# GT 0>
		<b>Other</b>                        #LookupAbsenceRequests.OTHER#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.GTO# GT 0>
		<b>Holiday Informal Time - GTO</b>  #LookupAbsenceRequests.GTO#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.JURYDUTY# GT 0>
		<b>Jury Duty</b>                    #LookupAbsenceRequests.JURYDUTY#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.LWOP# GT 0>
		<b>LWOP</b>                         #LookupAbsenceRequests.LWOP#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.MATPAT# GT 0>
		<b>Maternity/Paternity Leave</b>    #LookupAbsenceRequests.MATPAT#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.MILITARY# GT 0>
		<b>Military Leave</b>               #LookupAbsenceRequests.MILITARY#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.SICKFAMILY# GT 0>
		<b>Sick Leave Family*</b>           #LookupAbsenceRequests.SICKFAMILY#<br />
	</cfif>

	<cfif #LookupAbsenceRequests.SICKSELF# GT 0>
		<b>Sick Leave Self</b>              #LookupAbsenceRequests.SICKSELF# <br />
	</cfif>

	<cfif #LookupAbsenceRequests.WITNESS# GT 0>
		<b>Sick Leave Death*</b>            #LookupAbsenceRequests.WITNESS# <br />
	</cfif>
	
</fieldset>
<br /><br />
<fieldset>
<legend>Explanations</legend>
	<p><b>*Give Relationship)</b>
		<br />#LookupAbsenceRequests.RELATIONSHIP# </p><br />

	<p><b>REASON FOR ABSENCE (Sick Leave / LWOP )</b>
		<br />#LookupAbsenceRequests.REASON#</p>

</fieldset>
<br /><br /><br />
<hr />
	<p>This electronic request has been submitted to your
	Supervisor via email.</p>

	<p>Supervisors are to forward their approval/denial of all requests for
	<b>vacation, personal holiday, CTO, or any other use of accruals
	requiring scheduling </b> to their division head/manager and the employee.</p>

	<p><b>All approved requests for LWOP (Leave Without Pay) </b> need to be copied
	to Library Payroll (Joan Shelby) in order to avoid having a hold placed on your
	paycheck. </p>

	<p>Please direct all questions about this form or any payroll issue to
	Joan Shelby (x41642 or <a href="mailto:jshelby@mail.sdsu.edu">jshelby@mail.sdsu.edu</a>).</p>


<p>Information regarding vacations and leaves can be found at <a href="http://www.calstate.edu/LaborRel/Contracts_HTML/contracts.shtml"> Contract Information</a></p>

<cfif ((IsDefined('FORM.PROCESSABSENCEREQUESTS') AND FORM.PROCESSABSENCEREQUESTS EQ "ADD") AND (#SESSION.ORIGINSERVER# NEQ "LFOLKSWIKI" AND #SESSION.ORIGINSERVER# NEQ "FORMS"))>
     <table border="0" width="100%">
          <tr>
               <td align="LEFT">&nbsp;&nbsp;</td>
          </tr>
          <tr>
     <cfform action="/#application.type#apps/webreports/absencerequest.cfm?PROCESS=#FORM.PROCESSABSENCEREQUESTS#" method="POST">
               <td align="left">
                    <input type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /><br />
                    <COM>(Please DO NOT use the Browser's Back Button.)</COM>
               </td>
     </cfform>
          </tr>
          <tr>
               <td align="LEFT">&nbsp;&nbsp;</td>
          </tr>
     </table>
</cfif>

</cfoutput>

</body>
</html>