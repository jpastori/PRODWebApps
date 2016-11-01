<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: vendordbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/11/2012 --->
<!--- Date in Production: 07/11/2012 --->
<!--- Module: IDT Purchasing - Vendors Report --->
<!-- Last modified by John R. Pastori on 07/11/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/vendordbreport.cfm">
<CFSET CONTENT_UPDATED = "July 11, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Vendors Report</TITLE>
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
<CFIF NOT IsDefined("URL.LOOKUPVENDOR")>
	<CFSET CURSORFIELD = "document.LOOKUP.VENDORNAME.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************************
* The following code is the Look Up Process for IDT Purchasing - Vendor Report. *
*********************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPVENDOR")>

	<CFQUERY name="ListStates" datasource="#application.type#LIBSHAREDDATA" blockfactor="60">
          SELECT	STATEID, STATECODE, STATENAME, STATECODE || ' - ' || STATENAME AS STATECODENAME
          FROM		STATES
          ORDER BY	STATECODE
     </CFQUERY>

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
			<TH align="center"><H1>IDT Purchasing - Vendor Lookup</H1></TH>
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
<CFFORM name="LOOKUP" action="/#application.type#apps/purchasing/vendordbreport.cfm?LOOKUPVENDOR=FOUND" method="POST">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEVENDORNAME">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VENDORNAME">Vendor</LABEL>
               </TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEWEBSITE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WEBSITE">Web Site</LABEL>
			</TH>
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
				<CFINPUT type="CheckBox" name="NEGATEWEBSITE" id="NEGATEWEBSITE" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="WEBSITE" id="WEBSITE" value="" align="LEFT" required="No" size="16" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
          <TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECITY">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" width="45%">
               	<LABEL for="CITY">City</LABEL>
               </TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATESTATEID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" width="45%">
               	<LABEL for="STATEID">State</LABEL>
               </TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECITY" id="NEGATECITY" value="" align="LEFT" required="No" tabindex="6">
			</TD>			
               <TD align="left" width="45%">
				<CFINPUT type="Text" name="CITY" id="CITY" value="" align="LEFT" required="No" size="50" tabindex="7">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATESTATEID" id="NEGATESTATEID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
               <TD align="left" width="45%">
				<CFSELECT name="STATEID" id="STATEID" size="1" query="ListStates" value="STATEID" display="STATECODENAME" required="No" tabindex="9"></CFSELECT>
			</TD>
		</TR>

		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPRODUCTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PRODUCTS">Product</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECOMMENTS">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPRODUCTS" id="NEGATEPRODUCTS" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="PRODUCTS" id="PRODUCTS" value="" align="LEFT" required="No" size="16" tabindex="11">
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATECOMMENTS" id="NEGATECOMMENTS" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="COMMENTS" id="COMMENTS" value="" align="LEFT" required="No" size="50" tabindex="13">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
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
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="15">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="17">
			</TD>
		</TR>

		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH colspan="4"><HR align="left" width="100%" size="5" noshade /></TH>
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
********************************************************************************
* The following code is the IDT Purchasing - Vendor Report Generation Process. *
********************************************************************************
 --->
 
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

	<CFQUERY name="ListVendors" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	VENDORID, VENDORNAME, ADDRESSLINE1, ADDRESSLINE2, CITY, STATEID, ZIPCODE, COUNTRY, WEBSITE, PRODUCTS, COMMENTS,
				MODIFIEDBYID, MODIFIEDDATE
		FROM		VENDORS
		WHERE	VENDORID > 0 AND (
		<CFIF #FORM.VENDORNAME# NEQ "">
			<CFIF IsDefined("FORM.NEGATEVENDORNAME")>
				NOT VENDORNAME LIKE UPPER('%#FORM.VENDORNAME#%') #LOGICANDOR#
			<CFELSE>
				VENDORNAME LIKE UPPER('%#FORM.VENDORNAME#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.WEBSITE# NEQ "">
			<CFIF IsDefined("FORM.NEGATEWEBSITE")>
				NOT WEBSITE LIKE '%#FORM.WEBSITE#%' #LOGICANDOR#
			<CFELSE>
				WEBSITE LIKE '%#FORM.WEBSITE#%' #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.CITY# NEQ "">
			<CFIF IsDefined("FORM.NEGATECITY")>
				NOT CITY LIKE UPPER('%#FORM.CITY#%') #LOGICANDOR#
			<CFELSE>
				CITY LIKE UPPER('%#FORM.CITY#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

		<CFIF #FORM.STATEID# GT 0>
               <CFIF IsDefined("FORM.NEGATESTATEID")>
                    NOT STATEID = #val(FORM.STATEID)# #LOGICANDOR#
               <CFELSE>
                    STATEID = #val(FORM.STATEID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

		<CFIF #FORM.PRODUCTS# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPRODUCTS")>
				NOT PRODUCTS LIKE UPPER('%#FORM.PRODUCTS#%') #LOGICANDOR#
			<CFELSE>
				PRODUCTS LIKE UPPER('%#FORM.PRODUCTS#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
          
          <CFIF #FORM.COMMENTS# NEQ "">
               <CFIF IsDefined("FORM.NEGATECOMMENTS")>
                    NOT COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
               <CFELSE>
                    COMMENTS LIKE UPPER('%#FORM.COMMENTS#%') #LOGICANDOR#
               </CFIF>
          </CFIF>

		<CFIF #FORM.MODIFIEDBYID# GT 0>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
                    NOT MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               <CFELSE>
                    MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
                              <CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              NOT MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
                         </CFLOOP>
                         <CFSET FINALTEST = ">">
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                         NOT (MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         NOT MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               <CFELSE>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
                         (
                         <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                              <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
                         </CFLOOP>
                         <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
                         MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                              (MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>

				MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	VENDORNAME
	</CFQUERY>
	
	<CFIF #ListVendors.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/vendordbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>IDT Purchasing - Vendors Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" border="0">
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/vendordbreport.cfm" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="11"><H2>#ListVendors.RecordCount# Vendor records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="CENTER">Vendor</TH>
			<TH align="CENTER">Address Line 1</TH>
			<TH align="CENTER">Address Line 2</TH>
			<TH align="CENTER">City</TH>
			<TH align="CENTER">State</TH>
			<TH align="CENTER">Zip Code</TH>
			<TH align="CENTER">Country</TH>
			<TH align="CENTER">Web Site</TH>
			<TH align="CENTER">Products</TH>
			<TH align="CENTER" valign="TOP">Modified By</TH>
			<TH align="CENTER" valign="TOP">Date Modified</TH>
		</TR>
	<CFLOOP query="ListVendors">

		<CFQUERY name="ListStateCode" datasource="#application.type#LIBSHAREDDATA">
			SELECT	STATEID, STATECODE || ' - ' || STATENAME AS STATECODENAME
			FROM		STATES
			WHERE	STATEID = <CFQUERYPARAM value="#ListVendors.STATEID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	STATECODE
		</CFQUERY>

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListVendors.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<TR>
			<TD align="left" valign="TOP"><DIV>#ListVendors.VENDORNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.ADDRESSLINE1#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.ADDRESSLINE2#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.CITY#</DIV></TD>
			<TD align="left" valign="TOP" nowrap><DIV>#ListStateCode.STATECODENAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListVendors.ZIPCODE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.COUNTRY#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.WEBSITE#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#ListVendors.PRODUCTS#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="left" valign="TOP"><DIV>#DateFormat(ListVendors.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
          <TR>
			<TH align="CENTER" valign="TOP">Comments:&nbsp;&nbsp;</TH>
               <TD align="left" valign="TOP" colspan="10">#ListVendors.COMMENTS#</TD>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="11"><HR></TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="11"><H2>#ListVendors.RecordCount# Vendor records were selected.</H2></TH>
		</TR>
		<TR>
	<CFFORM action="/#application.type#apps/purchasing/vendordbreport.cfm" method="POST">
			<TD align="LEFT">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
	</CFFORM>
		</TR>
		<TR>
			<TD colspan="11">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>