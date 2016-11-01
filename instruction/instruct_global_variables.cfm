<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: instruct_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/24/2010 --->
<!--- Date in Production: 01/24/2010 --->
<!--- Module: Instruction Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 01/24/2010 using ColdFusion Studio: -->

<!--- This array is used to process Modify Loop Multiple Record changes. --->
<CFSET session.WorkshopSessionArray = ArrayNew(1)>

<!--- 
	This variable is used to check if the originating server is INFOTUTOR.SDSU.EDU or a program is 
	being called from the /forms/ directory.
 --->
<CFSET SESSION.ORIGINSERVER = "">

<!--- Variables to Designate that the Application Global Variables have been created --->
<CFIF NOT IsDefined('application.type')>
	<CFPARAM name="application.type" default="PROD">
	<CFSET application.type = "PROD">
</CFIF>
<CFSET application.instruct_initialized = 1>
<CFSET application.initialized = 1>
