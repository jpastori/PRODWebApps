<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: customerdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: Shared Data Customer Database Report--->
<!-- Last modified by John R. Pastori on 07/24/2012 using ColdFusion Studio. -->

<CFINCLUDE template = "../programsecuritycheck.cfm">

<CFOUTPUT>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center">
               	<H1>Shared Data - Customer Info Report - #REPORTCHOICE#</H1>
               </TD>
		</TR>
 	</TABLE>
	<TABLE width="100%" align="LEFT" border="0">
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<TD align="left">
               	<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR /><BR />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="10"><H2>#ListCustomers.RecordCount# Customer records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="left" valign="BOTTOM">Name</TH>
			<TH align="center" valign="BOTTOM">Customer Active?</TH>

		<CFIF #REPORTCHOICE# EQ 'IDT'>
			<TH align="center" valign="BOTTOM">Initials</TH>
          <CFELSE>
          	<TH align="center" valign="BOTTOM">&nbsp;&nbsp;</TH>
		</CFIF>

			<TH align="center" valign="BOTTOM">Customer Category</TH>
			<TH align="center" valign="BOTTOM">E-Mail Address</TH>
			<TH align="center" valign="BOTTOM">Campus Phone Number</TH>
			<TH align="center" valign="BOTTOM">2nd Campus Phone Number</TH>
			<TH align="center" valign="BOTTOM">Cell Phone Number</TH>
			<TH align="center" valign="BOTTOM">Fax Number</TH>
               <TH align="center" valign="BOTTOM">Voice Mail</TH>
		</TR>

	<CFLOOP query="ListCustomers">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM VALUE="#ListCustomers.MODIFIEDBYID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<CFQUERY name="LookupCampusMailCodes" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CAMPUSMAILCODEID, CAMPUSMAILCODE
			FROM		CAMPUSMAILCODES
			WHERE	CAMPUSMAILCODEID = <CFQUERYPARAM VALUE="#ListCustomers.CAMPUSMAILCODEID#" CFSQLTYPE="CF_SQL_NUMERIC">
			ORDER BY	CAMPUSMAILCODE
		</CFQUERY>

		<TR>
			<TD align="left" valign="TOP"><STRONG>#ListCustomers.FULLNAME#</STRONG></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.ACTIVE#</DIV></TD>

		<CFIF #REPORTCHOICE# EQ 'IDT'>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.INITIALS#</DIV></TD>
          <CFELSE>
          	<TD align="center" valign="BOTTOM">&nbsp;&nbsp;</TD>
		</CFIF>

			<TD align="left" valign="TOP"><DIV>#ListCustomers.CATEGORYNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.EMAIL#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.CAMPUSPHONE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.SECONDCAMPUSPHONE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.CELLPHONE#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListCustomers.FAX#</DIV></TD>
               <TD align="center" valign="TOP"><DIV>#ListCustomers.VOICEMAIL#</DIV></TD>
		</TR>

		<CFIF #REPORTCHOICE# EQ 'FULL' OR #REPORTCHOICE# EQ 'LIBADMIN'>
		<TR>
			<TH align="left" valign="TOP">Dialing Capability:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.DIALINGCAPABILITY#</DIV></TD>
			<TH align="left" valign="TOP">Long Distance Authorization Code?</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.LONGDISTAUTHCODE#</DIV></TD>
			<TH align="left" valign="TOP">PhoneBook Listing</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.PHONEBOOKLISTING#</DIV></TD>
			<TH align="left" valign="TOP">Bibliographer?</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.BIBLIOGRAPHER#</DIV></TD>
			<TH align="left" valign="TOP">Analog Line</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.ANALOGLINE#</DIV></TD>
		</TR>
		</CFIF>

		<TR>
		<CFIF #ListCustomers.REDID# GT 0>
			<TH align="left" valign="TOP">RedID:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.REDID#</DIV></TD>
		</CFIF>
			<TH align="left" valign="TOP">Campus Mail Code:</TH>
			<TD align="left" valign="TOP"><DIV>#LookupCampusMailCodes.CAMPUSMAILCODE#</DIV></TD>
			<TH align="left" valign="TOP">Unit Head?</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.UNITHEAD#</DIV></TD>
			<TH align="left" valign="TOP">Department Chair?</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.DEPTCHAIR#</DIV></TD>
		</TR>

		<TR>
			<TH align="left" valign="TOP">Unit/Group Name:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.UNITGROUP#</DIV></TD>
			<TH align="left" valign="TOP">Department Name:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.DEPARTMENTNAME#</DIV></TD>
			<TH align="left" valign="TOP">Room Number:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.ROOMNUMBER#</DIV></TD>

		<CFIF #REPORTCHOICE# EQ 'FULL' OR #REPORTCHOICE# EQ 'LIBADMIN'>
			<TH align="left" valign="TOP">Customer Allowed To Approve?:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.ALLOWEDTOAPPROVE#</DIV></TD>
		</CFIF>

			<TH align="left" valign="TOP">Contact By:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.CONTACTBY#</DIV></TD>

		</TR>
		<TR>
			<TH align="left" valign="TOP">Modified-By Name:</TH>
			<TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TH align="left" valign="TOP">Date Modified:</TH>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListCustomers.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
			<TH align="left" valign="TOP">Comments:</TH>
			<TD align="left" valign="TOP"><DIV>#ListCustomers.COMMENTS#</DIV></TD>
		<CFIF #REPORTCHOICE# NEQ 'LIBADMIN'>
			<TH align="left" valign="TOP">AA-Comments:</TH>
			<TD align="left" valign="TOP" colspan="2"><DIV>#ListCustomers.AA_COMMENTS#</DIV></TD>
		</CFIF>
		</TR>
		<TR>
			<TD colspan="10"><HR width="100%" size="5" noshade /></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="10"><H2>#ListCustomers.RecordCount# Customer records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/libshareddata/shareddatadbreports.cfm" method="POST">
			<TD align="left">
               	<BR /><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="10"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFOUTPUT>