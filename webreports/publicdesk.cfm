<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: publicdesk.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 08/03/2012 --->
<!--- Date in Production: 08/03/2012 --->
<!--- Module: Add/Modify/Delete Information to Web Reports - Public Desk--->
<!-- Last modified by John R. Pastori on 08/03/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/webreports/publicdesk.cfm">
<CFSET CONTENT_UPDATED = "August 03, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Web Reports - Public Desk</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Web Reports - Public Desk</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Web Reports - Public Desk";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}

	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {

		if (document.PUBLICDESK.TOPICID.selectedIndex == "0") {
			alertuser (document.PUBLICDESK.TOPICID.name +  ",  A Topic MUST be selected!");
			document.PUBLICDESK.TOPICID.focus();
			return false;
		}

		if (document.PUBLICDESK.SUBTOPICID.selectedIndex == "0") {
			alertuser (document.PUBLICDESK.SUBTOPICID.name +  ",  A SubTopic MUST be selected!");
			document.PUBLICDESK.SUBTOPICID.focus();
			return false;
		}

		if (document.PUBLICDESK.CONTACTTIMEID.selectedIndex == "0") {
			alertuser (document.PUBLICDESK.CONTACTTIMEID.name +  ",  A Contact Time MUST be selected!");
			document.PUBLICDESK.CONTACTTIMEID.focus();
			return false;
		}

		if (document.PUBLICDESK.CONTACTID.selectedIndex == "0") {
			alertuser (document.PUBLICDESK.CONTACTID.name +  ",  A Contact Name MUST be selected!");
			document.PUBLICDESK.CONTACTID.focus();
			return false;
		}

	}

		function validateLookupFields() {
		if (document.LOOKUP.PUBLICDESKID.selectedIndex == "0") {
			alertuser (document.LOOKUP.PUBLICDESKID.name +  ",  A Public Desk Topic MUST be selected!");
			document.LOOKUP.PUBLICDESKID.focus();
			return false;
		}

	}


	function setDelete() {
		document.PUBLICDESK.PROCESSPUBLICDESK.value = "DELETE";
		return true;
	}


//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPPUBLICDESK') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.PUBLICDESKID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.PUBLICDESK.TOPICID.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">

<CFIF NOT IsDefined('URL.PROCESS')>
	<CFSET URL.PROCESS = "ADD">
</CFIF>

<BR clear="left" />

<!--- 
*********************************************************
* The following code are the queries for all Processes. *
*********************************************************
 --->

<CFQUERY name="ListPDTopic" datasource="#application.type#WEBREPORTS" blockfactor="29">
	SELECT	TOPICID, TOPIC
	FROM		PDTOPIC
	ORDER BY	TOPIC
</CFQUERY>

<CFQUERY name="ListPDSubTopic" datasource="#application.type#WEBREPORTS" blockfactor="31">
	SELECT	SUBTOPICID, SUBTOPIC
	FROM		PDSUBTOPIC
	ORDER BY	SUBTOPIC
</CFQUERY>

<CFQUERY name="ListPDContactTime" datasource="#application.type#WEBREPORTS" blockfactor="5">
	SELECT	CONTACTTIMEID, CONTACTTIME
	FROM		PDCONTACTTIME
	ORDER BY	CONTACTTIME
</CFQUERY>

<CFQUERY name="ListPDContacts" datasource="#application.type#WEBREPORTS" blockfactor="31">
	SELECT	CONTACTID, CONTACTNAME, DEPARTMENT, PHONE, EMAIL
	FROM		PDCONTACTS
	ORDER BY	CONTACTNAME
</CFQUERY>

<CFQUERY name="ListRecordModifier" datasource="#application.type#LIBSECURITY" blockfactor="100">
	SELECT	CAA.CUSTAPPACCESSID, CAA.CUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, CUST.ACTIVE, CAA.PASSWORD, CAA.DBSYSTEMID,
			DBS.DBSYSTEMID, DBS.DBSYSTEMNUMBER, DBS.DBSYSTEMNAME, CAA.SECURITYLEVELID, SL.SECURITYLEVELID, SL.SECURITYLEVELNUMBER,
			SL.SECURITYLEVELNAME, CUST.FULLNAME || '-' || DBS.DBSYSTEMNAME AS LOOKUPKEY
	FROM		CUSTOMERAPPACCESS CAA, LIBSHAREDDATAMGR.CUSTOMERS CUST, DBSYSTEMS DBS,SECURITYLEVELS SL
	WHERE	CAA.CUSTOMERID = CUST.CUSTOMERID AND
			CUST.ACTIVE = 'YES' AND
			CAA.DBSYSTEMID = DBS.DBSYSTEMID AND
			DBS.DBSYSTEMNUMBER = 900 AND
			CAA.SECURITYLEVELID = SL.SECURITYLEVELID AND
			SL.SECURITYLEVELNUMBER >= 30
	ORDER BY	CUST.FULLNAME
