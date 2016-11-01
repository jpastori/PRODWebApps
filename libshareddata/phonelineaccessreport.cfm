<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: phonelineaccessreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/05/2014 --->
<!--- Date in Production: 03/05/2014 --->
<!--- Module: Shared Data - Phone Line Access Report --->
<!-- Last modified by John R. Pastori on 01/07/2015 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>	Shared Data - Phone Line Access Report</H1>
               </TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<TD align="left">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="9"><H2>#ListCustomers.RecordCount# Customer records were selected.</H2></TH>
		</TR>
          <TR>
			<TD colspan="9">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Customer</TH>
			<TH align="left" valign="BOTTOM">Red ID</TH>
               <TH align="left" valign="BOTTOM">Loc</TH>
			<TH align="center" valign="BOTTOM">Campus Telephone</TH>
			<TH align="left" valign="BOTTOM">Dialing Capability</TH>
			<TH align="center" valign="BOTTOM">VMS</TH>
			<TH align="center" valign="BOTTOM">LD Card</TH>
               <TH align="center" valign="BOTTOM">PhoneBook Listing</TH>
               <TH align="center" valign="BOTTOM">Analog Line</TH>
		</TR>
          <TR>
			<TD colspan="9"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
          
	<CFLOOP query="ListCustomers">
     
		<TR>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.FULLNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.REDID#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.ROOMNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.CAMPUSPHONE#</DIV></TD>
               <TD align="left" valign="TOP"><DIV>#ListCustomers.DIALINGCAPABILITY#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.VOICEMAIL#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.LONGDISTAUTHCODE#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListCustomers.PHONEBOOKLISTING#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListCustomers.ANALOGLINE#</DIV></TD>
		</TR>
          <TR>
			<TD colspan="9">&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
		<TR>
			<TD colspan="9"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="9"><H2>#ListCustomers.RecordCount# Customer records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<TD align="left">
               	<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="9"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>