<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: locationdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 03/02/2010 --->
<!--- Date in Production: 03/02/2010 --->
<!--- Module: Facilities - Location Report --->
<!-- Last modified by John R. Pastori on 05/06/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/locationdbreport.cfm">
<CFSET CONTENT_UPDATED = "May 07, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Facilities - Location Report</TITLE>
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined("URL.LOOKUPLOCATION")>
	<CFSET CURSORFIELD = "document.LOOKUP.BUILDINGNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFIF NOT IsDefined("URL.LOOKUPLOCATION")>
<!--- 
******************************************************************************
* The following code is the Look Up Process for Facilities Location Reports. *
******************************************************************************
 --->

	<CFQUERY name="LookupBuildings" datasource="#application.type#FACILITIES" blockfactor="15">
		SELECT	BUILDINGNAMEID, BUILDINGNAME, BUILDINGCODE, BUILDINGCODE || ' -- ' || BUILDINGNAME AS BUIDINGCODENAME
		FROM		BUILDINGNAMES
		ORDER BY	BUILDINGNAME
	</CFQUERY>

	<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOCATIONID, ROOMNUMBER
		FROM		LOCATIONS
		ORDER BY	ROOMNUMBER
	</CFQUERY>

	<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
		SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
				DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
				SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
		FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
		WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
				CUST.ACTIVE = 'YES' AND
				CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
				DBS.DBSYSTEMNUMBER = 100 AND
				CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
				SL.SECURITYLEVELNUMBER >= 20
		ORDER BY	CUST.FULLNAME
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Facilities Location Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center"><H2>Select from the drop down boxes or type in partial room number values to choose report criteria. <BR />
		  Checking an adjacent checkbox will Negate the selection or data entered.</H2></TH>
		</TR>
	</TABLE>
	<BR />
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="LOOKUP" action="/#application.type#apps/facilities/locationdbreport.cfm?LOOKUPLOCATION=FOUND" method="POST">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEBUILDING">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="BUILDINGNAMEID">Building Code -- Name</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEBUILDING" id="NEGATEBUILDING" value="" align="LEFT" required="No" tabindex="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="BUILDINGNAMEID" id="BUILDINGNAMEID" size="1" query="LookupBuildings" value="BUILDINGNAMEID" display="BUIDINGCODENAME" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEROOMNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LOCATIONID">
				(1) Select a Room Number or <LABEL for="ROOMNUMBER">(2) Enter a Room Number or <BR />
				&nbsp;(3) Enter a series of Room Numbers separated by commas,NO spaces.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEROOMNUMBER" id="NEGATEROOMNUMBER" value="" align="LEFT" required="No" tabindex="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="LOCATIONID" id="LOCATIONID" size="1" query="LookupRoomNumbers" value="LOCATIONID" display="ROOMNUMBER" selected="0" required="No" tabindex="5"></CFSELECT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<CFINPUT type="Text" name="ROOMNUMBER" id="ROOMNUMBER" value="" required="No" size="20" maxlength="50" tabindex="6">
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified-By</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="9">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="10">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="LookupRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">
				(1) a single Date Modified or (2) a series of dates separated by commas,NO spaces or<BR />
				&nbsp;(3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="11">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" width="45%">
				<CFINPUT type="Text" name="MODIFIEDDATE" value="" required="No" size="50" tabindex="12">
			</TD>
		</TR>
		<TR>
			<TD colspan="2">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH colspan="2"><HR align="left" width="100%" size="5" noshade /></TH>
		</TR>
		<TR>
			<TH align="center" colspan="2"><H2>Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2></TH>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" name="ProcessLookup" value="Match Any Field Entered" tabindex="13" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT">
				<INPUT type="submit" name="ProcessLookup" value="Match All Fields Entered" tabindex="14" />
			</TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="SUBMIT" value="Cancel" tabindex="15" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*****************************************************************
* The following code is the Location Report Generation Process. *
*****************************************************************
 --->
	<CFIF #FORM.ROOMNUMBER# NEQ "">
		<CFSET ROOMLIST = "NO">
		<CFIF FIND(',', #FORM.ROOMNUMBER#, 1) NEQ 0>
			<CFSET ROOMLIST = "YES">
			<CFSET FORM.ROOMNUMBER = UCASE(#FORM.ROOMNUMBER#)>
			<CFSET FORM.ROOMNUMBER = ListQualify(FORM.ROOMNUMBER,"'",",","CHAR")>
			ROOMNUMBER FIELD = #FORM.ROOMNUMBER#<BR /><BR />
		</CFIF>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
		<CFIF ROOMLIST EQ "YES">
			WHERE	ROOMNUMBER IN (#PreserveSingleQuotes(FORM.ROOMNUMBER)#)
		<CFELSE>
			WHERE	ROOMNUMBER LIKE (UPPER('#FORM.ROOMNUMBER#%'))
		</CFIF>
			ORDER BY	ROOMNUMBER
		</CFQUERY>
		<CFIF #LookupRoomNumbers.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Records having the selected Room Number were Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/istequipinventory/hardwareinventorydbreports.cfm" />
			<CFEXIT>
		</CFIF>
	<CFELSE>
		<CFQUERY name="LookupRoomNumbers" datasource="#application.type#FACILITIES">
			SELECT	LOCATIONID, ROOMNUMBER
			FROM		LOCATIONS
			ORDER BY	ROOMNUMBER
		</CFQUERY>
	</CFIF>

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
				MODIFIEDDATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR /><BR />
			</CFLOOP>
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR /><BR />
		MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR /><BR />
	</CFIF>

	<CFIF #FORM.ProcessLookup# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.ProcessLookup# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>
	<CFQUERY name="ListRoomNumbers" datasource="#application.type#FACILITIES" blockfactor="100">
		SELECT	LOC.LOCATIONID, LOC.ROOMNUMBER, LOC.BUILDINGNAMEID, BN.BUILDINGCODE || ' -- ' || BN.BUILDINGNAME AS BUIDINGCODENAME,
				LD.LOCATIONDESCRIPTIONID, LD.LOCATIONDESCRIPTION, LOC.NETWORKPORTCOUNT, LOC.NPORTDATECHKED,
				LOC.MODIFIEDBYID, LOC.MODIFIEDDATE
		FROM		LOCATIONS LOC, BUILDINGNAMES BN, LOCATIONDESCRIPTION LD
		WHERE	((LOC.LOCATIONID > 0 AND
				LOC.BUILDINGNAMEID = BN.BUILDINGNAMEID AND
				LOC.LOCATIONDESCRIPTIONID = LD.LOCATIONDESCRIPTIONID) AND (

			<CFIF #FORM.BUILDINGNAMEID# GT 0>
				<CFIF IsDefined("FORM.NEGATEBUILDING")>
					NOT LOC.BUILDINGNAMEID = <CFQUERYPARAM value="#FORM.BUILDINGNAMEID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				<CFELSE>
					LOC.BUILDINGNAMEID = <CFQUERYPARAM value="#FORM.BUILDINGNAMEID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.LOCATIONID# GT 0>
				<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
					NOT LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				<CFELSE>
					LOC.LOCATIONID = <CFQUERYPARAM value="#FORM.LOCATIONID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.ROOMNUMBER# NEQ "">
				<CFIF IsDefined("FORM.NEGATEROOMNUMBER")>
					NOT LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
				<CFELSE>
					LOC.LOCATIONID IN (#ValueList(LookupRoomNumbers.LOCATIONID)#) #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF #FORM.MODIFIEDBYID# GT 0>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
					NOT LOC.MODIFIEDBYID = <CFQUERYPARAM value="#FORM.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				<CFELSE>
					LOC.MODIFIEDBYID = <CFQUERYPARAM value="#FORM.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC"> #LOGICANDOR#
				</CFIF>
			</CFIF>

			<CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
				<CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
							<CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							NOT LOC.MODIFIEDDATE = TO_DATE(<CFQUERYPARAM value="#FORMATMODIFIEDDATE#" cfsqltype="CF_SQL_NUMERIC">, 'DD-MON-YYYY') AND
						</CFLOOP>
						<CFSET FINALTEST = ">">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
						NOT (LOC.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						NOT LOC.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				<CFELSE>
					<CFIF MODIFIEDDATELIST EQ "YES">
						<CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
						(
						<CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
							<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
							LOC.MODIFIEDDATE = TO_DATE(<CFQUERYPARAM value="#FORMATMODIFIEDDATE#" cfsqltype="CF_SQL_NUMERIC">, 'DD-MON-YYYY') OR
						</CFLOOP>
						<CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
						LOC.MODIFIEDDATE = TO_DATE('<CFQUERYPARAM value="#FORMATMODIFIEDDATE#" cfsqltype="CF_SQL_NUMERIC">, 'DD-MON-YYYY')) OR
						<CFSET FINALTEST = "=">
					<CFELSEIF MODIFIEDDATERANGE EQ "YES">
							(LOC.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
					<CFELSE>
						LOC.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
					</CFIF>
				</CFIF>
			</CFIF>

				LOC.LOCATIONNAME #FINALTEST# ' '))
		ORDER BY	BN.BUILDINGNAME, LOC.ROOMNUMBER
	</CFQUERY>

	<CFIF #ListRoomNumbers.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/facilities/locationdbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center"><H1>Facilities - Location Report</H1></TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/locationdbreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListRoomNumbers.RecordCount# location records were selected.<H2></H2></H2></TH>
		</TR>
		<TR>
			<TH align="center">Room Number</TH>
			<TH align="center">Building Code -- Name</TH>
			<TH align="center">Location Description</TH>
			<TH align="center">Network Port Count</TH>
			<TH align="center">NPort Date Last Checked</TH>
			<TH align="center" valign="TOP">Modified-By Name</TH>
			<TH align="center" valign="TOP">Date Modified</TH>
		</TR>
	<CFLOOP query="ListRoomNumbers">

		<CFQUERY name="LookupRecordModifier" datasource="#application.type#LIBSHAREDDATA">
			SELECT	CUSTOMERID, LASTNAME, FULLNAME
			FROM		CUSTOMERS
			WHERE	CUSTOMERID = <CFQUERYPARAM value="#ListRoomNumbers.MODIFIEDBYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	FULLNAME
		</CFQUERY>

		<TR>
			<TD align="center" valign="TOP"><DIV>#ListRoomNumbers.ROOMNUMBER#</DIV></TD>
			<TD align="center" valign="TOP" nowrap><DIV>#ListRoomNumbers.BUIDINGCODENAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListRoomNumbers.LOCATIONDESCRIPTION#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#ListRoomNumbers.NETWORKPORTCOUNT#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListRoomNumbers.NPORTDATECHKED, "MM/DD/YYYY")#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupRecordModifier.FULLNAME#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#DateFormat(ListRoomNumbers.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
		</TR>
		<TR>
			<TD>&nbsp;&nbsp;</TD>
		</TR>
	</CFLOOP>
		<TR>
			<TH align="CENTER" colspan="7"><H2>#ListRoomNumbers.RecordCount# location records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/locationdbreport.cfm" method="POST">
			<TD align="left"><INPUT type="submit" value="Cancel" tabindex="2" /></TD>
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