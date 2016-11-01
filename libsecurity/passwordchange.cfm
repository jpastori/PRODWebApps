<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: passwordchange.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/20/2009 --->
<!--- Date in Production: 05/20/2009 --->
<!--- Module: Modify Information to Library Security - Password Change --->
<!-- Last modified by John R. Pastori on 07/27/2016 using ColdFusion Studio. -->

<cfset AUTHOR_NAME = "John R. Pastori">
<cfset AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<cfset DOCUMENT_URI = "/#application.type#apps/libsecurity/passwordchange">
<cfset CONTENT_UPDATED = "July 27, 2016">

<html>
<head>
	<title>Modify Information to Library Security - Password Change</title>
	<meta http-equiv="Content-Language" content="en-us" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="Fri, 01 Jan 1999 00:00:01 GMT" />
	<link rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<script language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Library Security";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.PASSWORDCHANGE.OLDPASSWORD.value == "" || document.PASSWORDCHANGE.OLDPASSWORD.value == " ") {
			alertuser (document.PASSWORDCHANGE.OLDPASSWORD.name +  ",  An Old Password must be entered!");
			document.PASSWORDCHANGE.OLDPASSWORD.focus();
			return false;
		}

		if (document.PASSWORDCHANGE.NEWPASSWORD.value == "" || document.PASSWORDCHANGE.NEWPASSWORD.value == " ") {
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A New Password must be entered!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (document.PASSWORDCHANGE.CONFIRMPASSWORD.value == "" || document.PASSWORDCHANGE.CONFIRMPASSWORD.value == " ") {
			alertuser (document.PASSWORDCHANGE.CONFIRMPASSWORD.name +  ",  A Confirming Password must be entered!");
			document.PASSWORDCHANGE.CONFIRMPASSWORD.focus();
			return false;
		}

		if (document.PASSWORDCHANGE.NEWPASSWORD.value.length < 10) {
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  The New Password must be a MINIMUM of 10 characters");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (!document.PASSWORDCHANGE.NEWPASSWORD.value.match(/[A-Z_]/)){
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A Password must have at least 1 Uppercase Letter!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (!document.PASSWORDCHANGE.NEWPASSWORD.value.match(/[a-z]/)){
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A Password must have at least 1 lowercase letter!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (!document.PASSWORDCHANGE.NEWPASSWORD.value.match(/[0-9]/)){
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A Password must have at least 1 number!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (!document.PASSWORDCHANGE.NEWPASSWORD.value.match(/\W/)){
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A Password must have at least 1 special character!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

//		if (document.PASSWORDCHANGE.NEWPASSWORD.value.match(/[A-Z]{4,}/)
//		  || document.PASSWORDCHANGE.NEWPASSWORD.value.match(/\d{4,}/) || document.PASSWORDCHANGE.NEWPASSWORD.value.match(/\s{4,}/)) {
//			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  Passwords must not contain more than 3 consecutive upper case letters, numbers or special characters!");
//			document.PASSWORDCHANGE.NEWPASSWORD.focus();
//			return false;
//		}

		if (document.PASSWORDCHANGE.NEWPASSWORD.value.match(/\s/)) {
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  A Password CANNOT contain spaces, carriage returns, tabs or non-printable characters!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (document.PASSWORDCHANGE.NEWPASSWORD.value != document.PASSWORDCHANGE.CONFIRMPASSWORD.value) {
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  The New Password and the Confirm Password data must Match exactly!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}

		if (document.PASSWORDCHANGE.NEWPASSWORD.value == document.PASSWORDCHANGE.OLDPASSWORD.value) {
			alertuser (document.PASSWORDCHANGE.NEWPASSWORD.name +  ",  The New Password and the Old Password data CANNOT be the same!");
			document.PASSWORDCHANGE.NEWPASSWORD.focus();
			return false;
		}


	}

//
</script>
<!--Script ends here -->

</head>

<body onLoad="document.PASSWORDCHANGE.OLDPASSWORD.focus()">

<cfoutput>
<!--- Get a list of employees from the database. --->

<cfquery name="LookupCustomer" datasource="#application.type#LIBSHAREDDATA">
	SELECT	CUSTOMERID, FULLNAME, PASSWORD, ACTIVE, SEEDKEY
	FROM		CUSTOMERS
	WHERE	CUSTOMERID = <CFQUERYPARAM value="#URL.CUSTOMER#" cfsqltype="CF_SQL_NUMERIC"> AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</cfquery>

<cfinclude template="/include/coldfusion/formheader.cfm">

<table width="100%" align="center" border="3">
	<tr align="center">
		<td align="center"><h1>Modify Information to Library Security - Password Change</h1></td>
	</tr>
</table>
<table align="LEFT" width="100%" border="0">
	<tr align="LEFT">
		<td align="LEFT" colspan="2">
			You are logged in as #LookupCustomer.FULLNAME#.<br /><br />
			<COM>
				Password Rules: <br />
				1.&nbsp;&nbsp; Passwords must be at least ten (10) and not more than twenty (20) characters long.<br />
				2.&nbsp;&nbsp; Passwords must contain at least one of the following four types of characters: <br />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; uppercase letters (A-Z), lowercase letters (a-z), numbers (0-9), and punctuation characters (!, @, ##, etc.).<br />
				3.&nbsp;&nbsp; Passwords must not contain spaces, carriage returns, tabs or non-printable characters.<br />
				4.&nbsp;&nbsp; Passwords must not contain more than 3 consecutive letters, numbers or special characters.<br /><br />
			</COM>
		</td>
	</tr>
<cfform name="PASSWORDCHANGE" onsubmit="return validateReqFields();" action="/#application.type#apps/libsecurity/processpasswordchange.cfm?SEEDKEY=#LookupCustomer.SEEDKEY#" method="POST">
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">
			<h4><label for="OLDPASSWORD">*Old Password:</label></h4>
		</td>
		<td align="LEFT" valign="TOP">
			<input type="hidden" name="CUSTOMERID" value="#LookupCustomer.CUSTOMERID#" />
			<cfinput type="PASSWORD" name="OLDPASSWORD" id="OLDPASSWORD" value="" size="25"  maxlength="20" tabindex="1"><br /><br />
		</td>
	</tr>
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">
			<h4><label for="NEWPASSWORD">*New Password:</label></h4>
		</td>
		<td align="LEFT" valign="TOP">
			<cfinput type="PASSWORD" name="NEWPASSWORD" id="NEWPASSWORD" value="" size="25"  maxlength="20" tabindex="2"><br /><br />
		</td>
	</tr>
	<tr>
		<td align="RIGHT" valign="TOP" width="25%">
			<h4><label for="CONFIRMPASSWORD">*Confirm Password:</label></h4>
		</td>
		<td align="LEFT" valign="TOP">
			<cfinput type="PASSWORD" name="CONFIRMPASSWORD" id="CONFIRMPASSWORD" value="" size="25" maxlength="20" tabindex="3"><br /><br />
		</td>
	</tr>
	<tr>
		<td align="LEFT" valign="TOP">
			<input type="Submit" value="Change Password" tabindex="4" />
		</td>
	</tr>
</cfform>
	<tr>
<cfform action="/#application.type#apps/index.cfm?logout=Yes" method="POST">
		<td align="LEFT" colspan="2">
			<input type="submit" value="Cancel" tabindex="5" />
		</td>
</cfform>
	</tr>
	<tr>
		<td colspan="2">
			<cfinclude template="/include/coldfusion/footer.cfm">
		</td>
	</tr>
</table>
</cfoutput>

</body>
</html>