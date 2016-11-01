<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtchatterchanges.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 11/20/2013 --->
<!--- Date in Production: 11/20/2013 --->
<!--- Module: IDT Chatter Changes --->
<!-- Last modified by John R. Pastori on 11/17/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/idtchatterchanges.cfm">
<CFSET CONTENT_UPDATED = "November 17, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Chatter Changes</TITLE>

	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Chatter";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY>
<CFOUTPUT>

<CFINCLUDE template = "idtchatterchangesreport.cfm">

</CFOUTPUT>
<!--- 
*****************************************************************************************
* The following code E-Mails the IDT Chatter Changes Report to libraryes@mail.sdsu.edu. *
*****************************************************************************************
 --->	
<CFMAIL type="html"
     to="libraryes@mail.sdsu.edu"
     from="idtchat@mail.sdsu.edu"
     subject="IDT Chatter Changes in Previous 30 Days"
>
<CFINCLUDE template = "idtchatterchangesreport.cfm">
</CFMAIL>

</BODY>
</HTML>