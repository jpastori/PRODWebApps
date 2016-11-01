<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: reqlinelookupreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/24/2012 --->
<!--- Date in Production: 07/24/2012 --->
<!--- Module: IDT Purchasing - Requisition Line Lookup Report --->
<!-- Last modified by John R. Pastori on 11/07/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/purchasing/reqlinelookupreport.cfm">
<CFSET CONTENT_UPDATED = "November 07 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Purchasing - Requisition Line Lookup Report</TITLE>
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
<CFIF NOT IsDefined('URL.LOOKUPREQLINE')>
	<CFSET CURSORFIELD = "document.LOOKUP.PARTNUMBER.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
**************************************************************************************************
* The following code is the Look Up Process for IDT Purchasing - Requisition Line Lookup Report. *
**************************************************************************************************
 --->

<CFIF NOT IsDefined("URL.LOOKUPREQLINE")>
	
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Purchasing - Requisition Line Lookup Report</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH  align="center">
				<H2>Type in values to choose report criteria. <BR />
				Checking an adjacent checkbox will Negate the selection or data entered.</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
     <FIELDSET>
	<LEGEND>Criteria Selection</LEGEND>
<CFFORM name="LOOKUP" action="/#application.type#apps/purchasing/reqlinelookupreport.cfm?LOOKUPREQLINE=FOUND" method="POST">
	<TABLE width="100%" align="LEFT" >
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEPARTNUMBER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PARTNUMBER">Part Number - Type a full or partial Part Number</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATELINEDESCRIPTION">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="LINEDESCRIPTION">Line Description - Type a word or phrase.</LABEL><BR />
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATEPARTNUMBER" id="NEGATEPARTNUMBER" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="PARTNUMBER" id="PARTNUMBER" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="3">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="NEGATELINEDESCRIPTION" id="NEGATELINEDESCRIPTION" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="LINEDESCRIPTION" id="LINEDESCRIPTION" value="" align="LEFT" required="No" size="25" maxlength="50" tabindex="5">
			</TD>
		</TR>
		<TR>
			<TD colspan="4">&nbsp;&nbsp;</TD>
		</TR>
	</TABLE>
     </FIELDSET>
     <BR />
     <FIELDSET>
     <LEGEND>Report Selection</LEGEND>
     <TABLE width="100%" border="0">
		<TR>
			<TH align="center" colspan="4"><H2>Clicking the "Match All" Button with no selection equals ALL records for the requested report.</H2></TH>
		</TR>
          <TR>
			<TD align="LEFT" colspan="4">
               	<INPUT type="hidden" name="PROCESSLOOKUP" value="Match Any Field Entered" />
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="6" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="7" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>

     </FIELDSET>
     <BR />
     <TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR />
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
*************************************************************************************************
* The following code is the IDT Purchasing - Requisition Line Lookup Report Generation Process. *
*************************************************************************************************
 --->
 
 	<CFSET REPORTTITLE2 = "">

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupPurchReqLines" datasource="#application.type#PURCHASING" blockfactor="100">
		SELECT	PRL.PURCHREQLINEID, PR.FISCALYEARID, FY.FISCALYEAR_4DIGIT, PR.REQNUMBER, PRL.LINENUMBER, 
				PRL.PARTNUMBER, PRL.LINEDESCRIPTION, PR.PURCHREQID, PR.IDTREVIEWERID 
		FROM		PURCHREQLINES PRL, PURCHREQS PR, LIBSHAREDDATAMGR.FISCALYEARS FY
		WHERE	(PRL.PURCHREQLINEID > 0 AND
				PRL.PURCHREQID = PR.PURCHREQID AND 
				PR.FISCALYEARID = FY.FISCALYEARID) AND (
		<CFIF #FORM.PARTNUMBER# NEQ "">
			<CFIF IsDefined("FORM.NEGATEPARTNUMBER")>
				NOT (PRL.PARTNUMBER LIKE UPPER('%#FORM.PARTNUMBER#%')) #LOGICANDOR#
			<CFELSE>
				PRL.PARTNUMBER LIKE UPPER('%#FORM.PARTNUMBER#%') #LOGICANDOR#
			</CFIF>
		</CFIF>
		
		<CFIF #FORM.LINEDESCRIPTION# NEQ "">
			<CFIF IsDefined("FORM.NEGATELINEDESCRIPTION")>
				NOT (PRL.LINEDESCRIPTION LIKE UPPER('%#FORM.LINEDESCRIPTION#%')) #LOGICANDOR#
			<CFELSE>
				PRL.LINEDESCRIPTION LIKE UPPER('%#FORM.LINEDESCRIPTION#%') #LOGICANDOR#
			</CFIF>
		</CFIF>

				PR.IDTREVIEWERID #FINALTEST# 0)
		ORDER BY	FY.FISCALYEAR_4DIGIT, PR.REQNUMBER, PRL.LINENUMBER
	</CFQUERY>

	<CFIF #LookupPurchReqLines.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/purchasing/reqlinelookupreport.cfm" />
		<CFEXIT>
	</CFIF>
     
     <CFIF #FORM.PARTNUMBER# NEQ "">
     	<CFSET REPORTTITLE2 = "Part Number = #FORM.PARTNUMBER#">
     <CFELSEIF #FORM.LINEDESCRIPTION# NEQ "">     
          <CFSET REPORTTITLE2 = "Line Description = #FORM.LINEDESCRIPTION#">
	<CFELSE>
     	<CFSET REPORTTITLE2 = "">
     </CFIF>
 
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD  align="center">
               	<H1>IDT Purchasing - Requisition Line Report</H1>
			<CFIF REPORTTITLE2 NEQ "">
                    <H2>For Criteria: #REPORTTITLE2# </H2>
               </CFIF>
               </TD>
		</TR>
	</TABLE>
	<BR />
	<TABLE border="0">
		<TR>
<CFFORM action="/#application.type#apps/purchasing/reqlinelookupreport.cfm" method="POST">
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupPurchReqLines.RecordCount# Requisition Line records were selected.</H2></TH>
		</TR>
		<TR>
			<TH align="center">Requisition Number</TH>
			<TH align="center">Line Number</TH>
			<TH align="center">Part Number</TH>
			<TH align="center">Line Description</TH>
		</TR>

		<cfset #COMPAREFY# = "">
	<CFLOOP query="LookupPurchReqLines">
		<CFIF #COMPAREFY# NEQ #LookupPurchReqLines.FISCALYEAR_4DIGIT#>
			<cfset #COMPAREFY# = "#LookupPurchReqLines.FISCALYEAR_4DIGIT#">
		<TR>
			<TD align="LEFT" colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="left">Fiscal Year: #LookupPurchReqLines.FISCALYEAR_4DIGIT#</TH>
		</TR>
		</CFIF>
		<TR>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqLines.REQNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqLines.LINENUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqLines.PARTNUMBER#</DIV></TD>
			<TD align="center" valign="TOP"><DIV>#LookupPurchReqLines.LINEDESCRIPTION#</DIV></TD>
			
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><HR> </TD>
		</TR> 
	</CFLOOP>
		<TR>
			<TD align="LEFT" colspan="4"><HR align="left" width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="CENTER" colspan="4"><H2>#LookupPurchReqLines.RecordCount# Requisition Line records were selected.</H2></TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/purchasing/reqlinelookupreport.cfm" method="POST">
			<TD align="left" colspan="4">
               	<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" />
               </TD>
</CFFORM>
		</TR>
		<TR>
			<TD colspan="4">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>