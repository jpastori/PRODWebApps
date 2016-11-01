<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: probcatsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 05/25/2012 --->
<!--- Date in Production: 05/25/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Problem Categories --->
<!-- Last modified by John R. Pastori on 05/25/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori/cp">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/probcatsinfo.cfm">
<CFSET CONTENT_UPDATED = "May 25, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Problem Categories</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Problem Categories</TITLE>
	</CFIF>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<!-- Script starts here ---->
<SCRIPT language="JavaScript">
	window.defaultStatus = "Welcome to IDT Service Requests";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateReqFields() {
		if (document.CATEGORY.CATEGORYLETTER.value == "" || document.CATEGORY.CATEGORYLETTER.value == " ") {
			alertuser (document.CATEGORY.CATEGORYLETTER.name +  ",  A Problem Category Letter MUST be entered!");
			document.CATEGORY.CATEGORYLETTER.focus();
			return false;
		}

		if (document.CATEGORY.CATEGORYNAME.value == "" || document.CATEGORY.CATEGORYNAME.value == " ") {
			alertuser (document.CATEGORY.CATEGORYNAME.name +  ",  A Problem Category Name MUST be entered!");
			document.CATEGORY.CATEGORYNAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.CATEGORYID.selectedIndex == "0") {
			alertuser ("An Problem Category MUST be selected!");
			document.LOOKUP.CATEGORYID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.CATEGORY.PROCESSPROBLEMCATEGORIES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPCATEGORY') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.CATEGORYID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.CATEGORY.CATEGORYNAME.focus()">
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

<CFQUERY name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME, CATEGORYLETTER || ' ' || CATEGORYNAME AS KEYFINDER
	FROM		PROBLEMCATEGORIES
	ORDER BY	CATEGORYLETTER
</CFQUERY>

<!--- 
*****************************************************************
* The following code is the ADD Process for Problem Categories. *
*****************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Problem Categories</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(CATEGORYID) AS MAX_ID
		FROM		PROBLEMCATEGORIES
	</CFQUERY>
	<CFSET FORM.CATEGORYID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="CATEGORYID" secure="NO" value="#FORM.CATEGORYID#">
	<CFQUERY name="AddProblemCategoriesID" datasource="#application.type#SERVICEREQUESTS">
		INSERT INTO	PROBLEMCATEGORIES (CATEGORYID)
		VALUES		(#val(Cookie.CATEGORYID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Problem Category Key &nbsp; = &nbsp; #FORM.CATEGORYID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processprobcatsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPROBLEMCATEGORIES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="CATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processprobcatsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="CATEGORYLETTER">*Problem Category Letter</LABEL></H4></TH>
			<TH align="left" nowrap><H4><LABEL for="CATEGORYNAME">*Problem Category</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left"><CFINPUT type="Text" name="CATEGORYLETTER" id="CATEGORYLETTER" value="" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
			<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="" align="LEFT" required="No" size="30" maxlength="25" tabindex="3"></TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPROBLEMCATEGORIES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" />
               </TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processprobcatsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPROBLEMCATEGORIES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="5" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>

<CFELSE>

<!--- 
******************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Problem Category. *
******************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Problem Categories</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPCATEGORY')>
		<TR>
			<TH align="center">Problem Category Key &nbsp; = &nbsp; #FORM.CATEGORYID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPCATEGORY')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPCATEGORY=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="CATEGORYID">*Problem Category:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="CATEGORYID" id="CATEGORYID" size="1" query="ListProblemCategories" value="CATEGORYID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
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
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
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

	<CFELSE>

<!--- 
*******************************************************************************
* The following code is the Modify and Delete Processes for Problem Category. *
*******************************************************************************
 --->

		<CFQUERY name="GetProblemCategories" datasource="#application.type#SERVICEREQUESTS">
			SELECT	CATEGORYID, CATEGORYLETTER, CATEGORYNAME
			FROM		PROBLEMCATEGORIES
			WHERE	CATEGORYID = <CFQUERYPARAM value="#FORM.CATEGORYID#" cfsqltype="CF_SQL_NUMERIC">
			ORDER BY	CATEGORYLETTER
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="CATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processprobcatsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="CATEGORYID" secure="NO" value="#FORM.CATEGORYID#">
				<TH align="left" nowrap><H4><LABEL for="CATEGORYLETTER">*Problem Category Letter</LABEL></H4></TH>
				<TH align="left" nowrap><H4><LABEL for="CATEGORYNAME">*Problem Category</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left"><CFINPUT type="Text" name="CATEGORYLETTER" id="CATEGORYLETTER" value="#GetProblemCategories.CATEGORYLETTER#" align="LEFT" required="No" size="5" maxlength="5" tabindex="2"></TD>
				<TD align="left"><CFINPUT type="Text" name="CATEGORYNAME" id="CATEGORYNAME" value="#GetProblemCategories.CATEGORYNAME#" align="LEFT" required="No" size="30" maxlength="25" tabindex="3"></TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPROBLEMCATEGORIES" value="MODIFY" />
                         <INPUT type="image" src="/images/buttonMOD.jpg" value="MODIFY" alt="Modify" tabindex="4" />
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
                    	<INPUT type="image" src="/images/buttonDelete.jpg" value="DELETE" alt="Delete" OnClick="return setDelete();" tabindex="5" />
                    </TD>
			</TR>
		</CFIF>
</CFFORM>
			<TR>
				<TD align="left">&nbsp;&nbsp;</TD>
			</TR>
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/probcatsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="6" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
			<TR>
				<TD align="left" colspan="2"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
			</TR>
		</TABLE>
	</CFIF>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>