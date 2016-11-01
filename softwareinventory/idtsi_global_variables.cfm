<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtsi_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: IDT Software Inventory Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio: -->

<!--- This array is used to process Modify Loop Multiple Record changes. --->
<CFSET session.SoftwareIDArray = ArrayNew(1)>


<!--- Variables to Designate that the Application Global Variables have been created --->
<CFSET application.idtsi_initialized = 1>
<CFSET application.initialized = 1>
