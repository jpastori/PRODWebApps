<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: selecttutorformat.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 10/01/2007 --->
<!--- Date in Production: 10/01/2007 --->
<!--- Module: Instruction Plagiarism - Select Tutor Format --->
<!-- Last modified by John R. Pastori on 10/01/2007 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/instruction/plagiarism/selecttutorformat.cfm">
<CFSET CONTENT_UPDATED = "October 01, 2007">

<HTML>
<HEAD>

	<TITLE>Instruction Plagiarism - Select Tutor Format</TITLE>
	<META http-equiv="content-type" content="text/html; charset= iso-8859-1" />
	<META name="keywords" content="100W Registration form, San Diego State University" />
	<LINK rel="stylesheet" type="text/css" href="plagiarism.css" />

</HEAD>

<BODY marginheight="0" link="red">

<CFOUTPUT>

<CFIF SESSION.GUEST EQ "NO">
	<CFINCLUDE template="/#application.type#apps/instruction/plagiarism/header.cfm">
<CFELSE>
	<CFINCLUDE template="/#application.type#apps/instruction/plagiarism/headerguest.cfm">
</CFIF>
<BR />
<BR />

<DIV class="templateHeaderBodyIndent">

	<SPAN class="title18">Please select to use Flash or non-Flash version of the tutorial. </SPAN>
	<BR />
	<HR size="1" width="100%" />
	<TABLE cellpadding="5" cellspacing="0" border="0" width="90%" align="center">
		<TR>
			<TD valign="top" width="40%" align="right"><A href="/#application.type#apps/instruction/plagiarism/tutorialflash/flash_introduction.cfm" onMouseOver="flash1.src='/images/flash_2.jpg'"  onMouseOut="flash1.src='/images/flash_1.jpg'" > <IMG src="/images/flash_1.jpg" name="flash1" alt="Paraphasing" width="120" height="60" /></A></TD>
			<TD valign="top" width="20%"></TD>
			<TD valign="top" width="40%"><A href="/#application.type#apps/instruction/plagiarism/tutorial/nonflash_introduction.cfm" onMouseOver="nonflash.src='/images/non_flash_2.jpg'"  onMouseOut="nonflash.src='/images/non_flash_1.jpg'" > <IMG src="/images/non_flash_1.jpg" name="nonflash" alt="Paraphasing" width="120" height="60" /></A></TD>
		</TR>
	</TABLE>
	<BR />

	<CFIF SESSION.GUEST EQ "NO">
		<CFINCLUDE template="/#application.type#apps/instruction/plagiarism/footer.cfm">
	<CFELSE>
		<CFINCLUDE template="/#application.type#apps/instruction/plagiarism/footerguest.cfm">
	</CFIF>

</DIV>

<CFINCLUDE template="/include/coldfusion/footer.cfm">

</CFOUTPUT>

</BODY>
</HTML>