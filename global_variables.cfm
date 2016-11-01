<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: global_variables.cfm --->
<!--- Date Written: 08/04/2009 --->
<!--- Date in Production: 08/04/2009 --->
<!--- Module: Application Global Variables Page --->
<!-- Last modified by John R. Pastori on 08/04/2009 using ColdFusion Studio:. -->

<!--- <cfoutput>APPLICATION INITIALIZED = #application.initialized#<br></cfoutput> --->
<!--- The name of the datasource type used througout the site --->
<CFPARAM name="application.type" default="PROD">
<CFSET application.type = "PROD">

<!--- Path variables --->
<CFPARAM name="application.root_path" default="/home/www/lfolkscf/htdocs/PRODapps">

<CFPARAM name="app.image_path" default="/images/"> 
<!--- End Of Path variables --->

<!--- Shared Variables used in the Oracle Web Applications --->
<CFPARAM name="header.page_name" default="Library Oracle Web Applications">

<!--- End Of Shared Variables used in the Oracle Web Applications --->

<!--- CLIENT LOGOUT AND SECURITY VARIABLES --->
<CFPARAM name="URL.logout" default="NO">

<CFPARAM name="Client.AdminFlag" default="NO">

<CFPARAM name="Client.DeleteFlag" default="NO">

<CFPARAM name="Client.MaintFlag" default="NO">

<CFPARAM name="Client.SecurityFlag" default="NO">

<CFPARAM name="Client.SecurityLevel" default="">

<CFPARAM name="Client.ValidatedSystems" default="">

<!--- END OF CLIENT LOGOUT AND SECURITY VARIABLES --->

<!--- CLIENT APPLICATION ACCESS VARIABLES --->
<CFPARAM name="URL.ACCESSINGAPPFIRSTTIME" default="NO">
<CFPARAM name="Client.ACCESSINGFACILITIES" default="NO">
<CFPARAM name="Client.ACCESSINGINSTRUCTION" default="NO">
<CFPARAM name="Client.ACCESSINGISTEQUIPINVENTORY" default="NO">
<CFPARAM name="Client.ACCESSINGISTPURCHASING" default="NO">
<CFPARAM name="Client.ACCESSINGISTSERVICEREQUESTS" default="NO">
<CFPARAM name="Client.ACCESSINGISTSOFTWINVENT" default="NO">
<CFPARAM name="Client.ACCESSINGLIBSECURITY" default="NO">
<CFPARAM name="Client.ACCESSINGLIBSHAREDDATA" default="NO">
<CFPARAM name="Client.ACCESSINGSPECIALCOLLECTIONS" default="NO">
<CFPARAM name="Client.ACCESSINGWEBREPORTS" default="NO">


<!--- Variable to Designate that the Global Variables have been created --->
<CFSET application.initialized = 1>
<!--- <cfoutput>APPLICATION INITIALIZED = #application.initialized#<br></cfoutput> --->