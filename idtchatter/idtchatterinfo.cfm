<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: idtchatterinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/12/2012 --->
<!--- Date in Production: 07/12/2012 --->
<!--- Module: Add/Modify/Delete Information in IDT Chatter --->
<!-- Last modified by John R. Pastori on 11/18/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/idtchatter/idtchatterinfo.cfm">
<CFSET CONTENT_UPDATED = "November 18, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information in IDT Chatter</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information in IDT Chatter</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="../webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Chatter";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateTopicLookupField() {
		if (document.LOOKUPTOPIC.TOPICID.selectedIndex == "0") {
			alertuser ("A Topic Record MUST be selected!");
			document.LOOKUPTOPIC.TOPICID.focus();
			return false;
		}
	}


	function validateReqFields() {

		if (document.IDTCHATTERINFO.CHATINFOTOPICID.selectedIndex == "0") {
			alertuser (document.IDTCHATTERINFO.CHATINFOTOPICID.name +  ",  A Topic MUST be selected!");
			document.IDTCHATTERINFO.CHATINFOTOPICID.focus();
			return false;
		}

		if (document.IDTCHATTERINFO.CHATINFOSUBTOPICID.selectedIndex == "0") {
			alertuser (document.IDTCHATTERINFO.CHATINFOSUBTOPICID.name +  ",  A Sub-Topic MUST be selected!");
			document.IDTCHATTERINFO.CHATINFOSUBTOPICID.focus();
			return false;
		}

		if (document.IDTCHATTERINFO.CHATTER.value == "" || document.IDTCHATTERINFO.CHATTER.value == " ") {
			alertuser (document.IDTCHATTERINFO.CHATTER.name +  ",  Chatter Info MUST be entered!");
			document.IDTCHATTERINFO.CHATTER.focus();
			return false;
		}

		if (document.IDTCHATTERINFO.ORIGINATORID.selectedIndex == "0") {
			alertuser (document.IDTCHATTERINFO.ORIGINATORID.name +  ", A chat originator MUST be selected!");
			document.IDTCHATTERINFO.ORIGINATORID.focus();
			return false;
		}
	}


	function validateChatLookupField() {
		if ((document.LOOKUPCHAT.TEXTCHATKEY.value == "" || document.LOOKUPCHAT.TEXTCHATKEY.value == " ")
		 && (document.LOOKUPCHAT.TOPICCHATINFOID.selectedIndex == "0")) {
			alertuser ("A Chat Info Record Key MUST be entered or selected!");
			document.LOOKUPCHAT.TOPICCHATINFOID.focus();
			return false;
		}
		
		
		if (!document.LOOKUPCHAT.TEXTCHATKEY.value == "" && !document.LOOKUPCHAT.TEXTCHATKEY.value == " "
		 && !document.LOOKUPCHAT.TEXTCHATKEY.value.match(/^\d[0-9]/)) {
			alertuser ("An all numeric Chat key MUST be entered!");
			document.LOOKUPCHAT.TEXTCHATKEY.focus();
			return false;
		}
	}

			
	
	function setDelete() {
		document.IDTCHATTERINFO.PROCESSIDTCHATTER.value = "DELETE";
		return true;
	}


//

</SCRIPT>
<SCRIPT language="JavaScript" src="../calendar_us.js"></SCRIPT>

<!--Script ends here -->

</HEAD>

<CFOUTPUT>

<CFIF NOT IsDefined('URL.LOOKUPCHATID') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUPCHAT.TEXTCHATKEY.focus()">
<CFELSEIF NOT IsDefined('URL.TOPICCHOSEN') AND URL.PROCESS EQ "ADD">
	<CFSET CURSORFIELD = "document.LOOKUPTOPIC.TOPICID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.IDTCHATTERINFO.CHATINFOSUBTOPICID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->


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
			DBS.DBSYSTEMNUMBER = 1400 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
