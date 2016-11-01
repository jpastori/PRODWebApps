<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: salestax.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: Modify Information to IDT Purchasing - Sales Tax --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/salestax.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Modify/Delete Information to IDT Purchasing - Sales Tax</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Purchasing";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}

	function validateReqFields() {
		if (document.SALESTAX.SALESTAXTEXT.value == "" || document.SALESTAX.SALESTAXTEXT.value == " ") {
			alertuser (document.SALESTAX.SALESTAXTEXT.name +  ",  A Sales Tax Name MUST be entered!");
			document.SALESTAX.SALESTAXTEXT.focus();
			return false;
		}

		if (document.SALESTAX.CURRENTSALESTAX.value == "" || document.SALESTAX.CURRENTSALESTAX.value == " ") {
			alertuser (document.SALESTAX.CURRENTSALESTAX.name +  ",  A Current Sales Tax Number MUST be entered!");
			document.SALESTAX.CURRENTSALESTAX.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<BODY onLoad="document.SALESTAX.SALESTAXTEXT.focus()">

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "MODIFY">
</CFIF>

<BR clear="left" />
<!--- 
****************************************************************************
* The following code is the Modify Process for IDT Purchasing - Sales Tax. *
****************************************************************************
 --->
 
<CFQUERY name="GetSalesTax" datasource="#application.type#PURCHASING">
	SELECT	SALESTAXID, SALESTAXTEXT, TO_CHAR(CURRENTSALESTAX, '9D9999') AS SALESTAX
	FROM		SALESTAX
	WHERE	SALESTAXID = 1
	ORDER BY	SALESTAXID
</CFQUERY>

<TABLE width="100%" align="center" border="3">
	<TR align="center">
		<TD  align="center"><H1>Modify IDT Purchasing - Sales Tax</H1></TD>
	</TR>
</TABLE>

<TABLE width="100%" align="center" border="0">
	<TR>
		<TH align="center"><H4>*Red fields are required!</H4></TH>
	</TR>
	<TR>
		<TH align= "CENTER">
			Sales Tax Key &nbsp; = &nbsp; #GetSalesTax.SALESTAXID#
		</TH>
	</TR>
</TABLE>


<TABLE align="left" width="100%" border="0">
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
<CFFORM name="SALESTAX" onsubmit="return validateReqFields();" action="/#application.type#apps/purchasing/processsalestax.cfm" method="POST" ENABLECAB="Yes">
	<TR>
		<CFCOOKIE name="SALESTAXID" secure="NO" value="#GetSalesTax.SALESTAXID#">
		<TH align="left"><H4><LABEL for="SALESTAXTEXT">*Sales Tax Text:</LABEL></H4></TH>
		<TD align="left"><CFINPUT type="Text" name="SALESTAXTEXT" id="SALESTAXTEXT" value="#GetSalesTax.SALESTAXTEXT#" align="LEFT" required="No" size="8" maxlength="8" tabindex="2"></TD>
		<TH align="left"><H4><LABEL for="CURRENTSALESTAX">*Sales Tax in Number Format:</LABEL></H4></TH>
		<TD align="left"><CFINPUT type="Text" name="CURRENTSALESTAX" id="CURRENTSALESTAX" value="#GetSalesTax.SALESTAX#" align="LEFT" required="No" size="12" maxlength="12" tabindex="3"></TD>
	</TR>
	<TR>
     	<TD align="left">
               <INPUT type="hidden" name="PROCESSSALESTAX" value="MODIFY" />
               <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
          </TD>
	</TR>
</CFFORM>
	<TR>
		<TD align="left">&nbsp;&nbsp;</TD>
	</TR>
	<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
		<TD align="left" colspan="2">
			<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
			<COM>(Please DO NOT use the Browser's Back Button.)</COM>
		</TD>
</CFFORM>
	</TR>
	<TR>
		<TD align="CENTER" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
	</TR>
</TABLE>
</CFOUTPUT>

</BODY>
</HTML>