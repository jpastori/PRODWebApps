<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: Application.cfm.--->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/21/2009 --->
<!--- Date in Production: 05/21/2009--->
<!-- Last modified by John R. Pastori on 05/21/2009 using ColdFusion Studio: -->

<CFAPPLICATION name="LIBRARYWEBAPPS" clientmanagement="Yes" clientstorage="PRODLIBSHAREDDATA" sessionmanagement="Yes" setclientcookies="Yes" scriptprotect="all">

<CFINCLUDE template="../SQLInjectionIPBlackListProcess.cfm">

<CFINCLUDE template="../facilities/fac_global_variables.cfm">
<CFINCLUDE template="../hardwareinventory/idthardwareinv_global_variables.cfm">
<CFINCLUDE template="../purchasing/idtpurch_global_variables.cfm">
<CFINCLUDE template="../webreports/webrpts_global_variables.cfm">

<CFINCLUDE template="../SQLInjectionProtectionCode.cfm">