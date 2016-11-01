<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: choosehwaddorsradd.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/16/2013 --->
<!--- Date in Production: 05/16/2013 --->
<!--- Module: IDT Service Requests - Choose HW Add or SR Add --->
<!-- Last modified by John R. Pastori on 05/16/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/choosehwaddorsradd.cfm">
<CFSET CONTENT_UPDATED = "May 16, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>
<HTML>
<HEAD>
	<TITLE>IDT Service Requests - Choose HW Add or SR Add</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests Application";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY onLoad="document.HISRAdd.HIAdd.focus()">

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TH align="center"><H1>IDT Service Requests - Choose HW Inventory or SR Add</H1></TH>
	</TR>
</TABLE>
<TABLE width="100%" align="LEFT">
	<TR>
<CFFORM name="HIAdd" action="/#application.type#apps/hardwareinventory/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" method="POST">
		<TD align="LEFT">
          	<INPUT type="submit" name="HW Inventory" value="HW Inventory" tabindex="1" /><BR>
               <COM>Go to Hardware Inventory Index Page</COM>
		</TD>
</CFFORM>
<CFFORM name="SRAdd" action="/#application.type#apps/servicerequests/lookupcontactsprobleminfo.cfm" method="POST">
		<TD align="LEFT">
			<INPUT type="submit" name="SRAdd" value="SR Add" tabindex="2" /><BR>
               <COM>Go Back to SR Add Screen</COM>
		</TD>
</CFFORM>
	</TR>
</TABLE>

</BODY>
</HTML>
</CFOUTPUT>