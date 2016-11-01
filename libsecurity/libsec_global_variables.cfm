<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: libsec_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 01/13/2007 --->
<!--- Date in Production: 01/13/2007 --->
<!--- Module: Library Security Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 01/13/2007 using ColdFusion Studio: -->

<!--- This array is used to process Modify Loop Multiple Record changes. --->
<CFSET session.CustomerAccessIDArray = ArrayNew(1)>


<!--- Variables to Designate that the Application Global Variables have been created --->
<CFSET application.libsec_initialized = 1>
<CFSET application.initialized = 1>