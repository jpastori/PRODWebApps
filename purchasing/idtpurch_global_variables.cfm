<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtpurch_global_variables.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/05/2010 --->
<!--- Date in Production: 08/05/2010 --->
<!--- Module: IDT Purchasing Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 08/05/2010 using ColdFusion Studio: -->

<!--- This array is used to process Multiple Purchase Requisition Lines. --->

<CFSET SESSION.PurchReqSerNumsArray = ArrayNew(1)>
<CFSET SESSION.PurchReqID = 0>

<!--- Variables to Designate that the Global Variables have been created --->
<CFSET application.idtpurch_initialized = 1>
<CFSET application.initialized = 1>