</CFQUERY>

<!--- 
*********************************************************
* The following code is the ADD Process for Public Desk *
*********************************************************
 --->
<CFIF URL.PROCESS EQ 'ADD'>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to Web Reports - Public Desk</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#WEBREPORTS">
		SELECT	MAX(PUBLICDESKID) AS MAX_ID
		FROM		PUBLICDESK
	</CFQUERY>
	<CFSET FORM.PUBLICDESKID =  #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="PUBLICDESKID" secure="NO" value="#FORM.PUBLICDESKID#">
	<CFQUERY name="AddPublicDeskID" datasource="#application.type#WEBREPORTS">
		INSERT INTO	PUBLICDESK (PUBLICDESKID)
		VALUES		(#val(Cookie.PUBLICDESKID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
		<TR>
			<TH align= "CENTER">
				Public Desk Key &nbsp; = &nbsp; #FORM.PUBLICDESKID#
			</TH>
		</TR>
	</TABLE>
	<BR />
	
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpublicdesk.cfm" method="POST">
			<TD align="left">
				<INPUT type="hidden" name="PROCESSPUBLICDESK" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
			</TD>
</CFFORM>
		</TR>
<CFFORM name="PUBLICDESK" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpublicdesk.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="TOPICID">*Topic</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="SUBTOPICID">*SubTopic</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListPDTopic" value="TOPICID" display="TOPIC" selected="0" required="No" tabindex="2"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="SUBTOPICID" id="SUBTOPICID" size="1" query="ListPDSubTopic" value="SUBTOPICID" display="SUBTOPIC" selected="0" required="No" tabindex="3"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="CONTACTTIMEID">*Contact Time (When)</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="CONTACTID">*Contact Name</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="CONTACTTIMEID" id="CONTACTTIMEID" size="1" query="ListPDContactTime" value="CONTACTTIMEID" display="CONTACTTIME" selected="0" required="No" tabindex="4"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSELECT name="CONTACTID" id="CONTACTID" size="1" query="ListPDContacts" value="CONTACTID" display="CONTACTNAME" selected="0" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="PUBDESKOPTIONS">Public Desk Options</LABEL></TH>
			<TH align="left"><LABEL for="IDTOPTIONS">IDT Options</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" >
				<TEXTAREA name="PUBDESKOPTIONS" id="PUBDESKOPTIONS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="7"> </TEXTAREA>
			</TD>
			<TD align="left" valign="TOP">
				<TEXTAREA name="IDTOPTIONS" id="IDTOPTIONS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="6"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><LABEL for="CIRCNOTIFY">Circulation Notifications</LABEL></TH>
			<TH align="left"><LABEL for="IDTNOTIFY">IDT Notifications</LABEL></TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<TEXTAREA name="CIRCNOTIFY" id="CIRCNOTIFY" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="8"> </TEXTAREA>
			</TD>
			<TD align="left" valign="TOP">
				<TEXTAREA name="IDTNOTIFY" id="IDTNOTIFY" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="9"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="CIRCCALLORDER">Circulation Call Order</LABEL></TH>
			<TH align="left"><LABEL for="IDTCALLORDER">IDT Call Order</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<TEXTAREA name="CIRCCALLORDER" id="CIRCCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="10"> </TEXTAREA>
			</TD>
			<TD align="left">
				<TEXTAREA name="IDTCALLORDER" id="IDTCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="11"> </TEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" valign="TOP"><LABEL for="MGMTCALLORDER">Management Call Order</LABEL></TH>
			<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<TEXTAREA name="MGMTCALLORDER" id="MGMTCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="12"> </TEXTAREA>
			</TD>
			<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
			<TH align="left">Modified Date</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="13"></CFSELECT>
			</TD>
			<TD align="left">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
          	<TD align="left">
               	<INPUT type="hidden" name="PROCESSPUBLICDESK" value="ADD" /><BR />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="14" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/webreports/processpublicdesk.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPUBLICDESK" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="15" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2">
				<CFINCLUDE template="/include/coldfusion/footer.cfm">
			</TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
*************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Public Desk. *
*************************************************************************************
 --->

	<CFIF NOT IsDefined('URL.LOOKUPPUBLICDESK')>
		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Lookup for Modify/Delete in Web Reports - Public Desk</H1></TH>
			</TR>
		</TABLE>
	
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
		</TABLE>

		<CFQUERY name="LookupPublicDeskTopic" datasource="#application.type#WEBREPORTS" blockfactor="67">
			SELECT	PD.PUBLICDESKID, PD.TOPICID, T.TOPIC, PD.SUBTOPICID, ST.SUBTOPIC, PD.CONTACTTIMEID, CT.CONTACTTIME, 
					T.TOPIC || ' - ' || ST.SUBTOPIC || ' - ' || CT.CONTACTTIME AS LOOKUPKEY
			FROM		PUBLICDESK PD, PDTOPIC T, PDSUBTOPIC ST, PDCONTACTTIME CT
			WHERE	PD.TOPICID = T.TOPICID AND
					PD.SUBTOPICID = ST.SUBTOPICID AND
					PD.CONTACTTIMEID = CT.CONTACTTIMEID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<BR />
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupFields();" action="/#application.type#apps/webreports/publicdesk.cfm?PROCESS=#URL.PROCESS#&LOOKUPPUBLICDESK=FOUND" method="POST">
			<TR>
				<TH align="LEFT"><H4><LABEL for="PUBLICDESKID">*Select by Topic - SubTopic - Contact Time (When)</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="LEFT">
					<CFSELECT name="PUBLICDESKID" id="PUBLICDESKID" size="1" query="LookupPublicDeskTopic" value="PUBLICDESKID" display="LOOKUPKEY" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/webreports/index.cfm?logout=No" method="POST">
				<TD align="left">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="CENTER"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>

	<CFELSE>

<!--- 
**************************************************************************
* The following code is the Modify and Delete Processes for Public Desk. *
**************************************************************************
 --->

		<CFQUERY name="GetPublicDesk" datasource="#application.type#WEBREPORTS">
			SELECT	PD.PUBLICDESKID, PD.TOPICID, T.TOPIC, PD.SUBTOPICID, ST.SUBTOPIC, PD.CONTACTTIMEID, PD.CONTACTID, PD.IDTOPTIONS,
					PD.PUBDESKOPTIONS, PD.CIRCNOTIFY, PD.IDTNOTIFY, PD.CIRCCALLORDER, PD.IDTCALLORDER, PD.MGMTCALLORDER, PD.MODIFIEDBYID,
					PD.MODIFIEDDATE, T.TOPIC || ' - ' || ST.SUBTOPIC AS LOOKUPKEY
			FROM		PUBLICDESK PD, PDTOPIC T, PDSUBTOPIC ST
			WHERE	PD.PUBLICDESKID = <CFQUERYPARAM value="#FORM.PUBLICDESKID#" cfsqltype="CF_SQL_NUMERIC"> AND
					PD.TOPICID = T.TOPICID AND
					PD.SUBTOPICID = ST.SUBTOPICID
			ORDER BY	LOOKUPKEY
		</CFQUERY>

		<TABLE width="100%" align="center" border="3">
			<TR align="center">
				<TH align="center"><H1>Modify/Delete in Web Reports - Public Desk</H1></TH>
			</TR>
		</TABLE>
		<TABLE width="100%" align="center" border="0">
			<TR>
				<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
			</TR>
			<TR>
				<TH align= "CENTER">
					Public Desk Key &nbsp; = &nbsp; #GetPublicDesk.PUBLICDESKID#
				</TH>
			</TR>
		</TABLE>
		<BR />
		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/webreports/publicdesk.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM><BR /><BR />
				</TD>
</CFFORM>
			</TR>
<CFFORM name="PUBLICDESK" onsubmit="return validateReqFields();" action="/#application.type#apps/webreports/processpublicdesk.cfm" method="POST" ENABLECAB="Yes">
			<CFCOOKIE name="PUBLICDESKID" secure="NO" value="#GetPublicDesk.PUBLICDESKID#">
			<TR>
				<TH align="left"><H4><LABEL for="TOPICID">*Topic</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="SUBTOPICID">*SubTopic</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="TOPICID" id="TOPICID" size="1" query="ListPDTopic" value="TOPICID" display="TOPIC" selected="#GetPublicDesk.TOPICID#" required="No" tabindex="2"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="SUBTOPICID" id="SUBTOPICID" size="1" query="ListPDSubTopic" value="SUBTOPICID" display="SUBTOPIC" selected="#GetPublicDesk.SUBTOPICID#" required="No" tabindex="3"></CFSELECT>
			</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="CONTACTTIMEID">*Contact Time (When)</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="CONTACTID">*Contact Name</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left">
					<CFSELECT name="CONTACTTIMEID" id="CONTACTTIMEID" size="1" query="ListPDContactTime" value="CONTACTTIMEID" display="CONTACTTIME" selected="#GetPublicDesk.CONTACTTIMEID#" required="No" tabindex="4"></CFSELECT>
				</TD>
				<TD align="left">
					<CFSELECT name="CONTACTID" id="CONTACTID" size="1" query="ListPDContacts" value="CONTACTID" display="CONTACTNAME" selected="#GetPublicDesk.CONTACTID#" required="No" tabindex="5"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="PUBDESKOPTIONS">Public Desk Options</LABEL></TH>
				<TH align="left"><LABEL for="IDTOPTIONS">IDT Options</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP" >
					<TEXTAREA name="PUBDESKOPTIONS" id="PUBDESKOPTIONS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="7">#GetPublicDesk.PUBDESKOPTIONS# </TEXTAREA>
				</TD>
				<TD align="left" valign="TOP">
					<TEXTAREA name="IDTOPTIONS" id="IDTOPTIONS" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="6">#GetPublicDesk.IDTOPTIONS# </TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="CIRCNOTIFY">Circulation Notifications</LABEL></TH>
				<TH align="left"><LABEL for="IDTNOTIFY">IDT Notifications</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<TEXTAREA name="CIRCNOTIFY" id="CIRCNOTIFY" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="8">#GetPublicDesk.CIRCNOTIFY# </TEXTAREA>
				</TD>
				<TD align="left" valign="TOP">
					<TEXTAREA name="IDTNOTIFY" id="IDTNOTIFY" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="9">#GetPublicDesk.IDTNOTIFY# </TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="CIRCCALLORDER">Circulation Call Order</LABEL></TH>	
				<TH align="left"><LABEL for="IDTCALLORDER">IDT Call Order</LABEL></TH>
			</TR>
			<TR>
				<TD align="left">
					<TEXTAREA name="CIRCCALLORDER" id="CIRCCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="10">#GetPublicDesk.CIRCCALLORDER# </TEXTAREA>
				</TD>
				<TD align="left">
					<TEXTAREA name="IDTCALLORDER" id="IDTCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="11">#GetPublicDesk.IDTCALLORDER# </TEXTAREA>
				</TD>
			</TR>
			<TR>
				<TH align="left" valign="TOP"><LABEL for="MGMTCALLORDER">Management Call Order</LABEL></TH>
				<TH align="left" valign="TOP">&nbsp;&nbsp;</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<TEXTAREA name="MGMTCALLORDER" id="MGMTCALLORDER" wrap="VIRTUAL" REQUIRED="No" rows="5" cols="60" tabindex="12">#GetPublicDesk.MGMTCALLORDER# </TEXTAREA>
				</TD>
				<TD align="left" valign="TOP">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
				<TH align="left"><LABEL for="MODIFIEDBYID">Modified By</LABEL></TH>
				<TH align="left">Modified Date</TH>
			</TR>
			<TR>
				<TD align="left" valign="TOP">
					<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="ListRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#GetPublicDesk.MODIFIEDBYID#" tabindex="13"></CFSELECT>
				</TD>
				<TD align="left" valign="TOP">
					<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
					<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
					#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
				</TD>
			</TR>
			<TR>
               	<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPUBLICDESK" value="MODIFY" /><BR />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="14" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="15" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/webreports/publicdesk.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="16" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2">
					<CFINCLUDE template="/include/coldfusion/footer.cfm">
				</TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>