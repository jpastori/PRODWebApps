<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: probsubcatsinfo.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 06/21/2012 --->
<!--- Date in Production: 06/21/2012 --->
<!--- Module: Add/Modify/Delete Information to IDT Service Requests - Problem Sub-Categories --->
<!-- Last modified by John R. Pastori on 06/21/2012 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/servicerequests/probsubcatsinfo.cfm">
<CFSET CONTENT_UPDATED = "June 21, 2012">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<CFIF URL.PROCESS EQ 'ADD'>
		<TITLE>Add Information to Service Requests - Problem Sub-Categories</TITLE>
	<CFELSE>
		<TITLE>Modify/Delete Information to Service Requests - Problem Sub-Categories</TITLE>
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
		if (document.SUBCATEGORY.SUBCATEGORYLETTERID.selectedIndex == "0") {
			alertuser (document.SUBCATEGORY.SUBCATEGORYLETTERID.name +  ",  A Problem Sub-Category Letter MUST be selected!");
			document.SUBCATEGORY.SUBCATEGORYLETTERID.focus();
			return false;
		}

		if (document.SUBCATEGORY.SUBCATEGORYNAME.value == "" || document.SUBCATEGORY.SUBCATEGORYNAME.value == " ") {
			alertuser (document.SUBCATEGORY.SUBCATEGORYNAME.name +  ",  A Problem Sub-Category Name MUST be entered!");
			document.SUBCATEGORY.SUBCATEGORYNAME.focus();
			return false;
		}
	}


	function validateLookupField() {
		if (document.LOOKUP.SUBCATEGORYID.selectedIndex == "0") {
			alertuser ("A Problem Sub-Category MUST be selected!");
			document.LOOKUP.SUBCATEGORYID.focus();
			return false;
		}
	}
	
	
	function setDelete() {
		document.SUBCATEGORY.PROCESSPROBLEMSUBCATEGORIES.value = "DELETE";
		return true;
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPSUBCATEGORY') AND URL.PROCESS EQ "MODIFYDELETE">
	<CFSET CURSORFIELD = "document.LOOKUP.SUBCATEGORYID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.SUBCATEGORY.SUBCATEGORYNAME.focus()">
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

<CFQUERY name="ListProblemSubCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
	SELECT	PROBLEMSUBCATEGORIES.SUBCATEGORYID, PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME, PROBLEMCATEGORIES.CATEGORYLETTER || ' ' || PROBLEMSUBCATEGORIES.SUBCATEGORYNAME AS KEYFINDER
	FROM		PROBLEMSUBCATEGORIES, PROBLEMCATEGORIES
	WHERE	PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID = PROBLEMCATEGORIES.CATEGORYID
	ORDER BY	KEYFINDER
</CFQUERY>

<CFQUERY name="ListProblemCategories" datasource="#application.type#SERVICEREQUESTS" blockfactor="15">
	SELECT	CATEGORYID, CATEGORYLETTER || ' ' || CATEGORYNAME AS SUBCATEGORYLETTER
	FROM		PROBLEMCATEGORIES
	ORDER BY	CATEGORYLETTER
</CFQUERY>

<!--- 
*******************************************************************
* The following code is the ADD Process for Problem Sub-Category. *
*******************************************************************
 --->

<CFIF URL.PROCESS EQ 'ADD'>
	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Add Information to IDT Service Requests - Problem Sub-Categories</H1></TD>
		</TR>
	</TABLE>

	<CFQUERY name="GetMaxUniqueID" datasource="#application.type#SERVICEREQUESTS">
		SELECT	MAX(SUBCATEGORYID) AS MAX_ID
		FROM		PROBLEMSUBCATEGORIES
	</CFQUERY>
	<CFSET FORM.SUBCATEGORYID = #val(GetMaxUniqueID.MAX_ID+1)#>
	<CFCOOKIE name="SUBCATEGORYID" secure="NO" value="#FORM.SUBCATEGORYID#">
	<CFQUERY name="AddProblemSubCategoriesID" datasource="#application.type#SERVICEREQUESTS" blockfactor="100">
		INSERT INTO	PROBLEMSUBCATEGORIES (SUBCATEGORYID)
		VALUES		(#val(Cookie.SUBCATEGORYID)#)
	</CFQUERY>

	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center">
				<H4>*Red fields marked with asterisks are required!</H4>
			</TH>
		</TR>
		<TR>
			<TH align="center">
				Problem Sub-Category Key &nbsp; = &nbsp; #FORM.SUBCATEGORYID#
			</TH>
		</TR>
	</TABLE>
	<BR clear = "left" />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processprobsubcatsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPROBLEMSUBCATEGORIES" value="CANCELADD" />
				<INPUT type="image" src="/images/buttonCancelAdd.jpg" value="CANCELADD" alt="Cancel Add" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="SUBCATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processprobsubcatsinfo.cfm" method="POST" ENABLECAB="Yes">
		<TR>
			<TH align="left" nowrap><H4><LABEL for="SUBCATEGORYLETTERID">*Problem Sub-Category Letter</LABEL></H4></TH>
			<TH align="left" nowrap><H4><LABEL for="SUBCATEGORYNAME">*Problem Sub-Category</LABEL></H4></TH>
		</TR>
		<TR>
			<TD align="left" nowrap>
               	<CFSELECT name="SUBCATEGORYLETTERID" id="SUBCATEGORYLETTERID" size="1" query="ListProblemCategories" value="CATEGORYID" display="SUBCATEGORYLETTER" selected="0" required="No" tabindex="2"></CFSELECT>
               </TD>
			<TD align="left">
               	<CFINPUT type="Text" name="SUBCATEGORYNAME" id="SUBCATEGORYNAME" value="" align="LEFT" required="No" size="30" maxlength="30" tabindex="3">
               </TD>
		</TR>
		<TR>
			<TD align="left">
               	<INPUT type="hidden" name="PROCESSPROBLEMSUBCATEGORIES" value="ADD" />
               	<INPUT type="image" src="/images/buttonADD.jpg" value="ADD" alt="Add" tabindex="4" /></TD>
		</TR>
</CFFORM>
		<TR>
<CFFORM action="/#application.type#apps/servicerequests/processprobsubcatsinfo.cfm" method="POST">
			<TD align="left" colspan="2">
				<INPUT type="hidden" name="PROCESSPROBLEMSUBCATEGORIES" value="CANCELADD" />
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
**********************************************************************************************
* The following code is the Look Up Process for Modifying and Deleting Problem Sub-Category. *
**********************************************************************************************
 --->

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TD align="center"><H1>Modify/Delete Information to IDT Service Requests - Problem Sub-Categories</H1></TD>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align="center"><H4>*Red fields marked with asterisks are required!</H4></TH>
		</TR>
	<CFIF IsDefined('URL.LOOKUPSUBCATEGORY')>
		<TR>
			<TH align="center">Problem Sub-Category Key &nbsp; = &nbsp; #FORM.SUBCATEGORYID#</TH>
		</TR>
	</CFIF>
	</TABLE>
	<BR clear = "left" />

	<CFIF NOT IsDefined('URL.LOOKUPSUBCATEGORY')>
		<TABLE width="100%" align="LEFT">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/index.cfm?logout=No" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="LOOKUP" onsubmit="return validateLookupField();" action="/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=#URL.PROCESS#&LOOKUPSUBCATEGORY=FOUND" method="POST">
			<TR>
				<TH align="left" width="30%" nowrap><H4><LABEL for="SUBCATEGORYID">*Problem Sub-Category:</LABEL></H4></TH>
				<TD align="left" width="70%">
					<CFSELECT name="SUBCATEGORYID" id="SUBCATEGORYID" size="1" query="ListProblemSubCategories" value="SUBCATEGORYID" display="KEYFINDER" required="No" tabindex="2"></CFSELECT>
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
***********************************************************************************
* The following code is the Modify and Delete Processes for Problem Sub-Category. *
***********************************************************************************
 --->

		<CFQUERY name="GetProblemSubCategories" datasource="#application.type#SERVICEREQUESTS">
			SELECT	PROBLEMSUBCATEGORIES.SUBCATEGORYID, PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID, PROBLEMSUBCATEGORIES.SUBCATEGORYNAME, PROBLEMCATEGORIES.CATEGORYLETTER
			FROM		PROBLEMSUBCATEGORIES, PROBLEMCATEGORIES
			WHERE	PROBLEMSUBCATEGORIES.SUBCATEGORYID = <CFQUERYPARAM value="#FORM.SUBCATEGORYID#" cfsqltype="CF_SQL_NUMERIC"> AND
					PROBLEMSUBCATEGORIES.SUBCATEGORYLETTERID = PROBLEMCATEGORIES.CATEGORYID
		</CFQUERY>

		<TABLE align="left" width="100%" border="0">
			<TR>
<CFFORM action="/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
				<TD align="left" colspan="2">
					<INPUT type="image" src="/images/buttonCancel.jpg" value="Cancel" alt="Cancel" tabindex="1" /><BR />
					<COM>(Please DO NOT use the Browser's Back Button.)</COM>
				</TD>
</CFFORM>
			</TR>
<CFFORM name="SUBCATEGORY" onsubmit="return validateReqFields();" action="/#application.type#apps/servicerequests/processprobsubcatsinfo.cfm" method="POST" ENABLECAB="Yes">
			<TR>
				<CFCOOKIE name="SUBCATEGORYID" secure="NO" value="#FORM.SUBCATEGORYID#">
				<TH align="left" nowrap><H4><LABEL for="SUBCATEGORYLETTERID">*Problem Sub-Category Letter</LABEL></H4></TH>
				<TH align="left" nowrap><H4><LABEL for="SUBCATEGORYNAME">*Problem Sub-Category</LABEL></H4></TH>
			</TR>
			<TR>
				<TD align="left" nowrap>
                    	<CFSELECT name="SUBCATEGORYLETTERID" id="SUBCATEGORYLETTERID" size="1" query="ListProblemCategories" value="CATEGORYID" display="SUBCATEGORYLETTER" selected="#GetProblemSubCategories.SUBCATEGORYLETTERID#" required="No" tabindex="2"></CFSELECT>
                    </TD>
				<TD align="left">
                    	<CFINPUT type="Text" name="SUBCATEGORYNAME" id="SUBCATEGORYNAME" value="#GetProblemSubCategories.SUBCATEGORYNAME#" align="LEFT" required="No" size="30" maxlength="30" tabindex="3">
                    </TD>
			</TR>
			<TR>
				<TD align="left">
                    	<INPUT type="hidden" name="PROCESSPROBLEMSUBCATEGORIES" value="MODIFY" />
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
<CFFORM action="/#application.type#apps/servicerequests/probsubcatsinfo.cfm?PROCESS=#URL.PROCESS#" method="POST">
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