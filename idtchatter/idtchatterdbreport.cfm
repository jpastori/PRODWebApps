<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtchatterdbreport.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: IDT Chatter Report --->
<!-- Last modified by John R. Pastori on 06/24/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/idtchatterdbreport.cfm">
<CFSET CONTENT_UPDATED = "June 24, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>IDT Chatter Report</TITLE>

	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Chatter";


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateChatLookupField() {
		if (!document.LOOKUPCHAT.TEXTCHATKEY.value == "" && !document.LOOKUPCHAT.TEXTCHATKEY.value == " "
		 && !document.LOOKUPCHAT.TEXTCHATKEY.value.match(/^\d[0-9]/)) {
			alertuser ("An all numeric Chat key MUST be entered!");
			document.LOOKUPCHAT.TEXTCHATKEY.focus();
			return false;
		}
	}
	
	
	function setMatchAll() {
		document.LOOKUPCHAT.PROCESSLOOKUP.value = "Match All Fields Entered";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPCHAT')>
	<CFSET CURSORFIELD = "document.LOOKUPCHAT.TEXTCHATKEY.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<!--- 
*********************************************************************
* The following code is the Look Up Process for IDT Chatter Report. *
*********************************************************************
 --->
<CFIF NOT IsDefined('URL.LOOKUPCHAT')>

	<CFQUERY name="ListChatInfo" datasource="#application.type#IDTCHATTER">
          SELECT	ICI.CHATINFOID, ICI.CHATINFOTOPICID, ICT.TOPICID, ICT.TOPICINFO, ICI.CHATINFOSUBTOPICID, ICST.SUBTOPICID, 
                    ICST.SUBTOPICINFO,ICI.CHATTER, ICI.ORIGINATORID, CUST.FULLNAME, ICI.MODIFIEDBYID, ICI.MODIFIEDDATE,
                    ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO || ' - ' || ICI.CHATINFOID AS KEYFINDER
          FROM		IDTCHATTERINFO ICI, IDTCHATTOPICS ICT, IDTCHATSUBTOPICS ICST, LIBSHAREDDATAMGR.CUSTOMERS CUST
          WHERE	ICI.CHATINFOTOPICID = ICT.TOPICID  AND
                    ICI.CHATINFOSUBTOPICID = ICST.SUBTOPICID AND
                    ICI.ORIGINATORID = CUST.CUSTOMERID
          ORDER BY	KEYFINDER
     </CFQUERY>

     <CFQUERY name="ListChatSubTopics" datasource="#application.type#IDTCHATTER" blockfactor="100">
          SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICST.SUBTOPICINFO, ICT.TOPICID, ICT.TOPICINFO,
                    ICST.SUBTOPICINFO || ' - ' || ICT.TOPICINFO AS KEYFINDER
          FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
          WHERE	ICST.TOPICID = ICT.TOPICID
          ORDER BY	KEYFINDER
     </CFQUERY>
     
	<CFQUERY name="ListChatTopics" datasource="#application.type#IDTCHATTER" blockfactor="6">
          SELECT	TOPICID, TOPICINFO
          FROM		IDTCHATTOPICS
          ORDER BY	TOPICINFO
     </CFQUERY>
     
     <CFQUERY name="ListChatOriginator" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
          SELECT	CUST.CUSTOMERID, CUST.FIRSTNAME, CUST.LASTNAME, CUST.INITIALS, CUST.EMAIL, CUST.UNITID, U.GROUPID, CUST.CAMPUSPHONE,
                    CUST.FAX, CUST.FULLNAME, CUST.CATEGORYID, CUST.LOCATIONID, CUST.DEPTCHAIR, CUST.ALLOWEDTOAPPROVE
          FROM		CUSTOMERS CUST, UNITS U
          WHERE	(CUST.CUSTOMERID = 0 AND 
                    CUST.UNITID = U.UNITID) OR
                    (CUST.UNITID = U.UNITID AND
                    U.GROUPID = 4 AND
                    NOT (CUST.INITIALS IS NULL) AND
                    CUST.ACTIVE = 'YES')
          ORDER BY	CUST.FULLNAME
     </CFQUERY>
     
     <CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
          SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
                    DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
                    SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
          FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
          WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
                    CUST.ACTIVE = 'YES' AND
                    CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
                    DBS.DBSYSTEMNUMBER = 1300 AND
                    CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
                    SL.SECURITYLEVELNUMBER >= 30
          ORDER BY	CUST.FULLNAME
     </CFQUERY>


	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>IDT Chatter - Report Selection Lookup</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR align="center">
			<TH align="center">
				<H2>Select from the drop down boxes or type in partial values to choose report criteria. <BR /> 
					Checking an adjacent checkbox will Negate the selection or data entered.
				</H2>
			</TH>
		</TR>
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="2">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
	</TABLE>
	<BR />
<CFFORM name="LOOKUPCHAT" onsubmit="return validateChatLookupField();" action="/#application.type#apps/idtchatter/idtchatterdbreport.cfm?LOOKUPCHAT=FOUND" method="POST">
	<TABLE width="100%" align="LEFT">
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATETEXTCHATKEY">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				Enter a single<LABEL for="TEXTCHATKEY">Chat Key</LABEL> or <BR>two Chat Keys separated by a semicolon for range.
			</TH>
              <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHATTER">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHATTER">Chatter</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATETEXTCHATKEY" id="NEGATETEXTCHATKEY" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="TEXTCHATKEY" id="TEXTCHATKEY" value="" align="LEFT" required="No" size="10" tabindex="3">
			</TD>
               <TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECHATTER" id="NEGATECHATTER" value="" align="LEFT" required="No" tabindex="4">
			</TD>
               <TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="CHATTER" id="CHATTER" value="" align="LEFT" required="No" size="50" tabindex="5"><BR>
				<COM>(Enter a Word Or Exact Phrase.)</COM>
			</TD>
		</TR>
		<TR>
          	<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHATINFOSUBTOPICID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHATINFOSUBTOPICID">Sub-Topic</LABEL>
			</TH>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATECHATINFOTOPICID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CHATINFOTOPICID">Topic</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECHATINFOSUBTOPICID" id="NEGATECHATINFOSUBTOPICID" value="" align="LEFT" required="No" tabindex="6">
			</TD>
               <TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="CHATINFOSUBTOPICID" id="CHATINFOSUBTOPICID" size="1" query="ListChatSubTopics" value="SUBTOPICID" display="KEYFINDER" selected="0" required="No" tabindex="7"></CFSELECT><BR>
				<COM>(All Chatter by Sub-Topic. &nbsp;&nbsp;Note: Sub-Topics can be under more than one Topic.)</COM>
			</TD>
          	<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATECHATINFOTOPICID" id="NEGATECHATINFOTOPICID" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="CHATINFOTOPICID" id="CHATINFOTOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" selected="0" required="No" tabindex="9"></CFSELECT><BR>
				<COM>(All Chatter by Topic.)</COM>
			</TD>
		</TR>
		<TR>
               <TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEORIGINATORID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ORIGINATORID">Chat Originator</LABEL>
			</TH>
               <TH align="LEFT" valign="BOTTOM" width="5%">&nbsp;&nbsp;</TH>
               <TH align="left" valign="BOTTOM" width="45%">
               	<LABEL for="CHATSEEALSOINFO">See Also (Partial URL Lookup)</LABEL>
               </TH>
		</TR>
		<TR>
               <TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEORIGINATORID" id="NEGATEORIGINATORID" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="ORIGINATORID" id="ORIGINATORID" size="1" query="ListChatOriginator" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="11"></CFSELECT>
			</TD>
                <TD align="LEFT" width="5%" valign="TOP">&nbsp;&nbsp;</TD>
			<TD align="LEFT" width="45%" valign="TOP">
               	<CFINPUT type="Text" name="CHATSEEALSOINFO" id="CHATSEEALSOINFO" value="" align="LEFT" required="No" size="75" tabindex="12"><BR />
			</TD>
		</TR>
		<TR>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDBYID">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDBYID">Modified By</LABEL>
			</TH>
			<TH class="TH_negate" align="LEFT" valign="BOTTOM" width="5%">
				<LABEL for="NEGATEMODIFIEDDATE">Negate</LABEL><BR>
				&nbsp;Value 
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="MODIFIEDDATE">Enter (1) a single Modified Date or <BR />
				&nbsp;(2) a series of dates separated by by commas,NO spaces <BR />
				&nbsp;or (3) two dates separated by a semicolon for range.</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDBYID" id="NEGATEMODIFIEDBYID" value="" align="LEFT" required="No" tabindex="13">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" tabindex="14">
					<OPTION value="0">MODIFIED-BY</OPTION>
					<CFLOOP query="ListRecordModifier">
						<OPTION value=#CUSTOMERID#>#FULLNAME#</OPTION>
					</CFLOOP>
				</CFSELECT>
			</TD>
			<TD align="LEFT" width="5%" valign="TOP">
				<CFINPUT type="CheckBox" name="NEGATEMODIFIEDDATE" id="NEGATEMODIFIEDDATE" value="" align="LEFT" required="No" tabindex="15">
			</TD>
			<TD align="LEFT" width="45%" valign="TOP">
				<CFINPUT type="Text" name="MODIFIEDDATE" id="MODIFIEDDATE" value="" required="No" size="50" tabindex="16">
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
				<BR /><INPUT type="image" src="/images/buttonMatchANY.jpg" value="Match Any Field Entered" alt="Match Any Field Entered" tabindex="17" />
			</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4">
				<INPUT type="image" src="/images/buttonMatchALL.jpg" value="Match All Fields Entered" alt="Match All Fields Entered" OnClick="return setMatchAll();" tabindex="18" />
			</TD>
		</TR>
	</TABLE>
</CFFORM>
	<TABLE width="100%" align="LEFT">
		<TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm?logout=No" method="POST">
			<TD align="LEFT" valign="TOP" colspan="4">
				<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="19" />&nbsp;&nbsp;
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="LEFT" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFEXIT>

<CFELSE>

<!--- 
********************************************************************
* The following code is the IDT Chatter Report Generation Process. *
********************************************************************
 --->
 
 	<CFQUERY name="LookupChatSeeInfo" datasource="#application.type#IDTCHATTER">
          SELECT	SEEALSOID, CHATINFOID, CHATSEEALSOINFO
          FROM		CHATSEEALSO
          WHERE	CHATSEEALSOINFO LIKE ('%#FORM.CHATSEEALSOINFO#%')
          ORDER BY	CHATINFOID, SEEALSOID
     </CFQUERY>
     
     <CFIF #LookupChatSeeInfo.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("IDT Chatter See Also Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterdbreport.cfm" />
		<CFEXIT>
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
<!--- 		<CFLOOP INDEX="Counter" FROM=1 TO=#ArrayLen(MODIFIEDDATEARRAY)# >
				MODIFIEDDATE FIELD = #MODIFIEDDATEARRAY[COUNTER]#<BR><BR>
			</CFLOOP> --->
		</CFIF>
		<CFIF MODIFIEDDATERANGE EQ "YES">
			<CFSET BEGINMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[1]#, 'DD-MMM-YYYY')>
			<CFSET ENDMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[2]#, 'DD-MMM-YYYY')>
		</CFIF>
		<!--- MODIFIEDDATELIST = #MODIFIEDDATELIST#<BR><BR>
		MODIFIEDDATERANGE = #MODIFIEDDATERANGE#<BR><BR> --->
	</CFIF>

	<CFIF #FORM.PROCESSLOOKUP# EQ 'Match Any Field Entered'>
		<CFSET LOGICANDOR = "OR">
		<CFSET FINALTEST = "=">
	<CFELSEIF #FORM.PROCESSLOOKUP# EQ 'Match All Fields Entered'>
		<CFSET LOGICANDOR = "AND">
		<CFSET FINALTEST = ">">
	</CFIF>

	<CFQUERY name="LookupChatInfo" datasource="#application.type#IDTCHATTER">
          SELECT	ICI.CHATINFOID, ICI.CHATINFOTOPICID, ICT.TOPICID, ICT.TOPICINFO, ICI.CHATINFOSUBTOPICID, ICST.SUBTOPICID, 
                    ICST.SUBTOPICINFO, ICI.CHATTER, ICI.ORIGINATORID, CUST.FULLNAME AS ORIGINNAME, ICI.MODIFIEDBYID, MODBY.FULLNAME AS MODBYNAME,
                    ICI.MODIFIEDDATE, ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO || ' - ' || ICI.CHATINFOID AS KEYFINDER
          FROM		IDTCHATTERINFO ICI, IDTCHATTOPICS ICT, IDTCHATSUBTOPICS ICST, LIBSHAREDDATAMGR.CUSTOMERS CUST, LIBSHAREDDATAMGR.CUSTOMERS MODBY
          WHERE	(ICI.CHATINFOID> 0 AND
          		ICI.CHATINFOTOPICID = ICT.TOPICID  AND
                    ICI.CHATINFOSUBTOPICID = ICST.SUBTOPICID AND
                    ICI.ORIGINATORID = CUST.CUSTOMERID AND
                    ICI.MODIFIEDBYID = MODBY.CUSTOMERID) AND
				(
	<CFIF #FORM.TEXTCHATKEY# NEQ "">
		<CFIF FIND(';', #FORM.TEXTCHATKEY#, 1) NEQ 0>
			<CFSET FORM.TEXTCHATKEY= #REPLACE(FORM.TEXTCHATKEY, ";", ",")#>
			<CFSET TEXTCHATKEYARRAY = ListToArray(FORM.TEXTCHATKEY)>
			<CFSET BEGINCHATKEY = #TEXTCHATKEYARRAY[1]#>
			<CFSET ENDCHATKEY = #TEXTCHATKEYARRAY[2]#>
			<CFIF IsDefined("FORM.NEGATETEXTCHATKEY")>
                    NOT (ICI.CHATINFOID BETWEEN #val(BEGINCHATKEY)# AND #val(ENDCHATKEY)#) #LOGICANDOR#
               <CFELSE>
                    (ICI.CHATINFOID BETWEEN #val(BEGINCHATKEY)# AND #val(ENDCHATKEY)#) #LOGICANDOR#
               </CFIF>
		<CFELSE>
               <CFIF IsDefined("FORM.NEGATETEXTCHATKEY")>
                    NOT ICI.CHATINFOID = #val(FORM.TEXTCHATKEY)# #LOGICANDOR#
               <CFELSE>
                    ICI.CHATINFOID = #val(FORM.TEXTCHATKEY)# #LOGICANDOR#
               </CFIF>
          </CFIF>
	</CFIF>

		<CFIF #FORM.CHATTER# NEQ "">
               <CFIF IsDefined("FORM.NEGATECHATTER")>
                    NOT ICI.CHATTER LIKE UPPER('%#FORM.CHATTER#%') #LOGICANDOR#
               <CFELSE>
                    ICI.CHATTER LIKE UPPER('%#FORM.CHATTER#%') #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.CHATINFOSUBTOPICID# GT 0>
               <CFIF IsDefined("FORM.NEGATECHATINFOSUBTOPICID")>
                    NOT ICI.CHATINFOSUBTOPICID = #val(FORM.CHATINFOSUBTOPICID)# #LOGICANDOR#
               <CFELSE>
                    ICI.CHATINFOSUBTOPICID = #val(FORM.CHATINFOSUBTOPICID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF #FORM.CHATINFOTOPICID# GT 0>
               <CFIF IsDefined("FORM.NEGATECHATINFOTOPICID")>
                    NOT ICI.CHATINFOTOPICID = #val(FORM.CHATINFOTOPICID)# #LOGICANDOR#
               <CFELSE>
                    ICI.CHATINFOTOPICID = #val(FORM.CHATINFOTOPICID)# #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.ORIGINATORID# GT 0>
               <CFIF IsDefined("FORM.NEGATEORIGINATORID")>
                    NOT ICI.ORIGINATORID = #val(FORM.ORIGINATORID)# #LOGICANDOR#
               <CFELSE>
                    ICI.ORIGINATORID = #val(FORM.ORIGINATORID)# #LOGICANDOR#
               </CFIF>
          </CFIF>
          
          <CFIF #FORM.CHATSEEALSOINFO# NEQ "">
          		ICI.CHATINFOID IN (#ValueList(LookupChatSeeInfo.CHATINFOID)#) #LOGICANDOR#
          </CFIF>
          
		<CFIF #FORM.MODIFIEDBYID# GT 0>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDBYID")>
                    NOT ICI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               <CFELSE>
                    ICI.MODIFIEDBYID = #val(FORM.MODIFIEDBYID)# #LOGICANDOR#
               </CFIF>
          </CFIF>

          <CFIF "#FORM.MODIFIEDDATE#" NEQ ''>
               <CFIF IsDefined("FORM.NEGATEMODIFIEDDATE")>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFLOOP index="Counter" from=1 to=#ArrayLen(MODIFIEDDATEARRAY)#>
                              <CFSET FORMATMODIFIEDDATE =  DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              NOT ICI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') AND
                         </CFLOOP>
                         <CFSET FINALTEST = ">">
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                         NOT (ICI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         NOT ICI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               <CFELSE>
                    <CFIF MODIFIEDDATELIST EQ "YES">
                         <CFSET ARRAYCOUNT = (ArrayLen(MODIFIEDDATEARRAY) - 1)>
                         (
                         <CFLOOP index="Counter" from=1 to=#ARRAYCOUNT#>
                              <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[COUNTER]#, 'DD-MMM-YYYY')>
                              ICI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY') OR
                         </CFLOOP>
                         <CFSET FORMATMODIFIEDDATE = DateFormat(#MODIFIEDDATEARRAY[ArrayLen(MODIFIEDDATEARRAY)]#, 'DD-MMM-YYYY')>
                         ICI.MODIFIEDDATE = TO_DATE('#FORMATMODIFIEDDATE#', 'DD-MON-YYYY')) OR
                         <CFSET FINALTEST = "=">
                    <CFELSEIF MODIFIEDDATERANGE EQ "YES">
                              (ICI.MODIFIEDDATE BETWEEN TO_DATE('#BEGINMODIFIEDDATE#', 'DD-MON-YYYY') AND TO_DATE('#ENDMODIFIEDDATE#', 'DD-MON-YYYY')) #LOGICANDOR#
                    <CFELSE>
                         ICI.MODIFIEDDATE LIKE TO_DATE('#FORM.MODIFIEDDATE#', 'DD-MON-YYYY') #LOGICANDOR#
                    </CFIF>
               </CFIF>
          </CFIF>

				ICI.MODIFIEDBYID #FINALTEST# 0)
		ORDER BY	KEYFINDER
	</CFQUERY>

	<CFIF #LookupChatInfo.RecordCount# EQ 0>
		<SCRIPT language="JavaScript">
			<!-- 
				alert("IDT Chatter Records meeting the selected criteria were Not Found");
			--> 
		</SCRIPT>
		<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterdbreport.cfm" />
		<CFEXIT>
	</CFIF>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center">
				<H1>IDT Chatter Report</H1>
			</TH>
		</TR>
	</TABLE>
	<TABLE align="left" border="0">
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/idtchatterdbreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TH align="LEFT" colspan="2">
               	<H2>
               	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               	#LookupChatInfo.RecordCount# IDT Chatter records were selected.
                    </H2>
               </TH>
		</TR>

	<CFSET TOPICHEADER = "">
     <CFSET SUBTOPICHEADER = "">
	<CFLOOP query="LookupChatInfo">
     
     	<CFQUERY name="GetChatSeeInfo" datasource="#application.type#IDTCHATTER">
               SELECT	SEEALSOID, CHATINFOID, CHATSEEALSOINFO
               FROM		CHATSEEALSO
               WHERE	CHATINFOID = <CFQUERYPARAM value="#LookupChatInfo.CHATINFOID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	CHATINFOID, SEEALSOID
          </CFQUERY>

		<CFIF TOPICHEADER NEQ #LookupChatInfo.TOPICINFO#  OR SUBTOPICHEADER NEQ #LookupChatInfo.SUBTOPICINFO#>
			<CFSET TOPICHEADER = #LookupChatInfo.TOPICINFO#>
               <CFSET SUBTOPICHEADER = #LookupChatInfo.SUBTOPICINFO#>
          <TR>
			<TD colspan="2"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="left" nowrap><H5>Topic: &nbsp;&nbsp;#LookupChatInfo.TOPICINFO#</H5></TH>
               <TH align="left" nowrap><H5>Sub-Topic: &nbsp;&nbsp;#LookupChatInfo.SUBTOPICINFO#</H5></TH>
		</TR>
		</CFIF>
		<TR>
			<TH align="LEFT" valign="BOTTOM"><STRONG>Chat Key</STRONG></TH>
			<TH align="LEFT" valign="BOTTOM"><STRONG>Chatter</STRONG></TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP"><DIV>#LookupChatInfo.CHATINFOID#</DIV></TD>
			<TD align="LEFT" valign="TOP" colspan="2"><PRE>#LookupChatInfo.CHATTER#</PRE></TD>
		</TR>
		<TR>
			<TH align="LEFT" valign="BOTTOM"><STRONG>Chat Originator</STRONG></TH>
               <TH align="LEFT" valign="BOTTOM"><STRONG>See Also</STRONG></TH>
          </TR>
		<TR>
			<TD align="LEFT" valign="TOP"><DIV>#LookupChatInfo.ORIGINNAME#</DIV></TD>
               <TD align="left" valign="TOP" nowrap>
				<CFLOOP query="GetChatSeeInfo">
					#CHATSEEALSOINFO#<BR>
				</CFLOOP>
			</TD>
		</TR>
		<TR>
			
			<TH align="LEFT" valign="BOTTOM"><STRONG>Modified Date</STRONG></TH>
			<TH align="LEFT" valign="BOTTOM"><STRONG>Modified By</STRONG></TH>
		</TR>
		<TR>
			
			<TD align="LEFT" valign="TOP"><DIV>#DateFormat(LookupChatInfo.MODIFIEDDATE, "MM/DD/YYYY")#</DIV></TD>
			<TD align="LEFT" valign="TOP"><DIV>#LookupChatInfo.MODBYNAME#</DIV></TD>
		</TR>
          <TR>
			<TD colspan="2"><HR></TD>
		</TR>
	</CFLOOP>
          <TR>
			<TD colspan="2"><HR width="100%" size="5" noshade /></TD>
		</TR>
		<TR>
			<TH align="LEFT" colspan="2">
               	<H2>
               	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               	#LookupChatInfo.RecordCount# IDT Chatter records were selected.
                    </H2>
               </TH>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/idtchatter/idtchatterdbreport.cfm" method="POST">
			<TD align="left"><INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="2" /></TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>