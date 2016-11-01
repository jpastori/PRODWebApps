<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: workgroupassigns.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Workgroup Assigments --->
<!-- Last modified by John R. Pastori on 11/07/2013 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/workgroupassigns.cfm">
<CFSET CONTENT_UPDATED = "November 07, 2013">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to IDT Service Requests - Workgroup Assigments</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to IDT Service Requests - Workgroup Assigments</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to IDT Service Requests - Workgroup Assigments";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.WORKGROUPASSIGNS.STAFFCUSTOMERID != null && document.WORKGROUPASSIGNS.STAFFCUSTOMERID.selectedIndex == "0") {
			alertuser (document.WORKGROUPASSIGNS.STAFFCUSTOMERID.name +  ",  A Staff Customer MUST be selected!");
			document.WORKGROUPASSIGNS.STAFFCUSTOMERID.focus();
			return false;
		}

		if (document.WORKGROUPASSIGNS.GROUPID != null && document.WORKGROUPASSIGNS.GROUPID.selectedIndex == "0") {
			alertuser (document.WORKGROUPASSIGNS.GROUPID.name +  ",  A Group Name MUST be selected!");
			document.WORKGROUPASSIGNS.GROUPID.focus();
			return false;
		}

		if (document.WORKGROUPASSIGNS.GROUPORDER != null && document.WORKGROUPASSIGNS.GROUPORDER.selectedIndex == "0") {
			alertuser (document.WORKGROUPASSIGNS.GROUPORDER.name +  ",  A Group Order MUST be selected!");
			document.WORKGROUPASSIGNS.GROUPORDER.focus();
			return false;
		}

	}


	function validateLookupField() {
		if (document.LOOKUP.WORKGROUPASSIGNSID.selectedIndex == "0") {
			alertuser ("A Customer Name - Group Order - Group Name MUST be selected!");
			document.LOOKUP.WORKGROUPASSIGNSID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.WORKGROUPASSIGNS.PROCESSWGASSIGNS.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.WORKGROUPASSIGNSID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WORKGROUPASSIGNS.STAFFCUSTOMERID.focus()">
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

<CFQUERY name="ListStaffCustomers" datasource="#application.type#LIBSHAREDDATA" blockfactor="100">
	SELECT	CUSTOMERID, FULLNAME, INITIALS, ACTIVE
	FROM		CUSTOMERS
	WHERE	INITIALS IS NOT NULL AND
			ACTIVE = 'YES'
	ORDER BY	FULLNAME
</CFQUERY>

<CFQUERY name="ListGroupAssigned" datasource="#application.type#SERVICEREQUESTS" blockfactor="6">
	SELECT	GROUPID, GROUPNAME
	FROM		GROUPASSIGNED
	ORDER BY	GROUPNAME
</CFQUERY>


<!--- 
***************************************************************
* The following code is the ADD Process for Workgroup Assigns *
***************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Workgroup Assigments</H1></TD>
		</TR>
	</TABLE>
	
		<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
			SELECT	MAX(WORKGROUPASSIGNSID) AS MAX_ID
			FROM		WORKGROUPASSIGNS
		</CFQUERY>
		<CFSET FORM.WORKGROUPASSIGNSID = #val(GetMaxUniqueID.MAX_ID+1)#>
		<CFCOOKIE name="WORKGROUPASSIGNSID" secure="NO" value="#FORM.WORKGROUPASSIGNSID#">
		<CFQUERY name="AddWorkGroupAssignsID" datasource="#application.type#SERVICEREQUESTS">
			INSERT INTO	WORKGROUPASSIGNS (WORKGROUPASSIGNSID)
			VALUES		(#val(Cookie.WORKGROUPASSIGNSID)#)
		</CFQUERY>
	
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Workgroup Assigments Key &nbsp; = &nbsp; #FORM.WORKGROUPASSIGNSID#
			</TH>
		</TR>
	</TABLE>
		
	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processworkgroupassigns.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSWGASSIGNS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="WORKGROUPASSIGNS" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processworkgroupassigns.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left"><H4><LABEL for="STAFFCUSTOMERID">*Customer</LABEL></H4></TH>
			<TH align="left"><H4><LABEL for="GROUPID">*Workgroups</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap valign="top">
				<CFSELECT name="STAFFCUSTOMERID" id="STAFFCUSTOMERID" size="1" query="ListStaffCustomers" value="CUSTOMERID" display="FULLNAME" selected="0" required="No" tabindex="2"></CFSELECT><BR />
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="GROUPID" id="GROUPID" size="10" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="0" required="No" tabindex="3" multiple></CFSELECT><BR />
				<COM>(Hold down the shift key when <BR>
				clicking for a range of groups to be chosen. <BR>
				Use control key and left mouse click (PC) or <BR>
				command key when clicking (Mac) on a specific <BR>
				group to be chosen.)
				</COM>
			</TD>
		</TR>
		<TR>
			<TH align="left"><H4><LABEL for="GROUPORDER">*Workgroup Order</LABEL></H4></TH>
			<TH align="left"><LABEL for="ACTIVE">Active Group Member</LABEL></TH>
		</TR>
		<TR>
			<TD align="left">
				<CFSELECT name="GROUPORDER" id="GROUPORDER" size="1" tabindex="4">
					<OPTION value="0-Select Workgroup" selected>Select Workgroup</OPTION>
					<OPTION value="1-Primary Workgroup">Primary Workgroup</OPTION>
					<OPTION value="2-2nd Workgroup">2nd Workgroup</OPTION>
					<OPTION value="3-3rd Workgroup">3rd Workgroup</OPTION>
					<OPTION value="4-4th Workgroup">4th Workgroup</OPTION>
					<OPTION value="5-5th Workgroup">5th Workgroup</OPTION>
					<OPTION value="6-6th Workgroup">6th Workgroup</OPTION>
				</CFSELECT>
			</TD>
			<TD align="left" nowrap>
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="5">
					<OPTION selected value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSWGASSIGNS" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="6" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processworkgroupassigns.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSWGASSIGNS" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="7" /><BR />
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
*******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Workgroup Assigns. *
*******************************************************************************************
 --->

	<CFQUERY name="LookupCustomerGroups" datasource="#application.type#SERVICEREQUESTS" blockfactor="64">
		SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.CUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, WGA.ACTIVE,
				CUST.FULLNAME || ' - ' || WGA.GROUPORDER  || ' - ' ||  GA.GROUPNAME  || ' - ' ||  WGA.ACTIVE AS CUSTOMERGROUP
		FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
		WHERE	WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
				WGA.GROUPID = GA.GROUPID
		ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
	</CFQUERY>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
		<CFIF NOT IsDefined("URL.LOOKUPCUSTOMER")>
			<TH align="center">Lookup Modify/Delete Information to IDT Service Requests - Workgroup Assigments</H1></TH>
		<CFELSE>
			<TH align="center"><H1>Modify/Delete Information to IDT Service Requests - Workgroup Assigments</H1></TH>
		</CFIF>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields are required!</H4></TH>
		</TR>
		<CFIF IsDefined("URL.LOOKUPCUSTOMER")>
		<TR>
			<TH align="center">Workgroup Assigns Key &nbsp; = &nbsp; #FORM.WORKGROUPASSIGNSID#</TH>
			<CFCOOKIE name="WORKGROUPASSIGNSID" secure="NO" value="#FORM.WORKGROUPASSIGNSID#">
		</TR>
		</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCUSTOMER')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=#URL.PROCESS#&LOOKUPCUSTOMER=FOUND" method="POST">
			<TR>
				<TH align="LEFT" width="30%" nowrap><H4><LABEL for="WORKGROUPASSIGNSID">*Customer Name - Group Order - Group Name - Active?:</LABEL></H4></TH>
				<TD align="LEFT" width="70%">
					<CFSELECT name="WORKGROUPASSIGNSID" id="WORKGROUPASSIGNSID" size="1" query="LookupCustomerGroups" value="WORKGROUPASSIGNSID" display="CUSTOMERGROUP" required="No" tabindex="2"></CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="LEFT">
                    	<INPUT type="image" src="/images/buttonGO.jpg" value="GO" alt="Go" tabindex="3" />
                    </TD>
			</TR>
</CFFORM>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="4" /><BR />
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
********************************************************************************
* The following code is the Modify and Delete Processes for Workgroup Assigns. *
********************************************************************************
 --->

		<CFQUERY name="GetCustomerGroups" datasource="#application.type#SERVICEREQUESTS">
			SELECT	WGA.WORKGROUPASSIGNSID, WGA.STAFFCUSTOMERID, CUST.FULLNAME, WGA.GROUPID, GA.GROUPNAME, WGA.GROUPORDER, WGA.ACTIVE
			FROM		WORKGROUPASSIGNS WGA, LIBSHAREDDATAMGR.CUSTOMERS CUST, GROUPASSIGNED GA
			WHERE	WGA.WORKGROUPASSIGNSID = <CFQUERYPARAM value="#FORM.WORKGROUPASSIGNSID#" cfsqltype="CF_SQL_NUMERIC"> AND
					WGA.STAFFCUSTOMERID = CUST.CUSTOMERID AND
					WGA.GROUPID = GA.GROUPID
			ORDER BY	CUST.FULLNAME, WGA.GROUPORDER
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="WORKGROUPASSIGNS" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processworkgroupassigns.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<TH align="left"><H4><LABEL for="STAFFCUSTOMERID">*Customer</LABEL></H4></TH>
				<TH align="left"><H4><LABEL for="GROUPID">*Workgroups</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap valign="top">
					<CFSELECT name="STAFFCUSTOMERID" id="STAFFCUSTOMERID" size="1" query="ListStaffCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetCustomerGroups.STAFFCUSTOMERID#" required="No" tabindex="2"></CFSELECT><BR />
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="GROUPID" id="GROUPID" size="1" query="ListGroupAssigned" value="GROUPID" display="GROUPNAME" selected="#GetCustomerGroups.GROUPID#" required="No" tabindex="3"></CFSELECT><BR />
				</TD>
			</TR>
			<TR>
				<TH align="left"><H4><LABEL for="GROUPORDER">*Workgroup Order</LABEL></H4></TH>
				<TH align="left"><LABEL for="ACTIVE">Active Group Member</LABEL></TH>
			</TR>
			<TR>
				<TD align="left" valign="top">
					<CFSELECT name="GROUPORDER" id="GROUPORDER" size="1" tabindex="4">
						<OPTION value="0-Select Workgroup">Select Workgroup</OPTION>
						<OPTION value="#GetCustomerGroups.GROUPORDER#" selected>#GetCustomerGroups.GROUPORDER#</OPTION>
						<OPTION value="1-Primary Workgroup">Primary Workgroup</OPTION>
						<OPTION value="2-2nd Workgroup">2nd Workgroup</OPTION>
						<OPTION value="3-3rd Workgroup">3rd Workgroup</OPTION>
						<OPTION value="4-4th Workgroup">4th Workgroup</OPTION>
						<OPTION value="5-5th Workgroup">5th Workgroup</OPTION>
						<OPTION value="6-6th Workgroup">6th Workgroup</OPTION>
					</CFSELECT>
				</TD>
				<TD align="left" nowrap>
					<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="5">
						<OPTION selected value="#GetCustomerGroups.ACTIVE#">#GetCustomerGroups.ACTIVE#</OPTION>
						<OPTION value="YES">YES</OPTION>
						<OPTION value="NO">NO</OPTION>
					</CFSELECT>
				</TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSWGASSIGNS" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="6" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" onClick="return setDelete();" tabindex="7" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/workgroupassigns.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="LEFT" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="8" /><BR />
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
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>