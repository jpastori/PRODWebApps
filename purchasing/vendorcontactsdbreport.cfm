<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vendorcontactsdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Purchasing - Vendor Contacts Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/vendorcontactsdbreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Vendor Contacts Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Purchasing";
	
	
	function setMatchAll() {
		document.LOOKUP.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPVENDORCONTACT')>
	<CFSET CURSORFIELD = "document.LOOKUP.VENDORNAME.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
******************************************************************************************
* The following code is the Look Up Process for IDT Purchasing - Vendor Contacts Report. *
******************************************************************************************
 --->

<CFIF NOT IsDefined('URL.LOOKUPVENDORCONTACT')>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 400 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Purchasing - Vendor Contacts Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center"><H2>Type in partial values to choose report criteria. <BR /> 
			Checking an adjacent checkbox will Negate the data entered.</H2></TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
<CFFORM name="LOOKUP" action="/#application.type#apps/purchasing/vendorcontactsdbreport.cfm?LOOKUPVENDORCONTACT=FOUND" method="POST">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEVENDORNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VENDORNAME">Vendor</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECONTACTNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CONTACTNAME">Contact</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEVENDORNAME" id="NEGATEVENDORNAME" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="VENDORNAME" id="VENDORNAME" value="" align="LEFT" required="No" size="17" tabindex="3">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECONTACTNAME" id="NEGATECONTACTNAME" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="CONTACTNAME" id="CONTACTNAME" value="" align="LEFT" required="No" size="17" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPHONENUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PHONENUMBER">Phone Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEEMAILADDRESS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="EMAILADDRESS">E-Mail Address</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPHONENUMBER" id="NEGATEPHONENUMBER" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="PHONENUMBER" id="PHONENUMBER" value="" align="LEFT" required="No" size="16" tabindex="7">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEEMAILADDRESS" id="NEGATEEMAILADDRESS" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="EMAILADDRESS" id="EMAILADDRESS" value="" align="LEFT" required="No" size="16" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
               <TH align="LEFT" colspan="2">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="11">
			</TD>
               <TD align="LEFT" colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="left" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate </LABEL><BR>
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">(1) Type a single Date Modified or (2) a series of dates separated by commas,NO spaces or<BR />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="13">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="15">
			</TD>
		</TR>

		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH colspan="4"><H2>Click the radio button on the report you want to run. &nbsp;&nbsp;Only one report can be run at a time.</H2></TH>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE1" value="1" checked align="LEFT" required="No" tabindex="16"><LABEL for="REPORTCHOICE1">Vendor Contact Report By Vendor Name</LABEL>
			</TD>
			<TD align="LEFT" valign="top" colspan="2">
				<CFINPUT type="RADIO" name="REPORTCHOICE" id="REPORTCHOICE2" value="2" align="LEFT" required="No" tabindex="17"><LABEL for="REPORTCHOICE2">Vendor Contact Report By Vendor Contact Name</LABEL>
			</TD>
		</TR>
		<TR>
			<TD colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		
		</TR>
		<TR>
			<TH colspan="4"><H2>Clicking the "Match All" Button with no selections equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="18" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="19" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="20" /><BR>
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************************************
* The following code is the IDT Purchasing - Vendor Contacts Report Generation Process. *
*****************************************************************************************
 --->

	<CFSET SORTORDER = ARRAYNEW(1)>
	<CFSET SORTORDER[1] = 'V.VENDORNAME~ VC.CONTACTNAME'>
	<CFSET SORTORDER[2] = 'VC.CONTACTNAME'>
	<CFSET REPORTORDER = EVALUATE("SORTORDER[#FORM.REPORTCHOICE#]")>
	<CFSET REPORTORDER = ListChangeDelims(REPORTORDER, ",", "~")>
     
     <CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
		<CFSET MODIFIEDDATELIST = "NO">
		<CFSET MODIFIEDDATERANGE = "NO">
		<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) EQ 0 AND FIND(';', #FORM.MODIFIEDDATE#, 1) EQ 0>
			<CFSET FORM.MODIFIEDDATE = DateFormat(FORM.MODIFIEDDATE, 'DD-MMM-YYYY')>
		<CFELSE>
			<CFIF FIND(',', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATELIST = "YES">
			<CFELSEIF FIND(';', #FORM.MODIFIEDDATE#, 1) NEQ 0>
				<CFSET MODIFIEDDATERANGE = "YES">
				<CFSET FORM.MODIFIEDDATE = #REPLACE(FORM.MODIFIEDDATE, ";", ",")#>
			</CFIF>
			<CFSET MODIFIEDDATEARRAY = ListToArray(FORM.MODIFIEDDATE)>
			<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)# >
				<!--- MODIFIEDDATE FIELD #Counter# = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR> --->
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR><BR> --->
		<!--- MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="ListVendorContacts" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VC.VENDORCONTACTID, V.VENDORNAME, VC.CONTACTNAME, VC.PHONENUMBER, VC.FAXNUMBER, 
          		VC.EMAILADDRESS, VC.COMMENTS, VC.MODIFIEDBYID, VC.MODIFIEDDATE
		FROM		VENDORCONTACTS VC, VENDORS V
		WHERE	VC.VENDORCONTACTID > 0 AND
				V.VENDORID > 0 AND 
				VC.VENDORID = V.VENDORID AND (
		<CFIF #FORM.VENDORNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATEVENDORNAME")>
				NOT V.VENDORNAME LIKE UPPER('%#FORM.VENDORNAME#%') #LOGICANDOR#
			<CFELSE>
				V.VENDORNAME LIKE UPPER('%#FORM.VENDORNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CONTACTNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATECONTACTNAME")>
				NOT VC.CONTACTNAME LIKE UPPER('%#FORM.CONTACTNAME#%') #LOGICANDOR#
			<CFELSE>
				VC.CONTACTNAME LIKE UPPER('%#FORM.CONTACTNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.PHONENUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPHONENUMBER")>
				NOT VC.PHONENUMBER LIKE '%#FORM.PHONENUMBER#%' #LOGICANDOR#
			<CFELSE>
				VC.PHONENUMBER LIKE '%#FORM.PHONENUMBER#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.EMAILADDRESS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEEMAILADDRESS")>
				NOT VC.EMAILADDRESS LIKE LOWER('%#FORM.EMAILADDRESS#%') #LOGICANDOR#
			<CFELSE>
				VC.EMAILADDRESS LIKE LOWER('%#FORM.EMAILADDRESS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
          
		<CFIF #FORM.COMMENTS# NEQ "">
               <CFIF IsDefined("FORM.NEGATECOMMENTS")>
                    NOT VC.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
               <CFELSE>
                    VC.COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
               </CFIF>
          </CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
                    NOT VC.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               <CFELSE>
                    VC.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
                              <CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              NOT VC.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
                         </CFLOOP>
                         <CFSET FINALTEST = ">">
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                         NOT (VC.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         NOT VC.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               <CFELSE>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
                         (
                         <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                              <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              VC.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
                         </CFLOOP>
                         <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
                         VC.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                              (VC.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         VC.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>

				VC.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	#REPORTORDER#
	</CFQUERY>
	
	<CFIF #ListVendorContacts.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendorcontactsdbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>IDT Purchasing - Vendor Contacts Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/vendorcontactsdbreport.cfm" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListVendorContacts.RecordCount# Vendor Contact records were selected.</H2></TH>
		</TR>
     	<TR>
			<TD colspan="7"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TH align="CENTER">Vendor</TH>
			<TH align="CENTER">Contact</TH>
		<CFELSE>
			<TH align="CENTER">Contact</TH>
			<TH align="CENTER">Vendor</TH>
		</CFIF>
			<TH align="center">Phone Number</TH>
			<TH align="CENTER">Fax Number</TH>
			<TH align="CENTER">E-Mail Address</TH>
			<TH align="center" valign="TOP">Modified By</TH>
			<TH align="center" valign="TOP">Date Modified</TH>
		</TR>

	<CFLOOP query="ListVendorContacts">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = #ListVendorContacts.MODIFIEDBYID#
			ORDER BY	FULLNAME
		</CFQUERY>
          
          <TR>
			<TD align="left" colspan="7"><HR></TD>
		</TR>

		<TR>
		<CFIF #FORM.REPORTCHOICE# EQ 1>
			<TD align="left" valign="TOP"><DIV>#ListVendorContacts.VENDORNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendorContacts.CONTACTNAME#</DIV></TD>
		<CFELSE>
			<TD align="left" valign="TOP"><DIV>#ListVendorContacts.CONTACTNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendorContacts.VENDORNAME#</DIV></TD>
		</CFIF>
			<TD align="center" valign="TOP"><DIV>#ListVendorContacts.PHONENUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListVendorContacts.FAXNUMBER#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendorContacts.EMAILADDRESS#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListVendorContacts.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
          <TR>
			<TH align="CENTER">Comments:</TH>
               <TD align="left" valign="TOP" colspan="6"><DIV>#ListVendorContacts.COMMENTS#</DIV></TD>
		</TR>
		
	</CFLOOP>
     
     	<TR>
			<TD colspan="7"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListVendorContacts.RecordCount# Vendor Contact records were selected.</H2></TH>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/vendorcontactsdbreport.cfm" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TD colspan="7">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>