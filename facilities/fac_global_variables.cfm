<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: fac_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/05/2012 --->
<!--- Date in Production: 07/05/2012 --->
<!--- Module: Facilities Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 07/05/2012 using ColdFusion Studio: -->

<CFSET session.APPROVAL = "">
<CFSET session.APPROVER = 0>
<CFSET session.FIELDNAME = "">
<CFSET session.KEYCOUNTER = 0>
<CFSET session.MGMTNAME = "">
<CFSET session.MOVEREQUESTCOUNTER = 0>
<CFSET session.PROCESS = "">
<CFSET session.STATUS = "0">
<CFSET session.DOORSACCESSEDARRAY = ArrayNew(1)>
<CFSET session.WORKREQUESTIDArray = ArrayNew(1)>

<!--- This array is used to process Modify Loop Multiple Record changes. --->
<CFSET session.WallJackIDArray = ArrayNew(1)>

<!--- Variables to Designate that the Global Variables have been created --->
<CFSET application.fac_initialized = 1>
<CFSET application.initialized = 1>