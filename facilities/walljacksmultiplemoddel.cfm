<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<!--- Program: walljacksmultiplemoddel.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 07/17/2012 --->
<!--- Date in Production: 07/17/2012 --->
<!--- Module: Multiple Record Modify/Delete in Facilities - WallJacks --->
<!-- Last modified by John R. Pastori on 08/11/2015 using ColdFusion Studio. -->

<CFSET AUTHOR_NAME = "John R. Pastori">
<CFSET AUTHOR_EMAIL = "pastori@rohan.sdsu.edu">
<CFSET DOCUMENT_URI = "/#application.type#apps/facilities/walljacksmultiplemoddel.cfm">
<CFSET CONTENT_UPDATED = "August 11, 2015">
<CFINCLUDE template = "../programsecuritycheck.cfm">

<HTML>
<HEAD>
	<TITLE>Multiple Record Modify/Delete to Facilities - WallJacks</TITLE>
	<META http-equiv="Content-Language" content="en-us" />
	<META http-equiv="Expires" content="0" />
	<META http-equiv="Cache-Control" content="no-cache" />
	<META http-equiv="Pragma" content="no-cache" />
	<LINK rel="stylesheet" type="text/css" href="/webapps.css" />

<SCRIPT language=JAVASCRIPT>
	window.defaultStatus = "Welcome to Facilities";

	if (window.history.forward(1) != null) {
		window.history.forward(1); 
	}


	function alertuser(alertMsg) {
		alert(alertMsg);
	}


	function validateLookupFields() {
		if (document.LOOKUP.BUILDINGNAMEID.selectedIndex == "0"      && document.LOOKUP.LOCATIONID.selectedIndex == "0"
		 && (document.LOOKUP.ROOMNUMBER.value == ""                  || document.LOOKUP.ROOMNUMBER.value == " ")
		 && document.LOOKUP.WALLDIRID.selectedIndex == "0"      
		 && (document.LOOKUP.CLOSET.value == ""                      || document.LOOKUP.CLOSET.value == " ")
		 && document.LOOKUP.JACKNUMBER.value == "0" 
		 && document.LOOKUP.PORTLETTER.selectedIndex == "0"          && document.LOOKUP.ACTIVE.value == "Select" 
		 && document.LOOKUP.INSERTTYPE.value == "Select Insert Type" 
		 && document.LOOKUP.VLANID.selectedIndex == "0"			 && document.LOOKUP.CUSTOMERID.selectedIndex == "0"
		 && (document.LOOKUP.CUSTOMERFIRSTNAME.value == ""           || document.LOOKUP.CUSTOMERFIRSTNAME.value == " ")
		 && (document.LOOKUP.CUSTOMERLASTNAME.value == ""            || document.LOOKUP.CUSTOMERLASTNAME.value == " ")
		 && (document.LOOKUP.COMMENTS.value == ""            		 || document.LOOKUP.COMMENTS.value == " ")
		 && document.LOOKUP.MODIFIEDBYID.selectedIndex == "0" 
		 && (document.LOOKUP.MODIFIEDDATE.value == ""            	 || document.LOOKUP.MODIFIEDDATE.value == " ")) {
			alertuser ("At least one selection field must be entered or selected!");
			document.LOOKUP.BUILDINGNAMEID.focus();
			return false;
		}
	}

//
</SCRIPT>
<!--Script ends here -->

</HEAD>

<CFOUTPUT>
<CFIF NOT IsDefined('URL.LOOKUPWALLJACK')>
	<CFSET CURSORFIELD = "document.LOOKUP.BUILDINGNAMEID.focus()">
<CFELSE>
	<CFSET CURSORFIELD = "document.WALLJACK.JACKROOM.focus()">
</CFIF>
<BODY onLoad="#CURSORFIELD#">

<CFSET PROCESSPROGRAM = "walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL&LOOKUPWALLJACK=FOUND">

<CFINCLUDE template="/include/coldfusion/formheader.cfm">
<CFSET SCREENTITLE = "Multiple Record Modify/Delete Lookup in Facilities - WallJack">
<CFINCLUDE template="lookupwalljacksinfo.cfm">

<CFQUERY name="LookupVLanInfo" datasource="#application.type#FACILITIES" blockfactor="9">
	SELECT	VLANID, VLAN_NUMBER, VLAN_NAME, VLAN_NUMBER || ' - ' || VLAN_NAME AS VLANKEY
	FROM		VLANINFO
	ORDER BY	VLANID
