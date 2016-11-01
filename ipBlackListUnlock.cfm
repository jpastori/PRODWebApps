<!--- Program: ipBlackListUnlock.cfm --->
<!--- By: JOHN R. PASTORI --->
<!--- Date Written: 12/11/2008 --->
<!--- Date in Production: 12/11/2008 --->
<!--- Module: Application ColdFusion SQL Injection IP BlackList Reset Form --->
<!-- Last modified by John R. Pastori on 12/11/2008 using ColdFusion Studio. -->

<CFIF isDefined("FORM.Save")>
	<CFSET VARIABLES.exists = "0">
	<CFIF isDefined("APPLICATION.ipBlackList")>
		<CFLOOP from="1" to="#arrayLen(APPLICATION.ipBlackList)#" index="currPosition">
			<CFIF APPLICATION.ipBlackList[currPosition].arrayIp EQ FORM.ipAddress>
				<CFSET VARIABLES.temp = arrayDeleteAt(APPLICATION.ipBlackList, currPosition)>
				<CFSET VARIABLES.exists = "1">
				<CFBREAK>
			</CFIF>
		</CFLOOP>
	</CFIF>
	<CFIF VARIABLES.exists EQ "1">
		<CFSET VARIABLES.message = "IP Address was removed from blacklist!">
	<CFELSE>
		<CFSET VARIABLES.message = "This IP Address isn't in the blacklist!">
	</CFIF>
</CFIF>

<HTML>
<HEAD>
	<STYLE type="text/css">
		.borderColor {background-color: #555555; }
		.appTitle_Group {font-size: 18px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;color: #000000;text-decoration: none;font-weight: 100;}
		.appTitle_Minder {font-size: 18px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;color: #AA0000;text-decoration: none;	font-weight: 900;}
		.mainHeaderGradient {filter: progid:DXImageTransform.Microsoft.Gradient(gradientType=1,startColorStr=#EEF5FF,endColorStr=#ff0000);background-color: #ff0000;font: 14px sans-serif;font-weight: 100;color: #000000;}
		.mainHeaderNoGrad {background-color: #ff0000;}
		.separatorGradient {filter: progid:DXImageTransform.Microsoft.Gradient(gradientType=1,startColorStr=#777777,endColorStr=#FFFFFF);background-color: #FFFFFF; }
		.appTable {background-color: #FFFFFF;}
		.breadCrumbs {font: 10px sans-serif;color: #777777;font-weight: 100;padding: 5px 5px 5px 5px;}
		.messageArea {background-color: #FFDDDD;font: 11px sans-serif;font-weight: 100;color: #0000AA;border: 1px solid #FF0000;padding: 5px 5px 5px 5px; }
		.appContent {font: 11px sans-serif;font-weight: 100;color: #444444;padding: 2px 2px 2px 2px;}
		.appContent:link {color: #000088;text-decoration: none;}
		.appContent:visited {color: #000088;text-decoration: none;}
		.appContent:hover{color: #0000FF;}
		.appResultHeader {font-style: italic;font-weight: 100;}
		.frmFlds {background-color: #EFEFEF;font: 11px sans-serif;color: #000000;border: 1px solid #FF9900;}
		.TblRow1 {background-color: #EFEFEF;}
		.TblRow2 {background-color: #FFFFFF;}
		.frmBtn {font: 11px sans-serif;color: #000000;font-weight: 100;}
		.footer {font: 9px sans-serif;color: #FFFFFF;font-weight: 100;}
		.footer:link {color: #FF5555;text-decoration: none;}
		.footer:visited {color: #FF5555;text-decoration: none;}
		.footer:hover{color: #55FF55;text-decoration: none;}
		input {filter: progid:DXImageTransform.Microsoft.Gradient(gradientType=1,startColorStr=#C8C8C8,endColorStr=#FFFFFF);background-color: #FFFFFF;font: 11px sans-serif;font-weight: 100;color: #444444;}
		select {filter: progid:DXImageTransform.Microsoft.Gradient(gradientType=1,startColorStr=#C8C8C8,endColorStr=#FFFFFF);background-color: #FFFFFF;font: 11px sans-serif;font-weight: 800;color: #444444;}
	</STYLE>
	<TITLE>IP Unlock</TITLE>
</HEAD>
<BODY topmargin="3" leftmargin="0">

<!--- Content Table --->
<TABLE border="1" width="600" align="center" cellpadding="1" cellspacing="0" class="appTable">
	<TR>
		<TD>
			<TABLE width="100%">
<!--- Page Identity Area --->
				<TR>
					<TD valign="bottom" class="breadCrumbs" height="42" colspan="2">
						&raquo; Malicious IP : Unlock
						<HR size="0.5">
					</TD>
				</TR>

					<FORM method="POST" action="ipBlackListUnlock.cfm" name="form">
							<INPUT class="frmFlds" type="Hidden" name="Save" value="1">
							<CFIF NOT isDefined("APPLICATION.ipBlackList") OR (isDefined("APPLICATION.ipBlackList") AND arrayLen(APPLICATION.ipBlackList) EQ "0")>
								<CFSET VARIABLES.message = "The black list is empty.">
							</CFIF>
							<CFIF ISDEFINED("VARIABLES.message")>
				<TR>
					<TD colspan="2" class="messageArea">
						<IMG src="/images/cf.gif" width="30" height="30" border="0" align="absmiddle">&nbsp;<CFOUTPUT>#VARIABLES.message#</CFOUTPUT>
					</TD>
				</TR>
							</CFIF>
							<CFIF isDefined("APPLICATION.ipBlackList") AND arrayLen(APPLICATION.ipBlackList) GT "0">
								<CFOUTPUT>
				<TR>
					<TD align="right">
								*&nbsp;IP Address:
					</TD>
				<TD>
								<SELECT class="frmFlds" name="ipAddress">
									<CFLOOP from="1" to="#arrayLen(APPLICATION.ipBlackList)#" index="currPosition">
										<OPTION value="#APPLICATION.ipBlackList[currPosition].arrayIp#">#APPLICATION.ipBlackList[currPosition].arrayIp#</OPTION>
									</CFLOOP>
								</SELECT>
					</TD>
				</TR>
								</CFOUTPUT>
				<TR>
					<TD align="center" height="10" colspan="2">
								<HR size="0.5">
								<INPUT type="submit" class="frmbtn" style="filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=scale src='/images/btn_form_save.gif');background-color: transparent;cursor: hand;margin: 0px;padding: 0px;border: 0px 0;width: 103px;height: 27px;" value="&nbsp;&nbsp;&nbsp;Unlock">
					</TD>
				</TR>
							</CFIF>
					</form>
			</TABLE>
		</TD>
	</TR>
</TABLE>