<!-- Last modified by John R. Pastori on 01/31/2008 using ColdFusion Studio:-->
<CFOUTPUT>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="left">
			<a href="/"><img src="/images/lfolksnew.jpg" alt="LFOLKS Intranet Web Site" border="0"></a>
		</td>
	</tr>
</table>

<BR>
<CFIF Client.LoggedIn EQ "Yes">
<table width="100%" border="0" cellspacing="0" cellpadding="2" align="CENTER">
	<tr>
		<td align="LEFT">
			<a href="/#application.type#apps/index.cfm?logout=No&ACCESSINGAPPFIRSTTIME=YES">Home</a>
		</td>
	</tr>
</table>
</CFIF>
</CFOUTPUT>