</CFQUERY>

<CFIF NOT IsDefined('URL.LOOKUPWALLJACK') OR NOT #URL.LOOKUPWALLJACK# EQ "FOUND">
	<CFEXIT>
<CFELSE>

	<TABLE width="100%" align="center" border="3">
		<TR align="center">
			<TH align="center"><H1>Modify/Delete Multiple Records in Facilities - WallJacks</H1></TH>
		</TR>
	</TABLE>
	<TABLE width="100%" align="center" border="0">
		<TR>
			<TH align= "CENTER">
				WallJack Key &nbsp; = &nbsp; #GetJackNumbers.WALLJACKID# 
			</TH>
		</TR>
		<TR>
			<TH align="CENTER"><H2>To modify a field on multiple records, a check in the adjacent checkbox is required.</H2></TH>
		</TR>
	</TABLE>
	<BR />

	<TABLE align="left" width="100%" border="0">
		<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="submit" value="Cancel" tabindex="1" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
<CFFORM name="WALLJACK" action="/#application.type#apps/facilities/processwalljacksinfo.cfm?WALLJACKIDS=#URL.WALLJACKIDS#" method="POST" ENABLECAB="Yes">
		<TR>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="JACKROOMCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="JACKROOM">Jack Location</LABEL>
			</TH>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="WALLDIRECTIONCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="WALLDIRID">Wall Direction</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="JACKROOMCHANGED" id="JACKROOMCHANGED" value="" align="LEFT" required="No" tabindex="2">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="JACKROOM" id="JACKROOM" size="1" query="LookupRoomNumbers" value="LOCATIONID" display="BUILDINGROOM" selected="#GetJackNumbers.LOCATIONID#" required="No" tabindex="3"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="WALLDIRECTIONCHANGED" id="WALLDIRECTIONCHANGED" value="" align="LEFT" required="No" tabindex="4">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="WALLDIRID" id="WALLDIRID" size="1" query="LookupWallDirection" value="WALLDIRID" display="WALLDIRNAME" selected="#GetJackNumbers.WALLDIRID#" required="No" tabindex="5"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="CLOSETCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CLOSET">Closet</LABEL>
			</TH>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="JACKNUMBERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="JACKNUMBER">Jack Number</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="CLOSETCHANGED" id="CLOSETCHANGED" value="" align="LEFT" required="No" tabindex="6">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="CLOSET" id="CLOSET" value="#GetJackNumbers.CLOSET#" align="LEFT" required="No" size="16" tabindex="7">
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="JACKNUMBERCHANGED" id="JACKNUMBERCHANGED" value="" align="LEFT" required="No" tabindex="8">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFINPUT type="Text" name="JACKNUMBER" id="JACKNUMBER" value="#GetJackNumbers.JACKNUMBER#" align="LEFT" required="No" size="16" tabindex="9">
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="PORTLETTERCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="PORTLETTER">Port Letter</LABEL>
			</TH>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="ACTIVECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="ACTIVE">Active</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="PORTLETTERCHANGED" id="PORTLETTERCHANGED" value="" align="LEFT" required="No" tabindex="10">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="PORTLETTER" id="PORTLETTER" size="1" required="No" tabindex="11">
					<OPTION selected value="#GetJackNumbers.PORTLETTER#">#GetJackNumbers.PORTLETTER#</OPTION>
					<OPTION value="0">PORT LETTER</OPTION>
					<OPTION value="A">A</OPTION>
					<OPTION value="B">B</OPTION>
					<OPTION value="C">C</OPTION>
					<OPTION value="D">D</OPTION>
					<OPTION value="E">E</OPTION>
					<OPTION value="F">F</OPTION>
                         <OPTION value="WL">WIRELESS</OPTION>
				</CFSELECT>&nbsp;&nbsp;
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="ACTIVECHANGED" id="ACTIVECHANGED" value="" align="LEFT" required="No" tabindex="12">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="ACTIVE" id="ACTIVE" size="1" tabindex="13">
					<OPTION selected value="#GetJackNumbers.ACTIVE#">#GetJackNumbers.ACTIVE#</OPTION>
					<OPTION value="YES">YES</OPTION>
					<OPTION value="NO">NO</OPTION>
				</CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="INSERTTYPECHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="INSERTTYPE">Insert Type</LABEL>
			</TH>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="VLANIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="VLANID">VLAN</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="INSERTTYPECHANGED" id="INSERTTYPECHANGED" value="" align="LEFT" required="No" tabindex="14">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="INSERTTYPE" id="INSERTTYPE" size="1" tabindex="15">
					<OPTION selected value="#GetJackNumbers.INSERTTYPE#">#GetJackNumbers.INSERTTYPE#</OPTION>
					<OPTION value="0">Select Insert Type</OPTION>
					<OPTION value="DATA">DATA</OPTION>
					<OPTION value="ONE CARD">ONE CARD</OPTION>
					<OPTION value="PHONE">PHONE</OPTION>
				</CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="VLANIDCHANGED" id="VLANIDCHANGED" value="" align="LEFT" required="No" tabindex="16">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="VLANID" id="VLANID" size="1" query="LookupVLanInfo" value="VLANID" selected="#GetJackNumbers.VLANID#" display="VLANKEY" required="No" tabindex="17"></CFSELECT>
			</TD>
		</TR>
		<TR>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="CUSTOMERIDCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="CUSTOMERID">Customer</LABEL>
			</TH>
			<TH class="TH_change" align="LEFT" width="5%">
				<LABEL for="COMMENTSCHANGED">Change</LABEL><BR /> 
				&nbsp;Value
			</TH>
			<TH align="left" valign="BOTTOM" width="45%">
				<LABEL for="COMMENTS">Comments</LABEL>
			</TH>
		</TR>
		<TR>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="CUSTOMERIDCHANGED" id="CUSTOMERIDCHANGED" value="" align="LEFT" required="No" tabindex="18">
			</TD>
			<TD align="LEFT" valign="TOP" width="45%">
				<CFSELECT name="CUSTOMERID" id="CUSTOMERID" size="1" query="LookupCustomers" value="CUSTOMERID" display="FULLNAME" selected="#GetJackNumbers.CUSTOMERID#" required="No" tabindex="19"></CFSELECT>
			</TD>
			<TD align="LEFT" valign="TOP" width="5%">
				<CFINPUT type="CheckBox" name="COMMENTSCHANGED" id="COMMENTSCHANGED" value="" align="TOP" required="No" tabindex="20">
			</TD>
			<TD align="LEFT" width="45%">
				<CFTEXTAREA name="COMMENTS" id="COMMENTS" wrap="VIRTUAL" VALIGN="BOTTOM" required="No" rows="5" cols="60" tabindex="21">#GetJackNumbers.COMMENTS#</CFTEXTAREA>
			</TD>
		</TR>
		<TR>
			<TH align="left" colspan="2">
				<LABEL for="MODIFIEDBYID">Modified-By</LABEL>
			</TH>
			<TH align="left" colspan="2">Date Modified</TH>
		</TR>
		<TR>
			<TD align="left" valign="TOP" colspan="2">
				<CFSELECT name="MODIFIEDBYID" id="MODIFIEDBYID" query="LookupRecordModifier" value="CUSTOMERID" display="FULLNAME" selected="#Client.CUSTOMERID#" tabindex="22"></CFSELECT>
			</TD>
			<TD align="left" colspan="2">
				<CFSET FORM.MODIFIEDDATE = #DateFormat(NOW(), 'DD-MMM-YYYY')#>
				<INPUT type="hidden" name="MODIFIEDDATE" value="#FORM.MODIFIEDDATE#" />
				#DateFormat(FORM.MODIFIEDDATE, "MM/DD/YYYY")#
			</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2"><INPUT type="submit" name="ProcessWallJack" value="MODIFYMULTIPLE" tabindex="23" /></TD>
		</TR>
		<CFIF #Client.DeleteFlag# EQ "Yes">
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2"><INPUT type="submit" name="ProcessWallJack" value="DELETEMULTIPLE" tabindex="24" /></TD>
		</TR>
		</CFIF>
</CFFORM>
		<TR>
			<TD align="left">&nbsp;&nbsp;</TD>
		</TR>
		<TR>
<CFFORM action="/#application.type#apps/facilities/walljacksmultiplemoddel.cfm?PROCESS=MULTMODDEL" method="POST">
			<TD align="left" colspan="4">
				<INPUT type="submit" value="Cancel" tabindex="25" /><BR />
				<COM>(Please DO NOT use the Browser's Back Button.)</COM>
			</TD>
</CFFORM>
		</TR>
		<TR>
			<TD align="left" colspan="4"><CFINCLUDE template="/include/coldfusion/footer.cfm"></TD>
		</TR>
	</TABLE>
</CFIF>

</BODY>
</CFOUTPUT>
</HTML>