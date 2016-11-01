<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtsr_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/10/2012 --->
<!--- Date in Production: 07/10/2012 --->
<!--- Module: IDT Service Requests Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 07/10/2012 using ColdFusion Studio: -->

<!--- These arrays are used to process Modify Loop Multiple Record changes. --->
<CFSET session.SRIDArray = ArrayNew(1)>
<CFSET session.SRSTAFFASSIGNArray = ArrayNew(1)>

<!--- Set initial client variable values. --->
<CFSET client.STAFFLOOP = 'NO'>

<!--- Variables to Designate that the Global Variables have been created --->
<CFSET application.idtsr_initialized = 1>
<CFSET application.initialized = 1>