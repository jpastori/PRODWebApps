<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idthardwareinv_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/07/2013 --->
<!--- Date in Production: 05/07/2013 --->
<!--- Module: Application Global Variables Page  for IDT Hardware Inventory Application --->
<!-- Last modified by John R. Pastori on 05/07/2013 using ColdFusion Studio: -->

<!--- <cfoutput>IDT HARDWARE INVENTORY APPLICATION INITIALIZED = #application.idthardwareinv_initialized#</cfoutput> --->

<!--- This array is used to process Modify Loop Multiple Record changes. --->
<CFSET session.HardwareIDArray = ArrayNew(1)>

<CFINCLUDE template="setupglobalinventoryvariables.cfm">
<!--- END OF IDT HARDWARE INVENTORY APPLICATION VARIABLES --->

<!--- This array is used to process Facilities WallJack Modify Loop Multiple Record changes. --->
<CFSET session.WallJackIDArray = ArrayNew(1)>

<!--- Variables to Designate that the Global Variables have been created --->
<CFSET application.idthardwareinv_initialized = 1>
<CFSET application.initialized = 1>

<!--- <cfoutput>IDT HARDWARE INVENTORY APPLICATION INITIALIZED = #application.idtequipinv_initialized#</cfoutput> --->