*************************************************************************************
* The following code is the Topic Lookup Screen for the ADD Process of IDT Chatter. *
*************************************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'> 

	<CFIF NOT IsDefined('TOPICCHOSEN')>
     
		<CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
               <CFSET PROGRAMNAME = 'idtchatterinfo.cfm?PROCESS=#URL.PROCESS#&TOPICCHOSEN=YES&STAFFLOOP=YES'>
               <CFSET client.STAFFLOOP = 'YES'>
          <CFELSEIF IsDefined('URL.SRCALL') OR (IsDefined('client.SRCALL') AND #client.SRCALL# EQ 'YES')>
               <CFSET PROGRAMNAME = 'idtchatterinfo.cfm?PROCESS=#URL.PROCESS#&TOPICCHOSEN=YES&SRCALL=YES'>
               <CFSET client.SRCALL = 'YES'>
          <CFELSE>
          	<CFSET PROGRAMNAME = 'idtchatterinfo.cfm?PROCESS=#URL.PROCESS#&TOPICCHOSEN=YES'>
          </CFIF> 
		<TABLE width="100%" align="center" border="3">
               <TR align="center">
                    <TD align="center"><H1>Select Chat Topic To Add</H1></TD>
               </TR>
          </TABLE>
          <TABLE width="100%" align="center" border="0">
               <TR>
                    <TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
               </TR>
          </TABLE>
          <BR clear = "left" />
     
          <TABLE width="100%" align="LEFT">
               <TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
                    <TD align="left" colspan="2">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </TD>
</CFFORM>
               </TR>
<CFFORM name="LOOKUPTOPIC" onsubmit="return validateTopicLookupField();" action="/#application.type#apps/idtchatter/#PROGRAMNAME#" method="POST">
               <TR>
                    <TH align="left" width="30%" nowrap><H4><LABEL for="TOPICID">*Chat Topic:</LABEL></H4></TH>
                    <TD align="left" width="70%">
                         <CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" required="No" tabindex="2"></CFSELECT>
                    </TD>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
               <TR>
                    <TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
               </TR>
</CFFORM>
               <TR>
<CFFORM action="/#application.type#apps/idtchatter/index.cfm?logout=No" method="POST">
                    <TD align="left" colspan="2">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </TD>
</CFFORM>
               </TR>
               <TR>
                    <TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
               </TR>
          </TABLE>
          <CFEXIT>
     <CFELSE>
<!--- 
**********************************************************
* The following code is the ADD Process for IDT Chatter. *
**********************************************************
 --->
     
     	<CFQUERY name="LookupChatTopic" datasource="#application.type#IDTCHATTER" blockfactor="6">
               SELECT	TOPICID, TOPICINFO
               FROM		IDTCHATTOPICS
               WHERE	TOPICID = <CFQUERYPARAM value="#FORM.TOPICID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	TOPICINFO
          </CFQUERY>
 
         <CFQUERY name="LookupChatSubTopics" datasource="#application.type#IDTCHATTER" blockfactor="62">
               SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICT.TOPICID, ICT.TOPICINFO, ICST.SUBTOPICINFO
               FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
               WHERE	(ICST.SUBTOPICID = 0 OR
               		ICST.TOPICID = <CFQUERYPARAM value="#FORM.TOPICID#" cfsqltype="CF_SQL_NUMERIC">) AND
                         (ICST.TOPICID = ICT.TOPICID)
               ORDER BY	ICT.TOPICINFO, ICST.SUBTOPICINFO
         </CFQUERY>
          
     </CFIF>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#IDTCHATTER">
		SELECT	MAX(CHATINFOID) AS MAX_ID
		FROM		IDTCHATTERINFO
	</CFQUERY>
	<CFSET FORM.CHATINFOID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="CHATINFOID" secure="NO" value="#FORM.CHATINFOID#">

	<CFQUERY name="AddConfigMgmtRequestID" datasource="#application.type#IDTCHATTER">
		INSERT INTO	IDTCHATTERINFO (CHATINFOID)
		VALUES		(#val(Cookie.CHATINFOID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information in IDT Chatter</H1></TD>
		</TR>
	</TABLE>
     
     <CFIF ((IsDefined('URL.STAFFLOOP') AND #URL.STAFFLOOP# EQ 'YES') OR (IsDefined('client.STAFFLOOP') AND #client.STAFFLOOP# EQ 'YES'))>
		<CFSET PROGRAMNAME = 'processidtchatterinfo.cfm?STAFFLOOP=YES'>
          <CFSET client.STAFFLOOP = 'YES'>
     <CFELSEIF IsDefined('URL.SRCALL') OR (IsDefined('client.SRCALL') AND #client.SRCALL# EQ 'YES')>
          <CFSET PROGRAMNAME = 'processidtchatterinfo.cfm?SRCALL=YES'>
          <CFSET client.SRCALL = 'YES'>
     <CFELSE>
          <CFSET PROGRAMNAME = 'processidtchatterinfo.cfm'>
          <CFSET client.STAFFLOOP = 'NO'>
          <CFSET client.SRCALL = 'NO'>
     </CFIF>
     
	<TABLE width="100%" align="Left" border="0">
		<TR>
			<TH align="center" colspan="2">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center" colspan="2">
				IDT Chatter Key: &nbsp;&nbsp; #Cookie.CHATINFOID#
			</TH>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/idtchatter/#PROGRAMNAME#" method="POST">
				<INPUT type="hidden" name="PROCESSIDTCHATTER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
<CFFORM name="IDTCHATTERINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/#PROGRAMNAME#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" valign ="BOTTOM"><LABEL for="CHATINFOTOPICID">Topic</LABEL></TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="CHATINFOSUBTOPICID">*Sub-Topic</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP">
               	<INPUT type="hidden" name="CHATINFOTOPICID" value="#FORM.TOPICID#" />
				<STRONG>#LookupChatTopic.TOPICINFO#</STRONG>
			</TD>
			<TD align="left">
               	<CFSELECT name="CHATINFOSUBTOPICID" id="CHATINFOSUBTOPICID" size="1" query="LookupChatSubTopics" value="SUBTOPICID" display="SUBTOPICINFO" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign ="BOTTOM" colspan="2"><H4><LABEL for="CHATTER">*Chatter</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" valign ="TOP" colspan="2">
				<CFTEXTAREA name="CHATTER" id="CHATTER" wrap="VIRTUAL" rows="10" cols="100" tabindex="4"></CFTEXTAREA><BR />
			</TD>
		</TR>
		<TR>
          	<TH align="left" valign ="BOTTOM">See Also</TH>
			<TH align="left" valign ="BOTTOM"><H4><LABEL for="ORIGINATORID">*Chat Originator</LABEL></H4></TH>
		</TR>
		<TR>
          	<TD align="left" valign ="TOP">
				<LABEL for="CHATSEEALSOINFO1" class="LABEL_hidden">See Also 1</LABEL>
				<CFINPUT type="Text" name="CHATSEEALSOINFO1" id="CHATSEEALSOINFO1" value="" align="LEFT" required="No" size="75" tabindex="5"><BR />
				<LABEL for="CHATSEEALSOINFO2" class="LABEL_hidden">See Also 2</LABEL>
				<CFINPUT type="Text" name="CHATSEEALSOINFO2" id="CHATSEEALSOINFO2" value="" align="LEFT" required="No" size="75" tabindex="6"><BR />
				<LABEL for="CHATSEEALSOINFO3" class="LABEL_hidden">See Also 3</LABEL>
				<CFINPUT type="Text" name="CHATSEEALSOINFO3" id="CHATSEEALSOINFO3" value="" align="LEFT" required="No" size="75" tabindex="7"><BR />
			</TD>
			<TD align="left" valign ="TOP">
				<CFSELECT name="ORIGINATORID" id="ORIGINATORID" size="1" query="ListChatOriginator" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" required="No" tabindex="8"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="MODIFIEDBYID">*Modified By</LABEL></H4></TH>
			<TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="9"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
          	<TD align="left" colspan="2">
               	<INPUT type="hidden" name="PROCESSIDTCHATTER" value="ADD" />
                    <INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="10" />
			</TD>
		</TR>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/idtchatter/#PROGRAMNAME#" method="POST">
				<INPUT type="hidden" name="PROCESSIDTCHATTER" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="11" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
			</TD>
		</TR>
		
		<TR>
			<TD colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>
     <CFEXIT>

<CFELSE>

<!--- 
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting IDT Chatter. *
*************************************************************************************
 --->
     
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined('URL.LOOKUPCHATID')>
               <TD align="center"><H1>Modify/Delete Lookup Information in IDT Chatter</H1></TD>
          <CFELSE>
               <TD align="center"><H1>Modify/Delete Information in IDT Chatter</H1></TD>
          </CFIF>
          </TR>
     </TABLE>
     <TABLE width="100%" align="center" border="0">
          <TR>
               <TH align="center"><H4>* RED fields marked with asterisks are required!</H4></TH>
          </TR>
     </TABLE>
     
     <CFIF NOT IsDefined('URL.LOOKUPCHATID')>
          
          <CFQUERY name="LookupChatInfoByTopic" datasource="#application.type#IDTCHATTER">
     		SELECT	ICI.CHATINFOID, ICI.CHATINFOTOPICID, ICT.TOPICID, ICT.TOPICINFO, ICI.CHATINFOSUBTOPICID, ICST.SUBTOPICID, 
               		ICST.SUBTOPICINFO,ICI.CHATTER, ICI.ORIGINATORID, CUST.FULLNAME, ICI.MODIFIEDBYID, ICI.MODIFIEDDATE,
                         ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO || ' - ' || ICI.CHATINFOID AS TOPICFINDER
               FROM		IDTCHATTERINFO ICI, IDTCHATTOPICS ICT, IDTCHATSUBTOPICS ICST, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	ICI.CHATINFOTOPICID = ICT.TOPICID  AND
               		ICI.CHATINFOSUBTOPICID = ICST.SUBTOPICID AND
               		ICI.ORIGINATORID = CUST.CUSTOMERID
               ORDER BY	TOPICFINDER
          </CFQUERY>

          <TABLE width="100%" align="LEFT">
               <TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
                    <TD align="LEFT" colspan="2">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </TD>
</CFFORM>
               </TR>
<CFFORM name="LOOKUPCHAT" onsubmit="return validateChatLookupField();" action="/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPCHATID=FOUND" method="POST">
               <TR>
                    <TH align="LEFT">
                    	<H4><LABEL for="TEXTKEY">*Enter a Chat Key Number</LABEL></H4>
                    </TH>
               </TR>
               <TR>
                    <TD align="LEFT">
                        <CFINPUT type="Text" name="TEXTCHATKEY" id="TEXTCHATKEY" value="" align="LEFT" required="No" size="10" tabindex="2">
                    </TD>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
               <TR>
                    <TH align="LEFT">
                    	<H4><LABEL for="TOPICCHATINFOID">*Select by Topic - Sub-Topic - Key</LABEL></H4>
                    </TH>
               </TR>
               <TR>
                    <TD align="LEFT">
                         <CFSELECT name="TOPICCHATINFOID" id="TOPICCHATINFOID" size="1" query="LookupChatInfoByTopic" value="CHATINFOID" display="TOPICFINDER" required="No" tabindex="3"></CFSELECT>
                    </TD>
               </TR>
               <TR>
                    <TD align="LEFT">
                         <INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="4" /><BR />
                    </TD>
               </TR>
</CFFORM>
               <TR>
<CFFORM action="#Cookie.INDEXDIR#/index.cfm" method="POST">
                    <TD align="LEFT" colspan="2">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="5" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
                    </TD>
</CFFORM>
               </TR>
               <TR>
                    <TD colspan="2">
                         <CFINCLUDE template="/include/coldfusion/footer.cfm">
                    </TD>
               </TR>
          </TABLE>

	<CFELSE>

<!--- 
**************************************************************************
* The following code is the Modify and Delete Processes for IDT Chatter. *
**************************************************************************
 --->

		<CFIF IsDefined ('FORM.TOPICCHATINFOID') AND #FORM.TOPICCHATINFOID# GT 0>
          	<CFSET FORM.CHATINFOID = #FORM.TOPICCHATINFOID#>
          <CFELSEIF IsDefined ('URL.CHATINFOID') AND #URL.CHATINFOID# GT 0>
          	<CFSET FORM.CHATINFOID = #URL.CHATINFOID#>
          <CFELSE>
          	<CFSET FORM.CHATINFOID = #FORM.TEXTCHATKEY#>
          </CFIF>
 
		<CFQUERY name="GetChatInfo" datasource="#application.type#IDTCHATTER">
     		SELECT	ICI.CHATINFOID, ICI.CHATINFOTOPICID, ICT.TOPICID, ICT.TOPICINFO, ICI.CHATINFOSUBTOPICID, ICST.SUBTOPICID, 
               		ICST.SUBTOPICINFO,ICI.CHATTER, ICI.ORIGINATORID, CUST.FULLNAME AS ORIGINNAME, ICI.MODIFIEDBYID, ICI.MODIFIEDDATE,
                         ICT.TOPICINFO || ' - ' || ICST.SUBTOPICINFO || ' - ' || CUST.FULLNAME AS KEYFINDER
               FROM		IDTCHATTERINFO ICI, IDTCHATTOPICS ICT, IDTCHATSUBTOPICS ICST, LIBSHAREDDATAMGR.CUSTOMERS CUST
               WHERE	ICI.CHATINFOID = <CFQUERYPARAM value="#FORM.CHATINFOID#" cfsqltype="CF_SQL_NUMERIC"> AND
               		ICI.CHATINFOTOPICID = ICT.TOPICID  AND
               		ICI.CHATINFOSUBTOPICID = ICST.SUBTOPICID AND
               		ICI.ORIGINATORID = CUST.CUSTOMERID
               ORDER BY	KEYFINDER
          </CFQUERY>
          
          <CFIF #GetChatInfo.RecordCount# EQ 0>
			<SCRIPT language="JavaScript">
				<!-- 
					alert("Chat Record Not Found");
				--> 
			</SCRIPT>
			<META http-equiv="Refresh" content="0; URL=/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=MODIFYDELETE" />
			<CFEXIT>
		</CFIF>
          
          <CFQUERY name="GetChatSubTopics" datasource="#application.type#IDTCHATTER" blockfactor="100">
               SELECT	ICST.SUBTOPICID, ICST.TOPICID, ICT.TOPICID, ICT.TOPICINFO, ICST.SUBTOPICINFO
               FROM		IDTCHATSUBTOPICS ICST, IDTCHATTOPICS ICT
               WHERE	(ICST.SUBTOPICID = 0 OR
               		ICST.TOPICID = <CFQUERYPARAM value="#GetChatInfo.TOPICID#" cfsqltype="CF_SQL_NUMERIC">) AND
                         ICST.TOPICID = ICT.TOPICID
               ORDER BY	ICT.TOPICINFO, ICST.SUBTOPICINFO
         </CFQUERY>
          
          <CFQUERY name="GetChatSeeInfo" datasource="#application.type#IDTCHATTER" blockfactor="100">
               SELECT	SEEALSOID, CHATINFOID, CHATSEEALSOINFO
               FROM		CHATSEEALSO
               WHERE	CHATINFOID = <CFQUERYPARAM value="#FORM.CHATINFOID#" cfsqltype="CF_SQL_NUMERIC">
               ORDER BY	CHATINFOID, SEEALSOID
          </CFQUERY>

          <TABLE width="100%" align="Left" border="0">
               <TR>
                    <TH align="center" colspan="2">
                         IDT Chatter Key: &nbsp;&nbsp; #FORM.CHATINFOID#
                         <CFCOOKIE name="CHATINFOID" secure="NO" value="#GetChatInfo.CHATINFOID#">
                    </TH>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
               <TR>
                    <TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
                    </TD>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
<CFFORM name="IDTCHATTERINFO" onsubmit="return validateReqFields();" action="/#application.type#apps/idtchatter/processidtchatterinfo.cfm" method="POST" ENABLECAB="Yes">
               <TR>
                    <TH align="left" valign ="BOTTOM"><LABEL for="CHATINFOTOPICID">Topic</LABEL></TH>
                    <TH align="left" valign ="BOTTOM"><H4><LABEL for="CHATINFOSUBTOPICID">*Sub-Topic</LABEL></H4></TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                         <CFSELECT name="CHATINFOTOPICID" id="CHATINFOTOPICID" size="1" query="ListChatTopics" value="TOPICID" display="TOPICINFO" selected="#GetChatInfo.CHATINFOTOPICID#" required="No" tabindex="2"></CFSELECT>
                    </TD>
                    <TD align="left">
                         <CFSELECT name="CHATINFOSUBTOPICID" id="CHATINFOSUBTOPICID" size="1" query="GetChatSubTopics" value="SUBTOPICID" display="SUBTOPICINFO" selected="#GetChatInfo.CHATINFOSUBTOPICID#" required="No" tabindex="3"></CFSELECT>
                    </TD>
               </TR>
               <TR>
                    <TH align="left" valign ="BOTTOM" colspan="2"><H4><LABEL for="CHATTER">*Chatter</LABEL></H4></TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP" colspan="2">
                         <CFTEXTAREA name="CHATTER" id="CHATTER" wrap="VIRTUAL" rows="10" cols="100" tabindex="4">#GetChatInfo.CHATTER#</CFTEXTAREA><BR />
                    </TD>
               </TR>
               <TR>
                    <TH align="left" valign ="BOTTOM">See Also</TH>
                    <TH align="left" valign ="BOTTOM"><LABEL for="ORIGINATORID">Chat Originator</LABEL></TH>
               </TR>
               <TR>
                    <TD align="left" valign ="TOP">
                    	<CFIF GetChatSeeInfo.Recordcount GT 0>
						<CFSET COUNTER = 0>
                              <CFSET TAB = 0>
                              <CFLOOP query="GetChatSeeInfo">
                                   <CFSET COUNTER = #COUNTER# + 1>
                                   <CFSET TAB = #Counter# + 4>
                                   <LABEL for="CHATSEEALSOINFO#Counter#" class="LABEL_hidden">See Also #Counter#</LABEL>
                                   <CFINPUT type="Text" name="CHATSEEALSOINFO#Counter#" id="CHATSEEALSOINFO#Counter#" value="#GetChatSeeInfo.CHATSEEALSOINFO#" align="LEFT" required="No" size="75" tabindex="#val(TAB)#"><BR />
                              </CFLOOP>
                         </CFIF>
                         <CFIF GetChatSeeInfo.Recordcount EQ 0>
                         	<LABEL for="CHATSEEALSOINFO1" class="LABEL_hidden">See Also 1</LABEL>
                         	<CFINPUT type="Text" name="CHATSEEALSOINFO1" id="CHATSEEALSOINFO1" value="" align="LEFT" required="No" size="75" tabindex="5"><BR />
                         </CFIF>
                         <CFIF GetChatSeeInfo.Recordcount LT 2>
                         	<LABEL for="CHATSEEALSOINFO2" class="LABEL_hidden">See Also 2</LABEL>
                         	<CFINPUT type="Text" name="CHATSEEALSOINFO2" id="CHATSEEALSOINFO2" value="" align="LEFT" required="No" size="75" tabindex="6"><BR />
                         </CFIF>
                         <CFIF GetChatSeeInfo.Recordcount LT 3>
                         	<LABEL for="CHATSEEALSOINFO3" class="LABEL_hidden">See Also 3</LABEL>
                         	<CFINPUT type="Text" name="CHATSEEALSOINFO3" id="CHATSEEALSOINFO3" value="" align="LEFT" required="No" size="75" tabindex="7"><BR />
                         </CFIF>
                    </TD>
                    <TD align="left" valign ="TOP">
                         #GetChatInfo.ORIGINNAME#
                    </TD>
               </TR>
               <TR>
                    <TH align="left"><LABEL for="MODIFIEDBYID"><H4>*Modified By</H4></LABEL></TH>
                    <TH align="left">Modified Date</TH>
               </TR>
               <TR>
                    <TD align="left" valign="TOP">
                         <CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="9"></CFSELECT>
                    </TD>
                    <TD align="left">
                         <CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
                         <INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
                         #DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
                    </TD>
               </TR>
               <TR>
                    <TD align="left">&nbsp;&nbsp;</TD>
               </TR>
               <TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSIDTCHATTER" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="10" />
                    </TD>
			</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="11" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
               <TR>
                    <TD align="LEFT" colspan="2">
<CFFORM action="/#application.type#apps/idtchatter/idtchatterinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
                         <INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="12" /><BR />
                         <COM>(Please DO NOT use the Browser's Back Button.)</COM>
</CFFORM>
                    </TD>
               </TR>
               
               <TR>
                    <TD colspan="2">
                         <CFINCLUDE template="/include/coldfusion/footer.cfm">
                    </TD>
               </TR>
          </TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>