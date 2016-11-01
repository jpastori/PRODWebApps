<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: logon_form.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/26/2011 --->
<!--- Date in Production: 10/26/2011 --->
<!--- Module: LOVE Library Oracle Web Applications LogIn Form--->
<!-- Last modified by John R. Pastori on 07/27/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/logon_form.cfm">
<cfset CONTENT_UPDATED = "July 27, 2016">
<html>

<head>
	<title>Library's Web Applications LogIn Form</title>
	<cfoutput>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="Fri, 01 Jan 2999 00:00:01 GMT" />
	<!--- Global CSS --->
	<link rel="stylesheet" type="text/css" href="/webapps.css" />
	</cfoutput>

<!-- Scripts start here ---->
</head>

<noscript>
	<h4><font size=+3><strong><em><center><BLINK>The JavaScript option MUST BE turned on in your browser to use this site!</BLINK></center></em></strong></font></h4>
	<meta http-equiv="refresh" content="5; URL=/index2.shtml" />
</noscript>

<script language=JAVASCRIPT>
	window.defaultStatus = "Login for the Library's Web Applications System";

	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.LOGIN.CUSTOMERID.selectedIndex == "0") {
			alertuser (document.LOGIN.CUSTOMERID.name +  ",  A Customer Name must be selected!");
			document.LOGIN.CUSTOMERID.focus();
			return false;
		}
		if (document.LOGIN.PASSWORD.value == "") {
			alertuser (document.LOGIN.PASSWORD.name +  ",  A Password must be entered!");
			document.LOGIN.PASSWORD.focus();
			return false;
		}
		var cookiestring = "test=1;EXPIRES=Thursday, 01-Jan-54 23:59:59 GMT;" 
		document.cookie = cookiestring; 
		if (document.cookie) {
			cookiestring = "test=1;EXPIRES=Saturday, 01-Jan-00 00:00:00 GMT;" 
			document.cookie = cookiestring;
			return true;
		} else {
			alertuser ("Cookies need to be ENABLED on your browser!");
			document.LOGIN.CUSTOMERID.focus();
			return false;
		}
	}

//
</script>
<!--Script ends here -->

</head>

<body onLoad="document.LOGIN.CUSTOMERID.focus()">
<!--- Get a list of employees from the database. --->

<cfoutput>

<cfquery name="ListCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, PASSWORD, ACTIVE, SEEDKEY
	FROM		CUSTOMERS
	WHERE	PASSWORD IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</cfquery>

<cfinclude template="/include/coldfusion/header.cfm">

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Login for the Library's Web Applications System</h1></td>
	</tr>
</table>

<table width="100%" border="0">
<cfform name="LOGIN" onsubmit="return validateReqFields();" action="index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES" method="POST">
	<tr>
		<td align="CENTER" colspan="2">
			<input type="hidden" name="LoggingOn" value="1" />
		<!--- If the variable form.loggingon exists it means the user hit the form, but did not get logged in.  --->
			<cfif IsDefined("Form.LoggingOn") AND #Form.LoggingOn# EQ 1>
				<h4>Either that is not a valid password, so please try again<br />
				or this customer is not authorized to login to this system!</h4>
			<cfelse>
				<br /><h4>(Note: Cookies and JavaScript options need to be ENABLED on your browser!)</h4><br /><br />
			</cfif>
		</td>
	</tr>
</TABLE>
<fieldset>
<legend>Log in</legend>
<table width="100%" border="0">
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">&nbsp;&nbsp;</td>
		<td align="LEFT" valign="TOP">
			<COM>Please select your name from the list and enter your password.</COM>
		</td>
	</tr>
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">
			<h4><label for="CUSTOMERID">*Customer Name:</label></h4>
		</td>
		<td align="LEFT" valign="TOP">
			<!--- Display every employee that has a password set. --->
			<cfselect name="CUSTOMERID" id="CUSTOMERID" size="1" query="ListCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" tabindex="1"></cfselect>
		</td>
	</tr>
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">
			<h4><label for="PASSWORD">*Password:</label></h4>
		</td>
		<td align="LEFT" valign="TOP">
			<cfinput type="PASSWORD" name="PASSWORD" id="PASSWORD" value="" size="25"  maxlength="20" tabindex="2"><br /><br />
			<input type="Submit" name="LOGON" value="Logon" tabindex="3" />
			<input type="RESET" name="RESETBUTTON" value="Reset" tabindex="4" />
		</td>
	</tr>
</table>
</fieldset>
<br />
<fieldset>
<legend>Change Password</legend>
<table width="100%" border="0">
	<tr>
		<td align="LEFT" valign="TOP">&nbsp;&nbsp;</td>
		<td align="left">
			<input type="submit" name="CHANGEPASSWORD" value="Change Password" tabindex="5" /><br /><br />
			<COM>
				To change your password:  <br />Please select your name and enter your current password, then click the Change Password button.<br /><br />
			</COM>
			<COM>
				<strong>NOTE:</strong>&nbsp;&nbsp;A password must contain at least one uppercase, one lowercase, one symbol and one digit for a MINIMUM of 10 characters, MAXIMUM OF 20 characters.<br />
				<h4>Less than 10 characters is not allowed.</h4>
			</COM>
		</td>
	</tr>
</cfform>
</TABLE>
</FIELDSET>
<br />
<cfinclude template="/include/coldfusion/footer.cfm">
</cfoutput>

</body>
</html>