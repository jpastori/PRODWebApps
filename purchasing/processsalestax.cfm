<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: processsalestax.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/24/2008 --->
<!--- Date in Production: 06/24/2008 --->
<!--- Module: Process Information to IDT Purchasing - Sales Tax--->
<!-- Last modified by John R. Pastori on 06/24/2008 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Process Information to IDT Purchasing - Sales Tax</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />
</HEAD>

<BODY>

<CFOUTPUT>
<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFQUERY name="ModifySalesTax" datasource="#application.type#PURCHASING">
	UPDATE	SALESTAX
	SET		SALESTAX.SALESTAXTEXT = UPPER('#FORM.SALESTAXTEXT#'),
			SALESTAX.CURRENTSALESTAX = TO_NUMBER('#FORM.CURRENTSALESTAX#', '9D9999')
	WHERE	(SALESTAXID = #val(Cookie.SALESTAXID)#)
</CFQUERY>

<H1>Data MODIFIED!</H1>
<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/index.cfm?logout=No" />
</CFOUTPUT>

</BODY>
</HTML>